alter table public.pay_periods add column if not exists faculty_id bigint references public.faculties(id);
alter table public.hourly_rates add column if not exists faculty_id bigint references public.faculties(id);
set local app.payroll_fn = 'on';
update public.pay_periods set faculty_id = (select id from public.faculties where code='FSRC') where faculty_id is null;
update public.hourly_rates set faculty_id = coalesce(public.fac_of_teacher(teacher_id),(select id from public.faculties where code='FSRC')) where faculty_id is null;
alter table public.pay_periods alter column faculty_id set not null;
alter table public.hourly_rates alter column faculty_id set not null;
create index if not exists pay_periods_fac_idx on public.pay_periods(faculty_id);
create index if not exists hourly_rates_fac_idx on public.hourly_rates(faculty_id);

create or replace function public.fac_of_period(p bigint) returns bigint language sql stable security definer set search_path to ''
as $$ select faculty_id from public.pay_periods where id = p $$;
create or replace function public.fac_of_payslip(s bigint) returns bigint language sql stable security definer set search_path to ''
as $$ select pp.faculty_id from public.payslips ps join public.pay_periods pp on pp.id = ps.pay_period_id where ps.id = s $$;
create or replace function public.is_finance_for(fac bigint) returns boolean language sql stable security definer set search_path to ''
as $$ select public.has_role_for('finance', fac) $$;
create or replace function public.can_read_payroll_for(fac bigint) returns boolean language sql stable security definer set search_path to ''
as $$ select public.has_role_for('finance', fac) or public.has_role_for('direction', fac) or public.has_role_for('caissier', fac) or public.has_role_for('lecteur', fac) $$;

alter policy rates_select on public.hourly_rates using ((select public.can_read_payroll_for(faculty_id)));
alter policy rates_insert on public.hourly_rates with check ((select public.is_finance_for(faculty_id)) and (teacher_id is null or public.fac_of_teacher(teacher_id) = faculty_id));
alter policy rates_delete on public.hourly_rates using ((select public.is_finance_for(faculty_id)) and not exists (select 1 from public.payroll_items pi where pi.rate_id = hourly_rates.id));
alter policy periods_select on public.pay_periods using ((select public.can_read_payroll_for(faculty_id)) or exists (select 1 from public.payslips ps where ps.pay_period_id = pay_periods.id and ps.teacher_id = (select public.current_teacher_id())));
alter policy periods_insert on public.pay_periods with check ((select public.is_finance_for(faculty_id)) and status = 'ouverte');
alter policy periods_update on public.pay_periods using ((select public.is_finance_for(faculty_id)) and status in ('ouverte','en_verification')) with check ((select public.is_finance_for(faculty_id)) and status in ('ouverte','en_verification'));
alter policy periods_delete on public.pay_periods using ((select public.is_finance_for(faculty_id)) and status in ('ouverte','en_verification'));
alter policy items_select on public.payroll_items using ((select public.can_read_payroll_for(public.fac_of_period(pay_period_id))) or teacher_id = (select public.current_teacher_id()));
alter policy payslips_select on public.payslips using ((select public.can_read_payroll_for(public.fac_of_period(pay_period_id))) or teacher_id = (select public.current_teacher_id()));
alter policy payments_select on public.payments using ((select public.can_read_payroll_for(public.fac_of_payslip(payslip_id))) or exists (select 1 from public.payslips ps where ps.id = payments.payslip_id and ps.teacher_id = (select public.current_teacher_id())));
