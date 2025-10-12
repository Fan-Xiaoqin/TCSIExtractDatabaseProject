# Transformation Utilities
# TCSI ETL Project - Student Data Module

#' Transformation Utilities
#' 
#' Provides data transformation functions for CSV data.

# ==========================================
# NULL HANDLING
# ==========================================

#' Convert NULL strings to actual NA
#' @param value Input value
#' @return Cleaned value (NA if NULL string)
clean_null <- function(value) {
  if (is.null(value) || is.na(value)) {
    return(NA)
  }
  
  # Handle character values
  if (is.character(value)) {
    # Trim whitespace
    value <- trimws(value)
    
    # Check for NULL string or empty
    if (value == "" || value == NULL_STRING) {
      return(NA)
    }
  }
  
  return(value)
}

#' Clean NULL values in a data frame row
#' @param row Data frame row (single row)
#' @return Cleaned row
clean_nulls_in_row <- function(row) {
  for (col in names(row)) {
    row[[col]] <- clean_null(row[[col]])
  }
  return(row)
}

# ==========================================
# STRING TRANSFORMATIONS
# ==========================================

#' Truncate hash field to specified length
#' @param value Hash value
#' @param length Truncation length (default from config)
#' @return Truncated hash
truncate_hash <- function(value, length = HASH_TRUNCATE_LENGTH) {
  if (is.null(value) || is.na(value)) {
    return(NA)
  }
  
  value <- as.character(value)
  if (nchar(value) <= length) {
    return(value)
  }
  
  return(substr(value, 1, length))
}

#' Trim whitespace from string
#' @param value String value
#' @return Trimmed string
trim_string <- function(value) {
  if (is.null(value) || is.na(value)) {
    return(NA)
  }
  return(trimws(as.character(value)))
}

# ==========================================
# DATE TRANSFORMATIONS
# ==========================================

#' Parse date from various formats
#' @param value Date string
#' @param table_name Optional table name for logging
#' @param row_num Optional row number for logging
#' @param field_name Optional field name for logging
#' @return Date object or NA
parse_date <- function(value, table_name = NULL, row_num = NULL, field_name = NULL) {
  if (is.null(value) || is.na(value)) {
    return(NA)
  }
  
  # Clean the value
  value <- clean_null(value)
  if (is.na(value)) {
    return(NA)
  }
  
  # If already a Date object, return it
  if (inherits(value, "Date")) {
    return(value)
  }
  
  # Convert to string
  value <- as.character(value)
  
  # Try different date formats
  parsed_date <- NULL
  
  # Check if lubridate is available
  if (requireNamespace("lubridate", quietly = TRUE)) {
    for (format in DATE_FORMATS) {
      tryCatch({
        if (format == "ymd") {
          parsed_date <- lubridate::ymd(value)
        } else if (format == "dmy") {
          parsed_date <- lubridate::dmy(value)
        } else if (format == "mdy") {
          parsed_date <- lubridate::mdy(value)
        }
        
        if (!is.na(parsed_date)) {
          break
        }
      }, error = function(e) {
        # Try next format
      })
    }
  } else {
    # Fallback without lubridate
    tryCatch({
      parsed_date <- as.Date(value)
    }, error = function(e) {
      # Failed to parse
    })
  }
  
  if (is.null(parsed_date) || is.na(parsed_date)) {
    log_warn(paste("Failed to parse date:", value), 
             table_name = table_name, 
             row_num = row_num, 
             field_name = field_name)
    return(NA)
  }
  
  return(parsed_date)
}

# ==========================================
# NUMERIC TRANSFORMATIONS
# ==========================================

