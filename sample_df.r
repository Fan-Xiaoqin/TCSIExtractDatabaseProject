# sample data from ChatGPT, only for development

students_data <- data.frame(
  UID1_ProvidersResKey = "P001",
  E306_ProviderCode = "306",
  E781_ProviderType = "University",
  UID8_StudentsResKey = "S001",
  E313_StudentIdentificationCode = "STU12345",
  E488_CHESSN = "123456789",
  E584_USI = "USI0001234",
  A170_USIVerificationStatus = "Verified",
  A167_TFNVerificationStatus = "Verified",
  E314_DateOfBirth = as.Date("2000-05-15"),
  E402_StudentFamilyName = "Wang",
  E403_StudentGivenNameFirst = "Li",
  E404_StudentGivenNameOthers = "Ming",
  E410_ResidentialAddressLine1 = "123 Main Street",
  E469_ResidentialAddressSuburb = "Perth",
  E320_ResidentialAddressPostcode = "6000",
  E470_ResidentialAddressState = "WA",
  E658_ResidentialAddressCountryCode = "AU",
  E787_FirstResidentialAddressLine1 = "45 First St",
  E789_FirstResidentialAddressSuburb = "Fremantle",
  E790_FirstResidentialAddressPostcode = "6160",
  E791_FirstResidentialAddressState = "WA",
  E659_FirstResidentialAddressCountryCode = "AU",
  E319_TermResidencePostcode = "6001",
  E661_TermResidenceCountryCode = "AU",
  E315_GenderCode = "M",
  E316_ATSICode = "N",
  E346_CountryOfBirthCode = "036",  # 036 = Australia
  E347_ArrivalInAustraliaYear = 2005,
  E348_LanguageSpokenAtHomeCode = "1201", # Mandarin
  E572_YearLeftSchool = 2018,
  E612_LevelLeftSchool = "12",
  E573_HighestEducationParent1 = "Bachelor",
  E574_HighestEducationParent2 = "Diploma",
  stringsAsFactors = FALSE
)
citizenships_data <- data.frame(
  UID1_ProvidersResKey = "P001",
  E306_ProviderCode = "306",
  E781_ProviderType = "University",
  UID8_StudentsResKey = "S001",
  E313_StudentIdentificationCode = "ST12345",
  E488_CHESSN = "123456789",
  UID10_StudentCitizenshipsResKey = "CIT001",
  E358_CitizenResidentCode = "AU",
  E609_EffectiveFromDate = as.Date("2020-01-01"),
  E610_EffectiveToDate = as.Date("2025-12-31"),
  stringsAsFactors = FALSE
)
disabilities_data <- data.frame(
  UID1_ProvidersResKey = c("P001", "P002", "P003"),
  E306_ProviderCode = c("PRV1", "PRV2", "PRV3"),
  E781_ProviderType = c("TypeA", "TypeB", "TypeC"),
  UID8_StudentsResKey = c("S001", "S002", "S003"),
  E313_StudentIdentificationCode = c("ID001", "ID002", "ID003"),
  E488_CHESSN = c("CH001", "CH002", "CH003"),
  UID11_StudentDisabilitiesResKey = c("D001", "D002", "D003"),
  E615_DisabilityCode = c("DISA", "DISB", "DISC"),
  E609_EffectiveFromDate = as.Date(c("2025-01-01", "2025-02-01", "2025-03-01")),
  E610_EffectiveToDate = as.Date(c("2025-12-31", "2025-12-31", "2025-12-31"))
)
common_wealth_scholarships_data <- data.frame(
  UID1_ProvidersResKey = 1:10,
  E306_ProviderCode = sample(c("PRV001","PRV002","PRV003"), 10, replace = TRUE),
  E781_ProviderType = sample(c("University","TAFE","Private"), 10, replace = TRUE),
  UID8_StudentsResKey = as.character(sample(1001:1020, 10)),
  E313_StudentIdentificationCode = paste0("SID", 2001:2010),
  E488_CHESSN = sample(700000000:799999999, 10),
  UID12_StudentCommonwealthScholarshipsResKey = 3001:3010,
  E415_ReportingYear = sample(2021:2024, 10, replace = TRUE),
  E666_ReportingPeriod = sample(c("Semester1","Semester2","Trimester1","Trimester2"), 10, replace = TRUE),
  E545_CommonwealthScholarshipType = sample(c("Equity","Merit","Indigenous"), 10, replace = TRUE),
  E526_CommonwealthScholarshipStatusCode = sample(c("Active","Completed","Terminated"), 10, replace = TRUE),
  E598_CommonwealthScholarshipAmount = sample(seq(1000, 10000, by = 500), 10),
  E538_CommonwealthScholarshipTerminationReasonCode = sample(
    c("FIN","ACA","PER","N/A"), 10, replace = TRUE) # FIN=Financial, ACA=Academic, PER=Personal
)


