# TCSI Database Complete Setup Guide


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

**⚠️ DO THIS FIRST before any other setup steps!**

### Option 1: Clone with Git (Recommended)

```bash
# Navigate to where you want to store the project
cd ~/Documents  # or your preferred location

# Clone the repository
git clone https://github.com/YOUR_ORG/TCSIExtractDatabaseProject.git

# Navigate into the project
cd TCSIExtractDatabaseProject

# Verify the structure
ls -la
# You should see: tcsi-etl-project/, docs/, README.md, etc.
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
   cd ~/Documents/TCSIExtractDatabaseProject
   
   # Windows (PowerShell)
   cd $HOME\Downloads
   Expand-Archive TCSIExtractDatabaseProject-main.zip -DestinationPath $HOME\Documents
   cd $HOME\Documents\TCSIExtractDatabaseProject
   ```

### Verify Project Structure

After downloading, verify you have the correct structure:

```bash
# List project contents
ls -la

# Expected structure:
TCSIExtractDatabaseProject/
├── tcsi-etl-project/           # Main ETL project
│   ├── config/                 # Configuration files
│   ├── data/                   # Data directory
│   ├── docs/                   # Documentation
│   ├── schema/  (or db/schema/) # Database schema SQL files
│   ├── src/                    # Source code
│   ├── install_packages.R      # Package installer
│   └── README.md
├── docs/                       # Additional docs
├── mapping/                    # Field mappings
└── README.md                   # Project README
```

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

# 3. Create schema
psql -d tcsi_db -f schema/init.sql
# OR if schema is in db/ folder:
# psql -d tcsi_db -f db/schema/init.sql

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
# Then test connection:
R -e "
library(DBI); 
library(RPostgres); 
con <- dbConnect(RPostgres::Postgres(), 
                 dbname='tcsi_db', 
                 host='localhost'); 
dbGetQuery(con, 'SELECT version();'); 
dbDisconnect(con)
"
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

#### Understanding .Renviron
- Hidden file that stores environment variables for R
- Loaded automatically when R starts
- Keeps credentials out of code (security best practice)
- Works across all operating systems

#### 3.1 Create .Renviron File

**macOS/Linux:**
```bash
# Navigate to home directory
cd ~

# Create/edit .Renviron file
nano .Renviron
```

**Windows:**
```powershell
# Navigate to Documents folder
cd $HOME\Documents

# Create .Renviron using Notepad
notepad .Renviron
```

#### 3.2 Add Database Credentials

Add the following content to `.Renviron`:

```bash
# TCSI Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=tcsi_db
DB_USER=postgres                    # For Windows, or your username for Mac/Linux
DB_PASSWORD=                        # Empty for Mac/Linux local, or your password for Windows
```

**Important Notes:**
- For **macOS/Linux**: Leave `DB_PASSWORD` empty if using local trust authentication
- For **Windows**: Set `DB_PASSWORD` to the password you created during PostgreSQL installation
- Replace `postgres` with your actual database username if different

#### 3.3 Save and Apply

**macOS/Linux (nano editor):**
- Press `Ctrl+O` to save
- Press `Enter` to confirm
- Press `Ctrl+X` to exit

