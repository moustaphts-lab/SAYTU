
-- ===== Fonctions d'aide (droits) =====
create or replace function public.has_role(r public.app_role)
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (select 1 from public.user_roles ur where ur.user_id = auth.uid() and ur.role = r);
$$;

create or replace function public.current_teacher_id()
returns bigint language sql stable security definer set search_path = '' as $$
  select t.id from public.teachers t where t.profile_id = auth.uid();
$$;

create or replace function public.can_review_department(dept bigint)
returns boolean language sql stable security definer set search_path = '' as $$
  select public.has_role('admin') or exists (
    select 1 from public.user_roles ur
    where ur.user_id = auth.uid() and ur.role = 'responsable'
      and (ur.department_id is null or ur.department_id = dept));
$$;

create or replace function public.is_planner()
returns boolean language sql stable security definer set search_path = '' as $$
  select public.has_role('admin') or public.has_role('planificateur');
$$;

create or replace function public.my_roles()
returns table(role public.app_role, department_id bigint) language sql stable security definer set search_path = '' as $$
  select ur.role, ur.department_id from public.user_roles ur where ur.user_id = auth.uid();
$$;

-- ===== Création automatique du profil à l'inscription =====
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, full_name, email)
  values (new.id, coalesce(new.raw_user_meta_data->>'full_name', new.email), new.email)
  on conflict (id) do nothing;
  update public.teachers set profile_id = new.id where lower(email) = lower(new.email) and profile_id is null;
  return new;
end $$;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

