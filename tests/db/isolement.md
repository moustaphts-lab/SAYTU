# Tests d'isolement (schéma saytu_tests, dans la base)

Photographie de ce que chaque compte voit, table par table, avec les règles d'accès réelles.

- `saytu_tests.baseline` : référence prise le 30/10/2026, avant le passage à plusieurs établissements
  (37 comptes × 33 tables, 0 erreur).
- `saytu_tests.visibility(décalage, nombre, table)` : recompte ce que voient les comptes
  (par lots, la table audit_logs à part car ses règles sont lentes).
- `saytu_tests.current` puis `saytu_tests.diff()` : différences avec la référence.

Après chaque étape :
```sql
truncate saytu_tests.current;  -- (vider la table)
insert into saytu_tests.current select * from saytu_tests.visibility(0,40) on conflict do nothing;
insert into saytu_tests.current select * from saytu_tests.visibility(0,5,'audit_logs') on conflict do nothing; -- répéter par lots
select * from saytu_tests.diff();   -- doit être vide pour les comptes existants
```

Sauvegarde complète avant les changements : schéma `saytu_backup_20261030`
(copie de toutes les tables, des comptes auth, et de la structure dans `ddl` :
fonctions, règles d'accès, contraintes, index, déclencheurs, droits).
Code : étiquette Git `avant-multi-etablissements`.
