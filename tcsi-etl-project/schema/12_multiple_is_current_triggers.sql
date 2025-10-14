-- ============================================================================
-- 1. hep_student_citizenships trigger
-- ============================================================================
CREATE OR REPLACE FUNCTION fn_hep_student_citizenships_is_current()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE hep_student_citizenships
    SET is_current = false
    WHERE uid10_student_citizenships_res_key = NEW.uid10_student_citizenships_res_key
      AND is_current = true
      AND ctid != NEW.ctid;  -- Exclude the newly inserted row
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating hep_student_citizenships: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_hep_student_citizenships_is_current ON hep_student_citizenships;
CREATE TRIGGER trg_hep_student_citizenships_is_current
AFTER INSERT ON hep_student_citizenships
FOR EACH ROW
EXECUTE FUNCTION fn_hep_student_citizenships_is_current();

-- ============================================================================
-- 2. hep_student_disabilities trigger
-- ============================================================================
CREATE OR REPLACE FUNCTION fn_hep_student_disabilities_is_current()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE hep_student_disabilities
    SET is_current = false
    WHERE uid11_student_disabilities_res_key = NEW.uid11_student_disabilities_res_key
      AND is_current = true
      AND ctid != NEW.ctid;
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating hep_student_disabilities: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_hep_student_disabilities_is_current ON hep_student_disabilities;
CREATE TRIGGER trg_hep_student_disabilities_is_current
AFTER INSERT ON hep_student_disabilities
FOR EACH ROW
EXECUTE FUNCTION fn_hep_student_disabilities_is_current();

-- ============================================================================
-- 3. oshelp trigger
-- ============================================================================
CREATE OR REPLACE FUNCTION fn_oshelp_is_current()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE oshelp
    SET is_current = false
    WHERE uid21_student_loans_res_key = NEW.uid21_student_loans_res_key
      AND is_current = true
      AND ctid != NEW.ctid;
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating oshelp: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_oshelp_is_current ON oshelp;
CREATE TRIGGER trg_oshelp_is_current
AFTER INSERT ON oshelp
FOR EACH ROW
EXECUTE FUNCTION fn_oshelp_is_current();

-- ============================================================================
-- 4. sahelp trigger
-- ============================================================================
CREATE OR REPLACE FUNCTION fn_sahelp_is_current()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE sahelp
    SET is_current = false
    WHERE uid21_student_loans_res_key = NEW.uid21_student_loans_res_key
      AND is_current = true
      AND ctid != NEW.ctid;
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating sahelp: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_sahelp_is_current ON sahelp;
CREATE TRIGGER trg_sahelp_is_current
AFTER INSERT ON sahelp
FOR EACH ROW
EXECUTE FUNCTION fn_sahelp_is_current();

-- ============================================================================
-- 5. student_contacts_first_reported_address trigger
-- ============================================================================
CREATE OR REPLACE FUNCTION fn_student_contacts_first_reported_address_is_current()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE student_contacts_first_reported_address
    SET is_current = false
    WHERE student_id = NEW.student_id
      AND is_current = true
      AND ctid != NEW.ctid;
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating student_contacts_first_reported_address: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_student_contacts_first_reported_address_is_current ON student_contacts_first_reported_address;
CREATE TRIGGER trg_student_contacts_first_reported_address_is_current
AFTER INSERT ON student_contacts_first_reported_address
FOR EACH ROW
EXECUTE FUNCTION fn_student_contacts_first_reported_address_is_current();

-- ============================================================================
-- 6. unit_enrolments trigger
-- ============================================================================
CREATE OR REPLACE FUNCTION fn_unit_enrolments_is_current()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE unit_enrolments
    SET is_current = false
    WHERE uid16_unit_enrolments_res_key = NEW.uid16_unit_enrolments_res_key
      AND is_current = true
      AND ctid != NEW.ctid;
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating unit_enrolments: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_unit_enrolments_is_current ON unit_enrolments;
CREATE TRIGGER trg_unit_enrolments_is_current
AFTER INSERT ON unit_enrolments
FOR EACH ROW
EXECUTE FUNCTION fn_unit_enrolments_is_current();

-- ============================================================================
-- 7. unit_enrolments_aous trigger
-- ============================================================================
CREATE OR REPLACE FUNCTION fn_unit_enrolments_aous_is_current()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE unit_enrolments_aous
    SET is_current = false
    WHERE uid19_unit_enrolment_aous_res_key = NEW.uid19_unit_enrolment_aous_res_key
      AND is_current = true
      AND ctid != NEW.ctid;
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating unit_enrolments_aous: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_unit_enrolments_aous_is_current ON unit_enrolments_aous;
CREATE TRIGGER trg_unit_enrolments_aous_is_current
AFTER INSERT ON unit_enrolments_aous
FOR EACH ROW
EXECUTE FUNCTION fn_unit_enrolments_aous_is_current();