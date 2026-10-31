-- Audit du 31/10/2026, constat E1 : les fonctions du schéma public étaient exécutables par n'importe qui (droit donné à PUBLIC),
-- y compris par un visiteur non connecté (ex. rate_for renvoyait un tarif horaire).
-- Après : seules les personnes connectées (authenticated) et le service peuvent les appeler ; le visiteur n'a plus que login_demo().
-- Les droits des personnes connectées restent exactement ce qu'ils étaient (copiés avant le retrait).
do $m$
declare r record;
begin
  for r in select p.oid::regprocedure as sig, has_function_privilege('authenticated', p.oid, 'execute') as a
             from pg_proc p join pg_namespace n on n.oid = p.pronamespace
            where n.nspname = 'public' and p.prokind = 'f' loop
    execute 'revoke execute on function ' || r.sig || ' from public, anon';
    if r.a then execute 'grant execute on function ' || r.sig || ' to authenticated'; end if;
  end loop;
  grant execute on function public.login_demo() to anon, authenticated;
end $m$;
-- Fonctions futures : pas de droit automatique pour PUBLIC ni anon (accorder explicitement à authenticated).
alter default privileges for role postgres in schema public revoke execute on functions from public, anon;
