# Field Mappings Configuration
# TCSI ETL Project - Complete Database Schema
# 
# This file defines the mappings between CSV columns and database fields
# for all 28 TCSI tables, extracted from mapping CSV files.
#
# New Features:
# - override_enabled: Boolean flag to control whether existing records can be updated
# - override_check_fields: Fields to check for duplicate records before insert/update

# ==========================================
# VALIDATION CONSTRAINTS (from schema)
# ==========================================

# CHECK constraints from database schema
VALID_GENDER_CODES <- c('M', 'F', 'X')
VALID_ATSI_CODES <- c('2', '3', '4', '5', '9')
VALID_CITIZEN_RESIDENT_CODES <- c('1', '2', '3', '4', '5', '8', 'P')
VALID_DISABILITY_CODES <- c('11','12','13','14','15','16','17','18','19','20','99')
VALID_COURSE_OUTCOME_CODES <- c('1','2','3','4','5','6','7')
VALID_MODE_OF_ATTENDANCE_CODES <- c('1','2','3','4','5','6','7')
VALID_ATTENDANCE_TYPE_CODES <- c('1','2')
VALID_COMMONWEALTH_SCHOLARSHIP_TYPES <- c('A','B','C')
VALID_COMMONWEALTH_SCHOLARSHIP_STATUS_CODES <- c('1','2','3','7')
VALID_UNIT_STUDY_STATUS_CODES <- c('1','2','3','4','5','6')
VALID_MAX_STUDENT_CONTRIBUTION_CODES <- c('7','8','9','S')
VALID_COURSE_OF_STUDY_TYPE <- c(
            '1','2','3','4','5','6','7','8','9',
            '01','02','03','04','05','06','07','08','09','10','11','12','13','14',
            '20','21','22','23','30','41','42','50','51','52','60','61','80','81')
VALID_SPECIAL_COURSE_TYPE <- c('21','22','23','25','26','27','28')
VALID_CAMPUS_OPERATION_TYPE <- c('01','02','1','2')
VALID_PRINCIPAL_OFFSHORE_DELIVERY_MODE <- c('01','02','03', '04','1','2','3','4')
VALID_OFFSHORE_DELIVERY_CODE <- c('01','02','1','2')
VALID_COURSE_FEES_CODE <- c('0','1','2','3')
VALID_BASIS_FOR_ADMISSION_CODE <- c('31','32','34','40','41','42','43')
VALID_CREDIT_BASIS <- c('0100','0200','0300','0400','0500','0600',
        '100','200','300','400','500','600')
VALID_HDR_END_USER_ENGAGEMENT_CODE <- c('03','07','08', '3','7','8')
VALID_RTP_SCHOLARSHIP_TYPE <- c('9','09','10','11')
VALID_LOAN_STATUS <- c(
        'ACCPEND','ADJPEND','REJECTPEND','ACCEPTED','ADJUSTED',
        'COMMITTED','ADJCOMMITTED','REMITREC','REVERSREC',
        'ACCTRANS','ADJTRANS','INVALIDTRANS','REVERSETRANS','REMITTTRANS',
        'VETAPPROVED','DELETED','VETREJECTED','REMISSION','REVERSED',
        'REMITTED','REJECTED','INVALIDATED'
    )
VALID_OS_STUDENT_STATUS_CODE <- c('240', '241', '242')
VALID_SA_STUDENT_STATUS_CODE <- c('280', '281')
VALID_INVALIDATED_FLAG <- c('Y', 'N')

# ==========================================
# TABLE: hep_students
# ==========================================

HEP_STUDENTS_MAPPING <- list(
  primary_key = "student_id",
  csv_to_db = list(
    "UID8_StudentsResKey" = "uid8_students_res_key",
    "E313_StudentIdentificationCode" = "e313_student_identification_code",
    "E488_CHESSN" = "e488_chessn",
    "E584_USI" = "e584_usi",
    "A170_USIVerificationStatus" = "a170_usi_verification_status",
    "A167_TFNVerificationStatus" = "a167_tfn_verification_status",
    "E314_DateOfBirth" = "e314_date_of_birth",
    "E402_StudentFamilyName" = "e402_student_family_name",
    "E403_StudentGivenNameFirst" = "e403_student_given_name_first",
    "E404_StudentGivenNameOthers" = "e404_student_given_name_others",
    "E410_ResidentialAddressLine1" = "e410_residential_address_line1",
    "E469_ResidentialAddressSuburb" = "e469_residential_address_suburb",
    "E320_ResidentialAddressPostcode" = "e320_residential_address_postcode",
    "E470_ResidentialAddressState" = "e470_residential_address_state",
    "E658_ResidentialAddressCountryCode" = "e658_residential_address_country_code",
    "E319_TermResidencePostcode" = "e319_term_residence_postcode",
    "E661_TermResidenceCountryCode" = "e661_term_residence_country_code",
    "E315_GenderCode" = "e315_gender_code",
    "E316_ATSICode" = "e316_atsi_code",
    "E346_CountryOfBirthCode" = "e346_country_of_birth_code",
    "E347_ArrivalInAustraliaYear" = "e347_arrival_in_australia_year",
    "E348_LanguageSpokenAtHomeCode" = "e348_language_spoken_at_home_code",
    "E572_YearLeftSchool" = "e572_year_left_school",
    "E612_LevelLeftSchool" = "e612_level_left_school",
    "E573_HighestEducationParent1" = "e573_highest_education_parent1",
    "E574_HighestEducationParent2" = "e574_highest_education_parent2"
  ),
  
  date_fields = c("e314_date_of_birth"),
  
  integer_fields = c("e347_arrival_in_australia_year", "e572_year_left_school", "e612_level_left_school"),
  
  required_fields = c("uid8_students_res_key", "e313_student_identification_code", "e314_date_of_birth", 
                      "e315_gender_code", "e316_atsi_code", "e346_country_of_birth_code", 
                      "e348_language_spoken_at_home_code"),
  
  validated_fields = list(
    "e315_gender_code" = VALID_GENDER_CODES,
    "e316_atsi_code" = VALID_ATSI_CODES
  ),
  
  override_enabled = FALSE,
  
  override_check_fields = c(
    "uid8_students_res_key",
    "e313_student_identification_code",
    "e488_chessn",
    "e584_usi",
    "a170_usi_verification_status",
    "a167_tfn_verification_status",
    "e314_date_of_birth",
    "e402_student_family_name",
    "e403_student_given_name_first",
    "e404_student_given_name_others",
    "e410_residential_address_line1",
    "e469_residential_address_suburb",
    "e320_residential_address_postcode",
    "e470_residential_address_state",
    "e658_residential_address_country_code",
    "e319_term_residence_postcode",
    "e661_term_residence_country_code",
    "e315_gender_code",
    "e316_atsi_code",
    "e346_country_of_birth_code",
    "e347_arrival_in_australia_year",
    "e348_language_spoken_at_home_code",
    "e572_year_left_school",
    "e612_level_left_school",
    "e573_highest_education_parent1",
    "e574_highest_education_parent2"
  )
)

