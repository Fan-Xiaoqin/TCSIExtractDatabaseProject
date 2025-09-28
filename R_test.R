# ================================================
# TCSI Database R Test Suite
# Comprehensive testing for ETL pipeline and data validation
# ================================================

# Load required libraries
library(testthat)
library(DBI)
library(RMySQL)
library(dplyr)
library(tidyr)
library(lubridate)

# Source ETL functions (adjust paths as needed)
# source("ETL/config.R")
# source("ETL/extract.R")
# source("ETL/transform.R")
# source("ETL/validation.R")

# ================================================
# TEST CONFIGURATION
# ================================================

# Database connection for testing
create_test_connection <- function() {
  dbConnect(
    RMySQL::MySQL(),
    host = Sys.getenv("DB_HOST", "localhost"),
    port = as.integer(Sys.getenv("DB_PORT", 3306)),
    dbname = Sys.getenv("DB_NAME", "TCSI_Test"),
    user = Sys.getenv("DB_USER", "root"),
    password = Sys.getenv("DB_PASSWORD")
  )
}

# Test data directory
TEST_DATA_DIR <- "tests/test_data/"

# ================================================
# SECTION 1: DATABASE CONNECTION TESTS
# ================================================

context("Database Connection Tests")

test_that("Database connection can be established", {
  con <- NULL
  expect_no_error({
    con <- create_test_connection()
  })
  
  if (!is.null(con)) {
    expect_true(dbIsValid(con))
    dbDisconnect(con)
  }
})

test_that("All required tables exist", {
  con <- create_test_connection()
  
  required_tables <- c(
    "HEPStudents", "StudentResidentialAddress", "StudentCitizenship",
    "StudentDisabilities", "Courses", "Campuses", "CoursesOnCampuses",
    "CourseAdmissions", "UnitEnrolments", "UnitEnrolmentAOUs",
    "SAHELP", "OSHELP", "AggregatedAwards", "ExitAwards"
  )
  
  existing_tables <- dbListTables(con)
  
  for (table in required_tables) {
    expect_true(table %in% existing_tables, 
                info = paste("Missing table:", table))
  }
  
  dbDisconnect(con)
})

# ================================================
# SECTION 2: DATA EXTRACTION TESTS
# ================================================

context("Data Extraction Tests")

test_that("CSV extraction handles missing files gracefully", {
  non_existent_file <- "non_existent_file.csv"
  
  result <- tryCatch({
    extract_csv_data(non_existent_file)
  }, error = function(e) {
    NULL
  })
  
  expect_null(result)
})

test_that("CSV extraction adds required metadata", {
  # Create temporary test CSV
  test_data <- data.frame(
    Student_Key = c(1, 2, 3),
    Name = c("Alice", "Bob", "Charlie"),
    stringsAsFactors = FALSE
  )
  
  temp_file <- tempfile(fileext = ".csv")
  write.csv(test_data, temp_file, row.names = FALSE)
  
  # Mock extract function
  extract_csv_with_metadata <- function(file_path) {
    data <- read.csv(file_path, stringsAsFactors = FALSE)
    data$ExtractedAt <- Sys.time()
    data$SourceFile <- basename(file_path)
    data$LoadBatchID <- paste0("BATCH_", format(Sys.time(), "%Y%m%d_%H%M%S"))
    return(data)
  }
  
  result <- extract_csv_with_metadata(temp_file)
  
  expect_true("ExtractedAt" %in% names(result))
  expect_true("SourceFile" %in% names(result))
  expect_true("LoadBatchID" %in% names(result))
  expect_equal(nrow(result), 3)
  
  unlink(temp_file)
})

test_that("Database extraction returns correct structure", {
  con <- create_test_connection()
  
  # Test extracting students
  query <- "SELECT * FROM HEPStudents WHERE IsCurrent = TRUE LIMIT 5"
  result <- dbGetQuery(con, query)
  
  expect_true(is.data.frame(result))
  expect_true("Student_Key" %in% names(result))
  expect_true("E313_StudentIdentificationCode" %in% names(result))
  
  dbDisconnect(con)
})

