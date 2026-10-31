-- Audit M5 : les logos (enregistrés en texte dans la base) sont limités côté serveur.
-- L'application réduit déjà l'image à 256 px ; la base refuse maintenant tout ce qui n'est pas une image PNG ou JPEG
-- en base64, ou qui dépasse 300 000 caractères (environ 220 Ko d'image).
alter table public.app_settings add constraint app_settings_logo_valide
  check (logo is null or (length(logo) <= 300000 and logo ~ '^data:image/(png|jpeg);base64,[A-Za-z0-9+/=]+$'));
alter table public.faculties add constraint faculties_logo_valide
  check (logo is null or (length(logo) <= 300000 and logo ~ '^data:image/(png|jpeg);base64,[A-Za-z0-9+/=]+$'));
