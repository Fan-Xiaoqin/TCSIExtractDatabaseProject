# Data Dictionary

## HEPStudents
> Core student demographic and personal information table for Higher Education Provider (HEP) students.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| Student_Key | Integer | Primary key - unique identifier for each student record | Yes |
| UID8_StudentsResKey | String | Unique resource key for student records | Yes |
| E313_StudentIdentificationCode | String | Student identification code assigned by the provider | Yes |
| E488_CHESSN | String | Commonwealth Higher Education Student Support Number - unique identifier for students receiving Commonwealth assistance | No |
| E584_USI | String | Unique Student Identifier - lifelong education number for all Australian students | No |
| A170_USIVerificationStatus | String | Status of USI verification (Verified/Unverified) | No |
| A167_TFNVerificationStatus | String | Tax File Number verification status | No |
| E314_DateOfBirth | Date | Student's date of birth | Yes |
| E402_StudentFamilyName | String | Student's family/surname | Yes |
| E403_StudentGivenNameFirst | String | Student's first given name | Yes |
| E404_StudentGivenNameOthers | String | Student's other given names | No |
| E410_ResidentialAddressLine1 | String | First line of residential address | Yes |
| E469_ResidentialAddressSuburb | String | Residential suburb/town | Yes |
| E320_ResidentialAddressPostcode | String | Residential postcode | Yes |
| E470_ResidentialAddressState | String | Residential state/territory code | Yes |
| E658_ResidentialAddressCountryCode | String | Country code for residential address | Yes |
| E319_TermResidencePostcode | String | Postcode of term-time residence | No |
| E661_TermResidenceCountryCode | String | Country code for term-time residence | No |
| E315_GenderCode | String | Gender code (M/F/X) | Yes |
| E316_ATSICode | String | Aboriginal and Torres Strait Islander status code | Yes |
| E346_CountryOfBirthCode | String | Country of birth code (ISO) | Yes |
| E347_ArrivalInAustraliaYear | Integer | Year of arrival in Australia (if applicable) | No |
| E348_LanguageSpokenAtHomeCode | String | Main language spoken at home code | Yes |
| E572_YearLeftSchool | Integer | Year student left secondary school | No |
| E612_LevelLeftSchool | String | Highest level of secondary education completed | No |
| E573_HighestEducationParent1 | String | Highest education level of parent/guardian 1 | No |
| E574_HighestEducationParent2 | String | Highest education level of parent/guardian 2 | No |
| Start_Date | Date | Date record became effective | Yes |
| End_Date | Date | Date record ceased to be effective | No |
| Is_Current | Boolean | Indicates if this is the current active record | Yes |

