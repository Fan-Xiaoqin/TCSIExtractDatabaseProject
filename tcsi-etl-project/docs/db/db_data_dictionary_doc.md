# Data Dictionary - TCSI Extract Database 

## Student related entities
Stores personal and demographic details of students and their associated citizenships, disabilities, and contact data.

### 1. `hep_students`
Master table storing core student demographic and identification details.

| **Column Name**                         | **Data Type**  | **Description**                                              | **Key Type** |
| --------------------------------------- | -------------- | ------------------------------------------------------------ | ------------ |
| `student_id`                            | `BIGINT`       | Unique system-generated identifier for each student.         | **PK**       |
| `uid8_students_res_key`                 | `VARCHAR(10)`  | Unique TCSI resource key for student record.                 |              |
| `e313_student_identification_code`      | `VARCHAR(10)`  | Institution-assigned student ID code.                        |              |
| `e488_chessn`                           | `VARCHAR(10)`  | Commonwealth Higher Education Student Support Number.        |              |
| `e584_usi`                              | `VARCHAR(10)`  | Unique Student Identifier (USI).                             |              |
| `a170_usi_verification_status`          | `VARCHAR(8)`   | Status of USI verification (e.g., VERIFIED / FAILED).        |              |
| `a167_tfn_verification_status`          | `VARCHAR(8)`   | Status of TFN verification for HELP eligibility.             |              |
| `e314_date_of_birth`                    | `DATE`         | Student’s date of birth.                                     |              |
| `e402_student_family_name`              | `VARCHAR(40)`  | Student’s family name (surname).                             |              |
| `e403_student_given_name_first`         | `VARCHAR(40)`  | Student’s first given name.                                  |              |
| `e404_student_given_name_others`        | `VARCHAR(40)`  | Other given names (middle names).                            |              |
| `e410_residential_address_line1`        | `VARCHAR(255)` | First line of student’s current residential address.         |              |
| `e469_residential_address_suburb`       | `VARCHAR(48)`  | Suburb of residence.                                         |              |
| `e320_residential_address_postcode`     | `VARCHAR(4)`   | Postcode of residence.                                       |              |
| `e470_residential_address_state`        | `VARCHAR(3)`   | State or territory code of residence.                        |              |
| `e658_residential_address_country_code` | `VARCHAR(4)`   | Country code of residence (ISO or TCSI standard).            |              |
| `e319_term_residence_postcode`          | `VARCHAR(4)`   | Postcode of residence during study term.                     |              |
| `e661_term_residence_country_code`      | `VARCHAR(4)`   | Country code for residence during term.                      |              |
| `e315_gender_code`                      | `VARCHAR(1)`   | Gender code (‘M’ = Male, ‘F’ = Female, ‘X’ = Indeterminate). |              |
| `e316_atsi_code`                        | `VARCHAR(1)`   | Aboriginal and Torres Strait Islander status (‘2’–‘9’).      |              |
| `e346_country_of_birth_code`            | `VARCHAR(4)`   | Country of birth (standard TCSI country code).               |              |
| `e347_arrival_in_australia_year`        | `INTEGER`      | Year of arrival in Australia.                                |              |
| `e348_language_spoken_at_home_code`     | `VARCHAR(4)`   | Language code spoken at home.                                |              |
| `e572_year_left_school`                 | `INTEGER`      | Year student left school.                                    |              |
| `e612_level_left_school`                | `SMALLINT`     | Level of education completed at school leaving.              |              |
| `e573_highest_education_parent1`        | `VARCHAR(2)`   | Highest education level achieved by parent 1.                |              |
| `e574_highest_education_parent2`        | `VARCHAR(2)`   | Highest education level achieved by parent 2.                |              |
| `updated_at`                            | `TIMESTAMP`    | Timestamp of last record update.                             |              |
| `is_current`                            | `BOOLEAN`      | Indicates if the record is the current version.              |              |

### 2.`hep_student_citizenships`
Stores student citizenship and residency status over time.

| **Column Name**                      | **Data Type** | **Description**                                               | **Key Type**                      |
| ------------------------------------ | ------------- | ------------------------------------------------------------- | --------------------------------- |
| `student_citizenship_id`             | `BIGINT`      | Unique identifier for each citizenship record.                | **PK**                            |
| `student_id`                         | `BIGINT`      | Reference to the student in `hep_students`.                   | **FK → hep_students(student_id)** |
| `uid10_student_citizenships_res_key` | `VARCHAR(10)` | Unique TCSI resource key for student citizenship.             |                                   |
| `e358_citizen_resident_code`         | `CHAR(1)`     | Citizenship or residency status (‘1’–‘5’, ‘8’, or ‘P’).       |                                   |
| `e609_effective_from_date`           | `DATE`        | Date from which this citizenship record is effective.         |                                   |
| `e610_effective_to_date`             | `DATE`        | Date to which this citizenship record remains valid.          |                                   |
| `updated_at`                         | `TIMESTAMP`   | Timestamp of last update.                                     |                                   |
| `is_current`                         | `BOOLEAN`     | Indicates if record is currently active.                      |                                   |

### 3. `hep_student_disabilities`
Captures student disability information where applicable.

