INSERT INTO hep_students (
    uid8_students_res_key, e313_student_identification_code, e488_chessn, e584_usi,
    a170_usi_verification_status, a167_tfn_verification_status, e314_date_of_birth,
    e402_student_family_name, e403_student_given_name_first, e404_student_given_name_others,
    e315_gender_code, e316_atsi_code, e346_country_of_birth_code, e347_arrival_in_australia_year,
    e348_language_spoken_at_home_code, e572_year_left_school, e612_level_left_school,
    e573_highest_education_parent1, e574_highest_education_parent2,
    e319_term_residence_postcode, e661_term_residence_country_code, is_current
) VALUES
('STU100001', 'S2024001', '987654321A', 'USI1234567', 'Y', 'Y', '2003-03-15',
 'Smith', 'Emily', 'Jane', 'F', '3', 'AUS', NULL, '1201', 2020, '12', '08', '06', '6009', 'AUS', TRUE),

('STU100002', 'S2024002', '876543210B', 'USI2345678', 'Y', 'Y', '2002-07-22',
 'Chen', 'Wei', 'Michael', 'M', '3', 'CHN', 2015, '2401', 2019, '12', '11', '11', '6000', 'AUS', TRUE),

('STU100003', 'S2024003', NULL, 'USI3456789', 'Y', 'N', '2001-11-08',
 'Kumar', 'Priya', NULL, 'F', '3', 'IND', 2023, '4202', 2019, '12', '11', '08', '6009', 'AUS', TRUE),

('STU100004', 'S2024004', '765432109C', 'USI4567890', 'Y', 'Y', '2004-01-25',
 'Williams', 'Jack', 'Thomas', 'M', '2', 'AUS', NULL, '1201', 2021, '12', '05', '05', '6014', 'AUS', TRUE),

('STU100005', 'S2024005', '654321098D', 'USI5678901', 'Y', 'Y', '1985-09-30',
 'Anderson', 'Sarah', 'Louise', 'F', '3', 'NZL', 2010, '1201', 2003, '12', '06', '05', '6008', 'AUS', TRUE);
