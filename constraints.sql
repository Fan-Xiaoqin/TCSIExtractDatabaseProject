-- =============================================
-- TCSI Extract Database - Constraints and Relationships
-- Version: 2.0
-- Date: September 2025
-- Description: Primary keys, foreign keys, unique constraints, and check constraints
-- =============================================

-- =============================================
-- PRIMARY KEY CONSTRAINTS
-- =============================================

-- Core Tables Primary Keys
ALTER TABLE HEPStudents 
ADD CONSTRAINT PK_HEPStudents PRIMARY KEY (Student_key);

ALTER TABLE StudentResidentialAddress 
ADD CONSTRAINT PK_StudentResidentialAddress PRIMARY KEY (Address_key);

ALTER TABLE CourseAdmissions 
ADD CONSTRAINT PK_CourseAdmissions PRIMARY KEY (UID15_CourseAdmissionsResKey);

ALTER TABLE UnitEnrolments 
ADD CONSTRAINT PK_UnitEnrolments PRIMARY KEY (UID16_UnitEnrolmentsResKey);

ALTER TABLE SAHELP 
ADD CONSTRAINT PK_SAHELP PRIMARY KEY (UID17_SAHELPResKey);

-- Reference Tables Primary Keys
ALTER TABLE HEPProviders 
ADD CONSTRAINT PK_HEPProviders PRIMARY KEY (UID1_ProvidersResKey);

ALTER TABLE Courses 
ADD CONSTRAINT PK_Courses PRIMARY KEY (UID5_CoursesResKey);

ALTER TABLE CoursesOfStudy 
ADD CONSTRAINT PK_CoursesOfStudy PRIMARY KEY (UID3_CoursesOfStudyResKey);

ALTER TABLE Campuses 
ADD CONSTRAINT PK_Campuses PRIMARY KEY (UID30_CampusesResKey);

-- Relationship Tables Primary Keys
ALTER TABLE CoursesOnCampuses 
ADD CONSTRAINT PK_CoursesOnCampuses PRIMARY KEY (UID4_CoursesOnCampusResKey);

ALTER TABLE CampusCourseFees 
ADD CONSTRAINT PK_CampusCourseFees PRIMARY KEY (UID31_CampusCourseFeesResKey);

ALTER TABLE AggregatedAwards 
ADD CONSTRAINT PK_AggregatedAwards PRIMARY KEY (UID20_AggregatedAwardsResKey);

ALTER TABLE ExitAwards 
ADD CONSTRAINT PK_ExitAwards PRIMARY KEY (UID21_ExitAwardsResKey);

-- =============================================
-- FOREIGN KEY CONSTRAINTS
-- =============================================

-- StudentResidentialAddress Foreign Keys
ALTER TABLE StudentResidentialAddress
ADD CONSTRAINT FK_StudentAddress_Student 
    FOREIGN KEY (Student_key) 
    REFERENCES HEPStudents(Student_key)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- CourseAdmissions Foreign Keys
ALTER TABLE CourseAdmissions
ADD CONSTRAINT FK_CourseAdmissions_Student 
    FOREIGN KEY (Student_key) 
    REFERENCES HEPStudents(Student_key)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

ALTER TABLE CourseAdmissions
ADD CONSTRAINT FK_CourseAdmissions_Course 
    FOREIGN KEY (UID5_CoursesResKey) 
    REFERENCES Courses(UID5_CoursesResKey)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- UnitEnrolments Foreign Keys
ALTER TABLE UnitEnrolments
ADD CONSTRAINT FK_UnitEnrolments_Student 
    FOREIGN KEY (Student_key) 
    REFERENCES HEPStudents(Student_key)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

ALTER TABLE UnitEnrolments
ADD CONSTRAINT FK_UnitEnrolments_CourseAdmission 
    FOREIGN KEY (UID15_CourseAdmissionsResKey) 
    REFERENCES CourseAdmissions(UID15_CourseAdmissionsResKey)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- SAHELP Foreign Keys (Updated per Stage 4)
ALTER TABLE SAHELP
ADD CONSTRAINT FK_SAHELP_Student 
    FOREIGN KEY (Student_key) 
    REFERENCES HEPStudents(Student_key)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- Courses Foreign Keys
ALTER TABLE Courses
ADD CONSTRAINT FK_Courses_CourseOfStudy 
    FOREIGN KEY (UID3_CoursesOfStudyResKey) 
    REFERENCES CoursesOfStudy(UID3_CoursesOfStudyResKey)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- CoursesOnCampuses Foreign Keys
