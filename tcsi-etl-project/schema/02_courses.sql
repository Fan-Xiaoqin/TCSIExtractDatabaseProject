-- =====================================================
-- COURSE RELATED TABLES
-- =====================================================

-- Courses of Study (Master table for course types)
CREATE TABLE courses_of_study (
uid3_courses_of_study_res_key VARCHAR(10) PRIMARY KEY,
    e533_course_of_study_code VARCHAR(20) NOT NULL UNIQUE,
    e394_course_of_study_name VARCHAR(210) NOT NULL,
    e310_course_of_study_type VARCHAR(2) NOT NULL CHECK (
        e310_course_of_study_type IN (
            '1','2','3','4','5','6','7','8','9',
            '01','02','03','04','05','06','07','08','09','10','11','12','13','14',
            '20','21','22','23','30','41','42','50','51','52','60','61','80','81'
        )
    ),
    e350_course_of_study_load DECIMAL(2,1),
    e455_combined_course_of_study_indicator BOOLEAN NOT NULL,
    -- need to convert sample 0/1 data values to true /false when importing data from R
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

-- HEP Courses (Specific course offerings)
CREATE TABLE hep_courses (
    uid5_courses_res_key VARCHAR(10) PRIMARY KEY,
    uid3_courses_of_study_res_key VARCHAR(10) NOT NULL REFERENCES courses_of_study(uid3_courses_of_study_res_key),
    e307_course_code VARCHAR(10) NOT NULL UNIQUE,
    e308_course_name VARCHAR(210) NOT NULL,
    e596_standard_course_duration DECIMAL(4,3),
    e609_effective_from_date DATE NOT NULL,
    e610_effective_to_date DATE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Special Interest Courses
CREATE TABLE special_interest_courses (
    uid30_special_interest_courses_res_key VARCHAR(10) PRIMARY KEY,
    uid5_courses_res_key VARCHAR(10) NOT NULL REFERENCES hep_courses(uid5_courses_res_key),
    e312_special_course_type VARCHAR(2) CHECK (
        e312_special_course_type IN ('21','22','23','25','26','27','28')
    ),
    e609_effective_from_date DATE NOT NULL,
    e610_effective_to_date DATE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Course Fields of Education
CREATE TABLE course_fields_of_education (
    uid48_course_fields_of_education_res_key VARCHAR(10) PRIMARY KEY,
    uid5_courses_res_key VARCHAR(10) NOT NULL REFERENCES hep_courses(uid5_courses_res_key),
    e461_field_of_education_code VARCHAR(6) NOT NULL,
    e462_field_of_education_supplementary_code VARCHAR(6),
    e609_effective_from_date DATE NOT NULL,
    e610_effective_to_date DATE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
