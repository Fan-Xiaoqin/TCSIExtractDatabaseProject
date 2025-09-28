# ================================================
# Additional ETL Files for TCSI Project
# Specialized modules for data quality and reporting
# ================================================

# ================================================
# 9. ETL/data_quality.R - Data Quality Checks
# ================================================
# ETL/data_quality.R

library(dplyr)
library(tidyr)

source("ETL/config.R")
source("ETL/logging.R")

# Main data quality check function
perform_data_quality_checks <- function(connection = NULL) {
  log_message("Starting data quality checks", "INFO")
  
  if (is.null(connection)) {
    connection <- create_db_connection()
    on.exit(dbDisconnect(connection))
  }
  
  results <- list()
  
  # Check 1: Orphaned records
  results$orphaned <- check_orphaned_records(connection)
  
  # Check 2: Duplicate records
  results$duplicates <- check_duplicates(connection)
  
  # Check 3: Data completeness
  results$completeness <- check_completeness(connection)
  
  # Check 4: Referential integrity
  results$referential <- check_referential_integrity(connection)
  
  # Check 5: Business rules
  results$business_rules <- check_business_rules(connection)
  
  # Generate quality report
  generate_quality_report(results)
  
  return(results)
}

# Check for orphaned records
check_orphaned_records <- function(connection) {
  issues <- list()
  
  # Check unit enrolments without valid admissions
  query <- "
    SELECT COUNT(*) as orphaned_units
    FROM UnitEnrolments ue
    LEFT JOIN CourseAdmissions ca ON ue.Admission_ID = ca.Admission_ID
    WHERE ca.Admission_ID IS NULL AND ue.IsCurrent = TRUE
  "
  
  result <- dbGetQuery(connection, query)
  if (result$orphaned_units > 0) {
    issues$unit_enrolments <- result$orphaned_units
    log_message(paste("Found", result$orphaned_units, "orphaned unit enrolments"), "WARNING")
  }
  
  # Check admissions without valid students
  query <- "
    SELECT COUNT(*) as orphaned_admissions
    FROM CourseAdmissions ca
    LEFT JOIN HEPStudents s ON ca.Student_Key = s.Student_Key
    WHERE s.Student_Key IS NULL AND ca.IsCurrent = TRUE
  "
  
  result <- dbGetQuery(connection, query)
  if (result$orphaned_admissions > 0) {
    issues$admissions <- result$orphaned_admissions
    log_message(paste("Found", result$orphaned_admissions, "orphaned admissions"), "WARNING")
  }
  
  return(issues)
}

# Check for duplicate records
check_duplicates <- function(connection) {
  issues <- list()
  
  # Check duplicate students
  query <- "
    SELECT E313_StudentIdentificationCode, COUNT(*) as count
    FROM HEPStudents
    WHERE IsCurrent = TRUE
    GROUP BY E313_StudentIdentificationCode
    HAVING COUNT(*) > 1
  "
  
  duplicates <- dbGetQuery(connection, query)
  if (nrow(duplicates) > 0) {
    issues$duplicate_students <- duplicates
    log_message(paste("Found", nrow(duplicates), "duplicate student IDs"), "WARNING")
  }
  
  # Check duplicate CHESSN
  query <- "
    SELECT E488_CHESSN, COUNT(*) as count
    FROM HEPStudents
    WHERE E488_CHESSN IS NOT NULL AND IsCurrent = TRUE
    GROUP BY E488_CHESSN
    HAVING COUNT(*) > 1
  "
  
  duplicates <- dbGetQuery(connection, query)
  if (nrow(duplicates) > 0) {
    issues$duplicate_chessn <- duplicates
    log_message(paste("Found", nrow(duplicates), "duplicate CHESSN"), "WARNING")
  }
  
  return(issues)
}

