-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Student Related Tables
-- =====================================================

-- hep_students
CREATE INDEX idx_students_res_key ON hep_students(uid8_students_res_key);
CREATE INDEX idx_students_identification ON hep_students(e313_student_identification_code);

-- hep_student_citizenships
CREATE INDEX idx_citizenship_student_id ON hep_student_citizenships(student_id);
CREATE INDEX idx_citizenship_code ON hep_student_citizenships(e358_citizen_resident_code);

-- hep_student_disabilities
CREATE INDEX idx_disabilities_student_id ON hep_student_disabilities(student_id);

-- student_contacts_first_reported_address
CREATE INDEX idx_first_address_student_id ON student_contacts_first_reported_address(student_id);

-- commonwealth_scholarships
CREATE INDEX idx_commonwealth_student_id ON commonwealth_scholarships(student_id);
CREATE INDEX idx_commonwealth_year ON commonwealth_scholarships(e415_reporting_year);


-- Course Related Tables
-- =====================================================

-- courses_of_study
CREATE INDEX idx_courses_of_study_code ON courses_of_study(e533_course_of_study_code);

-- hep_courses
CREATE INDEX idx_courses_of_study_fk ON hep_courses(uid3_courses_of_study_res_key);
CREATE INDEX idx_course_code ON hep_courses(e307_course_code);

-- special_interest_courses
CREATE INDEX idx_special_interest_course_fk ON special_interest_courses(uid5_courses_res_key);

-- course_fields_of_education
CREATE INDEX idx_course_fields_course_fk ON course_fields_of_education(uid5_courses_res_key);
CREATE INDEX idx_field_of_education_code ON course_fields_of_education(e461_field_of_education_code);


-- Course Admission Related
-- =====================================================

-- hep_course_admissions
CREATE INDEX idx_course_admissions_student_id ON hep_course_admissions(student_id);
CREATE INDEX idx_course_admissions_course_fk ON hep_course_admissions(uid5_courses_res_key);
CREATE INDEX idx_course_admissions_res_key ON hep_course_admissions(uid15_course_admissions_res_key);

-- hep_basis_for_admission
CREATE INDEX idx_basis_for_admission_fk ON hep_basis_for_admission(course_admission_id);

-- hep_course_prior_credits
CREATE INDEX idx_prior_credits_fk ON hep_course_prior_credits(course_admission_id);

-- course_specialisations
CREATE INDEX idx_specialisations_fk ON course_specialisations(course_admission_id);

-- hep_hdr_end_users_engagement
CREATE INDEX idx_hdr_engagement_fk ON hep_hdr_end_users_engagement(course_admission_id);

-- rtp_scholarships
CREATE INDEX idx_rtp_scholarships_fk ON rtp_scholarships(course_admission_id);

-- rtp_stipend
CREATE INDEX idx_rtp_stipend_fk ON rtp_stipend(course_admission_id);
CREATE INDEX idx_rtp_stipend_year ON rtp_stipend(e415_reporting_year);


-- Student Loans
-- =====================================================

-- oshelp
CREATE INDEX idx_oshelp_course_fk ON oshelp(course_admission_id);
CREATE INDEX idx_oshelp_res_key ON oshelp(uid21_student_loans_res_key);

-- sahelp
CREATE INDEX idx_sahelp_student_id ON sahelp(student_id);
CREATE INDEX idx_sahelp_res_key ON sahelp(uid21_student_loans_res_key);


-- Campuses & Courses on Campus
-- =====================================================

-- campuses
CREATE INDEX idx_campuses_country ON campuses(e644_campus_country_code);

-- hep_courses_on_campuses
CREATE INDEX idx_courses_on_campus_course_fk ON hep_courses_on_campuses(uid5_courses_res_key);
CREATE INDEX idx_courses_on_campus_campus_fk ON hep_courses_on_campuses(uid2_campuses_res_key);

-- campus_course_fees_itsp
CREATE INDEX idx_campus_fees_course_campus_fk ON campus_course_fees_itsp(uid4_courses_on_campus_res_key);

-- campuses_tac
CREATE INDEX idx_campuses_tac_fk ON campuses_tac(uid4_courses_on_campus_res_key);


-- Unit Enrollments
-- =====================================================

-- unit_enrolments
CREATE INDEX idx_unit_enrolments_course_admission_fk ON unit_enrolments(course_admission_id);
CREATE INDEX idx_unit_enrolments_res_key ON unit_enrolments(uid16_unit_enrolments_res_key);
CREATE INDEX idx_unit_enrolments_reporting_year ON unit_enrolments(reporting_year);

-- unit_enrolments_aous
CREATE INDEX idx_aous_unit_enrolment_fk ON unit_enrolments_aous(unit_enrolment_id);
CREATE INDEX idx_aous_res_key ON unit_enrolments_aous(uid19_unit_enrolment_aous_res_key);
CREATE INDEX idx_aous_reporting_year ON unit_enrolments_aous(reporting_year);
