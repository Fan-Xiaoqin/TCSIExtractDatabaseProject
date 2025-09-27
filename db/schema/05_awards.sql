-- =====================================================
-- AWARDS AND OUTCOMES
-- =====================================================

-- Aggregated Awards
CREATE TABLE aggregated_awards (
    uid47_aggregate_awards_res_key VARCHAR(10) PRIMARY KEY,
    student_id BIGINT NOT NULL REFERENCES hep_students(student_id),
    uid5_courses_res_key VARCHAR(10) NOT NULL REFERENCES hep_courses(uid5_courses_res_key),
    e534_course_of_study_commencement_date DATE,
    e599_course_outcome_code VARCHAR(1) CHECK (
        e599_course_outcome_code IN ('1','2','3','4','5','6','7')
    ),
    e591_hdr_thesis_submission_date DATE,
    e592_course_outcome_date DATE,
    e329_mode_of_attendance_code VARCHAR(1) CHECK (
        e329_mode_of_attendance_code IN ('1','2','3','4','5','6','7')
    ),
    e330_attendance_type_code VARCHAR(1) CHECK (
        e330_attendance_type_code IN ('1','2')
    ),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Exit Awards
CREATE TABLE exit_awards (
    uid46_early_exit_awards_res_key VARCHAR(10) PRIMARY KEY,
    course_admission_id BIGINT NOT NULL REFERENCES hep_course_admissions(course_admission_id),
    uid5_courses_res_key VARCHAR(10) NOT NULL REFERENCES hep_courses(uid5_courses_res_key), -- Linked to courses following TCSI spec
    e599_course_outcome_code VARCHAR(1) CHECK (
        e599_course_outcome_code IN ('1','2','3','4','5','6','7')
    ),
    e592_course_outcome_date DATE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);