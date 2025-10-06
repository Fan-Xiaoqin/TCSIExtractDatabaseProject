-- =====================================================
-- STUDENT LOANS
-- =====================================================

-- OS-HELP Loans
CREATE TABLE oshelp (
    oshelp_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_admission_id BIGINT NOT NULL REFERENCES hep_course_admissions(course_admission_id),
    uid21_student_loans_res_key VARCHAR(10) NOT NULL,
    e527_help_debt_incurral_date DATE NOT NULL,
    e490_student_status_code VARCHAR(3) NOT NULL CHECK (
        e490_student_status_code IN ('240', '241', '242')
    ),
    e521_study_period_commencement_date DATE NOT NULL,
    e553_study_primary_country_code VARCHAR(4),
    e554_study_secondary_country_code VARCHAR(4),
    e583_language_study_commencement_date DATE,
    e582_language_code VARCHAR(4),
    e528_payment_amount DECIMAL(10,2) NOT NULL,
    e529_loan_fee DECIMAL(7,2) NOT NULL,
    a130_loan_status VARCHAR(20) CHECK (a130_loan_status IN (
        'ACCPEND','ADJPEND','REJECTPEND','ACCEPTED','ADJUSTED',
        'COMMITTED','ADJCOMMITTED','REMITREC','REVERSREC',
        'ACCTRANS','ADJTRANS','INVALIDTRANS','REVERSETRANS','REMITTTRANS',
        'VETAPPROVED','DELETED','VETREJECTED','REMISSION','REVERSED',
        'REMITTED','REJECTED','INVALIDATED'
    )),
    invalidated_flag VARCHAR(1) CHECK (
        invalidated_flag IN ('Y','N')
        ),
    -- Else we could use invalidated_flag BOOLEAN for cleaner logic
    -- but need to Transform 'Y' → TRUE, 'N' → FALSE when loading from R
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_current BOOLEAN DEFAULT TRUE
);

-- SA-HELP Loans
CREATE TABLE sahelp (
    sahelp_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id BIGINT NOT NULL REFERENCES hep_students(student_id),
    uid21_student_loans_res_key VARCHAR(10) NOT NULL,
    e527_help_debt_incurral_date DATE NOT NULL,
    e490_student_status_code VARCHAR(3) NOT NULL CHECK (
        e490_student_status_code IN ('280', '281')
    ),
    e384_amount_charged DECIMAL(7,2) NOT NULL,
    e381_amount_paid_upfront DECIMAL(7,2) NOT NULL,
    e558_help_loan_amount DECIMAL(7,2) NOT NULL,
    a130_loan_status VARCHAR(20) NOT NULL CHECK (a130_loan_status IN (
        'ACCPEND','ADJPEND','REJECTPEND','ACCEPTED','ADJUSTED',
        'COMMITTED','ADJCOMMITTED','REMITREC','REVERSREC',
        'ACCTRANS','ADJTRANS','INVALIDTRANS','REVERSETRANS','REMITTTRANS',
        'VETAPPROVED','DELETED','VETREJECTED','REMISSION','REVERSED',
        'REMITTED','REJECTED','INVALIDATED'
    )),
    invalidated_flag VARCHAR(1) CHECK (
        invalidated_flag IN ('Y','N')
        ),
    -- Else we could use invalidated_flag BOOLEAN for cleaner logic
    -- but need to Transform 'Y' → TRUE, 'N' → FALSE when loading from R
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_current BOOLEAN DEFAULT TRUE
);