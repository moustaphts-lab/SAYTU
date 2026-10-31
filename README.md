# Saytu

*Saytu* (« surveiller, veiller sur » en wolof) : emplois du temps, émargement des professeurs, contrôle des heures et paie pour une université de plusieurs facultés. Le nom et le logo de l'établissement se règlent dans Établissement › Identité ; ceux de chaque faculté dans Ma faculté.

- Interface : `index.html`, un fichier unique, sans étape de compilation.
- Identité : logo « l'œil qui veille » coiffé d'une toque (pupille en forme de coche), vert profond #0B5C4C et sable #D9A441 ; fichiers dans `icons/` (logo.svg, favicon.svg, icônes d'application) et `manifest.webmanifest` (ajout à l'écran d'accueil).
- Données et sécurité : Supabase. Toutes les permissions sont vérifiées côté serveur (règles d'accès et fonctions de la base).
- Comptes : la fonction `manage-users` (dossier `supabase/functions`) crée les comptes et réinitialise les mots de passe. Elle est réservée à l'administrateur.

## Hébergement sur Cloudflare Pages

1. Cloudflare > Workers & Pages > Create > Pages > Connect to Git.
2. Choisir le dépôt `moustaphts-lab/saytu`, branche `main`, nom du projet `saytu`.
3. Framework preset : **None**. Build command : *(vide)*. Build output directory : `/`.
4. Chaque modification poussée sur `main` est publiée automatiquement.

## Facultés

L'application gère une université de plusieurs facultés. Chaque faculté a ses départements, filières, groupes, matières, salles, semestres, jours et horaires, et jours sans cours. Les membres d'une faculté ne voient rien des autres facultés (règles vérifiées dans la base).

- **Administrateur central** : crée les facultés, nomme leurs administrateurs, règle ce qui est commun (identité, années, postes, droits optionnels, jours sans cours de toute l'université, sauvegarde).
- **Administrateur de faculté** : comptes et postes de sa faculté, nom et logo de sa faculté.
- **Directeur des études de la faculté** : référentiel, affectations et emplois du temps de sa faculté.
- **Doyen** : synthèse, suivi et visa de la paie de sa faculté. **Rectorat** (et services centraux en consultation) : « Comparaison des facultés » (avancement, émargement, annulations, heures validées, paie, visas en attente), puis le détail de chaque faculté.
- **Emploi du temps** : chaque faculté choisit le mode **hebdomadaire** (refait chaque semaine) ou **fixe** (une semaine publiée pour tout le semestre, disponibilités données une fois par semestre).
- **Paie** : chaque faculté a ses tarifs, ses périodes, ses bulletins (numérotés `CODE-ANNÉE-001`, ex. `FSRC-2026-001`) et son budget. L'administrateur de la faculté décide si le visa du doyen est obligatoire avant les paiements. Les statuts d'enseignants sont communs à l'université. La paie est faite dans chaque faculté par son **représentant financier** (et son caissier) ; le **responsable financier de l'université** consulte et contrôle la paie de toutes les facultés, sans pouvoir la modifier.

## Postes et droits

Un **poste** est un nom choisi par l'établissement (Directeur des études, Trésorier, Scolarité…) posé sur une combinaison de **droits**. L'administrateur crée, renomme et modifie les postes dans **Établissement › Postes**. Une personne peut aussi « enseigner » en plus de son poste.

| Droit | Ce qu'il permet |
|---|---|
| Enseigner | Aujourd'hui, Mon emploi du temps (grille, liste et émargement), Mes disponibilités, Heures et paiements, demandes d'absence |
| Référentiel et emplois du temps | Référentiel, jours sans cours, affectations, génération et publication des semaines, annonces, demandes d'absence |
| Validation des heures | Contrôle des émargements (lot des conformes, signalements, relances, prêt pour la paie), émargement par délégation ; limitable à un département |
| Paie, tarifs et paiements | Périodes de paie, calcul, vérifications, approbation, paiements en lot, ordre de paiement, budget |
| Direction générale | Synthèse, avancement par filière, suivi des enseignements, rapport mensuel, budget, visa de la paie |
| Administration des comptes | Comptes, postes, établissement (identité, logo, année, sauvegarde), journal ; sans accès aux montants de paie |
| *Optionnels* (à activer dans Établissement) | **Chef de département** (consultation et validation de son département), **Caissier** (paiements seulement), **Consultation** (tout voir sans rien modifier) |

Règles constantes : personne ne valide ses propres heures ni un émargement qu'il a saisi ; une paie approuvée est figée ; si la faculté l'a activée, aucun paiement n'est enregistré avant le visa du doyen.

## Fonctionnement d'une semaine

1. Les professeurs déclarent leurs disponibilités de la semaine suivante.
2. Le directeur des études génère ou reprend la semaine précédente, ajuste par glisser-déposer, vérifie, puis publie. Les jours sans cours du calendrier sont exclus. Un événement imprévu se déclare en jour sans cours : l'application propose d'annuler en une fois les cours déjà placés (séances émargées protégées) et de prévenir les professeurs.
3. Après chaque cours, le professeur émarge (« J'ai fait ce cours »).
4. L'aide du responsable financier valide les émargements conformes en lot et examine les autres.
5. En fin de mois, le responsable financier calcule, vérifie, approuve ; la direction vise ; les paiements sont enregistrés et les professeurs prévenus.

## Organisation du dépôt

| Où | Quoi |
|---|---|
| `index.html` | l'application (un fichier, sans compilation) |
| `i18n-ar.js`, `i18n-ar-gestion.js`, `pdf-ar.js` | traduction arabe des écrans et des PDF |
| `icons/`, `fonts/`, `manifest.webmanifest` | logo, polices, ajout à l'écran d'accueil |
| `supabase/MIGRATIONS.md` | liste ordonnée des migrations de la base et où lire leur SQL |
| `supabase/migrations-anciennes/` | les 68 premières migrations, copiées de la base et vérifiées par empreinte (`verifier.py`) |
| `supabase/multi-etablissements/` | SQL et notes des étapes « plusieurs établissements » (01 à 06) |
| `supabase/functions/manage-users/` | fonction de gestion des comptes (déployée sur Supabase) |
| `supabase/archives/`, `supabase/postes_et_nettoyage.sql` | anciens scripts, déjà exécutés, gardés pour mémoire |
| `tests/` | tests d'interface (`tests/ui`) et d'isolement de la base (`tests/db`) : voir `tests/README.md` |

Déploiement : pousser sur `main` publie le site (Cloudflare Pages). La base et la fonction de comptes se changent dans Supabase, pas par le dépôt :
toute modification de base doit aussi être copiée dans `supabase/` avec son numéro d'étape.

## Comptes de démonstration

Mot de passe commun : `Demo-2026!`. Ils s'affichent sur l'écran de connexion tant que la case « Afficher les comptes de démonstration » est cochée dans Établissement. **À décocher, et ces comptes à désactiver, avant toute utilisation réelle.**

| Compte | Poste |
|---|---|
| ousmane.faye@univdemo.test | Professeur (cours programmés) |
| directeur@univdemo.test | Directeur des études |
| secretaire@univdemo.test | Secrétaire |
| aide.finance@univdemo.test | Aide du responsable financier |
| financier@univdemo.test | Représentant financier (FSRC) |
| direction@univdemo.test | Direction générale |
| admin@univdemo.test | Administrateur |
