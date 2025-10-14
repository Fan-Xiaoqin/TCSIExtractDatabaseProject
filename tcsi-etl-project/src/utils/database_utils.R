# Database Utilities
# TCSI ETL Project - Student Data Module

#' Database Utilities
#' 
#' Provides database operations for both DUMMY and PostgreSQL modes.

# Load required configuration
if (!exists("DB_MODE")) {
  source("config/database_config.R")
}

if (!exists("log_info")) {
  source("src/utils/logging_utils.R")
}

# ==========================================
# DATABASE CONNECTION
# ==========================================

#' Connect to database
#' @return Database connection object (or NULL for DUMMY mode)
db_connect <- function() {
  if (DB_MODE == "DUMMY") {
    log_info("Using DUMMY database mode (in-memory)")
    return(NULL)
  } else if (DB_MODE == "POSTGRESQL") {
    log_info("Connecting to PostgreSQL database")
    library(DBI)
    library(RPostgres)
    
    conn <- dbConnect(
      RPostgres::Postgres(),
      dbname = DB_CONFIG$dbname,
      host = DB_CONFIG$host,
      port = DB_CONFIG$port,
      user = DB_CONFIG$user,
      password = DB_CONFIG$password
    )
    
    log_info(paste("Connected to database:", DB_CONFIG$dbname))
    return(conn)
  } else {
    stop(paste("Unknown DB_MODE:", DB_MODE))
  }
}

#' Disconnect from database
#' @param conn Database connection
#' @return Invisible NULL
db_disconnect <- function(conn) {
  if (!is.null(conn)) {
    if (DB_MODE == "POSTGRESQL") {
      dbDisconnect(conn)
    }
    log_info("Database connection closed")
  }
  return(invisible(NULL))
}

# ==========================================
# DUMMY DATABASE OPERATIONS
# ==========================================

#' Insert row into dummy database table
#' @param table_name Table name
#' @param row_data Named list or data frame with row data
#' @return TRUE if successful, FALSE otherwise
dummy_db_insert <- function(table_name, row_data) {
  tryCatch({
    # Convert to data frame if it's a list
    if (is.list(row_data) && !is.data.frame(row_data)) {
      row_data <- as.data.frame(row_data, stringsAsFactors = FALSE)
    }
    
    # Get existing table
    existing_table <- DUMMY_DB_ENV[[table_name]]
    
    if (is.null(existing_table) || nrow(existing_table) == 0) {
      # First row - create table structure
      DUMMY_DB_ENV[[table_name]] <- row_data
    } else {
      # Append row - ensure columns match
      # Add missing columns with NA
      missing_cols <- setdiff(names(existing_table), names(row_data))
      for (col in missing_cols) {
        row_data[[col]] <- NA
      }
      
      # Reorder columns to match existing table
      row_data <- row_data[names(existing_table)]
      
      # Append
      DUMMY_DB_ENV[[table_name]] <- rbind(existing_table, row_data)
    }
    
    return(TRUE)
  }, error = function(e) {
    log_error(paste("Failed to insert into dummy DB:", e$message), table_name = table_name)
    return(FALSE)
  })
}

#' Query dummy database table
#' @param table_name Table name
#' @param where_clause Optional named list for WHERE conditions
#' @return Data frame with query results
dummy_db_query <- function(table_name, where_clause = NULL) {
  table_data <- DUMMY_DB_ENV[[table_name]]
  
  if (is.null(table_data) || nrow(table_data) == 0) {
    return(data.frame())
  }
  
  # Apply WHERE clause if provided
  if (!is.null(where_clause)) {
    for (field in names(where_clause)) {
      if (field %in% names(table_data)) {
        table_data <- table_data[table_data[[field]] == where_clause[[field]], , drop = FALSE]
      }
    }
  }
  
  return(table_data)
}

#' Check if row exists in dummy database
#' @param table_name Table name
#' @param where_clause Named list for WHERE conditions
#' @return TRUE if exists, FALSE otherwise
dummy_db_exists <- function(table_name, where_clause) {
  result <- dummy_db_query(table_name, where_clause)
  return(nrow(result) > 0)
}

