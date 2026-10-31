-- Audit E2 : l'établissement de démonstration (mot de passe public) est marqué « demo » ; la fonction manage-users (v7) n'y crée
-- ni ne modifie plus aucun compte, et ne rattache un compte déjà existant que s'il a été activé par sa personne.
alter table public.establishments add column if not exists demo boolean not null default false;
update public.establishments set demo = true where id = 1 and code = 'DEMO';