# Check data completeness
check_completeness <- function(connection) {
  completeness_stats <- list()
  
  # Check required fields in students
  query <- "
    SELECT 
      COUNT(*) as total_students,
      SUM(CASE WHEN E488_CHESSN IS NULL THEN 1 ELSE 0 END) as missing_chessn,
      SUM(CASE WHEN E584_USI IS NULL THEN 1 ELSE 0 END) as missing_usi,
      SUM(CASE WHEN E314_DateOfBirth IS NULL THEN 1 ELSE 0 END) as missing_dob
    FROM HEPStudents
    WHERE IsCurrent = TRUE
  "
  
  completeness_stats$students <- dbGetQuery(connection, query)
  
  # Check required fields in admissions
  query <- "
    SELECT 
      COUNT(*) as total_admissions,
      SUM(CASE WHEN E330_AttendanceTypeCode IS NULL THEN 1 ELSE 0 END) as missing_attendance,
      SUM(CASE WHEN Reporting_Year IS NULL THEN 1 ELSE 0 END) as missing_year
    FROM CourseAdmissions
    WHERE IsCurrent = TRUE
  "
  
  completeness_stats$admissions <- dbGetQuery(connection, query)
  
  return(completeness_stats)
}

# Check referential integrity
check_referential_integrity <- function(connection) {
  issues <- list()
  
  # Check courses referenced in admissions exist
  query <- "
    SELECT DISTINCT ca.UID5_CoursesResKey
    FROM CourseAdmissions ca
    LEFT JOIN Courses c ON ca.UID5_CoursesResKey = c.UID5_CoursesResKey
    WHERE c.UID5_CoursesResKey IS NULL AND ca.IsCurrent = TRUE
  "
  
  invalid_courses <- dbGetQuery(connection, query)
  if (nrow(invalid_courses) > 0) {
    issues$invalid_course_refs <- invalid_courses
    log_message(paste("Found", nrow(invalid_courses), "invalid course references"), "ERROR")
  }
  
  return(issues)
}

# Check business rules
check_business_rules <- function(connection) {
  violations <- list()
  
  # Rule 1: ATAR should be between 0 and 99.95
  query <- "
    SELECT Student_Key, E632_ATAR
    FROM CourseAdmissions
    WHERE E632_ATAR IS NOT NULL 
      AND (E632_ATAR < 0 OR E632_ATAR > 99.95)
      AND IsCurrent = TRUE
  "
  
  invalid_atar <- dbGetQuery(connection, query)
  if (nrow(invalid_atar) > 0) {
    violations$invalid_atar <- invalid_atar
    log_message(paste("Found", nrow(invalid_atar), "invalid ATAR scores"), "WARNING")
  }
  
  # Rule 2: Census date should be after commencement date
  query <- "
    SELECT UID16_UnitEnrolmentsResKey, E600_UnitOfStudyCommencementDate, E489_UnitOfStudyCensusDate
    FROM UnitEnrolments
    WHERE E489_UnitOfStudyCensusDate < E600_UnitOfStudyCommencementDate
      AND IsCurrent = TRUE
  "
  
  invalid_dates <- dbGetQuery(connection, query)
  if (nrow(invalid_dates) > 0) {
    violations$invalid_census_dates <- invalid_dates
    log_message(paste("Found", nrow(invalid_dates), "units with census before commencement"), "WARNING")
  }
  
  # Rule 3: EFTSL should be between 0 and 1
  query <- "
    SELECT UID16_UnitEnrolmentsResKey, UE_E339_EFTSL
    FROM UnitEnrolments
    WHERE UE_E339_EFTSL IS NOT NULL 
      AND (UE_E339_EFTSL < 0 OR UE_E339_EFTSL > 1)
      AND IsCurrent = TRUE
  "
  
  invalid_eftsl <- dbGetQuery(connection, query)
  if (nrow(invalid_eftsl) > 0) {
    violations$invalid_eftsl <- invalid_eftsl
    log_message(paste("Found", nrow(invalid_eftsl), "invalid EFTSL values"), "WARNING")
  }
  
  return(violations)
}

