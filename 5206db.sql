-- ================================================
-- TCSI Stage 4 Final Database Structure
-- Client Approved Version with Minimal SCD-2 Pattern
-- ================================================

-- Drop tables in reverse dependency order (if needed)
/*
DROP TABLE IF EXISTS UnitEnrolmentAOUs;
DROP TABLE IF EXISTS UnitEnrolments;
DROP TABLE IF EXISTS OSHELP;
DROP TABLE IF EXISTS SAHELP;
DROP TABLE IF EXISTS ExitAwards;
DROP TABLE IF EXISTS AggregatedAwards;
DROP TABLE IF EXISTS CourseAdmissions;
DROP TABLE IF EXISTS StudentResidentialAddress;
DROP TABLE IF EXISTS StudentDisabilities;
DROP TABLE IF EXISTS StudentCitizenship;
DROP TABLE IF EXISTS CampusesTAC;
DROP TABLE IF EXISTS CampusCourseFeesITSP;
DROP TABLE IF EXISTS CoursesOnCampuses;
DROP TABLE IF EXISTS Campuses;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS HEPStudents;
*/

-- ================================================
-- Core Tables
-- ================================================

-- 1. HEPStudents Table (Main student demographics)
CREATE TABLE HEPStudents (
    Student_Key INT PRIMARY KEY,
    UID8_StudentsResKey VARCHAR(50) UNIQUE NOT NULL,
    E313_StudentIdentificationCode VARCHAR(20) UNIQUE NOT NULL,
    E488_CHESSN VARCHAR(20),
    E584_USI VARCHAR(20),
    A170_USIVerificationStatus CHAR(1),
    A167_TFNVerificationStatus CHAR(1),
    E314_DateOfBirth DATE NOT NULL,
    E402_StudentFamilyName VARCHAR(100) NOT NULL,
    E403_StudentGivenNameFirst VARCHAR(100) NOT NULL,
    E404_StudentGivenNameOthers VARCHAR(100),
    E315_GenderCode VARCHAR(2) NOT NULL,
    E316_ATSICode VARCHAR(2) NOT NULL,
    E346_CountryOfBirthCode VARCHAR(3) NOT NULL,
    E347_ArrivalInAustraliaYear INT,
    E348_LanguageSpokenAtHomeCode VARCHAR(4) NOT NULL,
    E572_YearLeftSchool INT,
    E612_LevelLeftSchool VARCHAR(2),
    E573_HighestEducationParent1 VARCHAR(2),
    E574_HighestEducationParent2 VARCHAR(2),
    E319_TermResidencePostcode VARCHAR(10),
    E661_TermResidenceCountryCode VARCHAR(3),
    
    -- Minimal SCD-2 fields
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    IsCurrent BOOLEAN DEFAULT TRUE,
    
    INDEX idx_student_id (E313_StudentIdentificationCode),
    INDEX idx_chessn (E488_CHESSN),
    INDEX idx_usi (E584_USI),
    INDEX idx_current (IsCurrent)
) COMMENT='Core student demographic information';

-- 2. StudentResidentialAddress Table (Normalized address tracking)
CREATE TABLE StudentResidentialAddress (
    Address_ID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Surrogate key for SCD-2',
    Student_Key INT NOT NULL,
    E410_ResidentialAddressLine1 VARCHAR(200) NOT NULL,
    E469_ResidentialAddressSuburb VARCHAR(100) NOT NULL,
    E320_ResidentialAddressPostcode VARCHAR(10) NOT NULL,
    E470_ResidentialAddressState VARCHAR(3) NOT NULL,
    E658_ResidentialAddressCountryCode VARCHAR(3) NOT NULL,
    
    -- Minimal SCD-2 fields
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsCurrent BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (Student_Key) REFERENCES HEPStudents(Student_Key),
    INDEX idx_student_address (Student_Key, IsCurrent),
    INDEX idx_postcode (E320_ResidentialAddressPostcode)
) COMMENT='Student residential addresses with history tracking';

-- 3. StudentCitizenship Table (With surrogate key)
CREATE TABLE StudentCitizenship (
    Citizenship_ID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Surrogate key for SCD-2',
    UID10_StudentCitizenshipsResKey VARCHAR(50) NOT NULL,
    Student_Key INT NOT NULL,
    E358_CitizenResidentCode VARCHAR(2) NOT NULL,
    E609_EffectiveFromDate DATE NOT NULL,
    E610_EffectiveToDate DATE,
    
    -- Minimal SCD-2 fields
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsCurrent BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (Student_Key) REFERENCES HEPStudents(Student_Key),
    INDEX idx_student_citizen (Student_Key, IsCurrent),
    INDEX idx_citizen_code (E358_CitizenResidentCode)
) COMMENT='Student citizenship and residency status';

