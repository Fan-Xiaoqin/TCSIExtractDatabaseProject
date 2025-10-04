-- ================================================
-- TCSI Stage 4 Sample Data
-- Updated for Final Client-Approved Structure with SCD-2
-- ================================================

-- Clear existing data (optional - use with caution)
/*
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE UnitEnrolmentAOUs;
TRUNCATE TABLE UnitEnrolments;
TRUNCATE TABLE OSHELP;
TRUNCATE TABLE SAHELP;
TRUNCATE TABLE ExitAwards;
TRUNCATE TABLE AggregatedAwards;
TRUNCATE TABLE CourseAdmissions;
TRUNCATE TABLE StudentResidentialAddress;
TRUNCATE TABLE StudentDisabilities;
TRUNCATE TABLE StudentCitizenship;
TRUNCATE TABLE CampusesTAC;
TRUNCATE TABLE CampusCourseFeesITSP;
TRUNCATE TABLE CoursesOnCampuses;
TRUNCATE TABLE Campuses;
TRUNCATE TABLE Courses;
TRUNCATE TABLE HEPStudents;
SET FOREIGN_KEY_CHECKS = 1;
*/

-- ================================================
-- 1. HEPStudents - Core student demographics
-- ================================================

INSERT INTO HEPStudents (
    Student_Key, UID8_StudentsResKey, E313_StudentIdentificationCode, E488_CHESSN, E584_USI,
    A170_USIVerificationStatus, A167_TFNVerificationStatus, E314_DateOfBirth,
    E402_StudentFamilyName, E403_StudentGivenNameFirst, E404_StudentGivenNameOthers,
    E315_GenderCode, E316_ATSICode, E346_CountryOfBirthCode, E347_ArrivalInAustraliaYear,
    E348_LanguageSpokenAtHomeCode, E572_YearLeftSchool, E612_LevelLeftSchool,
    E573_HighestEducationParent1, E574_HighestEducationParent2,
    E319_TermResidencePostcode, E661_TermResidenceCountryCode,
    IsCurrent
) VALUES
(100001, 'STU100001', 'S2024001', '987654321A', 'USI123456789', 'Y', 'Y', '2003-03-15',
 'Smith', 'Emily', 'Jane', '02', '04', 'AUS', NULL, '1201', 2020, '12', '08', '06',
 '6009', 'AUS', TRUE),

(100002, 'STU100002', 'S2024002', '876543210B', 'USI234567890', 'Y', 'Y', '2002-07-22',
 'Chen', 'Wei', 'Michael', '01', '04', 'CHN', 2015, '2401', 2019, '12', '11', '11',
 '6000', 'AUS', TRUE),

(100003, 'STU100003', 'S2024003', NULL, 'USI345678901', 'Y', 'N', '2001-11-08',
 'Kumar', 'Priya', NULL, '02', '04', 'IND', 2023, '4202', 2019, '12', '11', '08',
 '6009', 'AUS', TRUE),

(100004, 'STU100004', 'S2024004', '765432109C', 'USI456789012', 'Y', 'Y', '2004-01-25',
 'Williams', 'Jack', 'Thomas', '01', '01', 'AUS', NULL, '1201', 2021, '12', '05', '05',
 '6014', 'AUS', TRUE),

(100005, 'STU100005', 'S2024005', '654321098D', 'USI567890123', 'Y', 'Y', '1985-09-30',
 'Anderson', 'Sarah', 'Louise', '02', '04', 'NZL', 2010, '1201', 2003, '12', '06', '05',
 '6008', 'AUS', TRUE);

-- ================================================
-- 2. StudentResidentialAddress - Current addresses (normalized)
-- ================================================

INSERT INTO StudentResidentialAddress (
    Student_Key, E410_ResidentialAddressLine1, E469_ResidentialAddressSuburb,
    E320_ResidentialAddressPostcode, E470_ResidentialAddressState,
    E658_ResidentialAddressCountryCode, IsCurrent
) VALUES
(100001, '45 Stirling Highway', 'Crawley', '6009', 'WA', 'AUS', TRUE),
(100002, '12 Mounts Bay Road', 'Perth', '6000', 'WA', 'AUS', TRUE),
(100003, '78 Broadway', 'Nedlands', '6009', 'WA', 'AUS', TRUE),
(100004, '234 Cambridge Street', 'Wembley', '6014', 'WA', 'AUS', TRUE),
(100005, '567 Hay Street', 'Subiaco', '6008', 'WA', 'AUS', TRUE);