**Windows (Notepad):**
- Save as: `.Renviron` (ensure **no .txt extension**)
- File type: "All Files (*.*)"
- Location: `C:\Users\<YourUsername>\Documents\`

---

⚠️ **IMPORTANT: Restart Required!**

After creating or modifying `.Renviron`, you **MUST restart R or RStudio**:

| Method | How to Restart |
|--------|----------------|
| **RStudio** | `Session → Restart R` or `Cmd/Ctrl + Shift + 0/F10` |
| **Terminal R** | Type `q()` to quit, then `R` to restart |
| **Manual Load** | `readRenviron("~/.Renviron")` (temporary, current session only) |

**Why?** R only reads `.Renviron` at startup. Changes won't take effect until you restart.

---

**Restart R/RStudio** for changes to take effect.

⚠️ **CRITICAL:** `.Renviron` is only loaded when R starts. If you already have R or RStudio open, you MUST restart it:

**RStudio:**
- Menu: `Session → Restart R`
- Keyboard: `Cmd + Shift + 0` (Mac) or `Ctrl + Shift + F10` (Windows)

**Terminal R:**
```r
q()  # Quit R
R    # Restart R
```

**Alternative (temporary, not recommended):**
```r
# Manually reload .Renviron (only works for current session)
readRenviron("~/.Renviron")
```

#### 3.4 Verify Configuration

Open R or RStudio and run:
```r
Sys.getenv("DB_HOST")
Sys.getenv("DB_NAME")
# Should print: "localhost" and "tcsi_db"
```

**🔧 Troubleshooting: If you see empty strings `""`**

This is the **#1 most common issue**. If `Sys.getenv("DB_HOST")` returns `""`, it means:

**Problem:** R hasn't loaded the `.Renviron` file

**Solutions (in order of likelihood):**

1. **You didn't restart R/RStudio** (Most common!)
   ```r
   # In RStudio: Session → Restart R (Cmd/Ctrl + Shift + 0)
   # In Terminal: q() then R
   ```

2. **File is in the wrong location**
   ```r
   # Check where R expects it
   Sys.getenv("HOME")  
   path.expand("~/.Renviron")  # Verify path
   
   # Check if file exists
   file.exists("~/.Renviron")  # Should be TRUE
   ```

3. **File has wrong format**
   ```bash
   # Verify in terminal
   cat ~/.Renviron
   
   # Should show your variables WITHOUT quotes around values
   # Correct:   DB_HOST=localhost
   # Wrong:     DB_HOST="localhost"
   ```

4. **Manual load as last resort**
   ```r
   # Force reload (only for current session)
   readRenviron("~/.Renviron")
   Sys.getenv("DB_HOST")  # Test again
   ```

**Complete verification script:**

```r
# Run this after restarting R
cat("=== Environment Variable Check ===\n")
vars <- c("DB_HOST", "DB_PORT", "DB_NAME", "DB_USER", "DB_PASSWORD")
for (var in vars) {
  value <- Sys.getenv(var)
  status <- if (value != "" || var == "DB_PASSWORD") "✅" else "❌"
  cat(sprintf("%s %-15s: '%s'\n", status, var, value))
}

# Final check
all_set <- all(Sys.getenv("DB_HOST") != "", 
               Sys.getenv("DB_PORT") != "",
               Sys.getenv("DB_NAME") != "", 
               Sys.getenv("DB_USER") != "")

if (all_set) {
  cat("\n✅ SUCCESS: All environment variables loaded!\n")
} else {
  cat("\n❌ FAILED: Some variables missing. Did you restart R?\n")
}
```

Expected output after restart:
```
=== Environment Variable Check ===
✅ DB_HOST        : 'localhost'
✅ DB_PORT        : '5432'
✅ DB_NAME        : 'tcsi_db'
✅ DB_USER        : 'your_username'
✅ DB_PASSWORD    : ''

✅ SUCCESS: All environment variables loaded!
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
...
CREATE INDEX
CREATE INDEX
```

#### 5.3 Create Tables Individually (Alternative)

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
psql -d tcsi_db -f schema/08_indexes.sql
```

#### 5.4 Verify Schema Creation

**Check table count:**
```bash
psql -d tcsi_db -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';"
```
Expected: 27 tables

**List all tables:**
```bash
psql -d tcsi_db -c "\dt"
```

**Describe a specific table:**
```bash
psql -d tcsi_db -c "\d hep_students"
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
  host = Sys.getenv("DB_HOST"),        # From .Renviron
  port = as.integer(Sys.getenv("DB_PORT")),
  dbname = Sys.getenv("DB_NAME"),
  user = Sys.getenv("DB_USER"),        # From .Renviron
  password = Sys.getenv("DB_PASSWORD") # From .Renviron
)

# ETL Processing Settings
BATCH_SIZE <- 1000
MAX_ROWS_TO_PROCESS <- NULL       # NULL = process all rows
STOP_ON_ERROR <- FALSE            # Continue on errors

# File Paths
PROJECT_ROOT <- getwd()
DATA_INPUT_DIR <- file.path(PROJECT_ROOT, "data", "tcsiSample")
DATA_LOGS_DIR <- file.path(PROJECT_ROOT, "data", "logs")
```

⚠️ **Security Warning:** Never hardcode database credentials in configuration files. Always use environment variables through `.Renviron`.

#### 6.2 Alternative: Use Shiny Configuration App

The project includes a graphical configuration tool for easy database setup.