| **Column Name**                      | **Data Type** | **Description**                                  | **Key Type**                      |
| ------------------------------------ | ------------- | ------------------------------------------------ | --------------------------------- |
| `student_disability_id`              | `BIGINT`      | Unique identifier for student disability record. | **PK**                            |
| `student_id`                         | `BIGINT`      | Reference to student in `hep_students`.          | **FK → hep_students(student_id)** |
| `uid11_student_disabilities_res_key` | `VARCHAR(10)` | Unique TCSI resource key for disability record.  |                                   |
| `e615_disability_code`               | `VARCHAR(2)`  | Type of disability (‘11’–‘20’,‘99’).                  |                                   |
| `e609_effective_from_date`           | `DATE`        | Start date of disability record validity.        |                                   |
| `e610_effective_to_date`             | `DATE`        | End date of disability record validity.          |                                   |
| `updated_at`                         | `TIMESTAMP`   | Timestamp of last update.                        |                                   |
| `is_current`                         | `BOOLEAN`     | Indicates current active record.                 |                                   |

### 4. `student_contacts_first_reported_address`
Captures the student’s first reported residential address.

| **Column Name**                               | **Data Type**  | **Description**                                       | **Key Type**                      |
| --------------------------------------------- | -------------- | ----------------------------------------------------- | --------------------------------- |
| `first_address_id`                            | `BIGINT`       | Unique identifier for first address record.           | **PK**                            |
| `student_id`                                  | `BIGINT`       | Reference to student in `hep_students`.               | **FK → hep_students(student_id)** |
| `e787_first_residential_address_line1`        | `VARCHAR(255)` | First line of the first reported residential address. |                                   |
| `e789_first_residential_address_suburb`       | `VARCHAR(48)`  | Suburb of first address.                              |                                   |
| `e791_first_residential_address_state`        | `VARCHAR(3)`   | State of first address.                               |                                   |
| `e659_first_residential_address_country_code` | `VARCHAR(4)`   | Country code for the first address.                   |                                   |
| `e790_first_residential_address_postcode`     | `VARCHAR(4)`   | Postcode of first address.                            |                                   |
| `updated_at`                                  | `TIMESTAMP`    | Timestamp of last update.                             |                                   |

### 5. `commonwealth_scholarships`
Stores information about Commonwealth Scholarships awarded to students.

| **Column Name**                                         | **Data Type**  | **Description**                                            | **Key Type**                      |
| ------------------------------------------------------- | -------------- | ---------------------------------------------------------- | --------------------------------- |
| `uid12_student_commonwealth_scholarships_res_key`       | `VARCHAR(10)`  | Unique TCSI resource key for scholarship record.           | **PK**                            |
| `student_id`                                            | `BIGINT`       | Reference to student in `hep_students`.                    | **FK → hep_students(student_id)** |
| `e415_reporting_year`                                   | `INTEGER`      | Reporting year of the scholarship.                         |                                   |
| `e666_reporting_period`                                 | `SMALLINT`     | Eeporting period to which the individual data record relates.                  |                                   |
| `e545_commonwealth_scholarship_type`                    | `VARCHAR(1)`   | Type of Commonwealth Scholarship (‘A’, ‘B’, or ‘C’).       |                                   |
| `e526_commonwealth_scholarship_status_code`             | `VARCHAR(1)`   | Scholarship status (‘1’ = Active, ‘2’ = Deferred, etc.). |                                   |
| `e598_commonwealth_scholarship_amount`                  | `DECIMAL(8,2)` | Total scholarship amount.                                  |                                   |
| `e538_commonwealth_scholarship_termination_reason_code` | `VARCHAR(1)`   | Reason for scholarship termination (if applicable).        |                                   |
| `updated_at`                                            | `TIMESTAMP`    | Timestamp of last update.                                  |                                   |

---
## Course-related tables
Defines courses, course offerings, fields of education, and special interest courses.

### 6. `courses_of_study`
Master table for course-of-study types which reports data on what courses of study are offered by the provider.

| **Column Name**                           |  **Data Type** | **Description**                                                                                                                           | **Key Type / Constraints**              |
| ----------------------------------------- | -------------: | ----------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------- |
| `uid3_courses_of_study_res_key`           |  `VARCHAR(10)` | TCSI resource key for the course-of-study record.                                                                                         | **PK**                                  |
| `e533_course_of_study_code`               |  `VARCHAR(20)` | Official code for the course of study (institution/TCSI code).                                                                            | `NOT NULL`, **UNIQUE**                  |
| `e394_course_of_study_name`               | `VARCHAR(210)` | Full name/title of the course of study.                                                                                                   | `NOT NULL`                              |
| `e310_course_of_study_type`               |   `VARCHAR(2)` | Course type code ('01'= Higher Doctorate, '02'= Doctorate by research, etc.)              | `NOT NULL`, `CHECK` (enumerated values) |
| `e350_course_of_study_load`               | `DECIMAL(2,1)` | Typical load for the course of study (e.g. EFTSL or equivalent).                                                                          |                                         |
| `e455_combined_course_of_study_indicator` |      `BOOLEAN` | Indicator whether this course of study is a combined course (true/false). Note: sample imports require conversion from 0/1 → boolean. | `NOT NULL`                              |
| `updated_at`                              |    `TIMESTAMP` | Timestamp of last update for the record.                                                                                                  | `DEFAULT CURRENT_TIMESTAMP`             |

### 7. `hep_courses`
Report data on the courses offered by the provider

