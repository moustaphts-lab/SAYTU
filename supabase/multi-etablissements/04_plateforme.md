# Étape 4 : administrateur de la plateforme (30/10/2026) — appliquée

Migration : `etablissements_etape4_plateforme` (04_plateforme.sql). Fonction `manage-users` : version 4
(action `platform_create_admin`).

- Table `platform_admins` (aucune règle d'accès : seulement par fonctions). `is_platform_admin()`.
- `platform_establishments()` : fiche et activité de chaque établissement (comptes actifs, facultés,
  administrateurs centraux, dernière connexion) — aucune donnée d'enseignement ni de paie.
- `platform_create_establishment(code, nom, modèle)` : modèles « publique », « privee », « ecole »
  (postes, statuts d'enseignants, droits optionnels ; une école reçoit une faculté unique à son nom).
- `platform_attach_admin` + action `platform_create_admin` : premier administrateur central (nouveau compte avec
  mot de passe provisoire, ou compte existant qui garde son mot de passe).
- `platform_set_active` : un établissement désactivé n'est plus accessible à ses membres (données conservées).
- Application : onglet « Établissements » pour l'administrateur de la plateforme ; marque Saytu quand il n'a
  pas d'établissement ; écran de connexion neutre (plus le nom de l'établissement au-dessus de « Bonjour »).

Vérifications (essai annulé) : création d'une école, doublon et code invalide refusés ; l'administrateur de la
plateforme ne voit ni les postes ni les facultés du nouvel établissement ; le nouvel administrateur central y a
7 postes, 2 statuts, 1 faculté, son seul compte, ses réglages, et ne peut pas lister les établissements ;
après désactivation, il revient automatiquement à l'UCAB.
