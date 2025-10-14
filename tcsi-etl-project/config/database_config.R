# Database Configuration
# TCSI ETL Project - Student Data Module

#' Database Configuration Settings
#'
#' This file contains all configuration parameters for the ETL process.
#' Modify these settings as needed for different environments.

# ==========================================
# DATABASE CONNECTION SETTINGS
# ==========================================

# Current Mode: DUMMY (in-memory data frames)
# Set to "POSTGRESQL" when ready to connect to actual database
DB_MODE <- "POSTGRESQL"

if (!requireNamespace("getPass", quietly = TRUE)) {
  install.packages("getPass")
}
library(getPass)

# PostgreSQL Connection Settings (for future use)
DB_CONFIG <- list(
  host = "localhost",
  port = 5432,
  dbname = "tcsi_db",
  user = "",
  password = ""
)

# Detect if running inside Shiny (fixed)
RUNNING_IN_SHINY <- nzchar(Sys.getenv("SHINY_PORT"))

# Prompt only if not running in Shiny
if (!RUNNING_IN_SHINY) {
  if (is.null(DB_CONFIG$user) || DB_CONFIG$user == "") {
    DB_CONFIG$user <- getPass::getPass("Enter DB username: ")
  }
  
  if (is.null(DB_CONFIG$password) || DB_CONFIG$password == "") {
    DB_CONFIG$password <- getPass::getPass("Enter DB password: ")
  }
}


# ==========================================
# ETL PROCESSING SETTINGS
# ==========================================

# Batch size for processing large CSV files
BATCH_SIZE <- 1000

# Maximum rows to read (NULL for all rows, useful for testing)
MAX_ROWS_TO_PROCESS <- NULL  # Set to e.g. 100 for testing

# ==========================================
# FILE PATH SETTINGS
# ==========================================

# Base directory for the project (adjust if running from different location)
PROJECT_ROOT <- getwd()

# Data directories
DATA_INPUT_DIR <- file.path(PROJECT_ROOT, "data", "tcsiSample")
DATA_LOGS_DIR <- file.path(PROJECT_ROOT, "data", "logs")
DATA_ERRORS_DIR <- file.path(PROJECT_ROOT, "data", "errors")

# Mapping files directories
# MAPPING_EXCEL_DIR <- file.path(PROJECT_ROOT, "..", "Students")
MAPPING_CSV_DIR <- file.path(PROJECT_ROOT, "..", "datamapping")

# ==========================================
# CSV FILE PATTERNS
# ==========================================

# File patterns for locating CSV files
# CSV_FILES <- list(
#   hep_students = "hep_students.csv",
#   hep_student_citizenships = "hep_student_citizenships.csv",
#   hep_student_disabilities = "hep_student_disabilities.csv",
#   student_contacts_first_address = "student_contacts_first_reported_address.csv",
#   student_residential_address = "student_residential_address.csv",
#   commonwealth_scholarships = "commonwealth_scholarships.csv"
# )

# ==========================================
# LOGGING SETTINGS
# ==========================================

# Log levels: DEBUG, INFO, WARN, ERROR
LOG_LEVEL <- "INFO"

# Log file name pattern (timestamp will be added)
LOG_FILE_PREFIX <- "etl_students"

# Console logging
LOG_TO_CONSOLE <- TRUE

# File logging
LOG_TO_FILE <- TRUE

# ==========================================
# VALIDATION SETTINGS
# ==========================================

# Stop processing on first critical error
STOP_ON_ERROR <- FALSE

# Maximum errors to log per table (prevents huge error files)
MAX_ERRORS_PER_TABLE <- 1000

# ==========================================
# DATA TRANSFORMATION SETTINGS
# ==========================================

# Date formats to try (in order)
DATE_FORMATS <- c("ymd", "dmy", "mdy")

# Hash field truncation length
HASH_TRUNCATE_LENGTH <- 10

# NULL string representation in source data
NULL_STRING <- "NULL"

# ==========================================
# DUMMY DATABASE SETTINGS
# ==========================================

# Dummy DB storage (global environment)
DUMMY_DB_ENV <- new.env()

# Initialize dummy database tables
init_dummy_db <- function() {
  # Create empty data frames for each table
  DUMMY_DB_ENV$hep_students <- data.frame()
  DUMMY_DB_ENV$hep_student_citizenships <- data.frame()
  DUMMY_DB_ENV$hep_student_disabilities <- data.frame()
  DUMMY_DB_ENV$student_contacts_first_reported_address <- data.frame()
  DUMMY_DB_ENV$student_residential_address <- data.frame()
  DUMMY_DB_ENV$commonwealth_scholarships <- data.frame()
  
  # Transaction backup storage
  DUMMY_DB_ENV$backup <- list()
  DUMMY_DB_ENV$in_transaction <- FALSE
  
  return(invisible(NULL))
}

# ==========================================
# HELPER FUNCTIONS
# ==========================================

#' Find CSV file by pattern
#' @param pattern File pattern to search for
#' @param directory Directory to search in (defaults to DATA_INPUT_DIR)
#' @return Full path to first matching file, or NULL if not found
find_csv_file <- function(pattern, directory = DATA_INPUT_DIR) {
  files <- list.files(directory, pattern = glob2rx(pattern), full.names = TRUE)
  if (length(files) == 0) {
    return(NULL)
  }
  return(files[1])  # Return first match
}

#' Find CSV file by pattern
#' @param pattern File pattern to search for
#' @param directory Directory to search in (defaults to DATA_INPUT_DIR)
#' @return Full path to all matching files, or NULL if not found
find_csv_files <- function(pattern, directory = DATA_INPUT_DIR) {
  files <- list.files(directory, pattern = glob2rx(pattern), full.names = TRUE)
  if (length(files) == 0) {
    return(NULL)
  }
  return(files)  # Return all matches
}

#' Get log file path
#' @param suffix Optional suffix for log file name
#' @return Full path to log file
get_log_file_path <- function(suffix = "") {
  timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  filename <- paste0(LOG_FILE_PREFIX, suffix, "_", timestamp, ".log")
  return(file.path(DATA_LOGS_DIR, filename))
}

#' Get error file path
#' @param table_name Name of the table
#' @return Full path to error file
get_error_file_path <- function(table_name) {
  filename <- paste0(table_name, "_errors.csv")
  return(file.path(DATA_ERRORS_DIR, filename))
}

# ==========================================
# INITIALIZATION
# ==========================================

# Ensure directories exist
dir.create(DATA_LOGS_DIR, showWarnings = FALSE, recursive = TRUE)
dir.create(DATA_ERRORS_DIR, showWarnings = FALSE, recursive = TRUE)

# Initialize dummy database if in DUMMY mode
if (DB_MODE == "DUMMY") {
  init_dummy_db()
}

# Print configuration summary
cat("\n=== TCSI ETL Configuration ===\n")
cat("Database Mode:", DB_MODE, "\n")
cat("Batch Size:", BATCH_SIZE, "\n")
cat("Data Input Dir:", DATA_INPUT_DIR, "\n")
cat("Logs Dir:", DATA_LOGS_DIR, "\n")
cat("Errors Dir:", DATA_ERRORS_DIR, "\n")
cat("Log Level:", LOG_LEVEL, "\n")
cat("==============================\n\n")
