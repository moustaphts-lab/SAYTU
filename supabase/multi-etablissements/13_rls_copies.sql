-- Audit M6 : protection par ligne sur toutes les tables des copies de sauvegarde et de test.
-- Sans règle d'accès, ces tables sont illisibles pour l'application même si un réglage les exposait par erreur.
-- Les copies elles-mêmes sont temporaires : saytu_backup_20261030 à supprimer vers le 07/11/2026 (avec l'accord de Mustafaa),
-- saytu_backup_20261031 et saytu_tests à supprimer avant l'arrivée de vraies données.
do $$
declare r record;
begin
  for r in
    select n.nspname, c.relname
    from pg_class c join pg_namespace n on n.oid=c.relnamespace
    where n.nspname in ('saytu_backup_20261030','saytu_backup_20261031','saytu_tests')
      and c.relkind in ('r','p') and not c.relrowsecurity
  loop
    execute format('alter table %I.%I enable row level security', r.nspname, r.relname);
  end loop;
end $$;
