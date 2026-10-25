-- UCAB Touba : remise à zéro des données de démonstration et chargement d'un jeu d'essai réaliste
-- À exécuter UNE fois dans Supabase > SQL Editor (le script est une seule transaction : tout ou rien).
--
-- CONSERVE : comptes et rôles (profiles, user_roles), statuts d'enseignants, barème par statut,
--            salles, année 2026-2027 et ses semestres, « Jours et horaires », journal d'audit.
-- EFFACE   : départements, filières, groupes, matières, enseignants, affectations, emploi du temps,
--            séances, émargements, périodes de paie, bulletins, paiements, disponibilités, tarif individuel.
-- CRÉE     : 2 départements (Sciences religieuses ; Histoire et civilisation), 1 filière Licence 1 chacun,
--            1 groupe chacun, 14 matières du semestre 1 par département, 7 enseignants par département
--            (2 matières chacun) et les affectations correspondantes, prêtes pour le générateur.

begin;

-- 1. Effacement (ordre imposé par les liens entre tables)
delete from public.payments;
delete from public.payslips;
delete from public.payroll_items;
delete from public.attendance_records;
delete from public.pay_periods;
delete from public.schedule_sessions;
delete from public.timetable_slots;
delete from public.teaching_assignments;
delete from public.teacher_availability;
delete from public.hourly_rates where teacher_id is not null;
delete from public.teachers;
delete from public.courses;
delete from public.student_groups;
delete from public.programs;
update public.user_roles set department_id = null where department_id is not null;
delete from public.departments;
delete from public.semesters where academic_year_id in (select id from public.academic_years where not is_current);
delete from public.academic_years where not is_current;

-- 2. Départements, filières, groupes
insert into public.departments(code,name) values
  ('SREL','Département de sciences religieuses'),
  ('HIST','Département de l''Histoire et civilisation');

insert into public.programs(department_id,code,name,level)
  select id, code||'-L1', 'Licence 1 – '||case code when 'SREL' then 'Sciences religieuses' else 'Histoire et civilisation' end, 'Licence 1'
  from public.departments;

insert into public.student_groups(program_id,code,name,size)
  select p.id, p.code||'-A', 'Licence 1 '||d.code||' – Groupe A', case d.code when 'SREL' then 45 else 40 end
  from public.programs p join public.departments d on d.id=p.department_id;

-- 3. Matières du semestre 1 (14 par département) : n° d'ordre, code, intitulé, volume horaire
create temp table _c(dep text, n int, name text, h numeric) on commit drop;
insert into _c values
 ('SREL', 1,'Exégèse du Coran (Tafsir) I',36),
 ('SREL', 2,'Sciences du Coran (''Ulum al-Qur''an)',30),
 ('SREL', 3,'Hadith : lecture et commentaire I',30),
 ('SREL', 4,'Sciences du Hadith (Mustalah)',24),
 ('SREL', 5,'Jurisprudence malikite (Fiqh) I',36),
 ('SREL', 6,'Fondements du droit (Usul al-fiqh) I',30),
 ('SREL', 7,'Théologie (''Aqida)',30),
 ('SREL', 8,'Soufisme (Tasawwuf) : initiation',30),
 ('SREL', 9,'Biographie du Prophète (Sira)',24),
 ('SREL',10,'Grammaire arabe (Nahw) I',36),
 ('SREL',11,'Morphologie arabe (Sarf)',24),
 ('SREL',12,'Rhétorique arabe (Balagha) : initiation',24),
 ('SREL',13,'Méthodologie du travail universitaire',24),
 ('SREL',14,'Français : expression écrite et orale',30),
 ('HIST', 1,'Introduction à l''histoire et à ses méthodes',30),
 ('HIST', 2,'Histoire de l''Afrique ancienne',36),
 ('HIST', 3,'Empires et royaumes de l''Afrique de l''Ouest',36),
 ('HIST', 4,'Histoire du Sénégal précolonial',30),
 ('HIST', 5,'Colonisation et résistances en Afrique de l''Ouest',30),
 ('HIST', 6,'Civilisation islamique classique',36),
 ('HIST', 7,'L''islam en Afrique de l''Ouest',30),
 ('HIST', 8,'Histoire du mouridisme et de Touba',30),
 ('HIST', 9,'Sources orales et historiographie africaine',24),
 ('HIST',10,'Géographie historique de l''Afrique',24),
 ('HIST',11,'Initiation à l''archéologie',24),
 ('HIST',12,'Manuscrits arabes et ajami : initiation',24),
 ('HIST',13,'Histoire du monde contemporain',30),
 ('HIST',14,'Français : expression écrite et orale',30);

