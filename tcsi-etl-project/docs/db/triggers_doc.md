# Triggers - TCSI Extract Database

## 1. Overview

This document provides details of all database triggers implemented in the TCSI Extract Database (`tcsi_db`).
The triggers are designed to:
- Maintain record versioning using the `is_current` flag (ensuring only one current version exists for a given resource key).
- Ensure referential consistency between master and dependent tables when new versions of student or course admission records are inserted.
- Automatically cascade updates to dependent entities to reflect the latest student or course identifiers.

All triggers are written in PL/pgSQL and are executed AFTER INSERT operations on their respective tables.

## 2. Trigger Summary

| Trigger Name                                             | Table                                     | Function                                                  | Purpose                                                                                                               | Type         |
| -------------------------------------------------------- | ----------------------------------------- | --------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | ------------ |
| `trg_update_student_references`                          | `hep_students`                            | `update_student_references()`                             | Updates all related tables with the new `student_id` when a new student version is inserted.                          | AFTER INSERT |
| `trg_update_course_references`                           | `hep_course_admissions`                   | `update_course_references()`                              | Updates all related tables with the new `course_admission_id` when a new course admission record version is inserted. | AFTER INSERT |
| `trg_hep_student_citizenships_is_current`                | `hep_student_citizenships`                | `fn_hep_student_citizenships_is_current()`                | Ensures only one current citizenship record exists per `uid10_student_citizenships_res_key`.                          | AFTER INSERT |
| `trg_hep_student_disabilities_is_current`                | `hep_student_disabilities`                | `fn_hep_student_disabilities_is_current()`                | Ensures only one current disability record exists per `uid11_student_disabilities_res_key`.                           | AFTER INSERT |
| `trg_oshelp_is_current`                                  | `oshelp`                                  | `fn_oshelp_is_current()`                                  | Maintains single current OS-HELP record per `uid21_student_loans_res_key`.                                            | AFTER INSERT |
| `trg_sahelp_is_current`                                  | `sahelp`                                  | `fn_sahelp_is_current()`                                  | Maintains single current SA-HELP record per `uid21_student_loans_res_key`.                                            | AFTER INSERT |
| `trg_student_contacts_first_reported_address_is_current` | `student_contacts_first_reported_address` | `fn_student_contacts_first_reported_address_is_current()` | Ensures only one current address record per `student_id`.                                                             | AFTER INSERT |
| `trg_unit_enrolments_is_current`                         | `unit_enrolments`                         | `fn_unit_enrolments_is_current()`                         | Maintains single current enrolment record per `uid16_unit_enrolments_res_key`.                                        | AFTER INSERT |
| `trg_unit_enrolments_aous_is_current`                    | `unit_enrolments_aous`                    | `fn_unit_enrolments_aous_is_current()`                    | Maintains single current AOU enrolment record per `uid19_unit_enrolment_aous_res_key`.                                | AFTER INSERT |

## 3. Detailed Trigger Descriptions

### 3.1. Student Reference Update Trigger

**File**: `10_triggerinfo-student.sql`  
**Function**: `update_student_references()`  
**Trigger**: `trg_update_student_references`  
**Table**: `hep_students`  
**Event**: AFTER INSERT

**Purpose:**  
When a new hep_students record is inserted, this trigger ensures that:
- Any previous version of the same student (uid8_students_res_key) is marked as `is_current = false`.
- All dependent tables referencing the old `student_id` are updated to point to the new one.

**Affected Tables:**
- `hep_student_citizenships`
- `hep_student_disabilities`
- `student_contacts_first_reported_address`
- `commonwealth_scholarships`
- `hep_course_admissions`
- `sahelp`
- `aggregated_awards`

**Error Handling:**  
If any operation fails, an exception is raised and the transaction is rolled back with a detailed error message.

### 3.2. Course Reference Update Trigger

**File**: `11_triggerinfo-courses.sql`  
**Function**: `update_course_references()`  
**Trigger**: `trg_update_course_references`  
**Table**: `hep_course_admissions`  
**Event**: AFTER INSERT