# Generate quality report
generate_quality_report <- function(results) {
  report_file <- file.path(
    FILE_PATHS$output_dir,
    paste0("data_quality_report_", format(Sys.Date(), "%Y%m%d"), ".txt")
  )
  
  sink(report_file)
  
  cat("TCSI Data Quality Report\n")
  cat("========================\n")
  cat("Generated:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")
  
  # Orphaned records
  if (length(results$orphaned) > 0) {
    cat("Orphaned Records:\n")
    print(results$orphaned)
    cat("\n")
  }
  
  # Duplicate records
  if (length(results$duplicates) > 0) {
    cat("Duplicate Records:\n")
    print(results$duplicates)
    cat("\n")
  }
  
  # Completeness
  cat("Data Completeness:\n")
  print(results$completeness)
  cat("\n")
  
  # Business rule violations
  if (length(results$business_rules) > 0) {
    cat("Business Rule Violations:\n")
    print(summary(results$business_rules))
    cat("\n")
  }
  
  sink()
  
  log_message(paste("Quality report saved to", report_file), "INFO")
}

# ================================================
# 10. ETL/reconciliation.R - Data Reconciliation
# ================================================
# ETL/reconciliation.R

source("ETL/config.R")
source("ETL/logging.R")

# Reconcile source vs target data
reconcile_data <- function(source_path, target_table, connection = NULL) {
  log_message(paste("Reconciling", source_path, "with", target_table), "INFO")
  
  if (is.null(connection)) {
    connection <- create_db_connection()
    on.exit(dbDisconnect(connection))
  }
  
  # Load source data
  source_data <- read_csv(source_path)
  
  # Get target data
  target_data <- dbGetQuery(connection, paste0("SELECT * FROM ", target_table, " WHERE IsCurrent = TRUE"))
  
  # Count reconciliation
  reconciliation <- list(
    source_count = nrow(source_data),
    target_count = nrow(target_data),
    difference = nrow(source_data) - nrow(target_data)
  )
  
  # Identify missing records
  if ("E313_StudentIdentificationCode" %in% names(source_data)) {
    source_ids <- unique(source_data$E313_StudentIdentificationCode)
    target_ids <- unique(target_data$E313_StudentIdentificationCode)
    
    reconciliation$missing_in_target <- setdiff(source_ids, target_ids)
    reconciliation$extra_in_target <- setdiff(target_ids, source_ids)
  }
  
  # Financial reconciliation for unit enrolments
  if ("UE_E384_AmountCharged" %in% names(source_data)) {
    reconciliation$source_total_amount <- sum(source_data$UE_E384_AmountCharged, na.rm = TRUE)
    reconciliation$target_total_amount <- sum(target_data$UE_E384_AmountCharged, na.rm = TRUE)
    reconciliation$amount_difference <- reconciliation$source_total_amount - reconciliation$target_total_amount
    
    if (abs(reconciliation$amount_difference) > 0.01) {
      log_message(paste("Financial discrepancy:", reconciliation$amount_difference), "WARNING")
    }
  }
  
  # EFTSL reconciliation
  if ("UE_E339_EFTSL" %in% names(source_data)) {
    reconciliation$source_total_eftsl <- sum(source_data$UE_E339_EFTSL, na.rm = TRUE)
    reconciliation$target_total_eftsl <- sum(target_data$UE_E339_EFTSL, na.rm = TRUE)
    reconciliation$eftsl_difference <- reconciliation$source_total_eftsl - reconciliation$target_total_eftsl
  }
  
  # Generate reconciliation report
  generate_reconciliation_report(reconciliation, source_path, target_table)
  
  return(reconciliation)
}

# Generate reconciliation report
generate_reconciliation_report <- function(reconciliation, source_path, target_table) {
  report_file <- file.path(
    FILE_PATHS$output_dir,
    paste0("reconciliation_", target_table, "_", format(Sys.Date(), "%Y%m%d"), ".csv")
  )
  
  report_df <- data.frame(
    Metric = names(reconciliation),
    Value = sapply(reconciliation, function(x) {
      if (is.list(x)) paste(x, collapse = ";") else as.character(x)
    }),
    stringsAsFactors = FALSE
  )
  
  write_csv(report_df, report_file)
  log_message(paste("Reconciliation report saved to", report_file), "INFO")
}

# ================================================
# 11. ETL/wide_table_generator.R - Generate Wide Tables
# ================================================
# ETL/wide_table_generator.R

