# Tests de Saytu

Deux familles de tests. Aucun ne touche aux données réelles.

## Interface (`tests/ui/`)
Playwright + Chromium, avec un **faux Supabase** (aucune connexion) : on ouvre `index.html` du dépôt et on vérifie les écrans.
Les captures sont écrites dans `tests/ui/out/` (non versionné).

Installation : `pip install playwright` puis `playwright install chromium` (ou `CHROMIUM=/chemin/chromium`).
Lancer un test : `python3 tests/ui/test_xxx.py [arguments]`

| Fichier | Vérifie | Arguments |
|---|---|---|
| `test_langue.py` | choix de la langue (français/arabe), sens d'écriture, mémorisation | — |
| `test_vocabulaire.py` | écran d'accueil et Établissement avec le vocabulaire choisi (faculté, UFR, école, institut) ; signale les mots restants | `vocabulaire langue`, ex. `ecole fr` ; listes séparées par des virgules |
| `test_vocabulaire_salles.py` | idem, sur la section des salles partagées | idem |
| `test_vocabulaire_visa.py` | idem, sur la section « Visa de la paie » | idem |
| `test_pdf_vocabulaire.py` | le vocabulaire s'applique aux PDF ; attendu `[True, True, False, True]` | — |
| `test_planning_salles.py` | planning : salles partagées, « Occupée », référentiel des salles | — |
| `test_plateforme_ipad.py` | tableau des établissements sans débordement (iPad, téléphone, arabe) ; attendu : deux nombres égaux | — |

`test_langue.py` contient aussi le faux Supabase (`stub=...`) que les autres tests relisent.
Quand l'écran change, ces tests servent d'alerte : relire les captures avant de conclure.

## Base de données (`tests/db/`)
Isolement entre comptes et entre établissements : `isolement.md` (mode d'emploi) et `isolement.sql` (les fonctions du schéma `saytu_tests`).
Après chaque changement de règles d'accès : recompter ce que voit chaque compte et comparer à la référence du 30/10/2026 ;
la différence doit être vide pour les comptes de l'UCAB.

Les essais de règles métier (conflits de salles, visa, suppression d'un établissement vide…) ont été faits dans la base,
chacun terminé par une erreur volontaire pour tout annuler. Ils ne sont pas conservés comme scripts : à refaire de la même façon si besoin.
