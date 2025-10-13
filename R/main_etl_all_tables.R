# Main ETL Script - ALL TCSI Tables
# TCSI ETL Project - Complete Database Load

#' Main ETL Orchestration for ALL TCSI Tables
#'
#' This script runs the complete ETL process for all 26 tables
#' in the correct order (respecting foreign key dependencies).

# ==========================================
# COMPLETE ETL SEQUENCE - ALL 26 TABLES
# ==========================================

# Order respects foreign key dependencies
# Each table's insert/update behavior determined by mapping's override_enabled flag

ETL_SEQUENCE_ALL <- list(
  # ==========================================
  # PHASE 1: REFERENCE DATA (No dependencies)
  # ==========================================

  list(
    phase = "1-Reference",
    table_name = "courses_of_study",
    csv_pattern = "*CoursesOfStudy.csv",
    mapping = COURSES_OF_STUDY_MAPPING,
    key_field = "e533_course_of_study_code"
  ),

  list(
    phase = "1-Reference",
    table_name = "campuses",
    csv_pattern = "*Campuses.csv",
    mapping = CAMPUSES_MAPPING,
    key_field = "e525_campus_suburb"
  ),
  #
  # # ==========================================
  # # PHASE 2: STUDENTS MASTER (No dependencies)
  # # ==========================================
  #
  list(
    phase = "2-Students",
    table_name = "hep_students",
    csv_pattern = "*HEPStudents.csv",
    mapping = HEP_STUDENTS_MAPPING,
    key_field = "e313_student_identification_code"
  ),
  #
  # # ==========================================
  # # PHASE 3: COURSES (Depends on courses_of_study)
  # # ==========================================
  #
  list(
    phase = "3-Courses",
    table_name = "hep_courses",
    csv_pattern = "*HEPCourses.csv",
    mapping = HEP_COURSES_MAPPING,
    key_field = "e307_course_code"
  ) ,
  #
  list(
    phase = "3-Courses",
    table_name = "special_interest_courses",
    csv_pattern = "*SpecialInterestCourses.csv",
    mapping = SPECIAL_INTEREST_COURSES_MAPPING,
    key_field = NULL
  ),
  #
  list(
    phase = "3-Courses",
    table_name = "course_fields_of_education",
    csv_pattern = "*CourseFieldsOfEducation.csv",
    mapping = COURSE_FIELDS_OF_EDUCATION_MAPPING,
    key_field = NULL
  ),
  #
  # # ==========================================
  # # PHASE 4: CAMPUS-COURSE RELATIONSHIPS
  # # ==========================================
  #
  list(
    phase = "4-Campus-Courses",
    table_name = "hep_courses_on_campuses",
    csv_pattern = "*HEPCoursesOnCampuses.csv",
    mapping = HEP_COURSES_ON_CAMPUSES_MAPPING,
    key_field = NULL
  ),
  #
  list(
    phase = "4-Campus-Courses",
    table_name = "campus_course_fees_itsp",
    csv_pattern = "*CampusCourseFeesITSP.csv",
    mapping = CAMPUS_COURSE_FEES_ITSP_MAPPING,
    key_field = NULL
  ),
  #
  list(
    phase = "4-Campus-Courses",
    table_name = "campuses_tac",
    csv_pattern = "*CampusesTAC.csv",
    mapping = CAMPUSES_TAC_MAPPING,
    key_field = NULL
  ),
  #
  # # ==========================================
  # # PHASE 5: STUDENT DETAILS (Depends on hep_students)
  # # ==========================================
  #
  list(
    phase = "5-Student-Details",
    table_name = "hep_student_citizenships",
    csv_pattern = "*HEPStudentCitizenships.csv",
    mapping = HEP_STUDENT_CITIZENSHIPS_MAPPING,
    key_field = NULL
  ),
  #
  list(
    phase = "5-Student-Details",
    table_name = "hep_student_disabilities",
    csv_pattern = "*HEPStudentDisabilities.csv",
    mapping = HEP_STUDENT_DISABILITIES_MAPPING,
    key_field = NULL
  ),
  #
  list(
    phase = "5-Student-Details",
    table_name = "student_contacts_first_reported_address",
    csv_pattern = "*StudentContactsFirstReportedAddress.csv",
    mapping = STUDENT_CONTACTS_FIRST_ADDRESS_MAPPING,
    key_field = NULL
  ),
  #
  list(
    phase = "5-Student-Details",
    table_name = "commonwealth_scholarships",
    csv_pattern = "*CommonwealthScholarships.csv",
    mapping = COMMONWEALTH_SCHOLARSHIPS_MAPPING,
    key_field = NULL
  ),
  #
  # # ==========================================
  # # PHASE 6: COURSE ADMISSIONS (Depends on students + courses)
  # # ==========================================
  #
  list(
    phase = "6-Admissions",
    table_name = "hep_course_admissions",
    csv_pattern = "*HEPCourseAdmissions.csv",
    mapping = HEP_COURSE_ADMISSIONS_MAPPING,
    key_field = NULL
  ),
  #
  # # ==========================================
  # # PHASE 7: ADMISSION DETAILS (Depends on hep_course_admissions)
  # # ==========================================
  #
  list(
    phase = "7-Admission-Details",
    table_name = "hep_basis_for_admission",
    csv_pattern = "*HEPBasisForAdmission.csv",
    mapping = HEP_BASIS_FOR_ADMISSION_MAPPING,
    key_field = NULL
  ),
  #
  list(
    phase = "7-Admission-Details",
    table_name = "hep_course_prior_credits",
    csv_pattern = "*CoursePriorCredits.csv",
    mapping = HEP_COURSE_PRIOR_CREDITS_MAPPING,
    key_field = NULL
  ),
  #
  list(
    phase = "7-Admission-Details",
    table_name = "course_specialisations",
    csv_pattern = "*CourseSpecialisations.csv",
    mapping = COURSE_SPECIALISATIONS_MAPPING,
    key_field = NULL
  ),
  #
  list(
    phase = "7-Admission-Details",
    table_name = "hep_hdr_end_users_engagement",
    csv_pattern = "*HEPHDREndUsersEngagement.csv",
    mapping = HEP_HDR_END_USERS_ENGAGEMENT_MAPPING,
    key_field = NULL
  ),
  #
  list(
    phase = "7-Admission-Details",
    table_name = "rtp_scholarships",
    csv_pattern = "*RTPScholarships.csv",
    mapping = RTP_SCHOLARSHIPS_MAPPING,
    key_field = NULL
  ),
  #
  list(
    phase = "7-Admission-Details",
    table_name = "rtp_stipend",
    csv_pattern = "*RTPStipend.csv",
    mapping = RTP_STIPEND_MAPPING,
    key_field = NULL
  ),
  #
  # # ==========================================
  # # PHASE 8: FINANCIAL DATA (HELP loans)
  # # ==========================================
  #
  list(
    phase = "8-Financial",
    table_name = "oshelp",
    csv_pattern = "*OSHELP.csv",
    mapping = OSHELP_MAPPING,
    key_field = NULL
  ),
  #
  list(
    phase = "8-Financial",
    table_name = "sahelp",
    csv_pattern = "*SAHELP.csv",
    mapping = SAHELP_MAPPING,
    key_field = NULL
  ),
  #
  # # ==========================================
  # # PHASE 9: AWARDS
  # # ==========================================
  #
  list(
    phase = "9-Awards",
    table_name = "aggregated_awards",
    csv_pattern = "*AggregatedAwards.csv",
    mapping = AGGREGATED_AWARDS_MAPPING,
    key_field = NULL
  ),
  #
  list(
    phase = "9-Awards",
    table_name = "exit_awards",
    csv_pattern = "*ExitAwards.csv",
    mapping = EXIT_AWARDS_MAPPING,
    key_field = NULL
  ),
  #
  # # ==========================================
  # # PHASE 10: UNIT ENROLLMENTS (Depends on admissions)
  # # Note: These are loaded from annual files HEP_units-AOUs_YYYY.csv
  # # ==========================================
  #
  list(
    phase = "10-Unit-Enrollments",
    table_name = "unit_enrolments",
    csv_pattern = "*HEP_units-AOUs_2017.csv",
    mapping = UNIT_ENROLMENTS_MAPPING,
    key_field = NULL
  ),
  #
  list(
    phase = "10-Unit-Enrollments",
    table_name = "unit_enrolments_aous",
    csv_pattern = "*HEP_units-AOUs_2017.csv",
    mapping = UNIT_ENROLMENTS_AOUS_MAPPING,
    key_field = NULL
  )
)