-- Historical address for demonstration
INSERT INTO StudentResidentialAddress (
    Student_Key, E410_ResidentialAddressLine1, E469_ResidentialAddressSuburb,
    E320_ResidentialAddressPostcode, E470_ResidentialAddressState,
    E658_ResidentialAddressCountryCode, IsCurrent, UpdatedAt
) VALUES
(100002, '88 Shanghai Road', 'Beijing', '100001', 'BJ', 'CHN', FALSE, '2023-01-01 00:00:00');

-- ================================================
-- 3. StudentCitizenship - With surrogate keys
-- ================================================

INSERT INTO StudentCitizenship (
    UID10_StudentCitizenshipsResKey, Student_Key, E358_CitizenResidentCode,
    E609_EffectiveFromDate, E610_EffectiveToDate, IsCurrent
) VALUES
('CIT001', 100001, '01', '2024-01-01', NULL, TRUE), -- Australian citizen
('CIT002', 100002, '02', '2024-01-01', NULL, TRUE), -- Permanent resident
('CIT003', 100003, '08', '2024-01-01', NULL, TRUE), -- International student
('CIT004', 100004, '01', '2024-01-01', NULL, TRUE), -- Australian citizen
('CIT005', 100005, '01', '2024-01-01', NULL, TRUE); -- Australian citizen

-- ================================================
-- 4. StudentDisabilities - With surrogate keys
-- ================================================

INSERT INTO StudentDisabilities (
    UID11_StudentDisabilitiesResKey, Student_Key, E615_DisabilityCode,
    E609_EffectiveFromDate, E610_EffectiveToDate, IsCurrent
) VALUES
('DIS001', 100002, '02', '2024-01-01', NULL, TRUE), -- Learning disability
('DIS002', 100004, '03', '2024-01-01', NULL, TRUE), -- Mobility impairment
('DIS003', 100005, '04', '2024-01-01', NULL, TRUE); -- Vision impairment

-- ================================================
-- 5. Courses - Course master data
-- ================================================

INSERT INTO Courses (
    UID5_CoursesResKey, E307_CourseCode, E308_CourseName,
    E596_StandardCourseDuration, E310_CourseOfStudyType, IsCurrent
) VALUES
('CRS001', 'BCOM01', 'Bachelor of Commerce', 3.0, '01', TRUE),
('CRS002', 'BSCI01', 'Bachelor of Science', 3.0, '01', TRUE),
('CRS003', 'MBA001', 'Master of Business Administration', 1.5, '02', TRUE),
('CRS004', 'BART01', 'Bachelor of Arts', 3.0, '01', TRUE),
('CRS005', 'GDIP01', 'Graduate Diploma of Commerce', 1.0, '03', TRUE); -- For exit award

-- ================================================
-- 6. Campuses - Campus locations
-- ================================================

INSERT INTO Campuses (
    UID2_CampusesResKey, E525_CampusSuburb, E644_CampusCountryCode,
    E559_CampusPostcode, E569_CampusOperationType
) VALUES
('CAMP001', 'Crawley', 'AUS', '6009', '01'),
('CAMP002', 'Perth', 'AUS', '6000', '01'),
('CAMP003', 'Albany', 'AUS', '6330', '01'),
('CAMP004', 'Singapore', 'SGP', '238823', '02'),
('CAMP005', 'Online', 'AUS', '0000', '01');

-- ================================================
-- 7. CoursesOnCampuses - Course-campus associations
-- ================================================

INSERT INTO CoursesOnCampuses (
    UID4_CoursesOnCampusResKey, UID2_CampusesResKey, UID5_CoursesResKey,
    E597_CRICOSCode, E609_EffectiveFromDate, E610_EffectiveToDate
) VALUES
('COC001', 'CAMP001', 'CRS001', 'CRICOS001', '2024-01-01', NULL),
('COC002', 'CAMP001', 'CRS002', 'CRICOS002', '2024-01-01', NULL),
('COC003', 'CAMP002', 'CRS003', 'CRICOS003', '2024-01-01', NULL),
('COC004', 'CAMP004', 'CRS001', 'CRICOS001', '2024-01-01', NULL),
('COC005', 'CAMP005', 'CRS004', NULL, '2024-01-01', NULL);

