
create or replace function public.approve_payroll(p_period bigint)
returns int language plpgsql security definer set search_path = '' as $$
declare p public.pay_periods; v_n int;
begin
  if not public.is_finance() then raise exception 'Réservé au service financier.'; end if;
  select * into p from public.pay_periods where id = p_period for update;
  if not found then raise exception 'Période introuvable.'; end if;
  if p.status <> 'en_verification' then raise exception 'Lancez et vérifiez le calcul avant d''approuver.'; end if;
  if not exists (select 1 from public.payroll_items where pay_period_id = p_period) then
    raise exception 'Aucune heure payable dans cette période.'; end if;

  insert into public.payslips (number, pay_period_id, teacher_id, total_minutes, gross_fcfa, deductions_fcfa, net_fcfa, snapshot)
  select 'BUL-' || to_char(now(),'YYYY') || '-' || lpad(nextval('public.payslip_seq')::text, 4, '0'),
    p_period, t.id, agg.minutes, agg.gross, 0, agg.gross,
    jsonb_build_object(
      'enseignant', jsonb_build_object('nom', t.first_name || ' ' || t.last_name, 'email', t.email,
                     'statut', st.label, 'departement', d.name),
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
  left join public.teacher_statuses st on st.id = t.status_id
  left join public.departments d on d.id = t.department_id
  order by t.last_name;
  get diagnostics v_n = row_count;

  update public.attendance_records a set pay_period_id = p_period
  from public.payroll_items pi where pi.attendance_id = a.id and pi.pay_period_id = p_period;

  perform set_config('app.payroll_fn','on', true);
  update public.pay_periods set status = 'approuvee', approved_by = auth.uid(), approved_at = now() where id = p_period;
  return v_n;
end $$;

create or replace function public.record_payment(p_payslip bigint, p_amount int, p_paid_on date, p_method text default 'virement', p_reference text default null)
returns public.payslips language plpgsql security definer set search_path = '' as $$
declare ps public.payslips; v_paid int;
begin
  if not public.is_finance() then raise exception 'Réservé au service financier.'; end if;
  select * into ps from public.payslips where id = p_payslip for update;
  if not found then raise exception 'Bulletin introuvable.'; end if;
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
end $$;

revoke execute on function public.approve_payroll(bigint), public.record_payment(bigint,int,date,text,text) from public, anon;
grant execute on function public.approve_payroll(bigint), public.record_payment(bigint,int,date,text,text) to authenticated;
