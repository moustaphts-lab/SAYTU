create table public.no_class_days (
  id bigint generated always as identity primary key,
  start_date date not null,
  end_date date not null,
  label text not null check (length(btrim(label)) > 0),
  created_at timestamptz not null default now(),
  constraint ncd_order check (end_date >= start_date),
  constraint ncd_len check (end_date - start_date <= 60)
);
alter table public.no_class_days enable row level security;
create policy ncd_select on public.no_class_days for select to authenticated using (true);
create policy ncd_insert on public.no_class_days for insert to authenticated with check ((select public.is_planner()));
create policy ncd_update on public.no_class_days for update to authenticated using ((select public.is_planner())) with check ((select public.is_planner()));
create policy ncd_delete on public.no_class_days for delete to authenticated using ((select public.is_planner()));
create trigger trg_audit_no_class_days after insert or update or delete on public.no_class_days for each row execute function public.audit_trigger();

create or replace function public.generate_sessions(p_from date, p_to date)
returns table(created integer, conflicts jsonb)
language plpgsql security definer set search_path to '' as $function$
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
             where extract(isodow from g) = sl.day_of_week
               and not exists (select 1 from public.no_class_days n where g::date between n.start_date and n.end_date) loop
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
end $function$;
