-- Change le professeur d'une affectation. Les séances à venir non émargées passent au nouveau professeur ;
-- les séances passées ou émargées restent au nom de celui qui les a faites.
create or replace function public.change_assignment_teacher(p_assignment bigint, p_teacher bigint)
returns integer language plpgsql security definer set search_path to '' as $$
declare n int; a record; o record;
begin
  if not public.is_planner() then raise exception 'Réservé au directeur des études.'; end if;
  select * into a from public.teaching_assignments where id = p_assignment;
  if a.id is null then raise exception 'Affectation introuvable.'; end if;
  if not exists (select 1 from public.teachers where id = p_teacher and active) then raise exception 'Professeur introuvable ou inactif.'; end if;
  -- le nouveau professeur ne doit pas déjà avoir cours au même moment sur un créneau de cette affectation
  for o in
    select s.week_start, s.day_of_week, s.start_time, c.code
      from public.timetable_slots s
      join public.timetable_slots x on x.week_start = s.week_start and x.day_of_week = s.day_of_week
           and x.start_time < s.end_time and s.start_time < x.end_time and x.id <> s.id
      join public.teaching_assignments tx on tx.id = x.assignment_id and tx.teacher_id = p_teacher
      join public.courses c on c.id = tx.course_id
     where s.assignment_id = p_assignment
       and s.week_start + (s.day_of_week - 1) >= current_date
     limit 1
  loop
    raise exception 'Le nouveau professeur a déjà cours (%) le % à % : déplacez d''abord ce créneau.',
      o.code, to_char(o.week_start + (o.day_of_week - 1),'DD/MM/YYYY'), to_char(o.start_time,'HH24:MI');
  end loop;
  update public.teaching_assignments set teacher_id = p_teacher where id = p_assignment;
  update public.schedule_sessions s set teacher_id = p_teacher
   where s.assignment_id = p_assignment and s.session_date >= current_date
     and not exists (select 1 from public.attendance_records r where r.session_id = s.id);
  get diagnostics n = row_count;
  return n;
end $$;
