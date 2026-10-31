-- Audit M4 : un visiteur non connecté n'a plus aucun droit sur les tables, vues et séquences du schéma public.
-- (Avant : lecture et écriture sur 35 tables, protégées seulement par les règles par ligne.) Les comptes connectés ne sont pas touchés.
-- L'écran de connexion n'a besoin que de login_demo() (voir 07b et 08).
revoke all on all tables in schema public from anon;
revoke all on all sequences in schema public from anon;
alter default privileges for role postgres in schema public revoke all on tables from anon;
alter default privileges for role postgres in schema public revoke all on sequences from anon;
