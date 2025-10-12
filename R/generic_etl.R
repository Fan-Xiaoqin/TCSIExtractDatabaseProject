# Generic ETL Function
# TCSI ETL Project - Student Data Module

#' Generic ETL Function
#'
#' Provides a reusable ETL function for any table with field mapping.

# ==========================================
# GENERIC ETL FUNCTION
# ==========================================

#' Generic ETL function for any table
#' @param conn Database connection
#' @param table_name Table name
#' @param csv_file_pattern CSV file pattern
#' @param mapping Field mapping configuration
#' @param csv_file_path Optional specific path to CSV file
#' @return List with success status and statistics
generic_etl <- function(conn, import_dir, table_name, csv_file_pattern, mapping, csv_file_path = NULL) {
  log_info(paste("Starting ETL for", table_name))

  # Initialize statistics
  stats <- list(
    table_name = table_name,
    csv_file = NULL,
    total_rows = 0,
    processed_rows = 0,
    valid_rows = 0,
    invalid_rows = 0,
    loaded_rows = 0,
    errors = 0,
    success = FALSE
  )

  # Find CSV file
  if (is.null(csv_file_path)) {
    csv_file_path <- find_csv_file(csv_file_pattern, import_dir)
    if (is.null(csv_file_path)) {
      log_error(paste("CSV file not found for pattern:", csv_file_pattern))
      return(stats)
    }
  }

  stats$csv_file <- csv_file_path
  log_info(paste("Using CSV file:", csv_file_path))

  # Validate CSV structure
  log_info("Validating CSV structure...")
  csv_validation <- validate_csv_structure(csv_file_path, mapping, table_name)

  if (!csv_validation$valid) {
    for (error in csv_validation$errors) {
      log_error(error, table_name = table_name)
    }
    return(stats)
  }

  for (warning in csv_validation$warnings) {
    log_warn(warning, table_name = table_name)
  }

  # Read CSV file
  log_info("Reading CSV file...")
  tryCatch({
    data <- read.csv(
      csv_file_path,
      stringsAsFactors = FALSE,
      na.strings = c("", "NA", "NULL"),
      nrows = if (!is.null(MAX_ROWS_TO_PROCESS)) MAX_ROWS_TO_PROCESS else -1
    )

    stats$total_rows <- nrow(data)
    log_info(paste("Read", stats$total_rows, "rows from CSV"))

  }, error = function(e) {
    log_error(paste("Failed to read CSV file:", e$message), table_name = table_name)
    return(stats)
  })

  # Check if data is empty
  if (nrow(data) == 0) {
    log_warn("CSV file is empty - no data to process", table_name = table_name)
    stats$success <- TRUE  # Not an error, just empty
    return(stats)
  }

  # Process in batches
  log_info("Processing data in batches...")
  batch_start <- 1

  while (batch_start <= nrow(data)) {
    batch_end <- min(batch_start + BATCH_SIZE - 1, nrow(data))
    batch_data <- data[batch_start:batch_end, , drop = FALSE]

    log_debug(paste("Processing batch:", batch_start, "to", batch_end))

    # Transform batch (pass connection for FK resolution and csv_file_path for derived fields)
    transformed_rows <- transform_batch(batch_data, mapping, table_name, conn, csv_file_path = csv_file_path)

    # Validate batch
    validation_result <- validate_batch(transformed_rows, mapping, conn, table_name)

    stats$valid_rows <- stats$valid_rows + length(validation_result$valid_rows)
    stats$invalid_rows <- stats$invalid_rows + length(validation_result$invalid_rows)

    # Report validation errors
    if (length(validation_result$invalid_rows) > 0) {
      report_validation_errors(validation_result$invalid_rows, table_name)

      # Log invalid rows to error file
      for (invalid_row_info in validation_result$invalid_rows) {
        error_msg <- paste(invalid_row_info$errors, collapse = "; ")
        log_row_error(
          table_name,
          batch_start + invalid_row_info$row_num - 1,
          invalid_row_info$row,
          error_msg
        )
      }
    }

    # Load valid rows using smart insert (routes to appropriate method)
    inserted_count <- 0
    updated_count <- 0
    unchanged_count <- 0

    for (row in validation_result$valid_rows) {
      result <- db_smart_insert(conn, table_name, row, mapping)

      if (result == "INSERTED") {
        inserted_count <- inserted_count + 1
        stats$loaded_rows <- stats$loaded_rows + 1
      } else if (result == "UPDATED") {
        updated_count <- updated_count + 1
        stats$loaded_rows <- stats$loaded_rows + 1
      } else if (result == "UNCHANGED") {
        unchanged_count <- unchanged_count + 1
        # Count as loaded (data already exists and is current)
        stats$loaded_rows <- stats$loaded_rows + 1
      } else {
        stats$errors <- stats$errors + 1
      }
    }

    # Log insert/update/unchanged summary for this batch
    if (inserted_count > 0 || updated_count > 0 || unchanged_count > 0) {
      log_debug(paste0(
        "Batch results: ",
        inserted_count, " inserted, ",
        updated_count, " updated, ",
        unchanged_count, " unchanged"
      ))
    }

    stats$processed_rows <- batch_end

    # Move to next batch
    batch_start <- batch_end + 1
  }

  # Log summary
  log_validation_summary(
    stats$total_rows,
    stats$valid_rows,
    stats$invalid_rows,
    table_name
  )

  log_info(sprintf(
    "ETL complete for %s: %d rows loaded, %d errors",
    table_name,
    stats$loaded_rows,
    stats$errors
  ))

  stats$success <- (stats$loaded_rows > 0 || stats$total_rows == 0)

  return(stats)
}

# ==========================================
# GENERIC DATA QUALITY CHECKS
# ==========================================

#' Generic data quality checks
#' @param conn Database connection
#' @param table_name Table name
#' @param mapping Field mapping configuration
#' @param key_field Optional key field to check for duplicates
#' @return List with quality check results
generic_data_quality_checks <- function(conn, table_name, mapping, key_field = NULL) {
  log_info(paste("Running data quality checks for", table_name))

  results <- list()

  # Check 1: Verify row count
  loaded_count <- db_count(conn, table_name)
  results$loaded_count <- loaded_count
  log_info(paste("Total rows in", table_name, ":", loaded_count))

  # Check 2: Check for duplicate keys if specified
  if (!is.null(key_field)) {
    all_data <- db_query(conn, table_name)
    if (nrow(all_data) > 0 && key_field %in% names(all_data)) {
      duplicates <- check_duplicate_keys(
        conn,
        table_name,
        key_field,
        all_data[[key_field]]
      )

      if (length(duplicates) > 0) {
        log_warn(paste("Found", length(duplicates), "duplicate values in", key_field))
        results$duplicates <- duplicates
      } else {
        log_info(paste("No duplicate values found in", key_field))
        results$duplicates <- character(0)
      }
    }
  }

  # Check 3: Data completeness for required fields
  all_data <- db_query(conn, table_name)
  if (nrow(all_data) > 0) {
    completeness <- check_data_completeness(all_data, mapping$required_fields)
    results$completeness <- completeness

    for (field in names(completeness)) {
      log_info(sprintf(
        "Field %s: %.1f%% complete (%d NULL / %d total)",
        field,
        completeness[[field]]$completeness_pct,
        completeness[[field]]$null_count,
        completeness[[field]]$total_count
      ))
    }
  }

  return(results)
}
