INSERT INTO rtp_scholarships
(uid35_rtp_scholarships_res_key, course_admission_id, e487_rtp_scholarship_type, 
 e609_rtp_scholarship_from_date, e610_rtp_scholarship_to_date)
VALUES
('RTP001', 7, '9', '2024-02-26', '2028-02-25');

-- RTPStipend
INSERT INTO rtp_stipend
(uid18_rtp_stipends_res_key, course_admission_id, e623_rtp_stipend_amount, e415_reporting_year)
VALUES
('STIP001', 6, 28000.00, 2024);

-- SpecialInterestCourses
INSERT INTO special_interest_courses
(uid5_courses_res_key, uid30_special_interest_courses_res_key, e312_special_course_type, 
 e609_effective_from_date, e610_effective_to_date)
VALUES
('CRS001', 'SPC001', '22', '2005-01-01', '2007-12-31'),
('CRS002', 'SPC002', '22', '2009-01-01', NULL),
('CRS003', 'SPC003', '22', '2005-01-01', '2006-12-31'),
('CRS004', 'SPC004', '22', '2009-01-01', '2009-12-31');


-- SAHELP
INSERT INTO sahelp
(uid21_student_loans_res_key, student_id, e527_help_debt_incurral_date, 
 e490_student_status_code, e384_amount_charged, e381_amount_paid_upfront, 
 e558_help_loan_amount, a130_loan_status, invalidated_flag)
VALUES
('SL001', 1, '2019-06-01', '280', 151.5, 0, 151.5, 'COMMITTED', 'N'),
('SL002', 2, '2018-11-01', '280', 149.0, 0, 149.0, 'COMMITTED', 'N'),
('SL003', 3, '2019-06-01', '280', 151.5, 0, 151.5, 'COMMITTED', 'N'),
('SL004', 4, '2018-06-01', '280', 149.0, 0, 149.0, 'COMMITTED', 'N'),
('SL005', 5, '2019-11-01', '280', 160.0, 0, 160.0, 'COMMITTED', 'N');


-- OSHELP（LoanStatus 修正：APPROVED → ACCEPTED）
INSERT INTO oshelp
(uid21_student_loans_res_key, course_admission_id, e527_help_debt_incurral_date, 
 e490_student_status_code, e521_study_period_commencement_date, e553_study_primary_country_code, 
 e554_study_secondary_country_code, e583_language_study_commencement_date, e582_language_code, 
 e528_payment_amount, e529_loan_fee, a130_loan_status, invalidated_flag)
VALUES
('L001', 7, '2024-02-15', '240', '2024-03-01', 'AU', 'CA', '2024-03-05', 'ENG', 4000.00, 120.00, 'ACCEPTED', 'N');


-- HEPHDREndUsersEngagement
INSERT INTO hep_hdr_end_users_engagement
(uid37_hdr_end_user_engagements_res_key, course_admission_id, e593_hdr_end_user_engagement_code, 
 e609_hdr_end_user_engage_from_date, e610_hdr_end_user_engage_to_date, e798_hdr_days_of_engagement)
VALUES
('ENG001', 8, '07', '2024-03-01', '2024-09-01', '180');

-- HEPCoursePriorCredits
INSERT INTO hep_course_prior_credits
(uid32_course_prior_credits_res_key, course_admission_id, e560_credit_used_value, e561_credit_basis, e566_credit_provider_code)
VALUES
('CRD001', 6, 0.250, '100', '3001'),
('CRD002', 7, 0.500, NULL, NULL),
('CRD003', 8, 2.499, NULL, NULL),
('CRD004', 9, 2.000, NULL, NULL);

-- HEPBasisForAdmission
INSERT INTO hep_basis_for_admission
(uid17_basis_for_admission_res_key, course_admission_id, e327_basis_for_admission_code)
VALUES
('BAS001', 6, '31'),
('BAS002', 7, '31'),
('BAS003', 8, '31'),
('BAS004', 9, '31');


-- ExitAwards（OutcomeCode 已是数字，不需改）
INSERT INTO exit_awards
(uid46_early_exit_awards_res_key, course_admission_id, uid5_courses_res_key, e599_course_outcome_code, e592_course_outcome_date)
VALUES
('EXIT001', 6, 'CRS001', '1', '2022-02-10'),
('EXIT002', 7, 'CRS002', '1', '2023-06-15'),
('EXIT003', 8, 'CRS003', '1', '2025-03-25'),
('EXIT004', 9, 'CRS001', '1', '2024-11-30');