## HEP_units-AOUs
> Unit enrollments and Areas of Study (AOUs) for students, including financial and study load information.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| UE_AOU_Key | Integer | Primary key for unit enrollment/AOU record | Yes |
| Student_key | Integer | Foreign key to HEPStudents table | Yes |
| E313_StudentIdentificationCode | String | Student identification code | Yes |
| E488_CHESSN | String | CHESSN identifier | No |
| UID15_CourseAdmissionsResKey | String | Foreign key to course admissions | Yes |
| E533_CourseOfStudyCode | String | Code for the course of study | Yes |
| E310_CourseOfStudyType | String | Type of course (undergraduate/postgraduate/etc.) | Yes |
| UID5_CoursesResKey | String | Foreign key to courses table | Yes |
| E307_CourseCode | String | Course code | Yes |
| E308_CourseName | String | Course name | Yes |
| E534_CourseOfStudyCommDate | Date | Course commencement date | Yes |
| UID16_UnitEnrolmentsResKey | String | Unit enrollment resource key | Yes |
| E354_UnitOfStudyCode | String | Unit/subject code | Yes |
| E489_UnitOfStudyCensusDate | Date | Census date for the unit | Yes |
| E337_WorkExperienceInIndustryCode | String | Work experience/placement indicator | No |
| E551_SummerWinterSchoolCode | String | Summer/winter school indicator | No |
| E464_DisciplineCode | String | Field of education/discipline code | Yes |
| E355_UnitOfStudyStatusCode | String | Unit enrollment status | Yes |
| E329_ModeOfAttendanceCode | String | Mode of attendance (internal/external/multi-modal) | Yes |
| E477_DeliveryLocationPostcode | String | Location where unit is delivered | Yes |
| E660_DeliveryLocationCountryCode | String | Country code for delivery location | Yes |
| E490_StudentStatusCode | String | Student status code | Yes |
| E392_MaximumStudentContributionCode | String | Maximum student contribution indicator | No |
| E600_UnitOfStudyCommencementDate | Date | Unit start date | Yes |
| E601_UnitOfStudyOutcomeDate | Date | Unit outcome/completion date | No |
| E446_RemissionReasonCode | String | Reason for fee remission | No |
| A130_LoanStatus | String | HELP loan status | No |
| UID21_StudentLoansResKey | String | Foreign key to student loans | No |
| E662_AdjustedLoanAmount | Decimal | Adjusted loan amount | No |
| E663_AdjustedLoanFee | Decimal | Adjusted loan fee | No |
| UE_E339_EFTSL | Decimal | Equivalent Full-Time Student Load for unit enrollment | Yes |
| UE_E384_AmountCharged | Decimal | Amount charged for unit enrollment | Yes |
| UE_E381_AmountPaidUpfront | Decimal | Amount paid upfront by student | No |
| UE_E558_HELPLoanAmount | Decimal | HELP loan amount for unit | No |
| UE_E529_LoanFee | Decimal | Loan fee amount | No |
| UE_A111_IsDeleted | Boolean | Deletion flag for unit enrollment | No |
| UID19_UnitEnrolmentAOUsResKey | String | Unit enrollment AOU resource key | No |
| E333_AOUCode | String | Area of Study code | No |
| AOU_E339_EFTSL | Decimal | EFTSL for Area of Study | No |
| AOU_E384_AmountCharged | Decimal | Amount charged for AOU | No |
| AOU_E381_AmountPaidUpfront | Decimal | Amount paid upfront for AOU | No |
| AOU_E529_LoanFee | Decimal | Loan fee for AOU | No |
| AOU_IsDeleted | Boolean | Deletion flag for AOU | No |
| Year | Integer | Academic year | Yes |
| Start_Date | Date | Record start date | Yes |
| End_Date | Date | Record end date | No |
| Is_Current | Boolean | Current record indicator | Yes |

## StudentLoans
> Student loan information including HELP (Higher Education Loan Program) details.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| Student_Key | Integer | Foreign key to HEPStudents | Yes |
| E313_StudentIdentificationCode | String | Student ID code | Yes |
| E488_CHESSN | String | CHESSN identifier | No |
| UID21_StudentLoansResKey | String | Primary key for student loans | Yes |
| UID15_CourseAdmissionsResKey | String | Foreign key to course admissions | Yes |
| E307_CourseCode | String | Course code | Yes |
| E527_HELPDebtIncurralDate | Date | Date HELP debt was incurred | Yes |
| E490_StudentStatusCode | String | Student status | Yes |
| **SAHELP Section** | | | |
| E384_AmountCharged | Decimal | SA-HELP amount charged | No |
| E381_AmountPaidUpfront | Decimal | SA-HELP amount paid upfront | No |
| E558_HELPLoanAmount | Decimal | SA-HELP loan amount | No |
| A130_LoanStatus | String | SA-HELP loan status | No |
| Invalidated_Flag | Boolean | SA-HELP invalidation indicator | No |
| **OSHELP Section** | | | |
| E521_OSHELPStudyPeriodCommencementDate | Date | OS-HELP study period start date | No |
| E553_OSHELPStudyPrimaryCountryCode | String | Primary country for OS-HELP study | No |
| E554_OSHELPStudySecondaryCountryCode | String | Secondary country for OS-HELP study | No |
| E583_OSHELPLanguageStudyCommencementDate | Date | Language study start date | No |
| E582_OSHELPLanguageCode | String | Language being studied | No |
| E528_OSHELPPaymentAmount | Decimal | OS-HELP payment amount | No |
| E529_LoanFee | Decimal | OS-HELP loan fee | No |
| A130_LoanStatus | String | OS-HELP loan status | No |
| Invalidated_Flag | Boolean | OS-HELP invalidation indicator | No |

