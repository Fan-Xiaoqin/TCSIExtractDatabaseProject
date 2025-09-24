INSERT INTO RTPScholarships ("UID15_CourseAdmissionsResKey", "UID35_RTPScholarshipsResKey", "E487_RTPScholarshipType", "E609_RTPScholarshipFromDate", "E610_RTPScholarshipToDate") VALUES
('c6a33a78afb3c4c6d1c7995e30ee32fc1a41eb7223c7876576c1464dff5d3bc0', NULL, 9, '2024-02-26 00:00:00', '2028-02-25 00:00:00');

INSERT INTO RTPStipend ("UID15_CourseAdmissionsResKey", "UID18_RTPStipendsResKey", "E623_RTPStipendAmount", "E415_ReportingYear") VALUES
('c6a33a78afb3c4c6d1c7995e30ee32fc1a41eb7223c7876576c1464dff5d3bc0', NULL, NULL, NULL),
('1352130a9bf0fc648ea4d52b769db6e5d9a5ac51c39e8a35881feab327903e9e', NULL, NULL, NULL),
('a236dc5baa1c9ef75d0a640d96963ee11bbf1ee0a22444dd326f9744d30ea788', NULL, NULL, NULL),
('de18642ab7b58283158c7fde12d0c9f33ed6cff49c61a2c6c2bcef38f6418f79', NULL, NULL, NULL);

INSERT INTO SpecialInterestCourses ("UID5_CoursesResKey", "UID30_SpecialInterestCoursesResKey", "E312_SpecialCourseType", "E609_EffectiveFromDate", "E610_EffectiveToDate") VALUES
(10070, 7841, 22, '2005-01-01 00:00:00', '2007-12-31 00:00:00'),
(10070, 7835, 22, '2009-01-01 00:00:00', NULL),
(10267, 3831, 22, '2005-01-01 00:00:00', '2006-12-31 00:00:00'),
(10267, 954, 22, '2009-01-01 00:00:00', '2009-12-31 00:00:00');

INSERT INTO SAHELP ("UID21_StudentLoansResKey", "UID15_CourseAdmissionsResKey", "E527_HELPDebtIncurralDate", "E490_StudentStatusCode", "E384_AmountCharged", "E381_AmountPaidUpfront", "E558_HELPLoanAmount", "A130_LoanStatus", "Invalidated_Flag") VALUES
('410e500e563ca4909deb547b1e582589bbb4002e37a942f52a95ad009012f82b', 'c6a33a78afb3c4c6d1c7995e30ee32fc1a41eb7223c7876576c1464dff5d3bc0', '2019-06-01 00:00:00', 280, 151.5, 0, 151.5, 'COMMITTED', 'N'),
('abcad50b662dde3421586acbec650638f9d37fd320c741f9ef966deffab88cbd', '1352130a9bf0fc648ea4d52b769db6e5d9a5ac51c39e8a35881feab327903e9e', '2018-11-01 00:00:00', 280, 149, 0, 149, 'COMMITTED', 'N'),
('63d839cca661b050944a3bf8c957a4d2d01dc056474a84d05cd7bce9091bf872', 'a236dc5baa1c9ef75d0a640d96963ee11bbf1ee0a22444dd326f9744d30ea788', '2019-06-01 00:00:00', 280, 151.5, 0, 151.5, 'COMMITTED', 'N'),
('75e0280303f9379a28139ac0d34b027ffe17d959441186c4014fd1e0d10caf8e', 'de18642ab7b58283158c7fde12d0c9f33ed6cff49c61a2c6c2bcef38f6418f79', '2018-06-01 00:00:00', 280, 149, 0, 149, 'COMMITTED', 'N');

INSERT INTO OSHELP ("UID21_StudentLoansResKey", "UID15_CourseAdmissionsResKey", "E527_HELPDebtIncurralDate", "E490_StudentStatusCode", "E521_OSHELPStudyPeriodCommencementDate", "E553_OSHELPStudyPrimaryCountryCode", "E554_OSHELPStudySecondaryCountryCode", "E583_OSHELPLanguageStudyCommencementDate", "E582_OSHELPLanguageCode", "E528_OSHELPPaymentAmount", "E529_LoanFee", "A130_LoanStatus", "Invalidated_Flag") VALUES
('L001', 'c6a33a78af…ff5d3bc0', '2024-02-15 00:00:00', 'ACTIVE', '2024-03-01 00:00:00', 'AU', 'CA', '2024-03-05 00:00:00', 'ENG', 4000, 120, 'APPROVED', 'N');

