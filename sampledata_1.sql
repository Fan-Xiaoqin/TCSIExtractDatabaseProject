
-- TCSI Database Sample Data
-- Test data for all tables with realistic Australian higher education records

-- Clear existing data 
-- DELETE FROM UnitEnrolmentAOUs;
-- DELETE FROM UnitEnrolments;
-- DELETE FROM CampusesTAC;
-- DELETE FROM CampusCourseFeesITSP;
-- DELETE FROM HEPCoursesOnCampuses;
-- DELETE FROM StudentContactsFirstReportedAddress;
-- DELETE FROM HEPStudentDisabilities;
-- DELETE FROM HEPStudentCitizenships;
-- DELETE FROM CommonwealthScholarship;
-- DELETE FROM Campuses;
-- DELETE FROM HEPStudents;


-- 1. HEPStudents - Student demographic data


INSERT INTO HEPStudents (
    Student_Key, UID8_StudentsResKey, E313_StudentIdentificationCode, E488_CHESSN, E584_USI,
    A170_USIVerificationStatus, A167_TFNVerificationStatus, E314_DateOfBirth,
    E402_StudentFamilyName, E403_StudentGivenNameFirst, E404_StudentGivenNameOthers,
    E410_ResidentialAddressLine1, E469_ResidentialAddressSuburb, E320_ResidentialAddressPostcode,
    E470_ResidentialAddressState, E658_ResidentialAddressCountryCode,
    E319_TermResidencePostcode, E661_TermResidenceCountryCode,
    E315_GenderCode, E316_ATSICode, E346_CountryOfBirthCode, E347_ArrivalInAustraliaYear,
    E348_LanguageSpokenAtHomeCode, E572_YearLeftSchool, E612_LevelLeftSchool,
    E573_HighestEducationParent1, E574_HighestEducationParent2,
    Start_Date, End_Date, Is_Current
) VALUES
-- Australian citizen students
(100001, 'STU100001', 'S2024001', '987654321A', 'USI123456789', 'Y', 'Y', '2003-03-15',
 'Smith', 'Emily', 'Jane', '45 Stirling Highway', 'Crawley', '6009', 'WA', 'AUS',
 '6009', 'AUS', '02', '04', 'AUS', NULL, '1201', 2020, '12', '08', '06',
 '2024-01-01', NULL, TRUE),
 
(100002, 'STU100002', 'S2024002', '876543210B', 'USI234567890', 'Y', 'Y', '2002-07-22',
 'Chen', 'Wei', 'Michael', '12 Mounts Bay Road', 'Perth', '6000', 'WA', 'AUS',
 '6000', 'AUS', '01', '04', 'CHN', 2015, '2401', 2019, '12', '11', '11',
 '2024-01-01', NULL, TRUE),

-- International student
(100003, 'STU100003', 'S2024003', NULL, 'USI345678901', 'Y', 'N', '2001-11-08',
 'Kumar', 'Priya', NULL, '78 Broadway', 'Nedlands', '6009', 'WA', 'AUS',
 '6009', 'AUS', '02', '04', 'IND', 2023, '4202', 2019, '12', '11', '08',
 '2024-01-01', NULL, TRUE),

-- Indigenous Australian student
(100004, 'STU100004', 'S2024004', '765432109C', 'USI456789012', 'Y', 'Y', '2004-01-25',
 'Williams', 'Jack', 'Thomas', '234 Cambridge Street', 'Wembley', '6014', 'WA', 'AUS',
 '6014', 'AUS', '01', '01', 'AUS', NULL, '1201', 2021, '12', '05', '05',
 '2024-01-01', NULL, TRUE),

-- Mature age student
(100005, 'STU100005', 'S2024005', '654321098D', 'USI567890123', 'Y', 'Y', '1985-09-30',
 'Anderson', 'Sarah', 'Louise', '567 Hay Street', 'Subiaco', '6008', 'WA', 'AUS',
 '6008', 'AUS', '02', '04', 'NZL', 2010, '1201', 2003, '12', '06', '05',
 '2024-01-01', NULL, TRUE);