| **Column Name**                 |  **Data Type** | **Description**                                                                                               | **Key Type / Constraints**                                           |
| ------------------------------- | -------------: | ------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| `uid5_courses_res_key`          |  `VARCHAR(10)` | TCSI resource key for this specific course offering.                                                          | **PK**                                                               |
| `uid3_courses_of_study_res_key` |  `VARCHAR(10)` | FK to `courses_of_study.uid3_courses_of_study_res_key` — links specific course to its master course-of-study. | **FK → courses_of_study(uid3_courses_of_study_res_key)**, `NOT NULL` |
| `e307_course_code`              |  `VARCHAR(10)` | Institution/TCSI course code for this offering.                                                               | `NOT NULL`, **UNIQUE**                                               |
| `e308_course_name`              | `VARCHAR(210)` | Human-readable name/title of the course offering.                                                             | `NOT NULL`                                                           |
| `e596_standard_course_duration` | `DECIMAL(4,3)` | Standard duration for the  course of study for a full-time student.               |                                                                      |
| `e609_effective_from_date`      |         `DATE` | Date from which this course offering is effective.                                                            | `NOT NULL`                                                           |
| `e610_effective_to_date`        |         `DATE` | Date until which this course offering is effective (nullable if current).                                     |                                                                      |
| `updated_at`                    |    `TIMESTAMP` | Timestamp of last update for the record.                                                                      | `DEFAULT CURRENT_TIMESTAMP`                                          |

### 8. `special_interest_courses`
Report changes through time to the special course type for a given course. 

| **Column Name**                          | **Data Type** | **Description**                                                                         | **Key Type / Constraints**                             |
| ---------------------------------------- | ------------: | --------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| `uid30_special_interest_courses_res_key` | `VARCHAR(10)` | TCSI resource key for the special interest record.                                      | **PK**                                                 |
| `uid5_courses_res_key`                   | `VARCHAR(10)` | FK to `hep_courses.uid5_courses_res_key` — the course this special interest applies to. | **FK → hep_courses(uid5_courses_res_key)**, `NOT NULL` |
| `e312_special_course_type`               |  `VARCHAR(2)` | code which identifies courses of special interest to the department.   | `CHECK` (enumerated values)                            |
| `e609_effective_from_date`               |        `DATE` | From-date for the special-interest classification.                                      | `NOT NULL`                                             |
| `e610_effective_to_date`                 |        `DATE` | To-date for the special-interest classification.                                        |                                                        |
| `updated_at`                             |   `TIMESTAMP` | Timestamp of last update for the record.                                                | `DEFAULT CURRENT_TIMESTAMP`                            |

### 9. `course_fields_of_education`
Report changes through time to the fields of education for a given course. 

| **Column Name**                              | **Data Type** | **Description**                                                              | **Key Type / Constraints**                             |
| -------------------------------------------- | ------------: | ---------------------------------------------------------------------------- | ------------------------------------------------------ |
| `uid48_course_fields_of_education_res_key`   | `VARCHAR(10)` | TCSI resource key for the FoE record.                                        | **PK**                                                 |
| `uid5_courses_res_key`                       | `VARCHAR(10)` | FK to `hep_courses.uid5_courses_res_key` — course this FoE entry applies to. | **FK → hep_courses(uid5_courses_res_key)**, `NOT NULL` |
| `e461_field_of_education_code`               |  `VARCHAR(6)` | Field of Education (FoE) code (primary).                                     | `NOT NULL`                                             |
| `e462_field_of_education_supplementary_code` |  `VARCHAR(6)` | Supplementary/secondary FoE code (optional).                                 |                                                        |
| `e609_effective_from_date`                   |        `DATE` | From-date for this FoE classification.                                       | `NOT NULL`                                             |
| `e610_effective_to_date`                     |        `DATE` | To-date for this FoE classification.                                         |                                                        |
| `updated_at`                                 |   `TIMESTAMP` | Timestamp of last update for the record.                                     | `DEFAULT CURRENT_TIMESTAMP`                            |

## Course Admission related tables
Captures details of each student’s course admission, basis of admission, prior credits, and research/engagement records.

### 10. `course_admissions`
Report the admission of students into courses and provide data on aspects of the student's admission and engagement in the course.

| **Column Name**                             | **Data Type**  | **Description**                                                      | **Key / Constraint**                                   |
| ------------------------------------------- | -------------- | -------------------------------------------------------------------- | ------------------------------------------------------ |
| `course_admission_id`                       | `BIGINT`       | Unique identifier for each course admission record.                  | **PK**, `GENERATED ALWAYS AS IDENTITY`                 |
| `student_id`                                | `BIGINT`       | FK to `hep_students.student_id` — student being admitted.            | **FK → hep_students(student_id)**, `NOT NULL`          |
| `uid15_course_admissions_res_key`           | `VARCHAR(10)`  | TCSI resource key for this admission.                                | `NOT NULL`                                             |
| `uid5_courses_res_key`                      | `VARCHAR(10)`  | FK to `hep_courses.uid5_courses_res_key` — course being admitted to. | **FK → hep_courses(uid5_courses_res_key)**, `NOT NULL` |
| `e599_CourseOutcomeCode`                    | `VARCHAR(1)`   | Course outcome code (1–7).                                           | `CHECK (1–7)`                                          |
| `e592_CourseOutcomeDate`                    | `DATE`         | Date of course outcome.                                              |                                                        |
| `e534_course_of_study_commencement_date`    | `DATE`         | Start date of the course of study.                                   | `NOT NULL`                                             |
| `e330_attendance_type_code`                 | `VARCHAR(1)`   | Attendance type code (TCSI-defined).                                 |                                                        |
| `e591_hdr_thesis_submission_date`           | `DATE`         | Date of HDR thesis submission (if applicable).                       |                                                        |
| `e632_atar`                                 | `DECIMAL(4,2)` | Student ATAR score at admission.                                     |                                                        |
| `e605_selection_rank`                       | `DECIMAL(4,2)` | Selection rank for admission.                                        |                                                        |
| `e620_highest_attainment_code`              | `VARCHAR(3)`   | Highest prior education attainment code.                             |                                                        |
| `e594_hdr_primary_field_of_research_code`   | `VARCHAR(4)`   | Primary field of HDR research (if applicable).                       |                                                        |
| `e595_hdr_secondary_field_of_research_code` | `VARCHAR(4)`   | Secondary HDR field of research.                                     |                                                        |
| `updated_at`                                | `TIMESTAMP`    | Timestamp of last update.                                            | `DEFAULT CURRENT_TIMESTAMP`                            |
| `is_current`                                | `BOOLEAN`      | Indicates whether this is the current record for the student.        | `DEFAULT TRUE`                                         |

