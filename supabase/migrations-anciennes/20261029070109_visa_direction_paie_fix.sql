
create or replace function public.visa_payroll(p_period bigint, p_ok boolean, p_note text) returns void
language plpgsql security definer set search_path to '' as $$
declare st text;
begin
  if not public.has_role('direction') then raise exception 'Réservé à la direction générale.'; end if;
  select status::text into st from public.pay_periods where id = p_period;
  if st is null then raise exception 'Période introuvable.'; end if;
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
end $$;