# ==========================================
# TABLE: hep_student_citizenships
# ==========================================

HEP_STUDENT_CITIZENSHIPS_MAPPING <- list(
  primary_key = "student_citizenship_id",
  csv_to_db = list(
    "UID8_StudentsResKey" = "uid8_students_res_key",
    "UID10_StudentCitizenshipsResKey" = "uid10_student_citizenships_res_key",
    "E358_CitizenResidentCode" = "e358_citizen_resident_code",
    "E609_EffectiveFromDate" = "e609_effective_from_date",
    "E610_EffectiveToDate" = "e610_effective_to_date"
  ),
  
  date_fields = c("e609_effective_from_date", "e610_effective_to_date"),
  
  required_fields = c("uid8_students_res_key", "uid10_student_citizenships_res_key", 
                      "e358_citizen_resident_code", "e609_effective_from_date"),
  
  validated_fields = list(
    "e358_citizen_resident_code" = VALID_CITIZEN_RESIDENT_CODES
  ),
  
  foreign_keys = list(
    list(
      field = "uid8_students_res_key",
      references_table = "hep_students",
      reference_column = "student_id",
      references_field = "uid8_students_res_key"
    )
  ),
  
  override_enabled = FALSE,
  
  override_check_fields = c(
    "uid10_student_citizenships_res_key",
    "e358_citizen_resident_code",
    "e609_effective_from_date",
    "e610_effective_to_date"
  )
)

# ==========================================
# TABLE: hep_student_disabilities
# ==========================================

HEP_STUDENT_DISABILITIES_MAPPING <- list(
  primary_key = "student_disability_id",
  csv_to_db = list(
    "UID8_StudentsResKey" = "uid8_students_res_key",
    "UID11_StudentDisabilitiesResKey" = "uid11_student_disabilities_res_key",
    "E615_DisabilityCode" = "e615_disability_code",
    "E609_EffectiveFromDate" = "e609_effective_from_date",
    "E610_EffectiveToDate" = "e610_effective_to_date"
  ),
  
  date_fields = c("e609_effective_from_date", "e610_effective_to_date"),
  
  required_fields = c("uid8_students_res_key", "uid11_student_disabilities_res_key", 
                      "e615_disability_code", "e609_effective_from_date"),
  
  validated_fields = list(
    "e615_disability_code" = VALID_DISABILITY_CODES
  ),
  
  foreign_keys = list(
    list(
      field = "uid8_students_res_key",
      references_table = "hep_students",
      reference_column = "student_id",
      references_field = "uid8_students_res_key"
    )
  ),
  
  override_enabled = FALSE,
  
  override_check_fields = c(
    "uid11_student_disabilities_res_key",
    "e615_disability_code",
    "e609_effective_from_date",
    "e610_effective_to_date"
  )
)

# ==========================================
# TABLE: student_contacts_first_reported_address
# ==========================================

STUDENT_CONTACTS_FIRST_ADDRESS_MAPPING <- list(
  primary_key = "first_address_id",
  csv_to_db = list(
    "UID8_StudentsResKey" = "uid8_students_res_key",
    "E787_FirstResidentialAddressLine1" = "e787_first_residential_address_line1",
    "E789_FirstResidentialAddressSuburb" = "e789_first_residential_address_suburb",
    "E791_FirstResidentialAddressState" = "e791_first_residential_address_state",
    "E659_FirstResidentialAddressCountryCode" = "e659_first_residential_address_country_code",
    "E790_FirstResidentialAddressPostcode" = "e790_first_residential_address_postcode"
  ),
  
  date_fields = c(),
  
  required_fields = c("uid8_students_res_key"),
  
  validated_fields = list(),
  
  foreign_keys = list(
    list(
      field = "uid8_students_res_key",
      references_table = "hep_students",
      reference_column = "student_id",
      references_field = "uid8_students_res_key"
    )
  ),

  override_enabled = TRUE,

  override_check_fields = c(
    "e787_first_residential_address_line1",
    "e789_first_residential_address_suburb",
    "e791_first_residential_address_state",
    "e659_first_residential_address_country_code",
    "e790_first_residential_address_postcode"
  )
)

# ==========================================
# TABLE: commonwealth_scholarships
# ==========================================

COMMONWEALTH_SCHOLARSHIPS_MAPPING <- list(
  primary_key = "uid12_student_commonwealth_scholarships_res_key",
  csv_to_db = list(
    "UID8_StudentsResKey" = "uid8_students_res_key",
    "UID12_StudentCommonwealthScholarshipsResKey" = "uid12_student_commonwealth_scholarships_res_key",
    "E415_ReportingYear" = "e415_reporting_year",
    "E666_ReportingPeriod" = "e666_reporting_period",
    "E545_CommonwealthScholarshipType" = "e545_commonwealth_scholarship_type",
    "E526_CommonwealthScholarshipStatusCode" = "e526_commonwealth_scholarship_status_code",
    "E598_CommonwealthScholarshipAmount" = "e598_commonwealth_scholarship_amount",
    "E538_CommonwealthScholarshipTerminationReasonCode" = "e538_commonwealth_scholarship_termination_reason_code"
  ),
  
  date_fields = c(),
  
  integer_fields = c("e415_reporting_year", "e666_reporting_period", "e526_commonwealth_scholarship_status_code"),
  
  decimal_fields = c("e598_commonwealth_scholarship_amount"),
  
  required_fields = c("uid12_student_commonwealth_scholarships_res_key", "uid8_students_res_key",
                      "e415_reporting_year", "e545_commonwealth_scholarship_type", 
                      "e526_commonwealth_scholarship_status_code"),
  
  validated_fields = list(
    "e545_commonwealth_scholarship_type" = VALID_COMMONWEALTH_SCHOLARSHIP_TYPES,
    "e526_commonwealth_scholarship_status_code" = VALID_COMMONWEALTH_SCHOLARSHIP_STATUS_CODES
  ),
  
  foreign_keys = list(
    list(
      field = "uid8_students_res_key",
      references_table = "hep_students",
      reference_column = "student_id",
      references_field = "uid8_students_res_key"
    )
  ),
  
  override_enabled = TRUE,
  
  override_check_fields = c()
)

