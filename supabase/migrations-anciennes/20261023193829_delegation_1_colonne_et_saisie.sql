alter table public.attendance_records add column if not exists entered_for_teacher boolean not null default false;

create or replace function public.submit_attendance_for(p_session_id bigint, p_start time, p_end time, p_comment text default null)
returns public.attendance_records
language plpgsql security definer set search_path = '' as $$
declare
  s public.schedule_sessions;
  r public.attendance_records;
  v_dept bigint;
  v_now timestamp := (now() at time zone 'Africa/Dakar');
begin
  select * into s from public.schedule_sessions where id = p_session_id;
  if not found then raise exception 'Séance introuvable.'; end if;
  select c.department_id into v_dept from public.teaching_assignments ta
    join public.courses c on c.id = ta.course_id where ta.id = s.assignment_id;
  if not public.can_review_department(v_dept) then raise exception 'Vous n''êtes pas habilité à saisir pour ce département.'; end if;
  if s.teacher_id = public.current_teacher_id() then raise exception 'Vous ne pouvez pas saisir vos propres heures à ce titre : émargez vous-même.'; end if;
  if s.status = 'annulee' then raise exception 'Séance annulée : émargement impossible.'; end if;
  if (s.session_date + s.start_time) > v_now then raise exception 'La séance n''a pas encore commencé.'; end if;
  if p_end <= p_start then raise exception 'L''heure de fin doit être après l''heure de début.'; end if;
  if coalesce(trim(p_comment),'') = '' then raise exception 'Indiquez la source de la saisie (ex. fiche de cours n°…).'; end if;

  select * into r from public.attendance_records where session_id = p_session_id;
  if found then
    raise exception 'Cette séance a déjà un émargement (%).', r.status;
  end if;
  insert into public.attendance_records (session_id, teacher_id, planned_minutes, declared_start, declared_end,
    declared_minutes, teacher_comment, submitted_by, entered_for_teacher)
  values (p_session_id, s.teacher_id, (extract(epoch from (s.end_time - s.start_time)) / 60)::int, p_start, p_end,
    (extract(epoch from (p_end - p_start)) / 60)::int, p_comment, auth.uid(), true)
  returning * into r;
  return r;
end $$;
revoke all on function public.submit_attendance_for(bigint,time,time,text) from public, anon;
grant execute on function public.submit_attendance_for(bigint,time,time,text) to authenticated;
