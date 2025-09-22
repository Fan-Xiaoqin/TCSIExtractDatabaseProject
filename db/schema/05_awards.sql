-- =====================================================
-- AWARDS AND OUTCOMES
-- =====================================================

-- Aggregated Awards
CREATE TABLE aggregated_awards (
    uid47_aggregate_awards_res_key VARCHAR(10) PRIMARY KEY,
    student_key BIGINT NOT NULL REFERENCES hep_students(student_key),
    uid5_courses_res_key VARCHAR(10) NOT NULL REFERENCES hep_courses(uid5_courses_res_key),
    --- Linked to student and course rather than course admission following TCSI spec
    e534_course_of_study_commencement_date DATE,
    e599_course_outcome_code VARCHAR(1),
    e591_hdr_thesis_submission_date DATE,
    e592_course_outcome_date DATE,
    e329_mode_of_attendance_code VARCHAR(1),
    e330_attendance_type_code VARCHAR(1)
);

-- Exit Awards
CREATE TABLE exit_awards (
    uid46_early_exit_awards_res_key VARCHAR(10) PRIMARY KEY,
    uid15_course_admissions_res_key VARCHAR(10) REFERENCES hep_course_admissions(uid15_course_admissions_res_key),
    uid5_courses_res_key VARCHAR(10) REFERENCES hep_courses(uid5_courses_res_key), -- Linked to courses following TCSI spec
    e599_course_outcome_code VARCHAR(1),
    e592_course_outcome_date DATE
);