library(testthat)

# Locate project root relative to tests directory
project_root <- normalizePath(
  file.path(testthat::test_path(), "..", ".."),
  mustWork = TRUE
)

# Create isolated environment to host ETL utilities
etl_env <- new.env(parent = baseenv())

# Load configuration, sanitising placeholder credentials for parsing
config_path <- file.path(project_root, "config", "database_config.R")
config_source <- readLines(config_path, warn = FALSE)
config_source <- gsub('<"(.*?)">', '"\\1"', config_source)
eval(parse(text = paste(config_source, collapse = "\n")), envir = etl_env)

# Load additional project modules
sys.source(file.path(project_root, "config", "field_mappings.R"), envir = etl_env)
sys.source(file.path(project_root, "src", "utils", "logging_utils.R"), envir = etl_env)
sys.source(file.path(project_root, "src", "utils", "database_utils.R"), envir = etl_env)
sys.source(file.path(project_root, "src", "utils", "transformation_utils.R"), envir = etl_env)
sys.source(file.path(project_root, "src", "utils", "validation_utils.R"), envir = etl_env)

# Ensure tests operate quietly in dummy mode
etl_env$DB_MODE <- "DUMMY"
etl_env$LOG_TO_FILE <- FALSE
etl_env$LOG_TO_CONSOLE <- FALSE