source("ETL/config.R")
source("ETL/logging.R")

# Generate HEP_units_AOUs wide table
generate_wide_table <- function(connection = NULL) {
  log_message("Generating HEP_units_AOUs wide table", "INFO")
  
  if (is.null(connection)) {
    connection <- create_db_connection()
    on.exit(dbDisconnect(connection))
  }
  
  # Complex query to join all related tables
  query <- "
    SELECT 
      -- Student fields
      s.Student_Key,
      s.E313_StudentIdentificationCode,
      s.E488_CHESSN,
      s.E402_StudentFamilyName,
      s.E403_StudentGivenNameFirst,
      
      -- Admission fields
      ca.Admission_ID,
      ca.UID15_CourseAdmissionsResKey,
      ca.UID5_CoursesResKey,
      ca.E534_CourseOfStudyCommencementDate,
      ca.E330_AttendanceTypeCode,
      ca.Reporting_Year,
      
      -- Course fields
      c.E307_CourseCode,
      c.E308_CourseName,
      c.E310_CourseOfStudyType,
      c.E596_StandardCourseDuration,
      
      -- Unit Enrolment fields
      ue.UnitEnrolment_ID,
      ue.UID16_UnitEnrolmentsResKey,
      ue.E354_UnitOfStudyCode,
      ue.E489_UnitOfStudyCensusDate,
      ue.E464_DisciplineCode,
      ue.E355_UnitOfStudyStatusCode,
      ue.E329_ModeOfAttendanceCode,
      ue.E490_StudentStatusCode,
      ue.E600_UnitOfStudyCommencementDate,
      ue.E601_UnitOfStudyOutcomeDate,
      ue.UE_E339_EFTSL,
      ue.UE_E384_AmountCharged,
      ue.UE_E381_AmountPaidUpfront,
      ue.UE_E558_HELPLoanAmount,
      ue.UE_E529_LoanFee,
      
      -- AOU fields
      aou.AOU_ID,
      aou.UID19_UnitEnrolmentAOUsResKey,
      aou.E333_AOUCode,
      aou.AOU_E339_EFTSL,
      aou.AOU_E384_AmountCharged,
      aou.AOU_E381_AmountPaidUpfront,
      aou.AOU_E529_LoanFee,
      
      -- Metadata
      CURRENT_DATE as GeneratedDate,
      ue.UpdatedAt,
      ue.IsCurrent
      
    FROM HEPStudents s
    INNER JOIN CourseAdmissions ca ON s.Student_Key = ca.Student_Key
    INNER JOIN Courses c ON ca.UID5_CoursesResKey = c.UID5_CoursesResKey
    INNER JOIN UnitEnrolments ue ON ca.Admission_ID = ue.Admission_ID
    LEFT JOIN UnitEnrolmentAOUs aou ON ue.UnitEnrolment_ID = aou.UnitEnrolment_ID
    WHERE s.IsCurrent = TRUE 
      AND ca.IsCurrent = TRUE 
      AND c.IsCurrent = TRUE
      AND ue.IsCurrent = TRUE
      AND (aou.IsCurrent = TRUE OR aou.IsCurrent IS NULL)
  "
  
  # Execute query and create wide table
  wide_data <- dbGetQuery(connection, query)
  
  # Drop existing wide table if exists
  if (dbExistsTable(connection, "HEP_units_AOUs")) {
    dbRemoveTable(connection, "HEP_units_AOUs")
  }
  
  # Create new wide table
  dbWriteTable(connection, "HEP_units_AOUs", wide_data, row.names = FALSE)
  
  log_message(paste("Wide table generated with", nrow(wide_data), "rows"), "INFO")
  
  # Create indexes for performance
  index_queries <- c(
    "CREATE INDEX idx_wide_student ON HEP_units_AOUs(Student_Key)",
    "CREATE INDEX idx_wide_admission ON HEP_units_AOUs(Admission_ID)",
    "CREATE INDEX idx_wide_unit ON HEP_units_AOUs(UID16_UnitEnrolmentsResKey)",
    "CREATE INDEX idx_wide_year ON HEP_units_AOUs(Reporting_Year)"
  )
  
  for (query in index_queries) {
    dbExecute(connection, query)
  }
  
  return(nrow(wide_data))
}