#' Get row count from dummy database table
#' @param table_name Table name
#' @return Row count
dummy_db_count <- function(table_name) {
  table_data <- DUMMY_DB_ENV[[table_name]]
  if (is.null(table_data)) {
    return(0)
  }
  return(nrow(table_data))
}

# ==========================================
# GENERIC DATABASE OPERATIONS
# ==========================================

#' Insert row into database
#' @param conn Database connection (NULL for DUMMY mode)
#' @param table_name Table name
#' @param row_data Named list or data frame with row data
#' @return TRUE if successful, FALSE otherwise
db_insert <- function(conn, table_name, row_data) {
  if (DB_MODE == "DUMMY") {
    return(dummy_db_insert(table_name, row_data))
  } else {
    tryCatch({
      # Convert to data frame if needed
      if (is.list(row_data) && !is.data.frame(row_data)) {
        row_data <- as.data.frame(row_data, stringsAsFactors = FALSE)
      }
      dbWriteTable(conn, table_name, row_data, append = TRUE, row.names = FALSE)
      return(TRUE)
    }, error = function(e) {
      log_error(paste("Failed to insert into", table_name, ":", e$message))
      return(FALSE)
    })
  }
}

# ==========================================
# UPSERT WITH UPDATE (override_enabled = TRUE)
# ==========================================

#' Insert or Update row (for reference/lookup tables)
#' 
#' Uses PostgreSQL's INSERT ... ON CONFLICT DO UPDATE to either insert
#' a new row or update an existing row when the primary key already exists.
#' 
#' @param conn Database connection
#' @param table_name Table name
#' @param row_data Named list or data frame with row data
#' @param mapping Field mapping configuration (to get primary key)
#' @return "INSERTED", "UPDATED", or FALSE on error
db_upsert_with_update <- function(conn, table_name, row_data, mapping) {
  if (DB_MODE == "DUMMY") {
    # For DUMMY mode, just insert (simplified)
    return(if (dummy_db_insert(table_name, row_data)) "INSERTED" else FALSE)
  }
  
  tryCatch({
    # Convert to data frame if needed
    if (is.list(row_data) && !is.data.frame(row_data)) {
      row_data <- as.data.frame(row_data, stringsAsFactors = FALSE)
    }
    
    # Get primary key field directly from mapping
    primary_key <- mapping$primary_key
    
    if (is.null(primary_key) || primary_key == "") {
      log_error(paste("No primary_key defined in mapping for", table_name))
      return(FALSE)
    }
    
    # Prepare column names and values
    columns <- names(row_data)
    
    # Get boolean fields from mapping
    boolean_fields <- if (!is.null(mapping$boolean_fields)) mapping$boolean_fields else c()
    
    values <- sapply(columns, function(col) {
      val <- row_data[[col]]
      if (is.na(val) || is.null(val)) {
        return("NULL")
      } else if (is.logical(val)) {
        return(if (val) "TRUE" else "FALSE")
      } else if (col %in% boolean_fields) {
        # Convert 0/1 to TRUE/FALSE for boolean fields
        return(if (as.numeric(val) == 1) "TRUE" else "FALSE")
      } else if (is.numeric(val) && !is.na(as.numeric(val))) {
        # Numeric values don't need quotes
        return(as.character(val))
      } else {
        # Everything else (dates, strings, etc.) needs quotes
        return(paste0("'", gsub("'", "''", as.character(val)), "'"))
      }
    })
    
    # Build UPDATE SET clause (exclude primary key and updated_at)
    update_cols <- setdiff(columns, c(primary_key, "updated_at"))
    update_clause <- paste(
      sapply(update_cols, function(col) {
        idx <- which(columns == col)
        paste0(col, " = ", values[idx])
      }),
      collapse = ", "
    )
    
    # Build INSERT ... ON CONFLICT DO UPDATE query
    query <- sprintf(
      "INSERT INTO %s (%s) VALUES (%s) ON CONFLICT (%s) DO UPDATE SET %s, updated_at = CURRENT_TIMESTAMP RETURNING CASE WHEN xmax = 0 THEN true ELSE false END AS inserted",
      table_name,
      paste(columns, collapse = ", "),
      paste(values, collapse = ", "),
      primary_key,
      update_clause
    )
    
    # Execute and check if inserted or updated
    result <- tryCatch({
      dbGetQuery(conn, query)
    }, error = function(e) {
      log_error(paste("Query execution failed for", table_name, ":", e$message))
      log_error(paste("Query was:", query))
      return(data.frame())
    })

    if (is.null(result) || nrow(result) == 0) {
      log_error(paste("Upsert failed - no result returned for", table_name))
      return(FALSE)
    }
    
    if (!is.null(result$inserted) && length(result$inserted) > 0 && isTRUE(result$inserted[1])) {
      log_debug(paste("Inserted new row into", table_name))
      return("INSERTED")
    } else {
      log_debug(paste("Updated existing row in", table_name))
      return("UPDATED")
    }
    
  }, error = function(e) {
    log_error(paste("Failed to upsert into", table_name, ":", e$message , query))
    return(FALSE)
  })
}
# ==========================================
# INSERT WITH HISTORY (override_enabled = FALSE)
# ==========================================