-- 4. StudentDisabilities Table (With surrogate key)
CREATE TABLE StudentDisabilities (
    Disability_ID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Surrogate key for SCD-2',
    UID11_StudentDisabilitiesResKey VARCHAR(50) NOT NULL,
    Student_Key INT NOT NULL,
    E615_DisabilityCode VARCHAR(2) NOT NULL,
    E609_EffectiveFromDate DATE NOT NULL,
    E610_EffectiveToDate DATE,
    
    -- Minimal SCD-2 fields
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsCurrent BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (Student_Key) REFERENCES HEPStudents(Student_Key),
    INDEX idx_student_disability (Student_Key, IsCurrent)
) COMMENT='Student disability information';

-- 5. Courses Table
CREATE TABLE Courses (
    UID5_CoursesResKey VARCHAR(50) PRIMARY KEY,
    E307_CourseCode VARCHAR(20) NOT NULL,
    E308_CourseName VARCHAR(200) NOT NULL,
    E596_StandardCourseDuration DECIMAL(3,1),
    E310_CourseOfStudyType VARCHAR(2),
    
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    IsCurrent BOOLEAN DEFAULT TRUE,
    
    INDEX idx_course_code (E307_CourseCode)
) COMMENT='Course master data';

-- 6. Campuses Table
CREATE TABLE Campuses (
    UID2_CampusesResKey VARCHAR(50) PRIMARY KEY,
    E525_CampusSuburb VARCHAR(100) NOT NULL,
    E644_CampusCountryCode VARCHAR(3) NOT NULL,
    E559_CampusPostcode VARCHAR(10) NOT NULL,
    E569_CampusOperationType VARCHAR(2) NOT NULL,
    
    INDEX idx_campus_location (E559_CampusPostcode, E525_CampusSuburb)
) COMMENT='Campus locations';

-- 7. CoursesOnCampuses Table
CREATE TABLE CoursesOnCampuses (
    UID4_CoursesOnCampusResKey VARCHAR(50) PRIMARY KEY,
    UID2_CampusesResKey VARCHAR(50) NOT NULL,
    UID5_CoursesResKey VARCHAR(50) NOT NULL,
    E597_CRICOSCode VARCHAR(20),
    E609_EffectiveFromDate DATE NOT NULL,
    E610_EffectiveToDate DATE,
    
    FOREIGN KEY (UID2_CampusesResKey) REFERENCES Campuses(UID2_CampusesResKey),
    FOREIGN KEY (UID5_CoursesResKey) REFERENCES Courses(UID5_CoursesResKey),
    
    INDEX idx_course_campus (UID5_CoursesResKey, UID2_CampusesResKey)
) COMMENT='Courses offered at specific campuses';

-- 8. CampusCourseFeesITSP Table
CREATE TABLE CampusCourseFeesITSP (
    UID31_CampusCourseFeesResKey VARCHAR(50) PRIMARY KEY,
    UID4_CoursesOnCampusResKey VARCHAR(50) NOT NULL,
    E536_CourseFeesCode VARCHAR(10) NOT NULL,
    E495_IndicativeStudentContributionCSP DECIMAL(10,2),
    E496_IndicativeTuitionFeeDomesticFP DECIMAL(10,2),
    E609_EffectiveFromDate DATE NOT NULL,
    
    FOREIGN KEY (UID4_CoursesOnCampusResKey) REFERENCES CoursesOnCampuses(UID4_CoursesOnCampusResKey),
    
    INDEX idx_fees_course_campus (UID4_CoursesOnCampusResKey)
) COMMENT='Course fees by campus';

-- 9. CampusesTAC Table
CREATE TABLE CampusesTAC (
    UID40_CoursesOnCampusTACResKey VARCHAR(50) PRIMARY KEY,
    UID4_CoursesOnCampusResKey VARCHAR(50) NOT NULL,
    E557_TACOfferCode VARCHAR(2) NOT NULL,
    
    FOREIGN KEY (UID4_CoursesOnCampusResKey) REFERENCES CoursesOnCampuses(UID4_CoursesOnCampusResKey)
) COMMENT='TAC offerings by campus';

