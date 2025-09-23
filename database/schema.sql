PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS etl_load_history (
    load_id INTEGER PRIMARY KEY AUTOINCREMENT,
    extraction_timestamp TEXT NOT NULL,
    source_directory TEXT NOT NULL,
    loaded_at TEXT NOT NULL DEFAULT (datetime('now')),
    notes TEXT
);

CREATE TABLE IF NOT EXISTS dim_provider (
    provider_res_key TEXT PRIMARY KEY,
    provider_code TEXT,
    provider_type TEXT
);

CREATE TABLE IF NOT EXISTS dim_student (
    student_res_key TEXT PRIMARY KEY,
    provider_res_key TEXT NOT NULL,
    student_identifier TEXT,
    chessn TEXT,
    usi TEXT,
    usi_verification_status TEXT,
    tfn_verification_status TEXT,
    date_of_birth TEXT,
    family_name TEXT,
    given_name_first TEXT,
    given_name_others TEXT,
    residential_address_line1 TEXT,
    residential_address_suburb TEXT,
    residential_address_postcode TEXT,
    residential_address_state TEXT,
    residential_address_country TEXT,
    term_residence_postcode TEXT,
    term_residence_country TEXT,
    gender_code TEXT,
    atsi_code TEXT,
    country_of_birth_code TEXT,
    arrival_year TEXT,
    language_home_code TEXT,
    year_left_school TEXT,
    level_left_school TEXT,
    highest_ed_parent1 TEXT,
    highest_ed_parent2 TEXT,
    extraction_timestamp TEXT NOT NULL,
    FOREIGN KEY (provider_res_key) REFERENCES dim_provider(provider_res_key)
);

CREATE TABLE IF NOT EXISTS bridge_student_contact (
    student_contact_res_key TEXT PRIMARY KEY,
    student_res_key TEXT NOT NULL,
    provider_res_key TEXT NOT NULL,
    student_identifier TEXT,
    first_address_line1 TEXT,
    first_address_suburb TEXT,
    first_address_state TEXT,
    first_address_country TEXT,
    first_address_postcode TEXT,
    extraction_timestamp TEXT NOT NULL,
    FOREIGN KEY (student_res_key) REFERENCES dim_student(student_res_key),
    FOREIGN KEY (provider_res_key) REFERENCES dim_provider(provider_res_key)
);

CREATE TABLE IF NOT EXISTS bridge_student_citizenship (
    student_citizenship_res_key TEXT PRIMARY KEY,
    student_res_key TEXT NOT NULL,
    provider_res_key TEXT NOT NULL,
    student_identifier TEXT,
    chessn TEXT,
    citizen_resident_code TEXT,
    effective_from_date TEXT,
    effective_to_date TEXT,
    extraction_timestamp TEXT NOT NULL,
    FOREIGN KEY (student_res_key) REFERENCES dim_student(student_res_key),
    FOREIGN KEY (provider_res_key) REFERENCES dim_provider(provider_res_key)
);

CREATE TABLE IF NOT EXISTS bridge_student_disability (
    student_disability_res_key TEXT PRIMARY KEY,
    student_res_key TEXT NOT NULL,
    provider_res_key TEXT NOT NULL,
    student_identifier TEXT,
    chessn TEXT,
    disability_code TEXT,
    effective_from_date TEXT,
    effective_to_date TEXT,
    extraction_timestamp TEXT NOT NULL,
    FOREIGN KEY (student_res_key) REFERENCES dim_student(student_res_key),
    FOREIGN KEY (provider_res_key) REFERENCES dim_provider(provider_res_key)
);

CREATE TABLE IF NOT EXISTS dim_course_of_study (
    course_of_study_res_key TEXT PRIMARY KEY,
    provider_res_key TEXT NOT NULL,
    course_of_study_code TEXT,
    course_of_study_name TEXT,
    course_of_study_type TEXT,
    course_of_study_load TEXT,
    combined_course_indicator TEXT,
    FOREIGN KEY (provider_res_key) REFERENCES dim_provider(provider_res_key)
);