### 11. `hep_basis_for_admission`
Records the basis on which a student was admitted to a course.

| **Column Name**                     | **Data Type** | **Description**                                                         | **Key / Constraint**                                            |
| ----------------------------------- | ------------- | ----------------------------------------------------------------------- | --------------------------------------------------------------- |
| `uid17_basis_for_admission_res_key` | `VARCHAR(10)` | TCSI resource key for the admission basis record.                       | **PK**                                                          |
| `course_admission_id`               | `BIGINT`      | FK to `hep_course_admissions.course_admission_id`                       | **FK → hep_course_admissions(course_admission_id)**, `NOT NULL` |
| `e327_basis_for_admission_code`     | `VARCHAR(2)`  | Code representing basis for admission | `NOT NULL`                                |
| `updated_at`                        | `TIMESTAMP`   | Timestamp of last update.                                               | `DEFAULT CURRENT_TIMESTAMP`                                     |

### 12. `hep_course_prior_credits`
Tracks prior credit transfers for admitted students.

| **Column Name**                      | **Data Type**  | **Description**                                     | **Key / Constraint**                                            |
| ------------------------------------ | -------------- | --------------------------------------------------- | --------------------------------------------------------------- |
| `uid32_course_prior_credits_res_key` | `VARCHAR(10)`  | TCSI resource key for prior credit record.          | **PK**                                                          |
| `course_admission_id`                | `BIGINT`       | FK to `hep_course_admissions.course_admission_id`   | **FK → hep_course_admissions(course_admission_id)**, `NOT NULL` |
| `e560_credit_used_value`             | `DECIMAL(4,3)` |  EFTSL value of credit/RPL used towards the requirements of the course                        |                                                                 |
| `e561_credit_basis`                  | `VARCHAR(4)`   |  nature of the study for which credit /RPL was offered.           | `CHECK` (enumerated)                                            |
| `e566_credit_provider_code`          | `VARCHAR(4)`   | Code of institution/provider granting prior credit. |                                                                 |
| `updated_at`                         | `TIMESTAMP`    | Timestamp of last update.                           | `DEFAULT CURRENT_TIMESTAMP`                                     |

### 13. `course_specialisations`
Stores any specialisations linked to a student’s course admission.

| **Column Name**                        | **Data Type** | **Description**                                   | **Key / Constraint**                                            |
| -------------------------------------- | ------------- | ------------------------------------------------- | --------------------------------------------------------------- |
| `uid33_course_specialisations_res_key` | `VARCHAR(10)` | TCSI resource key for course specialisation.      | **PK**                                                          |
| `course_admission_id`                  | `BIGINT`      | FK to `hep_course_admissions.course_admission_id` | **FK → hep_course_admissions(course_admission_id)**, `NOT NULL` |
| `e463_specialisation_code`             | `VARCHAR(6)`  | Code of the course specialisation.                | `NOT NULL`                                                      |
| `updated_at`                           | `TIMESTAMP`   | Timestamp of last update.                         | `DEFAULT CURRENT_TIMESTAMP`                                     |

### 14. `hep_hdr_end_users_engagement`
Report one or more end-user engagements for a student who undertook a higher degree by research (HDR) course and the timeframes associated with each engagement.

| **Column Name**                          | **Data Type** | **Description**                                       | **Key / Constraint**                                            |
| ---------------------------------------- | ------------- | ----------------------------------------------------- | --------------------------------------------------------------- |
| `uid37_hdr_end_user_engagements_res_key` | `VARCHAR(10)` | TCSI resource key for HDR end-user engagement record. | **PK**                                                          |
| `course_admission_id`                    | `BIGINT`      | FK to `hep_course_admissions.course_admission_id`     | **FK → hep_course_admissions(course_admission_id)**, `NOT NULL` |
| `e593_hdr_end_user_engagement_code`      | `VARCHAR(2)`  | Engagement type code (e.g., ‘03’,’07’,’08’).          | `CHECK`                                          |
| `e609_hdr_end_user_engage_from_date`     | `DATE`        | Start date of engagement.                             | `NOT NULL`                                                      |
| `e610_hdr_end_user_engage_to_date`       | `DATE`        | End date of engagement.                               |                                                                 |
| `e798_hdr_days_of_engagement`            | `VARCHAR(4)`  | Total number of engagement days.                      |                                                                 |
| `updated_at`                             | `TIMESTAMP`   | Timestamp of last update.                             | `DEFAULT CURRENT_TIMESTAMP`                                     |

