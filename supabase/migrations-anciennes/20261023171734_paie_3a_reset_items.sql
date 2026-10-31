
create or replace function public.reset_payroll_items(p_period bigint)
returns void language sql security definer set search_path = '' as $$
  delete from public.payroll_items where pay_period_id = p_period;
$$;
revoke execute on function public.reset_payroll_items(bigint) from public, anon, authenticated;
