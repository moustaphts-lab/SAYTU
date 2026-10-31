
create or replace function public.rate_for(p_teacher bigint, p_date date)
returns table(rate_fcfa int, source text, rate_id bigint) language sql stable security definer set search_path = '' as $$
  select x.rate_fcfa, x.source, x.id from (
    (select r.rate_fcfa, 'individuel'::text source, r.id, 1 prio from public.hourly_rates r
      where r.teacher_id = p_teacher and r.effective_from <= p_date order by r.effective_from desc limit 1)
    union all
    (select r.rate_fcfa, 'statut'::text, r.id, 2 from public.hourly_rates r
      join public.teachers t on t.status_id = r.status_id
      where t.id = p_teacher and r.effective_from <= p_date order by r.effective_from desc limit 1)
  ) x order by x.prio limit 1;
$$;
create or replace function public.is_finance()
returns boolean language sql stable security definer set search_path = '' as $$
  select public.has_role('admin') or public.has_role('finance');
$$;
create or replace function public.can_read_payroll()
returns boolean language sql stable security definer set search_path = '' as $$
  select public.has_role('admin') or public.has_role('finance') or public.has_role('direction');
$$;
revoke execute on function public.is_finance(), public.can_read_payroll(), public.rate_for(bigint, date) from public, anon;
grant execute on function public.is_finance(), public.can_read_payroll(), public.rate_for(bigint, date) to authenticated;

alter table public.teacher_statuses enable row level security;
alter table public.hourly_rates enable row level security;
alter table public.pay_periods enable row level security;
alter table public.payroll_items enable row level security;
alter table public.payslips enable row level security;
alter table public.payments enable row level security;

create policy ts_select on public.teacher_statuses for select to authenticated using (true);
create policy ts_admin on public.teacher_statuses for all to authenticated using ((select public.has_role('admin'))) with check ((select public.has_role('admin')));
create policy rates_select on public.hourly_rates for select to authenticated using ((select public.can_read_payroll()));
create policy rates_insert on public.hourly_rates for insert to authenticated with check ((select public.is_finance()));
create policy rates_delete on public.hourly_rates for delete to authenticated using (
  (select public.is_finance()) and not exists (select 1 from public.payroll_items pi where pi.rate_id = hourly_rates.id));
create policy periods_select on public.pay_periods for select to authenticated using (
  (select public.can_read_payroll()) or exists (select 1 from public.payslips ps where ps.pay_period_id = pay_periods.id and ps.teacher_id = (select public.current_teacher_id())));
create policy periods_insert on public.pay_periods for insert to authenticated with check ((select public.is_finance()) and status = 'ouverte');
create policy periods_update on public.pay_periods for update to authenticated
  using ((select public.is_finance()) and status in ('ouverte','en_verification'))
  with check (status in ('ouverte','en_verification'));
create policy periods_delete on public.pay_periods for delete to authenticated using ((select public.is_finance()) and status in ('ouverte','en_verification'));
create policy items_select on public.payroll_items for select to authenticated using (
  (select public.can_read_payroll()) or teacher_id = (select public.current_teacher_id()));
create policy payslips_select on public.payslips for select to authenticated using (
  (select public.can_read_payroll()) or teacher_id = (select public.current_teacher_id()));
create policy payments_select on public.payments for select to authenticated using (
  (select public.can_read_payroll()) or exists (select 1 from public.payslips ps where ps.id = payments.payslip_id and ps.teacher_id = (select public.current_teacher_id())));

create or replace function public.protect_period()
returns trigger language plpgsql set search_path = '' as $$
begin
  if old.status in ('approuvee','payee') and current_setting('app.payroll_fn', true) is distinct from 'on' then
    raise exception 'Période approuvée : modification interdite.';
  end if;
  return new;
end $$;
create trigger trg_protect_period before update on public.pay_periods for each row execute function public.protect_period();

do $$ declare t text;
begin
  foreach t in array array['hourly_rates','pay_periods','payslips','payments','teacher_statuses']
  loop
    execute format('create trigger trg_audit_%1$s after insert or update or delete on public.%1$I for each row execute function public.audit_trigger()', t);
  end loop;
end $$;
