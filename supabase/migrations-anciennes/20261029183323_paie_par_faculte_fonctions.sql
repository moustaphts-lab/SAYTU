create or replace function public.rate_for(p_teacher bigint, p_date date, p_fac bigint)
 returns table(rate_fcfa integer, source text, rate_id bigint) language sql stable security definer set search_path to ''
as $$
  select x.rate_fcfa, x.source, x.id from (
    (select r.rate_fcfa, 'individuel'::text source, r.id, 1 prio from public.hourly_rates r
      where r.teacher_id = p_teacher and r.faculty_id = p_fac and r.effective_from <= p_date order by r.effective_from desc limit 1)
    union all
    (select r.rate_fcfa, 'statut'::text, r.id, 2 from public.hourly_rates r
      join public.teachers t on t.status_id = r.status_id
      where t.id = p_teacher and r.faculty_id = p_fac and r.effective_from <= p_date order by r.effective_from desc limit 1)
  ) x order by x.prio limit 1;
$$;
create or replace function public.rate_for(p_teacher bigint, p_date date)
 returns table(rate_fcfa integer, source text, rate_id bigint) language sql stable security definer set search_path to ''
as $$ select * from public.rate_for(p_teacher, p_date, public.fac_of_teacher(p_teacher)) $$;

create or replace function public.calculate_payroll(p_period bigint) returns jsonb language plpgsql security definer set search_path to ''
as $function$
declare p public.pay_periods; v_items int; v_total bigint; v_missing int; v_pending int; v_catch int;
begin
  select * into p from public.pay_periods where id = p_period for update;
  if not found then raise exception 'Période introuvable.'; end if;
  if not public.is_finance_for(p.faculty_id) then raise exception 'Réservé au service financier de la faculté.'; end if;
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
  cross join lateral public.rate_for(a.teacher_id, s.session_date, p.faculty_id) r
  where a.status = 'valide' and a.pay_period_id is null and s.session_date <= p.end_date
    and public.fac_of_session(s.id) = p.faculty_id
    and not exists (select 1 from public.payroll_items x where x.attendance_id = a.id);

  select count(*), coalesce(sum(amount_fcfa),0), count(*) filter (where is_catch_up)
    into v_items, v_total, v_catch from public.payroll_items where pay_period_id = p_period;

  select count(*) into v_missing from public.attendance_records a
    join public.schedule_sessions s on s.id = a.session_id
    where a.status = 'valide' and a.pay_period_id is null and s.session_date <= p.end_date
      and public.fac_of_session(s.id) = p.faculty_id
      and not exists (select 1 from public.payroll_items x where x.attendance_id = a.id)
      and not exists (select 1 from public.rate_for(a.teacher_id, s.session_date, p.faculty_id));

  select count(*) into v_pending from public.attendance_records a
    join public.schedule_sessions s on s.id = a.session_id
    where a.status in ('soumis','correction_demandee') and s.session_date between p.start_date and p.end_date
      and public.fac_of_session(s.id) = p.faculty_id;

  perform set_config('app.payroll_fn','on', true);
  update public.pay_periods set status = 'en_verification', calculated_at = now() where id = p_period;
  return jsonb_build_object('lignes', v_items, 'total_fcfa', v_total, 'sans_tarif', v_missing,
                            'en_attente', v_pending, 'rattrapages', v_catch);
end $function$;

create or replace function public.approve_payroll(p_period bigint) returns integer language plpgsql security definer set search_path to ''
as $function$
declare p public.pay_periods; v_n int; v_pref text; v_base int;
begin
  select * into p from public.pay_periods where id = p_period for update;
  if not found then raise exception 'Période introuvable.'; end if;
  if not public.is_finance_for(p.faculty_id) then raise exception 'Réservé au service financier de la faculté.'; end if;
  if p.status <> 'en_verification' then raise exception 'Lancez et vérifiez le calcul avant d''approuver.'; end if;
  if not exists (select 1 from public.payroll_items where pay_period_id = p_period) then
    raise exception 'Aucune heure payable dans cette période.'; end if;

  -- numéro propre à la faculté : CODE-ANNÉE-001 (la ligne de la faculté est verrouillée pendant la numérotation)
  select code || '-' || to_char(now(),'YYYY') || '-' into v_pref from public.faculties where id = p.faculty_id for update;
  select coalesce(max(substring(number from length(v_pref)+1)::int),0) into v_base from public.payslips
    where number like v_pref || '%' and substring(number from length(v_pref)+1) ~ '^[0-9]+$';

  insert into public.payslips (number, pay_period_id, teacher_id, total_minutes, gross_fcfa, deductions_fcfa, net_fcfa, snapshot)
  select v_pref || lpad((v_base + row_number() over (order by t.last_name, t.first_name, t.id))::text, 3, '0'),
    p_period, t.id, agg.minutes, agg.gross, 0, agg.gross,
    jsonb_build_object(
      'enseignant', jsonb_build_object('nom', t.first_name || ' ' || t.last_name, 'email', t.email,
                     'statut', st.label, 'departement', d.name),
      'faculte', jsonb_build_object('code', f.code, 'nom', f.name),
      'periode', jsonb_build_object('nom', p.name, 'debut', p.start_date, 'fin', p.end_date),
      'lignes', agg.lines,
      'approuve_le', now(), 'approuve_par', (select full_name from public.profiles where id = auth.uid()))
  from (
    select pi.teacher_id, sum(pi.minutes)::int minutes, sum(pi.amount_fcfa)::int gross,
      jsonb_agg(jsonb_build_object('date', pi.session_date, 'cours', pi.course_label, 'groupe', pi.group_code,
        'minutes', pi.minutes, 'tarif', pi.rate_fcfa, 'source', pi.rate_source, 'montant', pi.amount_fcfa,
        'rattrapage', pi.is_catch_up) order by pi.session_date, pi.course_label) lines
    from public.payroll_items pi where pi.pay_period_id = p_period group by pi.teacher_id
  ) agg
  join public.teachers t on t.id = agg.teacher_id
  join public.faculties f on f.id = p.faculty_id
  left join public.teacher_statuses st on st.id = t.status_id
  left join public.departments d on d.id = t.department_id;
  get diagnostics v_n = row_count;

  update public.attendance_records a set pay_period_id = p_period
  from public.payroll_items pi where pi.attendance_id = a.id and pi.pay_period_id = p_period;

  perform set_config('app.payroll_fn','on', true);
  update public.pay_periods set status = 'approuvee', approved_by = auth.uid(), approved_at = now() where id = p_period;
  return v_n;
