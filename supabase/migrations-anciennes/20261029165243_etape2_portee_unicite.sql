alter table public.user_roles drop constraint user_roles_user_id_role_department_id_key;
alter table public.user_roles add constraint user_roles_unique_scope unique nulls not distinct (user_id, role, department_id, faculty_id);