ALTER TABLE CoursesOnCampuses
ADD CONSTRAINT FK_CoursesOnCampuses_Course 
    FOREIGN KEY (UID5_CoursesResKey) 
    REFERENCES Courses(UID5_CoursesResKey)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE CoursesOnCampuses
ADD CONSTRAINT FK_CoursesOnCampuses_Campus 
    FOREIGN KEY (UID30_CampusesResKey) 
    REFERENCES Campuses(UID30_CampusesResKey)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- CampusCourseFees Foreign Keys
ALTER TABLE CampusCourseFees
ADD CONSTRAINT FK_CampusCourseFees_CourseOnCampus 
    FOREIGN KEY (UID4_CoursesOnCampusResKey) 
    REFERENCES CoursesOnCampuses(UID4_CoursesOnCampusResKey)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- AggregatedAwards Foreign Keys (Updated per Stage 4)
ALTER TABLE AggregatedAwards
ADD CONSTRAINT FK_AggregatedAwards_Student 
    FOREIGN KEY (Student_key) 
    REFERENCES HEPStudents(Student_key)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

ALTER TABLE AggregatedAwards
ADD CONSTRAINT FK_AggregatedAwards_Course 
    FOREIGN KEY (UID5_CoursesResKey) 
    REFERENCES Courses(UID5_CoursesResKey)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- ExitAwards Foreign Keys
ALTER TABLE ExitAwards
ADD CONSTRAINT FK_ExitAwards_Student 
    FOREIGN KEY (Student_key) 
    REFERENCES HEPStudents(Student_key)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

ALTER TABLE ExitAwards
ADD CONSTRAINT FK_ExitAwards_Course 
    FOREIGN KEY (UID5_CoursesResKey) 
    REFERENCES Courses(UID5_CoursesResKey)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- =============================================
-- UNIQUE CONSTRAINTS
-- =============================================

-- Ensure student IDs are unique within provider
ALTER TABLE HEPStudents
ADD CONSTRAINT UQ_StudentIdentificationCode 
    UNIQUE (E313_StudentIdentificationCode);

-- Ensure CHESSN is unique when provided
ALTER TABLE HEPStudents
ADD CONSTRAINT UQ_CHESSN 
    UNIQUE (E488_CHESSN);

-- Ensure USI is unique when provided
ALTER TABLE HEPStudents
ADD CONSTRAINT UQ_USI 
    UNIQUE (E584_USI);

-- Ensure one current address per student
ALTER TABLE StudentResidentialAddress
ADD CONSTRAINT UQ_CurrentAddress 
    UNIQUE (Student_key, effective_to_date);

-- Ensure unique course codes within provider
ALTER TABLE Courses
ADD CONSTRAINT UQ_CourseCode 
    UNIQUE (E307_CourseCode);

-- Ensure unique provider codes
ALTER TABLE HEPProviders
ADD CONSTRAINT UQ_ProviderCode 
    UNIQUE (E306_ProviderCode);

-- Prevent duplicate enrollments
ALTER TABLE UnitEnrolments
ADD CONSTRAINT UQ_UnitEnrolment 
    UNIQUE (Student_key, E354_UnitOfStudyCode, E489_UnitOfStudyCensusDate);

-- Prevent duplicate admissions
ALTER TABLE CourseAdmissions
ADD CONSTRAINT UQ_CourseAdmission 
    UNIQUE (Student_key, UID5_CoursesResKey, E534_CourseOfStudyCommDate);

-- =============================================
-- CHECK CONSTRAINTS
-- =============================================

-- Gender validation
ALTER TABLE HEPStudents
ADD CONSTRAINT CHK_GenderCode 
    CHECK (E314_GenderCode IN ('M', 'F', 'X'));

-- ATSI code validation
ALTER TABLE HEPStudents
ADD CONSTRAINT CHK_ATSICode 
    CHECK (E316_ATSICode IN ('1', '2', '3', '4') OR E316_ATSICode IS NULL);

-- Year of arrival validation
ALTER TABLE HEPStudents
ADD CONSTRAINT CHK_YearOfArrival 
    CHECK (E347_YearOfArrivalInAustralia BETWEEN 1900 AND YEAR(CURRENT_DATE) 
           OR E347_YearOfArrivalInAustralia IS NULL);

-- Date of birth validation
ALTER TABLE HEPStudents
ADD CONSTRAINT CHK_DateOfBirth 
    CHECK (E315_DateOfBirth <= CURRENT_DATE);