# ==========================================
# TABLE: courses_of_study
# ==========================================

COURSES_OF_STUDY_MAPPING <- list(
  primary_key = "uid3_courses_of_study_res_key",
  csv_to_db = list(
    "UID3_CoursesOfStudyResKey" = "uid3_courses_of_study_res_key",
    "E533_CourseOfStudyCode" = "e533_course_of_study_code",
    "E394_CourseOfStudyName" = "e394_course_of_study_name",
    "E310_CourseOfStudyType" = "e310_course_of_study_type",
    "E350_CourseOfStudyLoad" = "e350_course_of_study_load",
    "E455_CombinedCourseOfStudyIndicator" = "e455_combined_course_of_study_indicator"
  ),
  
  date_fields = c(),
  
  decimal_fields = c("e350_course_of_study_load"),
  
  boolean_fields = c("e455_combined_course_of_study_indicator"),
  
  required_fields = c("uid3_courses_of_study_res_key", "e533_course_of_study_code", 
                      "e394_course_of_study_name", "e310_course_of_study_type", 
                      "e455_combined_course_of_study_indicator"),
  
  validated_fields = list(
    "E310_CourseOfStudyType" = VALID_COURSE_OF_STUDY_TYPE
  ),
  
  override_enabled = TRUE,
  
  override_check_fields = c()
)

# ==========================================
# TABLE: hep_courses
# ==========================================

HEP_COURSES_MAPPING <- list(
  primary_key = "uid5_courses_res_key",
  csv_to_db = list(
    "UID5_CoursesResKey" = "uid5_courses_res_key",
    "UID3_CoursesOfStudyResKey" = "uid3_courses_of_study_res_key",
    "E307_CourseCode" = "e307_course_code",
    "E308_CourseName" = "e308_course_name",
    "E596_StandardCourseDuration" = "e596_standard_course_duration",
    "E609_EffectiveFromDate" = "e609_effective_from_date",
    "E610_EffectiveToDate" = "e610_effective_to_date"
  ),
  
  date_fields = c("e609_effective_from_date", "e610_effective_to_date"),
  
  decimal_fields = c("e596_standard_course_duration"),
  
  required_fields = c("uid5_courses_res_key", "uid3_courses_of_study_res_key", 
                      "e307_course_code", "e308_course_name", "e609_effective_from_date"),
  
  validated_fields = list(),
  
  foreign_keys = list(
    list(
      field = "uid3_courses_of_study_res_key",
      references_table = "courses_of_study",
      reference_column = "uid3_courses_of_study_res_key",
      references_field = "uid3_courses_of_study_res_key"
    )
  ),
  
  override_enabled = TRUE,
  
  override_check_fields = c()
)

# ==========================================
# TABLE: special_interest_courses
# ==========================================

SPECIAL_INTEREST_COURSES_MAPPING <- list(
  primary_key = "uid30_special_interest_courses_res_key",
  csv_to_db = list(
    "UID30_SpecialInterestCoursesResKey" = "uid30_special_interest_courses_res_key",
    "UID5_CoursesResKey" = "uid5_courses_res_key",
    "E312_SpecialCourseType" = "e312_special_course_type",
    "E609_EffectiveFromDate" = "e609_effective_from_date",
    "E610_EffectiveToDate" = "e610_effective_to_date"
  ),
  
  date_fields = c("e609_effective_from_date", "e610_effective_to_date"),
  
  required_fields = c("uid30_special_interest_courses_res_key", "uid5_courses_res_key", 
                      "e312_special_course_type", "e609_effective_from_date"),
  
  validated_fields = list("E312_SpecialCourseType" = VALID_SPECIAL_COURSE_TYPE),
  
  foreign_keys = list(
    list(
      field = "uid5_courses_res_key",
      references_table = "hep_courses",
      reference_column = "uid5_courses_res_key",
      references_field = "uid5_courses_res_key"
    )
  ),
  
  override_enabled = TRUE,
  
  override_check_fields = c()
)

# ==========================================
# TABLE: course_fields_of_education
# ==========================================

COURSE_FIELDS_OF_EDUCATION_MAPPING <- list(
  primary_key = "uid48_course_fields_of_education_res_key",
  csv_to_db = list(
    "UID48_CourseFieldsOfEducationResKey" = "uid48_course_fields_of_education_res_key",
    "UID5_CoursesResKey" = "uid5_courses_res_key",
    "E461_FieldOfEducationCode" = "e461_field_of_education_code",
    "E462_FieldOfEducationSupplementaryCode" = "e462_field_of_education_supplementary_code",
    "E609_EffectiveFromDate" = "e609_effective_from_date",
    "E610_EffectiveToDate" = "e610_effective_to_date"
  ),
  
  date_fields = c("e609_effective_from_date", "e610_effective_to_date"),
  
  required_fields = c("uid48_course_fields_of_education_res_key", "uid5_courses_res_key", 
                      "e461_field_of_education_code", "e609_effective_from_date"),
  
  validated_fields = list(),
  
  foreign_keys = list(
    list(
      field = "uid5_courses_res_key",
      references_table = "hep_courses",
      reference_column = "uid5_courses_res_key",
      references_field = "uid5_courses_res_key"
    )
  ),
  
  override_enabled = TRUE,
  
  override_check_fields = c()
)

# ==========================================
# TABLE: campuses
# ==========================================

CAMPUSES_MAPPING <- list(
  primary_key = "uid2_campuses_res_key",
  csv_to_db = list(
    "UID2_CampusesResKey" = "uid2_campuses_res_key",
    "E525_CampusSuburb" = "e525_campus_suburb",
    "E644_CampusCountryCode" = "e644_campus_country_code",
    "E559_CampusPostcode" = "e559_campus_postcode",
    "Campuses_E609_EffectiveFromDate" = "e609_effective_from_date",
    "Campuses_E610_EffectiveToDate" = "e610_effective_to_date"
  ),
  
  date_fields = c("e609_effective_from_date", "e610_effective_to_date"),
  
  required_fields = c("uid2_campuses_res_key", "e525_campus_suburb", 
                      "e644_campus_country_code", "e609_effective_from_date"),
  
  validated_fields = list(),
  
  override_enabled = TRUE,
  
  override_check_fields = c()
)

# ==========================================
# TABLE: hep_courses_on_campuses
# ==========================================

