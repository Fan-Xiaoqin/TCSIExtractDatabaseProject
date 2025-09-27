-- 1. Campuses Table (Campus Master Data)
-- Independent table with no foreign key dependencies
CREATE TABLE Campuses (
    UID2_CampusesResKey VARCHAR(50) PRIMARY KEY COMMENT 'Primary key - Campus resource identifier',
    E525_CampusSuburb VARCHAR(100) NOT NULL COMMENT 'Campus suburb/location name',
    E644_CampusCountryCode VARCHAR(3) NOT NULL COMMENT 'ISO country code (e.g., AUS, NZL)',
    E559_CampusPostcode VARCHAR(10) NOT NULL COMMENT 'Campus postcode',
    E569_CampusOperationType VARCHAR(2) NOT NULL COMMENT 'Operation type code (01=Onshore, 02=Offshore)',
    
    -- Indexes for query optimization
    INDEX idx_campus_location (E559_CampusPostcode, E525_CampusSuburb),
    INDEX idx_campus_country (E644_CampusCountryCode)
) COMMENT='Campus master data table storing all campus locations';

-- 2. HEPCoursesOnCampuses Table (Course-Campus Association)
-- Many-to-many relationship: Courses ↔ Campuses
CREATE TABLE HEPCoursesOnCampuses (
    UID4_CoursesOnCampusResKey VARCHAR(50) PRIMARY KEY COMMENT 'Primary key - Course on campus identifier',
    UID2_CampusesResKey VARCHAR(50) NOT NULL COMMENT 'Foreign key to Campuses table',
    E525_CampusSuburb VARCHAR(100) NOT NULL COMMENT 'Campus suburb (denormalized for performance)',
    E644_CampusCountryCode VARCHAR(3) NOT NULL COMMENT 'Campus country code',
    E559_CampusPostcode VARCHAR(10) NOT NULL COMMENT 'Campus postcode',
    Campuses_E609_EffectiveFromDate DATE NOT NULL COMMENT 'Campus record effective from date',
    Campuses_E610_EffectiveToDate DATE COMMENT 'Campus record effective to date',
    UID5_CoursesResKey VARCHAR(50) NOT NULL COMMENT 'Foreign key to HEPCourses table',
    E307_CourseCode VARCHAR(20) NOT NULL COMMENT 'Course code (e.g., BCOM01)',
    E597_CRICOSCode VARCHAR(20) COMMENT 'CRICOS code for international students',
    E569_CampusOperationType VARCHAR(2) NOT NULL COMMENT 'Campus operation type',
    E570_PrincipalOffshoreDeliveryMode VARCHAR(2) COMMENT 'Offshore delivery mode code',
    E571_OffshoreDeliveryCode VARCHAR(2) COMMENT 'Offshore delivery type code',
    E609_EffectiveFromDate DATE NOT NULL COMMENT 'Record effective from date',
    E610_EffectiveToDate DATE COMMENT 'Record effective to date',
    
    -- Foreign key constraints
    CONSTRAINT fk_courses_campus_campus FOREIGN KEY (UID2_CampusesResKey) 
        REFERENCES Campuses(UID2_CampusesResKey),
    CONSTRAINT fk_courses_campus_course FOREIGN KEY (UID5_CoursesResKey) 
        REFERENCES HEPCourses(UID5_CoursesResKey),
    
    -- Performance indexes
    INDEX idx_course_campus (UID5_CoursesResKey, UID2_CampusesResKey),
    INDEX idx_course_code (E307_CourseCode),
    INDEX idx_cricos (E597_CRICOSCode),
    INDEX idx_effective_dates (E609_EffectiveFromDate, E610_EffectiveToDate)
) COMMENT='Bridge table linking courses to campuses where they are offered';