**Option 1: Run from Terminal/Command Line**
```bash
# Navigate to src directory
cd /path/to/tcsi-etl-project/src

# Platform-specific examples:
# Windows (Git Bash): cd /c/Users/YourName/Documents/tcsi-etl-project/src
# macOS:   cd ~/Documents/tcsi-etl-project/src
# Linux:   cd ~/projects/tcsi-etl-project/src

# Run Shiny app
Rscript -e "shiny::runApp('app.R')"
```

**Option 2: Run from R/RStudio (Recommended)**
```r
# Set working directory to src folder
setwd("C:/Users/YourName/Documents/tcsi-etl-project/src")  # Windows
# OR
setwd("~/Documents/tcsi-etl-project/src")  # macOS/Linux

# Run app
library(shiny)
runApp("app.R")
```

**Option 3: RStudio One-Click (Easiest)**
```r
# Open app.R in RStudio, then click "Run App" button at top-right
# Or use keyboard shortcut: Cmd/Ctrl + Shift + Enter
```

**Shiny App Features:**
- ✅ Database connection testing with real-time feedback
- ✅ Visual configuration file generation
- ✅ ETL process monitoring with progress bars
- ✅ Real-time log viewing
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

### Test 3: R Database Connection

**Use the project's existing connection script** (no need to create new files):

```r
# 1. Load the project's database connection script
source("R/connect_db.R")

# 2. Test connection
cat("Testing database connection...\n")
db_conn <- create_db_connection()
# Expected: "Database connection successful!"

# 3. Test query using the helper function
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
  cat("✅ Found", nrow(tables), "tables\n")
  print(head(tables, 10))
} else {
  cat("⚠️ No tables found. You need to create the schema (Step 5)\n")
}

# 5. Clean up
dbDisconnect(db_conn)
cat("\n✅ Connection test complete!\n")
```

**Alternative: Use the ETL utilities**

```r
# Load ETL configuration and utilities
source("config/database_config.R")
source("src/utils/logging_utils.R")
source("src/utils/database_utils.R")

# Connect using ETL functions
conn <- db_connect()

if (!is.null(conn)) {
  # Test query
  version <- dbGetQuery(conn, "SELECT version();")
  print(version)
  
  # Disconnect
  db_disconnect(conn)
}
```

**📁 Project Files Reference:**
- `R/connect_db.R` - Main connection script with helper functions
- `src/utils/database_utils.R` - ETL database utilities
- `reports/connect_db_doc.Rmd` - Complete connection documentation

### Test 4: Sample Data Load

Test ETL with a small dataset:

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

# Run test ETL for one table
source("test_etl.R")
```

---

## 🗄️ Database Structure

### Table Categories and Count

| Category | Tables | Description |
|----------|--------|-------------|
| **Students** | 6 | Master student records, citizenships, disabilities, addresses, scholarships |
| **Courses** | 4 | Course programs, special interest courses, education fields |
| **Admissions** | 5 | Course admissions, prior credits, specializations, HDR engagement |
| **Financial** | 4 | OS-HELP, SA-HELP loans, RTP scholarships and stipends |
| **Campus** | 4 | Campus master data, course-campus relationships, fees, TAC |
| **Awards** | 2 | Aggregated awards, exit awards |
| **Units** | 2 | Unit enrolments, AOU (Academic Organisational Unit) details |
| **Total** | **27** | Complete TCSI data model |

### Key Tables Overview

#### Student Tables
```sql
hep_students                              -- Master student records
hep_student_citizenships                  -- Student citizenship data
hep_student_disabilities                  -- Disability records
student_contacts_first_reported_address   -- First reported addresses
commonwealth_scholarships                 -- Commonwealth scholarship data
```

#### Course Tables
```sql
courses_of_study              -- Course programs
hep_courses                   -- HEP course details
special_interest_courses      -- Special interest courses
course_fields_of_education    -- Course field mappings
```

#### Admission Tables
```sql
hep_course_admissions          -- Course admission records
hep_basis_for_admission        -- Admission basis data
hep_course_prior_credits       -- Prior credit records
course_specialisations         -- Course specializations
hep_hdr_end_users_engagement   -- HDR end user engagement
```

### Entity Relationship Diagram

```
┌──────────────┐         ┌──────────────────┐         ┌─────────────┐
│              │         │                  │         │             │
│ HEP Students │────────▶│ Course Admission │────────▶│ HEP Courses │
│              │         │                  │         │             │
└──────────────┘         └──────────────────┘         └─────────────┘
       │                          │                           │
       │                          │                           │
       ▼                          ▼                           ▼
