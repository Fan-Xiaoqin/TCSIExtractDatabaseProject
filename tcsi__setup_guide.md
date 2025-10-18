# TCSI Database Complete Setup Guide

> **Version:** 1.3.0  
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
   - [R Package Installation](#step-3-r-package-installation)
   - [Database Schema Setup](#step-4-database-schema-setup)
   - [Shiny App Configuration](#step-5-shiny-app-configuration)
5. [Testing & Verification](#testing-verification)
6. [Database Structure](#database-structure)
7. [Using the Shiny Application](#using-shiny-app)
8. [Maintenance & Monitoring](#maintenance)
9. [Troubleshooting](#troubleshooting)
10. [Security Best Practices](#security)
11. [Additional Resources](#resources)

---

## 🎯 Overview

This guide provides complete instructions for setting up the PostgreSQL database infrastructure for the TCSI ETL project. The database stores and manages student data extracted from TCSI (Tertiary Collection of Student Information) with comprehensive features including:

- ✅ **26 interconnected tables** covering student lifecycle data
- ✅ **Wide table views** for simplified analytical queries and KPI reporting
- ✅ **Database triggers** for data integrity and version control
- ✅ **Role-based access control** setup guidance for security
- ✅ **Historical data preservation** with SCD-2 (Slowly Changing Dimensions)
- ✅ **Shiny application** for easy database management and querying
- ✅ **Automated ETL pipeline** with validation and logging
- ✅ **Data quality controls** and referential integrity

### Database Overview
- **Database Name:** `tcsi_db`
- **RDBMS:** PostgreSQL 16
- **Total Tables:** 26 tables
- **Data Categories:** Students, Courses, Admissions, Financial, Awards, Units
- **New Features:** Wide table views, triggers for data consistency, role-based permissions

---

## 📋 Prerequisites

Before starting, ensure you have:

### Software Requirements
- ✅ **Operating System:** macOS, Windows, or Linux
- ✅ **Git:** For cloning the repository ([Download](https://git-scm.com/downloads))
- ✅ **R:** Version 4.4 or higher ([Download](https://cloud.r-project.org/))
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

**⚠️ DO THIS FIRST before any other setup steps!**

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
# You should see: config/, schema/, src/, data/, docs/, etc.
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
│   ├── database_config.R
│   └── field_mappings.R
├── data/                   # Data directory
│   ├── tcsiSample/        # Sample CSV files
│   ├── logs/              # ETL logs
│   └── errors/            # Error reports
├── docs/                   # Documentation
│   ├── db/                # Database docs
│   ├── etl/               # ETL docs
│   └── shiny_app/         # Shiny app docs
├── schema/                 # Database schema SQL files
│   ├── init.sql
│   ├── 01_students.sql
│   ├── ...
│   ├── 08_indexes.sql
│   ├── create_views.sql   # Wide table views
│   ├── create_triggers.sql # Data integrity triggers
│   └── roles_permissions.sql # RBAC setup
├── src/                    # Source code
│   ├── app.R              # Shiny application
│   ├── utils/             # Utility functions
│   └── main_etl_all_tables.R
├── install_packages.R      # Package installer
└── README.md
```

**Note on Project Structure:** Currently, there is no `R/` directory inside the tcsi-etl-project folder. The R scripts and utilities are organized within the `src/` directory. This structure may be adjusted in future updates as the project evolves.

### Set Your Working Directory

**For RStudio users:**
```r
# Open RStudio
# File → Open Project → Navigate to TCSIExtractDatabaseProject/tcsi-etl-project
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

# 3. Create schema (all 26 tables, views, triggers)
psql -d tcsi_db -f schema/init.sql

# 4. Install R packages
R -e "source('install_packages.R')"

# 5. Launch Shiny app for configuration and ETL
R -e "shiny::runApp('src/app.R')"

# 6. In the Shiny app:
# - Configure tab: Set up database connection (credentials will be prompted)
# - ETL Process tab: Run data import
# - Query Data tab: Access your data and wide table views
```

For detailed step-by-step instructions, continue to the next section.

---

## 🔧 Detailed Setup Instructions

### Step 1: PostgreSQL Installation

#### Option A: macOS (Homebrew) ⭐ Recommended

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
- Create a strong password for the `postgres` superuser (you'll need this later)

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

### Step 3: R Package Installation

#### 3.1 Required Packages

The project requires the following R packages:
- **DBI** - Database interface
- **RPostgres** - PostgreSQL driver for R
- **dplyr** - Data manipulation
- **readr** - CSV reading
- **writexl** - Excel export
- **shiny**, **shinydashboard**, **shinyFiles** - Shiny application
- **DT** - Interactive tables
- **lubridate** - Date handling
- **getPass** - Secure credential input

#### 3.2 Installation Methods

**Option A: Automated Installation (Recommended)**

Navigate to the project directory and run:
```r
source("install_packages.R")
```

**Option B: Manual Installation**

In R console:
```r
# Install required packages
packages <- c("DBI", "RPostgres", "dplyr", "readr", "writexl", 
              "shiny", "shinydashboard", "shinyFiles", "DT", 
              "lubridate", "getPass")
              
install.packages(packages, repos = "https://cloud.r-project.org/")

# Verify installation
library(DBI)
library(RPostgres)
library(shiny)
```

#### 3.3 Verify Package Installation

```r
# Check if packages are installed
packages <- c("DBI", "RPostgres", "dplyr", "readr", "writexl", 
              "shiny", "shinydashboard", "DT")
installed <- packages %in% rownames(installed.packages())
all(installed)  # Should return TRUE
```

---

### Step 4: Database Schema Setup

The database schema consists of **26 tables** organized into 8 SQL files, plus additional views, triggers, and role-based access control scripts.

#### 4.1 Schema File Structure

```
schema/
├── init.sql                      # Master loader script
├── 01_students.sql               # Student master tables (6 tables)
├── 02_courses.sql                # Course reference tables (4 tables)
├── 03_course_admissions.sql      # Admissions tables (5 tables)
├── 04_loans.sql                  # Financial aid tables (4 tables)
├── 05_awards.sql                 # Awards and outcomes (2 tables)
├── 06_campuses.sql               # Campus tables (4 tables)
├── 07_unit_enrolments.sql        # Unit enrolment tables (1 table)
├── 08_indexes.sql                # Performance indexes
├── create_views.sql              # Wide table analytical views
├── create_triggers.sql           # Data integrity triggers
└── roles_permissions.sql         # Role-based access control (optional)
```

#### 4.2 Create All Tables (Recommended Method)

**Navigate to project directory:**
```bash
# Replace with your actual project path
cd /path/to/tcsi-etl-project

# Examples:
# Windows (Git Bash): cd /c/Users/YourName/Documents/tcsi-etl-project
# macOS:   cd ~/Documents/TCSIExtractDatabaseProject/tcsi-etl-project
# Linux:   cd ~/projects/TCSIExtractDatabaseProject/tcsi-etl-project
```

**Execute master script:**
```bash
# This will create all 26 tables, indexes, views, and triggers
psql -d tcsi_db -f schema/init.sql
```

**Expected Output:**
```
CREATE TABLE
CREATE TABLE
... (26 times for tables)
CREATE INDEX
CREATE INDEX
... (for all indexes)
CREATE VIEW
CREATE VIEW
... (for wide table views)
CREATE TRIGGER
CREATE TRIGGER
... (for data integrity triggers)
```

#### 4.3 Create Tables Individually (Alternative)

If you prefer step-by-step creation:

```bash
cd tcsi-etl-project

# Create each table group
psql -d tcsi_db -f schema/01_students.sql
psql -d tcsi_db -f schema/02_courses.sql
psql -d tcsi_db -f schema/03_course_admissions.sql
psql -d tcsi_db -f schema/04_loans.sql
psql -d tcsi_db -f schema/05_awards.sql
psql -d tcsi_db -f schema/06_campuses.sql
psql -d tcsi_db -f schema/07_unit_enrolments.sql

# Create indexes
psql -d tcsi_db -f schema/08_indexes.sql

# Create views (wide tables for analytics)
psql -d tcsi_db -f schema/create_views.sql

# Create triggers (data integrity)
psql -d tcsi_db -f schema/create_triggers.sql
```

#### 4.4 Verify Schema Creation

**Check table count:**
```bash
psql -d tcsi_db -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE';"
```
Expected: 26 tables

**List all tables:**
```bash
psql -d tcsi_db -c "\dt"
```

**List all views:**
```bash
psql -d tcsi_db -c "\dv"
```

**List all triggers:**
```bash
psql -d tcsi_db -c "SELECT trigger_name, event_object_table FROM information_schema.triggers WHERE trigger_schema = 'public';"
```

**Describe a specific table:**
```bash
psql -d tcsi_db -c "\d hep_students"
```

#### 4.5 Optional: Setup Role-Based Access Control

For enhanced security, you can set up role-based access:

```bash
# Create roles and permissions
psql -d tcsi_db -f schema/roles_permissions.sql

# Create users (optional - see roles_and_permissions_setup_doc.md)
psql -d tcsi_db -f schema/create_users.sql
```

Refer to [`docs/db/roles_and_permissions_setup_doc.md`](docs/db/roles_and_permissions_setup_doc.md) for detailed instructions.

---

### Step 5: Shiny App Configuration

**Important Note:** Unlike earlier versions, this implementation **does not use .Renviron** for storing database credentials. Instead, when you run the Shiny application or ETL scripts, you will be **prompted to enter your database username and password at runtime** if not using the Shiny app's configuration interface.

The `config/database_config.R` file has been updated to support runtime credential prompting using the `getPass` package for secure password entry.

#### 5.1 Launch the Shiny Application

The Shiny app provides the easiest way to configure database connections and run ETL processes.

**Option 1: Run from RStudio (Recommended)**
```r
# Open RStudio and set working directory
setwd("~/Documents/TCSIExtractDatabaseProject/tcsi-etl-project")

# Open src/app.R and click "Run App" button
# Or run from console:
shiny::runApp("src/app.R")
```

**Option 2: Run from Terminal/Command Line**
```bash
# Navigate to project directory
cd ~/Documents/TCSIExtractDatabaseProject/tcsi-etl-project

# Run Shiny app
Rscript -e "shiny::runApp('src/app.R')"
```

**Option 3: RStudio One-Click (Easiest)**
```r
# Open src/app.R in RStudio
# Click "Run App" button at top-right
# Or use keyboard shortcut: Cmd/Ctrl + Shift + Enter
```

#### 5.2 Configure Database Connection in the App

Once the Shiny app is running:

1. **Go to the Configuration tab**
2. **Database Configuration section:**
   - Select "POSTGRESQL" as Database Mode
   - Enter Host (e.g., `localhost`)
   - Enter Port (default: `5432`)
   - Enter Database Name (e.g., `tcsi_db`)
   - Enter Username (e.g., `postgres` or your system username)
   - Enter Password (leave empty for local trust authentication on macOS/Linux, or enter your password on Windows)
   - Click **Test Connection** to verify connectivity

3. **File Configuration section:**
   - Click **Select Data Input Folder** and browse to your CSV files folder (e.g., `data/tcsiSample`)
   - Adjust Batch Size if needed (default: 1000)
   - Leave Max Rows blank to process all data
   - Optionally check "Stop on Error" if you want to halt on first error

4. **Logging Configuration section:**
   - Set Log Level (default: INFO)
   - Check/uncheck console and file logging options

5. **Click Save Configuration**

The configuration is saved to `config/database_config_runtime.R` and will persist for future runs.

**Shiny App Features:**
- ✅ Database connection testing with real-time feedback
- ✅ Visual configuration file generation
- ✅ ETL process monitoring with progress bars
- ✅ Real-time log viewing
- ✅ Query builder for accessing data and wide table views
- ✅ Download results as CSV or Excel
- ✅ Error reporting and diagnostics

**Access the app:**
Once running, the app opens automatically in your browser at `http://127.0.0.1:XXXX`

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
                                                 version
----------------------------------------------------------------------------------------------------------
 PostgreSQL 16.x on x86_64-apple-darwin, compiled by Apple clang version...
```

### Test 3: Verify Tables, Views, and Triggers

```bash
# Count tables
psql -d tcsi_db -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE';"
# Expected: 26

# List all views
psql -d tcsi_db -c "\dv"
# Should show wide table views

# List all triggers
psql -d tcsi_db -c "SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_schema = 'public';"
# Should show multiple triggers
```

### Test 4: Test Shiny App Connection

1. Launch the Shiny app (see Step 5.1)
2. Go to Configuration tab
3. Enter database credentials
4. Click "Test Connection"
5. Expected: "Connection successful!" message

---

## 🗄️ Database Structure

### Table Categories and Count

| Category | Tables | Description |
|----------|--------|-------------|
| **Students** | 6 | Master student records, citizenships, disabilities, addresses, scholarships |
| **Courses** | 4 | Course programs, special interest courses, education fields |
| **Admissions** | 5 | Course admissions, basis for admission, prior education |
| **Financial** | 4 | Loans, FEE-HELP, VET Student Loans, OS-HELP |
| **Awards** | 2 | Completions, awards conferred |
| **Campuses** | 4 | E494 campuses, course locations, unit locations |
| **Units** | 1 | Unit of study enrolments |
| **Total** | **26** | All interconnected tables |

### New Database Features

#### Wide Table Views
The database now includes consolidated views that combine data from multiple tables for easier analytical queries:
- Student overview with demographics and citizenship
- Course enrollment summary with outcomes
- Financial aid consolidated view
- KPI reporting views

Access these views through the Shiny app's Query Data tab.

#### Database Triggers
Automatic triggers maintain data integrity:
- `is_current` flag management for historical records
- Referential integrity checks
- Audit logging
- Version control for slowly changing dimensions

#### Role-Based Access Control
Optional security scripts for managing user permissions:
- Read-only role for analysts
- Data entry role for staff
- Admin role for database management

See `docs/db/roles_and_permissions_setup_doc.md` for setup instructions.

---

## 📱 Using the Shiny Application

### Launch and Navigate

The Shiny application provides four main tabs:

#### 1. Configure Tab
- Set database mode (POSTGRESQL or DUMMY)
- Configure database connection
- Test connectivity
- Select data input folder
- Adjust ETL settings
- Configure logging

#### 2. ETL Process Tab
- Start ETL execution
- Monitor live log output
- View progress with value boxes:
  - Tables processed
  - Tables succeeded
  - Tables failed
  - Total rows loaded
- Stop ETL if needed

#### 3. Results Tab
After ETL completion, view:
- Overall statistics
- Phase summary
- Detailed table results
- Error summary (if any)

#### 4. Query Data Tab
Build and execute SQL queries:
- Select table name (includes wide table views!)
- Choose columns
- Add WHERE conditions (up to 10)
- Add GROUP BY clause
- Add ORDER BY clause
- Set LIMIT
- Preview SQL query
- Execute query
- View results in interactive table
- Download as CSV or Excel

**Accessing Wide Table Views:**
In the Query Data tab, simply select a wide table view from the table name dropdown. These views provide pre-joined data from multiple tables for easier analysis and reporting.

### Best Practices
1. Always test database connection before running ETL
2. Start with small batch sizes for testing
3. Review logs regularly for warnings
4. Use wide table views for reporting queries
5. Download query results for offline analysis

---

## 🔧 Maintenance & Monitoring

### Regular Maintenance Tasks

**Weekly:**
```bash
# Vacuum and analyze for performance
psql -d tcsi_db -c "VACUUM ANALYZE;"
```

**Monthly:**
```bash
# Full database backup
pg_dump tcsi_db > tcsi_db_backup_$(date +%Y%m%d).sql

# Check database size
psql -d tcsi_db -c "SELECT pg_size_pretty(pg_database_size('tcsi_db'));"

# Check table sizes
psql -d tcsi_db -c "
  SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
  FROM pg_tables
  WHERE schemaname = 'public'
  ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC
  LIMIT 10;
"
```

### Performance Monitoring

**Check slow queries:**
```bash
# Enable query logging in postgresql.conf
log_min_duration_statement = 1000  # Log queries taking > 1 second

# View slow queries
tail -f /path/to/postgresql/log/postgresql-*.log | grep "duration:"
```

**Check index usage:**
```bash
psql -d tcsi_db -c "
  SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read
  FROM pg_stat_user_indexes
  ORDER BY idx_scan DESC;
"
```

---

## 🔍 Troubleshooting

### Issue 0: Cannot Find Required Files

**Symptom:**
```
Error: cannot open file 'schema/init.sql': No such file or directory
```

**Solution:**
1. **Ensure you're in the correct directory:**
   ```r
   getwd()  # Check current directory
   # Should be: .../TCSIExtractDatabaseProject/tcsi-etl-project
   ```

2. **Navigate to correct directory:**
   ```bash
   cd ~/Documents/TCSIExtractDatabaseProject/tcsi-etl-project
   ```

3. **Verify project structure:**
   ```bash
   ls -la schema/  # Should show init.sql and other SQL files
   ```

### Issue 1: Cannot Connect to PostgreSQL

**Symptom:**
```
psql: error: connection to server on socket...failed
```

**Solutions:**

1. **Check if service is running:**
   ```bash
   # macOS
   brew services info postgresql@16
   
   # If not running:
   brew services start postgresql@16
   ```

2. **Check PostgreSQL logs:**
   ```bash
   tail -f /opt/homebrew/var/log/postgresql@16.log
   ```

3. **Verify port 5432 is not in use:**
   ```bash
   lsof -i :5432
   ```

### Issue 2: R Cannot Find RPostgres Package

**Symptom:**
```r
Error: package 'RPostgres' is not installed
```

**Solution:**
```r
install.packages("RPostgres", repos = "https://cloud.r-project.org/")
library(RPostgres)
```

### Issue 3: Credential Prompt Issues

**Symptom:**
- Not prompted for credentials when expected
- Cannot enter password securely

**Solutions:**

1. **Install getPass package:**
   ```r
   install.packages("getPass")
   ```

2. **Use Shiny app for credential management:**
   - Launch Shiny app
   - Use Configuration tab to set credentials
   - Save configuration

3. **Manual credential entry (if needed):**
   ```r
   # When prompted, enter credentials
   # Username: postgres (or your username)
   # Password: (will not show characters while typing)
   ```

### Issue 4: Permission Denied Errors

**Symptom:**
```
ERROR: permission denied for table hep_students
```

**Solution:**
```bash
# Grant permissions
psql -d tcsi_db -c "
  GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
  GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres;
  GRANT ALL PRIVILEGES ON ALL VIEWS IN SCHEMA public TO postgres;
"
```

### Issue 5: Table Count Mismatch

**Symptom:**
```
Expected: 26 tables
Found: 27 tables (or different number)
```

**Solution:**

This is **not an error**. Earlier documentation mentioned 27 tables, but the correct count is **26 tables**. If you see 26 tables, your setup is correct!

To verify:
```bash
psql -d tcsi_db -c "
  SELECT COUNT(*) 
  FROM information_schema.tables 
  WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
"
```

Expected output: 26

### Issue 6: Shiny App Won't Launch

**Symptom:**
```r
Error in runApp: app.R not found
```

**Solutions:**

1. **Check working directory:**
   ```r
   getwd()
   # Should end with: /tcsi-etl-project
   ```

2. **Set correct directory:**
   ```r
   setwd("~/Documents/TCSIExtractDatabaseProject/tcsi-etl-project")
   ```

3. **Launch with full path:**
   ```r
   shiny::runApp("src/app.R")
   ```

### Issue 7: Wide Table Views Not Showing

**Symptom:**
- Cannot find wide table views in Query Data tab
- Views not listed in `\dv` command

**Solution:**

1. **Ensure views were created:**
   ```bash
   psql -d tcsi_db -c "\dv"
   ```

2. **If missing, create views:**
   ```bash
   psql -d tcsi_db -f schema/create_views.sql
   ```

3. **Refresh Shiny app:**
   - Stop and restart the app
   - Views should now appear in table dropdown

---

## 🔐 Security Best Practices

### 1. Credential Management

**Current Implementation:**
- ✅ Runtime prompting for credentials (no hardcoded passwords)
- ✅ Secure password entry with `getPass` package
- ✅ Configuration saved in `database_config_runtime.R`

**For Production Environments:**

```bash
# Set strong password
psql -d tcsi_db -c "ALTER USER postgres WITH PASSWORD 'YourStrongPassword123!';"
```

### 2. .gitignore Configuration

**Ensure your `.gitignore` includes:**
```gitignore
# Environment files
.Renviron
.env

# Runtime configuration with credentials
**/database_config_runtime.R

# Data files
data/tcsiSample/*.csv
data/logs/*.log
data/errors/*.csv

# RStudio project files
.Rproj.user/
.Rhistory
.RData
```

**Verify before committing:**
```bash
# Check what files will be committed
git status

# If sensitive files appear, add to .gitignore immediately
echo "config/database_config_runtime.R" >> .gitignore
git add .gitignore
git commit -m "Add runtime config to gitignore"
```

### 3. Restrict Network Access

Edit `pg_hba.conf`:
```bash
# Find config file
psql -d tcsi_db -c "SHOW hba_file;"

# Edit with text editor
# Change: host all all 0.0.0.0/0 md5
# To:     host all all 127.0.0.1/32 md5  # Local only
```

### 4. Use SSL Connections (Recommended for Remote Access)

```r
# Add ssl parameter
con <- dbConnect(
  RPostgres::Postgres(),
  host = "hostname",
  sslmode = "require"
)
```

### 5. Role-Based Access Control

Create read-only users for analysts:
```sql
CREATE USER analyst WITH PASSWORD 'password';
GRANT CONNECT ON DATABASE tcsi_db TO analyst;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst;
GRANT SELECT ON ALL VIEWS IN SCHEMA public TO analyst;
```

See `docs/db/roles_and_permissions_setup_doc.md` for complete RBAC setup.

### 6. Regular Backups

Implement automated backups:
```bash
# Create backup script
cat > ~/backup_tcsi.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="$HOME/tcsi_backups"
mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
pg_dump tcsi_db | gzip > "$BACKUP_DIR/tcsi_db_$TIMESTAMP.sql.gz"
# Keep only last 7 days of backups
find "$BACKUP_DIR" -name "tcsi_db_*.sql.gz" -mtime +7 -delete
EOF

chmod +x ~/backup_tcsi.sh

# Schedule with cron (daily at 2 AM)
crontab -e
# Add: 0 2 * * * /Users/yourname/backup_tcsi.sh
```

### 7. Audit Logging

Enable PostgreSQL logging:
```bash
# Edit postgresql.conf
logging_collector = on
log_destination = 'csvlog'
log_statement = 'all'
log_connections = on
log_disconnections = on
```

---

## 📚 Additional Resources

### Official Documentation
- [PostgreSQL 16 Documentation](https://www.postgresql.org/docs/16/)
- [RPostgres Package](https://rpostgres.r-dbi.org/)
- [DBI Package](https://dbi.r-dbi.org/)
- [Shiny Documentation](https://shiny.posit.co/)

### TCSI Resources
- [TCSI Support Portal](https://www.tcsisupport.gov.au/)
- TCSI Data Extract Specifications

### Project Documentation
- `docs/etl/etl_process_doc.md` - ETL workflow documentation
- `docs/etl/etl_tech_doc.md` - Technical documentation
- `docs/shiny_app/shiny_app_doc.md` - Shiny app user guide
- `docs/db/db_data_dictionary_doc.md` - Data dictionary
- `docs/db/consolidated_view_doc.md` - Wide table views documentation
- `docs/db/triggers_doc.md` - Database triggers documentation
- `docs/db/roles_and_permissions_setup_doc.md` - RBAC setup guide
- `docs/db/tcsi_db_schema_doc.md` - Database schema overview
- `docs/db/indexes_doc.md` - Index documentation
- `docs/erd-stage/` - ERD evolution documentation

### Useful Commands Reference

**PostgreSQL Commands:**
```bash
psql -l                              # List databases
psql -d tcsi_db                      # Connect to database
\dt                                   # List tables
\dv                                   # List views
\d table_name                        # Describe table
\d+ table_name                       # Describe table with details
\di                                   # List indexes
SELECT trigger_name FROM information_schema.triggers;  # List triggers
\q                                    # Quit psql
```

**Service Management:**
```bash
# macOS
brew services start postgresql@16
brew services stop postgresql@16
brew services restart postgresql@16
brew services info postgresql@16

# Linux
sudo systemctl start postgresql
sudo systemctl stop postgresql
sudo systemctl restart postgresql
sudo systemctl status postgresql

# Windows
# Use Services app or:
net start postgresql-x64-16
net stop postgresql-x64-16
```

---

## 📞 Getting Help


### Project Support
- Review project documentation in `docs/` folder
- Check `README.md` for project overview
- Examine `docs/db/tcsi_db_schema_doc.md` for schema details
- Review `docs/shiny_app/shiny_app_doc.md` for app usage

### External Resources
- [PostgreSQL Community Support](https://www.postgresql.org/support/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/postgresql)
- [R Community](https://community.rstudio.com/)
- [Shiny Community](https://community.rstudio.com/c/shiny/8)

---

## ✅ Setup Checklist

Use this checklist to verify your setup is complete:

- [ ] **Project code downloaded** (Git clone or ZIP download)
- [ ] **Project structure verified** (schema/, src/, config/ folders exist)
- [ ] PostgreSQL 16 installed
- [ ] PostgreSQL service running
- [ ] Database `tcsi_db` created
- [ ] **All 26 tables created successfully**
- [ ] Indexes created (08_indexes.sql executed)
- [ ] **Wide table views created** (create_views.sql executed)
- [ ] **Triggers created** (create_triggers.sql executed)
- [ ] R packages installed (DBI, RPostgres, shiny, etc.)
- [ ] **Shiny app launches successfully**
- [ ] Database connection test successful (via Shiny app)
- [ ] ETL configuration saved (via Shiny app)
- [ ] Sample data load test completed (optional)
- [ ] **Can query wide table views** (via Shiny app)
- [ ] Backup strategy implemented (optional)
- [ ] **Role-based access configured** (optional)

---

