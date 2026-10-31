
create or replace function public.check_slot()
returns trigger language plpgsql security definer set search_path = '' as $$
declare a public.teaching_assignments; o record; v_cap int; v_size int; v_room text;
begin
  select * into a from public.teaching_assignments where id = new.assignment_id;
  select capacity, code into v_cap, v_room from public.rooms where id = new.room_id;
  select size into v_size from public.student_groups where id = a.group_id;
  if v_size > v_cap then
    raise exception 'La salle % (% places) est trop petite pour ce groupe (% étudiants).', v_room, v_cap, v_size;
  end if;
  for o in
    select s.id, s.room_id, ta.teacher_id, ta.group_id, c.code course, s.start_time, s.end_time
    from public.timetable_slots s
    join public.teaching_assignments ta on ta.id = s.assignment_id
    join public.courses c on c.id = ta.course_id
    where ta.semester_id = a.semester_id and s.day_of_week = new.day_of_week
      and s.start_time < new.end_time and new.start_time < s.end_time
      and s.id is distinct from new.id
      and (s.room_id = new.room_id or ta.teacher_id = a.teacher_id or ta.group_id = a.group_id)
    limit 1
  loop
    raise exception 'Conflit avec % (de % à %) : %.', o.course, to_char(o.start_time,'HH24:MI'), to_char(o.end_time,'HH24:MI'),
      case when o.room_id = new.room_id then 'la salle est déjà occupée'
           when o.teacher_id = a.teacher_id then 'le professeur a déjà un cours' else 'le groupe a déjà un cours' end;
  end loop;
  return new;
end $$;
