-- =====================================================
-- COURSE ADMISSION RELATED TABLES
-- =====================================================

-- Course Admission Details
CREATE TABLE hep_course_admissions (
    course_admission_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id BIGINT NOT NULL REFERENCES hep_students(student_id),
    uid15_course_admissions_res_key VARCHAR(10) NOT NULL,
    uid5_courses_res_key VARCHAR(10) NOT NULL REFERENCES hep_courses(uid5_courses_res_key),
    e599_CourseOutcomeCode VARCHAR(1) CHECK (
        e599_CourseOutcomeCode IN ('1','2','3','4','5','6','7')
    ),
    e592_CourseOutcomeDate DATE,
    e534_course_of_study_commencement_date DATE NOT NULL,
    e330_attendance_type_code VARCHAR(1),
    e591_hdr_thesis_submission_date DATE,
    e632_atar DECIMAL(4,2),
    e605_selection_rank DECIMAL(4,2),
    e620_highest_attainment_code VARCHAR(3),
    e594_hdr_primary_field_of_research_code VARCHAR(4),
    e595_hdr_secondary_field_of_research_code VARCHAR(4),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_current BOOLEAN DEFAULT TRUE
);

-- Basis for Admission
CREATE TABLE hep_basis_for_admission (
    uid17_basis_for_admission_res_key VARCHAR(10) PRIMARY KEY,
    course_admission_id BIGINT NOT NULL REFERENCES hep_course_admissions(course_admission_id),
    e327_basis_for_admission_code VARCHAR(2) NOT NULL CHECK (
        e327_basis_for_admission_code IN (
            '31','32','34','40','41','42','43')
    ),
    e609_effective_from_date DATE NOT NULL,
    e610_effective_to_date DATE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Course Prior Credits
CREATE TABLE hep_course_prior_credits (
    uid32_course_prior_credits_res_key VARCHAR(10) PRIMARY KEY,
    course_admission_id BIGINT NOT NULL REFERENCES hep_course_admissions(course_admission_id),
    e560_credit_used_value DECIMAL(4,3),
    e561_credit_basis VARCHAR(4) CHECK (
        e561_credit_basis IN ('0100','0200','0300','0400','0500','0600',
        '100','200','300','400','500','600')
    ),
    e566_credit_provider_code VARCHAR(4),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Course Specialisations
CREATE TABLE course_specialisations (
    uid33_course_specialisations_res_key VARCHAR(10) PRIMARY KEY,
    course_admission_id BIGINT NOT NULL REFERENCES hep_course_admissions(course_admission_id),
    e463_specialisation_code VARCHAR(6) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- HEP HDR End Users Engagement
CREATE TABLE hep_hdr_end_users_engagement (
    uid37_hdr_end_user_engagements_res_key VARCHAR(10) PRIMARY KEY,
    course_admission_id BIGINT NOT NULL REFERENCES hep_course_admissions(course_admission_id),
    e593_hdr_end_user_engagement_code VARCHAR(2) CHECK (
        e593_hdr_end_user_engagement_code IN ('03','07','08', '3','7','8')
    ),
    e609_hdr_end_user_engage_from_date DATE NOT NULL,
    e610_hdr_end_user_engage_to_date DATE,
    e798_hdr_days_of_engagement VARCHAR(4),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Main RTP Scholarships table (keeps core scholarship info)
CREATE TABLE rtp_scholarships (
    uid35_rtp_scholarships_res_key VARCHAR(10) PRIMARY KEY,
    course_admission_id BIGINT NOT NULL REFERENCES hep_course_admissions(course_admission_id),
    e487_rtp_scholarship_type VARCHAR(2) NOT NULL CHECK (
        e487_rtp_scholarship_type IN ('9','09','10','11')
    ),
    e609_rtp_scholarship_from_date DATE NOT NULL,
    e610_rtp_scholarship_to_date DATE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RTP Stipend table (linked to scholarships with type '10')
CREATE TABLE rtp_stipend (
    uid18_rtp_stipends_res_key VARCHAR(10) PRIMARY KEY,
    course_admission_id BIGINT NOT NULL REFERENCES hep_course_admissions(course_admission_id),
    e623_rtp_stipend_amount DECIMAL(9,2),
    e415_reporting_year INTEGER,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);