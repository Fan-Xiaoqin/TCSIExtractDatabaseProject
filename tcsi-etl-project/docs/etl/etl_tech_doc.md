# TCSI ETL System – Technical Documentation

## Table of Contents
1. [Overview](#overview)
2. [Quick Start Guide](#quick-start-guide)
3. [User Guide](#user-guide)
4. [Developer Guide](#developer-guide)
5. [Troubleshooting](#troubleshooting)
6. [Appendix](#appendix)

---

## Overview

The TCSI ETL (Extract, Transform, Load) project is an R-based application for importing and validating higher education student data into a PostgreSQL database. The system uses Shiny as the user interface, providing a dashboard for configuration, execution, and querying of ETL processes.

### Key Features
- Interactive Shiny dashboard for ETL management
- Support for 26 database tables with complex relationships
- Automatic data validation and error tracking
- PostgreSQL database integration
- Data quality checks and reporting
- Query builder for accessing loaded data
- Transaction support (commit/rollback)

### System Requirements
- R 4.4+
- RStudio (recommended)
- PostgreSQL 10+
- Required R packages: `shiny`, `DBI`, `RPostgres`, `DT`, `shinydashboard`, `shinyFiles`, `fs`, `lubridate`, `writexl`, `getPass`

---

## Quick Start Guide

### Step 1: Install Dependencies

```r
# Install required packages
packages <- c("shiny", "DBI", "RPostgres", "DT", "shinydashboard", 
              "shinyFiles", "fs", "lubridate", "writexl")
install.packages(packages)

# Or use the provided script
source("install_packages.R")
```

### Step 2: Launch the Application

```r
# From R console
setwd("/path/to/tcsi-etl-project")
shiny::runApp("src/app.R")
```

The Shiny app will open in your default browser (`http://127.0.0.1:4021`) or the RStudio Viewer pane.

### Step 3: Configure Database Connection in the App

When you first open the app:
1. Go to the **Configuration** tab
2. In the **Database Configuration** section:
   - Select "POSTGRESQL" as Database Mode
   - Enter your Host (e.g., localhost or IP address)
   - Enter Port (default: 5432)
   - Enter Database Name
   - Enter Username
   - Enter Password
   - Click **Test Connection** to verify connectivity
3. In the **File Configuration** section:
   - Click **Select Data Input Folder** and browse to your CSV files folder
   - Adjust Batch Size if needed (default: 1000)
   - Leave Max Rows blank to process all data
   - Optionally check "Stop on Error" if you want to halt on first error
4. In the **Logging Configuration** section:
   - Set Log Level (default: INFO)
   - Check/uncheck console and file logging options
5. Click **Save Configuration**

The configuration is now saved to `config/database_config_runtime.R` and will persist for future runs.

### Step 4: Run ETL Process

1. Go to **ETL Process** tab
2. Click **Start ETL Process**
3. Monitor progress in the live log output
4. View results in the **Results** tab

---

## User Guide

### Configuration Tab

**Database Configuration:**
- **Database Mode**: Select "POSTGRESQL" (DUMMY mode is for testing only)
- **Host**: Database server address
- **Port**: PostgreSQL port (default: 5432)
- **Database Name**: Name of your database
- **User**: Database username
- **Password**: Database password
- **Test Connection**: Verify connectivity before proceeding

**File Configuration:**
- **Data Input Folder**: Browse and select folder containing CSV files
- **Batch Size**: Number of rows processed per batch (default: 1000, range: 100-10000)
- **Max Rows to Process**: Optional limit for testing (leave blank for all rows)
- **Stop on Error**: If checked, stops processing on first error (default: unchecked)

**Logging Configuration:**
- **Log Level**: DEBUG, INFO, WARN, or ERROR (default: INFO)
- **Log to Console**: Display logs in R console
- **Log to File**: Save logs to file in `data/logs/`

### ETL Process Tab

**Control Panel:**
- **Start ETL Process**: Begin the ETL pipeline
- **Stop ETL**: Stop current execution
- Current status indicator

**Live Log Output:**
- Real-time display of ETL progress
- Scrollable log window showing last 50 messages
- Color-coded by log level (INFO, WARN, ERROR)

**Statistics:**
- Tables Processed: Total tables attempted
- Succeeded: Tables loaded successfully
- Failed: Tables with errors
- Rows Loaded: Total data rows inserted

### Results Tab

**Overall Statistics:**
- Processing duration in minutes
- Summary of successes/failures
- Total rows loaded and errors encountered

**Phase Summary:**
- Breakdown by processing phase (Reference Data, Students, Courses, etc.)
- Row counts per phase
- Success/failure metrics

**Table Details:**
- Status for each table (SUCCESS/FAILED/SKIPPED)
- Row counts per table
- Error counts

**Error Log:**
- Detailed error information (populated from error files in `data/errors/`)

**Download:**
- Generate HTML report of entire process

### Query Data Tab

**Query Builder:**

1. **Table Name**: Select which table to query
2. **Select Columns**: Specify columns (default: "*" for all)
3. **WHERE Conditions**: Add filtering conditions
   - Click "Add Condition" to add filters
   - Multiple conditions are combined with AND
   - Example: `e315_gender_code = 'M'`
4. **GROUP BY**: Optional aggregation
5. **ORDER BY**: Sort results (e.g., `student_id DESC`)
6. **LIMIT**: Maximum rows to return

**Query Preview:**
- Live preview of generated SQL
- Updated as you modify parameters

**Results:**
- Interactive table with sorting and filtering
- Download as CSV or Excel

---

## Developer Guide

### Project Structure

```graphql
tcsi-etl-project/
├── app.R                          # Main Shiny application
├── config/
│   ├── database_config.R          # Base configuration
│   ├── database_config_runtime.R  # Runtime config (updated by app)
│   └── field_mappings.R           # Field definitions for all tables
├── src/
│   ├── utils/
│   │   ├── logging_utils.R        # Logging functions
│   │   ├── database_utils.R       # DB operations
│   │   ├── transformation_utils.R # Data transformations
│   │   ├── validation_utils.R     # Data validation
│   │   └── generic_etl.R          # Main ETL logic
│   ├── main_etl_all_tables.R      # ETL orchestration
│   └── app.R                      # Shiny app file
├── data/
│   ├── tcsiSample/                # CSV input files
│   ├── logs/                      # ETL log files
│   └── errors/                    # Error reports
├── docs                           # Supportive documentation
│   ├── db/                        # DB documentation
│   ├── etl/                       # ETL documentation
│   ├── shiny_app/                 $ Shiny app documentation
│   ├── mapping/                   # CSV with mapping framework
│   └── erd-stage/                 # Entity Relationship Diagrams
└── install_packages.R             # Package installer
```

### Core Concepts

#### Field Mappings
Each table has a mapping definition in `field_mappings.R`:

```r
TABLE_NAME_MAPPING <- list(
  primary_key = "unique_id_column",
  csv_to_db = list(
    "CSV_ColumnName" = "database_column_name",
    ...
  ),
  date_fields = c("date_column_1", "date_column_2"),
  integer_fields = c("int_column"),
  decimal_fields = c("decimal_column"),
  required_fields = c("mandatory_column"),
  validated_fields = list(
    "status_column" = c("VALUE1", "VALUE2", "VALUE3")
  ),
  foreign_keys = list(
    list(
      field = "fk_column",
      references_table = "parent_table",
      reference_column = "parent_id",
      references_field = "parent_business_key"
    )
  ),
  override_enabled = FALSE,  # TRUE for reference tables, FALSE for transactional
  override_check_fields = c("field1", "field2")
)
```

#### override_enabled Flag

**FALSE (Transactional tables):** Uses historical tracking
- Checks for existing is_current=TRUE row
- If unchanged: skips insert (UNCHANGED status)
- If changed: marks old as is_current=FALSE, inserts new
- Returns: "INSERTED", "UPDATED" or "UNCHANGED"

**TRUE (Reference/lookup tables):** Uses INSERT ON CONFLICT DO UPDATE
- Upserts new data
- Always attempts insert or update
- Returns: "INSERTED" or "UPDATED"

### Adding a New Table

#### Step 1: Define Field Mapping

Add to `config/field_mappings.R`:

```r
NEW_TABLE_MAPPING <- list(
  primary_key = "new_table_id",
  csv_to_db = list(
    "CSV_Field1" = "db_field_1",
    "CSV_Field2" = "db_field_2",
    "CSV_ParentKey" = "parent_key_uid"
  ),
  date_fields = c("db_field_1"),
  integer_fields = c("db_field_2"),
  required_fields = c("db_field_1", "db_field_2"),
  validated_fields = list(
    "status_field" = c("VALID_VALUE1", "VALID_VALUE2")
  ),
  foreign_keys = list(
    list(
      field = "parent_key_uid",
      references_table = "parent_table",
      reference_column = "parent_table_id",
      references_field = "parent_key_uid"
    )
  ),
  override_enabled = FALSE,
  override_check_fields = c("db_field_1", "db_field_2")
)
```

#### Step 2: Add to Mappings List

In `field_mappings.R`, update `get_all_table_mappings()`:

```r
list(
  ...existing tables...,
  "new_table" = NEW_TABLE_MAPPING
)
```

#### Step 3: Add to ETL Sequence

In `src/main_etl_all_tables.R`, add to `ETL_SEQUENCE_ALL`:

```r
list(
  phase = "appropriate-phase",
  table_name = "new_table",
  csv_pattern = "*NewTable.csv",
  mapping = NEW_TABLE_MAPPING,
  key_field = "db_field_1"  # Optional, for quality checks
)
```

### Adding Validation Rules

#### CHECK Constraint Validation
Add to `config/field_mappings.R`
```r
VALID_STATUS_CODES <- c('ACTIVE', 'INACTIVE', 'PENDING')

# In mapping:
validated_fields = list(
  "status_column" = VALID_STATUS_CODES
)
```

#### Custom Validation

Modify `src/utils/validation_utils.R`:

```r
validate_row <- function(row, mapping, conn, table_name, row_num) {
  errors <- character(0)
  
  # Add custom validation
  if (row$amount < 0) {
    errors <- c(errors, "Amount cannot be negative")
  }
  
  return(list(valid = length(errors) == 0, errors = errors))
}
```

### Adding Transformations

Modify `src/utils/transformation_utils.R`:

```r
transform_row <- function(row, mapping, table_name, row_num) {
  transformed <- list()
  
  # Custom transformation
  transformed$derived_field <- paste(row$first, row$last, sep = " ")
  
  # Continue with standard transformations...
}
```

### Handling Multi-File Inputs

For tables with multiple CSV files (e.g., unit enrollments by year):

```r
# In ETL_SEQUENCE_ALL, use wildcards:
list(
  phase = "10-Unit-Enrollments",
  table_name = "unit_enrolments",
  csv_pattern = "*HEP_units-AOUs_*.csv",  # Matches 2017, 2018, etc.
  mapping = UNIT_ENROLMENTS_MAPPING
)

# The system automatically:
# 1. Finds all matching files
# 2. Processes each file sequentially
# 3. Extracts reporting_year from filename
# 4. Aggregates statistics
```

### Database Smart Insert Logic

The system uses `db_smart_insert()` which routes to the appropriate method:

**For override_enabled = TRUE:**
```
INSERT INTO table ... ON CONFLICT DO UPDATE
→ Returns INSERTED or UPDATED
```

**For override_enabled = FALSE:**
```
Check for existing is_current=TRUE row with same check_fields
├─ If EXISTS and VALUES IDENTICAL → UNCHANGED (skip)
├─ If EXISTS and VALUES DIFFER → Mark old as is_current=FALSE, insert new → UPDATED
└─ If NOT EXISTS → Insert with is_current=TRUE → INSERTED
```

### Logging

```r
# Different log levels
log_debug("Detailed information", table_name = "table_name", row_num = 5)
log_info("General information")
log_warn("Warning message")
log_error("Error message", table_name = "table_name")

# Log specific errors to file
log_row_error(table_name, row_num, row_data, error_message)
```

### Testing New Features

```r
# Test configuration without connecting to main database
DB_MODE <- "DUMMY"

# Process limited rows for testing
MAX_ROWS_TO_PROCESS <- 100

# Run main ETL
source("src/main_etl_all_tables.R")
result <- main()
```

---

## Troubleshooting

### Connection Issues

**Error: "Failed to connect to database"**
- Verify PostgreSQL is running
- Check host, port, username, password in config
- Use "Test Connection" button to diagnose
- Check firewall rules if connecting to remote server

### Data Validation Failures

**Error: "Invalid value for field: 'X'. Valid values: Y, Z"**
- Check CSV data against VALID_* constants in `field_mappings.R`
- Verify CHECK constraints in database match mapping definitions

**Error: "Foreign key violation"**
- Parent record must exist before child
- Check ETL_SEQUENCE_ALL processing order
- Verify parent table loaded successfully first

### CSV Issues

**Error: "CSV file not found"**
- Verify file matches pattern in ETL_SEQUENCE_ALL
- Check file is in configured DATA_INPUT_DIR
- Ensure filename capitalization matches pattern

**Error: "Missing CSV columns"**
- Check CSV has all required columns per mapping
- Verify column names match exactly (case-sensitive)
- Add missing columns or update mapping

### Memory/Performance

**Issue: Large batch sizes cause memory errors**
- Reduce BATCH_SIZE in config (e.g., 500 instead of 1000)
- Process data in smaller chunks

**Issue: Query results too large**
- Use LIMIT in query builder
- Filter with WHERE conditions first

### Log Files

All logs and errors are saved:
- **Logs**: `data/logs/etl_students_YYYYMMDD_HHMMSS.log`
- **Errors**: `data/errors/table_name_errors.csv`

Review these files for detailed error information.

---

## Appendix

### Table Dependencies

```
Phase 1 (Reference Data - No deps):
  ├─ courses_of_study
  └─ campuses

Phase 2 (Students - No deps):
  └─ hep_students

Phase 3 (Courses - Depends on courses_of_study):
  ├─ hep_courses
  ├─ special_interest_courses
  └─ course_fields_of_education

Phase 4 (Campus-Courses - Depends on campuses, hep_courses):
  ├─ hep_courses_on_campuses
  ├─ campus_course_fees_itsp
  └─ campuses_tac

Phase 5 (Student Details - Depends on hep_students):
  ├─ hep_student_citizenships
  ├─ hep_student_disabilities
  ├─ student_contacts_first_reported_address
  └─ commonwealth_scholarships

Phase 6 (Admissions - Depends on hep_students, hep_courses):
  └─ hep_course_admissions

Phase 7 (Admission Details - Depends on hep_course_admissions):
  ├─ hep_basis_for_admission
  ├─ hep_course_prior_credits
  ├─ course_specialisations
  ├─ hep_hdr_end_users_engagement
  ├─ rtp_scholarships
  └─ rtp_stipend

Phase 8 (Financial - Depends on hep_course_admissions):
  ├─ oshelp
  └─ sahelp

Phase 9 (Awards):
  ├─ aggregated_awards
  └─ exit_awards

Phase 10 (Unit Enrollments - Depends on hep_course_admissions):
  ├─ unit_enrolments
  └─ unit_enrolments_aous
```

### Common Field Types

| Type | R Function | Example |
|------|-----------|---------|
| Date | `parse_date()` | "2023-01-15" |
| Integer | `to_integer()` | "42" |
| Numeric | `to_numeric()` | "123.45" |
| String | `trim_string()` | "  text  " → "text" |
| Boolean | Special handling | "1" → TRUE, "0" → FALSE |

### Environment Variables

Set in `database_config.R`:

| Variable | Purpose |
|----------|---------|
| `DB_MODE` | "POSTGRESQL" or "DUMMY" |
| `BATCH_SIZE` | Rows per processing batch |
| `MAX_ROWS_TO_PROCESS` | Limit for testing (NULL = all) |
| `LOG_LEVEL` | DEBUG, INFO, WARN, or ERROR |
| `STOP_ON_ERROR` | Halt on first error if TRUE |

### Database Transactions

The system wraps ETL in a transaction:
- **COMMIT**: If all tables succeed OR STOP_ON_ERROR is FALSE
- **ROLLBACK**: If any table fails AND STOP_ON_ERROR is TRUE

This ensures data consistency - either all data loads or none does.

### Contact & Support

For issues or questions:
1. Check troubleshooting section above
2. Review log files in `data/logs/`
3. Check error details in `data/errors/table_name_errors.csv`
4. Contact the development team with logs and configuration details

---

**Document Version:** 1.0  
**Prepared by:** *Group 3 – CITS5206 2025 Semester 2*  
**Date:** *October 2025*