INSERT INTO HEPHDREndUsersEngagement ("UID15_CourseAdmissionsResKey", "UID37_HDREndUserEngagementsResKey", "E593_HDREndUserEngagementCode", "E609_HDREndUserEngageFromDate", "E610_HDREndUserEngageToDate", "E798_HDRDaysOfEngagement") VALUES
('c6a33a78afb3c4c6d1c7995e30ee32fc1a41eb7223c7876576c1464dff5d3bc0', 'ENG001', 'ENGAGED', '2024-03-01 00:00:00', '2024-09-01 00:00:00', 180);

INSERT INTO HEPCourses ("UID3_CoursesOfStudyResKey", "UID5_CoursesResKey", "E307_CourseCode", "E308_CourseName", "E596_StandardCourseDuration", "E609_EffectiveFromDate", "E610_EffectiveToDate") VALUES
(1462, 8849, 201, 'Aboriginal Orientation Course', NULL, '2005-01-01 00:00:00', NULL),
(1463, 8949, 302, 'Aboriginal Pre-Law Programme', 0.3, '2005-01-01 00:00:00', NULL),
(1463, 8973, 301, 'Aboriginal Pre-Law Programme', NULL, '2005-01-01 00:00:00', NULL),
(1464, 8923, 401, 'Aboriginal Pre-Medicine Programme', NULL, '2005-01-01 00:00:00', NULL);

INSERT INTO HEPCoursePriorCredits ("UID15_CourseAdmissionsResKey", "UID32_CoursePriorCreditsResKey", "E560_CreditUsedValue", "E561_CreditBasis", "E566_CreditProviderCode") VALUES
('d76a8e187e39247bbbd72b891ccac0ab6dd99b73c8646ea3d9cb3a3837dfcef0', 2839074, 0.25, 100, 3001),
('b20e18623cc1e401ab90922f5dd101cabbf89976062f438e6af5ec5b6a2f8b41', 951277, 0.5, NULL, NULL),
('5c86a1d5895879805218301170d71872897592999d81b894ef79327b5b7170e1', 1834951, 2.499, NULL, NULL),
('a10c042ad5eb7da7fd6326a2f32e897d9358de42f8b21f853999a690b914533f', 1845360, 2, NULL, NULL);

