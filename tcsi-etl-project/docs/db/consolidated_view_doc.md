# Consolidated View: vw_consolidated_student_enrolment_data

## 1. Overview

The `vw_consolidated_student_enrolment_data` is a **PostgreSQL view** designed to provide a **consolidated, analysis-ready dataset** combining key fields from multiple HEP (Higher Education Provider) tables.  

The view integrates student, course admission, unit enrolment, and AOU-level information into a single, flattened dataset suitable for **reporting, KPI tracking, and dashboard analytics**.  

This reduces the need for analysts to perform complex joins and transformations, providing a **consistent, maintainable, and reusable data source**.

---

## 2. Purpose

The view was created to:

- Combine key student, course, and enrolment data into one consolidated dataset.
- Support regular KPI tracking such as enrolment counts, completions, and EFTSL calculations.
- Enable seamless integration with **business intelligence tools** and dashboards.
- Reduce complexity in queries by flattening hierarchical relationships.

---

## 3. Source Tables

| Table | Purpose |
|-------|----------|
| `hep_students` | Core student demographic and identity information. |
| `hep_course_admissions` | Student course enrolment details, including ATAR, commencement, and outcomes. |
| `unit_enrolments` | Unit-level enrolment information per course admission, including unit status, commencement, and outcome. |
| `unit_enrolments_aous` | Academic Organisation Unit (AOU) details for each unit enrolment, including EFTSL, fees, and reporting year. |


>`hep_students`  →  `hep_course_admissions`  →  `unit_enrolments`  →  `unit_enrolments_aous`
---

## 4. Design Choices

### 4.1 Joins

| Join Relationship | Type | Rationale |
|--------------------|------|------------|
| `hep_students → hep_course_admissions` | INNER JOIN | All students in the view must have at least one course admission. |
| `hep_course_admissions → unit_enrolments` | INNER JOIN | Only course admissions with unit enrolments are included. |
| `unit_enrolments → unit_enrolments_aous` | LEFT JOIN | Preserves unit enrolments even when no AOU record exists. |


### 4.2 Column Selection

- Only **key analytical fields** are included.
- Conflicting column names (e.g., `is_current`, `updated_at`) are **aliased** with source prefixes.
- Redundant or system-specific fields are excluded for performance and clarity.

### 4.3 Naming Conventions

- Columns are aliased to show their origin, e.g., `student_is_current`, `admission_is_current`.
- Naming avoids ambiguity and supports easier referencing in analysis scripts.

### 4.4 Performance Considerations

- The view is **not materialized**. It reflects the latest data from source tables.
- For very large datasets, users should **filter by year or current status** to improve performance.

---

## 5. Assumptions

- Only students with at least one course admission and one unit enrolment appear in the view.
- Some unit enrolments may not have related AOU records (NULLs expected).
- Selected fields are those relevant to current KPI and reporting needs.
- Analysts can filter on `is_current` or `reporting_year` as needed.
- Code-based or boolean flags are retained in their original format for consistency.

---

## 6. View Structure

### Sample Columns

| Column | Description |
|---------|-------------|
| `student_id` | Unique internal identifier for the student. |
| `student_code` | Official student identification code. |
| `first_name` / `family_name` | Student name details. |
| `gender`, `atsi_code`, `dob`, `country_of_birth` | Demographic information. |
| `course_admission_id` | Unique identifier for course admission. |
| `course_res_key` | Course reference key. |
| `commencement_date` | Course commencement date. |
| `atar`, `selection_rank` | Admission-related performance indicators. |
| `course_outcome_code`, `course_outcome_date` | Course completion information. |
| `unit_enrolment_id` | Unique identifier for unit enrolment. |
| `unit_code`, `census_date`, `unit_status_code` | Unit-level details. |
| `aou_code`, `eftsl`, `amount_charged` | Academic Organisation Unit (AOU) details. |
| `student_is_current`, `admission_is_current`, `unit_is_current`, `aou_is_current` | Status flags. |
| `student_updated_at`, `admission_updated_at`, `unit_updated_at`, `aou_updated_at` | Update timestamps. |

---

## 7. Usage Examples

### Filter for active enrolments in 2024

```sql
SELECT * 
FROM vw_consolidated_student_enrolment_data
WHERE unit_is_current = TRUE
  AND reporting_year = 2024;
```