CREATE TABLE IF NOT EXISTS dim_course (
    course_res_key TEXT PRIMARY KEY,
    provider_res_key TEXT NOT NULL,
    course_of_study_res_key TEXT,
    course_code TEXT,
    course_name TEXT,
    standard_course_duration TEXT,
    cricos_code TEXT,
    effective_from_date TEXT,
    effective_to_date TEXT,
    FOREIGN KEY (provider_res_key) REFERENCES dim_provider(provider_res_key),
    FOREIGN KEY (course_of_study_res_key) REFERENCES dim_course_of_study(course_of_study_res_key)
);

CREATE TABLE IF NOT EXISTS dim_campus (
    campus_res_key TEXT PRIMARY KEY,
    provider_res_key TEXT NOT NULL,
    campus_suburb TEXT,
    campus_country_code TEXT,
    campus_postcode TEXT,
    first_effective_from_date TEXT,
    last_effective_to_date TEXT,
    FOREIGN KEY (provider_res_key) REFERENCES dim_provider(provider_res_key)
);

CREATE TABLE IF NOT EXISTS bridge_course_campus (
    course_campus_res_key TEXT PRIMARY KEY,
    provider_res_key TEXT NOT NULL,
    course_res_key TEXT NOT NULL,
    campus_res_key TEXT NOT NULL,
    campus_suburb TEXT,
    campus_country_code TEXT,
    campus_postcode TEXT,
    campus_effective_from TEXT,
    campus_effective_to TEXT,
    course_effective_from TEXT,
    course_effective_to TEXT,
    extraction_timestamp TEXT NOT NULL,
    FOREIGN KEY (provider_res_key) REFERENCES dim_provider(provider_res_key),
    FOREIGN KEY (course_res_key) REFERENCES dim_course(course_res_key),
    FOREIGN KEY (campus_res_key) REFERENCES dim_campus(campus_res_key)
);

CREATE TABLE IF NOT EXISTS bridge_course_field_of_education (
    course_field_res_key TEXT PRIMARY KEY,
    provider_res_key TEXT NOT NULL,
    course_of_study_res_key TEXT,
    course_res_key TEXT,
    course_code TEXT,
    course_of_study_name TEXT,
    field_of_education_code TEXT,
    field_of_education_supp_code TEXT,
    effective_from_date TEXT,
    effective_to_date TEXT,
    extraction_timestamp TEXT NOT NULL,
    FOREIGN KEY (provider_res_key) REFERENCES dim_provider(provider_res_key),
    FOREIGN KEY (course_res_key) REFERENCES dim_course(course_res_key),
    FOREIGN KEY (course_of_study_res_key) REFERENCES dim_course_of_study(course_of_study_res_key)
);

CREATE TABLE IF NOT EXISTS fact_course_admission (
    course_admission_res_key TEXT PRIMARY KEY,
    provider_res_key TEXT NOT NULL,
    student_res_key TEXT NOT NULL,
    course_res_key TEXT,
    student_identifier TEXT,
    course_code TEXT,
    course_name TEXT,
    course_of_study_code TEXT,
    course_of_study_type TEXT,
    course_commencement_date TEXT,
    attendance_type_code TEXT,
    mode_of_attendance_code TEXT,
    course_outcome_code TEXT,
    course_outcome_date TEXT,
    chessn TEXT,
    hdr_thesis_submission_date TEXT,
    atar REAL,
    selection_rank REAL,
    highest_attainment_code TEXT,
    hdr_primary_for_code TEXT,
    hdr_secondary_for_code TEXT,
    extraction_timestamp TEXT NOT NULL,
    FOREIGN KEY (provider_res_key) REFERENCES dim_provider(provider_res_key),
    FOREIGN KEY (student_res_key) REFERENCES dim_student(student_res_key),
    FOREIGN KEY (course_res_key) REFERENCES dim_course(course_res_key)
);

CREATE TABLE IF NOT EXISTS fact_course_prior_credit (
    course_prior_credit_res_key TEXT PRIMARY KEY,
    provider_res_key TEXT NOT NULL,
    course_admission_res_key TEXT NOT NULL,
    student_identifier TEXT,
    course_code TEXT,
    course_commencement_date TEXT,
    credit_used_value REAL,
    credit_basis TEXT,
    credit_provider_code TEXT,
    extraction_timestamp TEXT NOT NULL,
    FOREIGN KEY (provider_res_key) REFERENCES dim_provider(provider_res_key),
    FOREIGN KEY (course_admission_res_key) REFERENCES fact_course_admission(course_admission_res_key)
);

