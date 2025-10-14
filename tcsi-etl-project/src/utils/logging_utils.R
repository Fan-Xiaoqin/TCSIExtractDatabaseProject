# Logging Utilities
# TCSI ETL Project - Student Data Module

#' Logging Utilities
#' 
#' Provides structured logging functionality for the ETL process.

# Load required configuration
if (!exists("LOG_LEVEL")) {
  source("config/database_config.R")
}

# ==========================================
# LOGGING STATE
# ==========================================

LOG_STATE <- new.env()
LOG_STATE$file_handle <- NULL
LOG_STATE$error_counts <- list()
LOG_STATE$warning_counts <- list()

# ==========================================
# LOG LEVEL DEFINITIONS
# ==========================================

LOG_LEVELS <- list(
  DEBUG = 1,
  INFO = 2,
  WARN = 3,
  ERROR = 4
)

# ==========================================
# INITIALIZATION
# ==========================================

#' Initialize logging
#' @param log_file Optional path to log file
#' @return Invisible NULL
init_logging <- function(log_file = NULL) {
  if (is.null(log_file) && LOG_TO_FILE) {
    log_file <- get_log_file_path()
  }
  
  if (!is.null(log_file)) {
    LOG_STATE$file_handle <- file(log_file, open = "wt")
    cat(sprintf("=== ETL Process Started: %s ===\n\n", Sys.time()), 
        file = LOG_STATE$file_handle)
  }
  
  LOG_STATE$error_counts <- list()
  LOG_STATE$warning_counts <- list()
  
  log_info("Logging initialized")
  return(invisible(NULL))
}

#' Close logging
#' @return Invisible NULL
close_logging <- function() {
  if (!is.null(LOG_STATE$file_handle)) {
    cat(sprintf("\n=== ETL Process Completed: %s ===\n", Sys.time()),
        file = LOG_STATE$file_handle)
    close(LOG_STATE$file_handle)
    LOG_STATE$file_handle <- NULL
  }
  return(invisible(NULL))
}

# ==========================================
# CORE LOGGING FUNCTIONS
# ==========================================

#' Write log message
#' @param level Log level (DEBUG, INFO, WARN, ERROR)
#' @param message Log message
#' @param table_name Optional table name for context
#' @param row_num Optional row number for context
#' @param field_name Optional field name for context
#' @return Invisible NULL
log_message <- function(level, message, table_name = NULL, row_num = NULL, field_name = NULL) {
  # Check if we should log this level
  current_level <- LOG_LEVELS[[LOG_LEVEL]]
  msg_level <- LOG_LEVELS[[level]]
  
  if (msg_level < current_level) {
    return(invisible(NULL))
  }
  
  # Build context
  context <- character(0)
  if (!is.null(table_name)) {
    context <- c(context, paste0("Table: ", table_name))
  }
  if (!is.null(row_num)) {
    context <- c(context, paste0("Row: ", row_num))
  }
  if (!is.null(field_name)) {
    context <- c(context, paste0("Field: ", field_name))
  }
  
  context_str <- if (length(context) > 0) paste0(" [", paste(context, collapse = ", "), "]") else ""
  
  # Format message
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  formatted_msg <- sprintf("[%s] [%s]%s %s\n", timestamp, level, context_str, message)
  
  # Write to console
  if (LOG_TO_CONSOLE) {
    cat(formatted_msg)
  }
  
  # Write to file
  if (!is.null(LOG_STATE$file_handle)) {
    cat(formatted_msg, file = LOG_STATE$file_handle)
  }
  
  # Track error/warning counts
  if (level == "ERROR" && !is.null(table_name)) {
    if (is.null(LOG_STATE$error_counts[[table_name]])) {
      LOG_STATE$error_counts[[table_name]] <- 0
    }
    LOG_STATE$error_counts[[table_name]] <- LOG_STATE$error_counts[[table_name]] + 1
  }
  
  if (level == "WARN" && !is.null(table_name)) {
    if (is.null(LOG_STATE$warning_counts[[table_name]])) {
      LOG_STATE$warning_counts[[table_name]] <- 0
    }
    LOG_STATE$warning_counts[[table_name]] <- LOG_STATE$warning_counts[[table_name]] + 1
  }
  
  return(invisible(NULL))
}