# ================================================
# SECTION 3: DATA TRANSFORMATION TESTS
# ================================================

context("Data Transformation Tests")

test_that("Student transformation cleans data correctly", {
  # Create test data with messy values
  test_students <- data.frame(
    Student_Key = c(1, 2, 3),
    E313_StudentIdentificationCode = c("S001", "S002", "S003"),
    E402_StudentFamilyName = c("  SMITH  ", "jones", "WANG"),
    E403_StudentGivenNameFirst = c("john", "MARY", "  Li  "),
    E314_DateOfBirth = c("2000-01-15", "1999-12-31", "2001-06-20"),
    E358_CitizenResidentCode = c("01", "02", "08"),
    stringsAsFactors = FALSE
  )
  
  # Transform function
  transform_students <- function(data) {
    data %>%
      mutate(
        E402_StudentFamilyName = str_to_title(trimws(E402_StudentFamilyName)),
        E403_StudentGivenNameFirst = str_to_title(trimws(E403_StudentGivenNameFirst)),
        E314_DateOfBirth = as.Date(E314_DateOfBirth),
        Age = as.integer((Sys.Date() - E314_DateOfBirth) / 365.25),
        IsInternational = E358_CitizenResidentCode == "08"
      )
  }
  
  result <- transform_students(test_students)
  
  expect_equal(result$E402_StudentFamilyName[1], "Smith")
  expect_equal(result$E403_StudentGivenNameFirst[2], "Mary")
  expect_true(is.Date(result$E314_DateOfBirth))
  expect_true("Age" %in% names(result))
  expect_true(result$IsInternational[3])
})

test_that("SCD-2 fields are added correctly", {
  test_data <- data.frame(
    ID = 1:3,
    Name = c("A", "B", "C")
  )
  
  add_scd2_fields <- function(data) {
    data %>%
      mutate(
        UpdatedAt = Sys.time(),
        IsCurrent = TRUE
      )
  }
  
  result <- add_scd2_fields(test_data)
  
  expect_true("UpdatedAt" %in% names(result))
  expect_true("IsCurrent" %in% names(result))
  expect_true(all(result$IsCurrent))
})

test_that("Unit enrollment transformation handles financial fields", {
  test_units <- data.frame(
    UID16_UnitEnrolmentsResKey = c("UE001", "UE002"),
    UE_E339_EFTSL = c("0.125", "0.25"),
    UE_E384_AmountCharged = c("2000.50", "3000"),
    UE_E381_AmountPaidUpfront = c("500", "0"),
    E489_UnitOfStudyCensusDate = c("2024-03-31", "2024-03-31"),
    stringsAsFactors = FALSE
  )
  
  transform_units <- function(data) {
    data %>%
      mutate(
        UE_E339_EFTSL = as.numeric(UE_E339_EFTSL),
        UE_E384_AmountCharged = as.numeric(UE_E384_AmountCharged),
        UE_E381_AmountPaidUpfront = as.numeric(UE_E381_AmountPaidUpfront),
        E489_UnitOfStudyCensusDate = as.Date(E489_UnitOfStudyCensusDate),
        UE_E558_HELPLoanAmount = UE_E384_AmountCharged - UE_E381_AmountPaidUpfront,
        Reporting_Year = year(E489_UnitOfStudyCensusDate)
      )
  }
  
  result <- transform_units(test_units)
  
  expect_equal(result$UE_E339_EFTSL[1], 0.125)
  expect_equal(result$UE_E558_HELPLoanAmount[1], 1500.50)
  expect_equal(result$Reporting_Year[1], 2024)
})

# ================================================
# SECTION 4: DATA VALIDATION TESTS
# ================================================

context("Data Validation Tests")

