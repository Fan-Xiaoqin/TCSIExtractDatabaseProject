-- =====================================================
-- STUDENT LOANS
-- =====================================================

-- OS-HELP Loans
CREATE TABLE oshelp (
    uid21_student_loans_res_key VARCHAR(10) PRIMARY KEY,
    uid15_course_admissions_res_key VARCHAR(10) REFERENCES hep_course_admissions(uid15_course_admissions_res_key),
    e527_help_debt_incurral_date DATE,
    e490_student_status_code VARCHAR(3),
    e521_study_period_commencement_date DATE,
    e553_study_primary_country_code VARCHAR(4),
    e554_study_secondary_country_code VARCHAR(4),
    e583_language_study_commencement_date DATE,
    e582_language_code VARCHAR(4),
    e528_payment_amount DECIMAL(10,2),
    e529_loan_fee DECIMAL(7,2),
    a130_loan_status VARCHAR(20) NOT NULL CHECK (a130_loan_status IN (
        'ACCPEND','ADJPEND','REJECTPEND','ACCEPTED','ADJUSTED',
        'COMMITTED','ADJCOMMITTED','REMITREC','REVERSREC',
        'ACCTRANS','ADJTRANS','INVALIDTRANS','REVERSETRANS','REMITTTRANS',
        'VETAPPROVED','DELETED','VETREJECTED','REMISSION','REVERSED',
        'REMITTED','REJECTED','INVALIDATED'
    )),
    invalidated_flag VARCHAR(1) CHECK (invalidated_flag IN ('Y','N')) 
    -- Else we could use invalidated_flag BOOLEAN for more cleaner logic 
    -- but need to Transform 'Y' → TRUE, 'N' → FALSE when loading from R
);

-- SA-HELP Loans
CREATE TABLE sahelp (
    uid21_student_loans_res_key VARCHAR(10) PRIMARY KEY,
    student_key BIGINT NOT NULL REFERENCES hep_students(student_key), --Linked to student rather than course admission following TCSI spec
    e527_help_debt_incurral_date DATE,
    e490_student_status_code VARCHAR(3),
    e384_amount_charged DECIMAL(7,2),
    e381_amount_paid_upfront DECIMAL(7,2),
    e558_help_loan_amount DECIMAL(7,2),
    a130_loan_status VARCHAR(20) NOT NULL CHECK (a130_loan_status IN (
        'ACCPEND','ADJPEND','REJECTPEND','ACCEPTED','ADJUSTED',
        'COMMITTED','ADJCOMMITTED','REMITREC','REVERSREC',
        'ACCTRANS','ADJTRANS','INVALIDTRANS','REVERSETRANS','REMITTTRANS',
        'VETAPPROVED','DELETED','VETREJECTED','REMISSION','REVERSED',
        'REMITTED','REJECTED','INVALIDATED'
    )),
    invalidated_flag VARCHAR(1) CHECK (invalidated_flag IN ('Y','N')) 
    -- Else we could use invalidated_flag BOOLEAN for more cleaner logic 
    -- but need to Transform 'Y' → TRUE, 'N' → FALSE when loading from R
);