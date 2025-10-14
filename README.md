# TCSI Extract Database Project

## Project Overview

This project implements a relational PostgreSQL database to store, manage, and query TCSI extract data. It includes ETL processes, analytical views, and a Shiny app for interactive querying and reporting. The project is designed to streamline the workflow for TCSI data handling and provide an efficient platform for analysis.

Key features:
- Relational database schema for multiple TCSI entities (students, courses, enrolments, etc.)
- ETL scripts for importing and transforming raw TCSI extracts
- Consolidated wide table for simplified analytical queries
- Shiny application for data import, interactive querying and reporting
- Indexes and triggers for performance optimization and data consistency
- Role based access setup guidance for security

## Team Members - Group 3
This project was developed as part of CITS5206 – Information Technologhy Capstone Project (Semester 02, 2025) at the University of Western Australia.

| Student Number | Student Name       |
| -------------- | ------------------ |
| 24312467       | Maneesha Arachchi  |
| 24055569       | Xiaoqin Fan        |
| 24368182       | Junyu Zhang        |
| 24087336       | Yifan Shen         |
| 23912137       | Ahmed Shadab       |
| 23861854       | Xiaoyu Song        |
| 24122057       | Yize Sun           |
| 23746283       | Yuheng Zheng       |

## Project Usage

To run this project, install a R language environment in your local computer:

** Database **
- Install PostgreSQL: [PostgresSQL](https://www.postgresql.org/download/)  
- Optional: Chrome, Edge or Firefox
** R **
- Install R: [CRAN R Project](https://cran.r-project.org/)  
- Optional: Install RStudio: [RStudio Desktop](https://posit.co/download/rstudio-desktop/)  

---


### Required R Packages
The following packages are required:
```
shiny, shinyFiles, shinydashboard, DBI, RPostgres, dplyr, DT, lubridate, readr, openxlsx
```
Install with
```r
install.packages(c("shiny", "shinydashboard", "DBI", "RPostgres", "shinyFiles" "dplyr", "readr", "DT", "openxlsx", "getPass", "lubridate"))
```

## Directory Structure
```graphql
TCSIExtractDatabaseProject
├── tcsi-etl-project/
│    ├── app.R                          # Main Shiny application
│    ├── config/
│    │   ├── database_config.R          # Base configuration
│    │   ├── database_config_runtime.R  # Runtime config (updated by app)
│    │   └── field_mappings.R           # Field definitions for all tables
│    ├── src/
│    │   ├── utils/
│    │   │   ├── logging_utils.R        # Logging functions
│    │   │   ├── database_utils.R       # DB operations
│    │   │   ├── transformation_utils.R # Data transformations
│    │   │   ├── validation_utils.R     # Data validation
│    │   │   └── generic_etl.R          # Main ETL logic
│    │   ├── main_etl_all_tables.R      # ETL orchestration
│    │   └── app.R                      # Shiny app file
│    ├── data/
│    │   ├── tcsiSample/                # CSV input files
│    │   ├── logs/                      # ETL log files
│    │   └── errors/                    # Error reports
│    ├── docs                           # Supportive documentation
│    │   ├── db/                        # DB documentation
│    │   ├── etl/                       # ETL documentation
│    │   ├── shiny_app/                 # Shiny app documentation
│    │   ├── mapping/                   # CSV with mapping framework
│    │   └── erd-stage/                 # Entity Relationship Diagrams
│    └── install_packages.R             # Package installer
├── README.md                           # Project overview and usage instructions
├── tcsi__setup_guide.md                # Comprehensive setup guide
└── .gitignore                          # files and folders to exclude from version control

```


## Getting Started

**Clone or Copy Project Directory**

First, obtain the project files on your local machine. You can either clone the repository (if using Git):
```bash
git clone <repository-url>
cd TCSIExtractDatabaseProject/tcsi-etl-project/
```
Or copy the project folder manually:
- Go to Git repository
- Click green "Code" button → "Download ZIP"
- Save to your preferred location
- Extract the folder and navigate to tcsi-etl-project directory
Ensure you are in the `tcsi-etl-project` before proceeding with database setup.

## PostgreSQL Database Setup
The project supports creating and initializing the PostgreSQL database using different options.

### 1. Install PostgreSQL
Download and install PostgreSQL from the official website: https://www.postgresql.org/download/

### 2. Create Database

#### Option 1: Terminal / Command Line
1. Open your terminal.
2. Connect to PostgreSQL:
    ```bash
    psql -U postgres
    ```
3. Create the database
    ```sql
    CREATE DATABASE tcsi_db;
    \c tcsi_db
    ```
4. Navigate to the shema directory containing init.sql:
    ```bash
    cd path/to/tcsi-etl-project/schema
    ```
5. Run the initialization script:
    ```sql
    \i init.sql
    ```
This will create all tables, indexes, views, and triggers.

#### Option 2: pgAdmin 4 Interface
1. Open pgAdmin 4 and connect to your PostgreSQL server.
2. Right-click on Databases → Create → Database… → Name it `tcsi_db`
3. Open the PSQL Tool and run the init.sql script from:
    ```
    \cd '/path/to/tcsi-etl-project/schema'
    
    \i init.sql
    ```
4. Execute the script to create all tables, views, indexes, and triggers.

**Notes**
- Ensure PostgreSQL service is running before connecting.
- Always run scripts from the project’s schema directory to ensure relative paths for included SQL files work correctly.
- After initialization, the database is ready for ETL processes and Shiny app queries.

---
### Optional: Role-Based Access Control (RBAC) Setup
The project includes optional role-based access scripts (`roles_permissions.sql`, `create_users.sql`) to enhance database security and manage permissions for different user roles (e.g., read-only, dataentry, admin).

Refer to `docs/db/roles_and_permissions_setup_doc.md` for detailed setup instructions.
SQL scripts for role creation and grant management are located in the `tcsi-etl-project/schema/` directory.

These scripts can be executed after database initialization to configure appropriate access levels.

---

## Run ETL
The ETL process can be executed via the Shiny app (recommended) or manually using R scripts.

### Option 1 – Run ETL via Shiny App (Recommended)
The Shiny app provides a graphical interface for running ETL jobs, monitoring live logs, viewing results and performing database queries without manually executing R scripts.

**Steps:**
1. Open RStudio
2. File → New Project → Existing Directory → Navigate to `tcsi-etl-project` folder
(Or: Session → Set Working Directory → Choose Directory → Navigate to Project Directory)
3. Launch the application using either of the following methods:
    - **(RStudio):** Open `src/app.R` and click **Run App**
    - **(Console):** Run the app from the project root:
        ```r
        shiny::runApp('src')
        ```
4. Configure Database in the Configure tab:
    - Database Mode → `POSTGRESQL`
    - Enter host, port, database name, username, password → Click Test Connection
    - Select the Data Input Folder containing CSV samples
    - Adjust Batch Size, Max Rows, and Stop on Error
    - Configure Logging preferences
    - Click Save Configuration
        - Status indicator confirms save
        - Configuration is stored at `config/database_config_runtime.R`

5. Run ETL Process
    - Navigate to the ETL Process tab.
    - Click Start ETL Process to begin extraction, transformation, validation and loading.
    - Monitor live log output and status value boxes (tables processed, rows loaded, etc.).
    - On completion, review the Results tab for ETL summaries.

### Option 2 – Run ETL Manually

**Steps:**  
1. Repeat the first two steps in the previous option.
2. Open the `main_etl_all_tables.R` file
2. Execute the main ETL script `main_etl_all_tables.R`
    - **(RStudio):** Click **Source** at the top of the script editor
    - **(Console):** Run the file from the etl project root (tcsi-etl-project)
        ```
        source("src/main_etl_all_tables.R")
        ```
    - **(Keyboard):** Press `Ctrl + Shift + S` (Windows/Linux) or `Cmd + Shift + S` (Mac) to source the entire script.

> Note: The manual option is primarily for debugging, testing, or automation. The Shiny app is preferred for routine ETL operations.

## Query Data via Shiny App

After configuring database connection and successful data import:
1. Navigate to the Query Data tab
2. Fill in:
    - Table Name
    - Columns
    - Optional **WHERE** conditions, **GROUP BY**, **ORDER BY**, **LIMIT**  
You could preview query in `Preview Query` panel
3. Click **Run Query**
4. Review query output and row count
5. Download results as CSV or Excel if required
6. The **wide table** (used for KPI reporting and trend analysis) can also be accessed the same way, simply select it from the table name dropdown in the app.
7. Use **Clear All** to reset fields and conditions

## Stopping the App

Click **Stop** in RStudio or press `Esc` in the R console to safely stop the application.

## Supporting Documentation

Before exploring the detailed documentation below, refer to the [TCSI Setup Guide](tcsi_setup_guide.md) file for step-by-step instructions on setting up the TCSI Extract Database project locally.

Additional and detailed documentation for the TCSI Extract Database project is available in the `docs/` folder:

| Document                             | Description                                                                                    |
| ------------------------------------ | ---------------------------------------------------------------------------------------------- |
| [`etl_process_doc.md`](tcsi-etl-project/docs/etl/etl_process_doc.md)                | Overview of the ETL workflow, data transformations, validations, and logging.      |
| [`etl_tech_doc.md`](tcsi-etl-project/docs/etl/etl_tech_doc.md)                   | Comprehensive technical documentation covering system architecture, environment setup, and configuration details for the TCSI Extract Database and ETL system. |
| [`shiny_app_doc.md`](tcsi-etl-project/docs/shiny_app/shiny_app_doc.md)                   | User guide for the Shiny application, including configuration, ETL execution, and query usage. |
| [`db_data_dictionary_doc.md`](tcsi-etl-project/docs/db/db_data_dictionary_doc.md)          | Data dictionary covering all database tables, columns, data types, and code values.            |
| [`indexes_doc.md`](tcsi-etl-project/docs/db/indexes_doc.md)                     | Documentation of indexes applied to database tables for performance optimization.              |
| [`consolidated_view_doc.md`](tcsi-etl-project/docs/db/consolidated_view_doc.md)           | Details on the wide table / consolidated view for analytical queries.                          |
| [`roles_and_permissions_setup_doc.md`](tcsi-etl-project/docs/db/roles_and_permissions_setup_doc.md) | Guidance on setting up roles and permissions for secure database access.                       |
| [`tcsi_db_schema_doc.md`](tcsi-etl-project/docs/db/tcsi_db_schema_doc.md)              | Overview of the database schema, tables, relationships, and entity definitions.                |
| [`triggers_doc.md`](tcsi-etl-project/docs/db/triggers_doc.md)                    | Documentation of triggers implemented for maintaining data integrity and `is_current` flags.   |

**Note**: Open the .md files directly from the docs/ folder in your editor or viewer for detailed instructions and supporting information.
6. Develop a single, analysis-ready view (with all important fields);

---