# ==========================================
# MAIN ETL ORCHESTRATION
# ==========================================

#' Run complete ETL for all TCSI tables
#' @param conn Database connection
#' @param sequence ETL sequence configuration (defaults to ETL_SEQUENCE_ALL)
#' @return List with overall statistics and results
run_complete_etl <- function(conn, import_dir, sequence = ETL_SEQUENCE_ALL) {
  log_info("========================================")
  log_info("Starting Complete TCSI ETL (All 26 Tables)")
  log_info("========================================")

  overall_stats <- list(
    start_time = Sys.time(),
    tables_processed = 0,
    tables_succeeded = 0,
    tables_failed = 0,
    tables_skipped = 0,
    total_rows_loaded = 0,
    total_errors = 0,
    table_results = list(),
    phase_results = list()
  )

  current_phase <- NULL
  phase_stats <- NULL

  # Process each table in sequence
  for (etl_config in sequence) {
    table_name <- etl_config$table_name
    phase <- etl_config$phase

    # Track phase changes
    if (is.null(current_phase) || current_phase != phase) {
      if (!is.null(phase_stats)) {
        overall_stats$phase_results[[current_phase]] <- phase_stats
      }
      current_phase <- phase
      phase_stats <- list(
        phase = phase,
        tables_processed = 0,
        tables_succeeded = 0,
        tables_failed = 0,
        rows_loaded = 0
      )
      log_info("")
      log_info(paste("========================================"))
      log_info(paste("PHASE:", phase))
      log_info(paste("========================================"))
    }

    log_info("")
    log_info(paste("Processing table:", table_name))
    log_info(paste("----------------------------------------"))

    overall_stats$tables_processed <- overall_stats$tables_processed + 1
    phase_stats$tables_processed <- phase_stats$tables_processed + 1

    tryCatch({
      # Check if CSV file exists
      csv_files <- list.files(
        path = import_dir,
        pattern = glob2rx(etl_config$csv_pattern),
        full.names = FALSE
      )

      if (length(csv_files) == 0) {
        log_warn(paste("No CSV file found for", table_name, "- skipping"))
        overall_stats$tables_skipped <- overall_stats$tables_skipped + 1
        overall_stats$table_results[[table_name]] <- list(
          table_name = table_name,
          success = FALSE,
          skipped = TRUE,
          reason = "CSV file not found"
        )
        next
      }

      # Run ETL for this table
      stats <- generic_etl(
        conn,
        import_dir,
        etl_config$table_name,
        etl_config$csv_pattern,
        etl_config$mapping
      )

      # Store results
      overall_stats$table_results[[table_name]] <- stats

      if (stats$success) {
        overall_stats$tables_succeeded <- overall_stats$tables_succeeded + 1
        overall_stats$total_rows_loaded <- overall_stats$total_rows_loaded + stats$loaded_rows
        overall_stats$total_errors <- overall_stats$total_errors + stats$errors

        phase_stats$tables_succeeded <- phase_stats$tables_succeeded + 1
        phase_stats$rows_loaded <- phase_stats$rows_loaded + stats$loaded_rows

        # Run quality checks if data was loaded
        if (stats$loaded_rows > 0 && !is.null(etl_config$key_field)) {
          quality_results <- generic_data_quality_checks(
            conn,
            etl_config$table_name,
            etl_config$mapping,
            etl_config$key_field
          )
          overall_stats$table_results[[table_name]]$quality_checks <- quality_results
        }
      } else {
        overall_stats$tables_failed <- overall_stats$tables_failed + 1
        phase_stats$tables_failed <- phase_stats$tables_failed + 1
        log_error(paste("ETL failed for", table_name))
      }

    }, error = function(e) {
      log_error(paste("Critical error processing", table_name, ":", e$message))
      overall_stats$tables_failed <- overall_stats$tables_failed + 1
      phase_stats$tables_failed <- phase_stats$tables_failed + 1
      overall_stats$table_results[[table_name]] <- list(
        table_name = table_name,
        success = FALSE,
        error = e$message
      )
    })
  }

  # Store final phase stats
  if (!is.null(phase_stats)) {
    overall_stats$phase_results[[current_phase]] <- phase_stats
  }

  overall_stats$end_time <- Sys.time()
  overall_stats$duration <- difftime(
    overall_stats$end_time,
    overall_stats$start_time,
    units = "mins"
  )

  return(overall_stats)
}