┌──────────────┐         ┌──────────────────┐         ┌─────────────┐
│  Citizenship │         │ Unit Enrolments  │         │  Campuses   │
│ Disabilities │         │  SAHELP/OSHELP   │         │             │
└──────────────┘         └──────────────────┘         └─────────────┘
```

---

## 📋 Data Validation Rules

The ETL process includes comprehensive data validation to ensure data quality and integrity.

### Required Fields

Each table has specific required fields that must be present and non-null:

**Student Tables:**
- `hep_students`: `uid8_students_res_key`, `e313_student_identification_code`
- `hep_student_citizenships`: `student_id`, `e358_citizen_resident_code`
- `hep_student_disabilities`: `student_id`, `e423_disability_type_code`

**Course Tables:**
- `courses_of_study`: `e533_course_of_study_code`
- `hep_courses`: `uid5_courses_res_key`, `e307_course_code`

**Admission Tables:**
- `hep_course_admissions`: `uid15_course_admissions_res_key`, `student_id`, `uid5_courses_res_key`

**Unit Enrolment Tables:**
- `unit_enrolments`: `uid16_unit_enrolments_res_key`, `reporting_year`
- `unit_enrolments_aous`: `uid19_unit_enrolment_aous_res_key`, `reporting_year`

### CHECK Constraint Validation

Many fields have restricted value sets enforced by database CHECK constraints:

| Field | Valid Values | Example |
|-------|-------------|---------|
| `e302_gender_code` | `'M'`, `'F'`, `'X'` | Student gender |
| `e348_atsi_code` | `'2'`, `'3'`, `'4'`, `'5'`, `'9'` | Indigenous status |
| `e358_citizen_resident_code` | `'1'`, `'2'`, `'3'`, `'4'`, `'5'`, `'8'`, `'P'` | Citizenship |
| `e329_mode_of_attendance_code` | `'1'` to `'7'` | Study mode |
| `e330_attendance_type_code` | `'1'`, `'2'` | Full/Part time |
| `e355_unit_of_study_status_code` | `'1'` to `'6'` | Unit completion status |
| `e392_maximum_student_contribution_code` | `'7'`, `'8'`, `'9'`, `'S'` | Contribution band |

**Full list of validation constants:**
```r
# Gender codes
VALID_GENDER_CODES <- c('M', 'F', 'X')

# Indigenous status
VALID_ATSI_CODES <- c('2', '3', '4', '5', '9')

# Citizenship/Residency
VALID_CITIZEN_RESIDENT_CODES <- c('1', '2', '3', '4', '5', '8', 'P')

# Disability types
VALID_DISABILITY_CODES <- c('11','12','13','14','15','16','17','18','19','20','99')

# Course outcomes
VALID_COURSE_OUTCOME_CODES <- c('1','2','3','4','5','6','7')

# Study modes
VALID_MODE_OF_ATTENDANCE_CODES <- c('1','2','3','4','5','6','7')

# Attendance types
VALID_ATTENDANCE_TYPE_CODES <- c('1','2')

# Unit status
VALID_UNIT_STUDY_STATUS_CODES <- c('1','2','3','4','5','6')
```

### Data Type Conversions

The ETL process automatically handles these conversions:

**Date Fields:**
- Format: `DD/MM/YYYY` in CSV
- Converted to: PostgreSQL `DATE` type
- NULL handling: String `"NULL"` → actual `NULL`
- Examples: `e489_course_admission_date`, `e592_course_outcome_date`

**Boolean Fields:**
- CSV values: `0` or `1`
- Converted to: PostgreSQL `BOOLEAN`
- Mapping: `0` → `FALSE`, `1` → `TRUE`
- Examples: `a111_is_deleted`, `is_current`

**Integer Fields:**
- Automatically converted from string to integer
- Examples: `reporting_year`, `e415_reporting_year`

**Decimal Fields:**
- Precision maintained for financial and EFTSL values
- Format: `DECIMAL(10,9)` for EFTSL
- Format: `DECIMAL(7,2)` for currency
- Examples: `e339_eftsl`, `e384_amount_charged`

### Foreign Key Validation

All foreign key relationships are validated before insert:

**Primary Relationships:**
```
hep_students (student_id) 
    ← hep_student_citizenships
    ← hep_student_disabilities
    ← hep_course_admissions
    ← commonwealth_scholarships

