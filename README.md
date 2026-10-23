# UCAB Enseignements

Application web de gestion universitaire : emplois du temps hebdomadaires, émargement électronique des professeurs, contrôle des heures, paie à l'heure et bulletins PDF.

- Interface : `index.html`, un fichier unique, sans étape de compilation.
- Données et sécurité : Supabase, projet « Gestion Enseignements Paie ». Les permissions sont vérifiées côté serveur.

## Hébergement sur Cloudflare Pages

1. Cloudflare > Workers & Pages > Create > Pages > Connect to Git.
2. Choisir le dépôt `moustaphts-lab/UCAB`, branche `main`.
3. Framework preset : **None**. Build command : *(laisser vide)*. Build output directory : `/`.
4. Save and Deploy. Chaque modification poussée sur `main` est publiée automatiquement.

## Règles de paie actuelles

- Tarif horaire selon le statut de l'enseignant (vacataire, maître-assistant, maître de conférences, professeur titulaire), avec exception individuelle possible.
- Tarifs historisés : un nouveau tarif prend effet à sa date, les séances antérieures gardent l'ancien.
- Périodes de paie libres, créées par le service financier.
- Seules les durées retenues des émargements validés sont payées. Une séance ne peut être payée qu'une fois.
- Net = brut (aucune retenue ni cotisation pour l'instant).
- Approbation par le service financier : les bulletins sont alors figés.

## Comptes de démonstration

Mot de passe commun : `Demo-2026!`

| Compte | Rôle |
|---|---|
| awa.ndiaye@univdemo.test | Professeure (Informatique) |
| resp.info@univdemo.test | Responsable Informatique et professeur |
| resp.gd@univdemo.test | Responsable Gestion et Droit |
| planif@univdemo.test | Emplois du temps |
| finance@univdemo.test | Service financier |
| direction@univdemo.test | Direction |
| admin@univdemo.test | Administrateur |

Ces comptes sont à supprimer avant toute utilisation réelle.

## Remarque sur la clé Supabase

La clé présente dans `index.html` est la clé publique (publishable) : elle est faite pour être dans le navigateur. La protection des données repose sur les règles de sécurité de la base (RLS) et les fonctions contrôlées.
