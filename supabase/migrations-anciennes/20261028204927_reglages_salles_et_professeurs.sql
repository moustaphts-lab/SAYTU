alter table public.courses add column room_type text check (room_type is null or room_type in ('standard','labo','amphi','informatique'));
alter table public.student_groups add column home_room_id bigint references public.rooms(id) on delete set null;
alter table public.school_schedule add column teacher_max_hours numeric not null default 6 check (teacher_max_hours between 1 and 12);
alter table public.rooms drop constraint if exists rooms_room_type_check;

create or replace function public.check_slot()
returns trigger language plpgsql security definer set search_path to '' as $function$
declare a public.teaching_assignments; o record; v_cap int; v_size int; v_room text; v_rtype text; v_need text; v_date date; v_s date; v_e date; v_groups bigint[];
begin
  select * into a from public.teaching_assignments where id = new.assignment_id;
  v_groups := public.asg_groups(a.id);
  if extract(isodow from new.week_start) <> 1 then raise exception 'La semaine doit commencer un lundi.'; end if;
  v_date := new.week_start + (new.day_of_week - 1);
  select start_date, end_date into v_s, v_e from public.semesters where id = a.semester_id;
  if v_date < v_s or v_date > v_e then
    raise exception 'Le % est en dehors du semestre de ce cours (du % au %).', to_char(v_date,'DD/MM/YYYY'), to_char(v_s,'DD/MM/YYYY'), to_char(v_e,'DD/MM/YYYY');
  end if;
  select capacity, code, room_type into v_cap, v_room, v_rtype from public.rooms where id = new.room_id;
  select room_type into v_need from public.courses where id = a.course_id;
  if v_need is not null and v_need <> coalesce(v_rtype,'standard') then
    raise exception 'Cette matière demande une salle de type « % » : la salle % ne convient pas.',
      case v_need when 'labo' then 'laboratoire' when 'amphi' then 'amphithéâtre' when 'informatique' then 'salle informatique' else v_need end, v_room;
  end if;
  select coalesce(sum(size),0) into v_size from public.student_groups where id = any(v_groups);
  if v_size > v_cap then
    raise exception 'La salle % (% places) est trop petite pour % (% étudiants).', v_room, v_cap,
      case when cardinality(v_groups) > 1 then 'ces groupes réunis' else 'ce groupe' end, v_size;
  end if;
  if not exists (select 1 from public.schedule_sessions ss where ss.slot_id = new.id and ss.status = 'annulee') then
    for o in
      select s.id, s.room_id, ta.teacher_id, c.code course, s.start_time, s.end_time
      from public.timetable_slots s
      join public.teaching_assignments ta on ta.id = s.assignment_id
      join public.courses c on c.id = ta.course_id
      where s.week_start = new.week_start and s.day_of_week = new.day_of_week
        and s.start_time < new.end_time and new.start_time < s.end_time
        and s.id is distinct from new.id
        and (s.room_id = new.room_id or ta.teacher_id = a.teacher_id or public.asg_groups(ta.id) && v_groups)
        and not exists (select 1 from public.schedule_sessions ss where ss.slot_id = s.id and ss.status = 'annulee')
      limit 1
    loop
      raise exception 'Conflit avec % (de % à %) : %.', o.course, to_char(o.start_time,'HH24:MI'), to_char(o.end_time,'HH24:MI'),
        case when o.room_id = new.room_id then 'la salle est déjà occupée'
             when o.teacher_id = a.teacher_id then 'le professeur a déjà un cours' else 'un des groupes a déjà un cours' end;
    end loop;
  end if;
  if exists (select 1 from public.published_weeks w where w.week_start = new.week_start) then new.published := true; end if;
  return new;
end $function$;