HEP_COURSES_ON_CAMPUSES_MAPPING <- list(
  primary_key = "uid4_courses_on_campus_res_key",
  csv_to_db = list(
    "UID4_CoursesOnCampusResKey" = "uid4_courses_on_campus_res_key",
    "UID2_CampusesResKey" = "uid2_campuses_res_key",
    "UID5_CoursesResKey" = "uid5_courses_res_key",
    "E597_CRICOSCode" = "e597_cricos_code",
    "E569_CampusOperationType" = "e569_campus_operation_type",
    "E570_PrincipalOffshoreDeliveryMode" = "e570_principal_offshore_delivery_mode",
    "E571_OffshoreDeliveryCode" = "e571_offshore_delivery_code",
    "E609_EffectiveFromDate" = "e609_effective_from_date",
    "E610_EffectiveToDate" = "e610_effective_to_date"
  ),
  
  date_fields = c("e609_effective_from_date", "e610_effective_to_date"),
  
  required_fields = c("uid4_courses_on_campus_res_key", "uid2_campuses_res_key", 
                      "uid5_courses_res_key", "e609_effective_from_date"),
  
  validated_fields = list(
    "e569_campus_operation_type" = VALID_CAMPUS_OPERATION_TYPE,
    "e570_principal_offshore_delivery_mode" = VALID_PRINCIPAL_OFFSHORE_DELIVERY_MODE,
    "e571_offshore_delivery_code" = VALID_OFFSHORE_DELIVERY_CODE
  ),
  
  foreign_keys = list(
    list(
      field = "uid2_campuses_res_key",
      references_table = "campuses",
      reference_column = "uid2_campuses_res_key",
      references_field = "uid2_campuses_res_key"
    ),
    list(
      field = "uid5_courses_res_key",
      references_table = "hep_courses",
      reference_column = "uid5_courses_res_key",
      references_field = "uid5_courses_res_key"
    )
  ),
  
  override_enabled = TRUE,
  
  override_check_fields = c()
)

# ==========================================
# TABLE: campus_course_fees_itsp
# ==========================================

CAMPUS_COURSE_FEES_ITSP_MAPPING <- list(
  primary_key = "uid31_campus_course_fees_res_key",
  csv_to_db = list(
    "UID31_CampusCourseFeesResKey" = "uid31_campus_course_fees_res_key",
    "UID4_CoursesOnCampusResKey" = "uid4_courses_on_campus_res_key",
    "E536_CourseFeesCode" = "e536_course_fees_code",
    "E495_IndicativeStudentContributionCSP" = "e495_indicative_student_contribution_csp",
    "E496_IndicativeTuitionFeeDomesticFP" = "e496_indicative_tuition_fee_domestic_fp",
    "E609_EffectiveFromDate" = "e609_effective_from_date"
  ),
  
  date_fields = c("e609_effective_from_date"),
  
  decimal_fields = c("e496_indicative_tuition_fee_domestic_fp"),
  
  required_fields = c("uid31_campus_course_fees_res_key", "uid4_courses_on_campus_res_key", 
                      "e609_effective_from_date"),
  
  validated_fields = list(
    "e536_course_fees_code" = VALID_COURSE_FEES_CODE
  ),
  
  foreign_keys = list(
    list(
      field = "uid4_courses_on_campus_res_key",
      references_table = "hep_courses_on_campuses",
      reference_column = "uid4_courses_on_campus_res_key",
      references_field = "uid4_courses_on_campus_res_key"
    )
  ),
  
  override_enabled = TRUE,
  
  override_check_fields = c()
)

# ==========================================
# TABLE: campuses_tac
# ==========================================

CAMPUSES_TAC_MAPPING <- list(
  primary_key = "uid40_courses_on_campus_tac_res_key",
  csv_to_db = list(
    "UID40_CoursesOnCampusTACResKey" = "uid40_courses_on_campus_tac_res_key",
    "UID4_CoursesOnCampusResKey" = "uid4_courses_on_campus_res_key",
    "E557_TACOfferCode" = "e557_tac_offer_code"
  ),
  
  date_fields = c(),
  
  required_fields = c("uid40_courses_on_campus_tac_res_key", "uid4_courses_on_campus_res_key"),
  
  validated_fields = list(),
  
  foreign_keys = list(
    list(
      field = "uid4_courses_on_campus_res_key",
      references_table = "hep_courses_on_campuses",
      reference_column = "uid4_courses_on_campus_res_key",
      references_field = "uid4_courses_on_campus_res_key"
    )
  ),
  
  override_enabled = TRUE,
  
  override_check_fields = c()
)

# ==========================================
# TABLE: hep_course_admissions
# ==========================================

HEP_COURSE_ADMISSIONS_MAPPING <- list(
  primary_key = "course_admission_id",
  csv_to_db = list(
    "UID8_StudentsResKey" = "uid8_students_res_key",
    "UID15_CourseAdmissionsResKey" = "uid15_course_admissions_res_key",
    "UID5_CoursesResKey" = "uid5_courses_res_key",
    "E599_CourseOutcomeCode" = "e599_courseoutcomecode",
    "E592_CourseOutcomeDate" = "e592_courseoutcomedate",
    "E534_CourseOfStudyCommencementDate" = "e534_course_of_study_commencement_date",
    "E330_AttendanceTypeCode" = "e330_attendance_type_code",
    "E591_HDRThesisSubmissionDate" = "e591_hdr_thesis_submission_date",
    "E632_ATAR" = "e632_atar",
    "E605_SelectionRank" = "e605_selection_rank",
    "E620_HighestAttainmentCode" = "e620_highest_attainment_code",
    "E594_HDRPrimaryFieldOfResearchCode" = "e594_hdr_primary_field_of_research_code",
    "E595_HDRSecondaryFieldOfResearchCode" = "e595_hdr_secondary_field_of_research_code"
  ),
  
  date_fields = c("e592_courseoutcomedate", "e534_course_of_study_commencement_date", 
                  "e591_hdr_thesis_submission_date"),
  
  decimal_fields = c("e632_atar", "e605_selection_rank"),
  
  required_fields = c("uid8_students_res_key", "uid15_course_admissions_res_key", 
                      "uid5_courses_res_key", "e534_course_of_study_commencement_date"),
  
  validated_fields = list(
    "e599_courseoutcomecode" = VALID_COURSE_OUTCOME_CODES,
    "e330_attendance_type_code" = VALID_ATTENDANCE_TYPE_CODES
  ),
  
  foreign_keys = list(
    list(
      field = "uid8_students_res_key",
      references_table = "hep_students",
      reference_column = "student_id",
      references_field = "uid8_students_res_key"
    ),
    list(
      field = "uid5_courses_res_key",
      references_table = "hep_courses",
      reference_column = "uid5_courses_res_key",
      references_field = "uid5_courses_res_key"
    )
  ),
  
  override_enabled = FALSE,
  
  override_check_fields = c(
    "uid15_course_admissions_res_key",
    "uid5_courses_res_key",
    "e599_courseoutcomecode",
    "e592_courseoutcomedate",
    "e534_course_of_study_commencement_date",
    "e330_attendance_type_code",
    "e591_hdr_thesis_submission_date",
    "e632_atar",
    "e605_selection_rank",
    "e620_highest_attainment_code",
    "e594_hdr_primary_field_of_research_code",
    "e595_hdr_secondary_field_of_research_code"
  )
)