-- CourseSpecialisations
INSERT INTO course_specialisations
(uid33_course_specialisations_res_key, course_admission_id, e463_specialisation_code)
VALUES
('CSP001', 6, '90900'),
('CSP002', 7, '90701'),
('CSP003', 8, '91500'),
('CSP004', 9, '90900');

-- CourseFieldsOfEducation
INSERT INTO course_fields_of_education
(uid5_courses_res_key, uid48_course_fields_of_education_res_key, e461_field_of_education_code, e462_field_of_education_supplementary_code, e609_effective_from_date, e610_effective_to_date)
VALUES
('CRS001', 'FOE001', '91901', '0', '2005-01-01', '2006-12-31'),
('CRS002', 'FOE002', '91901', '0', '2007-01-01', NULL),
('CRS003', 'FOE003', '61799', '0', '2005-01-01', '2006-12-31'),
('CRS004', 'FOE004', '61799', '0', '2007-01-01', NULL);

-- AggregatedAwards（OutcomeCode 修正：COMPLETED → 1, WITHDRAWN → 2）
INSERT INTO aggregated_awards
(uid47_aggregate_awards_res_key, student_id, uid5_courses_res_key, e599_course_outcome_code, e591_hdr_thesis_submission_date, e592_course_outcome_date, e329_mode_of_attendance_code, e330_attendance_type_code)
VALUES
('AWD001', 1, 'CRS001', '1', '2024-11-01', '2024-11-30', '1', '1'),
('AWD002', 2, 'CRS002', '2', '2024-11-01', '2024-07-15', '2', '2');


-- ================================================
-- 2. StudentResidentialAddress
-- ================================================
INSERT INTO student_contacts_first_reported_address 
(student_id, e787_first_residential_address_line1, e789_first_residential_address_suburb, e791_first_residential_address_state, e659_first_residential_address_country_code, e790_first_residential_address_postcode)
VALUES
(1, '45 Stirling Highway', 'Crawley', 'WA', 'AUS', '6009'),
(2, '12 Mounts Bay Road', 'Perth', 'WA', 'AUS', '6000'),
(3, '78 Broadway', 'Nedlands', 'WA', 'AUS', '6009'),
(4, '234 Cambridge Street', 'Wembley', 'WA', 'AUS', '6014'),
(5, '567 Hay Street', 'Subiaco', 'WA', 'AUS', '6008');

-- ================================================
-- 3. StudentCitizenship
-- ================================================
-- 示例：插入 citizenship 时用生成的 student_id
INSERT INTO hep_student_citizenships (
    student_id, uid10_student_citizenships_res_key, e358_citizen_resident_code,
    e609_effective_from_date, e610_effective_to_date, is_current
) VALUES
(1, 'CIT001', '1', '2024-01-01', NULL, TRUE),
(2, 'CIT002', '2', '2024-01-01', NULL, TRUE);

-- ================================================
-- 4. StudentDisabilities
-- ================================================
INSERT INTO hep_student_disabilities (
    uid11_student_disabilities_res_key, student_id, e615_disability_code,
    e609_effective_from_date, e610_effective_to_date, is_current
) VALUES
('DIS001', 2, '11', '2024-01-01', NULL, TRUE),
('DIS002', 4, '12', '2024-01-01', NULL, TRUE),
('DIS003', 5, '99', '2024-01-01', NULL, TRUE);

--  commonwealth_scholarships

INSERT INTO commonwealth_scholarships (
    uid12_student_commonwealth_scholarships_res_key, student_id, e415_reporting_year,
    e666_reporting_period, e545_commonwealth_scholarship_type,
    e526_commonwealth_scholarship_status_code, e598_commonwealth_scholarship_amount,
    e538_commonwealth_scholarship_termination_reason_code
) VALUES
('CS001', 1, 2024, 1, 'A', '1', 5000.00, NULL),
('CS002', 2, 2024, 1, 'B', '1', 7000.00, NULL);