#' Insert with historical tracking using is_current flag
#' 
#' For tables with temporal/historical tracking:
#' 1. Checks if a row with same override_check_fields AND is_current=TRUE exists
#' 2. If exists AND values identical → Skip insert (no change)
#' 3. If exists BUT values differ → Set old row is_current=FALSE, insert new with is_current=TRUE
#' 4. If doesn't exist → Insert new row with is_current=TRUE
#' 
#' @param conn Database connection
#' @param table_name Table name
#' @param row_data Named list or data frame with row data
#' @param mapping Field mapping configuration (contains override_check_fields)
#' @return "INSERTED", "UPDATED", "UNCHANGED", or FALSE on error
db_insert_with_history <- function(conn, table_name, row_data, mapping) {
  if (DB_MODE == "DUMMY") {
    # For DUMMY mode, just insert (simplified)
    return(if (dummy_db_insert(table_name, row_data)) "INSERTED" else FALSE)
  }
  
  tryCatch({
    # Convert to data frame if needed
    if (is.list(row_data) && !is.data.frame(row_data)) {
      row_data <- as.data.frame(row_data, stringsAsFactors = FALSE)
    }
    
    # Get override_check_fields
    check_fields <- mapping$override_check_fields
    if (is.null(check_fields) || length(check_fields) == 0) {
      log_warn(paste("No override_check_fields defined for", table_name, "- using simple insert"))
      return(if (db_insert(conn, table_name, row_data)) "INSERTED" else FALSE)
    }
    
    # Build WHERE clause to find existing is_current=TRUE row
    where_conditions <- sapply(check_fields, function(field) {
      if (field %in% names(row_data)) {
        val <- row_data[[field]]
        if (is.na(val) || is.null(val)) {
          return(paste0(field, " IS NULL"))
        } else {
          # Quote ALL values in WHERE clause to match PostgreSQL types
          # (even if they look numeric, they might be VARCHAR in the DB)
          return(paste0(field, " = '", gsub("'", "''", as.character(val)), "'"))
        }
      }
      return(NULL)
    })
    
    where_conditions <- where_conditions[!sapply(where_conditions, is.null)]
    where_clause <- paste(c(where_conditions, "is_current = TRUE"), collapse = " AND ")
    
    # Query for existing is_current=TRUE row
    query_existing <- sprintf("SELECT * FROM %s WHERE %s", table_name, where_clause)
    
    # Try to query - handle errors gracefully
    existing_rows <- tryCatch({
      dbGetQuery(conn, query_existing)
    }, error = function(e) {
      log_error(paste("Failed to query existing row in", table_name, ":", e$message))
      log_error(paste("Query was:", query_existing))
      return(NULL)
    })
    
    if (is.null(existing_rows)) {
      log_info(paste("existing_rows null", table_name))
      return(FALSE)
    }
    log_info(paste("existing_rows exists ", existing_rows , table_name))
    if (nrow(existing_rows) == 0) {
      # No existing row - insert new with is_current=TRUE
      row_data$is_current <- TRUE
      row_data$updated_at <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
      
      success <- db_insert(conn, table_name, row_data)
      if (success) {
        log_debug(paste("Inserted new row into", table_name, "(no existing is_current=TRUE row)"))
        return("INSERTED")
      } else {
        return(FALSE)
      }
    } else {
      return("UNCHANGED")
    }
  }, error = function(e) {
    log_error(paste("Failed to insert with history into", table_name, ":", e$message))
    return(FALSE)
  })
}