**Purpose:**  
Maintains referential integrity for course-related data by:
- Setting the previous is_current record to false for the same uid15_course_admissions_res_key.
- Updating all dependent tables that reference the old course_admission_id with the new ID.

**Affected Tables:**
- `hep_basis_for_admission`
- `hep_course_prior_credits`
- `course_specialisations`
- `hep_hdr_end_users_engagement`
- `rtp_scholarships`
- `rtp_stipend`
- `oshelp`
- `exit_awards`
- `unit_enrolments`

**Error Handling:**  
All exceptions are caught, and the trigger raises a descriptive error message.

### 3.3. Versioning Triggers for is_current Maintenance

**File**: `12_multiple_is_current_triggers.sql`

Each of these triggers ensures that for any resource key, only one record remains `is_current = true`.

| Table                                     | Function                                                  | Key Field                            | Logic                                                   |
| ----------------------------------------- | --------------------------------------------------------- | ------------------------------------ | ------------------------------------------------------- |
| `hep_student_citizenships`                | `fn_hep_student_citizenships_is_current()`                | `uid10_student_citizenships_res_key` | Marks old records with same UID as not current.         |
| `hep_student_disabilities`                | `fn_hep_student_disabilities_is_current()`                | `uid11_student_disabilities_res_key` | Maintains single current disability record per student. |
| `oshelp`                                  | `fn_oshelp_is_current()`                                  | `uid21_student_loans_res_key`        | Maintains single current OS-HELP record per loan key.   |
| `sahelp`                                  | `fn_sahelp_is_current()`                                  | `uid21_student_loans_res_key`        | Maintains single current SA-HELP record per loan key.   |
| `student_contacts_first_reported_address` | `fn_student_contacts_first_reported_address_is_current()` | `student_id`                         | Ensures only one address record is current.             |
| `unit_enrolments`                         | `fn_unit_enrolments_is_current()`                         | `uid16_unit_enrolments_res_key`      | Maintains single current enrolment record.              |
| `unit_enrolments_aous`                    | `fn_unit_enrolments_aous_is_current()`                    | `uid19_unit_enrolment_aous_res_key`  | Maintains single current AOU enrolment record.          |

**Trigger Type**: AFTER INSERT
**Error Handling**: Each trigger includes its own exception block to provide detailed error messages for easier debugging.

## 4. Execution Order & Dependencies

- **Student triggers** execute first when new student data is inserted.
- **Course triggers** follow, updating course-related records that may depend on updated student records.
- **is_current triggers** execute individually per table to maintain data integrity on insert operations.
All triggers are AFTER INSERT to ensure that the new record has a valid primary key before updates cascade.

## 5. Maintenance and Rollback

To remove or update a trigger safely:
```sql
-- Drop a specific trigger
DROP TRIGGER IF EXISTS trg_update_student_references ON hep_students;

-- Drop the associated function
DROP FUNCTION IF EXISTS update_student_references();

-- Recreate trigger (if modified)
CREATE TRIGGER trg_update_student_references
AFTER INSERT ON hep_students
FOR EACH ROW
EXECUTE FUNCTION update_student_references();
```
Always ensure function dependencies are dropped after their triggers.

## 6. Testing and Validation
**Recommended Tests:**
1. Insert a new student with an existing `uid8_students_res_key` — old record should become `is_current = false`.
2. Verify that all dependent tables now reference the new `student_id`.
3. Repeat for course admissions and confirm all linked records have updated `course_admission_id`.
4. For any `is_current` triggers, insert multiple versions of the same UID and verify that only the latest one remains current.
5. Review rollback behavior by simulating a constraint violation to ensure the trigger raises the expected exception.

## 7. 7. Benefits

- Ensures data consistency across related entities.
- Automatically manages record versioning.
- Reduces risk of orphaned references.
- Supports TCSI compliance by maintaining an accurate historical record of student and course changes.

---

**Document Version:** 1.0  
**Prepared by:** *Group 3 – CITS5206 2025 Semester 2*  
**Date:** *October 2025*