-- 3. CampusCourseFeesITSP Table (Campus Course Fees)
-- One-to-many relationship: HEPCoursesOnCampuses → CampusCourseFeesITSP
CREATE TABLE CampusCourseFeesITSP (
    UID31_CampusCourseFeesResKey VARCHAR(50) PRIMARY KEY COMMENT 'Primary key - Fee record identifier',
    UID4_CoursesOnCampusResKey VARCHAR(50) NOT NULL COMMENT 'Foreign key to courses on campus',
    E525_CampusSuburb VARCHAR(100) NOT NULL COMMENT 'Campus suburb',
    E644_CampusCountryCode VARCHAR(3) NOT NULL COMMENT 'Campus country code',
    E559_CampusPostcode VARCHAR(10) NOT NULL COMMENT 'Campus postcode',
    Campuses_E609_EffectiveFromDate DATE NOT NULL COMMENT 'Campus effective from date',
    UID5_CoursesResKey VARCHAR(50) NOT NULL COMMENT 'Foreign key to courses',
    E307_CourseCode VARCHAR(20) NOT NULL COMMENT 'Course code',
    E536_CourseFeesCode VARCHAR(10) NOT NULL COMMENT 'Fee structure code',
    E495_IndicativeStudentContributionCSP DECIMAL(10,2) COMMENT 'Commonwealth Supported Place contribution',
    E496_IndicativeTuitionFeeDomesticFP DECIMAL(10,2) COMMENT 'Domestic fee-paying student tuition',
    E609_EffectiveFromDate DATE NOT NULL COMMENT 'Fee effective from date',
    
    -- Foreign key constraints
    CONSTRAINT fk_fees_courses_campus FOREIGN KEY (UID4_CoursesOnCampusResKey) 
        REFERENCES HEPCoursesOnCampuses(UID4_CoursesOnCampusResKey),
    CONSTRAINT fk_fees_course FOREIGN KEY (UID5_CoursesResKey) 
        REFERENCES HEPCourses(UID5_CoursesResKey),
    
    -- Performance indexes
    INDEX idx_course_campus_fees (UID4_CoursesOnCampusResKey),
    INDEX idx_fees_code (E536_CourseFeesCode),
    INDEX idx_fees_effective_date (E609_EffectiveFromDate)
) COMMENT='Course fee information by campus and time period';

-- 4. CampusesTAC Table (Tertiary Admissions Centre Offerings)
-- One-to-many relationship: HEPCoursesOnCampuses → CampusesTAC
CREATE TABLE CampusesTAC (
    UID40_CoursesOnCampusTACResKey VARCHAR(50) PRIMARY KEY COMMENT 'Primary key - TAC offering identifier',
    UID4_CoursesOnCampusResKey VARCHAR(50) NOT NULL COMMENT 'Foreign key to courses on campus',
    E557_TACOfferCode VARCHAR(2) NOT NULL COMMENT 'TAC offer code (01=Offered through TAC, 02=Direct entry)',
    
    -- Foreign key constraints
    CONSTRAINT fk_tac_courses_campus FOREIGN KEY (UID4_CoursesOnCampusResKey) 
        REFERENCES HEPCoursesOnCampuses(UID4_CoursesOnCampusResKey),
    
    -- Performance indexes
    INDEX idx_course_campus_tac (UID4_CoursesOnCampusResKey),
    INDEX idx_tac_offer_code (E557_TACOfferCode)
) COMMENT='Records which courses are offered through Tertiary Admissions Centres';

