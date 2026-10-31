-- Étape 7.2 : l'écran de connexion (visiteur non connecté) ne peut plus lire app_settings dès qu'il y a plusieurs établissements.
-- Cette fonction ne révèle qu'une seule chose : faut-il afficher les comptes de démonstration (réglage de l'établissement « DEMO »).
create or replace function public.login_demo() returns boolean
language sql stable security definer set search_path = public as $$
  select coalesce((select a.show_demo from public.app_settings a join public.establishments e on e.id = a.establishment_id
                    where e.code = 'DEMO' and e.active limit 1), false)
$$;
revoke all on function public.login_demo() from public;
grant execute on function public.login_demo() to anon, authenticated;
