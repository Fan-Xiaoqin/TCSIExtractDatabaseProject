-- Step 1: Create the stored procedure
CREATE OR REPLACE FUNCTION update_student_references()
RETURNS TRIGGER AS $$
DECLARE
    v_old_student_id INTEGER;
    v_affected_rows INTEGER;
BEGIN
    -- Find existing current record with same uid8_students_res_key
    SELECT student_id INTO v_old_student_id
    FROM hep_students
    WHERE uid8_students_res_key = NEW.uid8_students_res_key
      AND is_current = true
      AND student_id != NEW.student_id;  -- Exclude the newly inserted record

    -- If no existing current record found, this is a new student - proceed normally
    IF v_old_student_id IS NULL THEN
        RETURN NEW;
    END IF;

    -- Set old record's is_current to false
    UPDATE hep_students
    SET is_current = false
    WHERE student_id = v_old_student_id;

    -- Update referenced tables to point to new student_id

    -- 1. Update hep_student_citizenships
    UPDATE hep_student_citizenships
    SET student_id = NEW.student_id
    WHERE student_id = v_old_student_id;

    -- 2. Update hep_student_disabilities
    UPDATE hep_student_disabilities
    SET student_id = NEW.student_id
    WHERE student_id = v_old_student_id;

    -- 3. Update student_contacts_first_reported_address
    UPDATE student_contacts_first_reported_address
    SET student_id = NEW.student_id
    WHERE student_id = v_old_student_id;

    -- 4. Update commonwealth_scholarships
    UPDATE commonwealth_scholarships
    SET student_id = NEW.student_id
    WHERE student_id = v_old_student_id;

    -- 5. Update hep_course_admissions
    UPDATE hep_course_admissions
    SET student_id = NEW.student_id
    WHERE student_id = v_old_student_id;

    -- 6. Update sahelp
    UPDATE sahelp
    SET student_id = NEW.student_id
    WHERE student_id = v_old_student_id;

    -- 7. Update aggregated_awards
    UPDATE aggregated_awards
    SET student_id = NEW.student_id
    WHERE student_id = v_old_student_id;

    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        -- If any error occurs, raise exception to rollback entire transaction
        RAISE EXCEPTION 'Failed to update student references: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;


-- Step 2: Create the trigger
CREATE TRIGGER trg_update_student_references
AFTER INSERT ON hep_students
FOR EACH ROW
EXECUTE FUNCTION update_student_references();

-- To remove the trigger and function (if needed):
-- DROP TRIGGER IF EXISTS trg_update_student_references ON hep_students;
-- DROP FUNCTION IF EXISTS update_student_references();