#' Convert to integer safely
#' @param value Input value
#' @param table_name Optional table name for logging
#' @param row_num Optional row number for logging
#' @param field_name Optional field name for logging
#' @return Integer or NA
to_integer <- function(value, table_name = NULL, row_num = NULL, field_name = NULL) {
  value <- clean_null(value)
  if (is.na(value)) {
    return(NA_integer_)
  }
  
  tryCatch({
    result <- as.integer(value)
    if (is.na(result)) {
      log_warn(paste("Failed to convert to integer:", value),
               table_name = table_name,
               row_num = row_num,
               field_name = field_name)
    }
    return(result)
  }, error = function(e) {
    log_warn(paste("Error converting to integer:", value, "-", e$message),
             table_name = table_name,
             row_num = row_num,
             field_name = field_name)
    return(NA_integer_)
  })
}

#' Convert to numeric safely
#' @param value Input value
#' @param table_name Optional table name for logging
#' @param row_num Optional row number for logging
#' @param field_name Optional field name for logging
#' @return Numeric or NA
to_numeric <- function(value, table_name = NULL, row_num = NULL, field_name = NULL) {
  value <- clean_null(value)
  if (is.na(value)) {
    return(NA_real_)
  }
  
  tryCatch({
    result <- as.numeric(value)
    if (is.na(result)) {
      log_warn(paste("Failed to convert to numeric:", value),
               table_name = table_name,
               row_num = row_num,
               field_name = field_name)
    }
    return(result)
  }, error = function(e) {
    log_warn(paste("Error converting to numeric:", value, "-", e$message),
             table_name = table_name,
             row_num = row_num,
             field_name = field_name)
    return(NA_real_)
  })
}

# ==========================================
# ROW TRANSFORMATION
# ==========================================

#' Check if field is a date field
#' @param db_col Database column name
#' @param mapping Field mapping configuration
#' @return TRUE if date field, FALSE otherwise
is_date_field <- function(db_col, mapping) {
  if (is.null(mapping$date_fields)) {
    return(FALSE)
  }
  return(db_col %in% mapping$date_fields)
}

#' Transform a CSV row according to field mappings
#' @param row Data frame row (single row)
#' @param mapping Field mapping configuration
#' @param table_name Table name (for logging)
#' @param row_num Row number (for logging)
#' @return Transformed row as named list
transform_row <- function(row, mapping, table_name, row_num) {
  transformed <- list()
  
  # Clean NULL values first
  row <- clean_nulls_in_row(row)
  
  # Process each field according to mapping
  for (csv_col in names(mapping$csv_to_db)) {
    db_col <- mapping$csv_to_db[[csv_col]]
    
    # Get value from CSV row
    value <- row[[csv_col]]
    
    # Apply transformations based on field type
    
    # # 1. Truncate fields that need truncation (e.g., for VARCHAR limits)
    # if (should_truncate_field(db_col, mapping)) {
    #   if (!is.null(value) && !is.na(value) && is.character(value)) {
    #     # Truncate to 6 characters for course codes
    #     if (nchar(value) > 6) {
    #       log_warn(paste("Truncating", db_col, "from", nchar(value), "to 6 characters:", value),
    #                table_name = table_name, row_num = row_num)
    #       value <- substr(value, 1, 6)
    #     }
    #   }
    # }
    
    # 2. Parse date fields
    if (is_date_field(db_col, mapping)) {
      value <- parse_date(value, table_name, row_num, db_col)
    }
    
    # 3. Trim string fields
    if (is.character(value)) {
      value <- trim_string(value)
    }
    
    # Store transformed value
    transformed[[db_col]] <- value
  }
  
  return(transformed)
}

# ==========================================
# FOREIGN KEY RESOLUTION
# ==========================================

# Global cache for UID lookups (speeds up FK resolution)
.uid_cache <- new.env(parent = emptyenv())

#' Clear the UID cache
clear_uid_cache <- function() {
  rm(list = ls(envir = .uid_cache), envir = .uid_cache)
}

