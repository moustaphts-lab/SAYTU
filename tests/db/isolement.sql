-- Outils du test d'isolement (schéma saytu_tests, dans la base). Copie des définitions en place.
-- Mode d'emploi : tests/db/isolement.md. Le schéma, la table baseline (référence du 30/10/2026) et la sauvegarde
-- saytu_backup_20261030 existent déjà dans la base ; ce fichier sert à les recréer au besoin (baseline à reprendre avec visibility()).
create schema if not exists saytu_tests;
create table if not exists saytu_tests.baseline(user_id uuid, email text, tbl text, n bigint);
create table if not exists saytu_tests.current(user_id uuid, email text, tbl text, n bigint);

-- ce que voit chaque compte, table par table, avec les vraies règles d'accès (par lots de comptes)
CREATE OR REPLACE FUNCTION saytu_tests.visibility(p_off integer, p_lim integer, p_tbl text DEFAULT NULL::text)
 RETURNS TABLE(user_id uuid, email text, tbl text, n bigint)
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare u record; t record; c bigint;
begin
  create temp table if not exists _vis(user_id uuid, email text, tbl text, n bigint) on commit drop;
  for u in select au.id, au.email from auth.users au order by au.email offset p_off limit p_lim loop
    for t in select cl.relname from pg_class cl where cl.relnamespace='public'::regnamespace and cl.relkind='r' and (p_tbl is null or cl.relname=p_tbl) and (p_tbl is not null or cl.relname<>'audit_logs') order by 1 loop
      perform set_config('request.jwt.claims', json_build_object('sub',u.id,'role','authenticated')::text, true);
      perform set_config('request.headers', '{}', true);
      execute 'set local role authenticated';
      begin execute format('select count(*) from public.%I', t.relname) into c;
      exception when others then c := -1; end;
      execute 'reset role';
      insert into _vis values (u.id, u.email, t.relname, c);
    end loop;
  end loop;
  return query select * from _vis;
end $function$;

-- différences entre la référence (baseline) et l'état courant (current) : doit être vide pour les comptes existants
CREATE OR REPLACE FUNCTION saytu_tests.diff()
 RETURNS TABLE(email text, tbl text, avant bigint, apres bigint)
 LANGUAGE sql
 SET search_path TO ''
AS $function$
  select coalesce(b.email,c.email), coalesce(b.tbl,c.tbl), b.n, c.n
  from saytu_tests.baseline b full join saytu_tests.current c on c.user_id=b.user_id and c.tbl=b.tbl
  where b.n is distinct from c.n order by 1,2 $function$;

-- ce que voit un seul compte (tables et vues) sous forme JSON
CREATE OR REPLACE FUNCTION saytu_tests.counts(u uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare t record; c bigint; r jsonb := '{}';
begin
  for t in select cl.relname from pg_class cl where cl.relnamespace='public'::regnamespace and cl.relkind in ('r','v') and cl.relname<>'audit_logs' order by 1 loop
    perform set_config('request.jwt.claims', json_build_object('sub',u,'role','authenticated')::text, true);
    perform set_config('request.headers', '{}', true);
    execute 'set local role authenticated';
    begin execute format('select count(*) from public.%I', t.relname) into c; exception when others then c := -1; end;
    execute 'reset role';
    r := r || jsonb_build_object(t.relname, c);
  end loop;
  return r;
end $function$;
