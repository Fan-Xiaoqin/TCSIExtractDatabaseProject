# TCSI Extract Database – Schema Documentation

## 1. Introduction

The **TCSI Extract Database** has been designed to store and manage data required for higher education reporting in alignment with the **Tertiary Collection of Student Information (TCSI)** standards.

This schema serves as the foundation for generating validated data extracts for submission and analysis. It captures key information related to **students, courses, admissions, campuses, enrolments, scholarships, awards and loans**.

The design was developed based on:
- The **TCSI Specification** provided at [https://www.tcsisupport.gov.au/](https://www.tcsisupport.gov.au/)
- The **Entity–Relationship Diagram (ERD)** created during the design phase
- **Client-specific requirements** to maintain a close resemblance to the TCSI structure

> **Note:**  
> The client required the database structure to align closely with TCSI table definitions.  
> Therefore, normalization was applied where feasible, but full normalization was limited to preserve compatibility with TCSI’s standard structure.

---

## 2. Design Overview

| Item | Description |
|------|--------------|
| **Database Type** | PostgreSQL |
| **Schema Name** | `tcsi_db` |
| **Design Approach** | Relational schema (partially normalized to align with TCSI specification) |
| **Primary Purpose** | Support TCSI-compliant data storage, extraction, and validation |
| **Data Origin** | Derived from internal higher education data sources |
| **Update Tracking** | `updated_at` timestamp field included in all tables |
| **Record Status Tracking** | `is_current` field identifies active records where overwriting is restricted |
| **Referential Integrity** | Enforced through foreign key constraints |
| **Code Validation** | Enforced through check constraints following TCSI codesets |

---

## 3. Entity Groups

| Group | Description |
|-------|--------------|
| **Student-Related Tables** | Core student demographics, citizenships, disabilities, and addresses |
| **Course-Related Tables** | Courses, fields of education, and special interests |
| **Course Admission-Related Tables** | Course enrolment, admission basis, prior credits, and specialisations |
| **Scholarships and Loans** | Commonwealth, RTP, OS-HELP, and SA-HELP funding records |
| **Awards and Outcomes** | Exit awards and aggregated award outcomes |
| **Campus and Location Tables** | Campus definitions and course delivery information |
| **Unit Enrolments and AOUs** | Unit-level enrolment details and academic organisational units |

---

## 4. Design Principles and Conventions

- **TCSI Alignment:** Field names and codes adhere to TCSI element identifiers (e.g., `e313_student_identification_code`, `e592_course_outcome_date`).
- **Effective Date Ranges:** Many tables include `e609_effective_from_date` and `e610_effective_to_date` to track record validity.
- **Historical Retention:** Records with `is_current = FALSE` remain stored for auditing and reporting history.
- **Data Integrity:** Foreign keys and `CHECK` constraints enforce relationships and permissible values.
- **Boolean Conversion:**  
  - Numeric (0/1) → Boolean (`FALSE`/`TRUE`)  
  - Character ('Y'/'N') → Boolean (`TRUE`/`FALSE`)  
  These conversions are applied during ETL processing from source data.
- **Indexes:** Strategic indexes have been defined on frequently queried fields (e.g. student identifiers) to optimize query performance.
- **Consolidated View:** A “wide table” database view has been created to simplify analytical reporting, combining key fields from multiple tables.

---

## 5. Key Entities and Relationships

### 5.1 `hep_students`
**Purpose:** Master table for student information.  
**Primary Key:** `student_id`

**Relationships:**
- 1 → N with `hep_student_citizenships`, `hep_student_disabilities`, `hep_course_admissions`, `commonwealth_scholarships`, `hep_course_admissions` and `sahelp`
- 1 → 1 with `student_contacts_first_reported_address`

**Highlights:**
- Captures demographic and identification fields (e.g., CHESSN, USI)
- Includes gender, ATSI, and country of birth codes validated per TCSI standards

---

### 5.2 `hep_student_citizenships`
**Purpose:** Track citizenship or residency status history for each student.  
**Foreign Key:** `student_id → hep_students(student_id)`  
**Constraint:** Unique combination of `(student_id, e358_citizen_resident_code, e609_effective_from_date)`  

---

### 5.3 `hep_student_disabilities`
**Purpose:** Record student disability information and history.  
**Foreign Key:** `student_id → hep_students(student_id)`  
Includes time-bounded validity through effective date fields.

---

### 5.4 `hep_course_admissions`
**Purpose:** Core table linking students to their enrolled courses.  
**Foreign Keys:**  
- `student_id → hep_students(student_id)`  
- `uid5_courses_res_key → hep_courses(uid5_courses_res_key)`

**Related Tables:**  
`hep_basis_for_admission`, `hep_course_prior_credits`, `course_specialisations`, `rtp_scholarships`, `oshelp`, `unit_enrolments`

---

### 5.5 `hep_courses`
**Purpose:** Define specific course offerings and structures.  
**Linked To:** `courses_of_study` via `uid3_courses_of_study_res_key`  
Includes effective date range to mark valid course periods.

---

### 5.6 `courses_of_study`
**Purpose:** Define generic course types (e.g., Bachelor, Diploma).  
**Field Example:** `e310_course_of_study_type` — standard TCSI classification code.

---

### 5.7 `rtp_scholarships` and `rtp_stipend`
**Purpose:** Represent Research Training Program (RTP) scholarships and associated stipends.  
**Foreign Key:** `course_admission_id → hep_course_admissions(course_admission_id)`  
RTP stipends apply only to scholarships of type `'10'`.

---

### 5.8 `oshelp` and `sahelp`
**Purpose:** Capture loan information for overseas study (`OS-HELP`) and Student Services fees (`SA-HELP`).  
**Relationships:**  
- `oshelp` links to `hep_course_admissions`  
- `sahelp` links to `hep_students`

---

### 5.9 `campuses` and `hep_courses_on_campuses`
**Purpose:** Define course delivery locations, CRICOS codes, and offshore delivery modes.  
**Relationship:**  
`hep_courses_on_campuses` joins courses (`hep_courses`) with campuses (`campuses`).

---

### 5.10 `unit_enrolments` and `unit_enrolments_aous`
**Purpose:** Represent enrolments per unit of study and their Academic Organisational Units (AOUs).  
**Foreign Keys:**  
- `course_admission_id → hep_course_admissions(course_admission_id)`  
- `unit_enrolment_id → unit_enrolments(unit_enrolment_id)` (for AOUs)

**Fields:** Include codes for mode of attendance, contribution category, and study year.

---

## 6. Historical Tracking and Record Validity

- **`is_current`** flags active records.  
- Older versions are preserved (`is_current = FALSE`) for traceability.  
- **Effective dates** (`e609_`, `e610_`) define time-bounded validity across entities.

---

## 7. Data Integrity and Validation

| Type | Description |
|------|--------------|
| **Foreign Key Constraints** | Maintain referential consistency |
| **Check Constraints** | Enforce TCSI-permitted code values |
| **Unique Constraints** | Prevent duplicate entries in temporal tables |
| **Defaults** | `updated_at DEFAULT CURRENT_TIMESTAMP` for auditability |

---

## 8. Supporting Documents

The following supporting materials provide further detail and are referenced from this main schema document:

1. **Data Dictionary**  
   Describes all entities, attributes, data types, and code value meanings in alignment with TCSI specifications.  
   *(See: `db_data_dictionary_doc.md`)*

2. **Indexes Documentation**  
   Lists indexing strategies for performance optimization, including rationale and sample index definitions.  
   *(See: `indexes_doc.md`)*

3. **Consolidated View Documentation**  
   Defines the analytical “wide table” database view combining key student, course, and enrolment information for reporting.  
   *(See: `consolidated_view_doc.md`)*

4. **Triggers Documentation**  
   Details all database triggers implemented to maintain data integrity, version control, and referential consistency across student, course, and enrolment entities.  
   (See: `triggers_doc.md`)

5. **Role Based Access Setup Documentation**
   Describes how to set up roles and permissions to control data access and maintain security across user groups.
   (See: `roles_and_permissions_setup_doc.md`)

---

## 9. References

- **TCSI Support and Specification:** [https://www.tcsisupport.gov.au/](https://www.tcsisupport.gov.au/)
- **Entity–Relationship Diagram (ERD):** Internal design file developed during database planning phase

---

## 10. Future Enhancements

- Addition of more derived views for analytical reporting
- Integration of metadata versioning for schema change tracking

---

**Document Version:** 1.0  
**Prepared by:** *Group 3 – CITS5206 2025 Semester 2*  
**Date:** *October 2025*