
create or replace function public.calculate_payroll(p_period bigint)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare p public.pay_periods; v_items int; v_total bigint; v_missing int; v_pending int; v_catch int;
begin
  if not public.is_finance() then raise exception 'Réservé au service financier.'; end if;
  select * into p from public.pay_periods where id = p_period for update;
  if not found then raise exception 'Période introuvable.'; end if;
  if p.status not in ('ouverte','en_verification') then raise exception 'Période déjà approuvée : calcul impossible.'; end if;

  perform public.reset_payroll_items(p_period);

  insert into public.payroll_items (pay_period_id, attendance_id, teacher_id, session_date, course_label, group_code,
    minutes, rate_fcfa, rate_source, rate_id, amount_fcfa, is_catch_up)
  select p_period, a.id, a.teacher_id, s.session_date, c.code || ' ' || c.name, g.code,
    a.retained_minutes, r.rate_fcfa, r.source, r.rate_id, round(a.retained_minutes * r.rate_fcfa / 60.0)::int,
    s.session_date < p.start_date
  from public.attendance_records a
  join public.schedule_sessions s on s.id = a.session_id
  join public.teaching_assignments ta on ta.id = s.assignment_id
  join public.courses c on c.id = ta.course_id
  join public.student_groups g on g.id = s.group_id
  cross join lateral public.rate_for(a.teacher_id, s.session_date) r
  where a.status = 'valide' and a.pay_period_id is null and s.session_date <= p.end_date
    and not exists (select 1 from public.payroll_items x where x.attendance_id = a.id);

  select count(*), coalesce(sum(amount_fcfa),0), count(*) filter (where is_catch_up)
    into v_items, v_total, v_catch from public.payroll_items where pay_period_id = p_period;

  select count(*) into v_missing from public.attendance_records a
    join public.schedule_sessions s on s.id = a.session_id
    where a.status = 'valide' and a.pay_period_id is null and s.session_date <= p.end_date
      and not exists (select 1 from public.payroll_items x where x.attendance_id = a.id)
      and not exists (select 1 from public.rate_for(a.teacher_id, s.session_date));

  select count(*) into v_pending from public.attendance_records a
    join public.schedule_sessions s on s.id = a.session_id
    where a.status in ('soumis','correction_demandee') and s.session_date between p.start_date and p.end_date;

  perform set_config('app.payroll_fn','on', true);
  update public.pay_periods set status = 'en_verification', calculated_at = now() where id = p_period;
  return jsonb_build_object('lignes', v_items, 'total_fcfa', v_total, 'sans_tarif', v_missing,
                            'en_attente', v_pending, 'rattrapages', v_catch);
end $$;
revoke execute on function public.calculate_payroll(bigint) from public, anon;
grant execute on function public.calculate_payroll(bigint) to authenticated;
