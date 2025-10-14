
# Database Configuration - Updated by Shiny App
DB_MODE <- "POSTGRESQL"

DB_CONFIG <- list(
  host = "localhost",
  port = 5432,
  dbname = "tcsi_db",
  user = <"your_username">,  # Replace with your actual username
  password = <"your_password">  # Replace with your actual password
)

BATCH_SIZE <- 1000
MAX_ROWS_TO_PROCESS <- NULL
STOP_ON_ERROR <- FALSE

DATA_INPUT_DIR <- "<path-to-your-data-directory>"  # Replace with your actual data directory path
# Example: "<path-to-your-project-directory/tcsi-etl-project/data/tcsiSample>"

LOG_LEVEL <- "INFO"
LOG_TO_CONSOLE <- TRUE
LOG_TO_FILE <- TRUE