## HEPStudentCitizenships
> Student citizenship and residency information.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| UID8_StudentsResKey | String | Student resource key | Yes |
| Student_Key | Integer | Foreign key to HEPStudents | Yes |
| E313_StudentIdentificationCode | String | Student ID code | Yes |
| E488_CHESSN | String | CHESSN identifier | No |
| UID10_StudentCitizenshipsResKey | String | Primary key for citizenship record | Yes |
| E358_CitizenResidentCode | String | Citizenship/residency status code | Yes |
| E609_EffectiveFromDate | Date | Date citizenship status became effective | Yes |
| E610_EffectiveToDate | Date | Date citizenship status ended | No |

## HEPStudentDisabilities
> Student disability information.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| UID8_StudentsResKey | String | Student resource key | Yes |
| Student_Key | Integer | Foreign key to HEPStudents | Yes |
| E313_StudentIdentificationCode | String | Student ID code | Yes |
| E488_CHESSN | String | CHESSN identifier | No |
| UID11_StudentDisabilitiesResKey | String | Primary key for disability record | Yes |
| E615_DisabilityCode | String | Type of disability code | Yes |
| E609_EffectiveFromDate | Date | Date disability status became effective | Yes |
| E610_EffectiveToDate | Date | Date disability status ended | No |

## StudentContactsFirstReportedAddress
> Student's first reported residential address.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| Student_Key | Integer | Foreign key to HEPStudents | Yes |
| E313_StudentIdentificationCode | String | Student ID code | Yes |
| E787_FirstResidentialAddressLine1 | String | First reported address line 1 | Yes |
| E789_FirstResidentialAddressSuburb | String | First reported suburb | Yes |
| E791_FirstResidentialAddressState | String | First reported state | Yes |
| E659_FirstResidentialAddressCountryCode | String | First reported country code | Yes |
| E790_FirstResidentialAddressPostcode | String | First reported postcode | Yes |

## AggregatedAwards
> Aggregated course completion and award information.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| UID47_AggregateAwardsResKey | String | Primary key for aggregated awards | Yes |
| Student_Key | Integer | Foreign key to HEPStudents | Yes |
| E313_StudentIdentificationCode | String | Student ID code | Yes |
| UID5_CoursesResKey | String | Foreign key to courses | Yes |
| E307_CourseCode | String | Course code | Yes |
| E534_CourseOfStudyCommencementDate | Date | Course start date | Yes |
| E599_CourseOutcomeCode | String | Course completion outcome code | Yes |
| E591_HDRThesisSubmissionDate | Date | Higher Degree Research thesis submission date | No |
| E592_CourseOutcomeDate | Date | Date of course completion | Yes |
| E329_ModeOfAttendanceCode | String | Mode of attendance | Yes |
| E330_AttendanceTypeCode | String | Full-time/part-time attendance | Yes |

## ExitAwards
> Early exit awards granted to students.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| Student_Key | Integer | Foreign key to HEPStudents | Yes |
| E313_StudentIdentificationCode | String | Student ID code | Yes |
| E781_ProviderType | String | Type of education provider | Yes |
| UID46_EarlyExitAwardsResKey | String | Primary key for exit awards | Yes |
| UID15_CourseAdmissionsResKey | String | Foreign key to course admissions | Yes |
| UID5_CoursesResKey | String | Foreign key to courses | Yes |
| E307_CourseCode | String | Course code | Yes |
| E308_CourseName | String | Course name | Yes |
| E599_CourseOutcomeCode | String | Exit award outcome code | Yes |
| E592_CourseOutcomeDate | Date | Date exit award granted | Yes |

