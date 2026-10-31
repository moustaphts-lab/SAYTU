
update public.user_roles set faculty_id = (select id from public.faculties where code='FSRC') where faculty_id is null and role <> 'admin';
update public.profiles p set faculty_id = (select id from public.faculties where code='FSRC')
 where faculty_id is null and not exists (select 1 from public.user_roles r where r.user_id = p.id and r.role = 'admin');
update public.postes set name = 'Administrateur central', scope = 'universite' where name = 'Administrateur';
update public.postes set name = 'Doyen' where name = 'Direction générale';
update public.postes set scope = 'universite' where name = 'Contrôleur (consultation)';
insert into public.postes(name, roles, sort, scope) values ('Administrateur de faculté','{admin}',72,'faculte'),('Rectorat','{direction}',5,'universite') on conflict (name) do nothing;