-- ================================================
-- 8. CampusCourseFeesITSP - Course fees
-- ================================================

INSERT INTO CampusCourseFeesITSP (
    UID31_CampusCourseFeesResKey, UID4_CoursesOnCampusResKey,
    E536_CourseFeesCode, E495_IndicativeStudentContributionCSP,
    E496_IndicativeTuitionFeeDomesticFP, E609_EffectiveFromDate
) VALUES
('FEE001', 'COC001', 'CSP1', 8750.00, 15000.00, '2024-01-01'),
('FEE002', 'COC002', 'CSP2', 9500.00, 18000.00, '2024-01-01'),
('FEE003', 'COC003', 'FEE1', NULL, 45000.00, '2024-01-01'),
('FEE004', 'COC004', 'INT1', NULL, 28000.00, '2024-01-01'),
('FEE005', 'COC005', 'CSP1', 7500.00, 12000.00, '2024-01-01');

-- ================================================
-- 9. CampusesTAC - TAC offerings
-- ================================================

INSERT INTO CampusesTAC (
    UID40_CoursesOnCampusTACResKey, UID4_CoursesOnCampusResKey, E557_TACOfferCode
) VALUES
('TAC001', 'COC001', '01'),
('TAC002', 'COC002', '01'),
('TAC003', 'COC003', '02'),
('TAC004', 'COC005', '02');

-- ================================================
-- 10. CourseAdmissions - With surrogate keys
-- ================================================

INSERT INTO CourseAdmissions (
    UID15_CourseAdmissionsResKey, Student_Key, UID5_CoursesResKey,
    E534_CourseOfStudyCommencementDate, E330_AttendanceTypeCode,
    E632_ATAR, E605_SelectionRank, E620_HighestAttainmentCode,
    IsCurrent, Reporting_Year
) VALUES
('ADM001', 100001, 'CRS001', '2024-02-26', '01', 85.50, 87.00, '12', TRUE, 2024),
('ADM002', 100002, 'CRS002', '2024-02-26', '01', 92.00, 93.50, '12', TRUE, 2024),
('ADM003', 100003, 'CRS003', '2024-03-01', '01', NULL, 75.00, '11', TRUE, 2024),
('ADM004', 100004, 'CRS001', '2024-02-26', '01', 78.00, 80.00, '12', TRUE, 2024),
('ADM005', 100005, 'CRS004', '2024-02-26', '02', NULL, 65.00, '08', TRUE, 2024);

-- ================================================
-- 11. UnitEnrolments - With surrogate keys, no direct campus link
-- ================================================

INSERT INTO UnitEnrolments (
    UID16_UnitEnrolmentsResKey, Admission_ID, E354_UnitOfStudyCode,
    E489_UnitOfStudyCensusDate, E464_DisciplineCode, E355_UnitOfStudyStatusCode,
    E329_ModeOfAttendanceCode, E477_DeliveryLocationPostcode, E660_DeliveryLocationCountryCode,
    E490_StudentStatusCode, E600_UnitOfStudyCommencementDate, E601_UnitOfStudyOutcomeDate,
    UE_E339_EFTSL, UE_E384_AmountCharged, UE_E381_AmountPaidUpfront,
    UE_E558_HELPLoanAmount, UE_E529_LoanFee,
    IsCurrent, UE_A111_IsDeleted, Reporting_Year, Load_Batch_ID
) VALUES
('UE001', 1, 'ACCT1001', '2024-03-31', '0801', '10', '01', '6009', 'AUS', '201',
 '2024-02-26', NULL, 0.125, 2187.50, 500.00, 1687.50, 0.00, TRUE, FALSE, 2024, 'BATCH001'),

('UE002', 1, 'ECON1101', '2024-03-31', '1401', '10', '01', '6009', 'AUS', '201',
 '2024-02-26', NULL, 0.125, 2187.50, 0.00, 2187.50, 109.38, TRUE, FALSE, 2024, 'BATCH001'),

('UE003', 2, 'MATH1001', '2024-03-31', '0101', '10', '01', '6009', 'AUS', '201',
 '2024-02-26', NULL, 0.125, 2375.00, 1000.00, 1375.00, 0.00, TRUE, FALSE, 2024, 'BATCH001'),

