-- Étape 4c, suite (etape4c_suppression_dernier_admin) : à appliquer APRÈS 04c_suppression.sql.
-- Le déclencheur « garder au moins un administrateur » laisse passer la suppression d'un établissement vide.
-- (Copie du SQL tel qu'appliqué ; 04c_suppression.sql contient déjà la fonction de départ.)
do $mig$ declare d text; n text; begin
  d := pg_get_functiondef('public.keep_one_admin()'::regprocedure);
  n := replace(d, 'begin
  if old.role = ''admin''', 'begin
  -- suppression d''un établissement vide par la plateforme : ses administrateurs partent avec lui
  if current_setting(''saytu.removing_etab'', true) = old.establishment_id::text then return old; end if;
  if old.role = ''admin''');
  if n = d then raise exception 'morceau introuvable'; end if;
  execute n;
  d := pg_get_functiondef('public.platform_remove_establishment(bigint,text)'::regprocedure);
  n := replace(d, '  select array_agg(id) into v_facs', '  perform set_config(''saytu.removing_etab'', p_id::text, true);
  select array_agg(id) into v_facs');
  if n = d then raise exception 'morceau 2 introuvable'; end if;
  execute n;
end $mig$;