end $function$;

create or replace function public.record_payment(p_payslip bigint, p_amount integer, p_paid_on date, p_method text default 'virement', p_reference text default null)
 returns public.payslips language plpgsql security definer set search_path to ''
as $function$
declare ps public.payslips; v_paid int; v_fac bigint;
begin
  select * into ps from public.payslips where id = p_payslip for update;
  if not found then raise exception 'Bulletin introuvable.'; end if;
  v_fac := public.fac_of_period(ps.pay_period_id);
  if not (public.is_finance_for(v_fac) or public.has_role_for('caissier', v_fac)) then raise exception 'Réservé au service financier de la faculté.'; end if;
  if p_amount is null or p_amount <= 0 then raise exception 'Montant invalide.'; end if;
  select coalesce(sum(amount_fcfa),0) into v_paid from public.payments where payslip_id = p_payslip;
  if v_paid + p_amount > ps.net_fcfa then
    raise exception 'Le paiement dépasse le net à payer (reste dû : % FCFA).', ps.net_fcfa - v_paid; end if;
  insert into public.payments (payslip_id, amount_fcfa, paid_on, method, reference)
  values (p_payslip, p_amount, p_paid_on, coalesce(nullif(trim(p_method),''),'virement'), nullif(trim(p_reference),''));
  update public.payslips set status = case when v_paid + p_amount = net_fcfa then 'paye'::public.payslip_status else 'partiellement_paye'::public.payslip_status end
    where id = p_payslip returning * into ps;
  if not exists (select 1 from public.payslips where pay_period_id = ps.pay_period_id and status <> 'paye') then
    perform set_config('app.payroll_fn','on', true);
    update public.pay_periods set status = 'payee' where id = ps.pay_period_id;
  end if;
  return ps;
end $function$;

create or replace function public.payment_needs_visa() returns trigger language plpgsql security definer set search_path to ''
as $function$
begin
  if exists (select 1 from public.payslips s join public.pay_periods p on p.id = s.pay_period_id
             join public.faculties f on f.id = p.faculty_id
             where s.id = new.payslip_id and f.payroll_visa and p.visa_at is null) then
    raise exception 'Paiement impossible : la paie n''a pas encore été visée par le doyen.';
  end if;
  return new;
end $function$;

create or replace function public.visa_payroll(p_period bigint, p_ok boolean, p_note text) returns void language plpgsql security definer set search_path to ''
as $function$
declare st text; v_fac bigint;
begin
  select status::text, faculty_id into st, v_fac from public.pay_periods where id = p_period;
  if st is null then raise exception 'Période introuvable.'; end if;
  if not exists (select 1 from public.user_roles ur where ur.user_id = auth.uid() and ur.role = 'direction' and ur.faculty_id = v_fac) then
    raise exception 'Réservé au doyen de la faculté.'; end if;
  if st not in ('approuvee','payee') then raise exception 'La paie doit d''abord être approuvée par le service financier.'; end if;
  perform set_config('app.payroll_fn','on', true);
  if p_ok then
    update public.pay_periods set visa_at = now(), visa_by = auth.uid(), visa_note = nullif(trim(coalesce(p_note,'')),'') where id = p_period and visa_at is null;
    if not found then raise exception 'Cette paie est déjà visée.'; end if;
  else
    if nullif(trim(coalesce(p_note,'')),'') is null then raise exception 'Écrivez la remarque.'; end if;
    update public.pay_periods set visa_note = trim(p_note) where id = p_period and visa_at is null;
    if not found then raise exception 'Cette paie est déjà visée.'; end if;
  end if;
  perform set_config('app.payroll_fn','off', true);
end $function$;

create or replace function public.set_teacher_payment(p_teacher bigint, p_method text, p_number text) returns void language plpgsql security definer set search_path to ''
as $function$
declare v_fac bigint := public.fac_of_teacher(p_teacher);
begin
  if not (public.has_role_for('finance', v_fac) or public.has_role_for('caissier', v_fac) or public.is_planner_for(v_fac)) then raise exception 'Action non autorisée.'; end if;
  update public.teachers set pay_method = nullif(p_method,''), pay_number = nullif(trim(coalesce(p_number,'')),'') where id = p_teacher;
  if not found then raise exception 'Enseignant introuvable.'; end if;
end $function$;

revoke execute on function public.fac_of_period(bigint), public.fac_of_payslip(bigint) from anon;
revoke execute on function public.rate_for(bigint,date,bigint) from anon;