-- ===== Cohérence des séances (prof et groupe tirés de l'affectation) =====
create or replace function public.sync_session_from_assignment()
returns trigger language plpgsql set search_path = '' as $$
begin
  select ta.teacher_id, ta.group_id into new.teacher_id, new.group_id
  from public.teaching_assignments ta where ta.id = new.assignment_id;
  return new;
end $$;
create trigger trg_sync_session before insert or update of assignment_id on public.schedule_sessions
  for each row execute function public.sync_session_from_assignment();

-- Un émargement validé verrouille la séance
create or replace function public.protect_attended_session()
returns trigger language plpgsql set search_path = '' as $$
begin
  if exists (select 1 from public.attendance_records a where a.session_id = old.id and a.status = 'valide')
     and (new.session_date, new.start_time, new.end_time, new.assignment_id) is distinct from
         (old.session_date, old.start_time, old.end_time, old.assignment_id) then
    raise exception 'Séance déjà émargée et validée : modification interdite (passer par une régularisation).';
  end if;
  return new;
end $$;
create trigger trg_protect_session before update on public.schedule_sessions
  for each row execute function public.protect_attended_session();

create or replace function public.prevent_attended_session_delete()
returns trigger language plpgsql set search_path = '' as $$
begin
  if exists (select 1 from public.attendance_records a where a.session_id = old.id) then
    raise exception 'Séance avec émargement : suppression interdite, utiliser le statut « annulée ».';
  end if;
  return old;
end $$;
create trigger trg_no_delete_attended before delete on public.schedule_sessions
  for each row execute function public.prevent_attended_session_delete();

-- ===== Journal d'audit =====
create or replace function public.audit_trigger()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.audit_logs (actor, action, table_name, record_id, old_data, new_data)
  values (auth.uid(), tg_op, tg_table_name,
          coalesce((case when tg_op = 'DELETE' then to_jsonb(old) else to_jsonb(new) end)->>'id', null),
          case when tg_op in ('UPDATE','DELETE') then to_jsonb(old) end,
          case when tg_op in ('INSERT','UPDATE') then to_jsonb(new) end);
  return coalesce(new, old);
end $$;

do $$ declare t text;
begin
  foreach t in array array['attendance_records','schedule_sessions','timetable_slots','teaching_assignments','user_roles','teachers','profiles']
  loop
    execute format('create trigger trg_audit_%1$s after insert or update or delete on public.%1$I for each row execute function public.audit_trigger()', t);
  end loop;
end $$;

-- ===== RLS =====
alter table public.profiles enable row level security;
alter table public.user_roles enable row level security;
alter table public.academic_years enable row level security;
alter table public.semesters enable row level security;
alter table public.departments enable row level security;
alter table public.programs enable row level security;
alter table public.student_groups enable row level security;
alter table public.courses enable row level security;
alter table public.rooms enable row level security;
alter table public.teachers enable row level security;
alter table public.teaching_assignments enable row level security;
alter table public.timetable_slots enable row level security;
alter table public.schedule_sessions enable row level security;
alter table public.attendance_records enable row level security;
alter table public.audit_logs enable row level security;

-- Profils
create policy profiles_select on public.profiles for select to authenticated
  using (id = (select auth.uid()) or exists (select 1 from public.user_roles ur where ur.user_id = (select auth.uid()) and ur.role <> 'professeur'));
create policy profiles_admin on public.profiles for all to authenticated
  using ((select public.has_role('admin'))) with check ((select public.has_role('admin')));

-- Rôles
create policy roles_select on public.user_roles for select to authenticated
  using (user_id = (select auth.uid()) or (select public.has_role('admin')));
create policy roles_admin on public.user_roles for all to authenticated
  using ((select public.has_role('admin'))) with check ((select public.has_role('admin')));

-- Référentiel : lecture pour tous les connectés, écriture admin
do $$ declare t text;
begin
  foreach t in array array['academic_years','semesters','departments','programs','student_groups','courses','rooms','teachers']
  loop
    execute format('create policy %1$s_select on public.%1$I for select to authenticated using (true)', t);
    execute format('create policy %1$s_admin on public.%1$I for all to authenticated using ((select public.has_role(''admin''))) with check ((select public.has_role(''admin'')))', t);
  end loop;
  foreach t in array array['teaching_assignments','timetable_slots','schedule_sessions']
  loop
    execute format('create policy %1$s_select on public.%1$I for select to authenticated using (true)', t);
    execute format('create policy %1$s_planner on public.%1$I for all to authenticated using ((select public.is_planner())) with check ((select public.is_planner()))', t);
  end loop;
end $$;

-- Émargements : lecture seulement ; écriture via fonctions contrôlées
create policy attendance_select on public.attendance_records for select to authenticated
  using (
    teacher_id = (select public.current_teacher_id())
    or (select public.has_role('admin')) or (select public.has_role('finance')) or (select public.has_role('direction'))
    or exists (select 1 from public.schedule_sessions s
               join public.teaching_assignments ta on ta.id = s.assignment_id
               join public.courses c on c.id = ta.course_id
               where s.id = attendance_records.session_id and public.can_review_department(c.department_id))
  );

-- Audit : lecture admin / direction
create policy audit_select on public.audit_logs for select to authenticated
  using ((select public.has_role('admin')) or (select public.has_role('direction')));

-- ===== Émargement par le professeur =====
create or replace function public.submit_attendance(p_session_id bigint, p_start time, p_end time, p_comment text default null)
returns public.attendance_records language plpgsql security definer set search_path = '' as $$
declare
  v_teacher bigint := public.current_teacher_id();
  s public.schedule_sessions;
  r public.attendance_records;
  v_now timestamp := (now() at time zone 'Africa/Dakar');
begin
  if v_teacher is null then raise exception 'Aucun profil professeur associé à ce compte.'; end if;
  select * into s from public.schedule_sessions where id = p_session_id;
  if not found then raise exception 'Séance introuvable.'; end if;
  if s.teacher_id <> v_teacher then raise exception 'Cette séance ne vous est pas attribuée.'; end if;
  if s.status = 'annulee' then raise exception 'Séance annulée : émargement impossible.'; end if;
  if (s.session_date + s.start_time) > v_now then raise exception 'La séance n''a pas encore commencé.'; end if;
  if p_end <= p_start then raise exception 'L''heure de fin doit être après l''heure de début.'; end if;

  select * into r from public.attendance_records where session_id = p_session_id;
  if found then
    if r.status in ('valide','rejete') then
      raise exception 'Émargement déjà traité (%). Demandez une régularisation au responsable.', r.status;
    end if;
    update public.attendance_records set
      declared_start = p_start, declared_end = p_end,
      declared_minutes = (extract(epoch from (p_end - p_start)) / 60)::int,
      teacher_comment = p_comment, status = 'soumis',
      submitted_by = auth.uid(), submitted_at = now(),
      reviewed_by = null, reviewed_at = null
    where id = r.id returning * into r;
  else
    insert into public.attendance_records (session_id, teacher_id, planned_minutes, declared_start, declared_end,
      declared_minutes, teacher_comment, submitted_by)
    values (p_session_id, v_teacher, (extract(epoch from (s.end_time - s.start_time)) / 60)::int, p_start, p_end,
      (extract(epoch from (p_end - p_start)) / 60)::int, p_comment, auth.uid())
    returning * into r;
  end if;
  return r;
end $$;

-- ===== Contrôle par le responsable =====
create or replace function public.review_attendance(p_id bigint, p_decision public.attendance_status,
  p_retained_minutes int default null, p_reason text default null)
returns public.attendance_records language plpgsql security definer set search_path = '' as $$
declare
  r public.attendance_records;
  v_dept bigint;
  v_retained int;
begin
  select * into r from public.attendance_records where id = p_id for update;
  if not found then raise exception 'Émargement introuvable.'; end if;
  select c.department_id into v_dept from public.schedule_sessions s
    join public.teaching_assignments ta on ta.id = s.assignment_id
    join public.courses c on c.id = ta.course_id where s.id = r.session_id;
  if not public.can_review_department(v_dept) then raise exception 'Vous n''êtes pas habilité à contrôler ce département.'; end if;
  if r.teacher_id = public.current_teacher_id() then raise exception 'Contrôle indépendant requis : vous ne pouvez pas valider vos propres heures.'; end if;
  if r.status <> 'soumis' then raise exception 'Seuls les émargements « soumis » peuvent être contrôlés (statut actuel : %).', r.status; end if;
  if r.pay_period_id is not null then raise exception 'Émargement rattaché à une période de paie : régularisation requise.'; end if;
  if p_decision = 'soumis' then raise exception 'Décision invalide.'; end if;
  if p_decision in ('rejete','correction_demandee') and coalesce(trim(p_reason),'') = '' then
    raise exception 'Un motif est obligatoire pour un rejet ou une demande de correction.';
  end if;

  if p_decision = 'valide' then
    v_retained := coalesce(p_retained_minutes, least(r.declared_minutes, r.planned_minutes));
    if v_retained > r.declared_minutes then raise exception 'La durée retenue ne peut pas dépasser la durée déclarée.'; end if;
    if v_retained > r.planned_minutes and coalesce(trim(p_reason),'') = '' then
      raise exception 'Durée retenue supérieure à la durée prévue : motif obligatoire.';
    end if;
    update public.schedule_sessions set status = 'effectuee' where id = r.session_id;
  else
    v_retained := null;
  end if;

  update public.attendance_records set status = p_decision, retained_minutes = v_retained,
    reviewed_by = auth.uid(), reviewed_at = now(), review_reason = nullif(trim(p_reason),'')
  where id = p_id returning * into r;
  return r;
end $$;

-- ===== Génération des séances datées à partir des créneaux publiés =====
create or replace function public.generate_sessions(p_from date, p_to date)
returns table(created int, conflicts jsonb) language plpgsql security definer set search_path = '' as $$
declare
  sl record; d date; v_created int := 0; v_conf jsonb := '[]'::jsonb;
begin
  if not public.is_planner() then raise exception 'Réservé aux responsables des emplois du temps.'; end if;
  if p_to < p_from or p_to - p_from > 200 then raise exception 'Intervalle de dates invalide.'; end if;
  for sl in select ts.*, sem.start_date sem_start, sem.end_date sem_end
            from public.timetable_slots ts
            join public.teaching_assignments ta on ta.id = ts.assignment_id
            join public.semesters sem on sem.id = ta.semester_id
            where ts.published loop
    for d in select g::date from generate_series(greatest(p_from, sl.sem_start), least(p_to, sl.sem_end), interval '1 day') g
             where extract(isodow from g) = sl.day_of_week loop
      if exists (select 1 from public.schedule_sessions x where x.slot_id = sl.id and x.session_date = d) then continue; end if;
      begin
        insert into public.schedule_sessions (assignment_id, slot_id, teacher_id, group_id, room_id, session_date, start_time, end_time)
        values (sl.assignment_id, sl.id, 0, 0, sl.room_id, d, sl.start_time, sl.end_time);
        v_created := v_created + 1;
      exception when exclusion_violation then
        v_conf := v_conf || jsonb_build_object('slot_id', sl.id, 'date', d);
      end;
    end loop;
  end loop;
  return query select v_created, v_conf;
end $$;

-- ===== Conflits entre créneaux hebdomadaires =====
create or replace view public.slot_conflicts with (security_invoker = true) as
select a.id slot_a, b.id slot_b, a.day_of_week,
  case when a.room_id = b.room_id then 'salle'
       when ta.teacher_id = tb.teacher_id then 'professeur'
       else 'groupe' end as conflict_type
from public.timetable_slots a
join public.timetable_slots b on a.id < b.id and a.day_of_week = b.day_of_week
  and a.start_time < b.end_time and b.start_time < a.end_time
join public.teaching_assignments ta on ta.id = a.assignment_id
join public.teaching_assignments tb on tb.id = b.assignment_id and tb.semester_id = ta.semester_id
where a.room_id = b.room_id or ta.teacher_id = tb.teacher_id or ta.group_id = tb.group_id;

-- Droits d'exécution
revoke execute on function public.submit_attendance, public.review_attendance, public.generate_sessions from public, anon;
grant execute on function public.submit_attendance, public.review_attendance, public.generate_sessions, public.my_roles to authenticated;
revoke execute on function public.handle_new_user, public.audit_trigger from public, anon, authenticated;