-- 5. UnitEnrolments Table (Unit/Subject Enrolments)
-- Multiple foreign key relationships:
-- - HEPCourseAdmissions → UnitEnrolments (one-to-many)
-- - HEPCoursesOnCampuses → UnitEnrolments (one-to-many, optional)
CREATE TABLE UnitEnrolments (
    UID16_UnitEnrolmentsResKey VARCHAR(50) NOT NULL COMMENT 'Unit enrolment identifier',
    UID15_CourseAdmissionsResKey VARCHAR(50) NOT NULL COMMENT 'Foreign key to course admissions',
    UID4_CoursesOnCampusResKey VARCHAR(50) COMMENT 'Foreign key to courses on campus (optional)',
    E354_UnitOfStudyCode VARCHAR(20) NOT NULL COMMENT 'Unit/subject code (e.g., STAT1400)',
    E489_UnitOfStudyCensusDate DATE NOT NULL COMMENT 'Census date for the unit',
    E337_WorkExperienceInIndustryCode VARCHAR(2) COMMENT 'Work experience indicator code',
    E551_SummerWinterSchoolCode VARCHAR(2) COMMENT 'Summer/winter school indicator',
    E464_DisciplineCode VARCHAR(6) NOT NULL COMMENT 'Field of education discipline code',
    E355_UnitOfStudyStatusCode VARCHAR(2) NOT NULL COMMENT 'Unit status code (10=Active, etc.)',
    E329_ModeOfAttendanceCode VARCHAR(2) NOT NULL COMMENT 'Mode of attendance (01=Internal, 02=External)',
    E477_DeliveryLocationPostcode VARCHAR(10) NOT NULL COMMENT 'Delivery location postcode',
    E660_DeliveryLocationCountryCode VARCHAR(3) NOT NULL COMMENT 'Delivery location country code',
    E490_StudentStatusCode VARCHAR(3) NOT NULL COMMENT 'Student status code (201=Active, etc.)',
    E392_MaximumStudentContributionCode VARCHAR(2) COMMENT 'Maximum student contribution indicator',
    E600_UnitOfStudyCommencementDate DATE NOT NULL COMMENT 'Unit start date',
    E601_UnitOfStudyOutcomeDate DATE COMMENT 'Unit completion/outcome date',
    UE_A111_IsDeleted BOOLEAN DEFAULT FALSE COMMENT 'Soft delete flag',
    AsAtMonth DATE NOT NULL COMMENT 'Snapshot month for historical tracking',
    ExtractedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'ETL extraction timestamp',
    Load_Batch_ID VARCHAR(50) COMMENT 'ETL batch identifier',
    Reporting_Year INT NOT NULL COMMENT 'Academic reporting year',
    
    -- Composite primary key (includes time dimension)
    PRIMARY KEY (UID16_UnitEnrolmentsResKey, AsAtMonth),
    
    -- Foreign key constraints
    CONSTRAINT fk_unit_course_admission FOREIGN KEY (UID15_CourseAdmissionsResKey) 
        REFERENCES HEPCourseAdmissions(UID15_CourseAdmissionsResKey),
    CONSTRAINT fk_unit_course_campus FOREIGN KEY (UID4_CoursesOnCampusResKey) 
        REFERENCES HEPCoursesOnCampuses(UID4_CoursesOnCampusResKey),
    
    -- Performance indexes
    INDEX idx_course_admission (UID15_CourseAdmissionsResKey),
    INDEX idx_campus_course (UID4_CoursesOnCampusResKey),
    INDEX idx_unit_code (E354_UnitOfStudyCode),
    INDEX idx_census_date (E489_UnitOfStudyCensusDate),
    INDEX idx_student_status (E490_StudentStatusCode),
    INDEX idx_unit_status (E355_UnitOfStudyStatusCode),
    INDEX idx_reporting_year (Reporting_Year),
    INDEX idx_as_at_month (AsAtMonth),
    INDEX idx_deleted_flag (UE_A111_IsDeleted)
) COMMENT='Student unit/subject enrolment records with monthly snapshots';

