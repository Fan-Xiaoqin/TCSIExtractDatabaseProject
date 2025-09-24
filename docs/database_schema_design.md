# Database Schema Design for TCSI Extracts

## Overview

The database stores deidentified TCSI extract files. To balance traceability with performance the structure uses:

- **Staging schema (`stg_*` tables):** one table per incoming CSV, loaded verbatim with columns stored as `TEXT` unless a numeric field is obvious. Staging tables are truncated and reloaded for each monthly drop.
- **Curated schema (`dim_*`, `fact_*`, `bridge_*` tables):** a relational layer that normalises repeated values, enforces keys, and supports analytics/KPI reporting. Curated tables are loaded with upsert logic so historical snapshots remain available.
- **Reporting views:** convenience views (including the wide analysis view) built on curated tables. These views expose ISO-formatted dates and cast numeric metrics for downstream tools such as RStudio.

The supplied resource keys (`UID*_...ResKey`) remain the fundamental identifiers. Provider scope is enforced by foreign keys back to `dim_provider`.

## Entity Relationship Outline

Core entities and relationships:

```
dim_provider(provider_res_key PK)
  ├── dim_campus(campus_res_key PK, provider_res_key FK)
  ├── dim_course_of_study(course_of_study_res_key PK, provider_res_key FK)
  │     ├── dim_course(course_res_key PK, course_of_study_res_key FK)
  │           ├── bridge_course_campus(course_res_key FK, campus_res_key FK)
  │           ├── bridge_course_field_of_education(course_res_key FK)
  │           └── fact_course_admission(course_admission_res_key PK, course_res_key FK, student_res_key FK)
  │                   ├── fact_course_prior_credit(course_admission_res_key FK)
  │                   ├── fact_course_specialisation(course_admission_res_key FK)
  │                   ├── fact_unit_enrolment(course_admission_res_key FK)
  │                   ├── fact_student_loan(course_admission_res_key FK)
  │                   └── fact_scholarship(course_admission_res_key FK)
  └── dim_student(student_res_key PK, provider_res_key FK)
          ├── bridge_student_citizenship(student_res_key FK)
          ├── bridge_student_disability(student_res_key FK)
          └── bridge_student_contact(student_res_key FK)
```

Additional staging-only tables (e.g., `stg_hep_hd_end_users_engagement`, `stg_sahelp`, `stg_undetermined_students`) are available for future integration but do not yet participate in curated relationships.

## Table Specifications

Dates are initially stored as raw strings to keep parity with the CSVs; helper views will expose ISO formats using SQLite/duckdb date functions if required.

### dim_provider
| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| provider_res_key | TEXT | UID1_ProvidersResKey | Primary key |
| provider_code | TEXT | E306_ProviderCode | |
| provider_type | TEXT | E781_ProviderType | |

`dim_provider` is deduced from any file that carries provider metadata (first choice: `HEPStudents`).

### dim_student
| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| student_res_key | TEXT | UID8_StudentsResKey | Primary key |
| provider_res_key | TEXT | UID1_ProvidersResKey | FK → dim_provider |
| student_identifier | TEXT | E313_StudentIdentificationCode | |
| chessn | TEXT | E488_CHESSN | |
| usi | TEXT | E584_USI | |
| usi_verification_status | TEXT | A170_USIVerificationStatus | |
| tfn_verification_status | TEXT | A167_TFNVerificationStatus | |
| date_of_birth | TEXT | E314_DateOfBirth | Raw string |
| family_name | TEXT | E402_StudentFamilyName | |
| given_name_first | TEXT | E403_StudentGivenNameFirst | |
| given_name_others | TEXT | E404_StudentGivenNameOthers | |
| residential_address_line1 | TEXT | E410_ResidentialAddressLine1 | |
| residential_address_suburb | TEXT | E469_ResidentialAddressSuburb | |
| residential_address_postcode | TEXT | E320_ResidentialAddressPostcode | |
| residential_address_state | TEXT | E470_ResidentialAddressState | |
| residential_address_country | TEXT | E658_ResidentialAddressCountryCode | |
| term_residence_postcode | TEXT | E319_TermResidencePostcode | |
| term_residence_country | TEXT | E661_TermResidenceCountryCode | |
| gender_code | TEXT | E315_GenderCode | |
| atsi_code | TEXT | E316_ATSICode | |
| country_of_birth_code | TEXT | E346_CountryOfBirthCode | |
| arrival_year | TEXT | E347_ArrivalInAustraliaYear | |
| language_home_code | TEXT | E348_LanguageSpokenAtHomeCode | |
| year_left_school | TEXT | E572_YearLeftSchool | |
| level_left_school | TEXT | E612_LevelLeftSchool | |
| highest_ed_parent1 | TEXT | E573_HighestEducationParent1 | |
| highest_ed_parent2 | TEXT | E574_HighestEducationParent2 | |
| extraction_timestamp | TEXT | Injected | identifies load month |