-- 10. CourseAdmissions Table (With surrogate key)
CREATE TABLE CourseAdmissions (
    Admission_ID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Surrogate key for SCD-2',
    UID15_CourseAdmissionsResKey VARCHAR(50) NOT NULL,
    Student_Key INT NOT NULL,
    UID5_CoursesResKey VARCHAR(50) NOT NULL,
    E534_CourseOfStudyCommencementDate DATE NOT NULL,
    E330_AttendanceTypeCode VARCHAR(2),
    E591_HDRThesisSubmissionDate DATE,
    E632_ATAR DECIMAL(5,2),
    E605_SelectionRank DECIMAL(5,2),
    E620_HighestAttainmentCode VARCHAR(2),
    
    -- Minimal SCD-2 fields
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsCurrent BOOLEAN DEFAULT TRUE,
    Reporting_Year INT NOT NULL,
    
    FOREIGN KEY (Student_Key) REFERENCES HEPStudents(Student_Key),
    FOREIGN KEY (UID5_CoursesResKey) REFERENCES Courses(UID5_CoursesResKey),
    
    INDEX idx_admission_student (Student_Key),
    INDEX idx_admission_course (UID5_CoursesResKey),
    INDEX idx_admission_current (IsCurrent),
    INDEX idx_reporting_year (Reporting_Year)
) COMMENT='Student course admissions with SCD-2';

-- 11. AggregatedAwards Table (Links to both Student and Course)
CREATE TABLE AggregatedAwards (
    UID47_AggregateAwardsResKey VARCHAR(50) PRIMARY KEY,
    Student_Key INT NOT NULL,
    UID5_CoursesResKey VARCHAR(50) NOT NULL,
    E534_CourseOfStudyCommencementDate DATE,
    E599_CourseOutcomeCode VARCHAR(2) NOT NULL,
    E591_HDRThesisSubmissionDate DATE,
    E592_CourseOutcomeDate DATE NOT NULL,
    E329_ModeOfAttendanceCode VARCHAR(2),
    E330_AttendanceTypeCode VARCHAR(2),
    
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Student_Key) REFERENCES HEPStudents(Student_Key),
    FOREIGN KEY (UID5_CoursesResKey) REFERENCES Courses(UID5_CoursesResKey),
    
    INDEX idx_award_student (Student_Key),
    INDEX idx_award_course (UID5_CoursesResKey)
) COMMENT='Aggregated course completions - links to Student and Course';

-- 12. ExitAwards Table (Links to CourseAdmission and Course)
CREATE TABLE ExitAwards (
    UID46_EarlyExitAwardsResKey VARCHAR(50) PRIMARY KEY,
    Admission_ID INT NOT NULL,
    UID5_CoursesResKey VARCHAR(50) NOT NULL,
    E599_CourseOutcomeCode VARCHAR(2) NOT NULL,
    E592_CourseOutcomeDate DATE NOT NULL,
    
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Admission_ID) REFERENCES CourseAdmissions(Admission_ID),
    FOREIGN KEY (UID5_CoursesResKey) REFERENCES Courses(UID5_CoursesResKey),
    
    INDEX idx_exit_admission (Admission_ID),
    INDEX idx_exit_course (UID5_CoursesResKey)
) COMMENT='Exit awards - actual award may differ from admission course';

-- 13. UnitEnrolments Table (No direct FK to CoursesOnCampuses)
CREATE TABLE UnitEnrolments (
    UnitEnrolment_ID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Surrogate key for SCD-2',
    UID16_UnitEnrolmentsResKey VARCHAR(50) NOT NULL,
    Admission_ID INT NOT NULL,
    E354_UnitOfStudyCode VARCHAR(20) NOT NULL,
    E489_UnitOfStudyCensusDate DATE NOT NULL,
    E337_WorkExperienceInIndustryCode VARCHAR(2),
    E551_SummerWinterSchoolCode VARCHAR(2),
    E464_DisciplineCode VARCHAR(6) NOT NULL,
    E355_UnitOfStudyStatusCode VARCHAR(2) NOT NULL,
    E329_ModeOfAttendanceCode VARCHAR(2) NOT NULL,
    E477_DeliveryLocationPostcode VARCHAR(10),
    E660_DeliveryLocationCountryCode VARCHAR(3),
    E490_StudentStatusCode VARCHAR(3) NOT NULL,
    E392_MaximumStudentContributionCode VARCHAR(2),
    E600_UnitOfStudyCommencementDate DATE NOT NULL,
    E601_UnitOfStudyOutcomeDate DATE,
    
    -- Financial fields
    UE_E339_EFTSL DECIMAL(4,3),
    UE_E384_AmountCharged DECIMAL(10,2),
    UE_E381_AmountPaidUpfront DECIMAL(10,2),
    UE_E558_HELPLoanAmount DECIMAL(10,2),
    UE_E529_LoanFee DECIMAL(10,2),
    
    -- Minimal SCD-2 fields
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsCurrent BOOLEAN DEFAULT TRUE,
    UE_A111_IsDeleted BOOLEAN DEFAULT FALSE,
    Reporting_Year INT NOT NULL,
    Load_Batch_ID VARCHAR(50),
    
    FOREIGN KEY (Admission_ID) REFERENCES CourseAdmissions(Admission_ID),
    
    INDEX idx_unit_admission (Admission_ID),
    INDEX idx_unit_code (E354_UnitOfStudyCode),
    INDEX idx_unit_census (E489_UnitOfStudyCensusDate),
    INDEX idx_unit_current (IsCurrent),
    INDEX idx_unit_year (Reporting_Year)
) COMMENT='Unit enrolments - fees resolved via CourseAdmission→Course→CoursesOnCampuses';

