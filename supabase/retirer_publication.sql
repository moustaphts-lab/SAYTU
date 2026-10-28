-- UCAB Touba : « Retirer la publication » d'une semaine (à exécuter UNE fois dans Supabase > SQL Editor)
-- Possible tant qu'aucune séance de la semaine n'a été émargée. Les cours repassent en brouillon,
-- les séances (non émargées) sont retirées et les professeurs peuvent de nouveau modifier leurs disponibilités.
create or replace function public.unpublish_week(p_week date)
returns integer language plpgsql security definer set search_path to '' as $$
declare n int; v_list text;
begin
  if not public.is_planner() then raise exception 'Réservé au directeur des études.'; end if;
  if not exists (select 1 from public.published_weeks where week_start = p_week) then raise exception 'Cette semaine n''est pas publiée.'; end if;
  select string_agg(distinct c.code || ' (' || to_char(ss.session_date,'DD/MM') || ')', ', ') into v_list
    from public.schedule_sessions ss
    join public.attendance_records ar on ar.session_id = ss.id
    join public.teaching_assignments ta on ta.id = ss.assignment_id
    join public.courses c on c.id = ta.course_id
   where ss.session_date between p_week and p_week + 6;
  if v_list is not null then
    raise exception 'Impossible de retirer la publication : des séances sont déjà émargées (%). Annulez ou reportez plutôt les autres cours un par un.', v_list;
  end if;
  delete from public.published_weeks where week_start = p_week;
  update public.timetable_slots set published = false where week_start = p_week and published;
  get diagnostics n = row_count;
  return n;
end $$;
revoke all on function public.unpublish_week(date) from public, anon;
grant execute on function public.unpublish_week(date) to authenticated;