('UE004', 2, 'CHEM1003', '2024-03-31', '0301', '10', '01', '6009', 'AUS', '201',
 '2024-02-26', NULL, 0.125, 2375.00, 0.00, 2375.00, 118.75, TRUE, FALSE, 2024, 'BATCH001'),

('UE005', 3, 'MBA501', '2024-03-31', '0803', '10', '02', '6000', 'AUS', '201',
 '2024-03-01', NULL, 0.167, 7500.00, 7500.00, 0.00, 0.00, TRUE, FALSE, 2024, 'BATCH001'),

('UE006', 4, 'MGMT2001', '2024-03-31', '0803', '10', '01', '6009', 'AUS', '201',
 '2024-02-26', NULL, 0.125, 2187.50, 0.00, 2187.50, 109.38, TRUE, FALSE, 2024, 'BATCH001'),

('UE007', 5, 'ENGL1001', '2024-03-31', '2001', '10', '04', '0000', 'AUS', '201',
 '2024-02-26', NULL, 0.125, 1875.00, 500.00, 1375.00, 0.00, TRUE, FALSE, 2024, 'BATCH001');

-- ================================================
-- 12. UnitEnrolmentAOUs - With surrogate keys
-- ================================================

INSERT INTO UnitEnrolmentAOUs (
    UID19_UnitEnrolmentAOUsResKey, UnitEnrolment_ID, E333_AOUCode,
    AOU_E339_EFTSL, AOU_E384_AmountCharged, AOU_E381_AmountPaidUpfront,
    AOU_E529_LoanFee, IsCurrent, AOU_IsDeleted
) VALUES
('AOU001', 1, 'ACCT-MAJ', 0.125, 2187.50, 500.00, 0.00, TRUE, FALSE),
('AOU002', 2, 'ECON-MAJ', 0.125, 2187.50, 0.00, 109.38, TRUE, FALSE),
('AOU003', 3, 'MATH-MAJ', 0.125, 2375.00, 1000.00, 0.00, TRUE, FALSE),
('AOU004', 4, 'CHEM-MAJ', 0.125, 2375.00, 0.00, 118.75, TRUE, FALSE),
('AOU005', 5, 'MBA-CORE', 0.167, 7500.00, 7500.00, 0.00, TRUE, FALSE),
('AOU006', 6, 'MGMT-MAJ', 0.083, 1458.33, 0.00, 72.92, TRUE, FALSE),
('AOU007', 6, 'MGMT-MIN', 0.042, 729.17, 0.00, 36.46, TRUE, FALSE),
('AOU008', 7, 'ENGL-MAJ', 0.125, 1875.00, 500.00, 0.00, TRUE, FALSE);

-- ================================================
-- 13. SAHELP - Links directly to Student (per TCSI spec)
-- ================================================

INSERT INTO SAHELP (
    UID21_StudentLoansResKey, Student_Key, E527_HELPDebtIncurralDate,
    E490_StudentStatusCode, E384_AmountCharged, E381_AmountPaidUpfront,
    E558_HELPLoanAmount, A130_LoanStatus, IsCurrent
) VALUES
('SAH001', 100001, '2024-03-31', '201', 500.00, 200.00, 300.00, '01', TRUE),
('SAH002', 100004, '2024-03-31', '201', 600.00, 0.00, 600.00, '01', TRUE);

-- ================================================
-- 14. OSHELP - Overseas study loans
-- ================================================

INSERT INTO OSHELP (
    UID21_StudentLoansResKey, Student_Key,
    E521_OSHELPStudyPeriodCommencementDate, E553_OSHELPStudyPrimaryCountryCode,
    E582_OSHELPLanguageCode, E528_OSHELPPaymentAmount, E529_LoanFee,
    A130_LoanStatus, IsCurrent
) VALUES
('OSH001', 100002, '2024-07-01', 'USA', 'ENG', 7000.00, 350.00, '01', TRUE);

-- ================================================
-- 15. AggregatedAwards - Links to Student AND Course
-- ================================================

INSERT INTO AggregatedAwards (
    UID47_AggregateAwardsResKey, Student_Key, UID5_CoursesResKey,
    E534_CourseOfStudyCommencementDate, E599_CourseOutcomeCode,
    E592_CourseOutcomeDate, E329_ModeOfAttendanceCode, E330_AttendanceTypeCode
) VALUES
-- Example: A student who completed their degree
('AGG001', 100001, 'CRS001', '2021-02-22', '01', '2024-12-15', '01', '01');

