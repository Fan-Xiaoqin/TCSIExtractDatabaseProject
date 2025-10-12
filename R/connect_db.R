# Function to create DB connection
create_db_connection <- function() {
  # Database connection parameters from .Renviron
  db_config <- list(
    host = Sys.getenv("DB_HOST"),
    port = as.integer(Sys.getenv("DB_PORT")),
    dbname = Sys.getenv("DB_NAME"),
    user = Sys.getenv("DB_USER"),
    password = Sys.getenv("DB_PASSWORD")
  )

  tryCatch({
    con <- DBI::dbConnect(
      RPostgres::Postgres(),
      host = db_config$host,
      port = db_config$port,
      dbname = db_config$dbname,
      user = db_config$user,
      password = db_config$password
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