n <- 10
course_data <- data.frame(
  UID5_CoursesResKey = paste0("CRS", sprintf("%03d", 1:n)),
  UID3_CoursesOfStudyResKey = paste0("COS", sprintf("%02d", sample(1:20, n, replace = TRUE))),
  E307_CourseCode = paste0("C", 1000 + 1:n),
  E308_CourseName = sample(c("Algorithms", "Calculus", "Quantum Mechanics", "History"), n, replace = TRUE),
  E596_StandardCourseDuration = sample(1:4, n, replace = TRUE),
  E609_EffectiveFromDate = sample(seq(as.Date("2020-01-01"), as.Date("2024-12-31"), by="day"), n),
  E610_EffectiveToDate = sample(seq(as.Date("2025-01-01"), as.Date("2030-12-31"), by="day"), n)
)
courses_special_interest_data <- data.frame(
  UID30_SpecialInterestCoursesResKey = paste0("SIC", sprintf("%03d", 1:n)),
  UID5_CoursesResKey = course_data$UID5_CoursesResKey, 
  E312_SpecialCourseType = sample(c("Honors", "Elective", "Workshop", "Seminar"), n, replace = TRUE),
  E609_EffectiveFromDate = course_data$E609_EffectiveFromDate,
  E610_EffectiveToDate = course_data$E610_EffectiveToDate
)
course_fields_of_education_data <- data.frame(
  UID48_CourseFieldsOfEducationResKey = paste0("FOE", sprintf("%03d", 1:n)),
  UID5_CoursesResKey = course_data$UID5_CoursesResKey, 
  E461_FieldOfEducationCode = paste0("FOECode", sample(101:200, n)),
  E462_FieldOfEducationSupplementaryCode = sample(1:20, n, replace = TRUE),
  E609_EffectiveFromDate = course_data$E609_EffectiveFromDate,
  E610_EffectiveToDate = course_data$E610_EffectiveToDate
)
course_of_study_data <- data.frame(
  UID3_CoursesOfStudyResKey = paste0("COS", sprintf("%02d", 1:20)),  # 20个方向
  E533_CourseOfStudyCode = paste0("CSC", 101:120),
  E394_CourseOfStudyName = c("Computer Science", "Mathematics", "Physics", "History", "Biology",
  "Chemistry", "Engineering", "Economics", "Law", "Psychology",
  "Philosophy", "Sociology", "Art", "Music", "Design",
  "Architecture", "Business", "Education", "Medicine", "Nursing"),
  E310_CourseOfStudyType = sample(c("Undergraduate", "Postgraduate", "Vocational"), 20, replace = TRUE),
  E350_CourseOfStudyLoad = sample(c("Full-time", "Part-time"), 20, replace = TRUE),
  E455_CombinedCourseOfStudyIndicator = sample(c("Y", "N"), 20, replace = TRUE)
)