# ================================================
# 12. ETL/archive.R - Archive Historical Data
# ================================================
# ETL/archive.R

source("ETL/config.R")
source("ETL/logging.R")

# Archive old data
archive_historical_data <- function(cutoff_date = NULL, connection = NULL) {
  log_message("Starting data archival process", "INFO")
  
  if (is.null(cutoff_date)) {
    # Default: archive data older than 3 years
    cutoff_date <- Sys.Date() - years(3)
  }
  
  if (is.null(connection)) {
    connection <- create_db_connection()
    on.exit(dbDisconnect(connection))
  }
  
  archived_counts <- list()
  
  # Archive unit enrolments
  archived_counts$unit_enrolments <- archive_table(
    "UnitEnrolments",
    "UnitEnrolments_Archive",
    paste0("UpdatedAt < '", cutoff_date, "' AND IsCurrent = FALSE"),
    connection
  )
  
  # Archive student records
  archived_counts$students <- archive_table(
    "HEPStudents",
    "HEPStudents_Archive",
    paste0("UpdatedAt < '", cutoff_date, "' AND IsCurrent = FALSE"),
    connection
  )
  
  # Generate archive summary
  generate_archive_summary(archived_counts, cutoff_date)
  
  return(archived_counts)
}

# Archive specific table
archive_table <- function(source_table, archive_table, where_clause, connection) {
  log_message(paste("Archiving", source_table), "INFO")
  
  # Create archive table if not exists
  if (!dbExistsTable(connection, archive_table)) {
    create_query <- paste0(
      "CREATE TABLE ", archive_table, " LIKE ", source_table
    )
    dbExecute(connection, create_query)
  }
  
  # Copy data to archive
  insert_query <- paste0(
    "INSERT INTO ", archive_table, " ",
    "SELECT * FROM ", source_table, " ",
    "WHERE ", where_clause
  )
  
  rows_archived <- dbExecute(connection, insert_query)
  
  # Delete from source
  if (rows_archived > 0) {
    delete_query <- paste0(
      "DELETE FROM ", source_table, " ",
      "WHERE ", where_clause
    )
    dbExecute(connection, delete_query)
  }
  
  log_message(paste("Archived", rows_archived, "rows from", source_table), "INFO")
  
  return(rows_archived)
}

# Generate archive summary
generate_archive_summary <- function(archived_counts, cutoff_date) {
  summary_file <- file.path(
    FILE_PATHS$archive_dir,
    paste0("archive_summary_", format(Sys.Date(), "%Y%m%d"), ".txt")
  )
  
  writeLines(c(
    paste("Archive Summary - ", format(Sys.Date(), "%Y-%m-%d")),
    paste("Cutoff Date:", cutoff_date),
    "",
    "Tables Archived:",
    sapply(names(archived_counts), function(table) {
      paste0("  ", table, ": ", archived_counts[[table]], " rows")
    })
  ), summary_file)
  
  log_message(paste("Archive summary saved to", summary_file), "INFO")
}

# ================================================
# 13. ETL/scheduler.cron - Cron Schedule Configuration
# ================================================
# This would be a cron configuration file, not R code
# Place in /etc/cron.d/tcsi_etl or use crontab -e

# Daily ETL at 2 AM
# 0 2 * * * /usr/local/bin/Rscript /path/to/ETL/main.R >> /path/to/logs/etl_cron.log 2>&1

# Weekly data quality check on Sundays at 3 AM
# 0 3 * * 0 /usr/local/bin/Rscript /path/to/ETL/data_quality.R >> /path/to/logs/quality_cron.log 2>&1

# Monthly archival on the 1st at 4 AM
# 0 4 1 * * /usr/local/bin/Rscript /path/to/ETL/archive.R >> /path/to/logs/archive_cron.log 2>&1

# Generate wide table after daily ETL
# 30 2 * * * /usr/local/bin/Rscript /path/to/ETL/wide_table_generator.R >> /path/to/logs/wide_table_cron.log 2>&1