# ========================================================================
# Test Suite: query_table_v1.R
# Author: MMM Arachchi
# Date: 23-09-2025
#
# Purpose:
#   Verify that query_table() dynamically builds and executes SQL queries
#   correctly using a connected database.
#
# Notes:
#   - Uses a dummy database since the production database is not yet available.
#   - Test queries should be updated with production DB parameters once available.
# ========================================================================


library(testthat)
library(DBI)

# Load connection code and query function
source(file.path("..", "..", "connect_db.R"))
source(file.path("..", "..", "query_table_v1.R"))

test_that("query_table executes a basic query correctly", {
  conn <- create_db_connection()
  
  # Dummy table for test; ensure table exists in dummy DB
  res <- query_table("students", select_cols = "*", limit = 2)
  
  expect_s3_class(res, "data.frame")
  expect_lte(nrow(res), 2)
  
  dbDisconnect(conn)
})

test_that("query_table applies WHERE conditions", {
  conn <- create_db_connection()
  
  res <- query_table("students", "enrollment_year >= 2025", limit = 5)
  
  expect_s3_class(res, "data.frame")
  expect_true(all(res$enrollment_year >= 2025))
  
  dbDisconnect(conn)
})

test_that("query_table applies GROUP BY correctly", {
  conn <- create_db_connection()
  
  # Example aggregate query
  res <- query_table(
    "students",
    select_cols = "enrollment_year, COUNT(*) as student_count",
    group_by = "enrollment_year"
  )
  
  expect_s3_class(res, "data.frame")
  expect_true("student_count" %in% colnames(res))
  
  dbDisconnect(conn)
})

test_that("query_table applies ORDER BY and LIMIT correctly", {
  conn <- create_db_connection()
  
  # Example ordered query
  res <- query_table(
    "students",
    order_by = "student_id DESC",
    limit = 3
  )
  
  expect_s3_class(res, "data.frame")
  expect_lte(nrow(res), 3)
  
  dbDisconnect(conn)
})
