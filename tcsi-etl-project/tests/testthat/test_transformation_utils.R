test_that("clean_null normalizes empty indicators to NA", {
  expect_true(is.na(etl_env$clean_null("")))
  expect_true(is.na(etl_env$clean_null("NULL")))
  expect_equal(etl_env$clean_null("value"), "value")
  expect_equal(etl_env$clean_null(123), 123)
})

test_that("transform_row trims strings and parses dates", {
  mapping <- list(
    csv_to_db = list(
      "E314_DateOfBirth" = "e314_date_of_birth",
      "E402_StudentFamilyName" = "e402_student_family_name"
    ),
    date_fields = c("e314_date_of_birth")
  )
  
  row <- data.frame(
    E314_DateOfBirth = "2024-02-01",
    E402_StudentFamilyName = "  Smith  ",
    stringsAsFactors = FALSE
  )
  
  transformed <- etl_env$transform_row(row, mapping, "hep_students", 1)
  
  expect_s3_class(transformed$e314_date_of_birth, "Date")
  expect_equal(transformed$e314_date_of_birth, as.Date("2024-02-01"))
  expect_equal(transformed$e402_student_family_name, "Smith")
})

test_that("transform_batch injects reporting_year for unit enrolments", {
  mapping <- list(
    csv_to_db = list(
      "UID16_UnitEnrolmentsResKey" = "uid16_unit_enrolments_res_key"
    ),
    date_fields = character()
  )
  
  data <- data.frame(
    UID16_UnitEnrolmentsResKey = c("5000001", "5000002"),
    stringsAsFactors = FALSE
  )
  
  transformed_rows <- etl_env$transform_batch(
    data,
    mapping,
    table_name = "unit_enrolments",
    conn = NULL,
    csv_file_path = "/tmp/HEP_units-AOUs_2017.csv"
  )
  
  expect_length(transformed_rows, 2)
  expect_equal(transformed_rows[[1]]$uid16_unit_enrolments_res_key, "5000001")
  expect_equal(transformed_rows[[1]]$reporting_year, 2017)
  
  other <- etl_env$transform_batch(
    data[1, , drop = FALSE],
    mapping,
    table_name = "hep_students",
    conn = NULL,
    csv_file_path = NULL
  )
  expect_false("reporting_year" %in% names(other[[1]]))
})