-- 6. UnitEnrolmentAOUs Table (Unit Enrolment Areas of Study)
-- One-to-many relationship: UnitEnrolments → UnitEnrolmentAOUs
CREATE TABLE UnitEnrolmentAOUs (
    UID19_UnitEnrolmentAOUsResKey VARCHAR(50) NOT NULL COMMENT 'AOU record identifier',
    UID16_UnitEnrolmentsResKey VARCHAR(50) NOT NULL COMMENT 'Foreign key to unit enrolments',
    E333_AOUCode VARCHAR(20) NOT NULL COMMENT 'Area of Study code',
    AOU_E339_EFTSL DECIMAL(4,3) COMMENT 'Equivalent Full-Time Student Load for AOU',
    AOU_E384_AmountCharged DECIMAL(10,2) COMMENT 'Amount charged for AOU',
    AOU_E381_AmountPaidUpfront DECIMAL(10,2) COMMENT 'Amount paid upfront for AOU',
    AOU_E529_LoanFee DECIMAL(10,2) COMMENT 'Loan fee amount for AOU',
    AOU_IsDeleted BOOLEAN DEFAULT FALSE COMMENT 'Soft delete flag',
    AsAtMonth DATE NOT NULL COMMENT 'Snapshot month matching parent record',
    ExtractedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'ETL extraction timestamp',
    Load_Batch_ID VARCHAR(50) COMMENT 'ETL batch identifier',
    Reporting_Year INT NOT NULL COMMENT 'Academic reporting year',
    
    -- Composite primary key (includes time dimension)
    PRIMARY KEY (UID19_UnitEnrolmentAOUsResKey, AsAtMonth),
    
    -- Composite foreign key (matches UnitEnrolments composite primary key)
    CONSTRAINT fk_aou_unit_enrolment FOREIGN KEY (UID16_UnitEnrolmentsResKey, AsAtMonth) 
        REFERENCES UnitEnrolments(UID16_UnitEnrolmentsResKey, AsAtMonth),
    
    -- Performance indexes
    INDEX idx_unit_enrolment (UID16_UnitEnrolmentsResKey),
    INDEX idx_aou_code (E333_AOUCode),
    INDEX idx_aou_deleted (AOU_IsDeleted),
    INDEX idx_aou_month (AsAtMonth),
    INDEX idx_aou_reporting_year (Reporting_Year)
) COMMENT='Areas of Study breakdown for unit enrolments';

-- ================================================
-- 7. HEP_units_AOUs Table (Comprehensive Wide Table)
-- Denormalized table combining UnitEnrolments and UnitEnrolmentAOUs
-- Optimized for reporting and analysis
-- ================================================

