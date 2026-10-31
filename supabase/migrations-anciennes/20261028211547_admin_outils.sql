-- Mot de passe à changer à la première connexion (comptes existants : non ; nouveaux comptes : oui)
alter table public.profiles add column must_change_password boolean not null default false;
alter table public.profiles alter column must_change_password set default true;

create or replace function public.my_must_change() returns boolean
language sql stable security definer set search_path to '' as $$
  select coalesce((select must_change_password from public.profiles where id = auth.uid()), false)
$$;

create or replace function public.clear_my_must_change() returns void
language sql security definer set search_path to '' as $$
  update public.profiles set must_change_password = false where id = auth.uid()
$$;

create or replace function public.admin_set_must_change(p_user uuid, p_value boolean) returns void
language plpgsql security definer set search_path to '' as $$
begin
  if not public.has_role('admin') then raise exception 'Réservé à l''administrateur.'; end if;
  update public.profiles set must_change_password = p_value where id = p_user;
end $$;

-- Informations de connexion des comptes (date de création, dernière connexion), pour l'administrateur
create or replace function public.admin_users_info()
returns table(id uuid, created_at timestamptz, last_sign_in_at timestamptz)
language plpgsql stable security definer set search_path to '' as $$
begin
  if not public.has_role('admin') then raise exception 'Réservé à l''administrateur.'; end if;
  return query select u.id, u.created_at, u.last_sign_in_at from auth.users u;
end $$;

-- Lier (ou délier) un compte et une fiche enseignant
create or replace function public.admin_link_teacher(p_user uuid, p_teacher bigint) returns void
language plpgsql security definer set search_path to '' as $$
begin
  if not public.has_role('admin') then raise exception 'Réservé à l''administrateur.'; end if;
  if p_teacher is not null and exists (select 1 from public.teachers where id = p_teacher and profile_id is not null and profile_id <> p_user) then
    raise exception 'Cette fiche enseignant est déjà liée à un autre compte.';
  end if;
  update public.teachers set profile_id = null where profile_id = p_user and (p_teacher is null or id <> p_teacher);
  if p_teacher is not null then update public.teachers set profile_id = p_user where id = p_teacher; end if;
end $$;

revoke all on function public.admin_set_must_change(uuid,boolean) from public, anon;
revoke all on function public.admin_users_info() from public, anon;
revoke all on function public.admin_link_teacher(uuid,bigint) from public, anon;
revoke all on function public.my_must_change() from public, anon;
revoke all on function public.clear_my_must_change() from public, anon;
grant execute on function public.admin_set_must_change(uuid,boolean), public.admin_users_info(), public.admin_link_teacher(uuid,bigint), public.my_must_change(), public.clear_my_must_change() to authenticated;
