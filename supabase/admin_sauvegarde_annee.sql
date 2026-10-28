-- Administrateur : sauvegarde, départ d'une personne, année en cours, nouvelle année.
-- À exécuter une fois dans Supabase > SQL Editor.

create or replace function public.admin_backup() returns jsonb
language plpgsql security definer set search_path to '' as $$
declare t text; r jsonb := '{}'::jsonb; v jsonb; full_ boolean;
  pay text[] := array['hourly_rates','pay_periods','payments','payroll_items','payslips'];
begin
  if not public.has_role('admin') then raise exception 'Réservé à l''administrateur.'; end if;
  full_ := public.has_role('finance') or public.has_role('direction');
  foreach t in array array['app_settings','academic_years','semesters','departments','programs','student_groups','rooms','courses','course_programs',
    'teacher_statuses','teachers','profiles','user_roles','teaching_assignments','assignment_groups','school_schedule','calendar_closures',
    'teacher_availability','availability_weeks','timetable_slots','published_weeks','schedule_sessions','attendance_records','announcements',
    'hourly_rates','pay_periods','payroll_items','payslips','payments','audit_logs'] loop
    if t = any(pay) and not full_ then continue; end if;
    if t = 'audit_logs' and not full_ then
      select coalesce(jsonb_agg(to_jsonb(x) order by x.occurred_at),'[]') into v from public.audit_logs x where not (x.table_name = any(pay));
    else
      execute format('select coalesce(jsonb_agg(to_jsonb(x)),''[]'') from public.%I x', t) into v;
    end if;
    r := r || jsonb_build_object(t, v);
  end loop;
  return jsonb_build_object('full', full_, 'tables', r);
end $$;

create or replace function public.admin_departure_check(p_user uuid) returns jsonb
language plpgsql security definer set search_path to '' as $$
declare v_t bigint; n int; d date;
begin
  if not public.has_role('admin') then raise exception 'Réservé à l''administrateur.'; end if;
  select id into v_t from public.teachers where profile_id = p_user;
  if v_t is null then return jsonb_build_object('sessions',0); end if;
  select count(*), min(session_date) into n, d from public.schedule_sessions
   where teacher_id = v_t and session_date >= current_date and status <> 'annulee';
  return jsonb_build_object('sessions', n, 'next', d,
    'assignments', (select count(*) from public.teaching_assignments ta join public.semesters s on s.id = ta.semester_id where ta.teacher_id = v_t and s.end_date >= current_date));
end $$;

create or replace function public.set_current_year(p_year bigint) returns void
language plpgsql security definer set search_path to '' as $$
begin
  if not (public.has_role('admin') or public.is_planner()) then raise exception 'Action non autorisée.'; end if;
  update public.academic_years set is_current = (id = p_year);
end $$;

-- p_sems : [{"label":"Semestre 1","start":"2027-10-01","end":"2028-02-15","from":12}, ...]
create or replace function public.new_academic_year(p_label text, p_start date, p_end date, p_sems jsonb, p_copy boolean, p_current boolean) returns jsonb
language plpgsql security definer set search_path to '' as $$
declare y bigint; s jsonb; ns bigint; a record; na bigint; n int := 0;
begin
  if not (public.has_role('admin') or public.is_planner()) then raise exception 'Action non autorisée.'; end if;
  if exists (select 1 from public.academic_years where label = p_label) then raise exception 'L''année % existe déjà.', p_label; end if;
  if p_end <= p_start then raise exception 'La fin de l''année doit être après son début.'; end if;
  insert into public.academic_years(label,start_date,end_date,is_current) values (p_label,p_start,p_end,false) returning id into y;
  for s in select * from jsonb_array_elements(p_sems) loop
    if (s->>'start')::date < p_start or (s->>'end')::date > p_end or (s->>'end')::date <= (s->>'start')::date then
      raise exception 'Les dates du semestre « % » doivent être comprises dans l''année.', s->>'label'; end if;
    insert into public.semesters(academic_year_id,label,start_date,end_date) values (y, s->>'label', (s->>'start')::date, (s->>'end')::date) returning id into ns;
    if p_copy and nullif(s->>'from','') is not null then
      for a in select ta.* from public.teaching_assignments ta join public.teachers t on t.id = ta.teacher_id
               where ta.semester_id = (s->>'from')::bigint and coalesce(t.active,true) loop
        insert into public.teaching_assignments(semester_id,teacher_id,course_id,group_id,planned_hours)
          values (ns,a.teacher_id,a.course_id,a.group_id,a.planned_hours) returning id into na;
        insert into public.assignment_groups(assignment_id,group_id)
          select na, ag.group_id from public.assignment_groups ag where ag.assignment_id = a.id
          on conflict do nothing;
        n := n + 1;
      end loop;
    end if;
  end loop;
  if p_current then update public.academic_years set is_current = (id = y); end if;
  return jsonb_build_object('year', y, 'copied', n);
end $$;

revoke execute on function public.admin_backup() from public, anon;
revoke execute on function public.admin_departure_check(uuid) from public, anon;
revoke execute on function public.set_current_year(bigint) from public, anon;
revoke execute on function public.new_academic_year(text,date,date,jsonb,boolean,boolean) from public, anon;
grant execute on function public.admin_backup() to authenticated;
grant execute on function public.admin_departure_check(uuid) to authenticated;
grant execute on function public.set_current_year(bigint) to authenticated;
grant execute on function public.new_academic_year(text,date,date,jsonb,boolean,boolean) to authenticated;

select 'Fonctions installées' as resultat;
