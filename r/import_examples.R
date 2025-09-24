#!/usr/bin/env Rscript
#' Illustrative RStudio-friendly snippets for exploring the TCSI database.
#'
#' Run via: Rscript r/import_examples.R
#' or source within RStudio to see example outputs.

suppressPackageStartupMessages({
  library(DBI)
  library(RSQLite)
  library(dplyr)
})

db_path <- Sys.getenv("TCSI_DB_PATH", unset = "tcsi.db")
if (!file.exists(db_path)) {
  stop("Database not found at ", db_path, " - run r/upload_extract.R first.")
}

con <- dbConnect(SQLite(), db_path)
on.exit(dbDisconnect(con))

message("Connected to ", db_path)

message("\nAvailable curated tables:")
print(dbListTables(con)[grepl("^(dim_|fact_|bridge_|wide_)", dbListTables(con))])

message("\nSample: latest course admissions with student demographics")
latest_admissions <- tbl(con, "fact_course_admission") %>%
  left_join(tbl(con, "dim_student"), by = c("student_res_key" = "student_res_key")) %>%
  arrange(desc(extraction_timestamp)) %>%
  select(extraction_timestamp, course_admission_res_key, course_code, course_name,
         course_commencement_date, course_outcome_code, student_identifier, gender_code) %>%
  head(5) %>%
  collect()
print(latest_admissions)

message("\nSample: wide reporting view (5 rows)")
print(dbGetQuery(con, "SELECT * FROM wide_student_course LIMIT 5"))

message("\nUse dbGetQuery() or dplyr verbs to craft custom analysis views.")
