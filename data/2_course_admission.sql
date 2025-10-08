INSERT INTO courses_of_study (
    uid3_courses_of_study_res_key,
    e533_course_of_study_code,
    e394_course_of_study_name,
    e310_course_of_study_type,
    e350_course_of_study_load,
    e455_combined_course_of_study_indicator
) VALUES
('CSR001', '20', 'Aboriginal Orientation Course', '30', 1.0, TRUE),
('CSR002', '30', 'Aboriginal Pre-Law Programme', '30', 0.3, FALSE),
('CSR003', '40', 'Aboriginal Pre-Medicine Programme', '30', 0.3, FALSE),
('CSR004', '50', 'Cross Institutional (Albany)', '41', NULL, FALSE);


INSERT INTO hep_courses (
    uid5_courses_res_key,
    uid3_courses_of_study_res_key,
    e307_course_code,
    e308_course_name,
    e596_standard_course_duration,
    e609_effective_from_date,
    e610_effective_to_date
) VALUES
('CRS001', 'CSR001', '201', 'Aboriginal Orientation Course', NULL, '2005-01-01', NULL),
('CRS002', 'CSR002', '302', 'Aboriginal Pre-Law Programme', 0.3, '2005-01-01', NULL),
('CRS003', 'CSR003', '301', 'Aboriginal Pre-Law Programme', NULL, '2005-01-01', NULL),
('CRS004', 'CSR004', '401', 'Aboriginal Pre-Medicine Programme', NULL, '2005-01-01', NULL);


INSERT INTO hep_course_admissions (
    uid15_course_admissions_res_key,
    student_id,
    uid5_courses_res_key,
    e534_course_of_study_commencement_date,
    e330_attendance_type_code,
    e632_atar,
    e605_selection_rank,
    e620_highest_attainment_code,
    is_current
) VALUES
('ADM001', 1, 'CRS001', '2024-02-26', '1', 85.50, 87.00, '12', TRUE),
('ADM002', 2, 'CRS002', '2024-02-26', '1', 92.00, 93.50, '12', TRUE),
('ADM003', 3, 'CRS003', '2024-03-01', '1', NULL, 75.00, '11', TRUE),
('ADM004', 4, 'CRS001', '2024-02-26', '1', 78.00, 80.00, '12', TRUE),
('ADM005', 5, 'CRS004', '2024-02-26', '2', NULL, 65.00, '08', TRUE);
