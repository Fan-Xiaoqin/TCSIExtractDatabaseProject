-- =====================================================
-- UNIT ENROLLMENTS AND AOUs
-- =====================================================

-- Unit Enrolments
CREATE TABLE unit_enrolments (
    unit_enrolment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_admission_id BIGINT NOT NULL REFERENCES hep_course_admissions(course_admission_id),
    uid16_unit_enrolments_res_key VARCHAR(10) NOT NULL,
    e354_unit_of_study_code VARCHAR(12),
    e489_unit_of_study_census_date DATE,
    e337_work_experience_in_industry_code VARCHAR(1),
    e551_summer_winter_school_code VARCHAR(1),
    e464_discipline_code VARCHAR(6),
    e355_unit_of_study_status_code VARCHAR(1) CHECK (
        e355_unit_of_study_status_code IN ('1','2','3','4','5','6')
    ),
    e329_mode_of_attendance_code VARCHAR(1) CHECK (
        e329_mode_of_attendance_code IN ('1','2','3','4','5','6','7')
    ),
    e477_delivery_location_postcode INTEGER,
    e660_delivery_location_country_code VARCHAR(4),
    e490_student_status_code VARCHAR(3),
    e392_maximum_student_contribution_code VARCHAR(1) CHECK (
        e392_maximum_student_contribution_code IN ('7','8','9','S')
    ),
    e622_UnitOfStudyYearLongIndicator BOOLEAN, -- Convert sample 0/1 to true /false when importing data from R
    e600_unit_of_study_commencement_date DATE,
    e601_unit_of_study_outcome_date DATE,
    a111_is_deleted BOOLEAN, -- need to covert sample 0/1 data values to true /false when importing data from R
    reporting_year INT NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_current BOOLEAN DEFAULT TRUE
);
-- Add trigger to keep is_current up to DATE
-- Trigger function
CREATE FUNCTION unit_enrolment_is_current()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE unit_enrolments
    SET is_current = FALSE
    WHERE uid16_unit_enrolments_res_key = NEW.uid16_unit_enrolments_res_key
        AND is_current = TRUE;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- Trigger
CREATE TRIGGER trg_unit_enrolment_is_current
BEFORE INSERT ON unit_enrolments
FOR EACH ROW
EXECUTE FUNCTION unit_enrolment_is_current();

-- Academic Organisations (AOUs) for Unit Enrolments
CREATE TABLE unit_enrolments_aous (
    aou_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    unit_enrolment_id BIGINT NOT NULL REFERENCES unit_enrolments(unit_enrolment_id),
    uid19_unit_enrolment_aous_res_key VARCHAR(10) NOT NULL,
    e333_aou_code VARCHAR(3),
    aou_e339_eftsl DECIMAL(10,9),
    aou_e384_amount_charged DECIMAL(7,2),
    aou_e381_amount_paid_upfront DECIMAL(7,2),
    aou_e529_loan_fee DECIMAL(7,2),
    aou_is_deleted BOOLEAN, -- need to covert sample 0/1 data values to true /false when importing data from R
    reporting_year INT NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_current BOOLEAN DEFAULT TRUE
);
-- Add trigger to keep is_current up to DATE
-- Trigger function
CREATE FUNCTION unit_enrolment_aou_is_current()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE unit_enrolments_aous
    SET is_current = FALSE
    WHERE uid19_unit_enrolment_aous_res_key = NEW.uid19_unit_enrolment_aous_res_key
        AND is_current = TRUE;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- Trigger
CREATE TRIGGER trg_unit_enrolment_aou_is_current
BEFORE INSERT ON unit_enrolments_aous
FOR EACH ROW
EXECUTE FUNCTION unit_enrolment_aou_is_current();