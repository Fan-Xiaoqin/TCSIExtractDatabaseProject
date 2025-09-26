-- RTPScholarships
INSERT INTO `RTPScholarships` (`UID15_CourseAdmissionsResKey`, `UID35_RTPScholarshipsResKey`, `E487_RTPScholarshipType`, `E609_RTPScholarshipFromDate`, `E610_RTPScholarshipToDate`) VALUES
('ADM002', 'RTP001', 9, '2024-02-26', '2028-02-25');

-- RTPStipend
INSERT INTO `RTPStipend` (`UID15_CourseAdmissionsResKey`, `UID18_RTPStipendsResKey`, `E623_RTPStipendAmount`, `E415_ReportingYear`) VALUES
('ADM001', 'STIP001', 28000, 2024);

-- SpecialInterestCourses
INSERT INTO `SpecialInterestCourses` (`UID5_CoursesResKey`, `UID30_SpecialInterestCoursesResKey`, `E312_SpecialCourseType`, `E609_EffectiveFromDate`, `E610_EffectiveToDate`) VALUES
('CRS001', 'SPC001', 22, '2005-01-01', '2007-12-31'),
('CRS002', 'SPC002', 22, '2009-01-01', NULL),
('CRS003', 'SPC003', 22, '2005-01-01', '2006-12-31'),
('CRS004', 'SPC004', 22, '2009-01-01', '2009-12-31');

-- SAHELP
INSERT INTO `SAHELP` (`UID21_StudentLoansResKey`, `UID15_CourseAdmissionsResKey`, `E527_HELPDebtIncurralDate`, `E490_StudentStatusCode`, `E384_AmountCharged`, `E381_AmountPaidUpfront`, `E558_HELPLoanAmount`, `A130_LoanStatus`, `Invalidated_Flag`) VALUES
('SL001', 'ADM001', '2019-06-01', 280, 151.5, 0, 151.5, 'COMMITTED', 'N'),
('SL002', 'ADM002', '2018-11-01', 280, 149, 0, 149, 'COMMITTED', 'N'),
('SL003', 'ADM003', '2019-06-01', 280, 151.5, 0, 151.5, 'COMMITTED', 'N'),
('SL004', 'ADM004', '2018-06-01', 280, 149, 0, 149, 'COMMITTED', 'N');

-- OSHELP
INSERT INTO `OSHELP` (`UID21_StudentLoansResKey`, `UID15_CourseAdmissionsResKey`, `E527_HELPDebtIncurralDate`, `E490_StudentStatusCode`, `E521_OSHELPStudyPeriodCommencementDate`, `E553_OSHELPStudyPrimaryCountryCode`, `E554_OSHELPStudySecondaryCountryCode`, `E583_OSHELPLanguageStudyCommencementDate`, `E582_OSHELPLanguageCode`, `E528_OSHELPPaymentAmount`, `E529_LoanFee`, `A130_LoanStatus`, `Invalidated_Flag`) VALUES
('L001', 'ADM002', '2024-02-15', 'ACTIVE', '2024-03-01', 'AU', 'CA', '2024-03-05', 'ENG', 4000, 120, 'APPROVED', 'N');

-- HEPHDREndUsersEngagement
INSERT INTO `HEPHDREndUsersEngagement` (`UID15_CourseAdmissionsResKey`, `UID37_HDREndUserEngagementsResKey`, `E593_HDREndUserEngagementCode`, `E609_HDREndUserEngageFromDate`, `E610_HDREndUserEngageToDate`, `E798_HDRDaysOfEngagement`) VALUES
('CA001', 'ENG001', 'ENGAGED', '2024-03-01', '2024-09-01', 180);

-- HEPCourses
INSERT INTO `HEPCourses` (`UID3_CoursesOfStudyResKey`, `UID5_CoursesResKey`, `E307_CourseCode`, `E308_CourseName`, `E596_StandardCourseDuration`, `E609_EffectiveFromDate`, `E610_EffectiveToDate`) VALUES
('CSR001', 'CRS001', 201, 'Aboriginal Orientation Course', NULL, '2005-01-01', NULL),
('CSR002', 'CRS002', 302, 'Aboriginal Pre-Law Programme', 0.3, '2005-01-01', NULL),
('CSR003', 'CRS003', 301, 'Aboriginal Pre-Law Programme', NULL, '2005-01-01', NULL),
('CSR004', 'CRS004', 401, 'Aboriginal Pre-Medicine Programme', NULL, '2005-01-01', NULL);

-- HEPCoursePriorCredits
INSERT INTO `HEPCoursePriorCredits` (`UID15_CourseAdmissionsResKey`, `UID32_CoursePriorCreditsResKey`, `E560_CreditUsedValue`, `E561_CreditBasis`, `E566_CreditProviderCode`) VALUES
('ADM001', 'CRD001', 0.25, 100, 3001),
('ADM002', 'CRD002', 0.5, NULL, NULL),
('ADM003', 'CRD003', 2.499, NULL, NULL),
('ADM004', 'CRD004', 2, NULL, NULL);