CREATE TABLE `HEP_units_AOUs` (
    UE_AOU_Key INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Auto-increment primary key',
    Student_key INT NOT NULL COMMENT 'Foreign key to HEPStudents',
    E313_StudentIdentificationCode VARCHAR(20) NOT NULL COMMENT 'Student ID code',
    E488_CHESSN VARCHAR(20) COMMENT 'Commonwealth Higher Ed Student Support Number',
    UID15_CourseAdmissionsResKey VARCHAR(50) NOT NULL COMMENT 'Course admission identifier',
    E533_CourseOfStudyCode VARCHAR(20) NOT NULL COMMENT 'Course of study code',
    E310_CourseOfStudyType VARCHAR(2) NOT NULL COMMENT 'Course type code',
    UID5_CoursesResKey VARCHAR(50) NOT NULL COMMENT 'Course identifier',
    E307_CourseCode VARCHAR(20) NOT NULL COMMENT 'Course code',
    E308_CourseName VARCHAR(200) NOT NULL COMMENT 'Course name',
    E534_CourseOfStudyCommDate DATE NOT NULL COMMENT 'Course commencement date',
    
    -- Unit Enrolment Fields
    UID16_UnitEnrolmentsResKey VARCHAR(50) NOT NULL COMMENT 'Unit enrolment identifier',
    E354_UnitOfStudyCode VARCHAR(20) NOT NULL COMMENT 'Unit code',
    E489_UnitOfStudyCensusDate DATE NOT NULL COMMENT 'Census date',
    E337_WorkExperienceInIndustryCode VARCHAR(2) COMMENT 'Work experience code',
    E551_SummerWinterSchoolCode VARCHAR(2) COMMENT 'Summer/winter school code',
    E464_DisciplineCode VARCHAR(6) NOT NULL COMMENT 'Discipline code',
    E355_UnitOfStudyStatusCode VARCHAR(2) NOT NULL COMMENT 'Unit status code',
    E329_ModeOfAttendanceCode VARCHAR(2) NOT NULL COMMENT 'Attendance mode code',
    E477_DeliveryLocationPostcode VARCHAR(10) NOT NULL COMMENT 'Delivery postcode',
    E660_DeliveryLocationCountryCode VARCHAR(3) NOT NULL COMMENT 'Delivery country',
    E490_StudentStatusCode VARCHAR(3) NOT NULL COMMENT 'Student status code',
    E392_MaximumStudentContributionCode VARCHAR(2) COMMENT 'Max contribution code',
    E600_UnitOfStudyCommencementDate DATE NOT NULL COMMENT 'Unit start date',
    E601_UnitOfStudyOutcomeDate DATE COMMENT 'Unit outcome date',
    E446_RemissionReasonCode VARCHAR(2) COMMENT 'Fee remission reason',
    A130_LoanStatus VARCHAR(2) COMMENT 'HELP loan status',
    UID21_StudentLoansResKey VARCHAR(50) COMMENT 'Student loan identifier',
    E662_AdjustedLoanAmount DECIMAL(10,2) COMMENT 'Adjusted loan amount',
    E663_AdjustedLoanFee DECIMAL(10,2) COMMENT 'Adjusted loan fee',
    
    -- Unit Enrolment Financial Fields
    UE_E339_EFTSL DECIMAL(4,3) NOT NULL COMMENT 'Unit EFTSL value',
    UE_E384_AmountCharged DECIMAL(10,2) NOT NULL COMMENT 'Unit amount charged',
    UE_E381_AmountPaidUpfront DECIMAL(10,2) COMMENT 'Unit amount paid upfront',
    UE_E558_HELPLoanAmount DECIMAL(10,2) COMMENT 'Unit HELP loan amount',
    UE_E529_LoanFee DECIMAL(10,2) COMMENT 'Unit loan fee',
    UE_A111_IsDeleted BOOLEAN DEFAULT FALSE COMMENT 'Unit deletion flag',
    
    -- AOU Fields
    UID19_UnitEnrolmentAOUsResKey VARCHAR(50) COMMENT 'AOU identifier',
    E333_AOUCode VARCHAR(20) COMMENT 'Area of Study code',
    AOU_E339_EFTSL DECIMAL(4,3) COMMENT 'AOU EFTSL value',
    AOU_E384_AmountCharged DECIMAL(10,2) COMMENT 'AOU amount charged',
    AOU_E381_AmountPaidUpfront DECIMAL(10,2) COMMENT 'AOU amount paid upfront',
    AOU_E529_LoanFee DECIMAL(10,2) COMMENT 'AOU loan fee',
    AOU_IsDeleted BOOLEAN DEFAULT FALSE COMMENT 'AOU deletion flag',
    
    -- Time and ETL Fields
    Year INT NOT NULL COMMENT 'Academic year',
    Start_Date DATE NOT NULL COMMENT 'Record start date',
    End_Date DATE COMMENT 'Record end date',
    Is_Current BOOLEAN DEFAULT TRUE COMMENT 'Current record indicator',
    
    -- Foreign key constraints
    CONSTRAINT fk_wide_student FOREIGN KEY (Student_key) 
        REFERENCES HEPStudents(Student_Key),
    CONSTRAINT fk_wide_admission FOREIGN KEY (UID15_CourseAdmissionsResKey) 
        REFERENCES HEPCourseAdmissions(UID15_CourseAdmissionsResKey),
    CONSTRAINT fk_wide_course FOREIGN KEY (UID5_CoursesResKey) 
        REFERENCES HEPCourses(UID5_CoursesResKey),
    CONSTRAINT fk_wide_loan FOREIGN KEY (UID21_StudentLoansResKey) 
        REFERENCES StudentLoans(UID21_StudentLoansResKey),
    
    -- Performance indexes
    INDEX idx_student (Student_key),
    INDEX idx_student_id (E313_StudentIdentificationCode),
    INDEX idx_chessn (E488_CHESSN),
    INDEX idx_course_admission (UID15_CourseAdmissionsResKey),
    INDEX idx_unit_code (E354_UnitOfStudyCode),
    INDEX idx_census_date (E489_UnitOfStudyCensusDate),
    INDEX idx_aou_code (E333_AOUCode),
    INDEX idx_year (Year),
    INDEX idx_current (Is_Current),
    INDEX idx_unit_status_current (E355_UnitOfStudyStatusCode, Is_Current),
    INDEX idx_student_unit_year (Student_key, E354_UnitOfStudyCode, Year)
) COMMENT='Denormalized wide table for reporting and analytics';

