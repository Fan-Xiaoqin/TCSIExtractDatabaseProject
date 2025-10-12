# TCSI ETL Shiny App
# Interactive interface for running ETL process with custom configurations

run_web_app <- function() {
library(shiny)
library(shinyFiles)
library(DT)
library(shinydashboard)

# ==========================================
# UI DEFINITION
# ==========================================

ui <- dashboardPage(
  skin = "blue",
  
  dashboardHeader(title = "TCSI ETL Manager"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Configuration", tabName = "config", icon = icon("cog")),
      menuItem("ETL Process", tabName = "etl", icon = icon("play")),
      menuItem("Results", tabName = "results", icon = icon("chart-bar")),
      menuItem("Query Data", tabName = "query", icon = icon("search"))
    )
  ),
  
  dashboardBody(
    tabItems(
      # Configuration Tab
      tabItem(
        tabName = "config",
        h2("ETL Configuration"),
        
        fluidRow(
          box(
            title = "Database Configuration",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            
            selectInput(
              "db_mode",
              "Database Mode:",
              choices = c("POSTGRESQL", "DUMMY"),
              selected = "POSTGRESQL"
            ),
            
            conditionalPanel(
              condition = "input.db_mode == 'POSTGRESQL'",
              textInput("db_host", "Host:", value = "localhost"),
              numericInput("db_port", "Port:", value = 5432, min = 1, max = 65535),
              textInput("db_name", "Database Name:", value = "tcsi_db"),
              textInput("db_user", "User:", value = Sys.getenv("USER")),
              passwordInput("db_password", "Password:", value = "")
            ),
            
            hr(),
            actionButton("test_connection", "Test Connection", icon = icon("plug"))
          ),
          
          box(
            title = "File Configuration",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            
            shinyDirButton(
              "data_dir",
              "Select Data Input Folder",
              "Please select input data folder",
              icon = icon("folder-open")
            ),
            verbatimTextOutput("data_dir_path"),
            
            hr(),
            
            numericInput(
              "batch_size",
              "Batch Size:",
              value = 1000,
              min = 100,
              max = 10000,
              step = 100
            ),
            
            numericInput(
              "max_rows",
              "Max Rows to Process (NULL for all):",
              value = NA,
              min = 1,
              step = 100
            ),
            
            checkboxInput("stop_on_error", "Stop on Error", value = FALSE)
          )
        ),
        
        fluidRow(
          box(
            title = "Logging Configuration",
            status = "info",
            width = 12,
            
            selectInput(
              "log_level",
              "Log Level:",
              choices = c("DEBUG", "INFO", "WARN", "ERROR"),
              selected = "INFO"
            ),
            
            checkboxInput("log_to_console", "Log to Console", value = TRUE),
            checkboxInput("log_to_file", "Log to File", value = TRUE)
          )
        ),
        
        fluidRow(
          box(
            width = 12,
            actionButton(
              "save_config",
              "Save Configuration",
              icon = icon("save"),
              class = "btn-success btn-lg"
            ),
            
            verbatimTextOutput("config_status")
          )
        )
      ),
      
      # ETL Process Tab
      tabItem(
        tabName = "etl",
        h2("ETL Process Execution"),
        
        fluidRow(
          box(
            title = "ETL Control",
            status = "warning",
            solidHeader = TRUE,
            width = 12,
            
            actionButton(
              "start_etl",
              "Start ETL Process",
              icon = icon("play"),
              class = "btn-success btn-lg"
            ),
            
            actionButton(
              "stop_etl",
              "Stop ETL",
              icon = icon("stop"),
              class = "btn-danger"
            ),
            
            hr(),
            
            h4("Current Status:"),
            textOutput("etl_status")
          )
        ),
        
        fluidRow(
          box(
            title = "Live Log Output",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            height = "500px",
            
            verbatimTextOutput("log_output") %>% 
              tagAppendAttributes(style = "height: 450px; overflow-y: scroll; background-color: #2c3e50; color: #ecf0f1; font-family: 'Courier New', monospace;")
          )
        ),
        
        fluidRow(
          valueBoxOutput("tables_processed", width = 3),
          valueBoxOutput("tables_succeeded", width = 3),
          valueBoxOutput("tables_failed", width = 3),
          valueBoxOutput("rows_loaded", width = 3)
        )
      ),
      
      # Results Tab
      tabItem(
        tabName = "results",
        h2("ETL Results Summary"),
        
        fluidRow(
          box(
            title = "Overall Statistics",
            status = "success",
            solidHeader = TRUE,
            width = 6,
            
            verbatimTextOutput("overall_summary")
          ),
          
          box(
            title = "Phase Summary",
            status = "info",
            solidHeader = TRUE,
            width = 6,
            
            DTOutput("phase_summary_table")
          )
        ),
        
        fluidRow(
          box(
            title = "Table Details",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            
            DTOutput("table_details")
          )
        ),
        
        fluidRow(
          box(
            title = "Error Log",
            status = "danger",
            solidHeader = TRUE,
            width = 12,
            
            DTOutput("error_log")
          )
        ),
        
        fluidRow(
          box(
            width = 12,
            downloadButton("download_report", "Download Full Report", class = "btn-primary")
          )
        )
      ),
      
      # Query Data Tab
      tabItem(
        tabName = "query",
        h2("Query Database Tables"),
        
        fluidRow(
          box(
            title = "Query Builder",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            
            textInput(
              "query_table_name",
              "Table Name:",
              value = "hep_students",
              placeholder = "e.g., hep_students"
            ),
            
            textInput(
              "query_select_cols",
              "Select Columns:",
              value = "*",
              placeholder = "e.g., e313_student_identification_code, e314_first_name"
            ),
            
            hr(),
            
            h4("WHERE Conditions"),
            p("Add conditions to filter your query (up to 10 conditions)"),
            
            # Dynamic conditions container
            div(id = "conditions_container"),
            
            actionButton(
              "add_condition_btn",
              "Add Condition",
              icon = icon("plus"),
              class = "btn-info btn-sm"
            ),
            
            actionButton(
              "remove_condition_btn",
              "Remove Last",
              icon = icon("minus"),
              class = "btn-warning btn-sm"
            ),
            
            hr(),
            
            textInput(
              "query_group_by",
              "GROUP BY:",
              placeholder = "e.g., e327_year_of_birth"
            ),
            
            textInput(
              "query_order_by",
              "ORDER BY:",
              placeholder = "e.g., e327_year_of_birth DESC"
            ),
            
            numericInput(
              "query_limit",
              "LIMIT:",
              value = 100,
              min = 1,
              max = 10000,
              step = 100
            ),
            
            hr(),
            
            actionButton(
              "run_query_btn",
              "Run Query",
              icon = icon("play"),
              class = "btn-success btn-lg"
            ),
            
            actionButton(
              "clear_query_btn",
              "Clear All",
              icon = icon("eraser"),
              class = "btn-warning"
            )
          ),
          
          box(
            title = "Query Preview",
            status = "info",
            solidHeader = TRUE,
            width = 6,
            
            verbatimTextOutput("query_preview") %>%
              tagAppendAttributes(style = "background-color: #f8f9fa; padding: 15px; border-radius: 5px; font-family: 'Courier New', monospace; min-height: 200px;"),
            
            hr(),
            
            h4("Query Status:"),
            textOutput("query_status"),
            
            hr(),
            
            h4("Row Count:"),
            verbatimTextOutput("query_row_count")
          )
        ),
        
        fluidRow(
          box(
            title = "Query Results",
            status = "success",
            solidHeader = TRUE,
            width = 12,
            
            DTOutput("query_results_table")
          )
        ),
        
        fluidRow(
          box(
            width = 12,
            downloadButton("download_query_results", "Download Results (CSV)", class = "btn-primary"),
            downloadButton("download_query_excel", "Download Results (Excel)", class = "btn-info")
          )
        )
      )
    )
  )
)

