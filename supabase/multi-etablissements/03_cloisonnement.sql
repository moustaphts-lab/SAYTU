-- Étape 3 : cloisonnement par établissement (règles d'accès et fonctions).
-- (DLT et DRP remplacent deux mots-clés SQL ; le texte est exécuté après remplacement.)

-- 1. Fonctions d'identité et de droits : seulement dans l'établissement de travail
create or replace function public.current_teacher_id() returns bigint
language sql stable security definer set search_path='' as $$
  select t.id from public.teachers t where t.profile_id = auth.uid() and t.establishment_id = public.current_establishment() $$;

create or replace function public.is_finance_for(fac bigint) returns boolean
language sql stable security definer set search_path='' as $$
  select fac is not null and exists (select 1 from public.user_roles ur where ur.user_id = auth.uid() and ur.role = 'finance'
    and ur.faculty_id = fac and ur.establishment_id = public.current_establishment()) $$;

create or replace function public.is_cashier_for(fac bigint) returns boolean
language sql stable security definer set search_path='' as $$
  select fac is not null and exists (select 1 from public.user_roles ur where ur.user_id = auth.uid() and ur.role = 'caissier'
    and ur.faculty_id = fac and ur.establishment_id = public.current_establishment()) $$;

create or replace function public.can_review_department(dept bigint) returns boolean
language sql stable security definer set search_path='' as $$
  select exists (select 1 from public.user_roles ur join public.departments d on d.id = dept and d.establishment_id = ur.establishment_id
    where ur.user_id = auth.uid() and ur.establishment_id = public.current_establishment()
      and ((ur.role = 'responsable' and (ur.department_id = dept or (ur.department_id is null and (ur.faculty_id is null or ur.faculty_id = d.faculty_id))))
        or (ur.role = 'chef_departement' and ur.department_id = dept))) $$;

-- 2. Fonctions qui supposaient un seul établissement
create or replace function public.set_current_year(p_year bigint) returns void
language plpgsql security definer set search_path='' as $$
declare et bigint := public.current_establishment();
begin
  if not (public.is_central_admin() or public.has_role_for('planificateur', null)) then raise exception 'Action non autorisée.'; end if;
  if not exists (select 1 from public.academic_years where id = p_year and establishment_id = et) then raise exception 'Année introuvable.'; end if;
  update public.academic_years set is_current = (id = p_year) where establishment_id = et;
end $$;

create or replace function public.admin_set_rights(p_rights text[]) returns void
language plpgsql security definer set search_path='' as $$
begin
  if not public.is_central_admin() then raise exception 'Réservé à l''administrateur.'; end if;
  update public.app_settings set enabled_rights = coalesce(p_rights,'{}') where establishment_id = public.current_establishment();
end $$;

create or replace function public.closure_for_faculty(p_date date, p_start time, p_end time, p_faculty bigint) returns text
language sql stable security definer set search_path='' as $$
  select c.label from public.calendar_closures c
    join public.faculties f on f.id = p_faculty
    left join public.school_schedule sc on sc.faculty_id = p_faculty
  where p_date between c.date_from and c.date_to
    and (c.faculty_id = p_faculty or (c.faculty_id is null and c.establishment_id = f.establishment_id))
    and (c.part = 'jour' or (c.part = 'matin' and p_start < coalesce(sc.lunch_start,'13:00')) or (c.part = 'apres_midi' and p_end > coalesce(sc.lunch_end,'13:00')))
  order by c.id limit 1 $$;

-- ancienne version sans faculté : jours communs de l'établissement de travail
create or replace function public.closure_for(p_date date, p_start time, p_end time) returns text
language sql stable security definer set search_path='' as $$
  select c.label from public.calendar_closures c
  where p_date between c.date_from and c.date_to and c.faculty_id is null and c.establishment_id = public.current_establishment()
    and (c.part = 'jour' or (c.part = 'matin' and p_start < '13:00') or (c.part = 'apres_midi' and p_end > '13:00'))
  order by c.id limit 1 $$;

create or replace function public.keep_one_admin() returns trigger
language plpgsql security definer set search_path='' as $$
begin
  if old.role = 'admin' and not exists (
      select 1 from public.user_roles where role = 'admin' and id <> old.id and establishment_id = old.establishment_id) then
    raise exception 'Il doit rester au moins un administrateur.';
  end if;
  return old;
end $$;

create or replace function public.admin_departure_check(p_user uuid) returns jsonb
language plpgsql security definer set search_path='' as $$
declare v_t bigint; n int; d date;
begin
  if not public.can_manage_user(p_user) then raise exception 'Réservé à l''administrateur.'; end if;
  select id into v_t from public.teachers where profile_id = p_user and establishment_id = public.current_establishment();
  if v_t is null then return jsonb_build_object('sessions',0); end if;
  select count(*), min(session_date) into n, d from public.schedule_sessions
   where teacher_id = v_t and session_date >= current_date and status <> 'annulee';
  return jsonb_build_object('sessions', n, 'next', d,
    'assignments', (select count(*) from public.teaching_assignments ta join public.semesters s on s.id = ta.semester_id where ta.teacher_id = v_t and s.end_date >= current_date));
end $$;

-- sauvegarde Excel : uniquement les données de l'établissement de travail
create or replace function public.admin_backup() returns jsonb
language plpgsql security definer set search_path='' as $$
declare t text; r jsonb := '{}'::jsonb; v jsonb; full_ boolean; et bigint := public.current_establishment(); w text;
  pay text[] := array['hourly_rates','pay_periods','payments','payroll_items','payslips'];
  facs text := '(select id from public.faculties where establishment_id = $1)';
begin
  if not public.is_central_admin() then raise exception 'Réservé à l''administrateur.'; end if;
  full_ := public.has_role('finance') or public.has_role('direction');
  foreach t in array array['app_settings','faculties','postes','academic_years','semesters','departments','programs','student_groups','rooms','courses','course_programs',
    'teacher_statuses','teachers','profiles','memberships','user_roles','teaching_assignments','assignment_groups','school_schedule','calendar_closures',
    'teacher_availability','availability_weeks','timetable_slots','published_weeks','schedule_sessions','attendance_records','announcements',
    'hourly_rates','pay_periods','payroll_items','payslips','payments','audit_logs'] loop
    if t = any(pay) and not full_ then continue; end if;
    w := case
      when t in ('app_settings','faculties','postes','academic_years','departments','programs','student_groups','courses','teacher_statuses',
                 'teachers','memberships','user_roles','calendar_closures','announcements','payslips','audit_logs') then 'x.establishment_id = $1'
      when t in ('semesters','rooms','school_schedule','published_weeks','pay_periods','hourly_rates') then 'x.faculty_id in ' || facs
      when t = 'profiles' then 'x.id in (select user_id from public.memberships where establishment_id = $1)'
      when t in ('course_programs','teaching_assignments') then 'x.course_id in (select id from public.courses where establishment_id = $1)'
      when t in ('assignment_groups','timetable_slots','schedule_sessions') then 'public.faculty_of_assignment(x.assignment_id) in ' || facs
      when t in ('teacher_availability','availability_weeks') then 'x.teacher_id in (select id from public.teachers where establishment_id = $1)'
      when t = 'attendance_records' then 'public.fac_of_session(x.session_id) in ' || facs
      when t = 'payroll_items' then 'public.fac_of_period(x.pay_period_id) in ' || facs
      when t = 'payments' then 'x.payslip_id in (select id from public.payslips where establishment_id = $1)'
      else 'false' end;
    if t = 'audit_logs' and not full_ then w := w || ' and not (x.table_name = any($2))'; end if;
    execute format('select coalesce(jsonb_agg(to_jsonb(x)),''[]'') from public.%I x where %s', t, w) into v using et, pay;
    r := r || jsonb_build_object(t, v);
  end loop;
  return jsonb_build_object('full', full_, 'tables', r);
end $$;

-- 3. Règles d'accès des tables propres à l'établissement
DRP policy if exists academic_years_select on public.academic_years;
DRP policy if exists academic_years_write on public.academic_years;
create policy academic_years_select on public.academic_years for select to authenticated
  using (establishment_id = (select public.current_establishment()));
create policy academic_years_write on public.academic_years for all to authenticated
  using (establishment_id = (select public.current_establishment()) and ((select public.is_central_admin()) or (select public.has_role_for('planificateur', null))))
  with check (establishment_id = (select public.current_establishment()) and ((select public.is_central_admin()) or (select public.has_role_for('planificateur', null))));

DRP policy if exists app_settings_select on public.app_settings;
DRP policy if exists app_settings_update on public.app_settings;
create policy app_settings_select on public.app_settings for select to authenticated
  using (establishment_id = (select public.current_establishment()));
-- écran de connexion (sans compte) : l'identité n'est montrée que tant qu'il n'existe qu'un établissement
create policy app_settings_select_anon on public.app_settings for select to anon
  using ((select count(*) from public.establishments) = 1);
create policy app_settings_update on public.app_settings for update to authenticated
  using (establishment_id = (select public.current_establishment()) and (select public.is_central_admin()))
  with check (establishment_id = (select public.current_establishment()) and (select public.is_central_admin()));

DRP policy if exists postes_select on public.postes;
create policy postes_select on public.postes for select to authenticated
  using (establishment_id = (select public.current_establishment()));

DRP policy if exists ts_select on public.teacher_statuses;
DRP policy if exists ts_write on public.teacher_statuses;
create policy ts_select on public.teacher_statuses for select to authenticated
  using (establishment_id = (select public.current_establishment()));
create policy ts_write on public.teacher_statuses for all to authenticated
  using (establishment_id = (select public.current_establishment()) and (select public.is_planner()))
  with check (establishment_id = (select public.current_establishment()) and (select public.is_planner()));

DRP policy if exists faculties_admin on public.faculties;
create policy faculties_admin on public.faculties for all to authenticated
  using (establishment_id = (select public.current_establishment()) and (select public.is_central_admin()))
  with check (establishment_id = (select public.current_establishment()) and (select public.is_central_admin()));

DRP policy if exists announcements_select on public.announcements;
DRP policy if exists announcements_write on public.announcements;
create policy announcements_select on public.announcements for select to authenticated
  using (establishment_id = (select public.current_establishment()) and (faculty_id is null or (select public.sees_fac(announcements.faculty_id))
         or faculty_id = (select public.fac_of_teacher(public.current_teacher_id()))));
create policy announcements_write on public.announcements for all to authenticated
  using (establishment_id = (select public.current_establishment()) and case when faculty_id is null then (select public.is_central_admin())
         else ((select public.is_planner_for(announcements.faculty_id)) or (select public.admin_for(announcements.faculty_id))) end)
  with check (establishment_id = (select public.current_establishment()) and case when faculty_id is null then (select public.is_central_admin())
         else ((select public.is_planner_for(announcements.faculty_id)) or (select public.admin_for(announcements.faculty_id))) end);

DRP policy if exists calendar_closures_select on public.calendar_closures;
DRP policy if exists calendar_closures_write on public.calendar_closures;
create policy calendar_closures_select on public.calendar_closures for select to authenticated
  using (establishment_id = (select public.current_establishment()) and (faculty_id is null or (select public.sees_fac(calendar_closures.faculty_id))
         or faculty_id = (select public.fac_of_teacher(public.current_teacher_id()))));
create policy calendar_closures_write on public.calendar_closures for all to authenticated
  using (establishment_id = (select public.current_establishment()) and case when faculty_id is null
         then ((select public.is_central_admin()) or (select public.has_role_for('planificateur', null)))
         else (select public.is_planner_for(calendar_closures.faculty_id)) end)
  with check (establishment_id = (select public.current_establishment()) and case when faculty_id is null
         then ((select public.is_central_admin()) or (select public.has_role_for('planificateur', null)))
         else (select public.is_planner_for(calendar_closures.faculty_id)) end);

DRP policy if exists roles_admin on public.user_roles;
DRP policy if exists roles_select on public.user_roles;
create policy roles_select on public.user_roles for select to authenticated
  using (user_id = (select auth.uid()) or (establishment_id = (select public.current_establishment()) and (select public.can_manage_user(user_roles.user_id))));
create policy roles_admin on public.user_roles for all to authenticated
  using (establishment_id = (select public.current_establishment()) and (select public.can_manage_user(user_roles.user_id)))
  with check (establishment_id = (select public.current_establishment()) and (select public.can_manage_user(user_roles.user_id))
              and ((select public.is_central_admin()) or (faculty_id is not null and (select public.admin_for(user_roles.faculty_id)))));

-- 4. Fonctions longues : modifications ciblées du texte existant (chaque morceau doit être trouvé)
do $f$
declare d text; fx record; pairs text[]; k int;
begin
  for fx in select * from (values
    ('public.compare_faculties(date,date)'::regprocedure, array[
      $a$and ur.role in ('direction','lecteur','finance') and ur.faculty_id is null)$a$,
      $a$and ur.role in ('direction','lecteur','finance') and ur.faculty_id is null and ur.establishment_id = public.current_establishment())$a$,
      $a$from public.academic_years where p_to between start_date and end_date$a$,
      $a$from public.academic_years where establishment_id = public.current_establishment() and p_to between start_date and end_date$a$,
      $a$from public.academic_years where is_current limit 1$a$,
      $a$from public.academic_years where is_current and establishment_id = public.current_establishment() limit 1$a$,
      $a$from public.faculties f),$a$,
      $a$from public.faculties f where f.establishment_id = public.current_establishment()),$a$]),
    ('public.cancel_for_closure(bigint,bigint)'::regprocedure, array[
      $a$if not found then raise exception 'Jour sans cours introuvable.'; end if;$a$,
      $a$if not found or c.establishment_id <> public.current_establishment() then raise exception 'Jour sans cours introuvable.'; end if;$a$,
      $a$and (p_fac is null or public.faculty_of_assignment(ts.assignment_id) = p_fac)$a$,
      $a$and (p_fac is null or public.faculty_of_assignment(ts.assignment_id) = p_fac)
    and public.faculty_of_assignment(ts.assignment_id) in (select f.id from public.faculties f where f.establishment_id = c.establishment_id)$a$]),
    ('public.new_academic_year(text,date,date,jsonb,boolean,boolean)'::regprocedure, array[
      $a$where label = p_label)$a$,
      $a$where label = p_label and establishment_id = public.current_establishment())$a$,
      $a$(select id from public.faculties order by sort, id limit 1)$a$,
      $a$(select id from public.faculties where establishment_id = public.current_establishment() order by sort, id limit 1)$a$,
      $a$    insert into public.semesters(academic_year_id$a$,
      $a$    if not exists (select 1 from public.faculties where id = f and establishment_id = public.current_establishment()) then raise exception 'Faculté introuvable.'; end if;
    insert into public.semesters(academic_year_id$a$,
      $a$where ta.semester_id = (s->>'from')::bigint and$a$,
      $a$where ta.semester_id = (s->>'from')::bigint
                 and exists (select 1 from public.semesters ss join public.faculties ff on ff.id = ss.faculty_id where ss.id = (s->>'from')::bigint and ff.establishment_id = public.current_establishment()) and$a$,
      $a$if p_current then update public.academic_years set is_current = (id = y); end if;$a$,
      $a$if p_current then update public.academic_years set is_current = (id = y) where establishment_id = public.current_establishment(); end if;$a$])
  ) v(fn, p) loop
    d := pg_get_functiondef(fx.fn); pairs := fx.p;
    for k in 1 .. array_length(pairs,1) by 2 loop
      if position(pairs[k] in d) = 0 then raise exception '% : morceau introuvable : %', fx.fn, left(pairs[k],60); end if;
      d := replace(d, pairs[k], pairs[k+1]);
    end loop;
    execute d;
  end loop;
end $f$;
