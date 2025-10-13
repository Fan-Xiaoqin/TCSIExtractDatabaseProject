-- Step 1: Create the stored procedure
CREATE OR REPLACE FUNCTION update_course_references()
RETURNS TRIGGER AS $$
DECLARE
    v_old_course_admission_id INTEGER;
    v_affected_rows INTEGER;
BEGIN
    -- Find existing current record with same uid15_course_admissions_res_key
    SELECT course_admission_id INTO v_old_course_admission_id
    FROM hep_course_admissions
    WHERE uid15_course_admissions_res_key = NEW.uid15_course_admissions_res_key
      AND is_current = true
      AND course_admission_id != NEW.course_admission_id;  -- Exclude the newly inserted record

    -- If no existing current record found, this is a new student - proceed normally
    IF v_old_course_admission_id IS NULL THEN
        RETURN NEW;
    END IF;

    -- Set old record's is_current to false
    UPDATE hep_course_admissions
    SET is_current = false
    WHERE course_admission_id = v_old_course_admission_id;

    -- Update referenced tables to point to new course_admission_id

    -- 1. Update hep_basis_for_admission
    UPDATE hep_basis_for_admission
    SET course_admission_id = NEW.course_admission_id
    WHERE course_admission_id = v_old_course_admission_id;

    -- 2. Update hep_course_prior_credits
    UPDATE hep_course_prior_credits
    SET course_admission_id = NEW.course_admission_id
    WHERE course_admission_id = v_old_course_admission_id;

    -- 3. Update course_specialisations
    UPDATE course_specialisations
    SET course_admission_id = NEW.course_admission_id
    WHERE course_admission_id = v_old_course_admission_id;

    -- 4. Update hep_hdr_end_users_engagement
    UPDATE hep_hdr_end_users_engagement
    SET course_admission_id = NEW.course_admission_id
    WHERE course_admission_id = v_old_course_admission_id;

    -- 5. Update rtp_scholarships
    UPDATE rtp_scholarships
    SET course_admission_id = NEW.course_admission_id
    WHERE course_admission_id = v_old_course_admission_id;

    -- 6. Update rtp_stipend
    UPDATE rtp_stipend
    SET course_admission_id = NEW.course_admission_id
    WHERE course_admission_id = v_old_course_admission_id;

    -- 7. Update oshelp
    UPDATE oshelp
    SET course_admission_id = NEW.course_admission_id
    WHERE course_admission_id = v_old_course_admission_id;

    -- 8. Update exit_awards
    UPDATE exit_awards
    SET course_admission_id = NEW.course_admission_id
    WHERE course_admission_id = v_old_course_admission_id;

    -- 9. Update unit_enrolments
    UPDATE unit_enrolments
    SET course_admission_id = NEW.course_admission_id
    WHERE course_admission_id = v_old_course_admission_id;

    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        -- If any error occurs, raise exception to rollback entire transaction
        RAISE EXCEPTION 'Failed to update student references: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;


-- Step 2: Create the trigger
CREATE TRIGGER trg_update_course_references
AFTER INSERT ON hep_course_admissions
FOR EACH ROW
EXECUTE FUNCTION update_course_references();

-- To remove the trigger and function (if needed):
-- DROP TRIGGER IF EXISTS trg_update_course_references ON hep_course_admissions;
-- DROP FUNCTION IF EXISTS update_course_references();


