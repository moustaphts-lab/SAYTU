# Étape 1 : établissements (30/10/2026) — appliquée

Migrations dans la base : `etablissements_etape1`, `etablissements_etape1b_unicites`, `etablissements_etape1c_coherence`.

- Table `establishments` ; l'UCAB est l'établissement n° 1 (code UCAB).
- Colonne `establishment_id` (remplie à 1 pour l'existant) sur :
  profiles, faculties, academic_years, postes, teacher_statuses, app_settings, calendar_closures,
  announcements, user_roles, audit_logs, departments, programs, courses, student_groups, teachers, payslips.
- Valeur par défaut : `current_establishment()` = établissement du compte connecté
  (tant qu'il n'existe qu'un établissement : celui-là).
- Recopie automatique depuis le parent (déclencheurs) : départements ← faculté, filières ← département,
  matières ← département, groupes ← filière, enseignants ← département, bulletins ← période ← faculté ;
  rôles, jours sans cours, annonces, profils ← faculté quand elle est renseignée.
- Unicités désormais par établissement (mêmes noms de contraintes, l'application traduit déjà les erreurs) :
  codes de faculté, département, filière, groupe, matière ; libellé d'année ; nom de poste ; code de statut ;
  e-mail et compte d'un enseignant ; numéro de bulletin ; rôles.
- Rien ne change à l'écran ; tests d'isolement : aucune différence pour les 37 comptes existants.

## À traiter aux étapes 2 et 3 (fonctions qui supposent un seul établissement)
admin_assign_poste, admin_backup, admin_delete_poste, admin_save_poste (×2), admin_set_rights, can_manage_user,
can_review_department, cancel_for_closure, closure_for_faculty, compare_faculties, has_role_for,
is_central_admin, new_academic_year, sees_fac, set_current_year, handle_new_user ; lecture de app_settings (id=1)
dans l'application. Règles d'accès : à cloisonner par établissement.
Performance : la règle de lecture du journal (audit_logs) appelle can_manage_user ligne par ligne (lente).