-- Permanent resident status validation
ALTER TABLE HEPStudents
ADD CONSTRAINT CHK_PermanentResident 
    CHECK (E359_PermanentResidentStatus IN ('Y', 'N') 
           OR E359_PermanentResidentStatus IS NULL);

-- Student status validation
ALTER TABLE HEPStudents
ADD CONSTRAINT CHK_StudentStatus 
    CHECK (E490_StudentStatusCode IN ('Active', 'Inactive', 'Graduated', 'Withdrawn', 'Deferred'));

-- Unit enrollment status validation
ALTER TABLE UnitEnrolments
ADD CONSTRAINT CHK_UnitStatus 
    CHECK (E355_UnitOfStudyStatusCode IN ('Enrolled', 'Withdrawn', 'Completed', 'Failed', 'Exempt'));

-- Mode of attendance validation
ALTER TABLE UnitEnrolments
ADD CONSTRAINT CHK_ModeOfAttendance 
    CHECK (E329_ModeOfAttendanceCode IN ('Internal', 'External', 'Multi-modal'));

-- EFTSL range validation (0 to 1)
ALTER TABLE UnitEnrolments
ADD CONSTRAINT CHK_EFTSL 
    CHECK (E339_EFTSL >= 0 AND E339_EFTSL <= 1.000);

-- Census date validation
ALTER TABLE UnitEnrolments
ADD CONSTRAINT CHK_CensusDate 
    CHECK (E489_UnitOfStudyCensusDate >= E534_CourseOfStudyCommDate);

-- Course commencement date validation
ALTER TABLE CourseAdmissions
ADD CONSTRAINT CHK_CommencementDate 
    CHECK (E534_CourseOfStudyCommDate <= CURRENT_DATE);

-- Effective date validation
ALTER TABLE Courses
ADD CONSTRAINT CHK_CourseEffectiveDates 
    CHECK (E609_EffectiveFromDate < E610_EffectiveToDate 
           OR E610_EffectiveToDate IS NULL);

ALTER TABLE Campuses
ADD CONSTRAINT CHK_CampusEffectiveDates 
    CHECK (E609_EffectiveFromDate <= CURRENT_DATE);

ALTER TABLE CoursesOnCampuses
ADD CONSTRAINT CHK_CourseOnCampusEffectiveDates 
    CHECK (E609_EffectiveFromDate < E610_EffectiveToDate 
           OR E610_EffectiveToDate IS NULL);

-- Fee amount validations
ALTER TABLE CampusCourseFees
ADD CONSTRAINT CHK_FeeAmounts 
    CHECK (E495_IndicativeStudentContributionCSP >= 0 
           AND E496_IndicativeTuitionFeeDomesticFP >= 0 
           AND E497_IndicativeTuitionFeeInternational >= 0);

-- HELP eligibility validation
ALTER TABLE SAHELP
ADD CONSTRAINT CHK_HELPEligibility 
    CHECK (E392_HELPEligibilityCode IN ('Y', 'N'));

-- Amount paid cannot exceed amount charged
ALTER TABLE SAHELP
ADD CONSTRAINT CHK_SAHELPAmounts 
    CHECK (E384_AmountPaidUpfront <= E381_AmountChargedUpfront 
           OR E384_AmountPaidUpfront IS NULL);

ALTER TABLE UnitEnrolments
ADD CONSTRAINT CHK_UnitPaymentAmounts 
    CHECK (E384_AmountPaidUpfront <= E381_AmountChargedUpfront 
           OR E384_AmountPaidUpfront IS NULL);

-- Award completion year validation
ALTER TABLE ExitAwards
ADD CONSTRAINT CHK_CompletionYear 
    CHECK (E593_AwardCompletionYear BETWEEN 1950 AND YEAR(CURRENT_DATE));

-- Reporting year validation
ALTER TABLE CourseAdmissions
ADD CONSTRAINT CHK_ReportingYear_Admissions 
    CHECK (reporting_year BETWEEN 2020 AND 2100);

ALTER TABLE UnitEnrolments
ADD CONSTRAINT CHK_ReportingYear_Enrolments 
    CHECK (reporting_year BETWEEN 2020 AND 2100);

ALTER TABLE SAHELP
ADD CONSTRAINT CHK_ReportingYear_SAHELP 
    CHECK (reporting_year BETWEEN 2020 AND 2100);

