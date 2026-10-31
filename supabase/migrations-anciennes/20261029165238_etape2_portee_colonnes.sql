
alter table public.user_roles add column if not exists faculty_id bigint references public.faculties(id) on delete cascade;
alter table public.profiles add column if not exists faculty_id bigint references public.faculties(id) on delete set null;
alter table public.postes add column if not exists scope text not null default 'faculte' check (scope in ('faculte','universite'));
alter table public.announcements add column if not exists faculty_id bigint references public.faculties(id) on delete cascade;

