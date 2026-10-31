
create or replace function public.keep_one_admin()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if old.role = 'admin' and not exists (
      select 1 from public.user_roles where role = 'admin' and id <> old.id) then
    raise exception 'Il doit rester au moins un administrateur.';
  end if;
  return old;
end $$;
create trigger trg_keep_one_admin before delete on public.user_roles
  for each row execute function public.keep_one_admin();
revoke execute on function public.keep_one_admin() from public, anon, authenticated;