# ==========================================
# TABLE: hep_basis_for_admission
# ==========================================

HEP_BASIS_FOR_ADMISSION_MAPPING <- list(
  primary_key = "uid17_basis_for_admission_res_key",
  csv_to_db = list(
    "UID17_BasisForAdmissionResKey" = "uid17_basis_for_admission_res_key",
    "UID15_CourseAdmissionsResKey" = "uid15_course_admissions_res_key",  # Will be resolved to course_admission_id
    "E327_BasisForAdmissionCode" = "e327_basis_for_admission_code"
  ),

  date_fields = c(),

  required_fields = c("uid17_basis_for_admission_res_key", "course_admission_id",
                      "e327_basis_for_admission_code"),

  validated_fields = list(
    "e327_basis_for_admission_code" = VALID_BASIS_FOR_ADMISSION_CODE
  ),

  foreign_keys = list(
    list(
      field = "uid15_course_admissions_res_key",
      references_table = "hep_course_admissions",
      reference_column = "course_admission_id",
      references_field = "uid15_course_admissions_res_key",
      target_field = "course_admission_id"  # Map to this field in target table
    )
  ),

  override_enabled = TRUE,

  override_check_fields = c()
)

# ==========================================
# TABLE: hep_course_prior_credits
# ==========================================

HEP_COURSE_PRIOR_CREDITS_MAPPING <- list(
  primary_key = "uid32_course_prior_credits_res_key",
  csv_to_db = list(
    "UID32_CoursePriorCreditsResKey" = "uid32_course_prior_credits_res_key",
    "UID15_CourseAdmissionsResKey" = "uid15_course_admissions_res_key",
    "E560_CreditUsedValue" = "e560_credit_used_value",
    "E561_CreditBasis" = "e561_credit_basis",
    "E566_CreditProviderCode" = "e566_credit_provider_code"
  ),
  
  date_fields = c(),
  
  decimal_fields = c("e560_credit_used_value"),
  
  required_fields = c("uid32_course_prior_credits_res_key"),

  validated_fields = list(
    "e561_credit_basis" = VALID_CREDIT_BASIS
  ),

  foreign_keys = list(
    list(
      field = "uid15_course_admissions_res_key",
      references_table = "hep_course_admissions",
      reference_column = "course_admission_id",
      references_field = "uid15_course_admissions_res_key"
    )
  ),
  
  override_enabled = TRUE,
  
  override_check_fields = c()
)

# ==========================================
# TABLE: course_specialisations
# ==========================================

COURSE_SPECIALISATIONS_MAPPING <- list(
  primary_key = "uid33_course_specialisations_res_key",
  csv_to_db = list(
    "UID33_CourseSpecialisationsResKey" = "uid33_course_specialisations_res_key",
    "UID15_CourseAdmissionsResKey" = "uid15_course_admissions_res_key",
    "E463_SpecialisationCode" = "e463_specialisation_code"
  ),
  
  date_fields = c(),
  
  required_fields = c("uid33_course_specialisations_res_key", "e463_specialisation_code"),
  
  validated_fields = list(),
  
  foreign_keys = list(
    list(
      field = "uid15_course_admissions_res_key",
      references_table = "hep_course_admissions",
      reference_column = "course_admission_id",
      references_field = "uid15_course_admissions_res_key"
    )
  ),
  
  override_enabled = TRUE,
  
  override_check_fields = c()
)

# ==========================================
# TABLE: hep_hdr_end_users_engagement
# ==========================================

HEP_HDR_END_USERS_ENGAGEMENT_MAPPING <- list(
  primary_key = "uid37_hdr_end_user_engagements_res_key",
  csv_to_db = list(
    "UID37_HDREndUserEngagementsResKey" = "uid37_hdr_end_user_engagements_res_key",
    "UID15_CourseAdmissionsResKey" = "uid15_course_admissions_res_key",
    "E593_HDREndUserEngagementCode" = "e593_hdr_end_user_engagement_code",
    "E609_HDREndUserEngageFromDate" = "e609_hdr_end_user_engage_from_date",
    "E610_HDREndUserEngageToDate" = "e610_hdr_end_user_engage_to_date",
    "E798_HDRDaysOfEngagement" = "e798_hdr_days_of_engagement"
  ),
  
  date_fields = c("e609_hdr_end_user_engage_from_date", "e610_hdr_end_user_engage_to_date"),
  
  required_fields = c("uid37_hdr_end_user_engagements_res_key", "e609_hdr_end_user_engage_from_date"),
  
  validated_fields = list(
    "e593_hdr_end_user_engagement_code" = VALID_HDR_END_USER_ENGAGEMENT_CODE
  ),
  
  foreign_keys = list(
    list(
      field = "uid15_course_admissions_res_key",
      references_table = "hep_course_admissions",
      reference_column = "course_admission_id",
      references_field = "uid15_course_admissions_res_key"
    )
  ),
  
  override_enabled = TRUE,
  
  override_check_fields = c()
)

# ==========================================
# TABLE: rtp_scholarships
# ==========================================

RTP_SCHOLARSHIPS_MAPPING <- list(
  primary_key = "uid35_rtp_scholarships_res_key",
  csv_to_db = list(
    "UID35_RTPScholarshipsResKey" = "uid35_rtp_scholarships_res_key",
    "UID15_CourseAdmissionsResKey" = "uid15_course_admissions_res_key",
    "E487_RTPScholarshipType" = "e487_rtp_scholarship_type",
    "E609_RTPScholarshipFromDate" = "e609_rtp_scholarship_from_date",
    "E610_RTPScholarshipToDate" = "e610_rtp_scholarship_to_date"
  ),
  
  date_fields = c("e609_rtp_scholarship_from_date", "e610_rtp_scholarship_to_date"),
  
  required_fields = c("uid35_rtp_scholarships_res_key",
                      "e487_rtp_scholarship_type", "e609_rtp_scholarship_from_date"),
  
  validated_fields = list(
    "e487_rtp_scholarship_type" = VALID_RTP_SCHOLARSHIP_TYPE
  ),
  
  foreign_keys = list(
    list(
      field = "uid15_course_admissions_res_key",
      references_table = "hep_course_admissions",
      reference_column = "course_admission_id",
      references_field = "uid15_course_admissions_res_key"
    )
  ),
  
  override_enabled = TRUE,
  
  override_check_fields = c()
)