insert into public.courses(department_id,code,name,course_type,total_hours)
  select d.id, c.dep||'1'||lpad(c.n::text,2,'0'), c.name, 'CM', c.h
  from _c c join public.departments d on d.code=c.dep;

-- 4. Enseignants (7 par département)
create temp table _t(dep text, n int, fn text, ln text, st text, grade text) on commit drop;
insert into _t values
 ('SREL',1,'Cheikh Ahmadou','Fall','PR','Professeur titulaire'),
 ('SREL',2,'Abdoulaye','Sylla','MC','Docteur'),
 ('SREL',3,'Mame Diarra','Ndiaye','MA','Docteur'),
 ('SREL',4,'Ibrahima','Gaye','VAC','Master'),
 ('SREL',5,'Moustapha','Cissé','MC','Docteur'),
 ('SREL',6,'Aminata','Sow','VAC','Master'),
 ('SREL',7,'Mouhamadou Bamba','Niang','MA','Docteur'),
 ('HIST',1,'Ousseynou','Sarr','PR','Professeur titulaire'),
 ('HIST',2,'Fatou Binetou','Diouf','MC','Docteur'),
 ('HIST',3,'Samba','Ba','MA','Docteur'),
 ('HIST',4,'Mariama','Kane','VAC','Master'),
 ('HIST',5,'Alioune Badara','Thiam','VAC','Master'),
 ('HIST',6,'Khady','Faye','MA','Docteur'),
 ('HIST',7,'Pape Moussa','Seck','MC','Docteur');

insert into public.teachers(first_name,last_name,email,department_id,grade,status_id,active)
  select t.fn, t.ln,
         lower(translate(split_part(t.fn,' ',1)||'.'||replace(t.ln,' ',''),'éèêàâîïôùç','eeeaaiiouc'))||'.'||lower(t.dep)||'@ucab.test',
         d.id, t.grade, s.id, true
  from _t t join public.departments d on d.code=t.dep join public.teacher_statuses s on s.code=t.st;

-- 5. Affectations du semestre 1 : matières 1-2 → enseignant 1, 3-4 → enseignant 2, etc.
insert into public.teaching_assignments(semester_id,teacher_id,course_id,group_id,planned_hours)
  select (select s.id from public.semesters s join public.academic_years y on y.id=s.academic_year_id
           where y.is_current and s.label='Semestre 1'),
         te.id, co.id, g.id, co.total_hours
  from _c c
  join public.departments d on d.code=c.dep
  join public.courses co on co.code=c.dep||'1'||lpad(c.n::text,2,'0')
  join public.student_groups g on g.code=c.dep||'-L1-A'
  join _t t on t.dep=c.dep and t.n=(c.n+1)/2
  join public.teachers te on te.department_id=d.id and te.last_name=t.ln and te.first_name=t.fn;

commit;

-- Contrôle
select d.name as departement,
       (select count(*) from public.courses c where c.department_id=d.id) as matieres,
       (select count(*) from public.teachers t where t.department_id=d.id) as enseignants,
       (select count(*) from public.teaching_assignments a join public.courses c on c.id=a.course_id where c.department_id=d.id) as affectations
from public.departments d order by d.code;
