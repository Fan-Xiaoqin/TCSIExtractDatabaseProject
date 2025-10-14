-- =================== Relationship Recap ===================
-- hep_students.student_id
--   ⮕ hep_course_admissions.student_id
--       ⮕ unit_enrolments.course_admission_id
--           ⮕ unit_enrolments_aous.unit_enrolment_id
--===========================================================

-- INNER JOINs for mandatory relationships (students ↔ course_admissions)
-- LEFT JOINs for optional relationships (unit_enrolments ↔ aous)


-- This view combines all key fields needed for analysis
--student, admission, unit, and AOU-level details

CREATE OR REPLACE VIEW vw_consolidated_student_enrolment_data AS
SELECT
    -- ===============================
    -- Student-level information
    -- ===============================
    s.student_id,
    s.e313_student_identification_code AS student_code,
    s.e403_student_given_name_first AS first_name,
    s.e402_student_family_name AS family_name,
    s.e315_gender_code AS gender,
    s.e316_atsi_code AS atsi_code,
    s.e314_date_of_birth AS dob,
    s.e346_country_of_birth_code AS country_of_birth,
    s.e348_language_spoken_at_home_code AS language_home,
    s.e347_arrival_in_australia_year AS arrival_year,
    s.e572_year_left_school AS year_left_school,
    s.is_current AS student_is_current,

    -- ===============================
    -- Course Admission information
    -- ===============================
    ca.course_admission_id,
    ca.uid5_courses_res_key AS course_res_key,
    ca.e534_course_of_study_commencement_date AS commencement_date,
    ca.e632_atar AS atar,
    ca.e605_selection_rank AS selection_rank,
    ca.e599_courseoutcomecode AS course_outcome_code,
    ca.e592_courseoutcomedate AS course_outcome_date,
    ca.e330_attendance_type_code AS attendance_type_code,
    ca.e591_hdr_thesis_submission_date AS thesis_submission_date,
    ca.is_current AS admission_is_current,

    -- ===============================
    -- Unit Enrolment information
    -- ===============================
    ue.unit_enrolment_id,
    ue.uid16_unit_enrolments_res_key AS unit_res_key,
    ue.e354_unit_of_study_code AS unit_code,
    ue.e489_unit_of_study_census_date AS census_date,
    ue.e329_mode_of_attendance_code AS mode_of_attendance_code,
    ue.e355_unit_of_study_status_code AS unit_status_code,
    ue.e600_unit_of_study_commencement_date AS unit_commencement_date,
    ue.e601_unit_of_study_outcome_date AS unit_outcome_date,
    ue.reporting_year,
    ue.e622_UnitOfStudyYearLongIndicator AS is_year_long,
    ue.a111_is_deleted AS is_deleted_unit,
    ue.is_current AS unit_is_current,

    -- ============================================
    -- AOU (Academic Organisation Unit) information
    -- ============================================
    aou.aou_id,
    aou.uid19_unit_enrolment_aous_res_key AS aou_res_key,
    aou.e333_aou_code AS aou_code,
    aou.aou_e339_eftsl AS eftsl,
    aou.aou_e384_amount_charged AS amount_charged,
    aou.aou_e381_amount_paid_upfront AS amount_paid_upfront,
    aou.aou_e529_loan_fee AS loan_fee,
    aou.aou_is_deleted AS aou_is_deleted,
    aou.reporting_year AS aou_reporting_year,
    aou.is_current AS aou_is_current,

    -- ===============================
    -- Metadata (timestamps for audit)
    -- ===============================
    s.updated_at AS student_updated_at,
    ca.updated_at AS admission_updated_at,
    ue.updated_at AS unit_updated_at,
    aou.updated_at AS aou_updated_at

FROM hep_students s
JOIN hep_course_admissions ca
    ON s.student_id = ca.student_id
JOIN unit_enrolments ue
    ON ca.course_admission_id = ue.course_admission_id
LEFT JOIN unit_enrolments_aous aou
    ON ue.unit_enrolment_id = aou.unit_enrolment_id;