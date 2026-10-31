create or replace function public.slot_follow_up()
returns trigger language plpgsql security definer set search_path to '' as $function$
declare v_date date; v_sid bigint; v_att boolean;
begin
  if tg_op = 'DELETE' then
    delete from public.schedule_sessions s
     where s.slot_id = old.id and not exists (select 1 from public.attendance_records a where a.session_id = s.id);
    return old;
  end if;
  select s.id, exists (select 1 from public.attendance_records a where a.session_id = s.id)
    into v_sid, v_att from public.schedule_sessions s where s.slot_id = new.id limit 1;
  if not new.published then
    if v_sid is not null and not v_att then delete from public.schedule_sessions where id = v_sid; end if;
    return new;
  end if;
  v_date := new.week_start + (new.day_of_week - 1);
  if v_sid is null then
    insert into public.schedule_sessions (assignment_id, slot_id, teacher_id, group_id, room_id, session_date, start_time, end_time)
    values (new.assignment_id, new.id, 0, 0, new.room_id, v_date, new.start_time, new.end_time);
  elsif not v_att then
    update public.schedule_sessions
       set assignment_id = new.assignment_id, room_id = new.room_id, session_date = v_date,
           start_time = new.start_time, end_time = new.end_time
     where id = v_sid
       and (assignment_id, room_id, session_date, start_time, end_time) is distinct from (new.assignment_id, new.room_id, v_date, new.start_time, new.end_time);
  end if;
  return new;
end $function$;
create trigger trg_slot_follow_ins after insert on public.timetable_slots for each row execute function public.slot_follow_up();

create or replace function public.publish_week(p_week date)
returns integer language plpgsql security definer set search_path to '' as $$
declare n int;
begin
  if not public.is_planner() then raise exception 'Réservé au directeur des études.'; end if;
  if p_week is null or extract(isodow from p_week) <> 1 then raise exception 'Semaine invalide.'; end if;
  insert into public.published_weeks(week_start) values (p_week)
    on conflict (week_start) do update set published_at = now(), published_by = auth.uid();
  update public.timetable_slots set published = true where week_start = p_week and not published;
  get diagnostics n = row_count;
  return n;
end $$;
