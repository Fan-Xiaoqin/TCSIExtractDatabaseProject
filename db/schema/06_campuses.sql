-- =====================================================
-- CAMPUS AND LOCATION TABLES
-- =====================================================

-- Campuses
CREATE TABLE campuses (
    uid2_campuses_res_key VARCHAR(10) PRIMARY KEY,
    e525_campus_suburb VARCHAR(48) NOT NULL,
    e644_campus_country_code VARCHAR(4) NOT NULL,
    e559_campus_postcode VARCHAR(4),
    e569_campus_operation_type VARCHAR(2) CHECK (
        e569_campus_operation_type IN ('01','02','1','2')
    ),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Courses on Campuses
CREATE TABLE hep_courses_on_campuses (
    uid4_courses_on_campus_res_key VARCHAR(10) PRIMARY KEY,
    uid2_campuses_res_key VARCHAR(10) NOT NULL REFERENCES campuses(uid2_campuses_res_key),
    uid5_courses_res_key VARCHAR(10) NOT NULL REFERENCES hep_courses(uid5_courses_res_key),
    e597_cricos_code VARCHAR(7),
    e570_principal_offshore_delivery_mode VARCHAR(2) CHECK (
        e570_principal_offshore_delivery_mode IN ('01','02','03', '04','1','2','3','4')
    ),
    e571_offshore_delivery_code VARCHAR(2) CHECK (
        e571_offshore_delivery_code IN ('01','02','1','2')
    ),
    e609_effective_from_date DATE NOT NULL,
    e610_effective_to_date DATE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Campus Course Fees ITSP
CREATE TABLE campus_course_fees_itsp (
    uid31_campus_course_fees_res_key VARCHAR(10) PRIMARY KEY,
    uid4_courses_on_campus_res_key VARCHAR(10) NOT NULL REFERENCES hep_courses_on_campuses(uid4_courses_on_campus_res_key),
    e536_course_fees_code VARCHAR(1) CHECK (
        e536_course_fees_code IN ('0','1','2','3')
    ),
    e495_indicative_student_contribution_csp VARCHAR(9),
    e496_indicative_tuition_fee_domestic_fp DECIMAL(9,2),
    e609_effective_from_date DATE NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Campuses TAC
CREATE TABLE campuses_tac (
    uid40_courses_on_campus_tac_res_key VARCHAR(10) PRIMARY KEY,
    uid4_courses_on_campus_res_key VARCHAR(10) NOT NULL REFERENCES hep_courses_on_campuses(uid4_courses_on_campus_res_key),
    e557_tac_offer_code VARCHAR(1) CHECK (
        e557_tac_offer_code IN ('Q','S','T','U','V')
    ), -- Sample e557 values consist of 'TRUE'. Should we proceed with TCSI spec or sample data?
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);