### bridge_student_contact
Based on `StudentContactsFirstReportedAddress`.

| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| student_contact_res_key | TEXT | Hash of student_res_key + extraction | Synthetic PK |
| student_res_key | TEXT | UID8_StudentsResKey | FK |
| provider_res_key | TEXT | UID1_ProvidersResKey | FK |
| student_identifier | TEXT | E313_StudentIdentificationCode | |
| first_address_line1 | TEXT | E787_FirstResidentialAddressLine1 | |
| first_address_suburb | TEXT | E789_FirstResidentialAddressSuburb | |
| first_address_state | TEXT | E791_FirstResidentialAddressState | |
| first_address_country | TEXT | E659_FirstResidentialAddressCountryCode | |
| first_address_postcode | TEXT | E790_FirstResidentialAddressPostcode | |
| extraction_timestamp | TEXT | Injected |

(Original file has no natural `UID`, so a deterministic hash is generated when loading.)

### bridge_student_citizenship
| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| student_citizenship_res_key | TEXT | UID10_StudentCitizenshipsResKey | Primary key |
| student_res_key | TEXT | UID8_StudentsResKey | FK |
| provider_res_key | TEXT | UID1_ProvidersResKey | FK |
| student_identifier | TEXT | E313_StudentIdentificationCode | |
| chessn | TEXT | E488_CHESSN | |
| citizen_resident_code | TEXT | E358_CitizenResidentCode | |
| effective_from_date | TEXT | E609_EffectiveFromDate | |
| effective_to_date | TEXT | E610_EffectiveToDate | |
| extraction_timestamp | TEXT | Injected |

### bridge_student_disability
| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| student_disability_res_key | TEXT | UID11_StudentDisabilitiesResKey | Primary key |
| student_res_key | TEXT | UID8_StudentsResKey | FK |
| provider_res_key | TEXT | UID1_ProvidersResKey | FK |
| student_identifier | TEXT | E313_StudentIdentificationCode | |
| chessn | TEXT | E488_CHESSN | |
| disability_code | TEXT | E615_DisabilityCode | |
| effective_from_date | TEXT | E609_EffectiveFromDate | |
| effective_to_date | TEXT | E610_EffectiveToDate | |
| extraction_timestamp | TEXT | Injected |

### dim_course_of_study
From `CoursesOfStudy`.

| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| course_of_study_res_key | TEXT | UID3_CoursesOfStudyResKey | Primary key |
| provider_res_key | TEXT | UID1_ProvidersResKey | FK |
| course_of_study_code | TEXT | E533_CourseOfStudyCode | |
| course_of_study_name | TEXT | E394_CourseOfStudyName | |
| course_of_study_type | TEXT | E310_CourseOfStudyType | |
| course_of_study_load | TEXT | E350_CourseOfStudyLoad | |
| combined_course_indicator | TEXT | E455_CombinedCourseOfStudyIndicator | |

### dim_course
From `HEPCourses`.

| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| course_res_key | TEXT | UID5_CoursesResKey | Primary key |
| provider_res_key | TEXT | UID1_ProvidersResKey | FK |
| course_of_study_res_key | TEXT | UID3_CoursesOfStudyResKey | FK |
| course_code | TEXT | E307_CourseCode | |
| course_name | TEXT | E308_CourseName | |
| standard_course_duration | TEXT | E596_StandardCourseDuration | |
| cricos_code | TEXT | E597_CRICOSCode | |
| effective_from_date | TEXT | E609_EffectiveFromDate | |
| effective_to_date | TEXT | E610_EffectiveToDate | |

### bridge_course_campus
From `HEPCoursesOnCampuses`.

| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| course_campus_res_key | TEXT | UID4_CoursesOnCampusResKey | Primary key |
| provider_res_key | TEXT | UID1_ProvidersResKey | FK |
| course_res_key | TEXT | UID5_CoursesResKey | FK |
| campus_res_key | TEXT | UID2_CampusesResKey | FK |
| campus_suburb | TEXT | E525_CampusSuburb | |
| campus_country_code | TEXT | E644_CampusCountryCode | |
| campus_postcode | TEXT | E559_CampusPostcode | |
| campus_effective_from | TEXT | Campuses_E609_EffectiveFromDate | |
| campus_effective_to | TEXT | Campuses_E610_EffectiveToDate | |
| course_effective_from | TEXT | E609_EffectiveFromDate | |
| course_effective_to | TEXT | E610_EffectiveToDate | |

`dim_campus` is derived from distinct `(campus_res_key, ...)` rows in this bridge.

### bridge_course_field_of_education
From `CourseFieldsOfEducation`.

| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| course_field_res_key | TEXT | UID48_CourseFieldsOfEducationResKey | Primary key |
| provider_res_key | TEXT | UID1_ProvidersResKey | FK |
| course_of_study_res_key | TEXT | UID3_CoursesOfStudyResKey | FK |
| course_res_key | TEXT | UID5_CoursesResKey | FK |
| course_code | TEXT | E307_CourseCode | |
| course_of_study_name | TEXT | E394_CourseOfStudyName | |
| field_of_education_code | TEXT | E461_FieldOfEducationCode | |
| field_of_education_supp_code | TEXT | E462_FieldOfEducationSupplementaryCode | |
| effective_from_date | TEXT | E609_EffectiveFromDate | |
| effective_to_date | TEXT | E610_EffectiveToDate | |
| extraction_timestamp | TEXT | Injected |

### fact_course_admission
From `HEPCourseAdmissions`.

| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| course_admission_res_key | TEXT | UID15_CourseAdmissionsResKey | Primary key |
| provider_res_key | TEXT | UID1_ProvidersResKey | FK |
| student_res_key | TEXT | UID8_StudentsResKey | FK |
| course_res_key | TEXT | UID5_CoursesResKey | FK |
| student_identifier | TEXT | E313_StudentIdentificationCode | |
| course_code | TEXT | E307_CourseCode | |
| course_name | TEXT | E308_CourseName | |
| course_of_study_code | TEXT | E533_CourseOfStudyCode | |
| course_of_study_type | TEXT | E310_CourseOfStudyType | |
| course_commencement_date | TEXT | E534_CourseOfStudyCommencementDate | |
| attendance_type_code | TEXT | E330_AttendanceTypeCode | |
| mode_of_attendance_code | TEXT | E329_ModeOfAttendanceCode | derived from data where present |
| course_outcome_code | TEXT | E599_CourseOutcomeCode | |
| course_outcome_date | TEXT | E592_CourseOutcomeDate | |
| chessn | TEXT | E488_CHESSN | |
| hdr_thesis_submission_date | TEXT | E591_HDRThesisSubmissionDate | |
| atar | REAL | E632_ATAR | |
| selection_rank | REAL | E605_SelectionRank | |
| highest_attainment_code | TEXT | E620_HighestAttainmentCode | |
| hdr_primary_for_code | TEXT | E594_HDRPrimaryFieldOfResearchCode | |
| hdr_secondary_for_code | TEXT | E595_HDRSecondaryFieldOfResearchCode | |
| extraction_timestamp | TEXT | Injected |

