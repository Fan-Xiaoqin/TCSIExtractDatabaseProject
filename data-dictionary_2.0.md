# TCSI Extract Database Data Dictionary

## Version 2.0
**Last Updated:** September 2025  
**Project:** TCSI Extract Database Project  
**Status:** Final (Stage 4 - Client Approved)

---

## Table of Contents
1. [Overview](#overview)
2. [Database Schema Overview](#database-schema-overview)
3. [Core Tables](#core-tables)
4. [Relationship Tables](#relationship-tables)
5. [Reference Tables](#reference-tables)
6. [Data Types and Conventions](#data-types-and-conventions)
7. [Business Rules](#business-rules)
8. [Glossary](#glossary)

---

## Overview

This data dictionary documents the TCSI Extract Database structure designed to store and manage student data from the Tertiary Collection of Student Information system. The database supports incremental monthly updates while preserving historical records for trend analysis and reporting.

### Key Features
- **Normalized Structure**: Minimizes redundancy through proper normalization
- **Historical Tracking**: Supports temporal data with effective dates
- **TCSI Compliance**: Aligns with TCSI specifications and packet structures
- **Incremental Loading**: Designed for monthly data updates without overwrites

---

## Database Schema Overview

The database follows a star schema pattern with fact tables (enrollments, admissions) and dimension tables (students, courses, providers).

### Primary Entity Categories
1. **Student Data**: Personal and demographic information
2. **Course Structure**: Programs, units, and campus offerings
3. **Enrollment Records**: Student registrations and academic progress
4. **Financial Data**: HELP loans, fees, and awards
5. **Provider Information**: Institution and campus details

---

## Core Tables

### 1. HEPStudents
**Description:** Master table for all Higher Education Provider students.

| Field Name | Data Type | Size | Nullable | Description | Business Rules |
|------------|-----------|------|----------|-------------|----------------|
| **Student_key** | INTEGER | - | NO | Primary key, auto-increment | Unique identifier |
| E313_StudentIdentificationCode | VARCHAR | 10 | NO | Student ID from provider | Must be unique within provider |
| E488_CHESSN | VARCHAR | 10 | YES | Commonwealth HE Student Support Number | 10-digit numeric string |
| E584_USI | VARCHAR | 10 | YES | Unique Student Identifier | National identifier |
| E401_PersonSurname | VARCHAR | 50 | NO | Student's family name | Required for all students |
| E402_PersonGivenName | VARCHAR | 50 | NO | Student's first name | Required for all students |
| E403_PersonMiddleName | VARCHAR | 50 | YES | Middle name(s) | Optional |
| E573_PersonTitle | VARCHAR | 20 | YES | Title (Mr, Ms, Dr, etc.) | From reference list |
| E315_DateOfBirth | DATE | - | NO | Date of birth | Format: YYYY-MM-DD |
| E314_GenderCode | CHAR | 1 | NO | Gender code | M/F/X (Male/Female/Other) |
| E346_CountryOfBirth | VARCHAR | 4 | YES | Birth country code | ISO 3166-1 numeric |
| E348_LanguageSpokenAtHome | VARCHAR | 4 | YES | Language code | ABS language codes |
| E347_YearOfArrivalInAustralia | INTEGER | 4 | YES | Year arrived | 4-digit year, if applicable |
| E316_ATSICode | CHAR | 1 | YES | Aboriginal/Torres Strait Islander | 1-4 (see glossary) |
| E358_CitizenshipCode | VARCHAR | 4 | NO | Citizenship status | TCSI citizenship codes |
| E359_PermanentResidentStatus | CHAR | 1 | YES | Permanent resident indicator | Y/N |
| E490_StudentStatusCode | VARCHAR | 2 | NO | Current enrollment status | Active/Inactive/Graduated |
| extraction_date | DATETIME | - | NO | When record was extracted | System generated |
| reporting_year | INTEGER | 4 | NO | TCSI reporting year | Current year default |
| created_date | DATETIME | - | NO | Record creation timestamp | System generated |
| modified_date | DATETIME | - | YES | Last modification timestamp | System generated |

### 2. StudentResidentialAddress
**Description:** Current residential address for students (normalized from HEPStudents).

| Field Name | Data Type | Size | Nullable | Description | Business Rules |
|------------|-----------|------|----------|-------------|----------------|
| **Address_key** | INTEGER | - | NO | Primary key | Auto-increment |
| Student_key | INTEGER | - | NO | Foreign key to HEPStudents | Must exist in HEPStudents |
| E469_ResidentialAddressLine1 | VARCHAR | 100 | NO | Street address line 1 | Required |
| E469_ResidentialAddressLine2 | VARCHAR | 100 | YES | Street address line 2 | Optional |
| E470_ResidentialAddressPostcode | VARCHAR | 10 | NO | Postcode | Australian postcode format |
| E470_ResidentialAddressSuburb | VARCHAR | 50 | NO | Suburb/city | Required |
| E470_ResidentialAddressState | VARCHAR | 3 | NO | State/territory code | Australian state codes |
| E659_ResidentialAddressCountry | VARCHAR | 4 | NO | Country code | ISO 3166-1 numeric |
| effective_from_date | DATE | - | NO | When address became current | Default: extraction date |
| effective_to_date | DATE | - | YES | When address ceased | NULL = current |

### 3. CourseAdmissions
**Description:** Student admissions to courses of study.

| Field Name | Data Type | Size | Nullable | Description | Business Rules |
|------------|-----------|------|----------|-------------|----------------|
| **UID15_CourseAdmissionsResKey** | VARCHAR | 50 | NO | Primary key | TCSI resource key |
| Student_key | INTEGER | - | NO | Foreign key to HEPStudents | Must exist |
| UID5_CoursesResKey | VARCHAR | 50 | NO | Foreign key to Courses | Must exist |
| E534_CourseOfStudyCommDate | DATE | - | NO | Course commencement date | Cannot be future date |
| E327_BasisForAdmissionCode | VARCHAR | 2 | YES | How student was admitted | TCSI admission codes |
| E330_SchemeDate | DATE | - | YES | Scheme admission date | If applicable |
| E462_EntireAcademicCareerReportableIndicator | CHAR | 1 | YES | Career reportable flag | Y/N |
| E563_StudentNumber | VARCHAR | 20 | YES | Alternative student number | Provider specific |
| E369_PriorStudiesCode | VARCHAR | 2 | YES | Prior education level | TCSI codes |
| E348_HighestEducationLevelCode | VARCHAR | 2 | YES | Highest qualification | TCSI education levels |
| E493_HighestParticipationCode | VARCHAR | 2 | YES | Highest participation type | TCSI participation codes |
| E622_ResearchMastersCommencementDate | DATE | - | YES | Research masters start | If HDR student |
| E623_DoctoralCommencementDate | DATE | - | YES | Doctoral start date | If PhD student |
| reporting_year | INTEGER | 4 | NO | TCSI reporting year | Required |

### 4. UnitEnrolments
**Description:** Student enrollments in individual units of study.

| Field Name | Data Type | Size | Nullable | Description | Business Rules |
|------------|-----------|------|----------|-------------|----------------|
| **UID16_UnitEnrolmentsResKey** | VARCHAR | 50 | NO | Primary key | TCSI resource key |
| Student_key | INTEGER | - | NO | Foreign key to HEPStudents | Must exist |
| UID15_CourseAdmissionsResKey | VARCHAR | 50 | NO | Foreign key to CourseAdmissions | Must exist |
| E354_UnitOfStudyCode | VARCHAR | 20 | NO | Unit/subject code | Provider specific |
| E489_UnitOfStudyCensusDate | DATE | - | NO | Census date | Critical for HELP |
| E355_UnitOfStudyStatusCode | VARCHAR | 2 | NO | Enrollment status | Enrolled/Withdrawn/Complete |
| E329_ModeOfAttendanceCode | VARCHAR | 2 | NO | Study mode | Internal/External/Multi-modal |
| E339_EFTSL | DECIMAL | 5,3 | NO | Equivalent full-time load | 0.000-1.000 |
| E381_AmountChargedUpfront | DECIMAL | 10,2 | YES | Upfront payment amount | In dollars |
| E384_AmountPaidUpfront | DECIMAL | 10,2 | YES | Amount actually paid | In dollars |
| E415_ReportingDate | DATE | - | NO | Date reported to TCSI | System date |
| E490_StudentStatusCode | VARCHAR | 2 | NO | Status at census | Active/Deferred/etc |
| E551_SummerWinterSchoolCode | CHAR | 1 | YES | Summer/winter indicator | Y/N |
| E337_WorkExperienceInIndustryCode | CHAR | 1 | YES | Work placement indicator | Y/N |
| reporting_year | INTEGER | 4 | NO | TCSI reporting year | Required |

### 5. SAHELP
**Description:** SA-HELP loan records for student services and amenities fees.

| Field Name | Data Type | Size | Nullable | Description | Business Rules |
|------------|-----------|------|----------|-------------|----------------|
| **UID17_SAHELPResKey** | VARCHAR | 50 | NO | Primary key | TCSI resource key |
| Student_key | INTEGER | - | NO | Foreign key to HEPStudents | Must exist |
| E381_AmountChargedUpfront | DECIMAL | 10,2 | YES | SA fee charged | Maximum set by government |
| E384_AmountPaidUpfront | DECIMAL | 10,2 | YES | Amount paid upfront | Cannot exceed charged |
| E558_LoanToSAHELP | DECIMAL | 10,2 | YES | Amount deferred to HELP | Cannot exceed limit |
| E392_HELPEligibilityCode | CHAR | 1 | NO | HELP eligibility status | Y/N |
| E415_ReportingDate | DATE | - | NO | Date reported | System generated |
| reporting_year | INTEGER | 4 | NO | TCSI reporting year | Required |

---

## Relationship Tables

### 6. CoursesOnCampuses
**Description:** Links courses to campus locations where they're offered.

| Field Name | Data Type | Size | Nullable | Description | Business Rules |
|------------|-----------|------|----------|-------------|----------------|
| **UID4_CoursesOnCampusResKey** | VARCHAR | 50 | NO | Primary key | TCSI resource key |
| UID5_CoursesResKey | VARCHAR | 50 | NO | Foreign key to Courses | Must exist |
| UID30_CampusesResKey | VARCHAR | 50 | NO | Foreign key to Campuses | Must exist |
| E551_CourseDeliveryMode | VARCHAR | 2 | YES | Primary delivery mode | Internal/External/Mixed |
| E609_EffectiveFromDate | DATE | - | NO | When offering starts | Required |
| E610_EffectiveToDate | DATE | - | YES | When offering ends | NULL = ongoing |

### 7. CampusCourseFees
**Description:** Fee structures for courses at specific campuses.

| Field Name | Data Type | Size | Nullable | Description | Business Rules |
|------------|-----------|------|----------|-------------|----------------|
| **UID31_CampusCourseFeesResKey** | VARCHAR | 50 | NO | Primary key | TCSI resource key |
| UID4_CoursesOnCampusResKey | VARCHAR | 50 | NO | Foreign key to CoursesOnCampuses | Must exist |
| E536_CourseFeesCode | VARCHAR | 10 | NO | Fee structure code | Provider specific |
| E495_IndicativeStudentContributionCSP | DECIMAL | 10,2 | YES | CSP contribution amount | Annual amount |
| E496_IndicativeTuitionFeeDomesticFP | DECIMAL | 10,2 | YES | Domestic fee-paying amount | Annual amount |
| E497_IndicativeTuitionFeeInternational | DECIMAL | 10,2 | YES | International student fee | Annual amount |
| E609_EffectiveFromDate | DATE | - | NO | Fee effective date | Required |
| E610_EffectiveToDate | DATE | - | YES | Fee end date | NULL = current |

### 8. AggregatedAwards
**Description:** Aggregated financial awards and scholarships.

| Field Name | Data Type | Size | Nullable | Description | Business Rules |
|------------|-----------|------|----------|-------------|----------------|
| **UID20_AggregatedAwardsResKey** | VARCHAR | 50 | NO | Primary key | TCSI resource key |
| Student_key | INTEGER | - | NO | Foreign key to HEPStudents | Must exist |
| UID5_CoursesResKey | VARCHAR | 50 | NO | Foreign key to Courses | Must exist |
| E552_AggregatedAwardCourseReportingDate | DATE | - | NO | Reporting date | Required |
| E533_CourseOfStudyCode | VARCHAR | 20 | NO | Course code | Must match course |
| E571_ScholarshipsFromCommonwealthPrograms | DECIMAL | 10,2 | YES | Commonwealth scholarship | In dollars |
| E538_OtherScholarshipsWithin | DECIMAL | 10,2 | YES | Other internal scholarships | In dollars |
| E597_TotalAwardAmount | DECIMAL | 10,2 | NO | Total award amount | Sum of all awards |
| reporting_year | INTEGER | 4 | NO | TCSI reporting year | Required |

---

## Reference Tables

### 9. HEPProviders
**Description:** Higher Education Provider information.

| Field Name | Data Type | Size | Nullable | Description | Business Rules |
|------------|-----------|------|----------|-------------|----------------|
| **UID1_ProvidersResKey** | VARCHAR | 50 | NO | Primary key | TCSI resource key |
| E306_ProviderCode | VARCHAR | 10 | NO | Provider identifier | Unique TCSI code |
| E781_ProviderType | VARCHAR | 20 | NO | Type of provider | University/TAFE/Private |
| provider_name | VARCHAR | 100 | NO | Institution name | Official name |
| provider_abn | VARCHAR | 11 | YES | Australian Business Number | 11 digits |

### 10. Courses
**Description:** Course/program definitions.

| Field Name | Data Type | Size | Nullable | Description | Business Rules |
|------------|-----------|------|----------|-------------|----------------|
| **UID5_CoursesResKey** | VARCHAR | 50 | NO | Primary key | TCSI resource key |
| UID3_CoursesOfStudyResKey | VARCHAR | 50 | NO | Foreign key to CoursesOfStudy | Must exist |
| E307_CourseCode | VARCHAR | 20 | NO | Course code | Unique within provider |
| E308_CourseName | VARCHAR | 200 | NO | Full course name | Official title |
| E310_CourseOfStudyType | VARCHAR | 2 | NO | Course type | UG/PG/HDR codes |
| E350_CourseOfStudyLoad | VARCHAR | 2 | NO | Standard load | FT/PT |
| E596_StandardCourseDuration | DECIMAL | 3,1 | NO | Duration in years | Standard duration |
| E609_EffectiveFromDate | DATE | - | NO | Course start date | Required |
| E610_EffectiveToDate | DATE | - | YES | Course end date | NULL = active |

### 11. CoursesOfStudy
**Description:** Course of study reference data.

| Field Name | Data Type | Size | Nullable | Description | Business Rules |
|------------|-----------|------|----------|-------------|----------------|
| **UID3_CoursesOfStudyResKey** | VARCHAR | 50 | NO | Primary key | TCSI resource key |
| E533_CourseOfStudyCode | VARCHAR | 20 | NO | Study code | Unique identifier |
| E394_CourseOfStudyName | VARCHAR | 200 | NO | Study name | Full name |
| E310_CourseOfStudyType | VARCHAR | 2 | NO | Type code | TCSI type codes |
| E455_CombinedCourseOfStudyIndicator | CHAR | 1 | YES | Combined degree flag | Y/N |

### 12. Campuses
**Description:** Physical and virtual campus locations.

| Field Name | Data Type | Size | Nullable | Description | Business Rules |
|------------|-----------|------|----------|-------------|----------------|
| **UID30_CampusesResKey** | VARCHAR | 50 | NO | Primary key | TCSI resource key |
| campus_code | VARCHAR | 10 | NO | Campus identifier | Unique within provider |
| campus_name | VARCHAR | 100 | NO | Campus name | Official name |
| E525_CampusSuburb | VARCHAR | 50 | NO | Suburb/city | Required |
| E559_CampusPostcode | VARCHAR | 10 | NO | Postcode | Valid postcode |
| E644_CampusCountryCode | VARCHAR | 4 | NO | Country code | ISO 3166-1 |
| E609_EffectiveFromDate | DATE | - | NO | Campus operational date | Required |

### 13. ExitAwards
**Description:** Exit awards and completions.

| Field Name | Data Type | Size | Nullable | Description | Business Rules |
|------------|-----------|------|----------|-------------|----------------|
| **UID21_ExitAwardsResKey** | VARCHAR | 50 | NO | Primary key | TCSI resource key |
| Student_key | INTEGER | - | NO | Foreign key to HEPStudents | Must exist |
| UID5_CoursesResKey | VARCHAR | 50 | NO | Foreign key to Courses | Must exist |
| E592_AwardCourseCompletionDate | DATE | - | NO | Completion date | Cannot be future |
| E593_AwardCompletionYear | INTEGER | 4 | NO | Completion year | 4-digit year |
| E594_AwardCourseType | VARCHAR | 2 | NO | Award type | Degree/Diploma/Certificate |
| E595_ConferralDate | DATE | - | YES | Graduation ceremony date | If applicable |
| reporting_year | INTEGER | 4 | NO | TCSI reporting year | Required |

---

## Data Types and Conventions

### Standard Data Types
- **VARCHAR(n)**: Variable character string, max length n
- **CHAR(n)**: Fixed character string, length n
- **INTEGER**: Whole numbers (-2,147,483,648 to 2,147,483,647)
- **DECIMAL(p,s)**: Decimal numbers with precision p and scale s
- **DATE**: Date values (YYYY-MM-DD format)
- **DATETIME**: Date and time values (YYYY-MM-DD HH:MM:SS)

### Naming Conventions
- **E###_**: TCSI element number prefix (e.g., E313_StudentIdentificationCode)
- **UID##_**: TCSI unique identifier prefix
- **_key**: Suffix for primary key fields
- **_date**: Suffix for date fields
- **_code**: Suffix for coded/reference fields

### NULL Value Handling
- Required fields (NOT NULL) are mandatory for TCSI compliance
- Optional fields may contain NULL where data is not applicable
- Date fields use NULL to indicate "ongoing" or "not yet occurred"

---

## Business Rules

### Data Integrity Rules
1. **Referential Integrity**: All foreign keys must reference existing records
2. **Temporal Consistency**: Effective dates must be logically consistent (from < to)
3. **CHESSN Validation**: Must be 10-digit numeric string when provided
4. **USI Validation**: Must conform to national USI format when provided
5. **Date Validation**: Dates cannot be in the future unless specifically allowed

### Loading Rules
1. **Incremental Updates**: New extracts add records, don't overwrite existing
2. **Historical Preservation**: Previous records maintained with effective dates
3. **Duplicate Prevention**: Unique constraints on natural keys prevent duplicates
4. **Audit Trail**: extraction_date and reporting_year track data lineage

### TCSI Compliance Rules
1. **Packet Linkages**: Maintain proper relationships per TCSI specifications
2. **Required Fields**: All TCSI mandatory fields must be populated
3. **Code Validation**: Use only valid TCSI reference codes
4. **Reporting Periods**: Align with TCSI reporting calendar

---

## Glossary

### Key Terms and Acronyms

| Term | Definition |
|------|------------|
| **ATSI** | Aboriginal and Torres Strait Islander status codes:<br>1 = Aboriginal<br>2 = Torres Strait Islander<br>3 = Both Aboriginal and Torres Strait Islander<br>4 = Neither |
| **CHESSN** | Commonwealth Higher Education Student Support Number - unique identifier for HELP loans |
| **CRICOS** | Commonwealth Register of Institutions and Courses for Overseas Students |
| **CSP** | Commonwealth Supported Place - government subsidized study place |
| **EFTSL** | Equivalent Full-Time Student Load - measure of study load (1.0 = full-time for one year) |
| **HDR** | Higher Degree by Research - Masters or Doctoral research programs |
| **HELP** | Higher Education Loan Program - government study loans including:<br>- HECS-HELP: For CSP students<br>- FEE-HELP: For fee-paying students<br>- SA-HELP: For student amenities fees<br>- OS-HELP: For overseas study |
| **HEP** | Higher Education Provider - universities and other tertiary institutions |
| **RPL** | Recognition of Prior Learning - credit for previous study or experience |
| **RTP** | Research Training Program - government funding for HDR students |
| **SCD** | Slowly Changing Dimension - method for tracking historical changes |
| **TAC** | Tertiary Admissions Centre - centralized admissions processing |
| **TCSI** | Tertiary Collection of Student Information - national data collection system |
| **UID** | Unique Identifier - TCSI system-generated keys |
| **USI** | Unique Student Identifier - lifelong education number for Australian students |

### TCSI Element Prefixes
- **E3xx**: Student and admission elements
- **E4xx**: Demographic and address elements
- **E5xx**: Financial and fee elements
- **E6xx**: Date and country elements
- **E7xx**: Provider elements

### Status Codes
| Code | Description |
|------|------------|
| **Student Status** | Active / Inactive / Graduated / Withdrawn / Deferred |
| **Unit Status** | Enrolled / Withdrawn / Completed / Failed / Exempt |
| **Gender Codes** | M = Male / F = Female / X = Other |
| **Yes/No Flags** | Y = Yes / N = No / NULL = Not Applicable |

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | Sept 2025 | Initial Team | Initial draft based on TCSI specifications |
| 1.5 | Sept 2025 | Development Team | Added ERD Stage 3 refinements |
| 2.0 | Sept 2025 | Final Team | Stage 4 approved version with client feedback |

】

*This document is confidential and contains sensitive information about student data structures. Handle according to data protection policies.*
