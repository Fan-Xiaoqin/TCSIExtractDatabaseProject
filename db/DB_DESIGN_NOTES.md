# Database Design Notes

Version: 1.0  
Date: 22nd September 2025  

This document captures design decisions, questions, and rationale for the TCSI Extract Database schema.

---

## HEP Students Tables

### hep_students
- Question: Do we need `start_date` / `end_date`?  
  - Suggestion: May use `as_at_month` like in `hep_course_admissions` table.  

### hep_student_citizenships
- Followed the ERD structure.  

### hep_student_disabilities
- Followed the ERD structure.  

### student_contacts_first_reported_address
- Question: Can we use `student_key` as the primary key?  
- Current design: separate identity column (`first_address_id`) used.  

### commonwealth_scholarships
- Followed the ERD structure.  

---

## Courses Tables

### courses_of_study
- `E455_combined_course_of_study_indicator` BOOLEAN  
  - Sample data uses 0/1; need conversion to TRUE/FALSE when importing from R.  

### hep_courses
- Linked to `courses_of_study`.  

### special_interest_courses
- Linked to `hep_courses`.  

### course_fields_of_education
- Linked to `hep_courses`.  

---

## Course Admission Tables

### hep_course_admissions
- Added `e599_CourseOutcomeCode` and `e592_CourseOutcomeDate` based on sample data and TCSI specifications.  

### hep_basis_for_admission
- Followed the ERD structure. 

### hep_course_prior_credits
- Followed the ERD structure.  

### course_specialisations
- Followed the ERD structure.

### hep_hdr_end_users_engagement
- Followed the ERD structure.

### rtp_scholarships
- Followed the ERD structure. 

### rtp_stipend
- Should link to `rtp_scholarships` of type '10'.  

---

## Student Loans Tables

### oshelp
- `a130_loan_status` included CHECK constraint based on valid A130 codes referring to TCSI.  
- `invalidated_flag` VARCHAR(1) CHECK (`'Y','N'`)  
  - Alternative: BOOLEAN for cleaner logic, transform `'Y' → TRUE, 'N' → FALSE` when importing from R.  

### sahelp
- Linked to `hep_students` instead of `course_admissions` (per TCSI spec).  
- Same `invalidated_flag` logic as above.  

---

## Awards and Outcomes Tables

### aggregated_awards
- Linked to student and course, not course admission (TCSI spec).  
- Includes `e534_course_of_study_commencement_date` since no course admission record exists related to this.  

### exit_awards
- Linked to course admission and course to reflect the award’s defined course (even if different from admission) reffering to TCSI specification.  
- Rationale: Exit awards may differ from original admission course but need course definition for reporting.  

---

## Campuses and Location Tables

### campuses
- Included `e609_effective_from_date` and `e610_effective_to_date` to specify validity period.  

### hep_courses_on_campuses
- Campus related effective dates moved to `campuses` table.  

### campus_course_fees_itsp
- Followed the ERD structure.  

### campuses_tac
- Followed the ERD structure. 

---

## Unit Enrolments Tables

### unit_enrolments
- Added missing fields per TCSI spec:  
  - `e622_unit_of_study_year_long_indicator`  
  - `e446_remission_reason_code`  
  - `e339_eftsl`  
  - Financial fields: `e384_amount_charged`, `e381_amount_paid_upfront`, `e558_help_loan_amount`, `e529_loan_fee`  
- PK: `(uid16_unit_enrolments_res_key, as_at_month)`  
  - Suggestion: use `YYYYMM` format for `as_at_month` to avoid clashes across years.  
- Removed fields not relevant: `a130_loan_status`, `uid21_student_loans_res_key`, 
- Any specific reasons for removing `e662_adjustedLoanAmount`, `e663_adjusted_loan_fee` from ERD? Noted that these fields only appeared in this (HEP_units-AOUs) tables.  

### unit_enrolments_aous
- Followed the ERD structure. 

---

## Indexes for Performance

- `idx_course_admissions_student` on `hep_course_admissions(student_key)`  
  - Speeds up queries filtering or joining by student, e.g., retrieving all course admissions for a student.

- `idx_course_admissions_course` on `hep_course_admissions(uid5_courses_res_key)`  
  - Speeds up queries filtering or joining by course, e.g., finding all students enrolled in a course.

- `idx_courses_code` on `hep_courses(e307_course_code)`  
  - Optimizes lookups by course code, often used in reporting or joining with admissions.

- `idx_courses_of_study_code` on `courses_of_study(e533_course_of_study_code)`  
  - Supports quick retrieval of course-of-study information by code.

- `idx_students_identification_code` on `hep_students(e313_student_identification_code)`  
  - Helps locate a student by their identification code efficiently.

- `idx_students_chessn` on `hep_students(e488_chessn)`  
  - Speeds up searches using the CHESSN (Commonwealth Higher Education Student Support Number).

- `idx_students_usi` on `hep_students(e584_usi)`  
  - Optimizes queries involving the USI (Unique Student Identifier).

- `idx_unit_enrolments_unit` on `unit_enrolments(e354_unit_of_study_code)`  
  - Useful for filtering/grouping enrolments by unit of study.

- `idx_unit_enrolments_year_unit` on `(reporting_year, e354_unit_of_study_code)`  
  - Improves performance for queries combining year and unit code, e.g., yearly reports.

- `idx_unit_enrolments_aous_aou` on `unit_enrolments_aous(e333_aou_code)`  
  - Optimizes queries on Academic Organisation Units for enrolments, e.g., reporting by AOU.
  
---

## General Notes
- All decisions follow TCSI Extract specifications unless noted.  
- Any deviations or questions highlighted above can be discussed in team review.  