course_on_campus_data <- data.frame(
  UID4_CoursesOnCampusResKey = paste0("CC", sprintf("%03d", 1:n)),
  UID5_CoursesResKey = course_data$UID5_CoursesResKey,  # 一对一
  UID2_CampusesResKey = paste0("CMP", sprintf("%03d", 1:n)),
  E525_CampusSuburb = sample(c("Sydney", "Melbourne", "Brisbane", "Perth", "Adelaide"), n, replace = TRUE),
  E644_CampusCountryCode = "AU",
  E559_CampusPostcode = sample(c("2000","3000","4000","5000","6000"), n, replace = TRUE),
  E569_CampusOperationType = sample(c("Full-time", "Part-time"), n, replace = TRUE),
  E570_PrincipalOffshoreDeliveryMode = sample(c("Onshore","Offshore"), n, replace = TRUE),
  E571_OffshoreDeliveryCode = NA_character_,
  E609_EffectiveFromDate = course_data$E609_EffectiveFromDate,
  E610_EffectiveToDate = course_data$E610_EffectiveToDate
)
campus_course_fees_data  <- data.frame(
  UID1_ProvidersResKey = c(101, 102),
  E306_ProviderCode = c("P001", "P002"),
  E781_ProviderType = c("University", "TAFE"),
  
  UID31_CampusCourseFeesResKey = c(201, 202),
  UID4_CoursesOnCampusResKey = c(301, 302),
  E525_CampusSuburb = c("SuburbA", "SuburbB"),
  E644_CampusCountryCode = c("AU", "AU"),
  E559_CampusPostcode = c("2000", "3000"),
  Campuses_E609_EffectiveFromDate = as.Date(c("2023-01-01","2023-02-01")),
  
  UID5_CoursesResKey = c(301, 302),
  E307_CourseCode = c("C101", "C102"),
  E536_CourseFeesCode = c("F001", "F002"),
  E495_IndicativeStudentContributionCSP = c(5000, 6000),
  E496_IndicativeTuitionFeeDomesticFP = c(10000, 12000),
  E609_EffectiveFromDate = as.Date(c("2023-01-15","2023-02-15"))
)
campus_tac_df <- data.frame(
  UID1_ProvidersResKey = c(101, 102, 101),
  E306_ProviderCode = c("P001", "P002", "P001"),
  E781_ProviderType = c("University", "TAFE", "University"),
  UID40_CoursesOnCampusTACResKey = c(401, 402, 403),
  UID4_CoursesOnCampusResKey = c(301, 302, 301),
  E557_TACOfferCode = c("TAC01", "TAC02", "TAC03")
)