hep_courses (uid5_courses_res_key)
    ← hep_course_admissions
    ← course_fields_of_education
    ← hep_courses_on_campuses

hep_course_admissions (course_admission_id)
    ← unit_enrolments
    ← hep_basis_for_admission
    ← hep_course_prior_credits
```

**Validation Process:**
1. Check if referenced record exists in parent table
2. If not found, record validation error
3. Option to skip invalid rows or halt ETL (configurable)

### Null Value Handling

**NULL String Conversion:**
- CSV string `"NULL"` → actual database `NULL`
- Applies to all optional fields
- Case-insensitive matching

**Required vs Optional:**
- Required fields: Must have non-null value
- Optional fields: Can be NULL
- Foreign keys: NULL allowed unless explicitly required

### Validation Error Handling

**Error Categories:**
1. **Critical Errors** (Row rejected):
   - Required field is NULL
   - Invalid CHECK constraint value
   - Foreign key not found
   - Data type conversion failure

2. **Warnings** (Row accepted with note):
   - Unusual but valid values
   - Optional field missing
   - Truncated string values

**Error Logging:**
```
data/logs/etl_YYYYMMDD_HHMMSS.log  # Main log
data/errors/table_name_errors.csv  # Invalid rows with errors
```

### Validation Configuration

Configure validation behavior in `config/database_config.R`:

```r
# Stop ETL on first error, or continue and log errors
STOP_ON_ERROR <- FALSE

# Maximum number of errors before halting
MAX_ERRORS_ALLOWED <- 100

# Validation strictness level
VALIDATION_LEVEL <- "STRICT"  # Options: "STRICT", "MODERATE", "LENIENT"
```

---

## 💡 Usage Examples

### Example 1: Connect to Database from R

**Option A: Use the project's connection script (Recommended)**

```r
# Load the project's database connection utilities
source("R/connect_db.R")

# Create connection with built-in error handling
db_conn <- create_db_connection()
# Output: "Database connection successful!"

# Use the connection
result <- dbGetQuery(db_conn, "SELECT COUNT(*) FROM hep_students;")
print(result)

# Disconnect
dbDisconnect(db_conn)
```

**Option B: Use the helper function for quick queries**

```r
source("R/connect_db.R")

# Run query with automatic connection management
result <- run_query("SELECT * FROM hep_students LIMIT 5;")
print(result)
# Connection automatically opens and closes
```

**Option C: Manual connection (if needed)**

```r
library(DBI)
library(RPostgres)

# Create connection manually
con <- dbConnect(
  RPostgres::Postgres(),
  host = Sys.getenv("DB_HOST"),
  port = as.integer(Sys.getenv("DB_PORT")),
  dbname = Sys.getenv("DB_NAME"),
  user = Sys.getenv("DB_USER"),
  password = Sys.getenv("DB_PASSWORD")
)

# Use connection
# ... your queries ...

# Always disconnect
dbDisconnect(con)
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

### Example 3: Join Multiple Tables

```r
# Complex query with joins
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

### Example 5: Run Complete ETL Pipeline

```r
# IMPORTANT: Ensure you're in the project root directory

# Option 1: Use RStudio (Recommended)
# Session → Set Working Directory → To Project Directory

# Option 2: Set manually with platform-specific paths
# Windows:
setwd("C:/Users/YourName/Documents/tcsi-etl-project")

# macOS:
setwd("~/Documents/tcsi-etl-project")

# Linux:
setwd("~/projects/tcsi-etl-project")

# Verify you're in the correct directory
getwd()  # Should show your project root path
list.files()  # Should see: src/, schema/, config/, data/, etc.

# Source main ETL script
source("src/main_etl_all_tables.R")

# Run complete ETL
results <- main()

# View summary
print_overall_summary(results)
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

### Monitor Active Connections

```bash
psql -d tcsi_db -c "
  SELECT 
    datname,
    usename,
    application_name,
    client_addr,
    state,
    query_start
  FROM pg_stat_activity
  WHERE datname = 'tcsi_db';
"
```

### Vacuum and Analyze (Database Optimization)

```bash
# Optimize database performance
psql -d tcsi_db -c "VACUUM ANALYZE;"
```