# ==========================================
# TABLE: rtp_stipend
# ==========================================

RTP_STIPEND_MAPPING <- list(
  primary_key = "uid18_rtp_stipends_res_key",
  csv_to_db = list(
    "UID18_RTPStipendsResKey" = "uid18_rtp_stipends_res_key",
    "UID15_CourseAdmissionsResKey" = "uid15_course_admissions_res_key",
    "E623_RTPStipendAmount" = "e623_rtp_stipend_amount",
    "E415_ReportingYear" = "e415_reporting_year"
  ),
  
  date_fields = c(),
  
  integer_fields = c("e415_reporting_year"),
  
  decimal_fields = c("e623_rtp_stipend_amount"),
  
  required_fields = c("uid18_rtp_stipends_res_key"),
  
  validated_fields = list(),
  
  foreign_keys = list(
    list(
      field = "uid15_course_admissions_res_key",
      references_table = "hep_course_admissions",
      reference_column = "course_admission_id",
      references_field = "uid15_course_admissions_res_key"
    )
  ),
  
  override_enabled = TRUE,
  
  override_check_fields = c()
)

# ==========================================
# TABLE: oshelp
# ==========================================

OSHELP_MAPPING <- list(
  primary_key = "oshelp_id",
  csv_to_db = list(
    "UID21_StudentLoansResKey" = "uid21_student_loans_res_key",
    "UID15_CourseAdmissionsResKey" = "uid15_course_admissions_res_key",
    "E527_HELPDebtIncurralDate" = "e527_help_debt_incurral_date",
    "E490_StudentStatusCode" = "e490_student_status_code",
    "E521_OSHELPStudyPeriodCommencementDate" = "e521_study_period_commencement_date",
    "E553_OSHELPStudyPrimaryCountryCode" = "e553_study_primary_country_code",
    "E554_OSHELPStudySecondaryCountryCode" = "e554_study_secondary_country_code",
    "E583_OSHELPLanguageStudyCommencementDate" = "e583_language_study_commencement_date",
    "E582_OSHELPLanguageCode" = "e582_language_code",
    "E528_OSHELPPaymentAmount" = "e528_payment_amount",
    "E529_LoanFee" = "e529_loan_fee",
    "A130_LoanStatus" = "a130_loan_status",
    "Invalidated_Flag" = "invalidated_flag"
  ),
  
  date_fields = c("e527_help_debt_incurral_date", "e521_study_period_commencement_date", 
                  "e583_language_study_commencement_date"),
  
  decimal_fields = c("e528_payment_amount", "e529_loan_fee"),
  
  required_fields = c("uid21_student_loans_res_key",
                      "e527_help_debt_incurral_date", "e490_student_status_code", 
                      "e521_study_period_commencement_date", "e528_payment_amount", "e529_loan_fee"),
  
  validated_fields = list(
    "e490_student_status_code" = VALID_OS_STUDENT_STATUS_CODE,
    "a130_loan_status" = VALID_LOAN_STATUS,
    "invalidated_flag" = VALID_INVALIDATED_FLAG
  ),
  
  foreign_keys = list(
    list(
      field = "uid15_course_admissions_res_key",
      references_table = "hep_course_admissions",
      reference_column = "course_admission_id",
      references_field = "uid15_course_admissions_res_key"
    )
  ),
  
  override_enabled = FALSE,
  
  override_check_fields = c(
    "uid21_student_loans_res_key",
    "e527_help_debt_incurral_date",
    "e490_student_status_code",
    "e521_study_period_commencement_date",
    "e553_study_primary_country_code",
    "e554_study_secondary_country_code",
    "e583_language_study_commencement_date",
    "e582_language_code",
    "e528_payment_amount",
    "e529_loan_fee",
    "a130_loan_status",
    "invalidated_flag"
  )
)

# ==========================================
# TABLE: sahelp
# ==========================================

SAHELP_MAPPING <- list(
  primary_key = "sahelp_id",
  csv_to_db = list(
    "UID21_StudentLoansResKey" = "uid21_student_loans_res_key",
    "UID8_StudentsResKey" = "uid8_students_res_key",
    "E527_HELPDebtIncurralDate" = "e527_help_debt_incurral_date",
    "E490_StudentStatusCode" = "e490_student_status_code",
    "E384_AmountCharged" = "e384_amount_charged",
    "E381_AmountPaidUpfront" = "e381_amount_paid_upfront",
    "E558_HELPLoanAmount" = "e558_help_loan_amount",
    "A130_LoanStatus" = "a130_loan_status",
    "Invalidated_Flag" = "invalidated_flag"
  ),
  
  date_fields = c("e527_help_debt_incurral_date"),
  
  decimal_fields = c("e384_amount_charged", "e381_amount_paid_upfront", "e558_help_loan_amount"),
  
  required_fields = c("uid21_student_loans_res_key",
                      "e527_help_debt_incurral_date", "e490_student_status_code", 
                      "e384_amount_charged", "e381_amount_paid_upfront", 
                      "e558_help_loan_amount", "a130_loan_status"),
  
  validated_fields = list(
    "e490_student_status_code" = VALID_SA_STUDENT_STATUS_CODE,
    "a130_loan_status" = VALID_LOAN_STATUS,
    "invalidated_flag" = VALID_INVALIDATED_FLAG
  ),
  
  foreign_keys = list(
    list(
      field = "uid8_students_res_key",
      references_table = "hep_students",
      reference_column = "student_id",
      references_field = "uid8_students_res_key"
    )
  ),
  
  override_enabled = FALSE,
  
  override_check_fields = c(
    "uid21_student_loans_res_key",
    "e527_help_debt_incurral_date",
    "e490_student_status_code",
    "e384_amount_charged",
    "e381_amount_paid_upfront",
    "e558_help_loan_amount",
    "a130_loan_status",
    "invalidated_flag"
  )
)

# ==========================================
# TABLE: aggregated_awards
# ==========================================