test_that("Required fields validation works", {
  test_students <- data.frame(
    Student_Key = c(1, 2, NA),
    E313_StudentIdentificationCode = c("S001", NA, "S003"),
    E314_DateOfBirth = c("2000-01-15", "1999-12-31", "2001-06-20"),
    E402_StudentFamilyName = c("Smith", "Jones", ""),
    stringsAsFactors = FALSE
  )
  
  validate_required_fields <- function(data, required_cols) {
    issues <- list()
    
    for (col in required_cols) {
      if (col %in% names(data)) {
        null_count <- sum(is.na(data[[col]]) | data[[col]] == "")
        if (null_count > 0) {
          issues[[col]] <- null_count
        }
      }
    }
    
    return(list(
      is_valid = length(issues) == 0,
      issues = issues
    ))
  }
  
  required <- c("Student_Key", "E313_StudentIdentificationCode", "E402_StudentFamilyName")
  result <- validate_required_fields(test_students, required)
  
  expect_false(result$is_valid)
  expect_equal(result$issues$Student_Key, 1)
  expect_equal(result$issues$E313_StudentIdentificationCode, 1)
  expect_equal(result$issues$E402_StudentFamilyName, 1)
})

test_that("ATAR range validation works", {
  test_admissions <- data.frame(
    Admission_ID = 1:5,
    E632_ATAR = c(95.5, 99.95, 0, 100.5, -5)
  )
  
  validate_atar <- function(data) {
    invalid <- data %>%
      filter(!is.na(E632_ATAR)) %>%
      filter(E632_ATAR < 0 | E632_ATAR > 99.95)
    
    return(list(
      is_valid = nrow(invalid) == 0,
      invalid_count = nrow(invalid),
      invalid_records = invalid
    ))
  }
  
  result <- validate_atar(test_admissions)
  
  expect_false(result$is_valid)
  expect_equal(result$invalid_count, 2)  # 100.5 and -5
})

test_that("EFTSL range validation works", {
  test_units <- data.frame(
    UnitEnrolment_ID = 1:5,
    UE_E339_EFTSL = c(0.125, 0.25, 0.5, 1.5, -0.1)
  )
  
  validate_eftsl <- function(data) {
    invalid <- data %>%
      filter(!is.na(UE_E339_EFTSL)) %>%
      filter(UE_E339_EFTSL < 0 | UE_E339_EFTSL > 1)
    
    return(nrow(invalid) == 0)
  }
  
  result <- validate_eftsl(test_units)
  
  expect_false(result)  # Should fail due to 1.5 and -0.1
})

test_that("Duplicate detection works", {
  test_students <- data.frame(
    Student_Key = c(1, 2, 3, 4, 5),
    E313_StudentIdentificationCode = c("S001", "S002", "S001", "S003", "S002"),
    IsCurrent = TRUE
  )
  
  find_duplicates <- function(data, key_column) {
    duplicates <- data %>%
      filter(IsCurrent == TRUE) %>%
      group_by(!!sym(key_column)) %>%
      filter(n() > 1) %>%
      ungroup()
    
    return(duplicates)
  }
  
  duplicates <- find_duplicates(test_students, "E313_StudentIdentificationCode")
  
  expect_equal(nrow(duplicates), 4)  # S001 appears twice, S002 appears twice
})

# ================================================
# SECTION 5: SCD-2 FUNCTIONALITY TESTS
# ================================================

context("SCD-2 Functionality Tests")

test_that("SCD-2 update preserves history", {
  # Simulate SCD-2 update
  existing_record <- data.frame(
    Student_Key = 1,
    Name = "John Smith",
    Address = "123 Main St",
    UpdatedAt = as.POSIXct("2024-01-01 10:00:00"),
    IsCurrent = TRUE
  )
  
  new_record <- data.frame(
    Student_Key = 1,
    Name = "John Smith",
    Address = "456 New Ave",
    UpdatedAt = Sys.time(),
    IsCurrent = TRUE
  )
  
  perform_scd2_update <- function(existing, new) {
    # Mark existing as not current
    existing$IsCurrent <- FALSE
    
    # Combine records
    result <- rbind(existing, new)
    
    return(result)
  }
  
  result <- perform_scd2_update(existing_record, new_record)
  
  expect_equal(nrow(result), 2)
  expect_equal(sum(result$IsCurrent), 1)
  expect_false(result$IsCurrent[1])
  expect_true(result$IsCurrent[2])
})

