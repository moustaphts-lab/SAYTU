alter policy timetable_slots_select on public.timetable_slots using (published or (select is_planner()));
