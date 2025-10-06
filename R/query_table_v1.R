# ============================================================
# Function: query_table
# Author: MMM Arachchi
# Date: 22-09-2025
# Version: 1.0
#
# Description:
#   This function dynamically builds and executes a SQL query
#   against a connected relational database. It allows users
#   to specify filtering conditions, grouping, ordering,
#   and limiting results directly from R.
#
# Parameters:
#   db_table_name   : (character) Name of the database table
#   query_condition_1, query_condition_2, ... : (character) Optional 
#                     WHERE clause conditions. Multiple conditions 
#                     are combined using AND.
#   select_cols     : (character) Columns to select. Default is "*".
#   group_by        : (character) Optional GROUP BY clause.
#   order_by        : (character) Optional ORDER BY clause.
#   limit           : (integer) Optional LIMIT for number of rows.
#
# Returns:
#   A data frame containing the query result.
#
# Dependencies:
#   - Requires a helper function run_query(query) that manages 
#     the DB connection and executes SQL queries.
#
# Example Usage:
#   query_table("students", "enrollment_year >= 2025")
#   query_table("students", order_by = "student_id DESC", limit = 3)
#   query_table("students", 
#               select_cols = "enrollment_year, COUNT(*) as student_count", 
#               group_by = "enrollment_year")
# ============================================================

query_table <- function(db_table_name, 
                        query_condition_1 = NULL, query_condition_2 = NULL, ...,
                        select_cols = "*", group_by = NULL, order_by = NULL, limit = NULL) {
  # Collect WHERE conditions
  conditions <- c(query_condition_1, query_condition_2, ...)
  conditions <- conditions[!sapply(conditions, is.null)]
  
  # WHERE clause
  where_clause <- ""
  if (length(conditions) > 0) {
    where_clause <- paste("WHERE", paste(conditions, collapse = " AND "))
  }
  
  # GROUP BY clause
  group_clause <- ""
  if (!is.null(group_by)) {
    group_clause <- paste("GROUP BY", group_by)
  }
  
  # ORDER BY clause
  order_clause <- ""
  if (!is.null(order_by)) {
    order_clause <- paste("ORDER BY", order_by)
  }
  
  # LIMIT clause
  limit_clause <- ""
  if (!is.null(limit)) {
    limit_clause <- paste("LIMIT", limit)
  }
  
  # Build final query
  query <- paste("SELECT", select_cols, "FROM", db_table_name, 
                 where_clause, group_clause, order_clause, limit_clause)
  
  # Print for user visibility
  message("Running query: ", query)
  
  # Execute query (requires run_query)
  result <- run_query(query)
  return(result)
}