CREATE TABLE IF NOT EXISTS fact_course_specialisation (
    course_specialisation_res_key TEXT PRIMARY KEY,
    provider_res_key TEXT NOT NULL,
    course_admission_res_key TEXT NOT NULL,
    student_res_key TEXT,
    student_identifier TEXT,
    course_code TEXT,
    course_commencement_date TEXT,
    specialisation_code TEXT,
    extraction_timestamp TEXT NOT NULL,
    FOREIGN KEY (provider_res_key) REFERENCES dim_provider(provider_res_key),
    FOREIGN KEY (course_admission_res_key) REFERENCES fact_course_admission(course_admission_res_key)
);

CREATE TABLE IF NOT EXISTS fact_unit_enrolment (
    unit_enrolment_res_key TEXT PRIMARY KEY,
    provider_code TEXT,
    student_res_key TEXT,
    student_identifier TEXT,
    chessn TEXT,
    course_admission_res_key TEXT,
    course_of_study_code TEXT,
    course_of_study_type TEXT,
    course_res_key TEXT,
    course_code TEXT,
    course_name TEXT,
    course_commencement_date TEXT,
    unit_of_study_code TEXT,
    census_date TEXT,
    work_experience_code TEXT,
    summer_winter_school_code TEXT,
    discipline_code TEXT,
    unit_status_code TEXT,
    mode_of_attendance_code TEXT,
    delivery_location_postcode TEXT,
    delivery_location_country_code TEXT,
    student_status_code TEXT,
    max_student_contribution_code TEXT,
    year_long_indicator TEXT,
    unit_commencement_date TEXT,
    unit_outcome_date TEXT,
    remission_reason_code TEXT,
    loan_status TEXT,
    student_loan_res_key TEXT,
    adjusted_loan_amount REAL,
    adjusted_loan_fee REAL,
    eftsl REAL,
    amount_charged REAL,
    amount_paid_upfront REAL,
    help_loan_amount REAL,
    loan_fee REAL,
    is_deleted TEXT,
    extraction_timestamp TEXT NOT NULL,
    reporting_year TEXT,
    FOREIGN KEY (course_admission_res_key) REFERENCES fact_course_admission(course_admission_res_key)
);

CREATE TABLE IF NOT EXISTS fact_unit_enrolment_aou (
    unit_enrolment_aou_res_key TEXT PRIMARY KEY,
    unit_enrolment_res_key TEXT NOT NULL,
    aou_code TEXT,
    eftsl REAL,
    amount_charged REAL,
    amount_paid_upfront REAL,
    help_loan_amount REAL,
    loan_fee REAL,
    is_deleted TEXT,
    extraction_timestamp TEXT NOT NULL,
    reporting_year TEXT,
    FOREIGN KEY (unit_enrolment_res_key) REFERENCES fact_unit_enrolment(unit_enrolment_res_key)
);

CREATE TABLE IF NOT EXISTS fact_student_loan (
    student_loan_res_key TEXT PRIMARY KEY,
    provider_res_key TEXT,
    student_res_key TEXT,
    course_admission_res_key TEXT,
    loan_type TEXT,
    reporting_year TEXT,
    reporting_period TEXT,
    loan_amount REAL,
    loan_fee REAL,
    status_code TEXT,
    extraction_timestamp TEXT NOT NULL,
    FOREIGN KEY (provider_res_key) REFERENCES dim_provider(provider_res_key),
    FOREIGN KEY (student_res_key) REFERENCES dim_student(student_res_key),
    FOREIGN KEY (course_admission_res_key) REFERENCES fact_course_admission(course_admission_res_key)
);