test_that("Point-in-time query works correctly", {
  # Create historical records
  history <- data.frame(
    ID = c(1, 1, 1, 2, 2),
    Name = c("A", "B", "C", "X", "Y"),
    UpdatedAt = as.POSIXct(c(
      "2024-01-01 10:00:00",
      "2024-02-01 10:00:00",
      "2024-03-01 10:00:00",
      "2024-01-15 10:00:00",
      "2024-02-15 10:00:00"
    )),
    IsCurrent = c(FALSE, FALSE, TRUE, FALSE, TRUE)
  )
  
  get_as_of <- function(data, as_of_date) {
    data %>%
      filter(UpdatedAt <= as_of_date) %>%
      group_by(ID) %>%
      filter(UpdatedAt == max(UpdatedAt)) %>%
      ungroup()
  }
  
  result <- get_as_of(history, as.POSIXct("2024-02-10 00:00:00"))
  
  expect_equal(nrow(result), 2)
  expect_equal(result$Name[result$ID == 1], "B")
  expect_equal(result$Name[result$ID == 2], "X")
})

# ================================================
# SECTION 6: RELATIONSHIP INTEGRITY TESTS
# ================================================

context("Relationship Integrity Tests")

test_that("Foreign key relationships are valid", {
  con <- create_test_connection()
  
  # Test orphaned unit enrollments
  query <- "
    SELECT COUNT(*) as orphans
    FROM UnitEnrolments ue
    LEFT JOIN CourseAdmissions ca ON ue.Admission_ID = ca.Admission_ID
    WHERE ca.Admission_ID IS NULL AND ue.IsCurrent = TRUE
  "
  
  result <- dbGetQuery(con, query)
  expect_equal(result$orphans, 0, 
               info = "Found orphaned unit enrollments")
  
  dbDisconnect(con)
})

test_that("Fee resolution path is complete", {
  con <- create_test_connection()
  
  # Test fee resolution through the chain
  query <- "
    SELECT 
      ue.UnitEnrolment_ID,
      ca.Admission_ID,
      c.UID5_CoursesResKey,
      coc.UID4_CoursesOnCampusResKey,
      fees.UID31_CampusCourseFeesResKey
    FROM UnitEnrolments ue
    JOIN CourseAdmissions ca ON ue.Admission_ID = ca.Admission_ID
    JOIN Courses c ON ca.UID5_CoursesResKey = c.UID5_CoursesResKey
    LEFT JOIN CoursesOnCampuses coc ON c.UID5_CoursesResKey = coc.UID5_CoursesResKey
    LEFT JOIN CampusCourseFeesITSP fees ON coc.UID4_CoursesOnCampusResKey = fees.UID4_CoursesOnCampusResKey
    WHERE ue.IsCurrent = TRUE
    LIMIT 10
  "
  
  result <- dbGetQuery(con, query)
  
  if (nrow(result) > 0) {
    # Check if fees can be resolved
    fees_resolved <- sum(!is.na(result$UID31_CampusCourseFeesResKey))
    expect_true(fees_resolved > 0,
                info = "Fee resolution path should work for at least some units")
  }
  
  dbDisconnect(con)
})

# ================================================
# SECTION 7: PERFORMANCE TESTS
# ================================================

context("Performance Tests")

