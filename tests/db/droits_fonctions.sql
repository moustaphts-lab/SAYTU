-- Test : un visiteur non connecté ne peut exécuter que login_demo() (audit E1). À jouer après chaque migration qui crée une fonction.
-- Résultat attendu : une seule ligne, login_demo().
select p.oid::regprocedure as fonction_ouverte_aux_visiteurs
  from pg_proc p join pg_namespace n on n.oid = p.pronamespace
 where n.nspname = 'public' and p.prokind = 'f' and has_function_privilege('anon', p.oid, 'execute');
-- Et les fonctions que les personnes connectées utilisaient doivent le rester : comparer avec la liste d'avant (aucune ne doit disparaître).
