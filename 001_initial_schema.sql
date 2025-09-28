-- =====================================================================
-- TCSI Extract Database Initial Schema
-- Version: 1.0
-- Date: September 2025
-- Description: Creates the initial database schema based on ERD Stage 4
-- Author: TCSI Database Project Team
-- =====================================================================

-- Set database configuration
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+08:00"; -- Perth time zone

-- =====================================================================
-- Drop existing tables if they exist (careful in production!)
-- =====================================================================

DROP TABLE IF EXISTS ExitAwards;
DROP TABLE IF EXISTS AggregatedAwards;
DROP TABLE IF EXISTS UnitEnrolmentsAOUs;
DROP TABLE IF EXISTS UnitEnrolments;
DROP TABLE IF EXISTS CourseAdmissions;
DROP TABLE IF EXISTS OSHELP;
DROP TABLE IF EXISTS SAHELP;
DROP TABLE IF EXISTS StudentDisabilities;
DROP TABLE IF EXISTS StudentCitizenship;
DROP TABLE IF EXISTS StudentResidentialAddress;
DROP TABLE IF EXISTS HEPStudents;
DROP TABLE IF EXISTS CampusesTAC;
DROP TABLE IF EXISTS CampusCourseFees;
DROP TABLE IF EXISTS CoursesOnCampuses;
DROP TABLE IF EXISTS SpecialInterestCourses;
DROP TABLE IF EXISTS CourseFieldsOfEducation;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS CoursesOfStudy;
DROP TABLE IF EXISTS Campuses;
DROP TABLE IF EXISTS HEPProviders;

-- =====================================================================
-- REFERENCE TABLES
-- =====================================================================