-- ================================================
-- Data Integrity Check Views
-- ================================================

-- View: Check for orphaned unit enrolment records
CREATE VIEW v_orphaned_unit_enrolments AS
SELECT ue.*
FROM UnitEnrolments ue
LEFT JOIN HEPCourseAdmissions ca ON ue.UID15_CourseAdmissionsResKey = ca.UID15_CourseAdmissionsResKey
WHERE ca.UID15_CourseAdmissionsResKey IS NULL;

-- View: Currently active course-campus combinations
CREATE VIEW v_current_courses_on_campus AS
SELECT *
FROM HEPCoursesOnCampuses
WHERE (E610_EffectiveToDate IS NULL OR E610_EffectiveToDate >= CURDATE())
  AND E609_EffectiveFromDate <= CURDATE();

-- ================================================
-- Stored Procedures for Incremental Data Updates
-- ================================================

DELIMITER $$

-- Stored Procedure: Insert or update UnitEnrolments records (preserves history)
CREATE PROCEDURE sp_upsert_unit_enrolment(
    IN p_UID16_UnitEnrolmentsResKey VARCHAR(50),
    IN p_UID15_CourseAdmissionsResKey VARCHAR(50),
    IN p_AsAtMonth DATE,
    IN p_E354_UnitOfStudyCode VARCHAR(20),
    IN p_E489_UnitOfStudyCensusDate DATE,
    IN p_Reporting_Year INT,
    IN p_Load_Batch_ID VARCHAR(50)
)
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    
    -- Check if record exists
    SELECT COUNT(*) INTO v_exists
    FROM UnitEnrolments
    WHERE UID16_UnitEnrolmentsResKey = p_UID16_UnitEnrolmentsResKey
      AND AsAtMonth = p_AsAtMonth;
    
    IF v_exists = 0 THEN
        -- Insert new record
        INSERT INTO UnitEnrolments (
            UID16_UnitEnrolmentsResKey,
            UID15_CourseAdmissionsResKey,
            AsAtMonth,
            E354_UnitOfStudyCode,
            E489_UnitOfStudyCensusDate,
            Reporting_Year,
            Load_Batch_ID,
            ExtractedAt
        ) VALUES (
            p_UID16_UnitEnrolmentsResKey,
            p_UID15_CourseAdmissionsResKey,
            p_AsAtMonth,
            p_E354_UnitOfStudyCode,
            p_E489_UnitOfStudyCensusDate,
            p_Reporting_Year,
            p_Load_Batch_ID,
            CURRENT_TIMESTAMP
        );
    ELSE
        -- Update existing record's Load_Batch_ID and ExtractedAt
        UPDATE UnitEnrolments
        SET Load_Batch_ID = p_Load_Batch_ID,
            ExtractedAt = CURRENT_TIMESTAMP
        WHERE UID16_UnitEnrolmentsResKey = p_UID16_UnitEnrolmentsResKey
          AND AsAtMonth = p_AsAtMonth;
    END IF;
END$$

