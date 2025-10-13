-- =====================================================
-- INDEXES FOR TCSI EXTRACT DATABASE
-- =====================================================

-- ======================
-- 1. Student Tables
-- ======================

-- FK join indexes
CREATE INDEX idx_student_citizenships_student_id
ON hep_student_citizenships(student_id);

CREATE INDEX idx_student_disabilities_student_id
ON hep_student_disabilities(student_id);

CREATE INDEX idx_student_contacts_first_address_student_id
ON student_contacts_first_reported_address(student_id);

CREATE INDEX idx_commonwealth_scholarships_student_id
ON commonwealth_scholarships(student_id);

-- Date range / current records for KPI
CREATE INDEX idx_hep_students_is_current
ON hep_students(is_current);


-- ======================
-- 2. Courses
-- ======================
-- FK join indexes
CREATE INDEX idx_hep_courses_course_of_study
ON hep_courses(uid3_courses_of_study_res_key);

CREATE INDEX idx_special_interest_courses_course
ON special_interest_courses(uid5_courses_res_key);

CREATE INDEX idx_course_fields_of_education_course
ON course_fields_of_education(uid5_courses_res_key);


-- ======================
-- 3. Course Admissions
-- ======================

-- FK join indexes
CREATE INDEX idx_hep_course_admissions_student
ON hep_course_admissions(student_id);

CREATE INDEX idx_hep_course_admissions_course
ON hep_course_admissions(uid5_courses_res_key);

CREATE INDEX idx_hep_course_admissions_is_current
ON hep_course_admissions(is_current);

-- Common filters for KPI
CREATE INDEX idx_hep_course_admissions_course_outcome
ON hep_course_admissions(e599_CourseOutcomeCode);

CREATE INDEX idx_hep_course_admissions_commencement
ON hep_course_admissions(e534_course_of_study_commencement_date);


-- ======================
-- 4. Scholarships and Loans
-- ======================

-- RTP scholarships
CREATE INDEX idx_rtp_scholarships_course_admission
ON rtp_scholarships(course_admission_id);

CREATE INDEX idx_rtp_scholarships_type
ON rtp_scholarships(e487_rtp_scholarship_type);

-- OS-HELP loans
CREATE INDEX idx_oshelp_course_admission
ON oshelp(course_admission_id);

CREATE INDEX idx_oshelp_status
ON oshelp(e490_student_status_code);

-- SA-HELP loans
CREATE INDEX idx_sahelp_student
ON sahelp(student_id);

CREATE INDEX idx_sahelp_status
ON sahelp(e490_student_status_code);

-- ======================
-- 5. Awards
-- ======================

-- Aggregated awards
CREATE INDEX idx_aggregated_awards_student
ON aggregated_awards(student_id);

CREATE INDEX idx_aggregated_awards_course
ON aggregated_awards(uid5_courses_res_key);

CREATE INDEX idx_aggregated_awards_outcome
ON aggregated_awards(e599_course_outcome_code);

-- Exit awards
CREATE INDEX idx_exit_awards_course_admission
ON exit_awards(course_admission_id);


-- ======================
-- 6. CAMPUS / FEES
-- ======================

-- FK join indexes
CREATE INDEX idx_hep_courses_on_campuses_course
ON hep_courses_on_campuses(uid5_courses_res_key);

CREATE INDEX idx_hep_courses_on_campuses_campus
ON hep_courses_on_campuses(uid2_campuses_res_key);

CREATE INDEX idx_campus_course_fees_itsp_courses_on_campus
ON campus_course_fees_itsp(uid4_courses_on_campus_res_key);


-- ======================
-- 7. UNIT ENROLLMENTS
-- ======================

-- FK join indexes
CREATE INDEX idx_unit_enrolments_course_admission
ON unit_enrolments(course_admission_id);

CREATE INDEX idx_unit_enrolments_reporting_year
ON unit_enrolments(reporting_year);

CREATE INDEX idx_unit_enrolments_aous_unit_enrolment
ON unit_enrolments_aous(unit_enrolment_id);