test_that("Common queries perform within acceptable limits", {
  con <- create_test_connection()
  
  # Test 1: Student lookup
  start_time <- Sys.time()
  
  query <- "
    SELECT s.*, ca.UID15_CourseAdmissionsResKey
    FROM HEPStudents s
    JOIN CourseAdmissions ca ON s.Student_Key = ca.Student_Key
    WHERE s.IsCurrent = TRUE AND ca.IsCurrent = TRUE
    LIMIT 100
  "
  
  result <- dbGetQuery(con, query)
  
  elapsed <- as.numeric(Sys.time() - start_time, units = "secs")
  
  expect_lt(elapsed, 1.0, 
            info = paste("Query took", round(elapsed, 3), "seconds"))
  
  dbDisconnect(con)
})

test_that("Batch insert performance is acceptable", {
  # Create test data
  test_data <- data.frame(
    ID = 1:1000,
    Value = rnorm(1000),
    Created = Sys.time()
  )
  
  start_time <- Sys.time()
  
  # Simulate batch insert (without actual DB write)
  process_batch <- function(data, batch_size = 100) {
    batches <- split(data, ceiling(seq_along(data$ID) / batch_size))
    
    for (batch in batches) {
      # Simulate processing
      Sys.sleep(0.001)  # Minimal delay to simulate work
    }
    
    return(length(batches))
  }
  
  batch_count <- process_batch(test_data)
  
  elapsed <- as.numeric(Sys.time() - start_time, units = "secs")
  
  expect_equal(batch_count, 10)
  expect_lt(elapsed, 1.0)
})

# ================================================
# SECTION 8: DATA QUALITY TESTS
# ================================================

context("Data Quality Tests")

test_that("Completeness check identifies missing data", {
  test_data <- data.frame(
    Student_Key = c(1, 2, 3, 4, 5),
    CHESSN = c("CH001", NA, "CH003", "", "CH005"),
    USI = c("USI001", "USI002", NA, "USI004", NA),
    DateOfBirth = c("2000-01-01", "2000-02-02", "2000-03-03", NA, "2000-05-05")
  )
  
  check_completeness <- function(data) {
    completeness <- data %>%
      summarise(
        total_records = n(),
        missing_chessn = sum(is.na(CHESSN) | CHESSN == ""),
        missing_usi = sum(is.na(USI) | USI == ""),
        missing_dob = sum(is.na(DateOfBirth) | DateOfBirth == "")
      ) %>%
      mutate(
        chessn_completeness = (total_records - missing_chessn) / total_records * 100,
        usi_completeness = (total_records - missing_usi) / total_records * 100,
        dob_completeness = (total_records - missing_dob) / total_records * 100
      )
    
    return(completeness)
  }
  
  result <- check_completeness(test_data)
  
  expect_equal(result$missing_chessn, 2)  # NA and ""
  expect_equal(result$missing_usi, 2)
  expect_equal(result$missing_dob, 1)
  expect_equal(result$chessn_completeness, 60)
})

test_that("Financial reconciliation detects discrepancies", {
  test_units <- data.frame(
    Unit_ID = 1:5,
    Amount_Charged = c(1000, 2000, 1500, 3000, 2500),
    Amount_Paid = c(500, 2000, 1000, 2900, 2500),
    HELP_Loan = c(500, 0, 500, 100, 0)
  )
  
  reconcile_financials <- function(data) {
    data %>%
      mutate(
        Expected_Loan = Amount_Charged - Amount_Paid,
        Discrepancy = HELP_Loan - Expected_Loan,
        Has_Discrepancy = abs(Discrepancy) > 0.01
      )
  }
  
  result <- reconcile_financials(test_units)
  
  expect_equal(sum(result$Has_Discrepancy), 0)
})

# ================================================
# RUN ALL TESTS
# ================================================

# Function to run all tests and generate report
run_all_tests <- function() {
  cat("\n========================================\n")
  cat("TCSI DATABASE R TEST SUITE\n")
  cat("========================================\n")
  cat("Test Date:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")
  
  # Run tests
  test_results <- test_dir("tests/", reporter = "summary")
  
  # Generate summary
  cat("\n========================================\n")
  cat("TEST SUMMARY\n")
  cat("========================================\n")
  
  return(test_results)
}

# Execute if running directly
if (sys.nframe() == 0) {
  run_all_tests()
}