course_admissions_data <- data.frame(
  UID1_ProvidersResKey = paste0("PRV", sprintf("%03d", sample(1:20, n, replace = TRUE))),
  E306_ProviderCode = paste0("P", sample(100:999, n, replace = TRUE)),
  E781_ProviderType = sample(c("University", "College", "Institute", "HighSchool"), n, replace = TRUE),
  UID8_StudentsResKey = paste0("STU", sprintf("%04d", sample(1:200, n, replace = TRUE))),
  E313_StudentIdentificationCode = paste0("SID", sprintf("%05d", sample(1:500, n, replace = TRUE))),
  E488_CHESSN = paste0("CH", sprintf("%06d", sample(1:500, n, replace = TRUE))),
  UID15_CourseAdmissionsResKey = paste0("CA", sprintf("%04d", sample(1:200, n, replace = TRUE))),
  UID5_CoursesResKey = paste0("CRS", sprintf("%03d", sample(1:50, n, replace = TRUE))),
  E307_CourseCode = paste0("C", sample(1000:1999, n, replace = TRUE)),
  E308_CourseName = sample(c("Algorithms", "Calculus", "Physics", "History"), n, replace = TRUE),
  E533_CourseOfStudyCode = paste0("COS", sample(100:199, n, replace = TRUE)),
  E310_CourseOfStudyType = sample(c("Undergraduate", "Postgraduate", "Vocational"), n, replace = TRUE),
  E534_CourseOfStudyCommencementDate = sample(seq(as.Date('2020-01-01'), as.Date('2024-12-31'), by="day"), n, replace = TRUE),
  UID37_HDREndUserEngagementsResKey = paste0("ENG", sprintf("%04d", sample(1:100, n, replace = TRUE))),
  E593_HDREndUserEngagementCode = sample(c("Research", "Thesis", "Project"), n, replace = TRUE),
  E609_HDREndUserEngageFromDate = sample(seq(as.Date('2021-01-01'), as.Date('2024-12-31'), by="day"), n, replace = TRUE),
  E610_HDREndUserEngageToDate = sample(seq(as.Date('2022-01-01'), as.Date('2025-12-31'), by="day"), n, replace = TRUE),
  E798_HDRDaysOfEngagement = sample(1:365, n, replace = TRUE)
)
course_specialisations_data <- data.frame(
  UID1_ProvidersResKey = paste0("PRV", sprintf("%03d", sample(1:20, n, replace = TRUE))),
  E306_ProviderCode = paste0("P", sample(100:999, n, replace = TRUE)),
  E781_ProviderType = sample(c("University", "College", "Institute", "HighSchool"), n, replace = TRUE),
  UID15_CourseAdmissionsResKey = paste0("CA", sprintf("%04d", sample(1:200, n, replace = TRUE))),
  E313_StudentIdentificationCode = paste0("SID", sprintf("%05d", sample(1:500, n, replace = TRUE))),
  E307_CourseCode = paste0("C", sample(1000:1999, n, replace = TRUE)),
  E534_CourseOfStudyCommencementDate = sample(seq(as.Date('2020-01-01'), as.Date('2024-12-31'), by="day"), n, replace = TRUE),
  UID47_AggregateAwardsResKey = paste0("AA", sprintf("%04d", sample(1:100, n, replace = TRUE))),
  UID33_CourseSpecialisationsResKey = paste0("CS", sprintf("%04d", sample(1:100, n, replace = TRUE))),
  E463_SpecialisationCode = paste0("SPC", sprintf("%03d", sample(1:50, n, replace = TRUE)))
)
rtp_scholarships_data <- data.frame(
  UID1_ProvidersResKey = paste0("PRV", sprintf("%03d", sample(1:20, n, replace = TRUE))),
  E306_ProviderCode = paste0("P", sample(100:999, n, replace = TRUE)),
  E781_ProviderType = sample(c("University", "College", "Institute", "HighSchool"), n, replace = TRUE),
  UID8_StudentsResKey = paste0("STU", sprintf("%04d", sample(1:200, n, replace = TRUE))),
  E313_StudentIdentificationCode = paste0("SID", sprintf("%05d", sample(1:500, n, replace = TRUE))),
  E488_CHESSN = paste0("CH", sprintf("%06d", sample(1:500, n, replace = TRUE))),
  UID15_CourseAdmissionsResKey = paste0("CA", sprintf("%04d", sample(1:200, n, replace = TRUE))),
  UID5_CoursesResKey = paste0("CRS", sprintf("%03d", sample(1:50, n, replace = TRUE))),
  E307_CourseCode = paste0("C", sample(1000:1999, n, replace = TRUE)),
  E308_CourseName = sample(c("Algorithms", "Calculus", "Physics", "History"), n, replace = TRUE),
  E533_CourseOfStudyCode = paste0("COS", sample(100:199, n, replace = TRUE)),
  E310_CourseOfStudyType = sample(c("Undergraduate", "Postgraduate", "Vocational"), n, replace = TRUE),
  E534_CourseOfStudyCommencementDate = sample(seq(as.Date('2020-01-01'), as.Date('2024-12-31'), by="day"), n, replace = TRUE),
  UID35_RTPScholarshipsResKey = paste0("RTP", sprintf("%04d", sample(1:100, n, replace = TRUE))),
  E487_RTPScholarshipType = sample(c("Full", "Partial", "Top-up"), n, replace = TRUE),
  E609_RTPScholarshipFromDate = sample(seq(as.Date('2021-01-01'), as.Date('2024-12-31'), by="day"), n, replace = TRUE),
  E610_RTPScholarshipToDate = sample(seq(as.Date('2022-01-01'), as.Date('2025-12-31'), by="day"), n, replace = TRUE)
)
rtp_stipends_data <- data.frame(
  UID1_ProvidersResKey = paste0("PRV", sprintf("%03d", sample(1:20, n, replace = TRUE))),
  E306_ProviderCode = paste0("P", sample(100:999, n, replace = TRUE)),
  E781_ProviderType = sample(c("University", "College", "Institute", "HighSchool"), n, replace = TRUE),
  UID15_CourseAdmissionsResKey = paste0("CA", sprintf("%04d", sample(1:200, n, replace = TRUE))),
  E313_StudentIdentificationCode = paste0("SID", sprintf("%05d", sample(1:500, n, replace = TRUE))),
  E307_CourseCode = paste0("C", sample(1000:1999, n, replace = TRUE)),
  E534_CourseOfStudyCommencementDate = sample(seq(as.Date('2020-01-01'), as.Date('2024-12-31'), by="day"), n, replace = TRUE),
  UID18_RTPStipendsResKey = paste0("STP", sprintf("%04d", sample(1:100, n, replace = TRUE))),
  E623_RTPStipendAmount = sample(seq(5000, 50000, by=500), n, replace = TRUE),
  E415_ReportingYear = sample(2020:2025, n, replace = TRUE)
)
basis_for_admission_data <- data.frame(
  UID1_ProvidersResKey = paste0("PRV", sprintf("%03d", sample(1:20, n, replace = TRUE))),
  E306_ProviderCode = paste0("P", sample(100:999, n, replace = TRUE)),
  E781_ProviderType = sample(c("University", "College", "Institute", "HighSchool"), n, replace = TRUE),
  UID15_CourseAdmissionsResKey = paste0("CA", sprintf("%04d", sample(1:150, n, replace = TRUE))),
  E313_StudentIdentificationCode = paste0("SID", sprintf("%05d", sample(1:500, n, replace = TRUE))),
  E307_CourseCode = paste0("C", sample(1000:1999, n, replace = TRUE)),
  E534_CourseOfStudyCommencementDate = sample(seq(as.Date('2015-01-01'), as.Date('2025-12-31'), by="day"), n, replace = TRUE),
  UID17_BasisForAdmissionResKey = paste0("BFA", sprintf("%04d", sample(1:50, n, replace = TRUE))),
  E327_BasisForAdmissionCode = sample(c("ATAR", "VET", "International", "Other"), n, replace = TRUE)
)
course_prior_credits_data <- data.frame(
  UID1_ProvidersResKey = paste0("PRV", sprintf("%03d", sample(1:10, n, replace = TRUE))),
  E306_ProviderCode = paste0("P", sample(100:999, n, replace = TRUE)),
  E781_ProviderType = sample(c("University", "College", "Institute", "HighSchool"), n, replace = TRUE),
  UID15_CourseAdmissionsResKey = paste0("CA", sprintf("%03d", sample(1:30, n, replace = TRUE))),
  E313_StudentIdentificationCode = paste0("SID", sprintf("%04d", sample(1:50, n, replace = TRUE))),
  E307_CourseCode = paste0("C", sample(1000:1100, n, replace = TRUE)),
  E534_CourseOfStudyCommencementDate = sample(seq(as.Date('2020-01-01'), as.Date('2023-12-31'), by="day"), n, replace = TRUE),
  UID32_CoursePriorCreditsResKey = paste0("CPC", sprintf("%03d", 1:n)),
  E560_CreditUsedValue = sample(c(0.25, 0.5, 0.75, 1), n, replace = TRUE),
  E561_CreditBasis = sample(c("Previous Course", "Work Experience", "Other"), n, replace = TRUE),
  E566_CreditProviderCode = paste0("CP", sample(200:299, n, replace = TRUE))
)
HDRendUserEngagement_data <- data.frame(
  UID1_ProvidersResKey = 1:10,
  E306_ProviderCode = sample(c("PRV001", "PRV002", "PRV003"), 10, replace = TRUE),
  E781_ProviderType = sample(c("University", "TAFE", "Private"), 10, replace = TRUE),
  UID8_StudentsResKey = sample(1001:1010, 10, replace = FALSE),
  E313_StudentIdentificationCode = paste0("SID", 2001:2010),
  E488_CHESSN = sample(700000000:799999999, 10),
  UID15_CourseAdmissionsResKey = as.character(2001:2010),
  UID5_CoursesResKey = 3001:3010,
  E307_CourseCode = paste0("C", sample(100:199, 10)),
  E308_CourseName = sample(c("Data Science", "AI Fundamentals", "Web Dev", "Networking"), 10, replace = TRUE),
  E533_CourseOfStudyCode = paste0("CS", sample(500:599, 10)),
  E310_CourseOfStudyType = sample(c("Bachelor", "Master", "PhD"), 10, replace = TRUE),
  E534_CourseOfStudyCommencementDate = sample(seq(as.Date("2020-01-01"), as.Date("2023-12-31"), by="month"), 10),
  UID37_HDREndUserEngagementsResKey = 4001:4010,
  E593_HDREndUserEngagementCode = sample(c("ENG01", "ENG02", "ENG03"), 10, replace = TRUE),
  E609_HDREndUserEngageFromDate = sample(seq(as.Date("2021-01-01"), as.Date("2024-01-01"), by="month"), 10),
  E610_HDREndUserEngageToDate = sample(seq(as.Date("2024-02-01"), as.Date("2025-12-31"), by="month"), 10),
  E798_HDRDaysOfEngagement = sample(10:100, 10, replace = TRUE)
)
sa_help_data <- data.frame(
  UID1_ProvidersResKey = c(101, 102, 101),
  E306_ProviderCode = c("P001", "P002", "P001"),
  E781_ProviderType = c("University", "TAFE", "University"),
  
  UID8_StudentsResKey = c("STU001", "STU002", "STU003"),
  E313_StudentIdentificationCode = c("SID001", "SID002", "SID003"),
  E488_CHESSN = c("CH001", "CH002", "CH003"),
  
  UID21_StudentLoansResKey = c(1001, 1002, 1003),
  E307_CourseCode = c("C101", "C102", "C101"),
  E527_HELPDebtIncurralDate = as.Date(c("2024-01-01","2024-02-01","2024-01-05")),
  E490_StudentStatusCode = c("Active","Active","Active"),
  
  E384_AmountCharged = c(5000, 6000, 5000),
  E381_AmountPaidUpfront = c(1000, 1500, 1200),
  E558_HELPLoanAmount = c(4000, 4500, 3800),
  A130_LoanStatus = c("Approved","Approved","Pending"),
  Invalidated_Flag = c(FALSE,FALSE,TRUE)
)
os_help_data <- data.frame(
  UID1_ProvidersResKey = c(101, 102, 101),
  E306_ProviderCode = c("P001", "P002", "P001"),
  E781_ProviderType = c("University", "TAFE", "University"),
  
  UID8_StudentsResKey = c("STU001", "STU002", "STU003"),
  UID15_CourseAdmissionsResKey = c("CA001", "CA002", "CA003"),
  E313_StudentIdentificationCode = c("SID001", "SID002", "SID003"),
  E488_CHESSN = c("CH001", "CH002", "CH003"),
  
  UID21_StudentLoansResKey = c(1001, 1002, 1003),
  E307_CourseCode = c("C101", "C102", "C101"),
  E527_HELPDebtIncurralDate = as.Date(c("2024-01-01","2024-02-01","2024-01-05")),
  E490_StudentStatusCode = c("Active","Active","Active"),
  
  E521_OSHELPStudyPeriodCommencementDate = as.Date(c("2024-02-01","2024-03-01","2024-02-15")),
  E553_OSHELPStudyPrimaryCountryCode = c("US", "UK", "US"),
  E554_OSHELPStudySecondaryCountryCode = c("FR", NA, "DE"),
  E583_OSHELPLanguageStudyCommencementDate = as.Date(c("2024-02-10","2024-03-05","2024-02-20")),
  E582_OSHELPLanguageCode = c("EN", "EN", "EN"),
  
  E528_OSHELPPaymentAmount = c(2000, 2500, 1800),
  E529_LoanFee = c(50, 60, 45),
  A130_LoanStatus = c("Approved","Approved","Pending"),
  Invalidated_Flag = c(FALSE,FALSE,TRUE)
)
exit_awards_data <- data.frame(
  UID1_ProvidersResKey = c(101, 102, 101),
  E306_ProviderCode = c("P001", "P002", "P001"),
  UID8_StudentsResKey = c("STU001", "STU002", "STU003"),
  E313_StudentIdentificationCode = c("SID001", "SID002", "SID003"),
  E781_ProviderType = c("University", "TAFE", "University"),
  
  UID46_EarlyExitAwardsResKey = c(501, 502, 503),
  UID15_CourseAdmissionsResKey = c("CA001", "CA002", "CA003"),
  UID5_CoursesResKey = c(301, 302, 303),
  E307_CourseCode = c("C101", "C102", "C103"),
  E308_CourseName = c("Math","Physics","History"),
  
  E599_CourseOutcomeCode = c("EO01","EO02","EO03"),
  E592_CourseOutcomeDate = as.Date(c("2024-06-01","2024-07-01","2024-08-01"))
)
aggregated_awards_data <- data.frame(
    UID1_ProvidersResKey = c(101, 102, 101),
  E306_ProviderCode = c("P001", "P002", "P001"),
  E781_ProviderType = c("University", "TAFE", "University"),
  
  UID47_AggregateAwardsResKey = c(601, 602, 603),
  UID8_StudentsResKey = c("STU001", "STU002", "STU003"),
  E313_StudentIdentificationCode = c("SID001", "SID002", "SID003"),
  
  UID5_CoursesResKey = c(301, 302, 303),
  E307_CourseCode = c("C101", "C102", "C103"),
  E534_CourseOfStudyCommencementDate = as.Date(c("2023-10-01","2023-11-01","2023-12-01")),
  
  E599_CourseOutcomeCode = c("AO01","AO02","AO03"),
  E591_HDRThesisSubmissionDate = as.Date(c("2024-06-15","2024-07-15","2024-08-15")),
  E592_CourseOutcomeDate = as.Date(c("2024-06-01","2024-07-01","2024-08-01")),
  
  E329_ModeOfAttendanceCode = c("FT","PT","FT"),
  E330_AttendanceTypeCode = c("OnCampus","Online","OnCampus")
)

