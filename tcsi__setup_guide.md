# TCSI Database Complete Setup Guide

> **Last Updated:** October 2025  
> **Project:** TCSI Extract Database - Tertiary Collection of Student Information

---

## 📖 Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Quick Start (5 Minutes)](#quick-start)
4. [Detailed Setup Instructions](#detailed-setup)
   - [PostgreSQL Installation](#step-1-postgresql-installation)
   - [Database Creation](#step-2-database-creation)
   - [Environment Configuration](#step-3-environment-configuration)
   - [R Package Installation](#step-4-r-package-installation)
   - [Database Schema Setup](#step-5-database-schema-setup)
   - [ETL Configuration](#step-6-etl-configuration)
   - [Data Files Preparation](#step-7-data-files-preparation) 
   - [Run ETL Import](#step-8-run-etl-import)
   - [Verify Data Import](#step-9-verify-data-import)
5. [Testing & Verification](#testing-verification)
6. [Database Structure](#database-structure)
7. [Usage Examples](#usage-examples)
8. [Maintenance & Monitoring](#maintenance)
9. [Troubleshooting](#troubleshooting)
10. [Security Best Practices](#security)
11. [Additional Resources](#resources)

---

## 🎯 Overview

This guide provides complete instructions for setting up the PostgreSQL database infrastructure for the TCSI ETL project. The database stores and manages student data extracted from TCSI (Tertiary Collection of Student Information) with support for:

- ✅ **27 interconnected tables** covering student lifecycle data
- ✅ **Historical data preservation** with SCD-2 (Slowly Changing Dimensions)
- ✅ **R/RStudio integration** for data analysis
- ✅ **Automated ETL pipeline** with validation and logging
- ✅ **Data quality controls** and referential integrity

### Database Overview
- **Database Name:** `tcsi_db`
- **RDBMS:** PostgreSQL 16
- **Total Tables:** 26 tables
- **Data Categories:** Students, Courses, Admissions, Financial, Awards, Units

---

## 📋 Prerequisites

Before starting, ensure you have:

### Software Requirements
- ✅ **Operating System:** macOS, Windows, or Linux
- ✅ **Git:** For cloning the repository ([Download](https://git-scm.com/downloads))
- ✅ **R:** Version 4.0 or higher ([Download](https://cloud.r-project.org/))
- ✅ **RStudio:** Latest version ([Download](https://posit.co/download/rstudio-desktop/))
- ✅ **Terminal/Command Line:** Basic familiarity required

### Permissions
- ✅ Administrator/sudo access for software installation
- ✅ Ability to create and modify files in your home directory

### Disk Space
- ✅ Minimum 2GB free space for PostgreSQL installation
- ✅ Additional space for data storage (varies by dataset size)

---

## 📥 Step 0: Get the Project Code

**⚠️ DO THIS FIRST before any other setup steps**

### Option 1: Clone with Git (Recommended)

```bash
# Navigate to where you want to store the project
cd ~/Documents  # or your preferred location

# Clone the repository
git clone https://github.com/YOUR_ORG/TCSIExtractDatabaseProject.git

# Navigate into the project
cd TCSIExtractDatabaseProject/tcsi-etl-project

# Verify the structure
ls -la
# You should see: config/, data/, schema/, src/, etc.
```

### Option 2: Download ZIP (Alternative)

If you don't have Git installed:

1. **Go to GitHub repository**
   - Visit: `https://github.com/YOUR_ORG/TCSIExtractDatabaseProject`

2. **Download ZIP**
   - Click green "Code" button → "Download ZIP"
   - Save to your preferred location (e.g., `~/Documents/`)

3. **Extract and navigate**
   ```bash
   # macOS/Linux
   cd ~/Downloads
   unzip TCSIExtractDatabaseProject-main.zip
   mv TCSIExtractDatabaseProject-main ~/Documents/TCSIExtractDatabaseProject
   cd ~/Documents/TCSIExtractDatabaseProject/tcsi-etl-project
   
   # Windows (PowerShell)
   cd $HOME\Downloads
   Expand-Archive TCSIExtractDatabaseProject-main.zip -DestinationPath $HOME\Documents
   cd $HOME\Documents\TCSIExtractDatabaseProject\tcsi-etl-project
   ```

### Verify Project Structure

After downloading, verify you have the correct structure:

```bash
# List project contents
ls -la

# Expected structure:
tcsi-etl-project/
├── config/                 # Configuration files
├── data/                   # Data directory
│   ├── tcsiSample/         # Sample CSV files (ALREADY INCLUDED!)
│   ├── logs/               # ETL logs (created automatically)
│   └── errors/             # Error logs (created automatically)
├── docs/                   # Documentation
├── schema/                 # Database schema SQL files
├── src/                    # Source code
│   ├── utils/              # Utility functions
│   ├── main_etl_all_tables.R  # Main ETL script
│   └── app.R               # Shiny app
├── R/                      # Helper scripts
├── install_packages.R      # Package installer
└── README.md
```

### Set Your Working Directory

**For RStudio users:**
```r
# Open RStudio
# File → Open Project → Navigate to tcsi-etl-project
# Or: Session → Set Working Directory → Choose Directory
```

**For Terminal users:**
```bash
# Remember this path - you'll use it throughout setup
cd ~/Documents/TCSIExtractDatabaseProject/tcsi-etl-project
pwd  # Print working directory - save this path!
```

**💡 Pro Tip:** Save your project path as an environment variable:

```bash
# Add to ~/.zshrc or ~/.bashrc
echo 'export TCSI_PROJECT="$HOME/Documents/TCSIExtractDatabaseProject/tcsi-etl-project"' >> ~/.zshrc
source ~/.zshrc

# Now you can quickly navigate:
cd $TCSI_PROJECT
```

---

## ⚡ Quick Start

**For experienced users who want to get running immediately:**

```bash
# 0. Get the project code
cd ~/Documents
git clone https://github.com/YOUR_ORG/TCSIExtractDatabaseProject.git
cd TCSIExtractDatabaseProject/tcsi-etl-project

# 1. Install PostgreSQL (macOS)
brew install postgresql@16
brew services start postgresql@16

# 2. Create database
createdb tcsi_db

# 3. Create schema
psql -d tcsi_db -f schema/init.sql

# 4. Install R packages
Rscript install_packages.R

# 5. Set up environment variables
# Create ~/.Renviron with:
# DB_HOST=localhost
# DB_PORT=5432
# DB_NAME=tcsi_db
# DB_USER=your_username
# DB_PASSWORD=

# 6. Restart R/RStudio (IMPORTANT!)

# 7. Sample data files are already in data/tcsiSample/

# 8. Run ETL to import data
R -e "source('src/main_etl_all_tables.R'); main()"
```

For detailed step-by-step instructions, continue to the next section.

---

## 🔧 Detailed Setup Instructions

### Step 0: Get the Project Code ✅

**See the ["Step 0: Get the Project Code"](#-step-0-get-the-project-code) section above for detailed instructions.**

Quick reference:
```bash
cd ~/Documents
git clone https://github.com/YOUR_ORG/TCSIExtractDatabaseProject.git
cd TCSIExtractDatabaseProject/tcsi-etl-project
```

---

### Step 1: PostgreSQL Installation

#### Option A: macOS (Homebrew)

**1.1 Install Homebrew (if not already installed)**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**1.2 Install PostgreSQL 16**
```bash
# Install PostgreSQL
brew install postgresql@16

# Add PostgreSQL to PATH (add to ~/.zshrc for permanent)
echo 'export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**1.3 Start PostgreSQL Service**
```bash
# Start service (will auto-start on login)
brew services start postgresql@16

# Verify service is running
brew services info postgresql@16
```

**1.4 Verify Installation**
```bash
psql --version
# Expected output: psql (PostgreSQL) 16.x
```

#### Option B: Windows

**1.1 Download PostgreSQL Installer**
- Visit [PostgreSQL Downloads](https://www.postgresql.org/download/windows/)
- Download PostgreSQL 16.x Windows installer
- Run the installer as Administrator

**1.2 Installation Settings**
- Installation Directory: `C:\Program Files\PostgreSQL\16`
- Data Directory: `C:\Program Files\PostgreSQL\16\data`
- Port: `5432` (default)
- Locale: Default locale
- Create a strong password for the `postgres` superuser

**1.3 Add PostgreSQL to PATH**
```powershell
# Open PowerShell as Administrator
$env:Path += ";C:\Program Files\PostgreSQL\16\bin"
[Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine)
```

**1.4 Verify Installation**
```powershell
psql --version
```

#### Option C: Linux (Ubuntu/Debian)

```bash
# Install PostgreSQL
sudo apt update
sudo apt install postgresql-16 postgresql-contrib-16

# Start service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Verify
psql --version
```

---

### Step 2: Database Creation

**2.1 Create the TCSI Database**

**macOS/Linux:**
```bash
# Default user is your system username with no password
createdb tcsi_db
```

**Windows:**
```powershell
# Connect as postgres user first
psql -U postgres

# In psql prompt:
CREATE DATABASE tcsi_db;
\q
```

**2.2 Verify Database Creation**
```bash
# List all databases
psql -l

# You should see tcsi_db in the list
```

**2.3 Test Connection**
```bash
# Connect to the database
psql -d tcsi_db

# You should see a prompt like: tcsi_db=#
# Type \q to exit
```

---

### Step 3: Environment Configuration

To securely store database credentials, use the `.Renviron` file.

**3.1 Create `.Renviron` File**

**macOS/Linux:**
```bash
# Create .Renviron in your home directory
cat > ~/.Renviron << 'EOF'
DB_HOST=localhost
DB_PORT=5432
DB_NAME=tcsi_db
DB_USER=your_username
DB_PASSWORD=
EOF

# Replace 'your_username' with your actual username
# macOS: usually your computer login name
# Linux: check with: whoami
```

**Windows:**
```powershell
# In PowerShell
$content = @"
DB_HOST=localhost
DB_PORT=5432
DB_NAME=tcsi_db
DB_USER=your_username
DB_PASSWORD=
"@

$content | Out-File -FilePath "$env:USERPROFILE\.Renviron" -Encoding ASCII
```

**3.2 ⚠️ CRITICAL: Restart R/RStudio**

**Environment variables ONLY load when R starts!**

```r
# RStudio: Session → Restart R
# Or keyboard shortcut: Cmd/Ctrl + Shift + 0

# Terminal R:
q()  # Then restart R
```

**3.3 Verify Environment Variables**

```r
# After restarting R, check if variables loaded:
Sys.getenv("DB_HOST")     # Should return "localhost"
Sys.getenv("DB_NAME")     # Should return "tcsi_db"
Sys.getenv("DB_USER")     # Should return your username
```

**3.4 Troubleshooting .Renviron**

If environment variables are empty:

```r
# Check home directory location
Sys.getenv("HOME")

# Check if file exists
file.exists("~/.Renviron")  # Should be TRUE

# Manually load (temporary fix)
readRenviron("~/.Renviron")

# But remember: You MUST restart R for permanent loading!
```

---

### Step 4: R Package Installation

#### 4.1 Required Packages

The project requires the following R packages:
- **DBI** - Database interface
- **RPostgres** - PostgreSQL driver for R
- **dplyr** - Data manipulation
- **readr** - CSV reading
- **writexl** - Excel export

#### 4.2 Installation Methods

**Option A: Automated Installation (Recommended)**

Navigate to the project directory and run:
```r
source("install_packages.R")
```

**Option B: Manual Installation**

In R console:
```r
# Install required packages
install.packages(c("DBI", "RPostgres", "dplyr", "readr", "writexl"),
                 repos = "https://cloud.r-project.org/")

# Verify installation
library(DBI)
library(RPostgres)
library(dplyr)
```

#### 4.3 Verify Package Installation

```r
# Check if packages are installed
packages <- c("DBI", "RPostgres", "dplyr", "readr", "writexl")
installed <- packages %in% rownames(installed.packages())
all(installed)  # Should return TRUE
```

---

### Step 5: Database Schema Setup

The database schema consists of 27 tables organized into 8 SQL files.

#### 5.1 Schema File Structure

```
schema/
├── init.sql                      # Master loader script
├── 01_students.sql               # Student master tables (6 tables)
├── 02_courses.sql                # Course reference tables (4 tables)
├── 03_course_admissions.sql      # Admissions tables (5 tables)
├── 04_loans.sql                  # Financial aid tables (4 tables)
├── 05_awards.sql                 # Awards and outcomes (2 tables)
├── 06_campuses.sql               # Campus tables (4 tables)
├── 07_unit_enrolments.sql        # Unit enrolment tables (2 tables)
└── 08_indexes.sql                # Performance indexes
```

#### 5.2 Create All Tables (Recommended Method)

**Navigate to project directory:**
```bash
# Replace with your actual project path
cd /path/to/tcsi-etl-project

# Examples:
# Windows (Git Bash): cd /c/Users/YourName/Documents/tcsi-etl-project
# macOS:   cd ~/Documents/tcsi-etl-project
# Linux:   cd ~/projects/tcsi-etl-project
```

**Execute master script:**
```bash
# This will create all 27 tables and indexes
psql -d tcsi_db -f schema/init.sql
```

**Expected Output:**
```
CREATE TABLE
CREATE TABLE
... (27 times)
CREATE INDEX
CREATE INDEX
... (10 times)
```

#### 5.3 Verify Schema Creation

**Check table count:**
```bash
psql -d tcsi_db -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';"
```
Expected: 26 tables

**List all tables:**
```bash
psql -d tcsi_db -c "\dt"
```

---

### Step 6: ETL Configuration

#### 6.1 Configure Database Connection

Edit `config/database_config.R`:

```r
# Database Configuration
DB_MODE <- "POSTGRESQL"  # Changed from "DUMMY"

# PostgreSQL Connection Settings
# IMPORTANT: Use environment variables, NEVER hardcode credentials
DB_CONFIG <- list(
  host = Sys.getenv("DB_HOST"),
  port = as.integer(Sys.getenv("DB_PORT")),
  dbname = Sys.getenv("DB_NAME"),
  user = Sys.getenv("DB_USER"),
  password = Sys.getenv("DB_PASSWORD")
)

# ETL Processing Settings
BATCH_SIZE <- 1000
MAX_ROWS_TO_PROCESS <- NULL       # NULL = process all rows
STOP_ON_ERROR <- FALSE            # Continue on errors

# File Paths
PROJECT_ROOT <- getwd()
DATA_INPUT_DIR <- file.path(PROJECT_ROOT, "data", "tcsiSample")
DATA_LOGS_DIR <- file.path(PROJECT_ROOT, "data", "logs")
DATA_ERRORS_DIR <- file.path(PROJECT_ROOT, "data", "errors")
```

⚠️ **Security Warning:** Never hardcode database credentials in configuration files. Always use environment variables through `.Renviron`.

#### 6.2 Alternative: Use Shiny Configuration App

The project includes a graphical configuration tool for easy database setup.

**Run Shiny App:**
```r
# Navigate to src directory in R
setwd("path/to/tcsi-etl-project/src")

# Run app
library(shiny)
runApp("app.R")
```

**Shiny App Features:**
- ✅ Database connection testing with real-time feedback
- ✅ Visual configuration file generation
- ✅ ETL process monitoring with progress bars
- ✅ Real-time log viewing
- ✅ Error reporting and diagnostics

---

## ✅ Testing & Verification

### Test 1: PostgreSQL Service Status

```bash
# Check service status
brew services info postgresql@16  # macOS
# OR
sudo systemctl status postgresql   # Linux
# OR
Get-Service postgresql*            # Windows PowerShell
```

Expected: Service should be "running" or "started"

### Test 2: Database Connection from Terminal

```bash
psql -d tcsi_db -c "SELECT version();"
```

Expected output:
```
PostgreSQL 16.x on x86_64-apple-darwin...
```

### Test 3: R Database Connection

**Use the project's existing connection script:**

```r
# 1. Load the project's database connection script
source("R/connect_db.R")

# 2. Test connection
cat("Testing database connection...\n")
db_conn <- create_db_connection()
# Expected: "Database connection successful!"

# 3. Test query
cat("\n=== PostgreSQL Version ===\n")
print(run_query("SELECT version();"))

# 4. Check for tables
cat("\n=== Database Tables ===\n")
tables <- run_query("
  SELECT tablename 
  FROM pg_tables 
  WHERE schemaname = 'public' 
  ORDER BY tablename;
")

if (nrow(tables) > 0) {
  cat("Found", nrow(tables), "tables\n")
  print(head(tables, 10))
} else {
  cat("No tables found. You need to create the schema (Step 5)\n")
}

# 5. Clean up
dbDisconnect(db_conn)
cat("\n Connection test complete!\n")
```

### Test 4: Quick ETL Test

Test ETL with a small dataset (optional quick test):

```r
# Set working directory to project root
setwd("path/to/tcsi-etl-project")

# Load configuration
source("config/database_config.R")
source("config/field_mappings.R")

# Load utilities
source("src/utils/logging_utils.R")
source("src/utils/database_utils.R")
source("src/utils/generic_etl.R")

# Test ETL for one table (e.g., campuses)
conn <- db_connect()
result <- generic_etl(conn, "campuses", "*Campuses.csv", CAMPUSES_MAPPING)
db_disconnect(conn)

print(result)
```

---

## 🆕 Step 7: Data Files Preparation

**Good news: Sample data files are ALREADY INCLUDED in the project!**

### 7.1 Verify Sample Data Files

The project includes sample TCSI CSV files for testing:

```bash
# Navigate to data directory
cd ~/Documents/tcsi-etl-project/data/tcsiSample

# List all sample CSV files
ls -la

# You should see files like:
# Campuses.csv
# CoursesOfStudy.csv
# HEPStudents.csv
# HEPCourses.csv
# HEPCourseAdmissions.csv
# ... and more (one file per table type)
```

**Or check in R:**
```r
# Set to project root
setwd("~/Documents/tcsi-etl-project")

# List sample files
list.files("data/tcsiSample", pattern = "\\.csv$")
```

### 7.2 Data File Naming Convention

CSV files must follow the naming pattern configured in `config/field_mappings.R`:

**Pattern Examples:**
- `*HEPStudents*.csv` → matches any file containing "HEPStudents"
- `*Campuses*.csv` → matches any file containing "Campuses"
- `*CoursesOfStudy*.csv` → matches any file containing "CoursesOfStudy"

**Valid filenames:**
- ✅ `HEPStudents_202410.csv`
- ✅ `Extract_HEPStudents_October.csv`
- ✅ `UWA_HEPStudents_2024.csv`
- ✅ `Campuses.csv`

**Invalid filenames:**
- ❌ `students.csv` (missing "HEPStudents")
- ❌ `data_export.csv` (doesn't match any pattern)

### 7.3 Data Directory Structure

```
data/
├── tcsiSample/          # Input CSV files (SOURCE DATA HERE)
│   ├── Campuses.csv
│   ├── CoursesOfStudy.csv
│   ├── HEPStudents.csv
│   ├── HEPCourses.csv
│   └── ... (all 27 table types)
├── logs/                # ETL logs (auto-created)
│   └── etl_20251013_143022.log
└── errors/              # Error logs (auto-created)
    └── hep_students_errors.csv
```

### 7.4 Using Your Own TCSI Data

**To import your own TCSI extract data:**

1. **Place CSV files in `data/tcsiSample/` directory:**
   ```bash
   cp /path/to/your/HEPStudents_202410.csv data/tcsiSample/
   ```

2. **Ensure filenames match the patterns:**
   - Check `config/field_mappings.R` for required patterns
   - File must contain the table identifier in its name

3. **Verify file format:**
   ```r
   # Check CSV structure
   test_data <- read.csv("data/tcsiSample/YourFile.csv", nrows = 5)
   head(test_data)
   names(test_data)  # Check column names match TCSI format
   ```

### 7.5 Data File Requirements

**Format Requirements:**
- ✅ CSV format with comma delimiters
- ✅ First row contains column headers
- ✅ Column names match TCSI field names (e.g., `E313_StudentIdentificationCode`)
- ✅ Encoding: UTF-8 (recommended)

**Common Issues:**
- ❌ Excel files (`.xlsx`) - must convert to CSV first
- ❌ Tab-delimited files - must use comma delimiters
- ❌ Missing headers - first row must be column names
- ❌ Wrong column names - must match TCSI specification

---

## 🆕 Step 8: Run ETL Import

**Now that you have data files, let's import them into the database!**

### 8.1 Run Complete ETL Pipeline

**Method A: Using R Console (Recommended)**

```r
# IMPORTANT: Set working directory to project root
setwd("~/Documents/tcsi-etl-project")

# Verify you're in the correct directory
getwd()  # Should show project root path
list.files()  # Should see: src/, schema/, config/, data/

# Load and run main ETL script
source("src/main_etl_all_tables.R")

# Execute ETL for all tables
results <- main()

# View summary
print_overall_summary(results)
```

**Method B: Using Terminal/Command Line**

```bash
# Navigate to project directory
cd ~/Documents/tcsi-etl-project

# Run ETL
Rscript -e "source('src/main_etl_all_tables.R'); main()"
```

**Method C: Using RStudio**

1. Open RStudio
2. Set Working Directory: `Session → Set Working Directory → To Project Directory`
3. Open file: `src/main_etl_all_tables.R`
4. Click "Source" button or press `Cmd/Ctrl + Shift + S`

### 8.2 ETL Process Overview

The ETL will process tables in dependency order:

**Phase 1: Reference Data (No dependencies)**
- `courses_of_study`
- `campuses`

**Phase 2: Students Master**
- `hep_students`

**Phase 3: Courses**
- `hep_courses`
- `special_interest_courses`
- `course_fields_of_education`

**... and so on through all 27 tables**

### 8.3 Expected Output

During ETL execution, you'll see:

```
========================================
Starting Complete TCSI ETL (All 26 Tables)
========================================

========================================
PHASE: 1-Reference
========================================

Processing table: courses_of_study
--------------------
Reading CSV file...
Read 145 rows from CSV
Processing data in batches...
ETL complete for courses_of_study: 145 rows loaded, 0 errors

Processing table: campuses
--------------------
Reading CSV file...
Read 8 rows from CSV
ETL complete for campuses: 8 rows loaded, 0 errors

========================================
PHASE: 2-Students
========================================

Processing table: hep_students
--------------------
Reading CSV file...
Read 25000 rows from CSV
Processing data in batches...
ETL complete for hep_students: 25000 rows loaded, 0 errors

... (continues for all tables)

========================================
OVERALL SUMMARY
========================================
Total tables processed: 27
Successful: 27
Failed: 0
Skipped: 0
Total rows loaded: 45,823
Total errors: 0
Duration: 8.5 minutes
========================================
```

### 8.4 ETL Success Indicators

**✅ Successful ETL:**
- All tables show "SUCCESS"
- `loaded_rows` > 0 for each table
- `errors` = 0 or very few
- No critical errors in logs
- Transaction committed

**⚠️ Partial Success:**
- Some tables skipped (CSV not found)
- Minor validation errors
- Check logs for details

**❌ Failed ETL:**
- Multiple tables failed
- Transaction rolled back
- Check error logs in `data/errors/`
- Review log file in `data/logs/`

### 8.5 ETL Performance

**Typical Processing Time:**
- Small dataset (< 1,000 rows/table): 2-5 minutes
- Medium dataset (1,000-10,000 rows/table): 5-15 minutes
- Large dataset (> 10,000 rows/table): 15-30 minutes

**Factors affecting speed:**
- Number of rows per table
- Data validation complexity
- Foreign key lookups
- Database indexing
- System resources (CPU, RAM, disk)

### 8.6 Troubleshooting ETL Issues

**Issue: "No CSV file found for table X"**
```
Solution:
1. Check file exists in data/tcsiSample/
2. Verify filename matches pattern
3. Check file permissions (readable)
```

**Issue: "Foreign key violation"**
```
Solution:
1. Ensure parent tables loaded first
2. Check reference data is valid
3. Review error log in data/errors/
```

**Issue: "Connection to database failed"**
```
Solution:
1. Verify PostgreSQL is running
2. Check .Renviron credentials
3. Test connection with Test 3
4. Restart R/RStudio
```

---

## 🆕 Step 9: Verify Data Import

**Verify that your data was successfully imported into the database.**

### 9.1 Check Data Loaded

**Quick verification in R:**

```r
source("R/connect_db.R")

# Check table row counts
cat("\n=== Database Table Counts ===\n")
table_counts <- run_query("
  SELECT 
    tablename,
    (xpath('/row/cnt/text()', 
           xml_count))[1]::text::int AS row_count
  FROM (
    SELECT 
      tablename,
      table_schema,
      query_to_xml(
        format('SELECT COUNT(*) AS cnt FROM %I.%I', 
               table_schema, tablename),
        false, true, ''
      ) AS xml_count
    FROM information_schema.tables
    WHERE table_schema = 'public'
  ) AS counts
  ORDER BY row_count DESC;
")

print(table_counts)

# Summary statistics
cat("\n=== Summary ===\n")
cat("Total tables:", nrow(table_counts), "\n")
cat("Total rows across all tables:", sum(table_counts$row_count), "\n")
cat("Tables with data:", sum(table_counts$row_count > 0), "\n")
cat("Empty tables:", sum(table_counts$row_count == 0), "\n")
```

**Alternative - Simple check:**

```r
source("R/connect_db.R")

# Check specific tables
cat("Students:", run_query("SELECT COUNT(*) FROM hep_students")[[1]], "\n")
cat("Courses:", run_query("SELECT COUNT(*) FROM hep_courses")[[1]], "\n")
cat("Admissions:", run_query("SELECT COUNT(*) FROM hep_course_admissions")[[1]], "\n")
cat("Campuses:", run_query("SELECT COUNT(*) FROM campuses")[[1]], "\n")
```

**From Terminal:**

```bash
psql -d tcsi_db -c "
  SELECT 
    schemaname,
    tablename,
    n_live_tup AS row_count
  FROM pg_stat_user_tables
  WHERE schemaname = 'public'
  ORDER BY n_live_tup DESC;
"
```

### 9.2 View ETL Logs

**Check most recent ETL log:**

```bash
# Navigate to logs directory
cd ~/Documents/tcsi-etl-project/data/logs

# List logs (newest first)
ls -lt

# View most recent log
tail -100 etl_20251013_143022.log

# Search for errors
grep -i "error" etl_20251013_143022.log

# Search for specific table
grep "hep_students" etl_20251013_143022.log
```

**In R:**

```r
# Find most recent log
log_files <- list.files("data/logs", pattern = "\\.log$", full.names = TRUE)
latest_log <- log_files[which.max(file.info(log_files)$mtime)]

cat("Latest log file:", latest_log, "\n\n")

# Read and display last 50 lines
log_content <- readLines(latest_log)
cat(tail(log_content, 50), sep = "\n")
```

### 9.3 Check for Errors

**Review error files (if any):**

```bash
# Check if any error files exist
ls -la data/errors/

# View error file for a specific table
head -20 data/errors/hep_students_errors.csv

# Count errors
wc -l data/errors/hep_students_errors.csv
```

**Common errors and meanings:**

| Error Type | Meaning | Action |
|------------|---------|--------|
| Required field is NULL | Missing mandatory data | Check source CSV |
| Foreign key violation | Referenced record doesn't exist | Load parent table first |
| Invalid value for field | Data doesn't match constraints | Verify data format |
| Duplicate key | Record already exists | Check for duplicates in CSV |

### 9.4 Verify Data Quality

**Run sample queries to verify data integrity:**

```r
source("R/connect_db.R")

# 1. Check for students
cat("\n=== Sample Students ===\n")
students_sample <- run_query("
  SELECT 
    e313_student_identification_code AS student_id,
    e330_attendance_type_code AS attendance,
    e358_citizen_resident_code AS citizen_status
  FROM hep_students
  LIMIT 5;
")
print(students_sample)

# 2. Check for duplicate students
cat("\n=== Duplicate Check ===\n")
duplicates <- run_query("
  SELECT 
    e313_student_identification_code,
    COUNT(*) AS count
  FROM hep_students
  GROUP BY e313_student_identification_code
  HAVING COUNT(*) > 1;
")
if (nrow(duplicates) > 0) {
  cat("Found", nrow(duplicates), "duplicate student IDs\n")
  print(duplicates)
} else {
  cat("No duplicate student IDs found\n")
}

# 3. Check foreign key relationships
cat("\n=== Foreign Key Validation ===\n")
orphaned_admissions <- run_query("
  SELECT COUNT(*) AS orphaned_count
  FROM hep_course_admissions a
  LEFT JOIN hep_students s 
    ON a.student_id = s.student_id
  WHERE s.student_id IS NULL;
")
if (orphaned_admissions$orphaned_count[1] > 0) {
  cat("Found", orphaned_admissions$orphaned_count[1], "admissions without students\n")
} else {
  cat("All admissions have valid student references\n")
}

# 4. Check data completeness
cat("\n=== Data Completeness ===\n")
completeness <- run_query("
  SELECT 
    COUNT(*) AS total_students,
    COUNT(e313_student_identification_code) AS with_id,
    COUNT(e330_attendance_type_code) AS with_attendance,
    COUNT(e358_citizen_resident_code) AS with_citizenship
  FROM hep_students;
")
print(completeness)
```

### 9.5 Verify Historical Data (SCD-2)

**Check if historical records are preserved:**

```r
# Check for records with different versions
historical_check <- run_query("
  SELECT 
    e313_student_identification_code AS student_id,
    COUNT(*) AS version_count,
    MIN(extract_timestamp) AS first_seen,
    MAX(extract_timestamp) AS last_seen
  FROM hep_students
  GROUP BY e313_student_identification_code
  HAVING COUNT(*) > 1
  LIMIT 10;
")

if (nrow(historical_check) > 0) {
  cat("Historical versions found for", nrow(historical_check), "students\n")
  print(historical_check)
} else {
  cat("No historical versions yet (this is normal for first import)\n")
}
```

### 9.6 Generate Data Summary Report

**Create a comprehensive summary:**

```r
# Complete verification report
cat("\n")
cat("========================================\n")
cat("DATA IMPORT VERIFICATION REPORT\n")
cat("========================================\n")
cat("Generated:", Sys.time(), "\n")
cat("Database:", Sys.getenv("DB_NAME"), "\n")
cat("\n")

# Table statistics
table_stats <- run_query("
  SELECT 
    COUNT(*) AS total_tables,
    SUM(CASE WHEN n_live_tup > 0 THEN 1 ELSE 0 END) AS tables_with_data,
    SUM(n_live_tup) AS total_rows
  FROM pg_stat_user_tables
  WHERE schemaname = 'public';
")

cat("--- Database Statistics ---\n")
cat("Total tables:", table_stats$total_tables[1], "\n")
cat("Tables with data:", table_stats$tables_with_data[1], "\n")
cat("Total rows:", format(table_stats$total_rows[1], big.mark = ","), "\n")
cat("\n")

# Top 10 largest tables
cat("--- Top 10 Largest Tables ---\n")
largest_tables <- run_query("
  SELECT 
    tablename,
    n_live_tup AS row_count
  FROM pg_stat_user_tables
  WHERE schemaname = 'public'
  ORDER BY n_live_tup DESC
  LIMIT 10;
")
print(largest_tables)

cat("\n")
cat("========================================\n")
cat("VERIFICATION COMPLETE\n")
cat("========================================\n")
```

### 9.7 Next Steps After Verification

**If verification successful:**
1. ✅ Data is ready for analysis
2. ✅ Proceed to [Usage Examples](#usage-examples)
3. ✅ Set up regular backups (see [Maintenance](#maintenance))

**If issues found:**
1. ⚠️ Review error logs in `data/errors/`
2. ⚠️ Check ETL log in `data/logs/`
3. ⚠️ Fix data issues in source CSV files
4. ⚠️ Re-run ETL: `source("src/main_etl_all_tables.R"); main()`
5. ⚠️ Consult [Troubleshooting](#troubleshooting) section

---

## 🗄️ Database Structure

### Table Categories and Count

| Category | Tables | Description |
|----------|--------|-------------|
| **Students** | 6 | Master student records, citizenships, disabilities, addresses, scholarships |
| **Courses** | 4 | Course programs, special interest courses, education fields |
| **Admissions** | 5 | Course admissions, basis, prior credits, specializations |
| **Financial** | 4 | OS-HELP, SA-HELP, RTP scholarships and stipends |
| **Campus** | 4 | Campus master, course locations, fees |
| **Awards** | 2 | Aggregated awards and exit awards |
| **Unit Enrollment** | 2 | Unit enrollments and AOUs |

**Total: 26 interconnected tables**

### Key Tables Detail

**1. hep_students** (Student Master)
- Primary table for student demographic data
- Key field: `e313_student_identification_code`
- Includes: citizenship, attendance type, basis of admission

**2. hep_courses** (Course Master)
- Course program definitions
- Key field: `e307_course_code`
- Links to: course admissions, campus locations

**3. hep_course_admissions** (Admissions)
- Student course enrollment records
- Foreign keys: `student_id`, `uid5_courses_res_key`
- Includes: admission date, status, completion

**4. campuses** (Campus Reference)
- Campus location master data
- Key field: `e525_campus_suburb`
- Used by: courses on campuses, fees

[Continue with remaining sections from original setup guide...]

---

## 📚 Usage Examples

### Example 1: Connect to Database

**Option A: Using the project's helper script**

```r
source("R/connect_db.R")

# Create connection
db_conn <- create_db_connection()

# Use the connection
result <- dbGetQuery(db_conn, "SELECT COUNT(*) FROM hep_students;")
print(result)

# Disconnect
dbDisconnect(db_conn)
```

### Example 2: Query Student Data

```r
# Simple query
students <- dbGetQuery(con, "
  SELECT 
    e313_student_identification_code,
    e330_attendance_type_code,
    e358_citizen_resident_code
  FROM hep_students
  LIMIT 10
")

print(students)
```

### Example 3: Complex Join Query

```r
# Query with multiple joins
admissions_summary <- dbGetQuery(con, "
  SELECT 
    s.e313_student_identification_code AS student_id,
    c.e307_course_code AS course_code,
    c.e310_course_name AS course_name,
    a.e327_admission_basis_code,
    a.e489_course_admission_date
  FROM hep_students s
  INNER JOIN hep_course_admissions a ON s.student_id = a.student_id
  INNER JOIN hep_courses c ON a.uid5_courses_res_key = c.uid5_courses_res_key
  WHERE a.e489_course_admission_date >= '2023-01-01'
  LIMIT 20
")

print(admissions_summary)
```

### Example 4: Export Query Results

```r
library(writexl)

# Query and export
results <- dbGetQuery(con, "SELECT * FROM hep_students LIMIT 100")
write_xlsx(results, "student_export.xlsx")

# Always disconnect when done
dbDisconnect(con)
```

---

## 🔧 Maintenance & Monitoring

### Check Database Size

```bash
psql -d tcsi_db -c "
  SELECT pg_size_pretty(pg_database_size('tcsi_db')) AS database_size;
"
```

### Check Individual Table Sizes

```bash
psql -d tcsi_db -c "
  SELECT 
    tablename,
    pg_size_pretty(pg_total_relation_size('public.'||tablename)) AS size
  FROM pg_tables
  WHERE schemaname = 'public'
  ORDER BY pg_total_relation_size('public.'||tablename) DESC;
"
```

### Backup Database

**Full backup:**
```bash
# Create backup
pg_dump tcsi_db > "tcsi_backup_$(date +%Y%m%d).sql"

# Restore from backup
psql tcsi_db < tcsi_backup_20251012.sql
```

---

## 🛠 Troubleshooting

### Issue 0: Environment Variables Not Loading ⚠️

**Most common issue!**

**Solution:** Restart R/RStudio after creating `.Renviron`

```r
# RStudio: Session → Restart R
# Or: Cmd/Ctrl + Shift + 0
```

### Issue 1: Cannot Connect to PostgreSQL

```bash
# Check if service is running
brew services info postgresql@16  # macOS

# If not running:
brew services start postgresql@16
```

### Issue 2: Tables Not Created

```bash
# Verify schema files exist
ls -la schema/

# Re-run schema creation
psql -d tcsi_db -f schema/init.sql
```

### Issue 3: ETL Fails with "CSV Not Found"

```bash
# Check data directory
ls -la data/tcsiSample/

# Verify file naming matches patterns
# Pattern: *TableName*.csv
```

---

## 🔐 Security Best Practices

### 1. Never Hardcode Credentials

✅ **DO:** Use `.Renviron` for credentials  
❌ **DON'T:** Hardcode passwords in scripts  

### 2. Git Configuration

Ensure your `.gitignore` includes:
```gitignore
.Renviron
.env
**/database_config_runtime.R
```

---

## 📚 Additional Resources

- [PostgreSQL 16 Documentation](https://www.postgresql.org/docs/16/)
- [RPostgres Package](https://rpostgres.r-dbi.org/)
- [DBI Package](https://dbi.r-dbi.org/)


---

## ✅ Setup Checklist

Use this checklist to verify your setup is complete:

### Basic Setup (Steps 0-6)
- [ ] Project code downloaded (Git clone or ZIP)
- [ ] Project structure verified (schema/, src/, config/ exist)
- [ ] PostgreSQL 16 installed
- [ ] PostgreSQL service running
- [ ] Database `tcsi_db` created
- [ ] All 27 tables created successfully
- [ ] Indexes created (08_indexes.sql executed)
- [ ] `.Renviron` file configured with credentials
- [ ] R/RStudio restarted after .Renviron creation
- [ ] Environment variables verified (Sys.getenv() returns values)
- [ ] R packages installed (DBI, RPostgres, dplyr, readr, writexl)
- [ ] Database connection test successful (Test 3)
- [ ] ETL configuration updated (Step 6)

### 🆕 Data Import (Steps 7-9)
- [ ] Sample data files verified in `data/tcsiSample/`
- [ ] CSV file naming checked (matches patterns)
- [ ] ETL executed successfully (`main()` completed)
- [ ] All tables loaded (no failures)
- [ ] Row counts verified (data exists in tables)
- [ ] ETL logs reviewed (no critical errors)
- [ ] Error logs checked (data/errors/ directory)
- [ ] Data quality validated (queries return expected results)
- [ ] Foreign keys verified (no orphaned records)
- [ ] Backup strategy implemented

