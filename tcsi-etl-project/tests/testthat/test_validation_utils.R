test_that("validate_row flags missing required fields", {
  mapping <- list(
    required_fields = c("uid8_students_res_key", "uid10_student_citizenships_res_key"),
    validated_fields = list(),
    foreign_keys = NULL
  )
  
  result <- etl_env$validate_row(
    row = list(uid10_student_citizenships_res_key = "CIT0001"),
    mapping = mapping,
    conn = NULL,
    table_name = "hep_student_citizenships",
    row_num = 1
  )
  
  expect_false(result$valid)
  expect_true(any(grepl("Required field missing: uid8_students_res_key", result$errors)))
})

test_that("validate_row enforces valid value constraints", {
  mapping <- list(
    required_fields = c(
      "uid8_students_res_key",
      "uid10_student_citizenships_res_key",
      "e358_citizen_resident_code",
      "e609_effective_from_date"
    ),
    validated_fields = list(
      "e358_citizen_resident_code" = etl_env$VALID_CITIZEN_RESIDENT_CODES
    ),
    foreign_keys = NULL
  )
  
  invalid_row <- list(
    uid8_students_res_key = "STU0001",
    uid10_student_citizenships_res_key = "CIT0001",
    e358_citizen_resident_code = "9",
    e609_effective_from_date = as.Date("2024-01-01")
  )
  
  result <- etl_env$validate_row(
    row = invalid_row,
    mapping = mapping,
    conn = NULL,
    table_name = "hep_student_citizenships",
    row_num = 1
  )
  
  expect_false(result$valid)
  expect_true(any(grepl("Invalid value for e358_citizen_resident_code", result$errors)))
})

test_that("validate_batch splits valid and invalid rows", {
  mapping <- list(
    required_fields = c(
      "uid8_students_res_key",
      "uid10_student_citizenships_res_key",
      "e358_citizen_resident_code",
      "e609_effective_from_date"
    ),
    validated_fields = list(
      "e358_citizen_resident_code" = etl_env$VALID_CITIZEN_RESIDENT_CODES
    ),
    foreign_keys = NULL
  )
  
  rows <- list(
    list(
      uid8_students_res_key = "STU0001",
      uid10_student_citizenships_res_key = "CIT0001",
      e358_citizen_resident_code = "1",
      e609_effective_from_date = as.Date("2024-01-01")
    ),
    list(
      uid8_students_res_key = "STU0002",
      uid10_student_citizenships_res_key = "CIT0002",
      e358_citizen_resident_code = "9",
      e609_effective_from_date = as.Date("2024-01-01")
    )
  )
  
  batch_result <- etl_env$validate_batch(
    rows = rows,
    mapping = mapping,
    conn = NULL,
    table_name = "hep_student_citizenships"
  )
  
  expect_length(batch_result$valid_rows, 1)
  expect_length(batch_result$invalid_rows, 1)
  expect_equal(batch_result$invalid_rows[[1]]$row_num, 2)
  expect_true(any(grepl("Invalid value for e358_citizen_resident_code", batch_result$invalid_rows[[1]]$errors)))
})
