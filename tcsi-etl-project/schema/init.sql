-- Master schema loader
-- Run this file to create the full TCSI schema in order

\i 01_students.sql
\i 02_courses.sql
\i 03_course_admissions.sql
\i 04_loans.sql
\i 05_awards.sql
\i 06_campuses.sql
\i 07_unit_enrolments.sql
-- Indexes and performance optimizations
\i 08_indexes.sql
-- Wide table view
\i 09_view.sql
-- Triggers for maintaining is_current and referential integrity
\i 10_triggerinfo-student.sql
\i 11_triggerinfo-courses.sql
\i 12_multiple_is_current_triggers.sql