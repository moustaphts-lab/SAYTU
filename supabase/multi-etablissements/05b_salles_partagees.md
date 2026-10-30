# Étape 5b : salles partagées

- Réglage `app_settings.shared_rooms` (écran Établissement, à côté du vocabulaire). UCAB : désactivé (salles par faculté).
- Salle partagée = `rooms.faculty_id` nul ; `rooms.establishment_id` ajouté (rempli depuis la faculté, ou l'établissement en cours).
- Gestion : l'administrateur central (section « Salles partagées »). Les planificateurs les voient dans le Référentiel (lecture seule) et les choisissent dans leurs emplois du temps.
- Une faculté peut garder ses propres salles en plus des salles partagées.
- `shared_room_busy(semaine, faculté)` : créneaux pris par les autres facultés, sans détail (salle, jour, heures). Affichés « Occupée » dans l'onglet Salles, évités par le générateur et le glisser-déposer.
- `check_slot` : la salle doit être celle de la faculté ou une salle partagée de l'établissement ; un conflit avec une autre faculté ne donne aucun détail (« la salle est occupée par une autre faculté »).
- Tests (annulés) : création par l'administrateur central, lecture seule pour les facultés, conflit entre facultés refusé, salle d'une autre faculté refusée, invisible pour un autre établissement ; visibilité des salles identique à la référence.