-- 2. HEPStudentCitizenships - Citizenship status


INSERT INTO HEPStudentCitizenships (
    UID10_StudentCitizenshipsResKey, UID8_StudentsResKey, Student_Key,
    E313_StudentIdentificationCode, E488_CHESSN, E358_CitizenResidentCode,
    E609_EffectiveFromDate, E610_EffectiveToDate
) VALUES
('CIT001', 'STU100001', 100001, 'S2024001', '987654321A', '01', '2024-01-01', NULL), -- Australian citizen
('CIT002', 'STU100002', 100002, 'S2024002', '876543210B', '02', '2024-01-01', NULL), -- Permanent resident
('CIT003', 'STU100003', 100003, 'S2024003', NULL, '08', '2024-01-01', NULL), -- International student
('CIT004', 'STU100004', 100004, 'S2024004', '765432109C', '01', '2024-01-01', NULL), -- Australian citizen
('CIT005', 'STU100005', 100005, 'S2024005', '654321098D', '01', '2024-01-01', NULL); -- Australian citizen


-- 3. HEPStudentDisabilities - Student disability records


INSERT INTO HEPStudentDisabilities (
    UID11_StudentDisabilitiesResKey, UID8_StudentsResKey, Student_Key,
    E313_StudentIdentificationCode, E488_CHESSN, E615_DisabilityCode,
    E609_EffectiveFromDate, E610_EffectiveToDate
) VALUES
-- Student with learning disability
('DIS001', 'STU100002', 100002, 'S2024002', '876543210B', '02', '2024-01-01', NULL),
-- Student with mobility impairment
('DIS002', 'STU100004', 100004, 'S2024004', '765432109C', '03', '2024-01-01', NULL),
-- Student with vision impairment
('DIS003', 'STU100005', 100005, 'S2024005', '654321098D', '04', '2024-01-01', NULL);


-- 4. StudentContactsFirstReportedAddress - First reported addresses


INSERT INTO StudentContactsFirstReportedAddress (
    Student_Key, E313_StudentIdentificationCode,
    E787_FirstResidentialAddressLine1, E789_FirstResidentialAddressSuburb,
    E791_FirstResidentialAddressState, E659_FirstResidentialAddressCountryCode,
    E790_FirstResidentialAddressPostcode
) VALUES
(100001, 'S2024001', '45 Stirling Highway', 'Crawley', 'WA', 'AUS', '6009'),
(100002, 'S2024002', '88 Shanghai Road', 'Beijing', 'BJ', 'CHN', '100001'),
(100003, 'S2024003', '456 MG Road', 'Mumbai', 'MH', 'IND', '400001'),
(100004, 'S2024004', '234 Cambridge Street', 'Wembley', 'WA', 'AUS', '6014'),
(100005, 'S2024005', '123 Queen Street', 'Auckland', 'AKL', 'NZL', '1010');


-- 5. CommonwealthScholarship - Scholarship records


INSERT INTO CommonwealthScholarship (
    UID12_StudentCommonwealthScholarshipsResKey, Student_Key, E415_ReportingYear,
    E666_ReportingPeriod, E545_CommonwealthScholarshipType, E526_CommonwealthScholarshipStatusCode,
    E598_CommonwealthScholarshipAmount, E538_CommonwealthScholarshipTerminationReasonCode
) VALUES
-- Indigenous Commonwealth Scholarship
('CWS001', 100004, 2024, '01', '01', '01', 5000.00, NULL),
-- Commonwealth Accommodation Scholarship
('CWS002', 100001, 2024, '01', '02', '01', 3000.00, NULL),
-- Commonwealth Education Costs Scholarship
('CWS003', 100002, 2024, '01', '03', '01', 2000.00, NULL);


-- 6. Campuses - Campus locations


