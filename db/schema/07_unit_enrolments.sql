-- =====================================================
-- UNIT ENROLLMENTS AND AOUs
-- =====================================================

-- Unit Enrolments
CREATE TABLE unit_enrolments (
    uid16_unit_enrolments_res_key VARCHAR(10) NOT NULL,
    uid15_course_admissions_res_key VARCHAR(10) REFERENCES hep_course_admissions(uid15_course_admissions_res_key),
    e354_unit_of_study_code VARCHAR(12),
    e489_unit_of_study_census_date DATE,
    e337_work_experience_in_industry_code VARCHAR(1),
    e551_summer_winter_school_code VARCHAR(1),
    e464_discipline_code VARCHAR(6),
    e355_unit_of_study_status_code VARCHAR(1),
    e329_mode_of_attendance_code VARCHAR(1),
    e477_delivery_location_postcode INTEGER,
    e660_delivery_location_country_code VARCHAR(4),
    e490_student_status_code VARCHAR(3),
    e392_maximum_student_contribution_code VARCHAR(1),
    e622_UnitOfStudyYearLongIndicator BOOLEAN,
    e600_unit_of_study_commencement_date DATE,
    e601_unit_of_study_outcome_date DATE,
    e446_remission_reason_code VARCHAR(2),
    --a130_loan_status VARCHAR(1),
    --uid21_student_loans_res_key VARCHAR(10),
    --e662_AdjustedLoanAmount DECIMAL(8,2),
    --e663_adjusted_loan_fee DECIMAL(8,2),
    e339_eftsl DECIMAL(10,9),


    -- Unit Enrolment Financial Data
    e384_amount_charged DECIMAL(7,2),
    e381_amount_paid_upfront DECIMAL(7,2),
    e558_help_loan_amount DECIMAL(7,2),
    e529_loan_fee DECIMAL(7,2),
    a111_is_deleted BOOLEAN, -- need to covert sample 0/1 data values to true /false when importing data from R
    
    reporting_year INT NOT NULL,
    as_at_month INT NOT NULL,
    extracted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    load_batch_id INT NOT NULL,

    PRIMARY KEY (uid16_unit_enrolments_res_key, as_at_month)
);

-- Academic Organisations (AOUs) for Unit Enrolments
CREATE TABLE unit_enrolments_aous (
    uid19_unit_enrolment_aous_res_key VARCHAR(10) NOT NULL,
    uid16_unit_enrolments_res_key VARCHAR(10) NOT NULL,
    e333_aou_code VARCHAR(3),
    aou_e339_eftsl DECIMAL(10,9),
    aou_e384_amount_charged DECIMAL(7,2),
    aou_e381_amount_paid_upfront DECIMAL(7,2),
    aou_e529_loan_fee DECIMAL(7,2),
    aou_is_deleted BOOLEAN, -- need to covert sample 0/1 data values to true /false when importing data from R

    as_at_month INT NOT NULL,
    extracted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    load_batch_id INT NOT NULL,
    reporting_year INT NOT NULL,

    PRIMARY KEY (uid19_unit_enrolment_aous_res_key, as_at_month),
    FOREIGN KEY (uid16_unit_enrolments_res_key, as_at_month) REFERENCES unit_enrolments(uid16_unit_enrolments_res_key, as_at_month)
);