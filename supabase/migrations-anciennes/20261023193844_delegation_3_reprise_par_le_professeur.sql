create or replace function public.submit_attendance(p_session_id bigint, p_start time, p_end time, p_comment text default null)
returns public.attendance_records
language plpgsql security definer set search_path = '' as $$
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
      submitted_by = auth.uid(), submitted_at = now(), entered_for_teacher = false,
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
