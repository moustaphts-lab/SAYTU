
alter table public.teachers add column if not exists pay_method text check (pay_method in ('virement','Wave','Orange Money','chèque','espèces'));
alter table public.teachers add column if not exists pay_number text check (length(pay_number) <= 60);

create or replace function public.set_teacher_payment(p_teacher bigint, p_method text, p_number text) returns void
language plpgsql security definer set search_path to '' as $$
begin
  if not (public.has_role('finance') or public.is_planner()) then raise exception 'Action non autorisée.'; end if;
  update public.teachers set pay_method = nullif(p_method,''), pay_number = nullif(trim(coalesce(p_number,'')),'') where id = p_teacher;
  if not found then raise exception 'Enseignant introuvable.'; end if;
end $$;