AGGREGATED_AWARDS_MAPPING <- list(
  primary_key = "uid47_aggregate_awards_res_key",
  csv_to_db = list(
    "UID47_AggregateAwardsResKey" = "uid47_aggregate_awards_res_key",
    "UID8_StudentsResKey" = "uid8_students_res_key",
    "UID5_CoursesResKey" = "uid5_courses_res_key",
    "E534_CourseOfStudyCommencementDate" = "e534_course_of_study_commencement_date",
    "E599_CourseOutcomeCode" = "e599_course_outcome_code",
    "E591_HDRThesisSubmissionDate" = "e591_hdr_thesis_submission_date",
    "E592_CourseOutcomeDate" = "e592_course_outcome_date",
    "E329_ModeOfAttendanceCode" = "e329_mode_of_attendance_code",
    "E330_AttendanceTypeCode" = "e330_attendance_type_code"
  ),
  
  date_fields = c("e534_course_of_study_commencement_date", "e591_hdr_thesis_submission_date", 
                  "e592_course_outcome_date"),
  
  required_fields = c("uid47_aggregate_awards_res_key", "uid5_courses_res_key"),
  
  validated_fields = list(
    "e599_course_outcome_code" = VALID_COURSE_OUTCOME_CODES,
    "e329_mode_of_attendance_code" = VALID_MODE_OF_ATTENDANCE_CODES,
    "e330_attendance_type_code" = VALID_ATTENDANCE_TYPE_CODES
  ),
  
  foreign_keys = list(
    list(
      field = "uid8_students_res_key",
      references_table = "hep_students",
      reference_column = "student_id",
      references_field = "uid8_students_res_key"
    ),
    list(
      field = "uid5_courses_res_key",
      references_table = "hep_courses",
      reference_column = "uid5_courses_res_key",
      references_field = "uid5_courses_res_key"
    )
  ),
  
  override_enabled = TRUE,
  
  override_check_fields = c()
)

# ==========================================
# TABLE: exit_awards
# ==========================================

EXIT_AWARDS_MAPPING <- list(
  primary_key = "uid46_early_exit_awards_res_key",
  csv_to_db = list(
    "UID46_EarlyExitAwardsResKey" = "uid46_early_exit_awards_res_key",
    "UID15_CourseAdmissionsResKey" = "uid15_course_admissions_res_key",
    "UID5_CoursesResKey" = "uid5_courses_res_key",
    "E599_CourseOutcomeCode" = "e599_course_outcome_code",
    "E592_CourseOutcomeDate" = "e592_course_outcome_date"
  ),
  
  date_fields = c("e592_course_outcome_date"),
  
  required_fields = c("uid46_early_exit_awards_res_key",
                      "uid5_courses_res_key"),
  
  validated_fields = list(
    "e599_course_outcome_code" = VALID_COURSE_OUTCOME_CODES
  ),
  
  foreign_keys = list(
    list(
      field = "uid15_course_admissions_res_key",
      references_table = "hep_course_admissions",
      reference_column = "course_admission_id",
      references_field = "uid15_course_admissions_res_key"
    ),
    list(
      field = "uid5_courses_res_key",
      references_table = "hep_courses",
      reference_column = "uid5_courses_res_key",
      references_field = "uid5_courses_res_key"
    )
  ),
  
  override_enabled = TRUE,
  
  override_check_fields = c()
)

# ==========================================
# TABLE: unit_enrolments
# ==========================================

UNIT_ENROLMENTS_MAPPING <- list(
  primary_key = "unit_enrolment_id",
  csv_to_db = list(
    "UID15_CourseAdmissionsResKey" = "uid15_course_admissions_res_key",
    "UID16_UnitEnrolmentsResKey" = "uid16_unit_enrolments_res_key",
    "E354_UnitOfStudyCode" = "e354_unit_of_study_code",
    "E489_UnitOfStudyCensusDate" = "e489_unit_of_study_census_date",
    "E337_WorkExperienceInIndustryCode" = "e337_work_experience_in_industry_code",
    "E551_SummerWinterSchoolCode" = "e551_summer_winter_school_code",
    "E464_DisciplineCode" = "e464_discipline_code",
    "E355_UnitOfStudyStatusCode" = "e355_unit_of_study_status_code",
    "E329_ModeOfAttendanceCode" = "e329_mode_of_attendance_code",
    "E477_DeliveryLocationPostcode" = "e477_delivery_location_postcode",
    "E660_DeliveryLocationCountryCode" = "e660_delivery_location_country_code",
    "E490_StudentStatusCode" = "e490_student_status_code",
    "E392_MaximumStudentContributionCode" = "e392_maximum_student_contribution_code",
    "E622_UnitOfStudyYearLongIndicator" = "e622_unitofstudyyearlongindicator",
    "E600_UnitOfStudyCommencementDate" = "e600_unit_of_study_commencement_date",
    "E601_UnitOfStudyOutcomeDate" = "e601_unit_of_study_outcome_date",
    "UE.A111_IsDeleted" = "a111_is_deleted"
  ),
  
  date_fields = c("e489_unit_of_study_census_date", "e600_unit_of_study_commencement_date", 
                  "e601_unit_of_study_outcome_date"),
  
  integer_fields = c("e477_delivery_location_postcode", "reporting_year"),

  boolean_fields = c("e622_unitofstudyyearlongindicator", "a111_is_deleted"),

  required_fields = c("uid16_unit_enrolments_res_key", "reporting_year"),
  
  validated_fields = list(
    "e355_unit_of_study_status_code" = VALID_UNIT_STUDY_STATUS_CODES,
    "e329_mode_of_attendance_code" = VALID_MODE_OF_ATTENDANCE_CODES,
    "e392_maximum_student_contribution_code" = VALID_MAX_STUDENT_CONTRIBUTION_CODES
  ),
  
  foreign_keys = list(
    list(
      field = "uid15_course_admissions_res_key",
      references_table = "hep_course_admissions",
      reference_column = "course_admission_id",
      references_field = "uid15_course_admissions_res_key"
    )
  ),
  
  override_enabled = FALSE,
  
  override_check_fields = c(
    "uid16_unit_enrolments_res_key",
    "e354_unit_of_study_code",
    "e489_unit_of_study_census_date",
    "e337_work_experience_in_industry_code",
    "e551_summer_winter_school_code",
    "e464_discipline_code",
    "e355_unit_of_study_status_code",
    "e329_mode_of_attendance_code",
    "e477_delivery_location_postcode",
    "e660_delivery_location_country_code",
    "e490_student_status_code",
    "e392_maximum_student_contribution_code",
    "e622_unitofstudyyearlongindicator",
    "e600_unit_of_study_commencement_date",
    "e601_unit_of_study_outcome_date",
    "a111_is_deleted",
    "reporting_year"
  )
)

# ==========================================
# TABLE: unit_enrolments_aous
# ==========================================