INSERT INTO HEPCourseAdmissions ("UID8_StudentsResKey", "UID5_CoursesResKey", "UID15_CourseAdmissionsResKey", "E534_CourseOfStudyCommencementDate", "E330_AttendanceTypeCode", "E591_HDRThesisSubmissionDate", "E632_ATAR", "E605_SelectionRank", "E620_HighestAttainmentCode", "E594_HDRPrimaryFieldOfResearchCode", "E595_HDRSecondaryFieldOfResearchCode", "AsAtMonth", "ExtractedAt", "Load_Batch_ID") VALUES
('63c6bdb49d8a7e91e2d02db148b9ea4c80492d49930a6eda4bdd3ca70944b4cf', 8725, 'c6a33a78afb3c4c6d1c7995e30ee32fc1a41eb7223c7876576c1464dff5d3bc0', '2011-02-01 00:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 202401, '2025-03-10 10:15:30', 1001),
('63c6bdb49d8a7e91e2d02db148b9ea4c80492d49930a6eda4bdd3ca70944b4cf', 8725, '1352130a9bf0fc648ea4d52b769db6e5d9a5ac51c39e8a35881feab327903e9e', '2011-02-28 00:00:00', 1, NULL, 0, 0, 420, NULL, NULL, 202409, '2025-03-10 14:45:00', 1002),
('4bdd6657e8a65a5526b1cae8b334470859ce9982cbddb3b86f69bae10c0797f9', 8725, 'a236dc5baa1c9ef75d0a640d96963ee11bbf1ee0a22444dd326f9744d30ea788', '2009-02-01 00:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 202403, '2025-03-11 08:05:12', 1003),
('4bdd6657e8a65a5526b1cae8b334470859ce9982cbddb3b86f69bae10c0797f9', 8725, 'de18642ab7b58283158c7fde12d0c9f33ed6cff49c61a2c6c2bcef38f6418f79', '2009-02-23 00:00:00', 1, NULL, 0, 0, 300, NULL, NULL, 202412, '2025-03-12 23:59:59', 1004);

INSERT INTO HEPBasisForAdmission ("UID15_CourseAdmissionsResKey", "UID17_BasisForAdmissionResKey", "E327_BasisForAdmissionCode") VALUES
('e9e34cf9e6be04b58eb9c48e83cfc79b5153831f709b123fe08db3c361f15847', 238225, 29),
('9d98125deaf9879483495282db6fb1c13511d307137559e0858a99f78b124d84', 8081801, 29),
('fbe1885ce76930adbe74f61f9e05925cc3b4d687113bd7e00cb68db3c7da6e4e', 7532867, 29),
('b1f575332da47cb6061fc0cb997da217dc1b79347aaabea6976c79d35cdc1e4d', 7546262, 29);

INSERT INTO ExitAwards ("UID46_EarlyExitAwardsResKey", "UID15_CourseAdmissionsResKey", "E599_CourseOutcomeCode", "E592_CourseOutcomeDate") VALUES
(5780, '7d7f274c624b1e9d451b4e33ea6077b72df610749e544f03031dea27af2ca978', 1, '2022-02-10 00:00:00');

INSERT INTO CourseSpecialisations ("UID15_CourseAdmissionsResKey", "UID33_CourseSpecialisationsResKey", "E463_SpecialisationCode") VALUES
('0451da5f7c51e403d6d52d75350eaf6adda1c11807fad8bbe009a6b7113857ee', 1076927, 90900),
('81409a9914e1c8b8661a2125f12f1e5cd1c7b5580379fc9f0f3aac7c2896d907', 3458114, 90701),
('81409a9914e1c8b8661a2125f12f1e5cd1c7b5580379fc9f0f3aac7c2896d907', 3458115, 91500),
('46f6e455781db7b75661689f3f13d4cf275dc45dca274f835c2da0f93c84c768', 1080279, 90900);

INSERT INTO CoursesOfStudy ("UID3_CoursesOfStudyResKey", "E533_CourseOfStudyCode", "E394_CourseOfStudyName", "E310_CourseOfStudyType", "E350_CourseOfStudyLoad", "E455_CombinedCourseOfStudyIndicator") VALUES
(1462, 20, 'Aboriginal Orientation Course', 30, 1, 0),
(1463, 30, 'Aboriginal Pre-Law Programme', 30, 0.3, 0),
(1464, 40, 'Aboriginal Pre-Medicine Programme', 30, 0.3, 0),
(1465, 50, 'Cross Institutional (Albany)', 41, NULL, 0);

INSERT INTO CourseFieldsOfEducation ("UID5_CoursesResKey", "UID48_CourseFieldsOfEducationResKey", "E461_FieldOfEducationCode", "E462_FieldOfEducationSupplementaryCode", "E609_EffectiveFromDate", "E610_EffectiveToDate") VALUES
(8710, 200916, 91901, 0, '2005-01-01 00:00:00', '2006-12-31 00:00:00'),
(8710, 200917, 91901, 0, '2007-01-01 00:00:00', NULL),
(8735, 200926, 61799, 0, '2005-01-01 00:00:00', '2006-12-31 00:00:00'),
(8735, 200927, 61799, 0, '2007-01-01 00:00:00', NULL);

INSERT INTO AggregatedAwards ("UID47_AggregateAwardsResKey", "UID15_CourseAdmissionsResKey", "E599_CourseOutcomeCode", "E591_HDRThesisSubmissionDate", "E592_CourseOutcomeDate", "E329_ModeOfAttendanceCode", "E330_AttendanceTypeCode") VALUES
(1001, 'c6a33a78afb3c4c6d1c7995e30ee32fc1a41eb7223c7876576c1464dff5d3bc0', 'COMPLETED', '2024-11-01 00:00:00', '2024-11-30 00:00:00', 'ON', 'FULLTIME'),
(1002, '1352130a9bf0fc648ea4d52b769db6e5d9a5ac51c39e8a35881feab327903e9e', 'WITHDRAWN', '2024-11-01 00:00:00', '2024-07-15 00:00:00', 'OFF', 'PARTTIME');