Run this:
- After large data loads
- Weekly for regular maintenance
- When query performance degrades

### Backup Database

**Full backup:**
```bash
# Create backup
pg_dump tcsi_db > "tcsi_backup_$(date +%Y%m%d).sql"

# Restore from backup
psql tcsi_db < tcsi_backup_20251012.sql
```

**Automated daily backups (macOS/Linux):**
```bash
# Create backup script
cat > ~/backup_tcsi.sh << 'EOF'
#!/bin/bash
BACKUP_DIR=~/tcsi_backups
mkdir -p $BACKUP_DIR
pg_dump tcsi_db | gzip > "$BACKUP_DIR/tcsi_$(date +%Y%m%d_%H%M%S).sql.gz"
# Keep only last 7 days
find $BACKUP_DIR -name "tcsi_*.sql.gz" -mtime +7 -delete
EOF

chmod +x ~/backup_tcsi.sh

# Add to crontab (run daily at 2 AM)
(crontab -l 2>/dev/null; echo "0 2 * * * ~/backup_tcsi.sh") | crontab -
```

---

## 🐛 Troubleshooting

### Issue 0: Environment Variables Not Loading (Most Common!) 🔥

**Symptom:**
```r
Sys.getenv("DB_HOST")  # Returns ""
```

**This is the #1 issue users face!**

**Solutions:**

1. **Restart R/RStudio (99% of cases)**
   - RStudio: `Session → Restart R` or `Cmd/Ctrl + Shift + 0`
   - Terminal R: `q()` then `R`
   - **Why:** `.Renviron` only loads at R startup

2. **Verify file location**
   ```r
   Sys.getenv("HOME")        # Check home directory
   file.exists("~/.Renviron") # Should be TRUE
   ```

3. **Check file format**
   ```bash
   cat ~/.Renviron
   # Should NOT have quotes: DB_HOST=localhost (correct)
   # Not: DB_HOST="localhost" (wrong)
   ```

4. **Manual reload (temporary fix)**
   ```r
   readRenviron("~/.Renviron")
   ```

See Section 3.4 for complete troubleshooting steps.

---

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

### Issue 3: Environment Variables Not Loading

**Symptom:**
```r
Sys.getenv("DB_HOST")  # Returns ""
```

**Solutions:**

1. **Verify .Renviron location:**
   ```r
   Sys.getenv("HOME")  # Check home directory
   ```

2. **Check file exists:**
   ```bash
   ls -la ~/.Renviron
   ```

3. **Restart R session:**
   - RStudio: Session → Restart R
   - Terminal: Close and reopen R

4. **Load manually (temporary):**
   ```r
   readRenviron("~/.Renviron")
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
"
```

### Issue 5: Table Already Exists Error

**Symptom:**
```
ERROR: relation "hep_students" already exists
```

**Solution:**

**Option A: Drop and recreate (⚠️ DELETES ALL DATA)**
```bash
# Drop the database
dropdb tcsi_db

# Recreate database
createdb tcsi_db

# Navigate to project directory (replace with your actual path)
cd /path/to/tcsi-etl-project

# Recreate schema
psql -d tcsi_db -f schema/init.sql
```

**Option B: Drop specific tables**
```bash
psql -d tcsi_db -c "DROP TABLE IF EXISTS hep_students CASCADE;"
psql -d tcsi_db -f schema/01_students.sql
```

### Issue 6: Out of Memory During ETL

**Solution:**

1. **Reduce batch size in config:**
   ```r
   BATCH_SIZE <- 500  # Reduce from 1000
   ```

2. **Process tables individually:**
   ```r
   # Instead of running all tables, run one at a time
   source("src/etl_students_only.R")
   ```

### Issue 7: Slow Query Performance

**Solutions:**

1. **Run VACUUM ANALYZE:**
   ```bash
   psql -d tcsi_db -c "VACUUM ANALYZE;"
   ```

2. **Check indexes exist:**
   ```bash
   psql -d tcsi_db -c "\di"
   ```

3. **Create missing indexes:**
   ```bash
   psql -d tcsi_db -f schema/08_indexes.sql
   ```

---

## 🔐 Security Best Practices

### 1. Password Protection

**For Production Environments:**

```bash
# Set strong password
psql -d tcsi_db -c "ALTER USER postgres WITH PASSWORD 'YourStrongPassword123!';"
```

