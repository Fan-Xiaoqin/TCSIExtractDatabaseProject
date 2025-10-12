# Validation Utilities
# TCSI ETL Project - Student Data Module

#' Validation Utilities
#' 
#' Provides data validation functions for ETL process.

# ==========================================
# FIELD VALIDATION
# ==========================================

#' Validate required field
#' @param field_name Field name
#' @param value Field value
#' @param table_name Table name (for error reporting)
#' @param row_num Row number (for error reporting)
#' @return List with valid (TRUE/FALSE) and error_message
validate_required_field <- function(field_name, value, table_name, row_num) {
  if (is_null_value(value)) {
    return(list(
      valid = FALSE,
      error_message = paste("Required field is NULL:", field_name)
    ))
  }
  
  return(list(valid = TRUE, error_message = NULL))
}

#' Validate field against CHECK constraint values
#' @param field_name Field name
#' @param value Field value
#' @param valid_values Vector of valid values
#' @param table_name Table name (for error reporting)
#' @param row_num Row number (for error reporting)
#' @return List with valid (TRUE/FALSE) and error_message
validate_check_constraint <- function(field_name, value, valid_values, table_name, row_num) {
  # NULL values are allowed unless field is required (checked separately)
  if (is_null_value(value)) {
    return(list(valid = TRUE, error_message = NULL))
  }
  
  # Check if value is in valid values
  if (!(value %in% valid_values)) {
    return(list(
      valid = FALSE,
      error_message = paste0(
        "Invalid value for ", field_name, ": '", value, 
        "'. Valid values: ", paste(valid_values, collapse = ", ")
      )
    ))
  }
  
  return(list(valid = TRUE, error_message = NULL))
}

#' Validate foreign key reference
#' @param field_name Field name
#' @param value Field value
#' @param fk_config Foreign key configuration
#' @param conn Database connection
#' @param table_name Table name (for error reporting)
#' @param row_num Row number (for error reporting)
#' @return List with valid (TRUE/FALSE) and error_message
validate_fk_reference <- function(field_name, value, fk_config, conn, table_name, row_num) {
  # NULL values are allowed unless field is required (checked separately)
  if (is_null_value(value)) {
    return(list(valid = TRUE, error_message = NULL))
  }
  
  # Check if foreign key exists
  if (!validate_foreign_key(conn, fk_config, value)) {
    return(list(
      valid = FALSE,
      error_message = paste0(
        "Foreign key violation for ", field_name, ": '", value,
        "' not found in ", fk_config$references_table,
        ".", fk_config$references_field
      )
    ))
  }
  
  return(list(valid = TRUE, error_message = NULL))
}

# ==========================================
# ROW VALIDATION
# ==========================================

#' Validate a complete row
#' @param row Transformed row (named list)
#' @param mapping Field mapping configuration
#' @param conn Database connection
#' @param table_name Table name
#' @param row_num Row number
#' @return List with valid (TRUE/FALSE), errors (vector of error messages), and warnings (vector of warnings)
validate_row <- function(row, mapping, conn, table_name, row_num) {
  errors <- character(0)
  warnings <- character(0)
  
  # 1. Validate required fields
  for (field_name in mapping$required_fields) {
    # Special handling for FK fields that have been resolved
    # After FK resolution, uid8_students_res_key becomes student_id
    if (field_name == "uid8_students_res_key" && !is.null(mapping$foreign_keys)) {
      # Check if this field has FK mapping
      has_fk <- any(sapply(mapping$foreign_keys, function(fk) fk$field == field_name))
      
      if (has_fk) {
        # After FK resolution, skip this field entirely
        # student_id will be validated separately if it's in required_fields
        next
      }
    }
    
    # Normal required field check
    if (field_name %in% names(row)) {
      result <- validate_required_field(
        field_name, 
        row[[field_name]], 
        table_name, 
        row_num
      )
      
      if (!result$valid) {
        errors <- c(errors, result$error_message)
      }
    } else {
      errors <- c(errors, paste("Required field missing:", field_name))
    }
  }
  
  # Special check: If this table has FK resolution, ensure student_id exists and is valid
  if (!is.null(mapping$foreign_keys)) {
    has_student_fk <- any(sapply(mapping$foreign_keys, function(fk) {
      fk$field == "uid8_students_res_key"
    }))
    
    if (has_student_fk) {
      # Validate student_id exists and is not NA
      if ("student_id" %in% names(row)) {
        if (is.na(row[["student_id"]]) || is.null(row[["student_id"]])) {
          errors <- c(errors, "Foreign key resolution failed: student_id is NULL")
        }
      } else {
        errors <- c(errors, "Foreign key resolution failed: student_id not found in row")
      }
    }
  }
  
  # 2. Validate CHECK constraints
  for (field_name in names(mapping$validated_fields)) {
    if (field_name %in% names(row)) {
      valid_values <- mapping$validated_fields[[field_name]]
      result <- validate_check_constraint(
        field_name,
        row[[field_name]],
        valid_values,
        table_name,
        row_num
      )
      
      if (!result$valid) {
        errors <- c(errors, result$error_message)
      }
    }
  }
  
  # 3. Validate foreign key references
  if (!is.null(mapping$foreign_keys)) {
    for (fk_config in mapping$foreign_keys) {
      field_name <- fk_config$field
      
      if (field_name %in% names(row)) {
        result <- validate_fk_reference(
          field_name,
          row[[field_name]],
          fk_config,
          conn,
          table_name,
          row_num
        )
        
        if (!result$valid) {
          errors <- c(errors, result$error_message)
        }
      }
    }
  }
  
  # Determine overall validity
  valid <- length(errors) == 0
  
  return(list(
    valid = valid,
    errors = errors,
    warnings = warnings
  ))
}

