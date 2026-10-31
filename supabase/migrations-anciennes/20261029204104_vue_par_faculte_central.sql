-- Faculté consultée par un compte de niveau université (rectorat, contrôle, responsable financier central).
-- L'application l'envoie dans l'en-tête x-ucab-fac ; cela ne peut que restreindre ce que le compte voit.
create or replace function public.view_fac() returns bigint language sql stable set search_path to ''
as $$ select case when (current_setting('request.headers', true)::json ->> 'x-ucab-fac') ~ '^[0-9]{1,12}$'
                  then (current_setting('request.headers', true)::json ->> 'x-ucab-fac')::bigint end $$;

create or replace function public.has_role_for(r public.app_role, fac bigint) returns boolean language sql stable security definer set search_path to ''
as $$
  select exists (select 1 from public.user_roles ur where ur.user_id = auth.uid() and ur.role = r
    and (ur.faculty_id = fac or (ur.faculty_id is null and (fac is null or public.view_fac() is null or public.view_fac() = fac)))) $$;

create or replace function public.sees_fac(fac bigint) returns boolean language sql stable security definer set search_path to ''
as $$
  select exists (select 1 from public.user_roles ur where ur.user_id = auth.uid()
    and (ur.faculty_id = fac or (ur.faculty_id is null and ur.role <> 'professeur' and (public.view_fac() is null or public.view_fac() = fac)))) $$;
