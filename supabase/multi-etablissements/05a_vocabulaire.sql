-- Étape 5a (etape5a_vocabulaire) : mot choisi par l'établissement (faculté, UFR, école, institut).
-- À appliquer APRÈS 04_plateforme.sql (modifie platform_create_establishment). Copie du SQL tel qu'appliqué.
alter table public.app_settings add column unit_word text not null default 'faculte'
  constraint app_settings_unit_word_check check (unit_word in ('faculte','ufr','ecole','institut'));
do $mig$ declare d text; n text; begin
  d := pg_get_functiondef('public.platform_create_establishment(text,text,text)'::regprocedure);
  n := replace(d, 'insert into public.app_settings(establishment_id, name, subtitle, enabled_rights, show_demo)
    values (e, nm, ''Enseignements'',', 'insert into public.app_settings(establishment_id, name, subtitle, enabled_rights, show_demo, unit_word)
    values (e, nm, ''Enseignements'',');
  if n = d then raise exception 'morceau 1 introuvable'; end if;
  d := n;
  n := replace(d, '''{caissier}''::text[] end, false);', '''{caissier}''::text[] end, false, case p_model when ''ecole'' then ''ecole'' else ''faculte'' end);');
  if n = d then raise exception 'morceau 2 introuvable'; end if;
  execute n;
end $mig$;
