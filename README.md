# UCAB Touba – Enseignements

Application web de gestion universitaire : emplois du temps hebdomadaires, émargement électronique des professeurs, contrôle des heures, paie à l'heure et bulletins PDF.

- Interface : `index.html`, un fichier unique, sans étape de compilation.
- Données et sécurité : Supabase, projet « Gestion Enseignements Paie ». Les permissions sont vérifiées côté serveur.
- Comptes : la fonction `manage-users` (dossier `supabase/functions`) crée les comptes et réinitialise les mots de passe. Elle est déjà déployée sur Supabase et réservée aux administrateurs.

## Hébergement sur Cloudflare Pages

1. Cloudflare > Workers & Pages > Create > Pages > Connect to Git.
2. Choisir le dépôt `moustaphts-lab/UCAB`, branche `main`.
3. Framework preset : **None**. Build command : *(laisser vide)*. Build output directory : `/`.
4. Save and Deploy. Chaque modification poussée sur `main` est publiée automatiquement.

## Qui fait quoi

| Personne | Ce qu'elle fait dans l'application |
|---|---|
| Professeur | Émarge ses séances, indique ses disponibilités de la semaine, consulte ses heures et ses bulletins. |
| Directeur des études (enseigne aussi) | Saisit le référentiel, construit les emplois du temps, suit les heures. |
| Secrétaire | Assiste le directeur (référentiel, emplois du temps) et l'aide du responsable financier (validation des heures). |
| Aide du responsable financier | Valide les heures des professeurs de tous les départements. Peut émarger à la place des professeurs qui ne le font pas (saisie par délégation, avec la fiche de cours comme source). |
| Responsable financier | Tarifs, calcul et approbation de la paie, bulletins, paiements. |
| Administrateur (nommé par l'université) | Crée les comptes, attribue les rôles, réinitialise les mots de passe. N'a pas accès à la paie. |

Un rôle est un droit d'accès : une même personne peut en cumuler plusieurs. Personne ne peut valider ses propres heures, ni un émargement qu'il a saisi lui-même : une saisie par délégation est validée par un autre responsable (par exemple la secrétaire).

## Disponibilités des professeurs

Chaque professeur déclare dans « Mes disponibilités » les plages où il peut enseigner chaque semaine (plusieurs jours à la fois, précision facultative). Le directeur et la secrétaire les voient dans « Emplois du temps » : affichées par professeur, comptées dans un indicateur, et un créneau placé hors de ces plages est signalé « Hors disponibilités » (avertissement, pas un blocage). Sans plage déclarée, le professeur est considéré disponible à tout moment.

## Tableau de bord et exports

- Onglet « Tableau de bord » (directeur, secrétaire, aide, responsable financier) : séances prévues, taux d'émargement, heures validées, émargements à valider, séances sans émargement, heures par département et par enseignant, et pour la finance le reste dû. La période se choisit en haut.
- Exports Excel (.xlsx) et PDF : tableau de bord, heures validées, liste des émargements (selon le filtre affiché), paie d'une période (provisoire ou approuvée avec les règlements). Les heures sont en décimal dans Excel (1,5 = 1 h 30) pour pouvoir calculer.

## Règles de paie actuelles

- Tarif horaire selon le statut de l'enseignant (vacataire, maître-assistant, maître de conférences, professeur titulaire), avec exception individuelle possible.
- Tarifs historisés : un nouveau tarif prend effet à sa date, les séances antérieures gardent l'ancien.
- Périodes de paie libres, créées par le service financier.
- Seules les durées retenues des émargements validés sont payées. Une séance ne peut être payée qu'une fois.
- Net = brut (aucune retenue ni cotisation pour l'instant).
- Approbation par le responsable financier : les bulletins sont alors figés.

## Générateur d'emploi du temps (version simple)

Dans « Emplois du temps », le bouton « Générer automatiquement » propose des créneaux hebdomadaires pour les affectations qui n'ont pas encore assez de créneaux. Réglages : semestre, jours de cours, début et fin de journée, durée d'un créneau, pause, maximum d'heures par jour (groupe et professeur), respect des disponibilités. Le calcul se fait dans le navigateur : placement glouton qui respecte les conflits de professeur, de groupe et de salle, la capacité des salles et les disponibilités. Une proposition est affichée avec les cours non placés et la raison la plus fréquente ; rien n'est enregistré avant validation, puis les créneaux sont créés en brouillon (la base refuse encore tout conflit). Volume visé par semaine = heures prévues ÷ nombre de semaines du semestre, arrondi au créneau.

## Comptes de démonstration

Mot de passe commun : `Demo-2026!`

| Compte | Rôle |
|---|---|
| awa.ndiaye@univdemo.test | Professeure |
| directeur@univdemo.test | Directeur des études (enseigne aussi) |
| secretaire@univdemo.test | Secrétaire |
| aide.finance@univdemo.test | Aide du responsable financier |
| financier@univdemo.test | Responsable financier |
| admin@univdemo.test | Administrateur |

Les autres professeurs de démonstration : ibrahima.diallo, fatou.sow, cheikh.mbaye, mariama.ba, ousmane.faye (même domaine). Ces comptes sont à supprimer avant toute utilisation réelle.