### Aggregate EFTSL per student
```sql
SELECT student_id, SUM(eftsl) AS total_eftsl
FROM vw_consolidated_student_enrolment_data
GROUP BY student_id;
```

### Count students per course
```sql
SELECT course_res_key, COUNT(DISTINCT student_id) AS student_count
FROM vw_consolidated_student_enrolment_data
GROUP BY course_res_key;
```

## 8. Benefits to Client

- Provides a single source of truth for student, course, and enrolment relationships.
- Simplifies analytical workflows and KPI tracking.
- Reduces dependency on repeated complex SQL joins.
- Can be easily extended or versioned to include additional analytical metrics.

## 9. Future Enhancements

- Incorporate additional related tables (e.g., scholarships, funding, awards).
- Add derived metrics such as:
    - `student_age`
    - `total_fee_per_student`
    - `unit_duration_days`
- Create a materialized view for large datasets to improve query performance.

## 10. SQL Definition

```sql
CREATE OR REPLACE VIEW vw_consolidated_student_enrolment_data AS
SELECT
    -- Student Information
    s.student_id,
    s.e313_student_identification_code AS student_code,
    s.e403_student_given_name_first AS first_name,
    s.e402_student_family_name AS family_name,
    s.e315_gender_code AS gender,
    s.e316_atsi_code AS atsi_code,
    s.e314_date_of_birth AS dob,
    s.e346_country_of_birth_code AS country_of_birth,
    s.e348_language_spoken_at_home_code AS language_home,
    s.e347_arrival_in_australia_year AS arrival_year,
    s.e572_year_left_school AS year_left_school,
    s.is_current AS student_is_current,

    -- Course Admission
    ca.course_admission_id,
    ca.uid5_courses_res_key AS course_res_key,
    ca.e534_course_of_study_commencement_date AS commencement_date,
    ca.e632_atar AS atar,
    ca.e605_selection_rank AS selection_rank,
    ca.e599_courseoutcomecode AS course_outcome_code,
    ca.e592_courseoutcomedate AS course_outcome_date,
    ca.e330_attendance_type_code AS attendance_type_code,
    ca.e591_hdr_thesis_submission_date AS thesis_submission_date,
    ca.is_current AS admission_is_current,

    -- Unit Enrolment
    ue.unit_enrolment_id,
    ue.uid16_unit_enrolments_res_key AS unit_res_key,
    ue.e354_unit_of_study_code AS unit_code,
    ue.e489_unit_of_study_census_date AS census_date,
    ue.e329_mode_of_attendance_code AS mode_of_attendance_code,
    ue.e355_unit_of_study_status_code AS unit_status_code,
    ue.e600_unit_of_study_commencement_date AS unit_commencement_date,
    ue.e601_unit_of_study_outcome_date AS unit_outcome_date,
    ue.reporting_year,
    ue.e622_UnitOfStudyYearLongIndicator AS is_year_long,
    ue.a111_is_deleted AS is_deleted_unit,
    ue.is_current AS unit_is_current,

    -- AOU
    aou.aou_id,
    aou.uid19_unit_enrolment_aous_res_key AS aou_res_key,
    aou.e333_aou_code AS aou_code,
    aou.aou_e339_eftsl AS eftsl,
    aou.aou_e384_amount_charged AS amount_charged,
    aou.aou_e381_amount_paid_upfront AS amount_paid_upfront,
    aou.aou_e529_loan_fee AS loan_fee,
    aou.aou_is_deleted AS aou_is_deleted,
    aou.reporting_year AS aou_reporting_year,
    aou.is_current AS aou_is_current,

    -- Audit
    s.updated_at AS student_updated_at,
    ca.updated_at AS admission_updated_at,
    ue.updated_at AS unit_updated_at,
    aou.updated_at AS aou_updated_at

FROM hep_students s
JOIN hep_course_admissions ca
    ON s.student_id = ca.student_id
JOIN unit_enrolments ue
    ON ca.course_admission_id = ue.course_admission_id
LEFT JOIN unit_enrolments_aous aou
    ON ue.unit_enrolment_id = aou.unit_enrolment_id;
```

---

**Document Version:** 1.0  
**Prepared by:** *Group 3 – CITS5206 2025 Semester 2*  
**Date:** *October 2025*