#' Resolve foreign key ID from business key
#' @param business_key_value Business key value from CSV
#' @param fk_def Foreign key definition (list with references_table, references_field, reference_column)
#' @param conn Database connection
#' @param table_name Table name (for logging)
#' @param row_num Row number (for logging)
#' @return Numeric ID or NA if not found
resolve_foreign_key_id <- function(business_key_value, fk_def, conn, table_name = NULL, row_num = NULL) {
  ref_table <- fk_def$references_table
  ref_field <- fk_def$references_field
  ref_column <- fk_def$reference_column
  
  # Check cache first
  cache_key <- paste0(ref_table, "_", ref_field, "_", business_key_value)
  if (exists(cache_key, envir = .uid_cache)) {
    return(get(cache_key, envir = .uid_cache))
  }
  
  # Clean the business key value
  bk_value <- clean_null(business_key_value)
  if (is.na(bk_value)) {
    log_warn(paste0("Cannot resolve ", ref_column, ": ", ref_field, " is NULL"),
             table_name = table_name, row_num = row_num)
    return(NA_integer_)
  }
  
  # Query database for the numeric ID
  tryCatch({
    query <- sprintf(
      "SELECT %s FROM %s WHERE %s = '%s'",
      ref_column,
      ref_table,
      ref_field,
      bk_value
    )
    
    result <- DBI::dbGetQuery(conn, query)
    
    if (nrow(result) == 0) {
      log_warn(paste0("No record found in ", ref_table, " for ", ref_field, ": ", bk_value),
               table_name = table_name, row_num = row_num)
      return(NA_integer_)
    }
    
    if (nrow(result) > 1) {
      log_warn(paste0("Multiple records found in ", ref_table, " for ", ref_field, ": ", bk_value),
               table_name = table_name, row_num = row_num)
    }
    
    fk_id <- as.integer(result[[ref_column]][1])
    
    # Cache the result
    assign(cache_key, fk_id, envir = .uid_cache)
    
    return(fk_id)
    
  }, error = function(e) {
    log_error(paste0("Error resolving ", ref_column, " for ", bk_value, ": ", e$message),
              table_name = table_name, row_num = row_num)
    return(NA_integer_)
  })
}

#' Resolve student_id from uid8_students_res_key (convenience wrapper)
#' @param uid8_students_res_key Business key from CSV
#' @param conn Database connection
#' @param table_name Table name (for logging)
#' @param row_num Row number (for logging)
#' @return student_id (numeric) or NA if not found
resolve_student_id <- function(uid8_students_res_key, conn, table_name = NULL, row_num = NULL) {
  fk_def <- list(
    references_table = "hep_students",
    references_field = "uid8_students_res_key",
    reference_column = "student_id"
  )
  return(resolve_foreign_key_id(uid8_students_res_key, fk_def, conn, table_name, row_num))
}

#' Resolve foreign key references in a row
#' @param row Transformed row (as list)
#' @param mapping Field mapping configuration
#' @param conn Database connection
#' @param table_name Table name (for logging)
#' @param row_num Row number (for logging)
#' @return Row with foreign keys resolved
resolve_foreign_keys <- function(row, mapping, conn, table_name, row_num) {
  # Check if mapping has foreign keys
  if (is.null(mapping$foreign_keys) || length(mapping$foreign_keys) == 0) {
    return(row)
  }
  
  # Process each foreign key
  for (fk_def in mapping$foreign_keys) {
    field <- fk_def$field
    ref_table <- fk_def$references_table
    ref_field <- fk_def$references_field
    ref_column <- fk_def$reference_column
    
    # Check if we have the business key in the row
    if (!field %in% names(row)) {
      next
    }
    
    business_key_value <- row[[field]]
    
    # Skip if NULL/NA
    if (is_null_value(business_key_value)) {
      next
    }
    
    # Resolve foreign key using generic function
    fk_id <- resolve_foreign_key_id(business_key_value, fk_def, conn, table_name, row_num)
    
    # Remove the business key and add the numeric foreign key
    row[[field]] <- NULL
    row[[ref_column]] <- fk_id
    
    if (is.na(fk_id)) {
      log_warn(paste0("Failed to resolve ", ref_column, " for ", business_key_value),
               table_name = table_name, row_num = row_num)
    }
  }
  
  return(row)
}

