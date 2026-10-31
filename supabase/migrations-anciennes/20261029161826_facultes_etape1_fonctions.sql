
create or replace function public.faculty_of_assignment(p_asg bigint) returns bigint
language sql stable security definer set search_path to '' as $$
  select d.faculty_id from public.teaching_assignments ta join public.courses c on c.id = ta.course_id join public.departments d on d.id = c.department_id where ta.id = p_asg $$;

create or replace function public.closure_for_faculty(p_date date, p_start time, p_end time, p_faculty bigint) returns text
language sql stable security definer set search_path to '' as $$
  select c.label from public.calendar_closures c
    left join public.school_schedule sc on sc.faculty_id = p_faculty
  where p_date between c.date_from and c.date_to and (c.faculty_id is null or c.faculty_id = p_faculty)
    and (c.part = 'jour' or (c.part = 'matin' and p_start < coalesce(sc.lunch_start,'13:00')) or (c.part = 'apres_midi' and p_end > coalesce(sc.lunch_end,'13:00')))
  order by c.id limit 1 $$;

create or replace function public.check_slot_closure() returns trigger
language plpgsql security definer set search_path to '' as $$
declare v text; d date;
begin
  if tg_op = 'UPDATE' and new.day_of_week = old.day_of_week and new.start_time = old.start_time and new.end_time = old.end_time and new.week_start = old.week_start then return new; end if;
  d := new.week_start + (new.day_of_week - 1);
  v := public.closure_for_faculty(d, new.start_time, new.end_time, public.faculty_of_assignment(new.assignment_id));
  if v is not null then raise exception 'Pas de cours le % à cette heure : %.', to_char(d,'DD/MM/YYYY'), v; end if;
  return new;
end $$;

-- une nouvelle faculté reçoit des jours et horaires par défaut (copie de la première)
create or replace function public.faculty_defaults() returns trigger
language plpgsql security definer set search_path to '' as $$
begin
  insert into public.school_schedule(id, faculty_id, days, day_start, day_end, slot_minutes, lunch_start, lunch_end, group_max_hours, teacher_max_hours)
  select (select coalesce(max(id),0)+1 from public.school_schedule), new.id, days, day_start, day_end, slot_minutes, lunch_start, lunch_end, group_max_hours, teacher_max_hours
    from public.school_schedule order by id limit 1;
  if not found then insert into public.school_schedule(id, faculty_id, days, day_start, day_end, slot_minutes) values ((select coalesce(max(id),0)+1 from public.school_schedule), new.id, '{1,2,3,4,5}', '08:00', '18:00', 120); end if;
  return new;
end $$;
create trigger trg_faculty_defaults after insert on public.faculties for each row execute function public.faculty_defaults();

-- nouvelle année : chaque semestre appartient à une faculté
create or replace function public.new_academic_year(p_label text, p_start date, p_end date, p_sems jsonb, p_copy boolean, p_current boolean) returns jsonb
language plpgsql security definer set search_path to '' as $$
declare y bigint; s jsonb; ns bigint; a record; na bigint; n int := 0; f bigint;
begin
  if not (public.has_role('admin') or public.is_planner()) then raise exception 'Action non autorisée.'; end if;
  if exists (select 1 from public.academic_years where label = p_label) then raise exception 'L''année % existe déjà.', p_label; end if;
  if p_end <= p_start then raise exception 'La fin de l''année doit être après son début.'; end if;
  insert into public.academic_years(label,start_date,end_date,is_current) values (p_label,p_start,p_end,false) returning id into y;
  for s in select * from jsonb_array_elements(p_sems) loop
    if (s->>'start')::date < p_start or (s->>'end')::date > p_end or (s->>'end')::date <= (s->>'start')::date then
      raise exception 'Les dates du semestre « % » doivent être comprises dans l''année.', s->>'label'; end if;
    f := coalesce(nullif(s->>'faculty','')::bigint, (select faculty_id from public.semesters where id = nullif(s->>'from','')::bigint), (select id from public.faculties order by sort, id limit 1));
    insert into public.semesters(academic_year_id,faculty_id,label,start_date,end_date) values (y, f, s->>'label', (s->>'start')::date, (s->>'end')::date) returning id into ns;
    if p_copy and nullif(s->>'from','') is not null then
      for a in select ta.* from public.teaching_assignments ta join public.teachers t on t.id = ta.teacher_id
               where ta.semester_id = (s->>'from')::bigint and coalesce(t.active,true) loop
        insert into public.teaching_assignments(semester_id,teacher_id,course_id,group_id,planned_hours)
          values (ns,a.teacher_id,a.course_id,a.group_id,a.planned_hours) returning id into na;
        insert into public.assignment_groups(assignment_id,group_id)
          select na, ag.group_id from public.assignment_groups ag where ag.assignment_id = a.id on conflict do nothing;
        n := n + 1;
      end loop;
    end if;
  end loop;
  if p_current then update public.academic_years set is_current = (id = y); end if;
  return jsonb_build_object('year', y, 'copied', n);
end $$;