# ==========================================
# REPORTING
# ==========================================

#' Print overall ETL summary
#' @param overall_stats Overall statistics from run_complete_etl
print_overall_summary <- function(overall_stats) {
  log_console("\n")
  log_console("========================================\n")
  log_console("       COMPLETE TCSI ETL SUMMARY        \n")
  log_console("========================================\n")
  log_console(sprintf("Start time:        %s\n", overall_stats$start_time))
  log_console(sprintf("End time:          %s\n", overall_stats$end_time))
  log_console(sprintf("Duration:          %.2f minutes\n", overall_stats$duration))
  log_console("\n")
  log_console(sprintf("Tables processed:  %d\n", overall_stats$tables_processed))
  log_console(sprintf("Tables succeeded:  %d\n", overall_stats$tables_succeeded))
  log_console(sprintf("Tables failed:     %d\n", overall_stats$tables_failed))
  log_console(sprintf("Tables skipped:    %d\n", overall_stats$tables_skipped))
  log_console("\n")
  log_console(sprintf("Total rows loaded: %d\n", overall_stats$total_rows_loaded))
  log_console(sprintf("Total errors:      %d\n", overall_stats$total_errors))
  log_console("\n")

  # Phase summary
  log_console("Phase Summary:\n")
  log_console("----------------------------------------\n")
  for (phase_name in names(overall_stats$phase_results)) {
    phase <- overall_stats$phase_results[[phase_name]]
    log_console(sprintf("%-25s: %2d tables, %6d rows loaded, %d succeeded, %d failed\n",
                phase_name,
                phase$tables_processed,
                phase$rows_loaded,
                phase$tables_succeeded,
                phase$tables_failed))
  }
  log_console("\n")

  log_console("Table Details:\n")
  log_console("----------------------------------------\n")

  for (table_name in names(overall_stats$table_results)) {
    result <- overall_stats$table_results[[table_name]]

    if (!is.null(result$skipped) && result$skipped) {
      log_console(sprintf("%-45s: SKIPPED (%s)\n", table_name, result$reason))
    } else if (result$success) {
      log_console(sprintf("%-45s: SUCCESS (%d rows loaded)\n",
                  table_name,
                  result$loaded_rows))
    } else {
      log_console(sprintf("%-45s: FAILED\n", table_name))
    }
  }

  log_console("========================================\n")
  log_console("\n")
}