# ==========================================
# SERVER LOGIC
# ==========================================

server <- function(input, output, session) {
  
  # Reactive values to store state
  rv <- reactiveValues(
    data_dir = NULL,
    config_saved = FALSE,
    etl_running = FALSE,
    etl_results = NULL,
    log_messages = character(),
    connection_status = NULL,
    db_connection = NULL,
    query_results = NULL,
    query_text = NULL,
    num_conditions = 0,
    condition_counter = 0
  )
  
  # Directory chooser
  volumes <- c(Home = fs::path_home(), getVolumes()())
  shinyDirChoose(input, "data_dir", roots = volumes, session = session)
  
  observe({
    if (!is.null(input$data_dir) && !is.integer(input$data_dir)) {
      rv$data_dir <- parseDirPath(volumes, input$data_dir)
    }
  })
  
  output$data_dir_path <- renderText({
    if (is.null(rv$data_dir) || length(rv$data_dir) == 0) {
      "No folder selected"
    } else {
      as.character(rv$data_dir)
    }
  })
  
  # Test database connection
  observeEvent(input$test_connection, {
    if (input$db_mode == "DUMMY") {
      rv$connection_status <- "DUMMY mode - no connection needed"
      rv$db_connection <- NULL
      showNotification("DUMMY mode selected", type = "message")
    } else {
      withProgress(message = "Testing connection...", {
        tryCatch({
          # Load required library
          if (!require("RPostgres", quietly = TRUE)) {
            stop("RPostgres package not installed. Please install it with: install.packages('RPostgres')")
          }
          
          # Close existing connection if any
          if (!is.null(rv$db_connection)) {
            tryCatch(DBI::dbDisconnect(rv$db_connection), error = function(e) {})
          }
          
          # Attempt connection
          rv$db_connection <- DBI::dbConnect(
            RPostgres::Postgres(),
            host = input$db_host,
            port = input$db_port,
            dbname = input$db_name,
            user = input$db_user,
            password = input$db_password
          )
          
          # Test query
          result <- DBI::dbGetQuery(rv$db_connection, "SELECT version();")
          
          rv$connection_status <- paste("Connection successful!", 
                                        "\nPostgreSQL version:", 
                                        substr(result$version[1], 1, 50))
          showNotification("Database connection successful!", type = "message", duration = 5)
          
        }, error = function(e) {
          rv$connection_status <- paste("Connection failed:", e$message)
          rv$db_connection <- NULL
          showNotification(
            paste("Connection failed:", e$message), 
            type = "error",
            duration = 10
          )
        })
      })
    }
  })
  
  # Save configuration
  observeEvent(input$save_config, {
    if (is.null(rv$data_dir) || length(rv$data_dir) == 0) {
      showNotification("Please select a data input folder", type = "error", duration = 5)
      return()
    }
    
    # Update configuration file
    config_content <- sprintf('
# Database Configuration - Updated by Shiny App
DB_MODE <- "%s"

DB_CONFIG <- list(
  host = "%s",
  port = %d,
  dbname = "%s",
  user = "%s",
  password = "%s"
)

BATCH_SIZE <- %d
MAX_ROWS_TO_PROCESS <- %s
STOP_ON_ERROR <- %s

DATA_INPUT_DIR <- "%s"

LOG_LEVEL <- "%s"
LOG_TO_CONSOLE <- %s
LOG_TO_FILE <- %s
',
    input$db_mode,
    input$db_host,
    input$db_port,
    input$db_name,
    input$db_user,
    input$db_password,
    input$batch_size,
    ifelse(is.na(input$max_rows), "NULL", input$max_rows),
    input$stop_on_error,
    rv$data_dir,
    input$log_level,
    input$log_to_console,
    input$log_to_file
    )
  
  
  # Set working directory to project root if running from src/
  if (basename(getwd()) == "src") {
    setwd("..")
  }
  # Save to file
  tryCatch({
    writeLines(config_content, "config/database_config_runtime.R")
    rv$config_saved <- TRUE
    showNotification("Configuration saved successfully!", type = "message", duration = 5)
  }, error = function(e) {
    showNotification(paste("Error saving configuration:", e$message), type = "error", duration = 10)
  })
  })

output$config_status <- renderText({
  if (rv$config_saved) {
    paste("✓ Configuration saved at:", Sys.time())
  } else {
    "Configuration not saved yet"
  }
})

# Start ETL Process
observeEvent(input$start_etl, {
  if (!rv$config_saved) {
    showNotification("Please save configuration first", type = "error", duration = 5)
    return()
  }
  
  if (rv$etl_running) {
    showNotification("ETL process is already running", type = "warning", duration = 5)
    return()
  }
  
  rv$etl_running <- TRUE
  rv$log_messages <- c("ETL process started...", "Loading configuration...")
  rv$etl_results <- NULL
  
  showNotification("Starting ETL process...", type = "message", duration = 3)
  
  # Set working directory to project root if running from src/
  if (basename(getwd()) == "src") {
    setwd("..")
  }
  # Run ETL synchronously (simpler and more reliable)
  tryCatch({
    # Run ETL
    results <- main()
    
    rv$etl_results <- results
    rv$etl_running <- FALSE
    rv$log_messages <- c(rv$log_messages, "ETL process completed successfully!")
    
    showNotification("ETL process completed successfully!", type = "message", duration = 10)
    
  }, error = function(e) {
    rv$etl_running <- FALSE
    error_msg <- paste("ETL process failed:", e$message)
    rv$log_messages <- c(rv$log_messages, error_msg)
    showNotification(error_msg, type = "error", duration = 15)
  })
})

# ETL Status
output$etl_status <- renderText({
  if (rv$etl_running) {
    "Running..."
  } else if (!is.null(rv$etl_results)) {
    "Completed"
  } else {
    "Ready to start"
  }
})

# Live log output (simulated)
output$log_output <- renderText({
  invalidateLater(1000, session)
  
  if (rv$etl_running) {
    # Read log file if it exists
    log_files <- list.files("data/logs", pattern = "*.log", full.names = TRUE)
    if (length(log_files) > 0) {
      latest_log <- log_files[which.max(file.mtime(log_files))]
      log_content <- readLines(latest_log, warn = FALSE)
      paste(tail(log_content, 50), collapse = "\n")
    } else {
      "Waiting for log output..."
    }
  } else {
    paste(rv$log_messages, collapse = "\n")
  }
})

# Value boxes
output$tables_processed <- renderValueBox({
  val <- if (!is.null(rv$etl_results)) rv$etl_results$tables_processed else 0
  valueBox(val, "Tables Processed", icon = icon("table"), color = "blue")
})

output$tables_succeeded <- renderValueBox({
  val <- if (!is.null(rv$etl_results)) rv$etl_results$tables_succeeded else 0
  valueBox(val, "Succeeded", icon = icon("check"), color = "green")
})

output$tables_failed <- renderValueBox({
  val <- if (!is.null(rv$etl_results)) rv$etl_results$tables_failed else 0
  valueBox(val, "Failed", icon = icon("times"), color = "red")
})

output$rows_loaded <- renderValueBox({
  val <- if (!is.null(rv$etl_results)) {
    format(rv$etl_results$total_rows_loaded, big.mark = ",")
  } else {
    "0"
  }
  valueBox(val, "Rows Loaded", icon = icon("database"), color = "yellow")
})

# Overall summary
output$overall_summary <- renderText({
  if (is.null(rv$etl_results)) {
    return("No results yet. Start ETL process to see summary.")
  }
  
  sprintf(
    "Duration: %.2f minutes\nTables Processed: %d\nSucceeded: %d\nFailed: %d\nSkipped: %d\nTotal Rows: %s\nTotal Errors: %d",
    rv$etl_results$duration,
    rv$etl_results$tables_processed,
    rv$etl_results$tables_succeeded,
    rv$etl_results$tables_failed,
    rv$etl_results$tables_skipped,
    format(rv$etl_results$total_rows_loaded, big.mark = ","),
    rv$etl_results$total_errors
  )
})

# Phase summary table
output$phase_summary_table <- renderDT({
  if (is.null(rv$etl_results) || is.null(rv$etl_results$phase_results)) {
    return(data.frame())
  }
  
  phase_df <- do.call(rbind, lapply(names(rv$etl_results$phase_results), function(phase_name) {
    phase <- rv$etl_results$phase_results[[phase_name]]
    data.frame(
      Phase = phase_name,
      Tables = phase$tables_processed,
      Succeeded = phase$tables_succeeded,
      Failed = phase$tables_failed,
      Rows = format(phase$rows_loaded, big.mark = ",")
    )
  }))
  
  datatable(phase_df, options = list(pageLength = 10, dom = 't'))
})

# Table details
output$table_details <- renderDT({
  if (is.null(rv$etl_results) || is.null(rv$etl_results$table_results)) {
    return(data.frame())
  }
  
  table_df <- do.call(rbind, lapply(names(rv$etl_results$table_results), function(table_name) {
    result <- rv$etl_results$table_results[[table_name]]
    
    status <- if (!is.null(result$skipped) && result$skipped) {
      "SKIPPED"
    } else if (result$success) {
      "SUCCESS"
    } else {
      "FAILED"
    }
    
    rows <- if (result$success) format(result$loaded_rows, big.mark = ",") else "-"
    
    data.frame(
      Table = table_name,
      Status = status,
      Rows = rows,
      Errors = if (result$success) result$errors else "-"
    )
  }))
  
  datatable(
    table_df,
    options = list(pageLength = 15),
    rownames = FALSE
  ) %>%
    formatStyle(
      'Status',
      backgroundColor = styleEqual(
        c('SUCCESS', 'FAILED', 'SKIPPED'),
        c('#d4edda', '#f8d7da', '#fff3cd')
      )
    )
})

# Error log placeholder
output$error_log <- renderDT({
  data.frame(
    Table = character(),
    Error = character(),
    Row = integer(),
    Details = character()
  )
})

# Download report
output$download_report <- downloadHandler(
  filename = function() {
    paste0("etl_report_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".html")
  },
  content = function(file) {
    # Generate HTML report
    report_content <- sprintf("
        <html>
        <head><title>ETL Report</title></head>
        <body>
        <h1>TCSI ETL Report</h1>
        <p>Generated: %s</p>
        <pre>%s</pre>
        </body>
        </html>
      ", Sys.time(), capture.output(print_overall_summary(rv$etl_results)))
    
    writeLines(report_content, file)
  }
)

# ==========================================
# QUERY TAB LOGIC
# ==========================================

# Add condition button
observeEvent(input$add_condition_btn, {
  if (rv$num_conditions >= 10) {
    showNotification("Maximum 10 conditions allowed", type = "warning", duration = 3)
    return()
  }
  
  rv$num_conditions <- rv$num_conditions + 1
  rv$condition_counter <- rv$condition_counter + 1
  condition_id <- paste0("query_condition_", rv$condition_counter)
  
  insertUI(
    selector = "#conditions_container",
    where = "beforeEnd",
    ui = div(
      id = paste0("condition_wrapper_", rv$condition_counter),
      style = "margin-bottom: 10px;",
      fluidRow(
        column(
          11,
          textInput(
            condition_id,
            paste("Condition", rv$num_conditions, ":"),
            placeholder = "e.g., e327_year_of_birth >= 1990"
          )
        ),
        column(
          1,
          br(),
          actionButton(
            paste0("remove_", rv$condition_counter),
            icon("times"),
            class = "btn-danger btn-sm",
            style = "margin-top: 5px;"
          )
        )
      )
    )
  )
  
  # Add observer for individual remove button
  local({
    counter_value <- rv$condition_counter
    observeEvent(input[[paste0("remove_", counter_value)]], {
      removeUI(selector = paste0("#condition_wrapper_", counter_value))
      rv$num_conditions <- rv$num_conditions - 1
    })
  })
})

# Remove last condition button
observeEvent(input$remove_condition_btn, {
  if (rv$num_conditions > 0) {
    removeUI(selector = paste0("#condition_wrapper_", rv$condition_counter))
    rv$num_conditions <- rv$num_conditions - 1
  } else {
    showNotification("No conditions to remove", type = "warning", duration = 3)
  }
})

# Helper function to run queries (reusing connection)
run_query <- function(query_text) {
  if (is.null(rv$db_connection)) {
    stop("No active database connection. Please test connection first.")
  }
  
  tryCatch({
    result <- DBI::dbGetQuery(rv$db_connection, query_text)
    return(result)
  }, error = function(e) {
    stop(paste("Query execution failed:", e$message))
  })
}

# Build query preview (reactive)
query_preview_text <- reactive({
  # Collect all dynamic conditions
  conditions <- c()
  
  for (i in 1:rv$condition_counter) {
    condition_id <- paste0("query_condition_", i)
    if (!is.null(input[[condition_id]]) && input[[condition_id]] != "") {
      conditions <- c(conditions, input[[condition_id]])
    }
  }
  
  # WHERE clause
  where_clause <- ""
  if (length(conditions) > 0) {
    where_clause <- paste("\nWHERE", paste(conditions, collapse = "\n  AND "))
  }
  
  # GROUP BY clause
  group_clause <- ""
  if (!is.null(input$query_group_by) && input$query_group_by != "") {
    group_clause <- paste("\nGROUP BY", input$query_group_by)
  }
  
  # ORDER BY clause
  order_clause <- ""
  if (!is.null(input$query_order_by) && input$query_order_by != "") {
    order_clause <- paste("\nORDER BY", input$query_order_by)
  }
  
  # LIMIT clause
  limit_clause <- ""
  if (!is.null(input$query_limit) && !is.na(input$query_limit)) {
    limit_clause <- paste("\nLIMIT", input$query_limit)
  }
  
  # Build query
  query <- paste0(
    "SELECT ", input$query_select_cols,
    "\nFROM ", input$query_table_name,
    where_clause,
    group_clause,
    order_clause,
    limit_clause
  )
  
  return(query)
})

# Display query preview
output$query_preview <- renderText({
  query_preview_text()
})

# Run query button
observeEvent(input$run_query_btn, {
  if (is.null(rv$db_connection)) {
    showNotification(
      "No database connection. Please test connection in Configuration tab first.",
      type = "error",
      duration = 5
    )
    return()
  }
  
  if (input$db_mode == "DUMMY") {
    showNotification(
      "Query feature requires PostgreSQL connection. DUMMY mode not supported for queries.",
      type = "warning",
      duration = 5
    )
    return()
  }
  
  withProgress(message = "Executing query...", {
    tryCatch({
      # Get query text
      query_text <- query_preview_text()
      rv$query_text <- query_text
      
      # Execute query
      result <- run_query(query_text)
      rv$query_results <- result
      
      showNotification(
        paste("Query executed successfully! Returned", nrow(result), "rows."),
        type = "message",
        duration = 5
      )
      
    }, error = function(e) {
      rv$query_results <- NULL
      showNotification(
        paste("Query failed:", e$message),
        type = "error",
        duration = 10
      )
    })
  })
})

# Clear query button
observeEvent(input$clear_query_btn, {
  updateTextInput(session, "query_table_name", value = "hep_students")
  updateTextInput(session, "query_select_cols", value = "*")
  updateTextInput(session, "query_group_by", value = "")
  updateTextInput(session, "query_order_by", value = "")
  updateNumericInput(session, "query_limit", value = 100)
  
  # Remove all dynamic conditions
  for (i in 1:rv$condition_counter) {
    removeUI(selector = paste0("#condition_wrapper_", i))
  }
  rv$num_conditions <- 0
  rv$condition_counter <- 0
  
  rv$query_results <- NULL
  rv$query_text <- NULL
})

# Query status
output$query_status <- renderText({
  if (is.null(rv$query_results)) {
    "No query executed yet"
  } else {
    paste("✓ Query executed successfully at", format(Sys.time(), "%H:%M:%S"))
  }
})

# Row count
output$query_row_count <- renderText({
  if (is.null(rv$query_results)) {
    "0 rows"
  } else {
    paste(format(nrow(rv$query_results), big.mark = ","), "rows returned")
  }
})

# Display query results
output$query_results_table <- renderDT({
  if (is.null(rv$query_results)) {
    return(data.frame())
  }
  
  datatable(
    rv$query_results,
    options = list(
      pageLength = 25,
      scrollX = TRUE,
      scrollY = "400px",
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel')
    ),
    rownames = FALSE,
    filter = 'top'
  )
})

# Download query results (CSV)
output$download_query_results <- downloadHandler(
  filename = function() {
    paste0("query_results_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".csv")
  },
  content = function(file) {
    if (!is.null(rv$query_results)) {
      write.csv(rv$query_results, file, row.names = FALSE)
    }
  }
)

# Download query results (Excel)
output$download_query_excel <- downloadHandler(
  filename = function() {
    paste0("query_results_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".xlsx")
  },
  content = function(file) {
    if (!is.null(rv$query_results)) {
      if (!require("writexl", quietly = TRUE)) {
        showNotification("writexl package not installed. Install with: install.packages('writexl')", 
                         type = "error")
        return()
      }
      writexl::write_xlsx(rv$query_results, file)
    }
  }
)

# Clean up database connection when app closes
session$onSessionEnded(function() {
  if (!is.null(rv$db_connection)) {
    tryCatch({
      DBI::dbDisconnect(rv$db_connection)
    }, error = function(e) {})
  }
})
}

# ==========================================
# RUN APP
# ==========================================

# Note: Before running, ensure these packages are installed:
# install.packages(c("shiny", "shinyFiles", "DT", "shinydashboard", "fs"))
# For PostgreSQL support: install.packages("RPostgres")

shinyApp(ui = ui, server = server)
}