unit_enrolments_data <- data.frame(
  E306_ProviderCode = paste0("P", sample(100:999, n, TRUE)),
  UID8_StudentsResKey = paste0("STU", sprintf("%04d", sample(1:200, n, TRUE))),
  E313_StudentIdentificationCode = paste0("SID", sprintf("%05d", sample(1:500, n, TRUE))),
  E488_CHESSN = paste0("CH", sprintf("%06d", sample(1:500, n, TRUE))),
  UID15_CourseAdmissionsResKey = paste0("CA", sprintf("%04d", sample(1:300, n, TRUE))),
  E533_CourseOfStudyCode = paste0("COS", sample(100:199, n, TRUE)),
  E310_CourseOfStudyType = sample(c("Undergraduate", "Postgraduate", "Vocational"), n, TRUE),
  UID5_CoursesResKey = paste0("CRS", sprintf("%03d", sample(1:50, n, TRUE))),
  E307_CourseCode = paste0("C", sample(1000:1999, n, TRUE)),
  E308_CourseName = sample(c("Algorithms","Calculus","Physics","History"), n, TRUE),
  E534_CourseOfStudyCommDate = sample(seq(as.Date("2020-01-01"), as.Date("2024-12-31"), by="day"), n),
  UID16_UnitEnrolmentsResKey = paste0("UE", sprintf("%05d", sample(1:500, n, TRUE))),
  E354_UnitOfStudyCode = paste0("U", sample(100:999, n, TRUE)),
  E489_UnitOfStudyCensusDate = sample(seq(as.Date("2022-01-01"), as.Date("2024-12-31"), by="day"), n),
  E337_WorkExperienceInIndustryCode = sample(c("Y","N"), n, TRUE),
  E551_SummerWinterSchoolCode = sample(c("S","W"), n, TRUE),
  E464_DisciplineCode = paste0("D", sample(100:199, n, TRUE)),
  E355_UnitOfStudyStatusCode = sample(1:5, n, TRUE),
  E329_ModeOfAttendanceCode = sample(c("ON","OFF"), n, TRUE),
  E477_DeliveryLocationPostcode = sample(1000:9999, n, TRUE),
  E660_DeliveryLocationCountryCode = sample(c("AU","NZ","US"), n, TRUE),
  E490_StudentStatusCode = sample(1:3, n, TRUE),
  E392_MaximumStudentContributionCode = sample(1:4, n, TRUE),
  E622_UnitOfStudyYearLongIndicator = sample(c("Y","N"), n, TRUE),
  E600_UnitOfStudyCommencementDate = sample(seq(as.Date("2022-01-01"), as.Date("2024-12-31"), by="day"), n),
  E601_UnitOfStudyOutcomeDate = sample(seq(as.Date("2022-06-01"), as.Date("2025-12-31"), by="day"), n),
  E446_RemissionReasonCode = sample(100:199, n, TRUE),
  A130_LoanStatus = sample(c("Active","Closed","Pending"), n, TRUE),
  UID21_StudentLoansResKey = paste0("LN", sprintf("%05d", sample(1:300, n, TRUE))),
  E662_AdjustedLoanAmount = sample(seq(1000,5000,by=250), n, TRUE),
  E663_AdjustedLoanFee = sample(seq(100,500,by=50), n, TRUE),
  UE_E339_EFTSL = runif(n,0.1,1),
  UE_E384_AmountCharged = sample(seq(500,5000,by=100), n, TRUE),
  UE_E381_AmountPaidUpfront = sample(seq(0,2000,by=100), n, TRUE),
  UE_E558_HELPLoanAmount = sample(seq(0,4000,by=200), n, TRUE),
  UE_E529_LoanFee = sample(seq(0,400,by=20), n, TRUE),
  UE_A111_IsDeleted = sample(c(TRUE,FALSE), n, TRUE),
  UID19_UnitEnrolmentAOUsResKey = paste0("AOU", sprintf("%05d", sample(1:500, n, TRUE))),
  E333_AOUCode = paste0("AOU", sample(100:199, n, TRUE)),
  AOU_E339_EFTSL = runif(n,0.05,0.5),
  AOU_E384_AmountCharged = sample(seq(200,3000,by=50), n, TRUE),
  AOU_E381_AmountPaidUpfront = sample(seq(0,1500,by=50), n, TRUE),
  AOU_E558_HELPLoanAmount = sample(seq(0,2500,by=100), n, TRUE),
  AOU_E529_LoanFee = sample(seq(0,250,by=10), n, TRUE),
  AOU_IsDeleted = sample(c(TRUE,FALSE), n, TRUE)
)
units_aou <- data.frame(
  E306_ProviderCode = sample(c("PRV001","PRV002","PRV003"), 5, replace = TRUE),
  UID8_StudentsResKey = sample(1001:1050, 5),
  E313_StudentIdentificationCode = paste0("SID", 2001:2005),
  E488_CHESSN = sample(700000000:799999999, 5),
  UID15_CourseAdmissionsResKey = 3001:3005,
  E533_CourseOfStudyCode = paste0("CS", sample(500:599, 5)),
  E310_CourseOfStudyType = sample(c("Bachelor","Master","PhD"), 5, replace = TRUE),
  UID5_CoursesResKey = 4001:4005,
  E307_CourseCode = paste0("C", sample(100:199, 5)),
  E308_CourseName = sample(c("Data Science","AI Fundamentals","Networking","Web Development"), 5, replace = TRUE),
  E534_CourseOfStudyCommDate = sample(seq(as.Date("2020-01-01"), as.Date("2023-12-31"), by="month"), 5),
  UID16_UnitEnrolmentsResKey = as.character(5001:5015),
  E354_UnitOfStudyCode = paste0("U", sample(1000:1999, 5)),
  E489_UnitOfStudyCensusDate = sample(seq(as.Date("2023-01-01"), as.Date("2024-12-31"), by="month"), 5),
  E337_WorkExperienceInIndustryCode = sample(c("Y","N"), 5, replace = TRUE),
  E551_SummerWinterSchoolCode = sample(c("S","W","N"), 5, replace = TRUE),
  E464_DisciplineCode = sample(sprintf("%03d", 1:999), 5),
  E355_UnitOfStudyStatusCode = sample(c("Active","Withdrawn","Completed"), 5, replace = TRUE),
  E329_ModeOfAttendanceCode = sample(c("Internal","External","Multi-Mode"), 5, replace = TRUE),
  E477_DeliveryLocationPostcode = sample(1000:7999, 5),
  E660_DeliveryLocationCountryCode = sample(c("AU","NZ","CN","IN"), 5, replace = TRUE),
  E490_StudentStatusCode = sample(c("Enrolled","Deferred","Completed"), 5, replace = TRUE),
  E392_MaximumStudentContributionCode = sample(c("A","B","C"), 5, replace = TRUE),
  E622_UnitOfStudyYearLongIndicator = sample(c("Y","N"), 5, replace = TRUE),
  E600_UnitOfStudyCommencementDate = sample(seq(as.Date("2023-01-01"), as.Date("2024-06-30"), by="month"), 5),
  E601_UnitOfStudyOutcomeDate = sample(seq(as.Date("2023-07-01"), as.Date("2025-12-31"), by="month"), 5),
  E446_RemissionReasonCode = sample(c("FIN","ACA","PER","N/A"), 5, replace = TRUE),
  A130_LoanStatus = sample(c("Active","Closed","Cancelled"), 5, replace = TRUE),
  UID21_StudentLoansResKey = 6001:6015,
  E662_AdjustedLoanAmount = sample(seq(1000,10000,500), 5),
  E663_AdjustedLoanFee = sample(seq(50,500,50), 5),
  UE_E339_EFTSL = round(runif(5, 0.125, 1.0),3),
  UE_E384_AmountCharged = sample(seq(1000,8000,500), 5),
  UE_E381_AmountPaidUpfront = sample(seq(0,4000,500), 5),
  UE_E558_HELPLoanAmount = sample(seq(0,8000,500), 5),
  UE_E529_LoanFee = sample(seq(0,500,50), 5),
  UE_A111_IsDeleted = sample(c(TRUE,FALSE), 5, replace = TRUE),
  UID19_UnitEnrolmentAOUsResKey = 7001:7015,
  E333_AOUCode = paste0("AOU", sample(10:99,5)),
  AOU_E339_EFTSL = round(runif(5, 0.125, 1.0),3),
  AOU_E384_AmountCharged = sample(seq(1000,8000,500), 5),
  AOU_E381_AmountPaidUpfront = sample(seq(0,4000,500), 5),
  AOU_E558_HELPLoanAmount = sample(seq(0,8000,500), 5),
  AOU_E529_LoanFee = sample(seq(0,500,50), 5),
  AOU_IsDeleted = sample(c(TRUE,FALSE), 5, replace = TRUE)
)