-- HEPCourseAdmissions
INSERT INTO `HEPCourseAdmissions` (`UID8_StudentsResKey`, `UID5_CoursesResKey`, `UID15_CourseAdmissionsResKey`, `E534_CourseOfStudyCommencementDate`, `E330_AttendanceTypeCode`, `E591_HDRThesisSubmissionDate`, `E632_ATAR`, `E605_SelectionRank`, `E620_HighestAttainmentCode`, `E594_HDRPrimaryFieldOfResearchCode`, `E595_HDRSecondaryFieldOfResearchCode`, `AsAtMonth`, `ExtractedAt`, `Load_Batch_ID`) VALUES
('STU100001', 'CRS001', 'ADM001', '2019-03-01', NULL, '2023-11-15', NULL, NULL, NULL, 1001, NULL, 202401, '2025-03-10', 1001),
('STU100002', 'CRS002', 'ADM002', '2011-02-28', 1, NULL, 0, 0, 420, NULL, 1100, 202409, '2025-03-10', 1002),
('STU100003', 'CRS003', 'ADM003', '2009-02-01', NULL, NULL, NULL, NULL, NULL, 1002, NULL, 202403, '2025-03-11', 1003),
('STU100004', 'CRS004', 'ADM004', '2009-02-23', 1, NULL, 0, 0, 300, NULL, 1200, 202412, '2025-03-12', 1004);

-- HEPBasisForAdmission
INSERT INTO `HEPBasisForAdmission` (`UID15_CourseAdmissionsResKey`, `UID17_BasisForAdmissionResKey`, `E327_BasisForAdmissionCode`) VALUES
('ADM001', 'BAS001', 29),
('ADM002', 'BAS002', 29),
('ADM003', 'BAS003', 29),
('ADM004', 'BAS004', 29);

-- ExitAwards
INSERT INTO `ExitAwards` (`UID46_EarlyExitAwardsResKey`, `UID15_CourseAdmissionsResKey`, `E599_CourseOutcomeCode`, `E592_CourseOutcomeDate`) VALUES
('EXIT001', 'ADM001', 1, '2022-02-10'),
('EXIT002', 'ADM002', 1, '2023-06-15'),
('EXIT003', 'ADM003', 1, '2025-03-25'),
('EXIT004', 'ADM004', 1, '2024-11-30');

-- CourseSpecialisations
INSERT INTO `CourseSpecialisations` (`UID15_CourseAdmissionsResKey`, `UID33_CourseSpecialisationsResKey`, `E463_SpecialisationCode`) VALUES
('ADM001', 'CSP001', 90900),
('ADM002', 'CSP002', 90701),
('ADM003', 'CSP003', 91500),
('ADM004', 'CSP004', 90900);

-- CoursesOfStudy
INSERT INTO `CoursesOfStudy` (`UID3_CoursesOfStudyResKey`, `E533_CourseOfStudyCode`, `E394_CourseOfStudyName`, `E310_CourseOfStudyType`, `E350_CourseOfStudyLoad`, `E455_CombinedCourseOfStudyIndicator`) VALUES
('CSR001', 20, 'Aboriginal Orientation Course', 30, 1, 0),
('CSR002', 30, 'Aboriginal Pre-Law Programme', 30, 0.3, 0),
('CSR003', 40, 'Aboriginal Pre-Medicine Programme', 30, 0.3, 0),
('CSR004', 50, 'Cross Institutional (Albany)', 41, NULL, 0);

-- CourseFieldsOfEducation
INSERT INTO `CourseFieldsOfEducation` (`UID5_CoursesResKey`, `UID48_CourseFieldsOfEducationResKey`, `E461_FieldOfEducationCode`, `E462_FieldOfEducationSupplementaryCode`, `E609_EffectiveFromDate`, `E610_EffectiveToDate`) VALUES
('CRS001', 'FOE001', 91901, 0, '2005-01-01', '2006-12-31'),
('CRS002', 'FOE002', 91901, 0, '2007-01-01', NULL),
('CRS003', 'FOE003', 61799, 0, '2005-01-01', '2006-12-31'),
('CRS004', 'FOE004', 61799, 0, '2007-01-01', NULL);

-- AggregatedAwards
INSERT INTO `AggregatedAwards` (`UID47_AggregateAwardsResKey`, `UID15_CourseAdmissionsResKey`, `E599_CourseOutcomeCode`, `E591_HDRThesisSubmissionDate`, `E592_CourseOutcomeDate`, `E329_ModeOfAttendanceCode`, `E330_AttendanceTypeCode`) VALUES
(1001, 'ADM001', 'COMPLETED', '2024-11-01', '2024-11-30', 'ON', 'FULLTIME'),
(1002, 'ADM002', 'WITHDRAWN', '2024-11-01', '2024-07-15', 'OFF', 'PARTTIME');