#' Log debug message
#' @param message Log message
#' @param ... Additional context parameters
log_debug <- function(message, ...) {
  log_message("DEBUG", message, ...)
}

#' Log info message
#' @param message Log message
#' @param ... Additional context parameters
log_info <- function(message, ...) {
  log_message("INFO", message, ...)
}

#' Log warning message
#' @param message Log message
#' @param ... Additional context parameters
log_warn <- function(message, ...) {
  log_message("WARN", message, ...)
}

#' Log error message
#' @param message Log message
#' @param ... Additional context parameters
log_error <- function(message, ...) {
  log_message("ERROR", message, ...)
}

# ==========================================
# ERROR TRACKING
# ==========================================

#' Log row error to error file
#' @param table_name Table name
#' @param row_num Row number
#' @param row_data Original row data
#' @param error_message Error message
#' @return Invisible NULL
log_row_error <- function(table_name, row_num, row_data, error_message) {
  # Check if we've exceeded max errors for this table
  if (!is.null(LOG_STATE$error_counts[[table_name]]) &&
      LOG_STATE$error_counts[[table_name]] >= MAX_ERRORS_PER_TABLE) {
    return(invisible(NULL))
  }
  
  # Get error file path
  error_file <- get_error_file_path(table_name)
  
  # Create error data frame
  error_df <- data.frame(
    row_number = row_num,
    error_message = error_message,
    timestamp = Sys.time(),
    stringsAsFactors = FALSE
  )
  
  # Add original row data
  if (is.list(row_data)) {
    for (col in names(row_data)) {
      error_df[[col]] <- as.character(row_data[[col]])
    }
  }
  
  # Append to error file
  if (file.exists(error_file)) {
    write.table(error_df, error_file, append = TRUE, sep = ",", 
                row.names = FALSE, col.names = FALSE, quote = TRUE)
  } else {
    write.table(error_df, error_file, append = FALSE, sep = ",", 
                row.names = FALSE, col.names = TRUE, quote = TRUE)
  }
  
  return(invisible(NULL))
}

# ==========================================
# SUMMARY REPORTING
# ==========================================

#' Print error/warning summary
#' @return Invisible NULL
print_log_summary <- function() {
  cat("\n=== ETL Process Summary ===\n")
  
  if (length(LOG_STATE$error_counts) > 0) {
    cat("\nErrors by table:\n")
    for (table in names(LOG_STATE$error_counts)) {
      cat(sprintf("  %s: %d errors\n", table, LOG_STATE$error_counts[[table]]))
    }
  } else {
    cat("\nNo errors encountered.\n")
  }
  
  if (length(LOG_STATE$warning_counts) > 0) {
    cat("\nWarnings by table:\n")
    for (table in names(LOG_STATE$warning_counts)) {
      cat(sprintf("  %s: %d warnings\n", table, LOG_STATE$warning_counts[[table]]))
    }
  }
  
  cat("\n===========================\n\n")
  return(invisible(NULL))
}

#' Get error count for table
#' @param table_name Table name
#' @return Error count
get_error_count <- function(table_name) {
  if (is.null(LOG_STATE$error_counts[[table_name]])) {
    return(0)
  }
  return(LOG_STATE$error_counts[[table_name]])
}

#' Get warning count for table
#' @param table_name Table name
#' @return Warning count
get_warning_count <- function(table_name) {
  if (is.null(LOG_STATE$warning_counts[[table_name]])) {
    return(0)
  }
  return(LOG_STATE$warning_counts[[table_name]])
}

cat("Logging utilities loaded successfully.\n")