# ==========================================
# SMART INSERT (routes to appropriate method)
# ==========================================

#' Smart insert that routes to appropriate method based on mapping
#' 
#' @param conn Database connection
#' @param table_name Table name
#' @param row_data Named list or data frame with row data
#' @param mapping Field mapping configuration
#' @return "INSERTED", "UPDATED", "UNCHANGED", or FALSE on error
db_smart_insert <- function(conn, table_name, row_data, mapping) {
  # Check override_enabled flag
  override_enabled <- if (!is.null(mapping$override_enabled)) mapping$override_enabled else FALSE
  
  if (override_enabled) {
    # Use upsert with update for reference/lookup tables
    return(db_upsert_with_update(conn, table_name, row_data, mapping))
  } else {
    # Use insert with history for transactional/temporal tables
    return(db_insert_with_history(conn, table_name, row_data, mapping))
  }
}

# ==========================================
# LEGACY UPSERT FUNCTION (kept for compatibility)
# ==========================================

#' Insert row into database using UPSERT (INSERT ... ON CONFLICT DO NOTHING)
#' @param conn Database connection
#' @param table_name Table name
#' @param row_data Named list or data frame with row data
#' @param unique_keys Character vector of column names that define uniqueness
#' @return TRUE, "EXISTS", or FALSE
db_insert_upsert <- function(conn, table_name, row_data, unique_keys) {
  if (DB_MODE == "DUMMY") {
    return(dummy_db_insert(table_name, row_data))
  }

  tryCatch({
    if (is.list(row_data) && !is.data.frame(row_data)) {
      row_data <- as.data.frame(row_data, stringsAsFactors = FALSE)
    }

    columns <- names(row_data)
    values <- sapply(row_data, function(val) {
      if (is.na(val) || is.null(val)) {
        return("NULL")
      } else if (is.character(val)) {
        return(paste0("'", gsub("'", "''", val), "'"))
      } else {
        return(as.character(val))
      }
    })

    conflict_keys <- paste(unique_keys, collapse = ", ")

    query <- sprintf(
      "INSERT INTO %s (%s) VALUES (%s) ON CONFLICT (%s) DO NOTHING",
      table_name,
      paste(columns, collapse = ", "),
      paste(values, collapse = ", "),
      conflict_keys
    )

    rows_affected <- dbExecute(conn, query)

    if (rows_affected > 0) {
      log_info(paste("Inserted new row into", table_name))
      return(TRUE)
    } else {
      log_info(paste("Row already exists in", table_name, "- skipped due to conflict on:", conflict_keys))
      return("EXISTS")
    }

  }, error = function(e) {
    log_error(paste("Failed to upsert into", table_name, ":", e$message))
    return(FALSE)
  })
}

# ==========================================
# QUERY AND EXISTENCE CHECKS
# ==========================================

#' Query database table
#' @param conn Database connection (NULL for DUMMY mode)
#' @param table_name Table name
#' @param where_clause Optional WHERE conditions
#' @return Data frame with query results
db_query <- function(conn, table_name, where_clause = NULL) {
  if (DB_MODE == "DUMMY") {
    return(dummy_db_query(table_name, where_clause))
  } else {
    query <- paste("SELECT * FROM", table_name)
    if (!is.null(where_clause)) {
      conditions <- sapply(names(where_clause), function(field) {
        value <- where_clause[[field]]
        # Quote ALL values to match PostgreSQL VARCHAR types
        paste0(field, " = '", gsub("'", "''", as.character(value)), "'")
      })
      query <- paste(query, "WHERE", paste(conditions, collapse = " AND "))
    }
    return(dbGetQuery(conn, query))
  }
}

#' Check if row exists in database
#' @param conn Database connection (NULL for DUMMY mode)
#' @param table_name Table name
#' @param where_clause WHERE conditions
#' @return TRUE if exists, FALSE otherwise
db_exists <- function(conn, table_name, where_clause) {
  if (DB_MODE == "DUMMY") {
    return(dummy_db_exists(table_name, where_clause))
  } else {
    result <- db_query(conn, table_name, where_clause)
    return(nrow(result) > 0)
  }
}

