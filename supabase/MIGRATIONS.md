# Migrations de la base (ordre d'application)

La base Supabase garde la liste officielle des migrations appliquées (`supabase_migrations.schema_migrations`, texte SQL compris).
Ce dépôt en garde une copie lisible. Les 68 anciennes sont copiées dans `supabase/migrations-anciennes/` (un fichier par migration, nommé `version_nom.sql`).
`python3 supabase/migrations-anciennes/verifier.py` compare chaque fichier à l'empreinte (md5) relevée dans la base (`MANIFEST.tsv`) : toutes sont conformes.
Les 17 migrations « plusieurs établissements » sont toutes dans `supabase/multi-etablissements/`.

Pour reconstruire une base vide : appliquer d'abord les 68 de `migrations-anciennes/` (dans l'ordre du nom de fichier), puis les fichiers ci-dessous dans l'ordre.
Dans plusieurs fichiers, `DLT` / `DRP` remplacent deux mots-clés SQL (suppression) : voir l'en-tête du fichier. Les 68 anciennes sont vérifiées par empreinte ; celles de `multi-etablissements/` sont des copies relues à la main (non vérifiées par empreinte).

## Avant les établissements (dans `supabase/migrations-anciennes/`)
Socle, sécurité, paie, référentiel, rôles, délégation, disponibilités, semaines, tronc commun, absences, postes et droits, facultés,
paie par faculté, comparaison, langue (`20261023162424` à `20261030151320`, 68 migrations).
Quelques scripts d'époque : `supabase/postes_et_nettoyage.sql`, `supabase/archives/`.

## Plusieurs établissements (dans `supabase/multi-etablissements/`)
| Version | Migration | Fichier |
|---|---|---|
| 20261030210053 | etablissements_etape1 | `01_etablissements.sql` |
| 20261030210154 | etablissements_etape1b_unicites | `01_etablissements.sql` |
| 20261030210204 | etablissements_etape1c_coherence | `01_etablissements.sql` |
| 20261030211433 | etablissements_etape2_comptes | `02_comptes_appartenances.sql` |
| 20261030213652 | etablissements_etape3_cloisonnement | `03_cloisonnement.sql` |
| 20261030213811 | etablissements_etape3b_app_settings | `03b_reglages_appartenances.sql` |
| 20261030213924 | etablissements_etape3c_appartenances_lecture | `03b_reglages_appartenances.sql` |
| 20261030214220 | etablissements_etape3d_compte_partage | `03b_reglages_appartenances.sql` |
| 20261030215247 | etablissements_etape4_plateforme | `04_plateforme.sql` |
| 20261030222833 | etablissements_etape4b_admins_centraux | `04b_admins_centraux.sql` |
| 20261030230235 | etape5a_vocabulaire | `05a_vocabulaire.sql` |
| 20261030230952 | etape5b_salles_partagees | `05b_salles_partagees.sql` |
| 20261030231002 | etape5b_controle_creneaux | `05b_controle_creneaux.sql` |
| 20261030232853 | etape4c_suppression_etablissement_vide | `04c_suppression.sql` |
| 20261030232912 | etape4c_suppression_dernier_admin | `04c_suppression_dernier_admin.sql` |
| 20261031063007 | etape6_visa_paie | `06_visa_paie.sql` |
| 20261031063054 | etape6_comparaison_visa | `06b_comparaison_visa.sql` |
| (31/10/2026) | etape7_connexion_demo | `07b_connexion_demo.sql` |
| (31/10/2026) | audit_e1_droits_fonctions | `08_droits_fonctions.sql` (test : `tests/db/droits_fonctions.sql`) |
| (31/10/2026) | audit_e1b_rate_for_interne | fin de `08_droits_fonctions.sql` |
| (31/10/2026) | audit_e2_etablissement_demo | `09_etablissement_demo.sql` |
| (31/10/2026) | audit_m4_droits_tables_visiteurs, audit_m4b_visiteurs_aucune_table | `10_droits_tables_visiteurs.sql` |
| (31/10/2026) | audit_m6_rls_copies | `13_rls_copies.sql` |
| (31/10/2026) | audit_m5_limite_logos | `12_limite_logos.sql` |
| (31/10/2026) | audit_m5_reinitialisation_demo | `11_reinitialisation_demo.sql` (test : `tests/db/reinitialisation_demo.sql`) |

## Opération ponctuelle (hors migrations)
`07_nettoyage_ucab.sql` : nettoyage unique du 31/10/2026 (étape 7). L'établissement n° 1 devient « DEMO », les essais sont supprimés, un nouvel « UCAB » vide est créé (n° 6). **À ne pas rejouer.** Sauvegarde : schéma `saytu_backup_20261031`.

Les fichiers `.md` du même dossier expliquent chaque étape en français (01 à 06).
Note : la suppression (4c) a été appliquée après 5a et 5b ; l'ordre d'application réel est celui de la colonne « Version ».

## Fonction de gestion des comptes
`supabase/functions/manage-users/index.ts` (version 7 déployée ; test sans réseau : `tests/functions/lancer.sh`) : création de comptes, mots de passe provisoires, activation,
et actions de la plateforme (premier administrateur, nouveau mot de passe, suppression d'un établissement vide).

## Remise à zéro de DEMO
Le schéma privé `saytu_demo_ref` (jamais exposé) garde une copie de référence de DEMO (`take_snapshot()`, prise le 31/10/2026) et sait la rétablir (`reset_demo()`, en une seule transaction : données, journal, noms, langues et mots de passe des 12 comptes).
Seul le propriétaire de la base peut l'appeler (éditeur SQL de Supabase, ou plus tard une tâche pg_cron). Si DEMO change volontairement (nouvelles données de démonstration), relancer `take_snapshot()` après les avoir préparées.
