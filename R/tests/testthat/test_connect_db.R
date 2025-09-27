# ==========================================
# Test Suite for TCSI Database Connection
# Author: MMM Arachchi
# Purpose: Verify that connect_db.R establishes
#          valid connections, can access schema
#          tables, and execute queries correctly.
# Note: These tests use a dummy/local test database
#       since the production database is not yet available.
# Instructions:
#   1. Ensure the PostgreSQL database is running.
#   2. Ensure R packages 'DBI' and 'testthat' are installed.
#   3. Run 'source("tests/testthat.R")' from the project root.
# ==========================================


library(testthat)
library(DBI)

# Load the connection code from the project root
source(file.path("..", "..", "connect_db.R"))

test_that("Database connection is established", {
  # Create a connection
  conn <- create_db_connection()
  
  # Test that the connection object is valid
  expect_true(DBI::dbIsValid(conn))
  
  # Close connection after test
  dbDisconnect(conn)
})

# Test the connection by listing tables
test_that("Schema tables are accessible", {
  conn <- create_db_connection()
  tables <- dbListTables(conn)
  expect_gt(length(tables), 0)   # more than 0 tables
  dbDisconnect(conn)
})

# Test a simple query execution
test_that("Simple query executes correctly", {
  conn <- create_db_connection()
  res <- run_query("SELECT 1 AS test_col;")
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 1)
  expect_equal(res$test_col, 1)
  dbDisconnect(conn)
})