## RTPScholarships
> Research Training Program (RTP) scholarship information.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| Student_Key | Integer | Foreign key to HEPStudents | Yes |
| UID8_StudentsResKey | String | Student resource key | Yes |
| E313_StudentIdentificationCode | String | Student ID code | Yes |
| E488_CHESSN | String | CHESSN identifier | No |
| UID15_CourseAdmissionsResKey | String | Foreign key to course admissions | Yes |
| UID5_CoursesResKey | String | Foreign key to courses | Yes |
| E307_CourseCode | String | Course code | Yes |
| E308_CourseName | String | Course name | Yes |
| E533_CourseOfStudyCode | String | Course of study code | Yes |
| E310_CourseOfStudyType | String | Course type | Yes |
| E534_CourseOfStudyCommencementDate | Date | Course start date | Yes |
| UID35_RTPScholarshipsResKey | String | Primary key for RTP scholarship | Yes |
| E487_RTPScholarshipType | String | Type of RTP scholarship | Yes |
| E609_RTPScholarshipFromDate | Date | Scholarship start date | Yes |
| E610_RTPScholarshipToDate | Date | Scholarship end date | No |

## HEPHDREndUsersEngagement
> Higher Degree Research (HDR) end-user engagement records.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| UID8_StudentsResKey | String | Student resource key | Yes |
| Student_Key | Integer | Foreign key to HEPStudents | Yes |
| E313_StudentIdentificationCode | String | Student ID code | Yes |
| E488_CHESSN | String | CHESSN identifier | No |
| UID15_CourseAdmissionsResKey | String | Foreign key to course admissions | Yes |
| UID5_CoursesResKey | String | Foreign key to courses | Yes |
| E307_CourseCode | String | Course code | Yes |
| E308_CourseName | String | Course name | Yes |
| E533_CourseOfStudyCode | String | Course of study code | Yes |
| E310_CourseOfStudyType | String | Course type | Yes |
| E534_CourseOfStudyCommencementDate | Date | Course start date | Yes |
| UID37_HDREndUserEngagementsResKey | String | Primary key for HDR engagement | Yes |
| E593_HDREndUserEngagementCode | String | Type of end-user engagement | Yes |
| E609_HDREndUserEngageFromDate | Date | Engagement start date | Yes |
| E610_HDREndUserEngageToDate | Date | Engagement end date | No |
| E798_HDRDaysOfEngagement | Integer | Number of engagement days | Yes |

## HEPCourses
> Course information master table.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| UID3_CoursesOfStudyResKey | String | Foreign key to courses of study | Yes |
| E533_CourseOfStudyCode | String | Course of study code | Yes |
| E394_CourseOfStudyName | String | Course of study name | Yes |
| UID5_CoursesResKey | String | Primary key for courses | Yes |
| E307_CourseCode | String | Course code | Yes |
| E308_CourseName | String | Course name | Yes |
| E596_StandardCourseDuration | Decimal | Standard duration in years | Yes |
| E609_EffectiveFromDate | Date | Course effective from date | Yes |
| E610_EffectiveToDate | Date | Course effective to date | No |

## CoursesOfStudy
> Courses of study reference table.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| UID3_CoursesOfStudyResKey | String | Primary key for courses of study | Yes |
| E533_CourseOfStudyCode | String | Course of study code | Yes |
| E394_CourseOfStudyName | String | Course of study name | Yes |
| E310_CourseOfStudyType | String | Course type (degree level) | Yes |
| E350_CourseOfStudyLoad | String | Study load (full-time/part-time) | Yes |
| E455_CombinedCourseOfStudyIndicator | String | Combined degree indicator | No |

## CourseFieldsOfEducation
> Field of education classifications for courses.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| UID3_CoursesOfStudyResKey | String | Foreign key to courses of study | Yes |
| E533_CourseOfStudyCode | String | Course of study code | Yes |
| UID5_CoursesResKey | String | Foreign key to courses | Yes |
| E307_CourseCode | String | Course code | Yes |
| E394_CourseOfStudyName | String | Course of study name | Yes |
| UID48_CourseFieldsOfEducationResKey | String | Primary key for field of education | Yes |
| E461_FieldOfEducationCode | String | Primary field of education code | Yes |
| E462_FieldOfEducationSupplementaryCode | String | Supplementary field of education | No |
| E609_EffectiveFromDate | Date | Effective from date | Yes |
| E610_EffectiveToDate | Date | Effective to date | No |

