# TCSI ETL Shiny Application

## 1. Overview

The **TCSI ETL Shiny Application** is a web-based control and monitoring interface built in **R Shiny**. It supports the **TCSI ETL Project**, which automates data extraction, transformation, validation, and loading for higher education reporting datasets.

Key features:
- Configure database and file paths
- Execute ETL processes with live logging
- View summary results
- Query database tables
- Download query results as CSV or Excel

### Purpose
The app provides a central point to interact with the ETL system without running R scripts manually. It improves traceability, transparency, and usability for data administrators managing TCSI submissions.


### Target Users
- Reporting and Data Team, UWA

---

## 2. System Requirements

### Software Requirements
| Component | Version / Notes |
|------------|----------------|
| **R** | Version ≥ 4.4.0 |
| **RStudio** | Latest stable version recommended |
| **PostgreSQL** | Access credentials for the `tcsi_db` database |
| **Browser** | Chrome, Edge, or Firefox (Optional) |

### Required R Packages
The following packages are required:
```
shiny, shinyFiles, shinydashboard, DBI, RPostgres, dplyr, DT, lubridate, readr, openxlsx
```
Install with
```r
install.packages(c("shiny", "shinydashboard", "DBI", "RPostgres", "shinyFiles"
                   "dplyr", "readr", "DT", "openxlsx", "lubridate"))
```

## 3. Project Directory Structure

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

## 4. Installation and Setup
**Step 1 – Install R and RStudio**
1. Download R from https://cran.r-project.org
2. Install RStudio from https://posit.co/download/rstudio/

**Step 2 - Install Required Packages**

From the project root: `source("install_packages.R")`
This script installs all required packages and dependencies.

## 5. Application Tabs Overview
### 5.1 Configure
- Set Database Mode (`POSTGRESQL` or `DUMMY`)
- Enter database details if using PostgreSQL
- Select Data Input Folder
- Configure Batch Size, Max Rows, and Stop on Error
- Set logging options (console/file and log level)
- Save configuration to persist settings

### 5.2 ETL Process
- Start or stop ETL execution
- Monitor Current Status and Live Log Output
- View Value Boxes summarizing tables processed, succeeded, failed, and rows loaded

### 5.3 Results
View 
- Overall Statistics
- Phase Summary
- Table Details

### 5.4 Query Data
- Build queries dynamically:
    - Table name
    - Columns to select
    - `WHERE` conditions (up to 10)
    - `GROUP BY`, `ORDER BY`, `LIMIT`
- Preview the SQL query before execution
- Execute query and view results in a table
- Download query results as CSV or Excel

## 6. Running the Shiny Application
1. Open the RStudio project or navigate to the project root folder: `tcsi-etl-project/`
2. Launch the application using either of the following methods:
    - **Option 1 (RStudio):** Open `src/app.R` and click **Run App**
    - **Option 2 (Console):** Run the app from the project root:
    ```r
    shiny::runApp('tcsi-etl-project/src')
    ```
3. The app will open in your default browser or the RStudio Viewer pane.

    On startup:
    - The **Configure** tab loads first for connection setup.

4. Stopping the App
Click **Stop** in RStudio or press `Esc` in the R console to safely stop the application.

## 7. Initial Setup / Configuration
1. Open the Configure tab.
2. Select Database Mode:
    - `POSTGRESQL` for real database
    - `DUMMY` for testing without DB connection

3. If using `POSTGRESQL`:
    - Fill in host, port, database name, username and password
    - Click Test Connection to ensure connectivity
4. Select the Data Input Folder containing CSV samples
5. Adjust Batch Size, Max Rows, and Stop on Error options as needed
6. Configure Logging preferences
7. Click Save Configuration
    - Status indicator confirms save
    - Configuration is stored at `config/database_config_runtime.R`

## 8. ETL Execution Steps
1. Go to the ETL Process tab
2. Click Start ETL Process
3. Monitor:
    - Current Status
    - Live Log Output
    - Value Boxes for tables processed, succeeded, failed, and rows loaded
4. After completion:
    - Check Results tab for overall ETL summary

## 9. Querying Database Tables
1. Navigate to the Query Data tab
2. Fill in:
    - Table Name
    - Columns
    - Optional **WHERE** conditions, **GROUP BY**, **ORDER BY**, **LIMIT**
3. Click **Run Query**
4. Review query output and row count
5. Download results as CSV or Excel if required
6. Use **Clear All** to reset fields and conditions

## 10. Troubleshooting
| Issue                          | Solution                                                                                              |
| ------------------------------ | ----------------------------------------------------------------------------------------------------- |
| Cannot connect to database     | Verify PostgreSQL server is running and credentials are correct; test connection in **Configure** tab |
| ETL fails midway               | Ensure **Stop on Error** is set appropriately; check `/data/errors` and logs for details              |
| Query returns 0 rows           | Check table name, column names, and WHERE conditions; ensure DB is not empty                          |
| Required package not installed | Run `install_packages.R` from project root                                                            |
| Logs not writing               | Check that `/data/logs` folder exists and app has write permissions                                   |

---

**Document Version:** 1.0  
**Prepared by:** *Group 3 – CITS5206 2025 Semester 2*  
**Date:** *October 2025*