UNIT_ENROLMENTS_AOUS_MAPPING <- list(
  primary_key = "aou_id",
  csv_to_db = list(
    "UID16_UnitEnrolmentsResKey" = "uid16_unit_enrolments_res_key",
    "UID19_UnitEnrolmentAOUsResKey" = "uid19_unit_enrolment_aous_res_key",
    "E333_AOUCode" = "e333_aou_code",
    "AOU.E339_EFTSL" = "aou_e339_eftsl",
    "AOU.E384_AmountCharged" = "aou_e384_amount_charged",
    "AOU.E381_AmountPaidUpfront" = "aou_e381_amount_paid_upfront",
    "AOU.E529_LoanFee" = "aou_e529_loan_fee",
    "AOU.IsDeleted" = "aou_is_deleted"
  ),
  
  date_fields = c(),
  
  integer_fields = c("reporting_year"),
  
  decimal_fields = c("aou_e339_eftsl", "aou_e384_amount_charged", 
    "aou_e381_amount_paid_upfront", "aou_e529_loan_fee"),
  
  boolean_fields = c("aou_is_deleted"),
  
  required_fields = c("uid19_unit_enrolment_aous_res_key", "reporting_year"),
  
  validated_fields = list(),
  
  foreign_keys = list(
    list(
      field = "uid16_unit_enrolments_res_key",
      references_table = "unit_enrolments",
      reference_column = "unit_enrolment_id",
      references_field = "uid16_unit_enrolments_res_key"
    )
  ),
  
  override_enabled = FALSE,
  
  override_check_fields = c(
    "uid19_unit_enrolment_aous_res_key",
    "e333_aou_code",
    "aou_e339_eftsl",
    "aou_e384_amount_charged",
    "aou_e381_amount_paid_upfront",
    "aou_e529_loan_fee",
    "aou_is_deleted",
    "reporting_year"
  )
)

# ==========================================
# HELPER FUNCTIONS
# ==========================================

#' Get override check fields for a table
#'
#' @param table_name Name of the table
#' @param mapping The mapping configuration list for the table
#' @return Vector of field names to check for duplicates, or NULL if none defined
#' @export
get_override_check_fields <- function(table_name, mapping) {
  if (!is.null(mapping$override_check_fields)) {
    return(mapping$override_check_fields)
  }
  return(NULL)
}

#' Check if override is enabled for a table
#'
#' @param table_name Name of the table
#' @param mapping The mapping configuration list for the table
#' @return Boolean indicating if override is enabled
#' @export
is_override_enabled <- function(table_name, mapping) {
  if (!is.null(mapping$override_enabled)) {
    return(mapping$override_enabled)
  }
  return(FALSE)  # Default to FALSE for safety
}

#' Get all table mappings
#'
#' @return Named list of all table mappings
#' @export
get_all_table_mappings <- function() {
  list(
    "hep_students" = HEP_STUDENTS_MAPPING,
    "hep_student_citizenships" = HEP_STUDENT_CITIZENSHIPS_MAPPING,
    "hep_student_disabilities" = HEP_STUDENT_DISABILITIES_MAPPING,
    "student_contacts_first_reported_address" = STUDENT_CONTACTS_FIRST_ADDRESS_MAPPING,
    "commonwealth_scholarships" = COMMONWEALTH_SCHOLARSHIPS_MAPPING,
    "courses_of_study" = COURSES_OF_STUDY_MAPPING,
    "hep_courses" = HEP_COURSES_MAPPING,
    "special_interest_courses" = SPECIAL_INTEREST_COURSES_MAPPING,
    "course_fields_of_education" = COURSE_FIELDS_OF_EDUCATION_MAPPING,
    "campuses" = CAMPUSES_MAPPING,
    "hep_courses_on_campuses" = HEP_COURSES_ON_CAMPUSES_MAPPING,
    "campus_course_fees_itsp" = CAMPUS_COURSE_FEES_ITSP_MAPPING,
    "campuses_tac" = CAMPUSES_TAC_MAPPING,
    "hep_course_admissions" = HEP_COURSE_ADMISSIONS_MAPPING,
    "hep_basis_for_admission" = HEP_BASIS_FOR_ADMISSION_MAPPING,
    "hep_course_prior_credits" = HEP_COURSE_PRIOR_CREDITS_MAPPING,
    "course_specialisations" = COURSE_SPECIALISATIONS_MAPPING,
    "hep_hdr_end_users_engagement" = HEP_HDR_END_USERS_ENGAGEMENT_MAPPING,
    "rtp_scholarships" = RTP_SCHOLARSHIPS_MAPPING,
    "rtp_stipend" = RTP_STIPEND_MAPPING,
    "oshelp" = OSHELP_MAPPING,
    "sahelp" = SAHELP_MAPPING,
    "aggregated_awards" = AGGREGATED_AWARDS_MAPPING,
    "exit_awards" = EXIT_AWARDS_MAPPING,
    "unit_enrolments" = UNIT_ENROLMENTS_MAPPING,
    "unit_enrolments_aous" = UNIT_ENROLMENTS_AOUS_MAPPING
  )
}

#' Check if field is required
#' @param field_name Database field name
#' @param mapping Mapping configuration list
#' @return TRUE if required, FALSE otherwise
is_required_field <- function(field_name, mapping) {
  return(field_name %in% mapping$required_fields)
}

#' Check if field is a date field
#' @param field_name Database field name
#' @param mapping Mapping configuration list
#' @return TRUE if date field, FALSE otherwise
is_date_field <- function(field_name, mapping) {
  return(field_name %in% mapping$date_fields)
}

#' Get validation rules for field
#' @param field_name Database field name
#' @param mapping Mapping configuration list
#' @return Vector of valid values, or NULL if no validation
get_field_validation <- function(field_name, mapping) {
  if (field_name %in% names(mapping$validated_fields)) {
    return(mapping$validated_fields[[field_name]])
  }
  return(NULL)
}

# ==========================================
# SUMMARY
# ==========================================

# Total tables configured: 26
# Tables with override_enabled = FALSE: 9
# 
# Each table includes:
# - csv_to_db: CSV column to database field mappings
# - date_fields: Fields requiring date parsing
# - integer_fields: Fields requiring integer conversion
# - decimal_fields: Fields requiring decimal conversion
# - boolean_fields: Fields requiring boolean conversion
# - required_fields: Fields that must be present and non-null
# - validated_fields: Fields with CHECK constraint validations
# - foreign_keys: Foreign key relationships
# - override_enabled: Whether existing records can be updated (all FALSE)
# - override_check_fields: Fields to check for duplicate detection
#
# Note: All override_enabled flags are set to FALSE by default for safety.
# Enable on a per-table basis only after careful consideration of the implications.