## HEPCourseAdmissions
> Course admission records for students.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| Student_Key | Integer | Foreign key to HEPStudents | Yes |
| E313_StudentIdentificationCode | String | Student ID code | Yes |
| E488_CHESSN | String | CHESSN identifier | No |
| UID5_CoursesResKey | String | Foreign key to courses | Yes |
| UID15_CourseAdmissionsResKey | String | Primary key for course admissions | Yes |
| E307_CourseCode | String | Course code | Yes |
| E308_CourseName | String | Course name | Yes |
| E533_CourseOfStudyCode | String | Course of study code | Yes |
| E310_CourseOfStudyType | String | Course type | Yes |
| E534_CourseOfStudyCommencementDate | Date | Course start date | Yes |
| E330_AttendanceTypeCode | String | Full-time/part-time attendance | Yes |
| E591_HDRThesisSubmissionDate | Date | HDR thesis submission date | No |
| E632_ATAR | Decimal | Australian Tertiary Admission Rank | No |
| E605_SelectionRank | Decimal | Selection rank for admission | No |
| E620_HighestAttainmentCode | String | Highest prior qualification | No |
| E594_HDRPrimaryFieldOfResearchCode | String | Primary research field for HDR | No |
| E595_HDRSecondaryFieldOfResearchCode | String | Secondary research field for HDR | No |

## HEPCoursePriorCredits
> Prior credit/RPL (Recognition of Prior Learning) information.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| UID15_CourseAdmissionsResKey | String | Foreign key to course admissions | Yes |
| E313_StudentIdentificationCode | String | Student ID code | Yes |
| E307_CourseCode | String | Course code | Yes |
| E534_CourseOfStudyCommencementDate | Date | Course start date | Yes |
| UID32_CoursePriorCreditsResKey | String | Primary key for prior credits | Yes |
| E560_CreditUsedValue | Decimal | Amount of credit granted | Yes |
| E561_CreditBasis | String | Basis for credit (RPL type) | Yes |
| E566_CreditProviderCode | String | Provider that granted original credit | No |

## HEPBasisForAdmission
> Basis for student admission to courses.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| UID15_CourseAdmissionsResKey | String | Foreign key to course admissions | Yes |
| E313_StudentIdentificationCode | String | Student ID code | Yes |
| E307_CourseCode | String | Course code | Yes |
| E534_CourseOfStudyCommencementDate | Date | Course start date | Yes |
| UID17_BasisForAdmissionResKey | String | Primary key for basis of admission | Yes |
| E327_BasisForAdmissionCode | String | Admission basis code | Yes |

## CourseSpecialisations
> Course specializations/majors for students.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| UID15_CourseAdmissionsResKey | String | Foreign key to course admissions | Yes |
| E313_StudentIdentificationCode | String | Student ID code | Yes |
| E307_CourseCode | String | Course code | Yes |
| E534_CourseOfStudyCommencementDate | Date | Course start date | Yes |
| UID47_AggregateAwardsResKey | String | Foreign key to aggregate awards | No |
| UID33_CourseSpecialisationsResKey | String | Primary key for specializations | Yes |
| E463_SpecialisationCode | String | Specialization/major code | Yes |

## Campuses
> Campus location information.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| UID2_CampusesResKey | String | Primary key for campus | Yes |
| E525_CampusSuburb | String | Campus suburb/location name | Yes |
| E644_CampusCountryCode | String | Campus country code | Yes |
| E559_CampusPostcode | String | Campus postcode | Yes |
| E569_CampusOperationType | String | Type of campus operation | Yes |

