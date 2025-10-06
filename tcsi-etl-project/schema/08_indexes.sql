-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Course and admission indexes
CREATE INDEX idx_course_admissions_student ON hep_course_admissions(student_id);
CREATE INDEX idx_course_admissions_course ON hep_course_admissions(uid5_courses_res_key);

-- Course code indexes
CREATE INDEX idx_courses_code ON hep_courses(e307_course_code);
CREATE INDEX idx_courses_of_study_code ON courses_of_study(e533_course_of_study_code);

-- Student lookup indexes
CREATE INDEX idx_students_identification_code ON hep_students(e313_student_identification_code);
CREATE INDEX idx_students_chessn ON hep_students(e488_chessn);
CREATE INDEX idx_students_usi ON hep_students(e584_usi);

-- Unit enrolments indexes

-- For filtering/grouping by unit of study
CREATE INDEX idx_unit_enrolments_unit ON unit_enrolments (e354_unit_of_study_code);
-- For linking enrolments back to course admissions
CREATE INDEX idx_unit_enrolments_year_unit ON unit_enrolments (reporting_year, e354_unit_of_study_code);
-- For AOU reporting
CREATE INDEX idx_unit_enrolments_aous_aou ON unit_enrolments_aous (e333_aou_code);