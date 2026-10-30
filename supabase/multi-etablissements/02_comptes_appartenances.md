# Étape 2 : comptes et appartenances (30/10/2026) — appliquée

Migration : `etablissements_etape2_comptes` (texte complet : 02_comptes_appartenances.sql).
Fonction de gestion des comptes `manage-users` : version 3.

- **Un compte par personne** (profiles : nom, e-mail, langue, mot de passe provisoire, établissement choisi).
- **Une appartenance par établissement** (memberships : poste, faculté, actif). Les colonnes poste_id, faculty_id
  et active ont quitté profiles (copie dans la sauvegarde).
- **Établissement de travail** : `current_establishment()` = celui choisi s'il y est actif, sinon sa première
  appartenance active. `my_establishments()` et `set_my_establishment()` ; bouton « Changer d'établissement »
  dans le menu du compte quand la personne en a plusieurs.
- **Rôles** : has_role, has_role_for, is_central_admin, sees_fac, my_roles, my_scope ne valent que dans
  l'établissement de travail ; un rôle « université » ne couvre que les facultés de son établissement.
- **Comptes** : vue `accounts` (comptes de l'établissement de travail) utilisée par l'application.
- **Garde-fous** : un compte partagé avec un autre établissement ne peut pas recevoir de nouveau mot de passe
  ni être forcé à le changer par un administrateur ; « désactiver » retire l'accès à son établissement seulement
  (le compte n'est bloqué que s'il n'a plus aucun établissement actif) ; créer un compte avec une adresse déjà
  utilisée ailleurs ajoute seulement l'appartenance (la personne garde son mot de passe).
- **Fiche enseignant** : reliée au compte dans le même établissement seulement.

Corrections faites au passage :
- admin_save_poste : en changeant les droits d'un poste de faculté, les droits devenaient « université » ;
  ils restent maintenant limités à la faculté de la personne.
- admin_link_teacher : ne délie plus les fiches des autres établissements.
- Journal : règle de lecture réécrite (par établissement, sans sous-requête ligne par ligne) : 0,25 s au lieu
  d'un dépassement de délai.

Vérifications : comptes existants identiques à la référence, sauf un compte désactivé qui ne voit plus rien
(avant, il ne pouvait déjà pas se connecter). Essai avec un 2e établissement fictif (annulé) : l'administrateur
UCAB ne voit ni ses facultés ni ses comptes ; le professeur partagé change d'établissement et n'a que les droits
de celui-ci ; un établissement non autorisé est refusé.

Reste pour l'étape 3 : règles d'accès de chaque table (ex. une fiche enseignant d'un autre établissement
reste visible à son propriétaire), lecture de app_settings, academic_years, postes, teacher_statuses
(aujourd'hui « tout le monde »), et les fonctions : admin_backup, admin_set_rights, can_review_department,
cancel_for_closure, closure_for_faculty, compare_faculties, new_academic_year, set_current_year.