## HEPCoursesOnCampuses
> Courses offered at specific campuses.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| UID2_CampusesResKey | String | Foreign key to campuses | Yes |
| E525_CampusSuburb | String | Campus suburb | Yes |
| E644_CampusCountryCode | String | Campus country code | Yes |
| E559_CampusPostcode | String | Campus postcode | Yes |
| Campuses_E609_EffectiveFromDate | Date | Campus effective from date | Yes |
| Campuses_E610_EffectiveToDate | Date | Campus effective to date | No |
| UID4_CoursesOnCampusResKey | String | Primary key for course-campus link | Yes |
| UID5_CoursesResKey | String | Foreign key to courses | Yes |
| E307_CourseCode | String | Course code | Yes |
| E597_CRICOSCode | String | CRICOS code for international students | No |
| E569_CampusOperationType | String | Campus operation type | Yes |
| E570_PrincipalOffshoreDeliveryMode | String | Offshore delivery mode | No |
| E571_OffshoreDeliveryCode | String | Offshore delivery code | No |
| E609_EffectiveFromDate | Date | Effective from date | Yes |
| E610_EffectiveToDate | Date | Effective to date | No |

## CampusCourseFeesITSP
> Course fees information by campus.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| UID31_CampusCourseFeesResKey | String | Primary key for course fees | Yes |
| UID4_CoursesOnCampusResKey | String | Foreign key to courses on campus | Yes |
| E525_CampusSuburb | String | Campus suburb | Yes |
| E644_CampusCountryCode | String | Campus country code | Yes |
| E559_CampusPostcode | String | Campus postcode | Yes |
| Campuses_E609_EffectiveFromDate | Date | Campus effective from date | Yes |
| UID5_CoursesResKey | String | Foreign key to courses | Yes |
| E307_CourseCode | String | Course code | Yes |
| E536_CourseFeesCode | String | Fee structure code | Yes |
| E495_IndicativeStudentContributionCSP | Decimal | Indicative CSP student contribution | No |
| E496_IndicativeTuitionFeeDomesticFP | Decimal | Indicative domestic fee-paying amount | No |
| E609_EffectiveFromDate | Date | Fee effective from date | Yes |

## CampusesTAC
> Tertiary Admissions Centre (TAC) course offerings.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| UID40_CoursesOnCampusTACResKey | String | Primary key for TAC offerings | Yes |
| UID4_CoursesOnCampusResKey | String | Foreign key to courses on campus | Yes |
| E557_TACOfferCode | String | TAC offer code | Yes |

## SpecialInterestCourses
> Special interest or specialized course categories.

| Field Name | Data Type | Description | Required |
| :--- | :--- | :--- | :--- |
| UID3_CoursesOfStudyResKey | String | Foreign key to courses of study | Yes |
| E533_CourseOfStudyCode | String | Course of study code | Yes |
| E394_CourseOfStudyName | String | Course of study name | Yes |
| UID5_CoursesResKey | String | Foreign key to courses | Yes |
| E307_CourseCode | String | Course code | Yes |
| E308_CourseName | String | Course name | Yes |
| UID30_SpecialInterestCoursesResKey | String | Primary key for special interest courses | Yes |
| E312_SpecialCourseType | String | Type of special course | Yes |
| E609_EffectiveFromDate | Date | Effective from date | Yes |
| E610_EffectiveToDate | Date | Effective to date | No |

# Key Terminology
* **AOU**: Area of Study Unit
* **ATAR**: Australian Tertiary Admission Rank
* **ATSI**: Aboriginal and Torres Strait Islander
* **CHESSN**: Commonwealth Higher Education Student Support Number
* **CRICOS**: Commonwealth Register of Institutions and Courses for Overseas Students
* **CSP**: Commonwealth Supported Place
* **EFTSL**: Equivalent Full-Time Student Load
* **HDR**: Higher Degree by Research (Masters/PhD research programs)
* **HELP**: Higher Education Loan Program (includes HECS-HELP, FEE-HELP, SA-HELP, OS-HELP)
* **HEP**: Higher Education Provider
* **RPL**: Recognition of Prior Learning
* **RTP**: Research Training Program - government scholarship scheme
* **TAC**: Tertiary Admissions Centre
* **TCSI**: Tertiary Collection of Student Information - Australian government data collection system
* **USI**: Unique Student Identifier - lifelong education number for Australian students