INSERT INTO Campuses (
    UID2_CampusesResKey, E525_CampusSuburb, E644_CampusCountryCode,
    E559_CampusPostcode, E569_CampusOperationType
) VALUES
('CAMP001', 'Crawley', 'AUS', '6009', '01'), -- Main campus
('CAMP002', 'Perth', 'AUS', '6000', '01'), -- City campus
('CAMP003', 'Albany', 'AUS', '6330', '01'), -- Regional campus
('CAMP004', 'Singapore', 'SGP', '238823', '02'), -- Offshore campus
('CAMP005', 'Online', 'AUS', '0000', '01'); -- Online delivery


-- 7. HEPCoursesOnCampuses - Courses offered at campuses


-- Note: These reference HEPCourses table which should already exist
-- Using sample course codes that would typically exist
INSERT INTO HEPCoursesOnCampuses (
    UID4_CoursesOnCampusResKey, UID2_CampusesResKey, E525_CampusSuburb,
    E644_CampusCountryCode, E559_CampusPostcode, Campuses_E609_EffectiveFromDate,
    Campuses_E610_EffectiveToDate, UID5_CoursesResKey, E307_CourseCode,
    E597_CRICOSCode, E569_CampusOperationType, E570_PrincipalOffshoreDeliveryMode,
    E571_OffshoreDeliveryCode, E609_EffectiveFromDate, E610_EffectiveToDate
) VALUES
-- Bachelor of Commerce at Crawley
('COC001', 'CAMP001', 'Crawley', 'AUS', '6009', '2024-01-01', NULL,
 'CRS001', 'BCOM01', 'CRICOS001', '01', NULL, NULL, '2024-01-01', NULL),
 
-- Bachelor of Science at Crawley
('COC002', 'CAMP001', 'Crawley', 'AUS', '6009', '2024-01-01', NULL,
 'CRS002', 'BSCI01', 'CRICOS002', '01', NULL, NULL, '2024-01-01', NULL),
 
-- Master of Business Administration at Perth City
('COC003', 'CAMP002', 'Perth', 'AUS', '6000', '2024-01-01', NULL,
 'CRS003', 'MBA001', 'CRICOS003', '01', NULL, NULL, '2024-01-01', NULL),
 
-- Bachelor of Commerce at Singapore (offshore)
('COC004', 'CAMP004', 'Singapore', 'SGP', '238823', '2024-01-01', NULL,
 'CRS001', 'BCOM01', 'CRICOS001', '02', '01', '01', '2024-01-01', NULL),
 
-- Bachelor of Arts (Online)
('COC005', 'CAMP005', 'Online', 'AUS', '0000', '2024-01-01', NULL,
 'CRS004', 'BART01', NULL, '01', NULL, NULL, '2024-01-01', NULL);

-- ================================================
-- 8. CampusCourseFeesITSP - Course fees by campus
-- ================================================

INSERT INTO CampusCourseFeesITSP (
    UID31_CampusCourseFeesResKey, UID4_CoursesOnCampusResKey, E525_CampusSuburb,
    E644_CampusCountryCode, E559_CampusPostcode, Campuses_E609_EffectiveFromDate,
    UID5_CoursesResKey, E307_CourseCode, E536_CourseFeesCode,
    E495_IndicativeStudentContributionCSP, E496_IndicativeTuitionFeeDomesticFP,
    E609_EffectiveFromDate
) VALUES
-- Bachelor of Commerce fees at Crawley
('FEE001', 'COC001', 'Crawley', 'AUS', '6009', '2024-01-01',
 'CRS001', 'BCOM01', 'CSP1', 8750.00, 15000.00, '2024-01-01'),
 
-- Bachelor of Science fees at Crawley
('FEE002', 'COC002', 'Crawley', 'AUS', '6009', '2024-01-01',
 'CRS002', 'BSCI01', 'CSP2', 9500.00, 18000.00, '2024-01-01'),
 
-- MBA fees at Perth City (postgrad, full fee)
('FEE003', 'COC003', 'Perth', 'AUS', '6000', '2024-01-01',
 'CRS003', 'MBA001', 'FEE1', NULL, 45000.00, '2024-01-01'),
 
-- Bachelor of Commerce fees at Singapore
('FEE004', 'COC004', 'Singapore', 'SGP', '238823', '2024-01-01',
 'CRS001', 'BCOM01', 'INT1', NULL, 28000.00, '2024-01-01'),
 
