# Étape 6 : circuit de paie configurable (visa)

Décision : validation des heures toujours manuelle ; calcul et approbation par le service financier (inchangé) ; seul le visa avant paiement se règle.

- `app_settings.payroll_visa_mode` : `aucun`, `faculte` (UCAB : doyen, activé faculté par faculté), `etablissement` (direction au niveau de l'établissement).
- `visa_required(faculté)` et `can_visa(faculté)` décident ; utilisées par `payment_needs_visa`, `visa_payroll` et `compare_faculties`.
- Modèles de départ : publique → `faculte`, privée → `etablissement`, école → `aucun`.
- Réglage : écran Établissement, section « Visa de la paie ». La case par faculté n'apparaît qu'en mode `faculte`.
- Tests (annulés) : mode faculté inchangé ; mode établissement : doyen refusé, paiement bloqué avant visa, visa par la direction puis paiement accepté ; mode aucun : paiement direct.
