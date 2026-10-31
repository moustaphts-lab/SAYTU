alter table public.teachers add column if not exists availability_declared boolean not null default false;
update public.teachers t set availability_declared = exists (select 1 from public.teacher_availability a where a.teacher_id = t.id);
comment on column public.teachers.availability_declared is 'true = le professeur a rempli ses disponibilités : les plages enregistrées font foi (aucune plage = indisponible toute la semaine). false = rien déclaré : disponible partout.';
