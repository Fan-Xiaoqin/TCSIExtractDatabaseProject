# Function to create DB connection
create_db_connection <- function() {
  tryCatch({
    con <- DBI::dbConnect(
      RPostgres::Postgres(),
      host = DB_CONFIG$host,
      port = DB_CONFIG$port,
      dbname = DB_CONFIG$dbname,
      user = DB_CONFIG$user,
      password = DB_CONFIG$password
    )
    message("Database connection successful!")
    return(con)
  }, error = function(e) {
    stop("Connection failed: ", e$message)
  })
}

# Helper to run queries
run_query <- function(query) {
  con <- create_db_connection()
  on.exit(DBI::dbDisconnect(con), add = TRUE)
  DBI::dbGetQuery(con, query)
}
