
create or replace function public.slot_follow_up()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if tg_op = 'DELETE' then
    delete from public.schedule_sessions s
    where s.slot_id = old.id and s.session_date >= current_date
      and not exists (select 1 from public.attendance_records a where a.session_id = s.id);
    return old;
  end if;
  if old.day_of_week <> new.day_of_week then
    -- le jour change : les séances futures sont supprimées puis recréées par « Créer les séances »
    delete from public.schedule_sessions s
    where s.slot_id = new.id and s.session_date >= current_date
      and not exists (select 1 from public.attendance_records a where a.session_id = s.id);
    return new;
  end if;
  update public.schedule_sessions s
  set start_time = new.start_time, end_time = new.end_time, room_id = new.room_id
  where s.slot_id = new.id and s.session_date >= current_date and s.status = 'planifiee'
    and not exists (select 1 from public.attendance_records a where a.session_id = s.id)
    and (s.start_time, s.end_time, s.room_id) is distinct from (new.start_time, new.end_time, new.room_id);
  return new;
end $$;
