create or replace view public.slot_conflicts with (security_invoker = true) as
 SELECT a.id AS slot_a, b.id AS slot_b, a.day_of_week,
   CASE WHEN a.room_id = b.room_id THEN 'salle'::text WHEN ta.teacher_id = tb.teacher_id THEN 'professeur'::text ELSE 'groupe'::text END AS conflict_type,
   a.week_start
 FROM timetable_slots a
 JOIN timetable_slots b ON a.id < b.id AND a.week_start = b.week_start AND a.day_of_week = b.day_of_week AND a.start_time < b.end_time AND b.start_time < a.end_time
 JOIN teaching_assignments ta ON ta.id = a.assignment_id
 JOIN teaching_assignments tb ON tb.id = b.assignment_id
 WHERE a.room_id = b.room_id OR ta.teacher_id = tb.teacher_id OR ta.group_id = tb.group_id;
