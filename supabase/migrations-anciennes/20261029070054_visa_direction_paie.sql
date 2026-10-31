
alter table public.pay_periods add column if not exists visa_at timestamptz;
alter table public.pay_periods add column if not exists visa_by uuid references public.profiles(id);
alter table public.pay_periods add column if not exists visa_note text;
alter table public.app_settings add column if not exists payroll_visa boolean not null default true;

create or replace function public.visa_payroll(p_period bigint, p_ok boolean, p_note text) returns void
language plpgsql security definer set search_path to '' as $$
declare st text;
begin
  if not public.has_role('direction') then raise exception 'Réservé à la direction générale.'; end if;
  select status::text into st from public.pay_periods where id = p_period;
  if st is null then raise exception 'Période introuvable.'; end if;
  if st not in ('approuvee','payee') then raise exception 'La paie doit d''abord être approuvée par le service financier.'; end if;
  if p_ok then
    update public.pay_periods set visa_at = now(), visa_by = auth.uid(), visa_note = nullif(trim(coalesce(p_note,'')),'') where id = p_period and visa_at is null;
    if not found then raise exception 'Cette paie est déjà visée.'; end if;
  else
    if nullif(trim(coalesce(p_note,'')),'') is null then raise exception 'Écrivez la remarque.'; end if;
    update public.pay_periods set visa_note = trim(p_note) where id = p_period and visa_at is null;
    if not found then raise exception 'Cette paie est déjà visée.'; end if;
  end if;
end $$;

-- pas de paiement avant le visa, si la règle est activée
create or replace function public.payment_needs_visa() returns trigger
language plpgsql security definer set search_path to '' as $$
begin
  if coalesce((select payroll_visa from public.app_settings where id = 1), false)
     and exists (select 1 from public.payslips s join public.pay_periods p on p.id = s.pay_period_id where s.id = new.payslip_id and p.visa_at is null) then
    raise exception 'Paiement impossible : la paie n''a pas encore été visée par la direction générale.';
  end if;
  return new;
end $$;
create trigger trg_payment_needs_visa before insert on public.payments for each row execute function public.payment_needs_visa();

