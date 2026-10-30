# Étape 3 : cloisonnement de sécurité (30/10/2026) — appliquée

Migrations : `etablissements_etape3_cloisonnement`, `etablissements_etape3b_app_settings`,
`etablissements_etape3c_appartenances_lecture`, `etablissements_etape3d_compte_partage`
(texte principal : 03_cloisonnement.sql).

- Droits limités à l'établissement de travail : current_teacher_id (la fiche de cet établissement),
  is_finance_for, is_cashier_for, can_review_department (en plus de has_role, has_role_for, sees_fac… de l'étape 2).
  Toutes les règles d'accès qui passent par ces fonctions sont donc cloisonnées.
- Règles réécrites : années, réglages (app_settings), postes, statuts, facultés (administration), annonces,
  jours sans cours, rôles, appartenances (lues seulement dans l'établissement de travail).
- Écran de connexion sans compte : l'identité n'est montrée que tant qu'il n'existe qu'un établissement
  (l'étape 4 rendra l'écran neutre, aux couleurs de Saytu).
- app_settings : une ligne par établissement (plus de contrainte « id = 1 »).
- Fonctions corrigées : set_current_year, new_academic_year, admin_set_rights, admin_backup (sauvegarde de
  l'établissement seulement), closure_for_faculty, closure_for, cancel_for_closure, compare_faculties,
  keep_one_admin (au moins un administrateur par établissement), admin_departure_check.
- is_shared_account ne renseigne que l'administrateur qui gère le compte.

Vérifications (base réelle, essais annulés ensuite) :
- Les 36 comptes actifs voient exactement la même chose que la référence d'avant les travaux.
- Avec un 2e établissement fictif complet (faculté, année, semestre, département, filière, groupe, matière, salle,
  enseignant, affectation, créneau, séance, jour sans cours, annonce, poste, statut, réglages) :
  - administrateur, directeur des études, financier et professeur de l'UCAB : rien ne change pour eux ;
  - le compte partagé, une fois dans l'autre établissement, ne voit que ses données (1 de chaque) ;
  - sa sauvegarde ne contient que son établissement ; celle de l'UCAB que l'UCAB ;
  - refusés : mettre l'année de l'UCAB en cours, créer une faculté dans l'UCAB, modifier les réglages ou une
    faculté de l'autre établissement (dans les deux sens).
- Conseiller sécurité Supabase : aucune alerte grave (seulement des informations déjà connues).
