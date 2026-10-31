create or replace function public.compare_faculties(p_from date, p_to date) returns jsonb
language plpgsql stable security definer set search_path to ''
as $function$
declare v_out jsonb; v_year public.academic_years;
begin
  if not exists (select 1 from public.user_roles ur where ur.user_id = auth.uid()
                 and ur.role in ('direction','lecteur','finance') and ur.faculty_id is null) then
    raise exception 'Réservé au rectorat et aux services centraux.';
  end if;
  if p_from is null or p_to is null or p_to < p_from then raise exception 'Période invalide.'; end if;
  select * into v_year from public.academic_years where p_to between start_date and end_date order by start_date desc limit 1;
  if not found then select * into v_year from public.academic_years where is_current limit 1; end if;

  with fac as (select f.id, f.code, f.name, f.timetable_mode, f.payroll_visa, f.sort from public.faculties f),
  ses as (
    select public.faculty_of_assignment(s.assignment_id) fid, s.*, (s.session_date + s.end_time) < (now() at time zone 'UTC') past
    from public.schedule_sessions s where s.session_date between p_from and p_to),
  att as (
    select s.fid, a.status, a.retained_minutes, a.declared_minutes
    from public.attendance_records a join ses s on s.id = a.session_id),
  sem as (
    select distinct on (sm.faculty_id) sm.* from public.semesters sm
    where sm.start_date <= current_date order by sm.faculty_id, (current_date <= sm.end_date) desc, sm.start_date desc),
  prog as (
    select sm.faculty_id fid, sm.label sem_label, sm.start_date, sm.end_date,
      coalesce((select sum(ta.planned_hours) from public.teaching_assignments ta where ta.semester_id = sm.id),0) planned_h,
      coalesce((select sum(extract(epoch from (s.end_time - s.start_time))/3600) from public.schedule_sessions s
                join public.teaching_assignments ta on ta.id = s.assignment_id
                where ta.semester_id = sm.id and s.status <> 'annulee' and (s.session_date + s.end_time) < (now() at time zone 'UTC')),0) done_h
    from sem sm),
  pay as (
    select pp.faculty_id fid,
      coalesce(sum(ps.net_fcfa) filter (where pp.status in ('approuvee','payee')),0) engage,
      coalesce(sum((select sum(x.amount_fcfa) from public.payments x where x.payslip_id = ps.id)),0) paye
    from public.pay_periods pp left join public.payslips ps on ps.pay_period_id = pp.id
    where v_year.id is not null and pp.start_date between v_year.start_date and v_year.end_date
    group by pp.faculty_id),
  draft as (
    select pp.faculty_id fid, coalesce(sum(pi.amount_fcfa),0) en_calcul
    from public.pay_periods pp join public.payroll_items pi on pi.pay_period_id = pp.id
    where pp.status in ('ouverte','en_verification') group by pp.faculty_id),
  visa as (
    select pp.faculty_id fid, count(*) n from public.pay_periods pp join public.faculties f on f.id = pp.faculty_id
    where f.payroll_visa and pp.status in ('approuvee','payee') and pp.visa_at is null group by pp.faculty_id)
  select coalesce(jsonb_agg(jsonb_build_object(
      'id', f.id, 'code', f.code, 'nom', f.name, 'mode', f.timetable_mode, 'visa_requis', f.payroll_visa,
      'enseignants', (select count(*) from public.teachers t join public.departments d on d.id = t.department_id where d.faculty_id = f.id and t.active),
      'seances_prevues', (select count(*) from ses where ses.fid = f.id and ses.status <> 'annulee'),
      'seances_terminees', (select count(*) from ses where ses.fid = f.id and ses.status <> 'annulee' and ses.past),
      'seances_emargees', (select count(*) from ses where ses.fid = f.id and ses.status <> 'annulee' and ses.past
                            and exists (select 1 from public.attendance_records a where a.session_id = ses.id)),
      'seances_annulees', (select count(*) from ses where ses.fid = f.id and ses.status = 'annulee'),
      'a_controler', (select count(*) from att where att.fid = f.id and att.status = 'soumis'),
      'heures_validees', round(coalesce((select sum(retained_minutes) from att where att.fid = f.id and att.status = 'valide'),0) / 60.0, 1),
      'semestre', p.sem_label,
      'avancement_pct', case when coalesce(p.planned_h,0) > 0 then round(100 * p.done_h / p.planned_h) end,
      'attendu_pct', case when p.start_date is not null then round(100 * greatest(0, least(1, (current_date - p.start_date)::numeric / nullif(p.end_date - p.start_date, 0)))) end,
      'heures_faites', round(coalesce(p.done_h,0)::numeric, 1), 'heures_prevues', round(coalesce(p.planned_h,0)::numeric, 1),
      'paie_engagee', coalesce(py.engage,0), 'paie_payee', coalesce(py.paye,0), 'paie_en_calcul', coalesce(dr.en_calcul,0),
      'paies_attente_visa', coalesce(vs.n,0)
    ) order by f.sort, f.name), '[]'::jsonb)
  into v_out
  from fac f left join prog p on p.fid = f.id left join pay py on py.fid = f.id left join draft dr on dr.fid = f.id left join visa vs on vs.fid = f.id;

  return jsonb_build_object('du', p_from, 'au', p_to, 'annee', v_year.label, 'facultes', v_out);
end $function$;
revoke execute on function public.compare_faculties(date,date) from anon;