CREATE TABLE IF NOT EXISTS fact_scholarship (
    scholarship_res_key TEXT PRIMARY KEY,
    provider_res_key TEXT,
    student_res_key TEXT,
    course_admission_res_key TEXT,
    student_identifier TEXT,
    scholarship_type TEXT,
    reporting_year TEXT,
    reporting_period TEXT,
    amount REAL,
    status_code TEXT,
    extraction_timestamp TEXT NOT NULL,
    FOREIGN KEY (provider_res_key) REFERENCES dim_provider(provider_res_key),
    FOREIGN KEY (student_res_key) REFERENCES dim_student(student_res_key),
    FOREIGN KEY (course_admission_res_key) REFERENCES fact_course_admission(course_admission_res_key)
);

CREATE TABLE IF NOT EXISTS fact_course_fee (
    campus_course_fee_res_key TEXT PRIMARY KEY,
    provider_res_key TEXT NOT NULL,
    course_campus_res_key TEXT,
    course_res_key TEXT,
    course_code TEXT,
    campus_suburb TEXT,
    indicative_student_contribution_csp REAL,
    indicative_tuition_fee_domestic_fp REAL,
    effective_from_date TEXT,
    campus_effective_from_date TEXT,
    extraction_timestamp TEXT NOT NULL,
    FOREIGN KEY (provider_res_key) REFERENCES dim_provider(provider_res_key),
    FOREIGN KEY (course_res_key) REFERENCES dim_course(course_res_key),
    FOREIGN KEY (course_campus_res_key) REFERENCES bridge_course_campus(course_campus_res_key)
);

CREATE TABLE IF NOT EXISTS fact_aggregated_award (
    aggregated_award_res_key TEXT PRIMARY KEY,
    provider_res_key TEXT,
    student_res_key TEXT,
    course_res_key TEXT,
    course_code TEXT,
    course_commencement_date TEXT,
    course_outcome_code TEXT,
    course_outcome_date TEXT,
    hdr_thesis_submission_date TEXT,
    attendance_type_code TEXT,
    mode_of_attendance_code TEXT,
    extraction_timestamp TEXT NOT NULL,
    FOREIGN KEY (provider_res_key) REFERENCES dim_provider(provider_res_key),
    FOREIGN KEY (student_res_key) REFERENCES dim_student(student_res_key),
    FOREIGN KEY (course_res_key) REFERENCES dim_course(course_res_key)
);

CREATE VIEW IF NOT EXISTS wide_student_course AS
SELECT
    fca.course_admission_res_key,
    fca.extraction_timestamp,
    fca.student_res_key,
    ds.student_identifier,
    ds.chessn,
    ds.gender_code,
    ds.date_of_birth,
    ds.residential_address_state,
    fca.course_code,
    fca.course_name,
    fca.course_commencement_date,
    fca.course_outcome_code,
    fca.course_outcome_date,
    fca.attendance_type_code,
    fue.census_date,
    fue.unit_of_study_code,
    fue.eftsl,
    fue.amount_charged,
    fue.help_loan_amount,
    fsl.amount AS scholarship_amount
FROM fact_course_admission fca
LEFT JOIN dim_student ds ON ds.student_res_key = fca.student_res_key
LEFT JOIN fact_unit_enrolment fue ON fue.course_admission_res_key = fca.course_admission_res_key
    AND fue.extraction_timestamp = fca.extraction_timestamp
LEFT JOIN fact_scholarship fsl ON fsl.course_admission_res_key = fca.course_admission_res_key
    AND fsl.extraction_timestamp = fca.extraction_timestamp;

CREATE INDEX IF NOT EXISTS idx_dim_student_provider ON dim_student(provider_res_key);
CREATE INDEX IF NOT EXISTS idx_fact_course_admission_student ON fact_course_admission(student_res_key);
CREATE INDEX IF NOT EXISTS idx_fact_unit_enrolment_course ON fact_unit_enrolment(course_admission_res_key);
CREATE INDEX IF NOT EXISTS idx_fact_course_prior_credit_admission ON fact_course_prior_credit(course_admission_res_key);
CREATE INDEX IF NOT EXISTS idx_fact_student_loan_admission ON fact_student_loan(course_admission_res_key);
CREATE INDEX IF NOT EXISTS idx_fact_scholarship_admission ON fact_scholarship(course_admission_res_key);