Update `.Renviron`:
```bash
DB_PASSWORD=YourStrongPassword123!
```

### 2. Restrict Network Access

Edit `pg_hba.conf`:
```bash
# Find config file
psql -d tcsi_db -c "SHOW hba_file;"

# Edit with text editor
# Change: host all all 0.0.0.0/0 md5
# To:     host all all 127.0.0.1/32 md5  # Local only
```

### 3. Use SSL Connections (Recommended for Remote Access)

```r
# Add ssl parameter
con <- dbConnect(
  RPostgres::Postgres(),
  host = "hostname",
  sslmode = "require"
)
```

### 4. Regular Backups

Implement automated backups (see Maintenance section above).

### 5. Principle of Least Privilege

Create read-only users for analysts:
```sql
CREATE USER analyst WITH PASSWORD 'password';
GRANT CONNECT ON DATABASE tcsi_db TO analyst;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst;
```

### 6. Environment Variables

✅ **DO:** Use `.Renviron` for credentials  
❌ **DON'T:** Hardcode passwords in scripts  
❌ **DON'T:** Commit `.Renviron` to Git

**Important Git Configuration:**

Ensure your `.gitignore` includes:
```gitignore
# Environment files
.Renviron
.env

# Configuration with credentials
**/database_config_runtime.R
```

**Verify before committing:**
```bash
# Check what files will be committed
git status

# If .Renviron appears, add it to .gitignore immediately
echo ".Renviron" >> .gitignore
git add .gitignore
git commit -m "Add .Renviron to gitignore"
```

### 7. Audit Logging

Enable PostgreSQL logging:
```bash
# Edit postgresql.conf
logging_collector = on
log_destination = 'csvlog'
log_statement = 'all'
```

---

## 📚 Additional Resources

### Official Documentation
- [PostgreSQL 16 Documentation](https://www.postgresql.org/docs/16/)
- [RPostgres Package](https://rpostgres.r-dbi.org/)
- [DBI Package](https://dbi.r-dbi.org/)

### TCSI Resources
- [TCSI Support Portal](https://www.tcsisupport.gov.au/)
- TCSI Data Extract Specifications

### Project Documentation
- `docs/POSTGRESQL_SETUP.md` - Original setup guide
- `docs/Setup_Guide.md` - Environment configuration
- `reports/connect_db_doc.Rmd` - R connection examples
- `db/DB_DESIGN_NOTES.md` - Database design decisions
- `docs/erd-stage/` - ERD evolution documentation

### Useful Commands Reference

**PostgreSQL Commands:**
```bash
psql -l                              # List databases
psql -d tcsi_db                      # Connect to database
\dt                                   # List tables
\d table_name                        # Describe table
\q                                    # Quit psql
```

**Service Management:**
```bash
# macOS
brew services start postgresql@16
brew services stop postgresql@16
brew services restart postgresql@16

# Linux
sudo systemctl start postgresql
sudo systemctl stop postgresql
sudo systemctl restart postgresql
```

---

## 📞 Getting Help

### Common Issues and Solutions
1. Check this troubleshooting section first
2. Review error messages carefully
3. Consult PostgreSQL logs

### Project Support
- Review project documentation in `docs/` folder
- Check `README.md` for project overview
- Examine `db/DB_DESIGN_NOTES.md` for design rationale

### External Resources
- [PostgreSQL Community Support](https://www.postgresql.org/support/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/postgresql)
- [R Community](https://community.rstudio.com/)

---

## ✅ Setup Checklist

Use this checklist to verify your setup is complete:

- [ ] **Project code downloaded** (Git clone or ZIP download)
- [ ] **Project structure verified** (schema/, src/, config/ folders exist)
- [ ] PostgreSQL 16 installed
- [ ] PostgreSQL service running
- [ ] Database `tcsi_db` created
- [ ] All 27 tables created successfully
- [ ] Indexes created (08_indexes.sql executed)
- [ ] `.Renviron` file configured with credentials
- [ ] **R/RStudio restarted** after .Renviron creation
- [ ] Environment variables verified (Sys.getenv() returns values)
- [ ] R packages installed (DBI, RPostgres, dplyr, readr, writexl)
- [ ] Database connection test from R successful
- [ ] ETL configuration file updated
- [ ] Sample data load test completed
- [ ] Backup strategy implemented


