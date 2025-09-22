-- =====================================================
-- STUDENT RELATED TABLES
-- =====================================================

-- HEP Students (Master table for student details)
CREATE TABLE hep_students (
    student_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    uid8_students_res_key VARCHAR(10),
    e313_student_identification_code VARCHAR(10) NOT NULL,
    e488_chessn VARCHAR(10),
    e584_usi VARCHAR(10),
    a170_usi_verification_status VARCHAR(8),
    a167_tfn_verification_status VARCHAR(8),
    e314_date_of_birth DATE,
    e402_student_family_name VARCHAR(40),
    e403_student_given_name_first VARCHAR(40),
    e404_student_given_name_others VARCHAR(40),
    e410_residential_address_line1 VARCHAR(255),
    e469_residential_address_suburb VARCHAR(48),
    e320_residential_address_postcode VARCHAR(4),
    e470_residential_address_state VARCHAR(3),
    e658_residential_address_country_code VARCHAR(4),
    e319_term_residence_postcode VARCHAR(4),
    e661_term_residence_country_code VARCHAR(4),
    e315_gender_code VARCHAR(1),
    e316_atsi_code VARCHAR(1),
    e346_country_of_birth_code VARCHAR(4),
    e347_arrival_in_australia_year INTEGER,
    e348_language_spoken_at_home_code VARCHAR(4),
    e572_year_left_school INTEGER,
    e612_level_left_school SMALLINT,
    e573_highest_education_parent1 VARCHAR(2),
    e574_highest_education_parent2 VARCHAR(2),
    -- start_date DATE,
    -- end_date DATE,
    is_current BOOLEAN DEFAULT TRUE,
    extracted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    load_batch_id INT NOT NULL
);

-- Student Citizenships
CREATE TABLE hep_student_citizenships (
    uid10_student_citizenships_res_key VARCHAR(10) PRIMARY KEY,
    student_key BIGINT NOT NULL REFERENCES hep_students(student_key),
    e358_citizen_resident_code VARCHAR(1) NOT NULL,
    e609_effective_from_date DATE NOT NULL,
    e610_effective_to_date DATE
);

-- Student Disabilities
CREATE TABLE hep_student_disabilities (
    uid11_student_disabilities_res_key VARCHAR(10) PRIMARY KEY,
    student_key BIGINT NOT NULL REFERENCES hep_students(student_key),
    e615_disability_code VARCHAR(2) NOT NULL,
    e609_effective_from_date DATE NOT NULL,
    e610_effective_to_date DATE
);

-- Student Contacts First Reported Address
CREATE TABLE student_contacts_first_reported_address (
    first_address_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_key BIGINT REFERENCES hep_students(student_key),
    e787_first_residential_address_line1 VARCHAR(255),
    e789_first_residential_address_suburb VARCHAR(48),
    e791_first_residential_address_state VARCHAR(3),
    e659_first_residential_address_country_code VARCHAR(4),
    e790_first_residential_address_postcode VARCHAR(4),
    UNIQUE (student_key)  -- optional, keeps it one-to-one for now
);

-- Commonwealth Scholarships
CREATE TABLE commonwealth_scholarships (
    uid12_student_commonwealth_scholarships_res_key VARCHAR(10) PRIMARY KEY,
    student_key BIGINT NOT NULL REFERENCES hep_students(student_key),
    e415_reporting_year INTEGER,
    e666_reporting_period SMALLINT,
    e545_commonwealth_scholarship_type VARCHAR(1),
    e526_commonwealth_scholarship_status_code VARCHAR(1),
    e598_commonwealth_scholarship_amount DECIMAL(8,2),
    e538_commonwealth_scholarship_termination_reason_code VARCHAR(1)
);