-- Stored Procedure: Generate monthly summary report
CREATE PROCEDURE sp_generate_monthly_report(
    IN p_reporting_month DATE
)
BEGIN
    SELECT 
        c.E525_CampusSuburb AS Campus,
        coc.E307_CourseCode AS CourseCode,
        COUNT(DISTINCT ue.UID16_UnitEnrolmentsResKey) AS TotalEnrolments,
        SUM(CASE WHEN ue.E355_UnitOfStudyStatusCode = '10' THEN 1 ELSE 0 END) AS ActiveEnrolments,
        SUM(CASE WHEN ue.UE_A111_IsDeleted = FALSE THEN 1 ELSE 0 END) AS ValidEnrolments,
        COUNT(DISTINCT ue.E354_UnitOfStudyCode) AS UniqueUnits,
        p_reporting_month AS ReportingMonth
    FROM UnitEnrolments ue
    JOIN HEPCoursesOnCampuses coc ON ue.UID4_CoursesOnCampusResKey = coc.UID4_CoursesOnCampusResKey
    JOIN Campuses c ON coc.UID2_CampusesResKey = c.UID2_CampusesResKey
    WHERE ue.AsAtMonth = p_reporting_month
    GROUP BY c.E525_CampusSuburb, coc.E307_CourseCode
    ORDER BY c.E525_CampusSuburb, coc.E307_CourseCode;
END$$

DELIMITER ;

-- ================================================
-- Triggers for Data Integrity
-- ================================================

DELIMITER $$

-- Trigger: Validate parent record exists before inserting AOU
CREATE TRIGGER trg_check_unit_enrolment_exists
BEFORE INSERT ON UnitEnrolmentAOUs
FOR EACH ROW
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_exists
    FROM UnitEnrolments
    WHERE UID16_UnitEnrolmentsResKey = NEW.UID16_UnitEnrolmentsResKey
      AND AsAtMonth = NEW.AsAtMonth;
    
    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Parent UnitEnrolment record does not exist';
    END IF;
END$$

-- Trigger: Log changes for wide table updates
CREATE TRIGGER trg_log_unit_enrolment_changes
AFTER INSERT ON UnitEnrolments
FOR EACH ROW
BEGIN
    -- Log changes for batch processing of wide table updates
    -- This avoids real-time updates for better performance
    INSERT INTO update_queue (table_name, record_key, action, created_at)
    VALUES ('UnitEnrolments', NEW.UID16_UnitEnrolmentsResKey, 'INSERT', NOW());
END$$

DELIMITER ;



/*
TABLE RELATIONSHIPS:

1. ONE-TO-MANY RELATIONSHIPS:
   - Campuses (1) → HEPCoursesOnCampuses (*)
     One campus can host multiple courses
   
   - HEPCourses (1) → HEPCoursesOnCampuses (*)
     One course can be offered at multiple campuses
   
   - HEPCoursesOnCampuses (1) → CampusCourseFeesITSP (*)
     One course-campus combination can have multiple fee records over time
   
   - HEPCoursesOnCampuses (1) → CampusesTAC (*)
     One course-campus combination can have multiple TAC offering methods
   
   - HEPCourseAdmissions (1) → UnitEnrolments (*)
     One course admission can have multiple unit enrolments
   
   - HEPCoursesOnCampuses (1) → UnitEnrolments (*)
     One course-campus combination can have multiple unit enrolments
   
   - UnitEnrolments (1) → UnitEnrolmentAOUs (*)
     One unit enrolment can have multiple areas of study

2. MANY-TO-MANY RELATIONSHIPS:
   - HEPCourses (*) ↔ Campuses (*)
     Implemented through HEPCoursesOnCampuses bridge table
     A course can be offered at multiple campuses, a campus can offer multiple courses

3. OPTIONAL RELATIONSHIPS:
   - UnitEnrolments → HEPCoursesOnCampuses
     UID4_CoursesOnCampusResKey can be NULL (some units may not be campus-specific)

4. TEMPORAL RELATIONSHIPS:
   - UnitEnrolments and UnitEnrolmentAOUs use composite keys with AsAtMonth
     Supports monthly snapshots and historical data preservation

5. SOFT DELETE SUPPORT:
   - UnitEnrolments (UE_A111_IsDeleted flag)
   - UnitEnrolmentAOUs (AOU_IsDeleted flag)
     Maintains audit trail without physical deletion