-- ================================================
-- 16. ExitAwards - Links to CourseAdmission AND Course
-- ================================================

INSERT INTO ExitAwards (
    UID46_EarlyExitAwardsResKey, Admission_ID, UID5_CoursesResKey,
    E599_CourseOutcomeCode, E592_CourseOutcomeDate
) VALUES
-- Example: Student exited with Graduate Diploma instead of full degree
('EXIT001', 1, 'CRS005', '01', '2024-12-15');

-- ================================================
-- Validation Queries
-- ================================================

-- Check data counts
SELECT 'Data Load Summary' as Report;
SELECT 'HEPStudents' as Table_Name, COUNT(*) as Count FROM HEPStudents
UNION ALL SELECT 'StudentResidentialAddress', COUNT(*) FROM StudentResidentialAddress
UNION ALL SELECT 'StudentCitizenship', COUNT(*) FROM StudentCitizenship
UNION ALL SELECT 'StudentDisabilities', COUNT(*) FROM StudentDisabilities
UNION ALL SELECT 'Courses', COUNT(*) FROM Courses
UNION ALL SELECT 'Campuses', COUNT(*) FROM Campuses
UNION ALL SELECT 'CoursesOnCampuses', COUNT(*) FROM CoursesOnCampuses
UNION ALL SELECT 'CourseAdmissions', COUNT(*) FROM CourseAdmissions
UNION ALL SELECT 'UnitEnrolments', COUNT(*) FROM UnitEnrolments
UNION ALL SELECT 'UnitEnrolmentAOUs', COUNT(*) FROM UnitEnrolmentAOUs
UNION ALL SELECT 'SAHELP', COUNT(*) FROM SAHELP
UNION ALL SELECT 'OSHELP', COUNT(*) FROM OSHELP
UNION ALL SELECT 'AggregatedAwards', COUNT(*) FROM AggregatedAwards
UNION ALL SELECT 'ExitAwards', COUNT(*) FROM ExitAwards;

-- View current student profiles with addresses
SELECT 
    s.E313_StudentIdentificationCode,
    CONCAT(s.E403_StudentGivenNameFirst, ' ', s.E402_StudentFamilyName) as Name,
    a.E469_ResidentialAddressSuburb as Current_Suburb,
    c.E358_CitizenResidentCode as Citizenship,
    COUNT(ue.UnitEnrolment_ID) as Unit_Count
FROM HEPStudents s
LEFT JOIN StudentResidentialAddress a ON s.Student_Key = a.Student_Key AND a.IsCurrent = TRUE
LEFT JOIN StudentCitizenship c ON s.Student_Key = c.Student_Key AND c.IsCurrent = TRUE
LEFT JOIN CourseAdmissions ca ON s.Student_Key = ca.Student_Key AND ca.IsCurrent = TRUE
LEFT JOIN UnitEnrolments ue ON ca.Admission_ID = ue.Admission_ID AND ue.IsCurrent = TRUE
GROUP BY s.Student_Key;

-- Test fee resolution path:
-- UnitEnrolment → CourseAdmission → Course → CoursesOnCampuses → CampusCourseFeesITSP
SELECT 
    ue.E354_UnitOfStudyCode,
    ca.Student_Key,
    c.E307_CourseCode,
    camp.E525_CampusSuburb,
    fees.E495_IndicativeStudentContributionCSP,
    fees.E496_IndicativeTuitionFeeDomesticFP
FROM UnitEnrolments ue
JOIN CourseAdmissions ca ON ue.Admission_ID = ca.Admission_ID
JOIN Courses c ON ca.UID5_CoursesResKey = c.UID5_CoursesResKey
LEFT JOIN CoursesOnCampuses coc ON c.UID5_CoursesResKey = coc.UID5_CoursesResKey
LEFT JOIN Campuses camp ON coc.UID2_CampusesResKey = camp.UID2_CampusesResKey
LEFT JOIN CampusCourseFeesITSP fees ON coc.UID4_CoursesOnCampusResKey = fees.UID4_CoursesOnCampusResKey
WHERE ue.IsCurrent = TRUE;