### 15. `rtp_scholarships`
Stores RTP scholarship information linked to course admissions.

| **Column Name**                  | **Data Type** | **Description**                                   | **Key / Constraint**                                            |
| -------------------------------- | ------------- | ------------------------------------------------- | --------------------------------------------------------------- |
| `uid35_rtp_scholarships_res_key` | `VARCHAR(10)` | TCSI resource key for RTP scholarship.            | **PK**                                                          |
| `course_admission_id`            | `BIGINT`      | FK to `hep_course_admissions.course_admission_id` | **FK → hep_course_admissions(course_admission_id)**, `NOT NULL` |
| `e487_rtp_scholarship_type`      | `VARCHAR(2)`  | Type of RTP scholarship (’09’,’10’,’11’).     | `NOT NULL`, `CHECK` (enumerated)                                |
| `e609_rtp_scholarship_from_date` | `DATE`        | Scholarship start date.                           | `NOT NULL`                                                      |
| `e610_rtp_scholarship_to_date`   | `DATE`        | Scholarship end date.                             |                                                                 |
| `updated_at`                     | `TIMESTAMP`   | Timestamp of last update.                         | `DEFAULT CURRENT_TIMESTAMP`                                     |

### 16. rtp_stipend
Stores stipend amounts linked to RTP scholarships (type '10').

| **Column Name**              | **Data Type**  | **Description**                                   | **Key / Constraint**                                            |
| ---------------------------- | -------------- | ------------------------------------------------- | --------------------------------------------------------------- |
| `uid18_rtp_stipends_res_key` | `VARCHAR(10)`  | TCSI resource key for RTP stipend record.         | **PK**                                                          |
| `course_admission_id`        | `BIGINT`       | FK to `hep_course_admissions.course_admission_id` | **FK → hep_course_admissions(course_admission_id)**, `NOT NULL` |
| `e623_rtp_stipend_amount`    | `DECIMAL(9,2)` | Amount of stipend awarded.                        |                                                                 |
| `e415_reporting_year`        | `INTEGER`      | Year of reporting for stipend.                    |                                                                 |
| `updated_at`                 | `TIMESTAMP`    | Timestamp of last update.                         | `DEFAULT CURRENT_TIMESTAMP`                                     |

## Student Loans related tables
Records OS-HELP and SA-HELP related details.

### 17. `oshelp`
Tracks OS-HELP loans for students enrolled in HEP courses.

| **Column Name**                         | **Data Type**   | **Description**                                                    | **Key / Constraint**                                            |
| --------------------------------------- | --------------- | ------------------------------------------------------------------ | --------------------------------------------------------------- |
| `oshelp_id`                             | `BIGINT`        | Unique identifier for OS-HELP loan record.                         | **PK**, `GENERATED ALWAYS AS IDENTITY`                          |
| `course_admission_id`                   | `BIGINT`        | FK to `hep_course_admissions.course_admission_id`                  | **FK → hep_course_admissions(course_admission_id)**, `NOT NULL` |
| `uid21_student_loans_res_key`           | `VARCHAR(10)`   | TCSI resource key for student loan record.                         | `NOT NULL`                                                      |
| `e527_help_debt_incurral_date`          | `DATE`          | Date the HELP debt was incurred.                                   | `NOT NULL`                                                      |
| `e490_student_status_code`              | `VARCHAR(3)`    | Student status code ('240', '241', '242').                         | `NOT NULL`, `CHECK` (enumerated)                                |
| `e521_study_period_commencement_date`   | `DATE`          | Start date of study period related to OS-HELP assistance..                                        | `NOT NULL`                                                      |
| `e553_study_primary_country_code`       | `VARCHAR(4)`    | Code of primary country of study.                                  |                                                                 |
| `e554_study_secondary_country_code`     | `VARCHAR(4)`    | Code of secondary country of study (if any).                       |                                                                 |
| `e583_language_study_commencement_date` | `DATE`          | Start date of language study (if applicable).                      |                                                                 |
| `e582_language_code`                    | `VARCHAR(4)`    | Code for language studied.                                         |                                                                 |
| `e528_payment_amount`                   | `DECIMAL(10,2)` | Payment amount for OS-HELP loan.                                   | `NOT NULL`                                                      |
| `e529_loan_fee`                         | `DECIMAL(7,2)`  | Loan fee for a unit of study.                                              | `NOT NULL`                                                      |
| `a130_loan_status`                      | `VARCHAR(20)`   | Status of the loan ('ACCEPTED','ADJUSTED','REJECTED', etc.). | `CHECK`                                            |
| `invalidated_flag`                      | `VARCHAR(1)`    | Flag indicating if the loan is invalidated ('Y'/'N').              | `CHECK` (Y/N)                                                   |
| `updated_at`                            | `TIMESTAMP`     | Timestamp of last update.                                          | `DEFAULT CURRENT_TIMESTAMP`                                     |
| `is_current`                            | `BOOLEAN`       | Indicates if this is the current record for the loan.              | `DEFAULT TRUE`                                                  |

### 18. `sahelp`
Tracks SA-HELP loans for students (linked to hep_students).

