
create policy audit_hide_payroll on public.audit_logs as restrictive for select to authenticated
  using (table_name not in ('hourly_rates','pay_periods','payslips','payments') or (select public.can_read_payroll()));
create policy audit_finance_read on public.audit_logs for select to authenticated
  using ((select public.has_role('finance')));