# ==========================================
# MAIN EXECUTION
# ==========================================

#' Main entry point
main <- function(import_dir) {
  # Initialize logging
  init_logging()

  log_info("TCSI Complete ETL Process - All Tables")
  log_info(paste("Data input directory:", import_dir))

  # Connect to database
  conn <- db_connect()

  overall_stats <- NULL

  # Run ETL with transaction support
  tryCatch({
    # Begin transaction
    db_begin_transaction(conn)

    # Run complete ETL
    overall_stats <- run_complete_etl(conn, import_dir)

    # Decide whether to commit or rollback
    if (overall_stats$tables_failed == 0) {
      db_commit(conn)
      log_info("All tables processed successfully - transaction committed")
    } else {
      if (STOP_ON_ERROR) {
        db_rollback(conn)
        log_error("Some tables failed and STOP_ON_ERROR is TRUE - transaction rolled back")
      } else {
        db_commit(conn)
        log_warn("Some tables failed but STOP_ON_ERROR is FALSE - transaction committed with partial data")
      }
    }

  }, error = function(e) {
    log_error(paste("Critical ETL error:", e$message))
    db_rollback(conn)
    log_error("Transaction rolled back due to critical error")
  }, finally = {
    # Disconnect from database
    db_disconnect(conn)

    # Print summaries
    if (!is.null(overall_stats)) {
      print_overall_summary(overall_stats)
    }

    print_log_summary()

    # Close logging
    close_logging()
  })

  # Return overall statistics
  return(invisible(overall_stats))
}