| **Column Name**                | **Data Type**  | **Description**                                                    | **Key / Constraint**                          |
| ------------------------------ | -------------- | ------------------------------------------------------------------ | --------------------------------------------- |
| `sahelp_id`                    | `BIGINT`       | Unique identifier for SA-HELP loan record.                         | **PK**, `GENERATED ALWAYS AS IDENTITY`        |
| `student_id`                   | `BIGINT`       | FK to `hep_students.student_id`                                    | **FK → hep_students(student_id)**, `NOT NULL` |
| `uid21_student_loans_res_key`  | `VARCHAR(10)`  | TCSI resource key for student loan record.                         | `NOT NULL`                                    |
| `e527_help_debt_incurral_date` | `DATE`         | Date the HELP debt was incurred.                                   | `NOT NULL`                                    |
| `e490_student_status_code`     | `VARCHAR(3)`   | Student status code ('280','281').                                 | `NOT NULL`, `CHECK`              |
| `e384_amount_charged`          | `DECIMAL(7,2)` | Amount charged for the loan.                                       | `NOT NULL`                                    |
| `e381_amount_paid_upfront`     | `DECIMAL(7,2)` | Amount paid upfront by the student.                                | `NOT NULL`                                    |
| `e558_help_loan_amount`        | `DECIMAL(7,2)` | Total HELP loan amount.                                            | `NOT NULL`                                    |
| `a130_loan_status`             | `VARCHAR(20)`  | Status of the loan ('ACCEPTED','ADJUSTED','REJECTED', etc.). | `NOT NULL`, `CHECK`              |
| `invalidated_flag`             | `VARCHAR(1)`   | Flag indicating if the loan is invalidated ('Y'/'N').              | `CHECK` (Y/N)                                 |
| `updated_at`                   | `TIMESTAMP`    | Timestamp of last update.                                          | `DEFAULT CURRENT_TIMESTAMP`                   |
| `is_current`                   | `BOOLEAN`      | Indicates if this is the current record for the loan.              | `DEFAULT TRUE`                                |

## Awards and Outcomes related tables
Report an award course completion for a student who does not have a course admissions record with the provider that relates to the course completion.

### 19. `aggregated_awards`
Stores aggregated award information for students at the course and unit level.

| **Column Name**                          | **Data Type** | **Description**                                                     | **Key / Constraint**                                   |
| ---------------------------------------- | ------------- | ------------------------------------------------------------------- | ------------------------------------------------------ |
| `uid47_aggregate_awards_res_key`         | `VARCHAR(10)` | TCSI resource key for aggregated award record.                      | **PK**                                                 |
| `student_id`                             | `BIGINT`      | FK to `hep_students.student_id`                                     | **FK → hep_students(student_id)**, `NOT NULL`          |
| `uid5_courses_res_key`                   | `VARCHAR(10)` | FK to `hep_courses.uid5_courses_res_key` — course related to award. | **FK → hep_courses(uid5_courses_res_key)**, `NOT NULL` |
| `e534_course_of_study_commencement_date` | `DATE`        | Commencement date of the course of study.                           |                                                        |
| `e599_course_outcome_code`               | `VARCHAR(1)`  | Course outcome code (1–7).                                          | `CHECK (1–7)`                                          |
| `e591_hdr_thesis_submission_date`        | `DATE`        | Date of HDR thesis submission (if applicable).                      |                                                        |
| `e592_course_outcome_date`               | `DATE`        | Date the course outcome was recorded.                               |                                                        |
| `e329_mode_of_attendance_code`           | `VARCHAR(1)`  | Mode of attendance code (1–7).                                      | `CHECK (1–7)`                                          |
| `e330_attendance_type_code`              | `VARCHAR(1)`  | Attendance type code (1–2).                                         | `CHECK (1–2)`                                          |
| `updated_at`                             | `TIMESTAMP`   | Timestamp of last update.                                           | `DEFAULT CURRENT_TIMESTAMP`                            |

### 20. `exit_awards`
Stores early exit award information for students who leave courses before completion.

| **Column Name**                   | **Data Type** | **Description**                                                                       | **Key / Constraint**                                            |
| --------------------------------- | ------------- | ------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| `uid46_early_exit_awards_res_key` | `VARCHAR(10)` | TCSI resource key for early exit award record.                                        | **PK**                                                          |
| `course_admission_id`             | `BIGINT`      | FK to `hep_course_admissions.course_admission_id` — course from which student exited. | **FK → hep_course_admissions(course_admission_id)**, `NOT NULL` |
| `uid5_courses_res_key`            | `VARCHAR(10)` | FK to `hep_courses.uid5_courses_res_key` — course related to award.                   | **FK → hep_courses(uid5_courses_res_key)**, `NOT NULL`          |
| `e599_course_outcome_code`        | `VARCHAR(1)`  | Course outcome code (1–7).                                                            | `CHECK (1–7)`                                                   |
| `e592_course_outcome_date`        | `DATE`        | Date the course outcome was recorded.                                                 |                                                                 |
| `updated_at`                      | `TIMESTAMP`   | Timestamp of last update.                                                             | `DEFAULT CURRENT_TIMESTAMP`                                     |

## Campus and location tables
Contains details of campuses and their linkages to courses and delivery locations.

### 21. `campuses`
Stores information about campuses where courses are delivered.