ALTER TABLE AggregatedAwards
ADD CONSTRAINT CHK_ReportingYear_Awards 
    CHECK (reporting_year BETWEEN 2020 AND 2100);

-- =============================================
-- COMPOSITE CONSTRAINTS
-- =============================================

-- Ensure address effective dates don't overlap for same student
ALTER TABLE StudentResidentialAddress
ADD CONSTRAINT CHK_AddressDateOverlap 
    CHECK (effective_from_date < effective_to_date 
           OR effective_to_date IS NULL);

-- Ensure course duration is positive
ALTER TABLE Courses
ADD CONSTRAINT CHK_CourseDuration 
    CHECK (E596_StandardCourseDuration > 0 AND E596_StandardCourseDuration <= 10);

-- Combined course indicator validation
ALTER TABLE CoursesOfStudy
ADD CONSTRAINT CHK_CombinedCourseIndicator 
    CHECK (E455_CombinedCourseOfStudyIndicator IN ('Y', 'N') 
           OR E455_CombinedCourseOfStudyIndicator IS NULL);

-- Summer/Winter school indicator validation
ALTER TABLE UnitEnrolments
ADD CONSTRAINT CHK_SummerWinterSchool 
    CHECK (E551_SummerWinterSchoolCode IN ('Y', 'N') 
           OR E551_SummerWinterSchoolCode IS NULL);

-- Work experience indicator validation
ALTER TABLE UnitEnrolments
ADD CONSTRAINT CHK_WorkExperience 
    CHECK (E337_WorkExperienceInIndustryCode IN ('Y', 'N') 
           OR E337_WorkExperienceInIndustryCode IS NULL);

-- =============================================
-- DEFAULT CONSTRAINTS
-- =============================================

-- Set default extraction date to current timestamp
ALTER TABLE HEPStudents 
ALTER COLUMN extraction_date SET DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE HEPStudents 
ALTER COLUMN created_date SET DEFAULT CURRENT_TIMESTAMP;

-- Set default reporting year to current year
ALTER TABLE CourseAdmissions 
ALTER COLUMN reporting_year SET DEFAULT YEAR(CURRENT_DATE);

ALTER TABLE UnitEnrolments 
ALTER COLUMN reporting_year SET DEFAULT YEAR(CURRENT_DATE);

ALTER TABLE SAHELP 
ALTER COLUMN reporting_year SET DEFAULT YEAR(CURRENT_DATE);

ALTER TABLE AggregatedAwards 
ALTER COLUMN reporting_year SET DEFAULT YEAR(CURRENT_DATE);

ALTER TABLE ExitAwards 
ALTER COLUMN reporting_year SET DEFAULT YEAR(CURRENT_DATE);

-- Set default reporting date to current date
ALTER TABLE UnitEnrolments 
ALTER COLUMN E415_ReportingDate SET DEFAULT CURRENT_DATE;

ALTER TABLE SAHELP 
ALTER COLUMN E415_ReportingDate SET DEFAULT CURRENT_DATE;

-- =============================================
-- TRIGGER CONSTRAINTS (Optional - for auto-update)
-- =============================================

-- Note: These are MySQL/PostgreSQL style triggers
-- Adjust syntax for your specific database system

DELIMITER $$

-- Auto-update modified_date on HEPStudents
CREATE TRIGGER trg_UpdateModifiedDate
BEFORE UPDATE ON HEPStudents
FOR EACH ROW
BEGIN
    SET NEW.modified_date = CURRENT_TIMESTAMP;
END$$

-- Validate CHESSN format (10 digits)
CREATE TRIGGER trg_ValidateCHESSN
BEFORE INSERT ON HEPStudents
FOR EACH ROW
BEGIN
    IF NEW.E488_CHESSN IS NOT NULL 
       AND (LENGTH(NEW.E488_CHESSN) != 10 OR NEW.E488_CHESSN NOT REGEXP '^[0-9]+$') THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'CHESSN must be exactly 10 digits';
    END IF;
END$$

-- Ensure only one current address per student
CREATE TRIGGER trg_ValidateCurrentAddress
BEFORE INSERT ON StudentResidentialAddress
FOR EACH ROW
BEGIN
    IF NEW.effective_to_date IS NULL THEN
        UPDATE StudentResidentialAddress 
        SET effective_to_date = CURRENT_DATE
        WHERE Student_key = NEW.Student_key 
        AND effective_to_date IS NULL;
    END IF;
END$$

DELIMITER ;

-- =============================================
-- END OF CONSTRAINTS DEFINITION
-- =============================================