-- Bachelor of Arts fees (Online)
('FEE005', 'COC005', 'Online', 'AUS', '0000', '2024-01-01',
 'CRS004', 'BART01', 'CSP1', 7500.00, 12000.00, '2024-01-01');

-- ================================================
-- 9. CampusesTAC - TAC offerings
-- ================================================

INSERT INTO CampusesTAC (
    UID40_CoursesOnCampusTACResKey, UID4_CoursesOnCampusResKey, E557_TACOfferCode
) VALUES
('TAC001', 'COC001', '01'), -- BCOM through TAC
('TAC002', 'COC002', '01'), -- BSCI through TAC
('TAC003', 'COC003', '02'), -- MBA direct entry only
('TAC004', 'COC005', '02'); -- BA Online direct entry

-- ================================================
-- 10. UnitEnrolments - Student unit enrolments
-- ================================================

-- Note: These reference HEPCourseAdmissions which should exist
-- Using sample admission keys
INSERT INTO UnitEnrolments (
    UID16_UnitEnrolmentsResKey, UID15_CourseAdmissionsResKey, UID4_CoursesOnCampusResKey,
    E354_UnitOfStudyCode, E489_UnitOfStudyCensusDate, E337_WorkExperienceInIndustryCode,
    E551_SummerWinterSchoolCode, E464_DisciplineCode, E355_UnitOfStudyStatusCode,
    E329_ModeOfAttendanceCode, E477_DeliveryLocationPostcode, E660_DeliveryLocationCountryCode,
    E490_StudentStatusCode, E392_MaximumStudentContributionCode, 
    E600_UnitOfStudyCommencementDate, E601_UnitOfStudyOutcomeDate,
    UE_A111_IsDeleted, AsAtMonth, Load_Batch_ID, Reporting_Year
) VALUES
-- Emily Smith - Commerce units
('UE001', 'ADM001', 'COC001', 'ACCT1001', '2024-03-31', NULL, NULL, '0801', '10', '01', 
 '6009', 'AUS', '201', '01', '2024-02-26', NULL, FALSE, '2024-03-01', 'BATCH001', 2024),
 
('UE002', 'ADM001', 'COC001', 'ECON1101', '2024-03-31', NULL, NULL, '1401', '10', '01',
 '6009', 'AUS', '201', '01', '2024-02-26', NULL, FALSE, '2024-03-01', 'BATCH001', 2024),

-- Wei Chen - Science units  
('UE003', 'ADM002', 'COC002', 'MATH1001', '2024-03-31', NULL, NULL, '0101', '10', '01',
 '6009', 'AUS', '201', '01', '2024-02-26', NULL, FALSE, '2024-03-01', 'BATCH001', 2024),
 
('UE004', 'ADM002', 'COC002', 'CHEM1003', '2024-03-31', NULL, NULL, '0301', '10', '01',
 '6009', 'AUS', '201', '01', '2024-02-26', NULL, FALSE, '2024-03-01', 'BATCH001', 2024),

-- Priya Kumar - MBA units (intensive mode)
('UE005', 'ADM003', 'COC003', 'MBA501', '2024-03-31', NULL, NULL, '0803', '10', '02',
 '6000', 'AUS', '201', NULL, '2024-03-01', NULL, FALSE, '2024-03-01', 'BATCH001', 2024),

-- Jack Williams - Commerce with work placement
('UE006', 'ADM004', 'COC001', 'MGMT2001', '2024-03-31', '01', NULL, '0803', '10', '01',
 '6009', 'AUS', '201', '01', '2024-02-26', NULL, FALSE, '2024-03-01', 'BATCH001', 2024),

-- Sarah Anderson - Online Arts
('UE007', 'ADM005', 'COC005', 'ENGL1001', '2024-03-31', NULL, NULL, '2001', '10', '04',
 '0000', 'AUS', '201', '01', '2024-02-26', NULL, FALSE, '2024-03-01', 'BATCH001', 2024),