### fact_course_prior_credit
From `HEPCoursePriorCredits`.

| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| course_prior_credit_res_key | TEXT | UID32_CoursePriorCreditsResKey | Primary key |
| provider_res_key | TEXT | UID1_ProvidersResKey | FK |
| course_admission_res_key | TEXT | UID15_CourseAdmissionsResKey | FK |
| student_identifier | TEXT | E313_StudentIdentificationCode | |
| course_code | TEXT | E307_CourseCode | |
| course_commencement_date | TEXT | E534_CourseOfStudyCommencementDate | |
| credit_used_value | REAL | E560_CreditUsedValue | |
| credit_basis | TEXT | E561_CreditBasis | |
| credit_provider_code | TEXT | E566_CreditProviderCode | |
| extraction_timestamp | TEXT | Injected |

### fact_course_specialisation
From `CourseSpecialisations` (student-level specialisations).

| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| course_specialisation_res_key | TEXT | UID33_CourseSpecialisationsResKey | Primary key |
| provider_res_key | TEXT | UID1_ProvidersResKey | FK |
| course_admission_res_key | TEXT | UID15_CourseAdmissionsResKey | FK |
| student_res_key | TEXT | via course_admission join | denormalised on load |
| student_identifier | TEXT | E313_StudentIdentificationCode | |
| course_code | TEXT | E307_CourseCode | |
| course_commencement_date | TEXT | E534_CourseOfStudyCommencementDate | |
| specialisation_code | TEXT | E463_SpecialisationCode | |
| extraction_timestamp | TEXT | Injected |

### fact_unit_enrolment
Derived by unioning all `HEP_units-AOUs_*.csv` files.

| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| unit_enrolment_res_key | TEXT | UID16_UnitEnrolmentsResKey | Primary key |
| provider_code | TEXT | E306_ProviderCode | |
| student_res_key | TEXT | UID8_StudentsResKey | FK |
| student_identifier | TEXT | E313_StudentIdentificationCode | |
| chessn | TEXT | E488_CHESSN | |
| course_admission_res_key | TEXT | UID15_CourseAdmissionsResKey | FK |
| course_of_study_code | TEXT | E533_CourseOfStudyCode | |
| course_of_study_type | TEXT | E310_CourseOfStudyType | |
| course_res_key | TEXT | UID5_CoursesResKey | |
| course_code | TEXT | E307_CourseCode | |
| course_name | TEXT | E308_CourseName | |
| course_commencement_date | TEXT | E534_CourseOfStudyCommDate | |
| unit_of_study_code | TEXT | E354_UnitOfStudyCode | |
| census_date | TEXT | E489_UnitOfStudyCensusDate | |
| work_experience_code | TEXT | E337_WorkExperienceInIndustryCode | |
| summer_winter_school_code | TEXT | E551_SummerWinterSchoolCode | |
| discipline_code | TEXT | E464_DisciplineCode | |
| unit_status_code | TEXT | E355_UnitOfStudyStatusCode | |
| mode_of_attendance_code | TEXT | E329_ModeOfAttendanceCode | |
| delivery_location_postcode | TEXT | E477_DeliveryLocationPostcode | |
| delivery_location_country_code | TEXT | E660_DeliveryLocationCountryCode | |
| student_status_code | TEXT | E490_StudentStatusCode | |
| max_student_contribution_code | TEXT | E392_MaximumStudentContributionCode | |
| year_long_indicator | TEXT | E622_UnitOfStudyYearLongIndicator | |
| unit_commencement_date | TEXT | E600_UnitOfStudyCommencementDate | |
| unit_outcome_date | TEXT | E601_UnitOfStudyOutcomeDate | |
| remission_reason_code | TEXT | E446_RemissionReasonCode | |
| loan_status | TEXT | A130_LoanStatus | |
| student_loan_res_key | TEXT | UID21_StudentLoansResKey | FK → fact_student_loan |
| adjusted_loan_amount | REAL | E662_AdjustedLoanAmount | |
| adjusted_loan_fee | REAL | E663_AdjustedLoanFee | |
| eftsl | REAL | UE.E339_EFTSL | |
| amount_charged | REAL | UE.E384_AmountCharged | |
| amount_paid_upfront | REAL | UE.E381_AmountPaidUpfront | |
| help_loan_amount | REAL | UE.E558_HELPLoanAmount | |
| loan_fee | REAL | UE.E529_LoanFee | |
| is_deleted | TEXT | UE.A111_IsDeleted | |
| extraction_timestamp | TEXT | Injected (based on folder month) |
| reporting_year | INTEGER | Derived from filename suffix | helps partitioning |