-- 14. UnitEnrolmentAOUs Table (With surrogate key)
CREATE TABLE UnitEnrolmentAOUs (
    AOU_ID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Surrogate key for SCD-2',
    UID19_UnitEnrolmentAOUsResKey VARCHAR(50) NOT NULL,
    UnitEnrolment_ID INT NOT NULL,
    E333_AOUCode VARCHAR(20) NOT NULL,
    AOU_E339_EFTSL DECIMAL(4,3),
    AOU_E384_AmountCharged DECIMAL(10,2),
    AOU_E381_AmountPaidUpfront DECIMAL(10,2),
    AOU_E529_LoanFee DECIMAL(10,2),
    
    -- Minimal SCD-2 fields
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsCurrent BOOLEAN DEFAULT TRUE,
    AOU_IsDeleted BOOLEAN DEFAULT FALSE,
    
    FOREIGN KEY (UnitEnrolment_ID) REFERENCES UnitEnrolments(UnitEnrolment_ID),
    
    INDEX idx_aou_unit (UnitEnrolment_ID),
    INDEX idx_aou_code (E333_AOUCode),
    INDEX idx_aou_current (IsCurrent)
) COMMENT='Areas of Study with surrogate key for SCD-2';

-- 15. SAHELP Table (Links directly to Student, not CourseAdmission)
CREATE TABLE SAHELP (
    SAHELP_ID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Surrogate key for SCD-2',
    UID21_StudentLoansResKey VARCHAR(50) NOT NULL,
    Student_Key INT NOT NULL,
    E527_HELPDebtIncurralDate DATE NOT NULL,
    E490_StudentStatusCode VARCHAR(3),
    E384_AmountCharged DECIMAL(10,2),
    E381_AmountPaidUpfront DECIMAL(10,2),
    E558_HELPLoanAmount DECIMAL(10,2),
    A130_LoanStatus VARCHAR(2),
    Invalidated_Flag BOOLEAN DEFAULT FALSE,
    
    -- Minimal SCD-2 fields
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsCurrent BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (Student_Key) REFERENCES HEPStudents(Student_Key),
    
    INDEX idx_sahelp_student (Student_Key),
    INDEX idx_sahelp_current (IsCurrent)
) COMMENT='SA-HELP loans linked to student per TCSI spec';

-- 16. OSHELP Table (With surrogate key)
CREATE TABLE OSHELP (
    OSHELP_ID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Surrogate key for SCD-2',
    UID21_StudentLoansResKey VARCHAR(50) NOT NULL,
    Student_Key INT NOT NULL,
    E521_OSHELPStudyPeriodCommencementDate DATE,
    E553_OSHELPStudyPrimaryCountryCode VARCHAR(3),
    E554_OSHELPStudySecondaryCountryCode VARCHAR(3),
    E583_OSHELPLanguageStudyCommencementDate DATE,
    E582_OSHELPLanguageCode VARCHAR(3),
    E528_OSHELPPaymentAmount DECIMAL(10,2),
    E529_LoanFee DECIMAL(10,2),
    A130_LoanStatus VARCHAR(2),
    Invalidated_Flag BOOLEAN DEFAULT FALSE,
    
    -- Minimal SCD-2 fields
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsCurrent BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (Student_Key) REFERENCES HEPStudents(Student_Key),
    
    INDEX idx_oshelp_student (Student_Key),
    INDEX idx_oshelp_current (IsCurrent)
) COMMENT='OS-HELP loans with surrogate key';

-- ================================================
-- Views for Common Queries
-- ================================================

-- View: Current student addresses
CREATE VIEW v_current_student_addresses AS
SELECT 
    s.Student_Key,
    s.E313_StudentIdentificationCode,
    s.E402_StudentFamilyName,
    s.E403_StudentGivenNameFirst,
    a.E410_ResidentialAddressLine1,
    a.E469_ResidentialAddressSuburb,
    a.E320_ResidentialAddressPostcode,
    a.E470_ResidentialAddressState