-- Table: HEPProviders
-- Description: Higher Education Provider information
CREATE TABLE HEPProviders (
    UID1_ProvidersResKey VARCHAR(50) NOT NULL,
    E306_ProviderCode VARCHAR(10) NOT NULL UNIQUE,
    E781_ProviderType VARCHAR(20) NOT NULL,
    provider_name VARCHAR(100) NOT NULL,
    provider_abn VARCHAR(11),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (UID1_ProvidersResKey),
    INDEX idx_provider_code (E306_ProviderCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Higher Education Provider information';

-- Table: CoursesOfStudy
-- Description: Course of study reference table
CREATE TABLE CoursesOfStudy (
    UID3_CoursesOfStudyResKey VARCHAR(50) NOT NULL,
    E533_CourseOfStudyCode VARCHAR(20) NOT NULL UNIQUE,
    E394_CourseOfStudyName VARCHAR(200) NOT NULL,
    E310_CourseOfStudyType VARCHAR(2) NOT NULL COMMENT 'UG/PG/HDR',
    E350_CourseOfStudyLoad VARCHAR(2) NOT NULL COMMENT 'FT/PT',
    E455_CombinedCourseOfStudyIndicator CHAR(1) COMMENT 'Y/N',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (UID3_CoursesOfStudyResKey),
    INDEX idx_course_study_code (E533_CourseOfStudyCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Courses of study reference table';

-- Table: Courses
-- Description: Course/program definitions
CREATE TABLE Courses (
    UID5_CoursesResKey VARCHAR(50) NOT NULL,
    UID3_CoursesOfStudyResKey VARCHAR(50) NOT NULL,
    E307_CourseCode VARCHAR(20) NOT NULL,
    E308_CourseName VARCHAR(200) NOT NULL,
    E310_CourseOfStudyType VARCHAR(2) NOT NULL,
    E350_CourseOfStudyLoad VARCHAR(2) NOT NULL,
    E596_StandardCourseDuration DECIMAL(3,1) NOT NULL COMMENT 'Duration in years',
    E609_EffectiveFromDate DATE NOT NULL,
    E610_EffectiveToDate DATE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (UID5_CoursesResKey),
    UNIQUE KEY uk_course_code_dates (E307_CourseCode, E609_EffectiveFromDate),
    INDEX idx_course_code (E307_CourseCode),
    INDEX idx_effective_dates (E609_EffectiveFromDate, E610_EffectiveToDate),
    FOREIGN KEY (UID3_CoursesOfStudyResKey) REFERENCES CoursesOfStudy(UID3_CoursesOfStudyResKey)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Course/program definitions';

-- Table: Campuses
-- Description: Physical and virtual campus locations
CREATE TABLE Campuses (
    UID30_CampusesResKey VARCHAR(50) NOT NULL,
    campus_code VARCHAR(10) NOT NULL UNIQUE,
    campus_name VARCHAR(100) NOT NULL,
    E525_CampusSuburb VARCHAR(50) NOT NULL,
    E559_CampusPostcode VARCHAR(10) NOT NULL,
    E644_CampusCountryCode VARCHAR(4) NOT NULL COMMENT 'ISO 3166-1 numeric',
    E609_EffectiveFromDate DATE NOT NULL,
    E610_EffectiveToDate DATE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (UID30_CampusesResKey),
    INDEX idx_campus_code (campus_code),
    INDEX idx_campus_location (E559_CampusPostcode, E644_CampusCountryCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Physical and virtual campus locations';

-- Table: CourseFieldsOfEducation
-- Description: Field of education classifications for courses
CREATE TABLE CourseFieldsOfEducation (
    UID29_CourseFieldsOfEducationResKey VARCHAR(50) NOT NULL,
    UID5_CoursesResKey VARCHAR(50) NOT NULL,
    E461_FieldOfEducationCode VARCHAR(6) NOT NULL COMMENT 'ASCED code',
    E462_FieldOfEducationPercentage DECIMAL(5,2) NOT NULL COMMENT 'Percentage allocation',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (UID29_CourseFieldsOfEducationResKey),
    INDEX idx_course_foe (UID5_CoursesResKey, E461_FieldOfEducationCode),
    FOREIGN KEY (UID5_CoursesResKey) REFERENCES Courses(UID5_CoursesResKey),
    CONSTRAINT chk_percentage CHECK (E462_FieldOfEducationPercentage >= 0 AND E462_FieldOfEducationPercentage <= 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Field of education classifications';

-- Table: SpecialInterestCourses
-- Description: Special interest or specialized course categories
CREATE TABLE SpecialInterestCourses (
    UID30_SpecialInterestCoursesResKey VARCHAR(50) NOT NULL,
    UID5_CoursesResKey VARCHAR(50) NOT NULL,
    E312_SpecialCourseType VARCHAR(20) NOT NULL,
    E609_EffectiveFromDate DATE NOT NULL,
    E610_EffectiveToDate DATE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (UID30_SpecialInterestCoursesResKey),
    INDEX idx_special_course (UID5_CoursesResKey, E312_SpecialCourseType),
    FOREIGN KEY (UID5_CoursesResKey) REFERENCES Courses(UID5_CoursesResKey)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Special interest course categories';

-- =====================================================================
-- STUDENT TABLES
-- =====================================================================

-- Table: HEPStudents
-- Description: Master table for all Higher Education Provider students
CREATE TABLE HEPStudents (
    Student_key INT AUTO_INCREMENT,
    E313_StudentIdentificationCode VARCHAR(10) NOT NULL,
    E488_CHESSN VARCHAR(10) COMMENT 'Commonwealth HE Student Support Number',
    E584_USI VARCHAR(10) COMMENT 'Unique Student Identifier',
    E401_PersonSurname VARCHAR(50) NOT NULL,
    E402_PersonGivenName VARCHAR(50) NOT NULL,
    E403_PersonMiddleName VARCHAR(50),
    E573_PersonTitle VARCHAR(20),
    E315_DateOfBirth DATE NOT NULL,
    E314_GenderCode CHAR(1) NOT NULL COMMENT 'M/F/X',
    E346_CountryOfBirth VARCHAR(4),
    E348_LanguageSpokenAtHome VARCHAR(4),
    E347_YearOfArrivalInAustralia INT(4),
    E316_ATSICode CHAR(1) COMMENT '1-4 Aboriginal/Torres Strait Islander status',
    E358_CitizenshipCode VARCHAR(4) NOT NULL,
    E359_PermanentResidentStatus CHAR(1) COMMENT 'Y/N',
    E490_StudentStatusCode VARCHAR(2) NOT NULL,
    extraction_date DATETIME NOT NULL,
    reporting_year INT(4) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (Student_key),
    UNIQUE KEY uk_student_id (E313_StudentIdentificationCode),
    INDEX idx_chessn (E488_CHESSN),
    INDEX idx_usi (E584_USI),
    INDEX idx_student_name (E401_PersonSurname, E402_PersonGivenName),
    INDEX idx_reporting_year (reporting_year),
    CONSTRAINT chk_gender CHECK (E314_GenderCode IN ('M', 'F', 'X')),
    CONSTRAINT chk_atsi CHECK (E316_ATSICode IN ('1', '2', '3', '4') OR E316_ATSICode IS NULL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Master student table';

-- Table: StudentResidentialAddress
-- Description: Current residential address for students
CREATE TABLE StudentResidentialAddress (
    Address_key INT AUTO_INCREMENT,
    Student_key INT NOT NULL,
    E469_ResidentialAddressLine1 VARCHAR(100) NOT NULL,
    E469_ResidentialAddressLine2 VARCHAR(100),
    E470_ResidentialAddressPostcode VARCHAR(10) NOT NULL,
    E470_ResidentialAddressSuburb VARCHAR(50) NOT NULL,
    E470_ResidentialAddressState VARCHAR(3) NOT NULL,
    E659_ResidentialAddressCountry VARCHAR(4) NOT NULL DEFAULT '1101' COMMENT 'Australia default',
    effective_from_date DATE NOT NULL,
    effective_to_date DATE,
    is_current BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (Address_key),
    INDEX idx_student_address (Student_key, is_current),
    INDEX idx_postcode (E470_ResidentialAddressPostcode),
    FOREIGN KEY (Student_key) REFERENCES HEPStudents(Student_key) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Student residential addresses';

-- Table: StudentCitizenship
-- Description: Student citizenship history (SCD-2)
CREATE TABLE StudentCitizenship (
    Citizenship_key INT AUTO_INCREMENT,
    Student_key INT NOT NULL,
    E358_CitizenshipCode VARCHAR(4) NOT NULL,
    E359_PermanentResidentStatus CHAR(1),
    E347_YearOfArrivalInAustralia INT(4),
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_current BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (Citizenship_key),
    INDEX idx_student_citizenship (Student_key, is_current),
    FOREIGN KEY (Student_key) REFERENCES HEPStudents(Student_key) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Student citizenship history';

-- Table: StudentDisabilities
-- Description: Student disability information
CREATE TABLE StudentDisabilities (
    Disability_key INT AUTO_INCREMENT,
    Student_key INT NOT NULL,
    E386_DisabilityCode VARCHAR(2) NOT NULL,
    E387_DisabilityImpactCode VARCHAR(2),
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_current BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (Disability_key),
    INDEX idx_student_disability (Student_key, is_current),
    FOREIGN KEY (Student_key) REFERENCES HEPStudents(Student_key) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Student disability information';

-- =====================================================================
-- ENROLLMENT AND ADMISSION TABLES
-- =====================================================================

-- Table: CourseAdmissions
-- Description: Student admissions to courses of study
CREATE TABLE CourseAdmissions (
    Admission_key INT AUTO_INCREMENT,
    UID15_CourseAdmissionsResKey VARCHAR(50) NOT NULL UNIQUE,
    Student_key INT NOT NULL,
    UID5_CoursesResKey VARCHAR(50) NOT NULL,
    E534_CourseOfStudyCommDate DATE NOT NULL,
    E327_BasisForAdmissionCode VARCHAR(2),
    E330_SchemeDate DATE,
    E462_EntireAcademicCareerReportableIndicator CHAR(1),
    E563_StudentNumber VARCHAR(20),
    E369_PriorStudiesCode VARCHAR(2),
    E348_HighestEducationLevelCode VARCHAR(2),
    E493_HighestParticipationCode VARCHAR(2),
    E622_ResearchMastersCommencementDate DATE,
    E623_DoctoralCommencementDate DATE,
    reporting_year INT(4) NOT NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_current BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (Admission_key),
    UNIQUE KEY uk_admission_res_key (UID15_CourseAdmissionsResKey),
    INDEX idx_student_course (Student_key, UID5_CoursesResKey),
    INDEX idx_commencement_date (E534_CourseOfStudyCommDate),
    INDEX idx_reporting_year (reporting_year),
    FOREIGN KEY (Student_key) REFERENCES HEPStudents(Student_key) ON DELETE CASCADE,
    FOREIGN KEY (UID5_CoursesResKey) REFERENCES Courses(UID5_CoursesResKey)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Student course admissions';

-- Table: UnitEnrolments
-- Description: Student enrollments in individual units of study
CREATE TABLE UnitEnrolments (
    Enrolment_key INT AUTO_INCREMENT,
    UID16_UnitEnrolmentsResKey VARCHAR(50) NOT NULL UNIQUE,
    Student_key INT NOT NULL,
    UID15_CourseAdmissionsResKey VARCHAR(50) NOT NULL,
    E354_UnitOfStudyCode VARCHAR(20) NOT NULL,
    E489_UnitOfStudyCensusDate DATE NOT NULL,
    E355_UnitOfStudyStatusCode VARCHAR(2) NOT NULL,
    E329_ModeOfAttendanceCode VARCHAR(2) NOT NULL,
    E339_EFTSL DECIMAL(5,3) NOT NULL COMMENT '0.000-1.000',
    E381_AmountChargedUpfront DECIMAL(10,2),
    E384_AmountPaidUpfront DECIMAL(10,2),
    E415_ReportingDate DATE NOT NULL,
    E490_StudentStatusCode VARCHAR(2) NOT NULL,
    E551_SummerWinterSchoolCode CHAR(1),
    E337_WorkExperienceInIndustryCode CHAR(1),
    E477_DeliveryLocationPostcode VARCHAR(10),
    E660_DeliveryLocationCountryCode VARCHAR(4),
    reporting_year INT(4) NOT NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_current BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (Enrolment_key),
    UNIQUE KEY uk_enrolment_res_key (UID16_UnitEnrolmentsResKey),
    INDEX idx_student_unit (Student_key, E354_UnitOfStudyCode),
    INDEX idx_census_date (E489_UnitOfStudyCensusDate),
    INDEX idx_admission (UID15_CourseAdmissionsResKey),
    INDEX idx_reporting_year (reporting_year),
    FOREIGN KEY (Student_key) REFERENCES HEPStudents(Student_key) ON DELETE CASCADE,
    FOREIGN KEY (UID15_CourseAdmissionsResKey) REFERENCES CourseAdmissions(UID15_CourseAdmissionsResKey),
    CONSTRAINT chk_eftsl CHECK (E339_EFTSL >= 0 AND E339_EFTSL <= 1.000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Unit enrollments';

-- Table: UnitEnrolmentsAOUs
-- Description: Area of Study classifications for unit enrollments
CREATE TABLE UnitEnrolmentsAOUs (
    AOU_key INT AUTO_INCREMENT,
    UID16_UnitEnrolmentsResKey VARCHAR(50) NOT NULL,
    E464_DisciplineCode VARCHAR(6) NOT NULL COMMENT 'Field of Education code',
    E462_DisciplinePercentage DECIMAL(5,2) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (AOU_key),
    INDEX idx_unit_discipline (UID16_UnitEnrolmentsResKey, E464_DisciplineCode),
    FOREIGN KEY (UID16_UnitEnrolmentsResKey) REFERENCES UnitEnrolments(UID16_UnitEnrolmentsResKey) ON DELETE CASCADE,
    CONSTRAINT chk_aou_percentage CHECK (E462_DisciplinePercentage >= 0 AND E462_DisciplinePercentage <= 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Unit enrollment areas of study';

-- =====================================================================
-- FINANCIAL TABLES
-- =====================================================================

-- Table: SAHELP
-- Description: SA-HELP loan records for student services and amenities fees
CREATE TABLE SAHELP (
    SAHELP_key INT AUTO_INCREMENT,
    UID17_SAHELPResKey VARCHAR(50) NOT NULL UNIQUE,
    Student_key INT NOT NULL,
    E381_AmountChargedUpfront DECIMAL(10,2),
    E384_AmountPaidUpfront DECIMAL(10,2),
    E558_LoanToSAHELP DECIMAL(10,2),
    E392_HELPEligibilityCode CHAR(1) NOT NULL,
    E415_ReportingDate DATE NOT NULL,
    reporting_year INT(4) NOT NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_current BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (SAHELP_key),
    UNIQUE KEY uk_sahelp_res_key (UID17_SAHELPResKey),
    INDEX idx_student_sahelp (Student_key, reporting_year),
    FOREIGN KEY (Student_key) REFERENCES HEPStudents(Student_key) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='SA-HELP loan records';

-- Table: OSHELP
-- Description: OS-HELP loan records for overseas study
CREATE TABLE OSHELP (
    OSHELP_key INT AUTO_INCREMENT,
    UID18_OSHELPResKey VARCHAR(50) NOT NULL UNIQUE,
    Student_key INT NOT NULL,
    E584_OSHELPStudyStartDate DATE NOT NULL,
    E585_OSHELPStudyEndDate DATE NOT NULL,
    E587_TotalOSHELPLoan DECIMAL(10,2) NOT NULL,
    E588_LanguageOSHELPLoan DECIMAL(10,2),
    E415_ReportingDate DATE NOT NULL,
    reporting_year INT(4) NOT NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_current BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (OSHELP_key),
    UNIQUE KEY uk_oshelp_res_key (UID18_OSHELPResKey),
    INDEX idx_student_oshelp (Student_key, reporting_year),
    FOREIGN KEY (Student_key) REFERENCES HEPStudents(Student_key) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OS-HELP loan records';

-- Table: AggregatedAwards
-- Description: Aggregated financial awards and scholarships
CREATE TABLE AggregatedAwards (
    UID20_AggregatedAwardsResKey VARCHAR(50) NOT NULL,
    Student_key INT NOT NULL,
    UID5_CoursesResKey VARCHAR(50) NOT NULL,
    E552_AggregatedAwardCourseReportingDate DATE NOT NULL,
    E533_CourseOfStudyCode VARCHAR(20) NOT NULL,
    E571_ScholarshipsFromCommonwealthPrograms DECIMAL(10,2),
    E538_OtherScholarshipsWithin DECIMAL(10,2),
    E597_TotalAwardAmount DECIMAL(10,2) NOT NULL,
    reporting_year INT(4) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (UID20_AggregatedAwardsResKey),
    INDEX idx_student_awards (Student_key, UID5_CoursesResKey),
    INDEX idx_reporting_date (E552_AggregatedAwardCourseReportingDate),
    FOREIGN KEY (Student_key) REFERENCES HEPStudents(Student_key) ON DELETE CASCADE,
    FOREIGN KEY (UID5_CoursesResKey) REFERENCES Courses(UID5_CoursesResKey)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Aggregated awards and scholarships';

-- =====================================================================
-- RELATIONSHIP TABLES
-- =====================================================================

-- Table: CoursesOnCampuses
-- Description: Links courses to campus locations where they're offered
CREATE TABLE CoursesOnCampuses (
    UID4_CoursesOnCampusResKey VARCHAR(50) NOT NULL,
    UID5_CoursesResKey VARCHAR(50) NOT NULL,
    UID30_CampusesResKey VARCHAR(50) NOT NULL,
    E551_CourseDeliveryMode VARCHAR(2),
    E609_EffectiveFromDate DATE NOT NULL,
    E610_EffectiveToDate DATE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (UID4_CoursesOnCampusResKey),
    UNIQUE KEY uk_course_campus (UID5_CoursesResKey, UID30_CampusesResKey, E609_EffectiveFromDate),
    INDEX idx_course (UID5_CoursesResKey),
    INDEX idx_campus (UID30_CampusesResKey),
    FOREIGN KEY (UID5_CoursesResKey) REFERENCES Courses(UID5_CoursesResKey),
    FOREIGN KEY (UID30_CampusesResKey) REFERENCES Campuses(UID30_CampusesResKey)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Course campus offerings';

-- Table: CampusCourseFees
-- Description: Fee structures for courses at specific campuses
CREATE TABLE CampusCourseFees (
    UID31_CampusCourseFeesResKey VARCHAR(50) NOT NULL,
    UID4_CoursesOnCampusResKey VARCHAR(50) NOT NULL,
    E536_CourseFeesCode VARCHAR(10) NOT NULL,
    E495_IndicativeStudentContributionCSP DECIMAL(10,2),
    E496_IndicativeTuitionFeeDomesticFP DECIMAL(10,2),
    E497_IndicativeTuitionFeeInternational DECIMAL(10,2),
    E609_EffectiveFromDate DATE NOT NULL,
    E610_EffectiveToDate DATE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (UID31_CampusCourseFeesResKey),
    INDEX idx_course_campus_fees (UID4_CoursesOnCampusResKey, E609_EffectiveFromDate),
    FOREIGN KEY (UID4_CoursesOnCampusResKey) REFERENCES CoursesOnCampuses(UID4_CoursesOnCampusResKey)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Campus course fee structures';

-- Table: CampusesTAC
-- Description: Tertiary Admissions Centre (TAC) course offerings
CREATE TABLE CampusesTAC (
    UID40_CoursesOnCampusTACResKey VARCHAR(50) NOT NULL,
    UID4_CoursesOnCampusResKey VARCHAR(50) NOT NULL,
    E557_TACOfferCode VARCHAR(20) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (UID40_CoursesOnCampusTACResKey),
    INDEX idx_tac_offer (UID4_CoursesOnCampusResKey, E557_TACOfferCode),
    FOREIGN KEY (UID4_CoursesOnCampusResKey) REFERENCES CoursesOnCampuses(UID4_CoursesOnCampusResKey)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='TAC course offerings';

-- =====================================================================
-- COMPLETION TABLES
-- =====================================================================

-- Table: ExitAwards
-- Description: Exit awards and completions
CREATE TABLE ExitAwards (
    UID21_ExitAwardsResKey VARCHAR(50) NOT NULL,
    Student_key INT NOT NULL,
    UID15_CourseAdmissionsResKey VARCHAR(50) NOT NULL,
    UID5_CoursesResKey VARCHAR(50) NOT NULL,
    E592_AwardCourseCompletionDate DATE NOT NULL,
    E593_AwardCompletionYear INT(4) NOT NULL,
    E594_AwardCourseType VARCHAR(2) NOT NULL,
    E595_ConferralDate DATE,
    E599_CourseOutcomeCode VARCHAR(2),
    reporting_year INT(4) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (UID21_ExitAwardsResKey),
    INDEX idx_student_completion (Student_key, E592_AwardCourseCompletionDate),
    INDEX idx_admission_exit (UID15_CourseAdmissionsResKey),
    FOREIGN KEY (Student_key) REFERENCES HEPStudents(Student_key) ON DELETE CASCADE,
    FOREIGN KEY (UID15_CourseAdmissionsResKey) REFERENCES CourseAdmissions(UID15_CourseAdmissionsResKey),
    FOREIGN KEY (UID5_CoursesResKey) REFERENCES Courses(UID5_CoursesResKey)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Exit awards and completions';

-- =====================================================================
-- VIEWS FOR REPORTING
-- =====================================================================

-- View: Current Students
CREATE VIEW v_current_students AS
SELECT 
    s.*,
    a.E469_ResidentialAddressLine1,
    a.E470_ResidentialAddressPostcode,
    a.E470_ResidentialAddressSuburb,
    a.E470_ResidentialAddressState
FROM HEPStudents s
LEFT JOIN StudentResidentialAddress a ON s.Student_key = a.Student_key AND a.is_current = TRUE
WHERE s.E490_StudentStatusCode = 'ACTIVE';

-- View: Active Course Enrollments
CREATE VIEW v_active_enrollments AS
SELECT 
    s.Student_key,
    s.E313_StudentIdentificationCode,
    s.E401_PersonSurname,
    s.E402_PersonGivenName,
    ca.UID15_CourseAdmissionsResKey,
    c.E307_CourseCode,
    c.E308_CourseName,
    ca.E534_CourseOfStudyCommDate,
    ca.reporting_year
FROM CourseAdmissions ca
JOIN HEPStudents s ON ca.Student_key = s.Student_key
JOIN Courses c ON ca.UID5_CoursesResKey = c.UID5_CoursesResKey
WHERE ca.is_current = TRUE;

-- View: Wide Table for Analysis (as per project requirements)
CREATE VIEW v_analysis_wide_table AS
SELECT 
    -- Student Information
    s.Student_key,
    s.E313_StudentIdentificationCode,
    s.E488_CHESSN,
    s.E584_USI,
    s.E401_PersonSurname,
    s.E402_PersonGivenName,
    s.E315_DateOfBirth,
    s.E314_GenderCode,
    s.E316_ATSICode,
    s.E358_CitizenshipCode,
    
    -- Address Information
    addr.E470_ResidentialAddressPostcode,
    addr.E470_ResidentialAddressSuburb,
    addr.E470_ResidentialAddressState,
    
    -- Course Admission Information
    ca.UID15_CourseAdmissionsResKey,
    ca.E534_CourseOfStudyCommDate,
    ca.E327_BasisForAdmissionCode,
    
    -- Course Information
    c.E307_CourseCode,
    c.E308_CourseName,
    c.E310_CourseOfStudyType,
    c.E596_StandardCourseDuration,
    
    -- Unit Enrollment Information
    ue.E354_UnitOfStudyCode,
    ue.E489_UnitOfStudyCensusDate,
    ue.E355_UnitOfStudyStatusCode,
    ue.E339_EFTSL,
    ue.E381