-- Summer school unit
('UE008', 'ADM001', 'COC001', 'STAT1400', '2024-01-15', NULL, '01', '0101', '10', '01',
 '6009', 'AUS', '201', '01', '2024-01-02', '2024-02-15', FALSE, '2024-01-01', 'BATCH001', 2024);

-- ================================================
-- 11. UnitEnrolmentAOUs - Areas of Study
-- ================================================

INSERT INTO UnitEnrolmentAOUs (
    UID19_UnitEnrolmentAOUsResKey, UID16_UnitEnrolmentsResKey, E333_AOUCode,
    AOU_E339_EFTSL, AOU_E384_AmountCharged, AOU_E381_AmountPaidUpfront,
    AOU_E529_LoanFee, AOU_IsDeleted, AsAtMonth, Load_Batch_ID, Reporting_Year
) VALUES
-- Accounting AOU for ACCT1001
('AOU001', 'UE001', 'ACCT-MAJ', 0.125, 2187.50, 500.00, 0.00, FALSE, '2024-03-01', 'BATCH001', 2024),

-- Economics AOU for ECON1101  
('AOU002', 'UE002', 'ECON-MAJ', 0.125, 2187.50, 0.00, 109.38, FALSE, '2024-03-01', 'BATCH001', 2024),

-- Mathematics AOU for MATH1001
('AOU003', 'UE003', 'MATH-MAJ', 0.125, 2375.00, 1000.00, 0.00, FALSE, '2024-03-01', 'BATCH001', 2024),

-- Chemistry AOU for CHEM1003
('AOU004', 'UE004', 'CHEM-MAJ', 0.125, 2375.00, 0.00, 118.75, FALSE, '2024-03-01', 'BATCH001', 2024),

-- MBA Core AOU
('AOU005', 'UE005', 'MBA-CORE', 0.167, 7500.00, 7500.00, 0.00, FALSE, '2024-03-01', 'BATCH001', 2024),

-- Management AOU with split between major and minor
('AOU006', 'UE006', 'MGMT-MAJ', 0.083, 1458.33, 0.00, 72.92, FALSE, '2024-03-01', 'BATCH001', 2024),
('AOU007', 'UE006', 'MGMT-MIN', 0.042, 729.17, 0.00, 36.46, FALSE, '2024-03-01', 'BATCH001', 2024),

-- English Literature AOU
('AOU008', 'UE007', 'ENGL-MAJ', 0.125, 1875.00, 500.00, 0.00, FALSE, '2024-03-01', 'BATCH001', 2024),

-- Statistics AOU (Summer)
('AOU009', 'UE008', 'STAT-MIN', 0.125, 2187.50, 2187.50, 0.00, FALSE, '2024-01-01', 'BATCH001', 2024);


-- Summary Statistics


SELECT 'Data Load Summary' as Report;

SELECT 'HEPStudents' as Table_Name, COUNT(*) as Record_Count FROM HEPStudents
UNION ALL
SELECT 'HEPStudentCitizenships', COUNT(*) FROM HEPStudentCitizenships
UNION ALL
SELECT 'HEPStudentDisabilities', COUNT(*) FROM HEPStudentDisabilities
UNION ALL
SELECT 'StudentContactsFirstReportedAddress', COUNT(*) FROM StudentContactsFirstReportedAddress
UNION ALL
SELECT 'CommonwealthScholarship', COUNT(*) FROM CommonwealthScholarship
UNION ALL
SELECT 'Campuses', COUNT(*) FROM Campuses
UNION ALL
SELECT 'HEPCoursesOnCampuses', COUNT(*) FROM HEPCoursesOnCampuses
UNION ALL
SELECT 'CampusCourseFeesITSP', COUNT(*) FROM CampusCourseFeesITSP
UNION ALL
SELECT 'CampusesTAC', COUNT(*) FROM CampusesTAC
UNION ALL
SELECT 'UnitEnrolments', COUNT(*) FROM UnitEnrolments
UNION ALL
SELECT 'UnitEnrolmentAOUs', COUNT(*) FROM UnitEnrolmentAOUs;