# ==========================================
# BATCH TRANSFORMATION
# ==========================================

#' Transform multiple rows
#' @param data Data frame with multiple rows
#' @param mapping Field mapping configuration
#' @param table_name Table name (for logging)
#' @param conn Database connection (optional, for FK resolution)
#' @return List of transformed rows
transform_batch <- function(data, mapping, table_name, conn = NULL, csv_file_path = NULL) {
  transformed_rows <- list()
  
  # Extract year from filename for unit_enrolments tables
  reporting_year <- NULL
  if (!is.null(csv_file_path) && (table_name == "unit_enrolments" || table_name == "unit_enrolments_aous")) {
    # Extract year from filename like "HEP_units-AOUs_2017.csv"
    year_match <- regmatches(csv_file_path, regexpr("\\d{4}", csv_file_path))
    if (length(year_match) > 0) {
      reporting_year <- as.integer(year_match[1])
      log_info(paste("Extracted reporting_year:", reporting_year, "from filename:", basename(csv_file_path)))
    }
  }

  for (i in seq_len(nrow(data))) {
    row <- data[i, , drop = FALSE]
    transformed <- transform_row(row, mapping, table_name, i)

    # Add reporting_year for unit_enrolments tables
    if (!is.null(reporting_year) && (table_name == "unit_enrolments" || table_name == "unit_enrolments_aous")) {
      transformed$reporting_year <- reporting_year
    }

    # Resolve foreign keys if connection provided
    if (!is.null(conn) && !is.null(mapping$foreign_keys)) {
      transformed <- resolve_foreign_keys(transformed, mapping, conn, table_name, i)
    }

    transformed_rows[[i]] <- transformed
  }

  return(transformed_rows)
}

# ==========================================
# DATA TYPE INFERENCE
# ==========================================

#' Infer appropriate R data type for database column type
#' @param db_type Database column type (e.g., "varchar", "integer", "date")
#' @return R class name
infer_r_type <- function(db_type) {
  db_type <- tolower(db_type)
  
  if (grepl("int", db_type)) {
    return("integer")
  } else if (grepl("numeric|decimal|double|float", db_type)) {
    return("numeric")
  } else if (grepl("date", db_type)) {
    return("Date")
  } else if (grepl("bool", db_type)) {
    return("logical")
  } else {
    return("character")
  }
}

# ==========================================
# COLUMN MAPPING
# ==========================================

#' Map CSV columns to database columns
#' @param csv_columns Vector of CSV column names
#' @param mapping Field mapping configuration
#' @return Named vector: names are DB columns, values are CSV columns
map_columns <- function(csv_columns, mapping) {
  result <- character()
  
  for (csv_col in csv_columns) {
    if (csv_col %in% names(mapping$csv_to_db)) {
      db_col <- mapping$csv_to_db[[csv_col]]
      result[db_col] <- csv_col
    } else {
      # Keep unmapped columns with lowercase names
      db_col <- tolower(csv_col)
      result[db_col] <- csv_col
      log_warn(paste("No mapping found for CSV column:", csv_col))
    }
  }
  
  return(result)
}

# ==========================================
# HELPER FUNCTIONS
# ==========================================

#' Check if value is effectively NULL
#' @param value Value to check
#' @return TRUE if NULL/NA/empty, FALSE otherwise
is_null_value <- function(value) {
  if (is.null(value) || is.na(value)) {
    return(TRUE)
  }
  
  if (is.character(value)) {
    value <- trimws(value)
    if (value == "" || value == NULL_STRING) {
      return(TRUE)
    }
  }
  
  return(FALSE)
}

#' Format value for display
#' @param value Value to format
#' @return String representation
format_value <- function(value) {
  if (is.null(value) || is.na(value)) {
    return("NULL")
  }
  
  if (is.character(value)) {
    if (nchar(value) > 50) {
      return(paste0(substr(value, 1, 47), "..."))
    }
    return(value)
  }
  
  return(as.character(value))
}