| **Column Name**            | **Data Type** | **Description**                        | **Key / Constraint**        |
| -------------------------- | ------------- | -------------------------------------- | --------------------------- |
| `uid2_campuses_res_key`    | `VARCHAR(10)` | TCSI resource key for campus.          | **PK**                      |
| `e525_campus_suburb`       | `VARCHAR(48)` | Suburb of the campus.                  | `NOT NULL`                  |
| `e644_campus_country_code` | `VARCHAR(4)`  | Country code of the campus location.   | `NOT NULL`                  |
| `e559_campus_postcode`     | `VARCHAR(4)`  | Postcode of the campus.                |                             |
| `e609_effective_from_date` | `DATE`        | Effective from date for campus record. | `NOT NULL`                  |
| `e610_effective_to_date`   | `DATE`        | Effective to date for campus record.   |                             |
| `updated_at`               | `TIMESTAMP`   | Timestamp of last update.              | `DEFAULT CURRENT_TIMESTAMP` |

### 22. `hep_courses_on_campuses`
Links courses to campuses and provides delivery details.

| **Column Name**                         | **Data Type** | **Description**                                               | **Key / Constraint**                                   |
| --------------------------------------- | ------------- | ------------------------------------------------------------- | ------------------------------------------------------ |
| `uid4_courses_on_campus_res_key`        | `VARCHAR(10)` | TCSI resource key for course-campus record.                   | **PK**                                                 |
| `uid2_campuses_res_key`                 | `VARCHAR(10)` | FK to `campuses.uid2_campuses_res_key`.                       | **FK → campuses(uid2_campuses_res_key)**, `NOT NULL`   |
| `uid5_courses_res_key`                  | `VARCHAR(10)` | FK to `hep_courses.uid5_courses_res_key`.                     | **FK → hep_courses(uid5_courses_res_key)**, `NOT NULL` |
| `e597_cricos_code`                      | `VARCHAR(7)`  | CRICOS code for international course registration.            |                                                        |
| `e569_campus_operation_type`            | `VARCHAR(2)`  | Campus operation type ('01','02').                    | `CHECK`                                                |
| `e570_principal_offshore_delivery_mode` | `VARCHAR(2)`  | Offshore delivery mode ('01','02','03','04'). | `CHECK`                                                |
| `e571_offshore_delivery_code`           | `VARCHAR(2)`  | Offshore delivery code ('01','02').                   | `CHECK`                                                |
| `e609_effective_from_date`              | `DATE`        | Effective from date.                                          | `NOT NULL`                                             |
| `e610_effective_to_date`                | `DATE`        | Effective to date.                                            |                                                        |
| `updated_at`                            | `TIMESTAMP`   | Timestamp of last update.                                     | `DEFAULT CURRENT_TIMESTAMP`                            |

### 23. `campus_course_fees_itsp`
Stores course fees for courses delivered at campuses.

| **Column Name**                            | **Data Type**  | **Description**                                                 | **Key / Constraint**                                                         |
| ------------------------------------------ | -------------- | --------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| `uid31_campus_course_fees_res_key`         | `VARCHAR(10)`  | TCSI resource key for campus course fees record.                | **PK**                                                                       |
| `uid4_courses_on_campus_res_key`           | `VARCHAR(10)`  | FK to `hep_courses_on_campuses.uid4_courses_on_campus_res_key`. | **FK → hep_courses_on_campuses(uid4_courses_on_campus_res_key)**, `NOT NULL` |
| `e536_course_fees_code`                    | `VARCHAR(1)`   | Course fees code ('0','1','2','3').                             | `CHECK`                                                                      |
| `e495_indicative_student_contribution_csp` | `VARCHAR(9)`   | Indicative student contribution for CSP.                        |                                                                              |
| `e496_indicative_tuition_fee_domestic_fp`  | `DECIMAL(9,2)` | Indicative tuition fee for domestic fee-paying students.        |                                                                              |
| `e609_effective_from_date`                 | `DATE`         | Effective from date.                                            | `NOT NULL`                                                                   |
| `updated_at`                               | `TIMESTAMP`    | Timestamp of last update.                                       | `DEFAULT CURRENT_TIMESTAMP`                                                  |

### 24. campuses_tac
Tracks TAC (Tuition Assurance Contribution) offers for courses on campuses.

| **Column Name**                       | **Data Type** | **Description**                                                 | **Key / Constraint**                                                         |
| ------------------------------------- | ------------- | --------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| `uid40_courses_on_campus_tac_res_key` | `VARCHAR(10)` | TCSI resource key for campus TAC record.                        | **PK**                                                                       |
| `uid4_courses_on_campus_res_key`      | `VARCHAR(10)` | FK to `hep_courses_on_campuses.uid4_courses_on_campus_res_key`. | **FK → hep_courses_on_campuses(uid4_courses_on_campus_res_key)**, `NOT NULL` |
| `e557_tac_offer_code`                 | `BOOLEAN`     | Indicates if TAC offer is available.                            |                                                                              |
| `updated_at`                          | `TIMESTAMP`   | Timestamp of last update.                                       | `DEFAULT CURRENT_TIMESTAMP`                                                  |

## Unit enrolments and AOU entities
Manages enrolment-level and academic organisation (AOU) records per unit.

### 25. `unit_enrolments`
Stores information about students’ enrolments in individual units of study.