# ==========================================
# BATCH VALIDATION
# ==========================================

#' Validate multiple rows
#' @param rows List of transformed rows
#' @param mapping Field mapping configuration
#' @param conn Database connection
#' @param table_name Table name
#' @return List with valid_rows, invalid_rows (with error info)
validate_batch <- function(rows, mapping, conn, table_name) {
  valid_rows <- list()
  invalid_rows <- list()
  
  for (i in seq_along(rows)) {
    row <- rows[[i]]
    validation_result <- validate_row(row, mapping, conn, table_name, i)
    
    if (validation_result$valid) {
      valid_rows[[length(valid_rows) + 1]] <- row
    } else {
      invalid_rows[[length(invalid_rows) + 1]] <- list(
        row_num = i,
        row = row,
        errors = validation_result$errors,
        warnings = validation_result$warnings
      )
    }
  }
  
  return(list(
    valid_rows = valid_rows,
    invalid_rows = invalid_rows
  ))
}

# ==========================================
# CSV FILE VALIDATION
# ==========================================

#' Validate CSV file structure
#' @param file_path Path to CSV file
#' @param mapping Field mapping configuration
#' @param table_name Table name
#' @return List with valid (TRUE/FALSE), errors, warnings
validate_csv_structure <- function(file_path, mapping, table_name) {
  errors <- character(0)
  warnings <- character(0)
  
  # Check file exists
  if (!file.exists(file_path)) {
    errors <- c(errors, paste("CSV file not found:", file_path))
    return(list(valid = FALSE, errors = errors, warnings = warnings))
  }
  
  # Try to read header
  tryCatch({
    header <- read.csv(file_path, nrows = 1, stringsAsFactors = FALSE)
    csv_columns <- names(header)
    
    # Check for required CSV columns
    required_csv_cols <- names(mapping$csv_to_db)
    missing_cols <- setdiff(required_csv_cols, csv_columns)
    
    if (length(missing_cols) > 0) {
      errors <- c(errors, paste("Missing CSV columns:", paste(missing_cols, collapse = ", ")))
    }
    
    # Warn about unexpected columns
    extra_cols <- setdiff(csv_columns, required_csv_cols)
    if (length(extra_cols) > 0) {
      warnings <- c(warnings, paste("Extra CSV columns (will be ignored):", paste(extra_cols, collapse = ", ")))
    }
    
  }, error = function(e) {
    errors <- c(errors, paste("Failed to read CSV file:", e$message))
  })
  
  valid <- length(errors) == 0
  
  return(list(
    valid = valid,
    errors = errors,
    warnings = warnings
  ))
}

# ==========================================
# DATA QUALITY CHECKS
# ==========================================

#' Check for duplicate keys
#' @param conn Database connection
#' @param table_name Table name
#' @param key_field Key field name
#' @param values Vector of values to check
#' @return Vector of duplicate values
check_duplicate_keys <- function(conn, table_name, key_field, values) {
  # Remove NA values
  values <- values[!is.na(values)]
  
  if (length(values) == 0) {
    return(character(0))
  }
  
  # Check for duplicates in the input
  duplicates <- values[duplicated(values)]
  
  if (length(duplicates) > 0) {
    return(unique(duplicates))
  }
  
  return(character(0))
}

#' Validate data completeness
#' @param data Data frame
#' @param required_fields Vector of required field names
#' @return List with completeness statistics
check_data_completeness <- function(data, required_fields) {
  stats <- list()
  
  for (field in required_fields) {
    if (field %in% names(data)) {
      null_count <- sum(is.na(data[[field]]))
      total_count <- nrow(data)
      completeness_pct <- (total_count - null_count) / total_count * 100
      
      stats[[field]] <- list(
        null_count = null_count,
        total_count = total_count,
        completeness_pct = completeness_pct
      )
    }
  }
  
  return(stats)
}

# ==========================================
# VALIDATION REPORTING
# ==========================================

#' Format validation errors for logging
#' @param invalid_rows List of invalid rows with error info
#' @param table_name Table name
#' @return Invisible NULL (logs errors as side effect)
report_validation_errors <- function(invalid_rows, table_name) {
  if (length(invalid_rows) == 0) {
    return(invisible(NULL))
  }
  
  log_info(paste("Found", length(invalid_rows), "invalid rows in", table_name))
  
  for (invalid_row_info in invalid_rows) {
    row_num <- invalid_row_info$row_num
    
    for (error in invalid_row_info$errors) {
      log_error(error, table_name = table_name, row_num = row_num)
    }
    
    for (warning in invalid_row_info$warnings) {
      log_warn(warning, table_name = table_name, row_num = row_num)
    }
  }
  
  return(invisible(NULL))
}

#' Generate validation summary
#' @param total_rows Total number of rows processed
#' @param valid_count Number of valid rows
#' @param invalid_count Number of invalid rows
#' @param table_name Table name
#' @return Invisible NULL (logs summary as side effect)
log_validation_summary <- function(total_rows, valid_count, invalid_count, table_name) {
  log_info(sprintf(
    "Validation summary for %s: %d total rows, %d valid (%.1f%%), %d invalid (%.1f%%)",
    table_name,
    total_rows,
    valid_count,
    valid_count / total_rows * 100,
    invalid_count,
    invalid_count / total_rows * 100
  ))
  
  return(invisible(NULL))
}