FROM HEPStudents s
LEFT JOIN StudentResidentialAddress a ON s.Student_Key = a.Student_Key
WHERE a.IsCurrent = TRUE;

-- View: Current course admissions with fees
CREATE VIEW v_current_admissions_with_fees AS
SELECT 
    ca.Admission_ID,
    ca.Student_Key,
    ca.UID5_CoursesResKey,
    c.E307_CourseCode,
    c.E308_CourseName,
    coc.UID2_CampusesResKey,
    camp.E525_CampusSuburb,
    fees.E495_IndicativeStudentContributionCSP,
    fees.E496_IndicativeTuitionFeeDomesticFP
FROM CourseAdmissions ca
JOIN Courses c ON ca.UID5_CoursesResKey = c.UID5_CoursesResKey
LEFT JOIN CoursesOnCampuses coc ON c.UID5_CoursesResKey = coc.UID5_CoursesResKey
LEFT JOIN Campuses camp ON coc.UID2_CampusesResKey = camp.UID2_CampusesResKey
LEFT JOIN CampusCourseFeesITSP fees ON coc.UID4_CoursesOnCampusResKey = fees.UID4_CoursesOnCampusResKey
WHERE ca.IsCurrent = TRUE;

-- ================================================
-- Stored Procedures for SCD-2 Management
-- ================================================

DELIMITER $$

-- Procedure: Update student address (handles SCD-2)
CREATE PROCEDURE sp_update_student_address(
    IN p_student_key INT,
    IN p_address_line1 VARCHAR(200),
    IN p_suburb VARCHAR(100),
    IN p_postcode VARCHAR(10),
    IN p_state VARCHAR(3),
    IN p_country VARCHAR(3)
)
BEGIN
    -- Set current address to not current
    UPDATE StudentResidentialAddress 
    SET IsCurrent = FALSE 
    WHERE Student_Key = p_student_key AND IsCurrent = TRUE;
    
    -- Insert new current address
    INSERT INTO StudentResidentialAddress (
        Student_Key,
        E410_ResidentialAddressLine1,
        E469_ResidentialAddressSuburb,
        E320_ResidentialAddressPostcode,
        E470_ResidentialAddressState,
        E658_ResidentialAddressCountryCode,
        IsCurrent
    ) VALUES (
        p_student_key,
        p_address_line1,
        p_suburb,
        p_postcode,
        p_state,
        p_country,
        TRUE
    );
END$$

-- Procedure: Get historical data as of specific date
CREATE PROCEDURE sp_get_data_as_of(
    IN p_table_name VARCHAR(50),
    IN p_as_of_date DATETIME,
    IN p_key_field VARCHAR(50),
    IN p_key_value VARCHAR(50)
)
BEGIN
    SET @sql = CONCAT(
        'SELECT * FROM ', p_table_name,
        ' WHERE ', p_key_field, ' = ''', p_key_value, '''',
        ' AND UpdatedAt <= ''', p_as_of_date, '''',
        ' ORDER BY UpdatedAt DESC LIMIT 1'
    );
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;

-- ================================================
-- Summary Comments
-- ================================================

/*
Stage 4 Final Database Structure Features:

1. MINIMAL SCD-2 PATTERN:
   - UpdatedAt: Effective-from timestamp
   - IsCurrent: Boolean flag for current version
   - Simpler than traditional Start_Date/End_Date approach

2. SURROGATE KEYS ADDED TO:
   - StudentCitizenship (Citizenship_ID)
   - StudentDisabilities (Disability_ID)
   - StudentResidentialAddress (Address_ID)
   - CourseAdmissions (Admission_ID)
   - UnitEnrolments (UnitEnrolment_ID)
   - UnitEnrolmentAOUs (AOU_ID)
   - SAHELP (SAHELP_ID)
   - OSHELP (OSHELP_ID)

3. KEY RELATIONSHIP CHANGES:
   - SAHELP → Student (not CourseAdmission)
   - AggregatedAwards → Student AND Course
   - ExitAwards → CourseAdmission AND Course
   - UnitEnrolments → CourseAdmission (no direct link to CoursesOnCampuses)

4. NORMALIZED STRUCTURE:
   - StudentResidentialAddress separated from HEPStudents
   - Clean separation of concerns

5. FEE RESOLUTION PATH:
   UnitEnrolment → CourseAdmission → Course → CoursesOnCampuses → CampusCourseFeesITSP

This structure is fully compliant with TCSI specifications and optimized for:
- Incremental data loads
- Historical data tracking
- Simplified ETL processes
- Efficient reporting
*/