| **Column Name**                          | **Data Type** | **Description**                                                         | **Key / Constraint**                                            |
| ---------------------------------------- | ------------- | ----------------------------------------------------------------------- | --------------------------------------------------------------- |
| `unit_enrolment_id`                      | `BIGINT`      | Unique identifier for each unit enrolment record.                       | **PK**, `GENERATED ALWAYS AS IDENTITY`                          |
| `course_admission_id`                    | `BIGINT`      | References the course admission to which this unit enrolment belongs.   | **FK → hep_course_admissions(course_admission_id)**, `NOT NULL` |
| `uid16_unit_enrolments_res_key`          | `VARCHAR(10)` | TCSI resource key for unit enrolment record.                            | `NOT NULL`                                                      |
| `e354_unit_of_study_code`                | `VARCHAR(12)` | Code identifying the unit of study.                                     |                                                                 |
| `e489_unit_of_study_census_date`         | `DATE`        | Census date for the unit of study.                                      |                                                                 |
| `e337_work_experience_in_industry_code`  | `VARCHAR(1)`  | Indicates if the unit involves work experience in industry.             |                                                                 |
| `e551_summer_winter_school_code`         | `VARCHAR(1)`  | Indicates if the unit was taken in summer or winter school.             |                                                                 |
| `e464_discipline_code`                   | `VARCHAR(6)`  | Field of education or discipline code for the unit.                     |                                                                 |
| `e355_unit_of_study_status_code`         | `VARCHAR(1)`  | Unit of study status code (1–6).                                        | `CHECK (IN ('1','2','3','4','5','6'))`                          |
| `e329_mode_of_attendance_code`           | `VARCHAR(1)`  | Mode of attendance code (1–7).                                          | `CHECK (IN ('1','2','3','4','5','6','7'))`                      |
| `e477_delivery_location_postcode`        | `INTEGER`     | Postcode of the delivery location.                                      |                                                                 |
| `e660_delivery_location_country_code`    | `VARCHAR(4)`  | Country code of the delivery location.                                  |                                                                 |
| `e490_student_status_code`               | `VARCHAR(3)`  | Student status code for the unit enrolment.                             |                                                                 |
| `e392_maximum_student_contribution_code` | `VARCHAR(1)`  | Maximum student contribution code (‘7’, ‘8’, ‘9’, or ‘S’).              | `CHECK (IN ('7','8','9','S'))`                                  |
| `e622_UnitOfStudyYearLongIndicator`      | `BOOLEAN`     | Indicates if the unit of study runs for the full year (`true`/`false`). | Converted from 0/1 when importing data from R.                  |
| `e600_unit_of_study_commencement_date`   | `DATE`        | Unit of study commencement date.                                        |                                                                 |
| `e601_unit_of_study_outcome_date`        | `DATE`        | Unit of study outcome date.                                             |                                                                 |
| `a111_is_deleted`                        | `BOOLEAN`     | Indicates if record is deleted (`true`/`false`).                        | Converted from 0/1 when importing data from R.                  |
| `reporting_year`                         | `INT`         | Enrolment year of the unit.                                           | `NOT NULL`                                                      |
| `updated_at`                             | `TIMESTAMP`   | Timestamp when the record was last updated.                             | `DEFAULT CURRENT_TIMESTAMP`                                     |
| `is_current`                             | `BOOLEAN`     | Flag to indicate if this is the current record.                         | `DEFAULT TRUE`                                                  |

### 26. unit_enrolments_aous
Stores Academic Organisational Unit (AOU) details for each unit enrolment.

| **Column Name**                     | **Data Type**   | **Description**                                              | **Key / Constraint**                                    |
| ----------------------------------- | --------------- | ------------------------------------------------------------ | ------------------------------------------------------- |
| `aou_id`                            | `BIGINT`        | Unique identifier for each AOU record.                       | **PK**, `GENERATED ALWAYS AS IDENTITY`                  |
| `unit_enrolment_id`                 | `BIGINT`        | References the unit enrolment this AOU record belongs to.    | **FK → unit_enrolments(unit_enrolment_id)**, `NOT NULL` |
| `uid19_unit_enrolment_aous_res_key` | `VARCHAR(10)`   | TCSI resource key for unit enrolment AOU record.             | `NOT NULL`                                              |
| `e333_aou_code`                     | `VARCHAR(3)`    | Academic Organisational Unit code.                           |                                                         |
| `aou_e339_eftsl`                    | `DECIMAL(10,9)` | Equivalent Full-Time Student Load (EFTSL) value for the AOU. |                                                         |
| `aou_e384_amount_charged`           | `DECIMAL(7,2)`  | Amount charged for the AOU.                                  |                                                         |
| `aou_e381_amount_paid_upfront`      | `DECIMAL(7,2)`  | Amount paid upfront for the AOU.                             |                                                         |
| `aou_e529_loan_fee`                 | `DECIMAL(7,2)`  | Loan fee amount related to the AOU.                          |                                                         |
| `aou_is_deleted`                    | `BOOLEAN`       | Indicates if record is deleted (`true`/`false`).             | Converted from 0/1 when importing data from R.          |
| `reporting_year`                    | `INT`           | Enrolment year of the record.                                | `NOT NULL`                                              |
| `updated_at`                        | `TIMESTAMP`     | Timestamp when the record was last updated.                  | `DEFAULT CURRENT_TIMESTAMP`                             |
| `is_current`                        | `BOOLEAN`       | Flag to indicate if this is the current record.              | `DEFAULT TRUE`                                          |

---

**Document Version:** 1.0  
**Prepared by:** *Group 3 – CITS5206 2025 Semester 2*  
**Date:** *October 2025*