#' Get row count from database table
#' @param conn Database connection (NULL for DUMMY mode)
#' @param table_name Table name
#' @return Row count
db_count <- function(conn, table_name) {
  if (DB_MODE == "DUMMY") {
    return(dummy_db_count(table_name))
  } else {
    result <- dbGetQuery(conn, paste("SELECT COUNT(*) FROM", table_name))
    return(result[[1]])
  }
}

# ==========================================
# TRANSACTION SUPPORT
# ==========================================

#' Begin transaction
#' @param conn Database connection
#' @return Invisible NULL
db_begin_transaction <- function(conn) {
  if (DB_MODE == "DUMMY") {
    DUMMY_DB_ENV$backup <- list()
    for (table_name in ls(DUMMY_DB_ENV)) {
      if (table_name != "backup" && table_name != "in_transaction") {
        DUMMY_DB_ENV$backup[[table_name]] <- DUMMY_DB_ENV[[table_name]]
      }
    }
    DUMMY_DB_ENV$in_transaction <- TRUE
    log_debug("Transaction started (DUMMY mode)")
  } else {
    dbBegin(conn)
    log_debug("Transaction started (PostgreSQL)")
  }
  return(invisible(NULL))
}

#' Commit transaction
#' @param conn Database connection
#' @return Invisible NULL
db_commit <- function(conn) {
  if (DB_MODE == "DUMMY") {
    DUMMY_DB_ENV$backup <- list()
    DUMMY_DB_ENV$in_transaction <- FALSE
    log_debug("Transaction committed (DUMMY mode)")
  } else {
    dbCommit(conn)
    log_debug("Transaction committed (PostgreSQL)")
  }
  return(invisible(NULL))
}

#' Rollback transaction
#' @param conn Database connection
#' @return Invisible NULL
db_rollback <- function(conn) {
  if (DB_MODE == "DUMMY") {
    for (table_name in names(DUMMY_DB_ENV$backup)) {
      DUMMY_DB_ENV[[table_name]] <- DUMMY_DB_ENV$backup[[table_name]]
    }
    DUMMY_DB_ENV$backup <- list()
    DUMMY_DB_ENV$in_transaction <- FALSE
    log_warn("Transaction rolled back (DUMMY mode)")
  } else {
    dbRollback(conn)
    log_warn("Transaction rolled back (PostgreSQL)")
  }
  return(invisible(NULL))
}

# ==========================================
# FOREIGN KEY VALIDATION
# ==========================================

#' Validate foreign key exists
#' @param conn Database connection
#' @param fk_config Foreign key configuration (from field mappings)
#' @param value Value to check
#' @return TRUE if valid, FALSE otherwise
validate_foreign_key <- function(conn, fk_config, value) {
  if (is.null(value) || is.na(value)) {
    return(TRUE)
  }
  
  where_clause <- list()
  where_clause[[fk_config$references_field]] <- value
  
  return(db_exists(conn, fk_config$references_table, where_clause))
}

# ==========================================
# UTILITY FUNCTIONS
# ==========================================

#' Get table statistics
#' @param conn Database connection
#' @param table_name Table name
#' @return List with table statistics
get_table_stats <- function(conn, table_name) {
  count <- db_count(conn, table_name)
  
  stats <- list(
    table_name = table_name,
    row_count = count
  )
  
  return(stats)
}

#' Print all table statistics
#' @param conn Database connection
#' @return Invisible NULL
print_all_table_stats <- function(conn) {
  table_names <- c(
    "hep_students",
    "hep_student_citizenships",
    "hep_student_disabilities",
    "student_contacts_first_reported_address",
    "student_residential_address",
    "commonwealth_scholarships"
  )
  
  cat("\n=== Database Table Statistics ===\n")
  for (table_name in table_names) {
    stats <- get_table_stats(conn, table_name)
    cat(sprintf("%-45s: %6d rows\n", table_name, stats$row_count))
  }
  cat("=================================\n\n")
  
  return(invisible(NULL))
}

cat("Database utilities loaded successfully.\n")
