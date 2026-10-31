# Migrations de la base (ordre d'application)

La base Supabase garde la liste officielle des migrations appliquées (`supabase_migrations.schema_migrations`, texte SQL compris).
Ce dépôt en garde une copie lisible. **Les 68 anciennes ne sont pas encore copiées ici** : leur texte est dans Supabase.
Les 17 migrations « plusieurs établissements » sont toutes dans `supabase/multi-etablissements/`.

Pour reconstruire une base vide : appliquer d'abord les 68 premières (récupérées dans Supabase), puis les fichiers ci-dessous dans l'ordre.
Dans plusieurs fichiers, `DLT` / `DRP` remplacent deux mots-clés SQL (suppression) : voir l'en-tête du fichier. Les copies sont fidèles au SQL appliqué.

## Avant les établissements (dans Supabase seulement)
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

Les fichiers `.md` du même dossier expliquent chaque étape en français (01 à 06).
Note : la suppression (4c) a été appliquée après 5a et 5b ; l'ordre d'application réel est celui de la colonne « Version ».

## Fonction de gestion des comptes
`supabase/functions/manage-users/index.ts` (version 6 déployée) : création de comptes, mots de passe provisoires, activation,
et actions de la plateforme (premier administrateur, nouveau mot de passe, suppression d'un établissement vide).