### fact_unit_enrolment_aou
Captures the nested AOUs in the `HEP_units-AOUs` files.

| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| unit_enrolment_aou_res_key | TEXT | UID19_UnitEnrolmentAOUsResKey | Primary key |
| unit_enrolment_res_key | TEXT | UID16_UnitEnrolmentsResKey | FK |
| aou_code | TEXT | E333_AOUCode | |
| eftsl | REAL | AOU.E339_EFTSL | |
| amount_charged | REAL | AOU.E384_AmountCharged | |
| amount_paid_upfront | REAL | AOU.E381_AmountPaidUpfront | |
| help_loan_amount | REAL | AOU.E558_HELPLoanAmount | |
| loan_fee | REAL | AOU.E529_LoanFee | |
| is_deleted | TEXT | AOU.IsDeleted | |
| extraction_timestamp | TEXT | Injected |
| reporting_year | INTEGER | From filename |

### fact_student_loan
Combines OS-HELP (`OSHELP`), SA-HELP (`SAHELP`), and loan-related fields embedded in unit enrolments.

| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| student_loan_res_key | TEXT | UID21_StudentLoansResKey / equivalent | Primary key; for SAHELP/OSHELP the UID is available directly |
| provider_res_key | TEXT | UID1_ProvidersResKey | |
| student_res_key | TEXT | Derived via joins to admissions/unit enrolments | |
| course_admission_res_key | TEXT | Derived | |
| loan_type | TEXT | {SAHELP, OSHELP, UNIT_EMBEDDED} | |
| reporting_year | TEXT | E415_ReportingYear | |
| reporting_period | TEXT | E666_ReportingPeriod | where available |
| loan_amount | REAL | E553_SAHELPAmount / OSHELP amount / UE.E558 | |
| loan_fee | REAL | Fields vary; default `NULL` if not supplied |
| status_code | TEXT | Source-specific status fields | |
| extraction_timestamp | TEXT | Injected |

### fact_scholarship
Combines `CommonwealthScholarships`, `RTPScholarships`, and `RTPStipend`.

| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| scholarship_res_key | TEXT | UID12_StudentCommonwealthScholarshipsResKey / UID26_RTPScholarshipsResKey / UID18_RTPStipendsResKey | Primary key |
| provider_res_key | TEXT | UID1_ProvidersResKey | |
| student_res_key | TEXT | UID8_StudentsResKey | FK |
| course_admission_res_key | TEXT | Derived for RTP using UID15 | |
| student_identifier | TEXT | E313_StudentIdentificationCode | |
| scholarship_type | TEXT | {COMMONWEALTH, RTP_SCHOLARSHIP, RTP_STIPEND} | |
| reporting_year | TEXT | E415_ReportingYear | |
| reporting_period | TEXT | E666_ReportingPeriod | where available |
| amount | REAL | E598_CommonwealthScholarshipAmount / E623_RTPStipendAmount | |
| status_code | TEXT | Source-specific status/termination fields | |
| extraction_timestamp | TEXT | Injected |

### fact_course_fee
From `CampusCourseFeesITSP`.

| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| campus_course_fee_res_key | TEXT | UID31_CampusCourseFeesResKey | Primary key |
| provider_res_key | TEXT | UID1_ProvidersResKey | FK |
| course_campus_res_key | TEXT | UID4_CoursesOnCampusResKey | FK |
| course_res_key | TEXT | UID5_CoursesResKey | FK |
| course_code | TEXT | E307_CourseCode | |
| campus_suburb | TEXT | E525_CampusSuburb | |
| indicative_student_contribution_csp | REAL | E495_IndicativeStudentContributionCSP | |
| indicative_tuition_fee_domestic_fp | REAL | E496_IndicativeTuitionFeeDomesticFP | |
| effective_from_date | TEXT | E609_EffectiveFromDate | |
| campus_effective_from_date | TEXT | Campuses_E609_EffectiveFromDate | |
| extraction_timestamp | TEXT | Injected |

### fact_aggregated_award
From `AggregatedAwards` (when populated).

| Column | Type | Source | Notes |
| --- | --- | --- | --- |
| aggregated_award_res_key | TEXT | UID47_AggregateAwardsResKey | Primary key |
| provider_res_key | TEXT | UID1_ProvidersResKey | |
| student_res_key | TEXT | UID8_StudentsResKey | |
| course_res_key | TEXT | UID5_CoursesResKey | |
| course_code | TEXT | E307_CourseCode | |
| course_commencement_date | TEXT | E534_CourseOfStudyCommencementDate | |
| course_outcome_code | TEXT | E599_CourseOutcomeCode | |
| course_outcome_date | TEXT | E592_CourseOutcomeDate | |
| hdr_thesis_submission_date | TEXT | E591_HDRThesisSubmissionDate | |
| attendance_type_code | TEXT | E330_AttendanceTypeCode | |
| mode_of_attendance_code | TEXT | E329_ModeOfAttendanceCode | |
| extraction_timestamp | TEXT | Injected |

### wide_student_course view
A reporting view joining `dim_student`, `fact_course_admission`, latest `fact_unit_enrolment` (per student/course/admission/extraction), cumulative HELP amounts, and scholarships. Fields exposed:
- Student demographics (selected columns from `dim_student`)
- Course metadata (codes, names, course-of-study details)
- Current status and outcome metrics
- Most recent unit census information (EFTSL, HELP amounts)
- Aggregated scholarship and loan totals per admission and extraction

## Data Type Strategy

- Identifiers and codes remain `TEXT` to preserve leading zeros and hashed values.
- Monetary/EFTSL metrics loaded as `REAL`.
- Reporting helper views will convert the stored text dates using `DATE(substr(...))` where necessary.

## Constraints and Indexes

- Primary key and unique indexes on every curated table as listed above.
- Foreign keys enforce provider, student, course, and admission relationships.
- Composite indexes added for common query paths (e.g., `(student_res_key, extraction_timestamp)` on admissions; `(course_res_key, reporting_year)` on fees).
- Staging tables remain unconstrained for fast bulk inserts.

## Monthly Incremental Load Rules

1. **Extraction timestamp:** The loader derives an ISO timestamp from the directory name (`12Mar2025_extracted` → `2025-03-12T00:00:00Z`) and records it in `etl_load_history` plus the `extraction_timestamp` column on curated rows.
2. **Staging refresh:** Each load folder is ingested into staging tables (truncate + insert). Curated upserts compare primary keys; newer rows update descriptive attributes but keep prior snapshots thanks to distinct extraction timestamps.
3. **History preservation:** No hard deletes; rows become inactive when the source `effective_to_date` is set. Otherwise, history is distinguished by `extraction_timestamp`.
4. **Data validation:** After loading, row counts between staging and curated tables are compared and logged. Failed validations keep data staged for investigation.

## Open Assumptions

- `fact_student_loan` will expand once SA-HELP/OS-HELP columns are confirmed during implementation.
- `fact_scholarship` currently aggregates three files; additional scholarship extracts can be mapped with the same pattern.
- `HEPHDREndUsersEngagement` and `Undetermined*` tables are staged but not yet surfaced; future iterations can extend the curated model.

This schema definition guides the implementation and testing tasks scheduled for the Database Development Phase.