-- ================================================
-- 6. Campuses
-- ================================================
INSERT INTO campuses (
    uid2_campuses_res_key, e525_campus_suburb, e644_campus_country_code,
    e559_campus_postcode, e609_effective_from_date, e610_effective_to_date
) VALUES
('CAMP001', 'Crawley', 'AUS', '6009', '2020-01-01', NULL),
('CAMP002', 'Perth', 'AUS', '6000', '2020-01-01', NULL),
('CAMP003', 'Albany', 'AUS', '6330', '2020-01-01', NULL),
('CAMP004', 'Singapore', 'SGP', '2388', '2020-01-01', NULL),
('CAMP005', 'Online', 'AUS', '0000', '2020-01-01', NULL);

-- ================================================
-- 7. CoursesOnCampuses
-- ================================================
INSERT INTO hep_courses_on_campuses (
    uid4_courses_on_campus_res_key, uid2_campuses_res_key, uid5_courses_res_key,
    e597_cricos_code, e569_campus_operation_type,
    e570_principal_offshore_delivery_mode, e571_offshore_delivery_code,
    e609_effective_from_date, e610_effective_to_date
) VALUES
('COC001', 'CAMP001', 'CRS001', 'CRIC001', '01', '01', '01', '2024-01-01', NULL),
('COC002', 'CAMP001', 'CRS002', 'CRIC002', '01', '01', '01', '2024-01-01', NULL),
('COC003', 'CAMP002', 'CRS003', 'CRIC003', '01', '01', '01', '2024-01-01', NULL),
('COC004', 'CAMP004', 'CRS001', 'CRIC004', '02', '02', '02', '2024-01-01', NULL),
('COC005', 'CAMP005', 'CRS004', NULL, '01', '01', '01', '2024-01-01', NULL);

-- ================================================
-- 8. CampusCourseFeesITSP
-- ================================================
INSERT INTO campus_course_fees_itsp (
    uid31_campus_course_fees_res_key, uid4_courses_on_campus_res_key,
    e536_course_fees_code, e495_indicative_student_contribution_csp,
    e496_indicative_tuition_fee_domestic_fp, e609_effective_from_date
) VALUES
('FEE001', 'COC001', '1', '8750', 15000.00, '2024-01-01'),
('FEE002', 'COC002', '1', '9500', 18000.00, '2024-01-01'),
('FEE003', 'COC003', '2', NULL, 45000.00, '2024-01-01'),
('FEE004', 'COC004', '3', NULL, 28000.00, '2024-01-01'),
('FEE005', 'COC005', '1', '7500', 12000.00, '2024-01-01');

-- ================================================
-- 9. CampusesTAC
-- ================================================
INSERT INTO campuses_tac (
    uid40_courses_on_campus_tac_res_key, uid4_courses_on_campus_res_key, e557_tac_offer_code
) VALUES
('TAC001', 'COC001', TRUE),
('TAC002', 'COC002', TRUE),
('TAC003', 'COC003', FALSE),
('TAC004', 'COC005', FALSE);

-- ================================================
-- 12. UnitEnrolmentAOUs
-- ================================================
INSERT INTO unit_enrolments_aous (
    uid19_unit_enrolment_aous_res_key, unit_enrolment_id, e333_aou_code,
    aou_e339_eftsl, aou_e384_amount_charged, aou_e381_amount_paid_upfront,
    aou_e529_loan_fee, reporting_year, is_current, aou_is_deleted
) VALUES
('AOU001', 1, 'AC', 0.125, 2187.50, 500.00, 0.00, 2024, TRUE, FALSE),
('AOU002', 2, 'EC', 0.125, 2187.50, 0.00, 109.38, 2024, TRUE, FALSE),
('AOU003', 3, 'MA', 0.125, 2375.00, 1000.00, 0.00, 2024, TRUE, FALSE),
('AOU004', 4, 'CH', 0.125, 2375.00, 0.00, 118.75, 2024, TRUE, FALSE),
('AOU005', 5, 'MB', 0.167, 7500.00, 7500.00, 0.00, 2024, TRUE, FALSE),
('AOU006', 6, 'MG', 0.083, 1458.33, 0.00, 72.92, 2024, TRUE, FALSE),
('AOU007', 6, 'MI', 0.042, 729.17, 0.00, 36.46, 2024, TRUE, FALSE),
('AOU008', 7, 'EN', 0.125, 1875.00, 500.00, 0.00, 2024, TRUE, FALSE);
