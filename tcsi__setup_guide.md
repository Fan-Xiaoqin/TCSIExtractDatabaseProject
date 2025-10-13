# TCSI Database Complete Setup Guide

> **Version:** 1.3.0  
> **Last Updated:** October 2025  
> **Project:** TCSI Extract Database - Tertiary Collection of Student Information

---

## 📖 Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Quick Start (10 Minutes)](#quick-start)
4. [Detailed Setup Instructions](#detailed-setup)
   - [Step 0: Get the Project Code](#step-0-get-the-project-code)
   - [Step 1: PostgreSQL Installation](#step-1-postgresql-installation)
   - [Step 2: Database Creation](#step-2-database-creation)
   - [Step 3: Environment Configuration](#step-3-environment-configuration)
   - [Step 4: R Package Installation](#step-4-r-package-installation)
   - [Step 5: Database Schema Setup](#step-5-database-schema-setup)
   - [Step 6: ETL Configuration](#step-6-etl-configuration)
   - [**Step 7: Data File Preparation** 🆕](#step-7-data-file-preparation)
   - [**Step 8: Run ETL Import** 🆕](#step-8-run-etl-import)
   - [**Step 9: Verify Data Import** 🆕](#step-9-verify-data-import)
5. [Testing & Verification](#testing-verification)
6. [Database Structure](#database-structure)
7. [Usage Examples](#usage-examples)
8. [Maintenance & Monitoring](#maintenance)
9. [Troubleshooting](#troubleshooting)
10. [Security Best Practices](#security)

---

## 🎯 Overview

This guide provides complete instructions for setting up the PostgreSQL database infrastructure for the TCSI ETL project. The database stores and manages student data extracted from TCSI (Tertiary Collection of Student Information) with support for:

- ✅ **26 interconnected tables** covering student lifecycle data
- ✅ **Historical data preservation** with SCD-2 (Slowly Changing Dimensions)
- ✅ **R/RStudio integration** for data analysis
- ✅ **Automated ETL pipeline** with validation and logging
- ✅ **Data quality controls** and referential integrity

### Database Overview
- **Database Name:** `tcsi_db`
- **RDBMS:** PostgreSQL 16
- **Total Tables:** 27 tables
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
│   ├── tcsiSample/         # Sample CSV files (ALREADY PROVIDED!)
│   ├── logs/               # ETL logs (auto-created)
│   └── errors/             # Error logs (auto-created)
├── docs/                   # Documentation
├── schema/                 # Database schema SQL files
├── src/                    # Source code
│   ├── main_etl_all_tables.R  # Main ETL script
│   ├── app.R               # Shiny app
│   └── utils/              # Utility functions
├── R/                      # R helper scripts
└── README.md
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

# 3. Setup environment variables
cat > ~/.Renviron << EOF
DB_HOST=localhost
DB_PORT=5432
DB_NAME=tcsi_db
DB_USER=$(whoami)
DB_PASSWORD=
EOF

# 4. Restart R/RStudio (CRITICAL!)
# RStudio: Session → Restart R

# 5. Install R packages
R -e "source('install_packages.R')"

# 6. Create all tables
psql -d tcsi_db -f schema/init.sql

# 7. Verify sample data exists
ls -la data/tcsiSample/

# 8. Run ETL in R
R -e "source('src/main_etl_all_tables.R'); main()"
```

---

## 🔧 Detailed Setup Instructions

### Step 1: PostgreSQL Installation

#### Option A: macOS (Homebrew) ⭐ Recommended

```bash
# Install PostgreSQL
brew install postgresql@16

# Add PostgreSQL to PATH
echo 'export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Start service
brew services start postgresql@16

# Verify
psql --version
```

#### Option B: Windows

1. Download PostgreSQL 16 installer from [postgresql.org](https://www.postgresql.org/download/windows/)
2. Run installer and set password for `postgres` user
3. Add to PATH: `C:\Program Files\PostgreSQL\16\bin`
4. Verify: `psql --version`

#### Option C: Linux (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install postgresql-16 postgresql-contrib-16
sudo systemctl start postgresql
sudo systemctl enable postgresql
psql --version
```

---

### Step 2: Database Creation

**macOS/Linux:**
```bash
createdb tcsi_db
```

**Windows:**
```powershell
psql -U postgres
CREATE DATABASE tcsi_db;
\q
```

**Verify:**
```bash
psql -l  # List all databases
psql -d tcsi_db  # Connect to database
```

---

### Step 3: Environment Configuration

Create `.Renviron` file in your home directory:

```bash
# Create .Renviron file
cat > ~/.Renviron << EOF
DB_HOST=localhost
DB_PORT=5432
DB_NAME=tcsi_db
DB_USER=$(whoami)
DB_PASSWORD=
EOF

# Verify file was created
cat ~/.Renviron
```

**🔴 CRITICAL: Restart R/RStudio**

```r
# In RStudio: Session → Restart R
# Or keyboard: Cmd/Ctrl + Shift + 0

# In R terminal:
q()
R
```

**Verify environment variables loaded:**

```r
# Check all variables
Sys.getenv("DB_HOST")      # Should return "localhost"
Sys.getenv("DB_NAME")      # Should return "tcsi_db"
Sys.getenv("DB_USER")      # Should return your username
```

---

### Step 4: R Package Installation

```r
# Automated installation (recommended)
source("install_packages.R")

# Or manual installation
install.packages(c("DBI", "RPostgres", "dplyr", "readr", "writexl"))

# Verify
library(DBI)
library(RPostgres)
```

---

### Step 5: Database Schema Setup

Create all 27 tables using the master init script:

```bash
# Navigate to project directory
cd ~/Documents/TCSIExtractDatabaseProject/tcsi-etl-project

# Execute master script (creates all tables)
psql -d tcsi_db -f schema/init.sql
```

**Expected output:**
```
CREATE TABLE
CREATE TABLE
... (27 tables)
CREATE INDEX
... (10+ indexes)
```

**Verify tables created:**

```bash
psql -d tcsi_db -c "
  SELECT COUNT(*) as table_count 
  FROM information_schema.tables 
  WHERE table_schema = 'public';
"
```

Should return: **26 tables**

---

### Step 6: ETL Configuration

The ETL is pre-configured in `config/database_config.R`. Verify the settings:

```r
# Open in RStudio or text editor
file.edit("config/database_config.R")

# Key settings to verify:
# DB_MODE <- "POSTGRESQL"  # Should be POSTGRESQL, not DUMMY
# DATA_INPUT_DIR <- file.path(PROJECT_ROOT, "data", "tcsiSample")
# BATCH_SIZE <- 1000
# LOG_LEVEL <- "INFO"
```

**Alternative: Use Shiny Configuration App**

```r
# Run interactive configuration app
library(shiny)
setwd("~/Documents/tcsi-etl-project/src")
runApp("app.R")
```

The Shiny app provides:
- ✅ Database connection testing
- ✅ Visual configuration file generation
- ✅ ETL process monitoring
- ✅ Real-time log viewing

---

### Step 7: Data File Preparation 🆕

#### 7.1 Verify Sample Data Files

**The project ALREADY includes sample CSV files for testing!** 

```bash
# Navigate to data directory
cd ~/Documents/TCSIExtractDatabaseProject/tcsi-etl-project

# List sample data files
ls -la data/tcsiSample/

# You should see files like:
# HEPStudents*.csv
# HEPCourses*.csv
# HEPCourseAdmissions*.csv
# HEPCoursesOnCampuses*.csv
# ... and more for all 27 tables
```

#### 7.2 Understand CSV File Naming Pattern

The ETL system uses **glob patterns** to find CSV files:

```r
# Example patterns from field_mappings.R:
csv_pattern = "*HEPStudents*.csv"          # Matches any file containing "HEPStudents"
csv_pattern = "*HEPCourses*.csv"           # Matches any file containing "HEPCourses"
csv_pattern = "*HEPCourseAdmissions*.csv"  # Matches any file containing "HEPCourseAdmissions"
```

**Valid filename examples:**
- ✅ `HEPStudents.csv`
- ✅ `HEPStudents_202410.csv`
- ✅ `Extract_HEPStudents_Final.csv`
- ✅ `MyData_HEPStudents_V2.csv`

**What matters:** The table name (e.g., "HEPStudents") must appear somewhere in the filename.

#### 7.3 Data Directory Structure

```
data/
├── tcsiSample/          # INPUT: Place CSV files here
│   ├── HEPStudents*.csv
│   ├── HEPCourses*.csv
│   ├── ... (27 tables)
├── logs/                # OUTPUT: ETL logs (auto-created)
│   └── etl_20251013_143022.log
└── errors/              # OUTPUT: Error files (auto-created)
    └── hep_students_errors.csv
```

#### 7.4 Using Your Own TCSI Data (Optional)

If you want to import your own TCSI extract data:

1. **Obtain TCSI CSV files** from your institution's data warehouse
2. **Place files in `data/tcsiSample/`** directory
3. **Ensure naming matches patterns** (include table name in filename)
4. **Verify CSV format:**
   ```bash
   # Check first few lines
   head -5 data/tcsiSample/HEPStudents.csv
   
   # Check for proper encoding
   file -I data/tcsiSample/HEPStudents.csv
   ```

#### 7.5 Verify Sample Data is Ready

```bash
# Count CSV files
ls data/tcsiSample/*.csv | wc -l

# Show first file as example
echo "Sample file preview:"
head -3 data/tcsiSample/HEPCourses.csv
```

---

### Step 8: Run ETL Import 🆕

Now that data files are ready, run the complete ETL pipeline to import all tables.

#### 8.1 Prepare to Run ETL

```r
# 1. Open RStudio
# 2. Set working directory to project root
setwd("~/Documents/TCSIExtractDatabaseProject/tcsi-etl-project")

# 3. Verify you're in the correct location
getwd()
list.files()  # Should see: config/, data/, schema/, src/
```

#### 8.2 Run Complete ETL Pipeline

**Method 1: Run from R Console (Recommended)**

```r
# Load and run the main ETL script
source("src/main_etl_all_tables.R")

# Execute ETL for all tables
results <- main()
```

**Method 2: Run from Terminal/Command Line**

```bash
# Navigate to project root
cd ~/Documents/TCSIExtractDatabaseProject/tcsi-etl-project

# Run ETL
Rscript -e "source('src/main_etl_all_tables.R'); main()"
```

**Method 3: Use Shiny App (Visual Interface)**

```r
# Run Shiny app
library(shiny)
setwd("~/Documents/tcsi-etl-project/src")
runApp("app.R")

# In the app:
# 1. Go to "ETL Process" tab
# 2. Click "Start ETL Process" button
# 3. Monitor progress in real-time
```

#### 8.3 Understanding ETL Output

During ETL execution, you'll see output like:

```
=== TCSI ETL Configuration ===
Database Mode: POSTGRESQL
Batch Size: 1000
Data Input Dir: /Users/you/Documents/tcsi-etl-project/data/tcsiSample
==============================

========================================
Starting Complete TCSI ETL (All 26 Tables)
========================================

========================================
PHASE: 01-Students
========================================

Processing table: hep_students
--------------------
Reading CSV file...
Read 1250 rows from CSV
Processing data in batches...
Validation summary: 1250 total rows, 1248 valid (99.8%), 2 invalid (0.2%)
ETL complete for hep_students: 1248 rows loaded, 2 errors

Processing table: hep_student_citizenships
--------------------
...
```

#### 8.4 Expected Runtime

| Dataset Size | Approximate Time |
|--------------|------------------|
| Sample data (provided) | 5-10 minutes |
| Small dataset (<10K rows/table) | 10-15 minutes |
| Medium dataset (10K-100K rows) | 15-30 minutes |
| Large dataset (>100K rows) | 30-60 minutes |

#### 8.5 ETL Success Indicators

Look for these signs of successful ETL:

✅ **Each table shows "SUCCESS"**
```
hep_students                              : SUCCESS (1248 rows loaded)
hep_student_citizenships                  : SUCCESS (856 rows loaded)
```

✅ **Final summary shows high success rate**
```
========================================
       COMPLETE TCSI ETL SUMMARY        
========================================
Tables processed:  26
Tables succeeded:  26
Tables failed:     0
Tables skipped:    0
Total rows loaded: 45,823
Total errors:      12
========================================
```

✅ **Phase summary shows data loaded**
```
Phase Summary:
----------------------------------------
01-Students              :  6 tables,   8234 rows loaded, 6 succeeded, 0 failed
02-Courses               :  4 tables,   5678 rows loaded, 4 succeeded, 0 failed
...
```

#### 8.6 What If ETL Fails?

If you see failures:

```
hep_students                              : FAILED
```

**Don't panic!** Common causes:

1. **CSV file not found**
   - Check file exists in `data/tcsiSample/`
   - Verify filename matches pattern

2. **Data validation errors**
   - Check `data/errors/hep_students_errors.csv`
   - Review validation rules in field mappings

3. **Database connection lost**
   - Verify PostgreSQL is running: `brew services info postgresql@16`
   - Test connection: `psql -d tcsi_db`

4. **Foreign key violations**
   - ETL processes tables in dependency order
   - Check if dependent tables succeeded first

**See [Step 9](#step-9-verify-data-import) for verification and debugging steps.**

---

### Step 9: Verify Data Import 🆕

After ETL completes, verify that data was successfully imported.

#### 9.1 Check Table Row Counts

**Method 1: Using R helper script**

```r
source("R/connect_db.R")

# Get row counts for all tables
tables <- run_query("
  SELECT 
    tablename,
    (xpath('/row/c/text()', 
      query_to_xml(
        format('SELECT COUNT(*) AS c FROM %I', tablename),
        false, true, ''
      )
    ))[1]::text::int AS row_count
  FROM pg_tables 
  WHERE schemaname = 'public'
  ORDER BY row_count DESC;
")

print(tables)
```

**Method 2: Using psql**

```bash
psql -d tcsi_db -c "
  SELECT 
    schemaname,
    tablename,
    (SELECT COUNT(*) FROM \"" || tablename || "\") as row_count
  FROM pg_tables 
  WHERE schemaname = 'public'
  ORDER BY row_count DESC;
"
```


#### 9.2 Inspect Sample Data

```r
source("R/connect_db.R")

# View first 10 rows from students table
students <- run_query("
  SELECT * FROM hep_students 
  LIMIT 10;
")
print(students)

# Check data quality - look for NULLs in required fields
student_quality <- run_query("
  SELECT 
    COUNT(*) as total_students,
    COUNT(DISTINCT e313_student_identification_code) as unique_students,
    COUNT(e330_attendance_type_code) as students_with_attendance_type,
    COUNT(e358_citizen_resident_code) as students_with_citizenship
  FROM hep_students;
")
print(student_quality)
```

#### 9.3 Verify Relationships

```r
# Test foreign key relationships
relationship_check <- run_query("
  SELECT 
    'Students' as entity,
    COUNT(*) as count
  FROM hep_students
  UNION ALL
  SELECT 
    'Admissions' as entity,
    COUNT(*) 
  FROM hep_course_admissions
  UNION ALL
  SELECT 
    'Courses' as entity,
    COUNT(*) 
  FROM hep_courses;
")
print(relationship_check)

# Test a join to verify referential integrity
join_test <- run_query("
  SELECT 
    s.e313_student_identification_code,
    c.e307_course_code,
    c.e310_course_name,
    a.e489_course_admission_date
  FROM hep_students s
  INNER JOIN hep_course_admissions a 
    ON s.student_id = a.student_id
  INNER JOIN hep_courses c 
    ON a.uid5_courses_res_key = c.uid5_courses_res_key
  LIMIT 5;
")
print(join_test)
```

#### 9.4 Review ETL Logs

**Location:** `data/logs/`

```bash
# List recent log files
ls -lt data/logs/ | head -5

# View latest log file
cat data/logs/etl_20251013_143022.log

# Search for errors in logs
grep -i "ERROR" data/logs/etl_20251013_143022.log

# Search for warnings
grep -i "WARN" data/logs/etl_20251013_143022.log

# Count successful table loads
grep -i "SUCCESS" data/logs/etl_20251013_143022.log | wc -l
```

**Log file contains:**
- ✅ Timestamp for each operation
- ✅ Table processing sequence
- ✅ Row counts and validation results
- ✅ Error details and warnings
- ✅ Performance metrics

#### 9.5 Check Error Files

**Location:** `data/errors/`

If there were validation errors during ETL, check error files:

```bash
# List error files
ls -la data/errors/

# View errors for a specific table
head -20 data/errors/hep_students_errors.csv

# Count errors per table
for f in data/errors/*.csv; do 
  echo "$f: $(wc -l < $f) errors"
done
```

**Error file format:**
```csv
row_num,field,value,error_message
145,e330_attendance_type_code,9,Invalid value: must be 1-8
267,e313_student_identification_code,,"Required field is NULL"
```

#### 9.6 Data Quality Summary

```r
# Get comprehensive data quality report
source("R/connect_db.R")

# Tables with data
tables_with_data <- run_query("
  SELECT 
    tablename,
    (SELECT COUNT(*) FROM \"" || tablename || "\") as rows
  FROM pg_tables 
  WHERE schemaname = 'public' 
    AND (SELECT COUNT(*) FROM \"" || tablename || "\") > 0
  ORDER BY rows DESC;
")

cat("\n=== Data Quality Summary ===\n")
cat(sprintf("Tables with data: %d / 27\n", nrow(tables_with_data)))
cat(sprintf("Total rows across all tables: %s\n", 
    format(sum(tables_with_data$rows), big.mark=",")))
cat("\nTop 5 tables by row count:\n")
print(head(tables_with_data, 5))
```

#### 9.7 Verification Checklist

Use this checklist to confirm successful setup:

- [ ] All 26 tables exist in database
- [ ] All tables have row_count > 0 (or expected to be empty)
- [ ] Sample queries return expected results
- [ ] Foreign key relationships work (joins succeed)
- [ ] No critical errors in log files
- [ ] Error counts are acceptable (<1% of total rows)
- [ ] Database size is reasonable (check with `\l+` in psql)

**If all checks pass: 🎉 Congratulations! Your TCSI database is ready to use!**

---

## ✅ Testing & Verification

### Test 1: PostgreSQL Service Status

```bash
brew services info postgresql@16  # macOS
# Expected: "postgresql@16: started"
```

### Test 2: Database Connection

```bash
psql -d tcsi_db -c "SELECT version();"
# Should return PostgreSQL version
```

### Test 3: R Database Connection

```r
source("R/connect_db.R")

# Test connection
db_conn <- create_db_connection()
# Expected: "Database connection successful!"

# Test query
print(run_query("SELECT version();"))

# Check tables
tables <- run_query("
  SELECT tablename 
  FROM pg_tables 
  WHERE schemaname = 'public'
  ORDER BY tablename;
")
print(tables)

# Clean up
dbDisconnect(db_conn)
```

---

## 📊 Database Structure

### Table Categories

| Category | Tables | Description |
|----------|--------|-------------|
| **Students** | 6 | Master student records, citizenships, disabilities, addresses |
| **Courses** | 4 | Course programs, special interest courses, fields of education |
| **Admissions** | 5 | Admissions, basis for admission, prior credits, specializations |
| **Financial** | 4 | OS-HELP, SA-HELP, RTP scholarships and stipends |
| **Campuses** | 4 | Campus locations, course offerings, fees |
| **Awards** | 2 | Aggregated awards, exit awards |
| **Unit Enrollments** | 2 | Unit enrollments and AOU data |

**Total: 26 tables**

---

## 💡 Usage Examples

### Example 1: Query Student Data

```r
source("R/connect_db.R")

students <- run_query("
  SELECT 
    e313_student_identification_code,
    e330_attendance_type_code,
    e358_citizen_resident_code
  FROM hep_students
  LIMIT 10;
")
print(students)
```

### Example 2: Complex Join Query

```r
admissions_summary <- run_query("
  SELECT 
    s.e313_student_identification_code,
    c.e307_course_code,
    c.e310_course_name,
    a.e489_course_admission_date
  FROM hep_students s
  INNER JOIN hep_course_admissions a ON s.student_id = a.student_id
  INNER JOIN hep_courses c ON a.uid5_courses_res_key = c.uid5_courses_res_key
  WHERE a.e489_course_admission_date >= '2023-01-01'
  LIMIT 20;
")
print(admissions_summary)
```

### Example 3: Export to Excel

```r
library(writexl)

results <- run_query("SELECT * FROM hep_students LIMIT 100;")
write_xlsx(results, "student_export.xlsx")
```

---

## 🔧 Maintenance & Monitoring

### Database Size

```bash
psql -d tcsi_db -c "
  SELECT pg_size_pretty(pg_database_size('tcsi_db'));
"
```

### Table Sizes

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

### Backup

```bash
# Create backup
pg_dump tcsi_db > "tcsi_backup_$(date +%Y%m%d).sql"

# Restore
psql tcsi_db < tcsi_backup_20251013.sql
```

---

## 🛠 Troubleshooting

### Issue 1: Environment Variables Not Loading

**Most common issue!**

```r
# Symptom
Sys.getenv("DB_HOST")  # Returns ""
```

**Solution: Restart R/RStudio**
```r
# RStudio: Session → Restart R (Cmd/Ctrl + Shift + 0)
# Then check again:
Sys.getenv("DB_HOST")  # Should return "localhost"
```

### Issue 2: PostgreSQL Not Running

```bash
# Check status
brew services info postgresql@16

# Start service
brew services start postgresql@16
```

### Issue 3: CSV Files Not Found

```bash
# Verify files exist
ls -la data/tcsiSample/

# Check file naming
# Files should contain table name, e.g.:
# HEPStudents.csv ✅
# Students.csv ❌ (missing "HEP" prefix)
```

### Issue 4: ETL Validation Errors

```bash
# Check error file
cat data/errors/hep_students_errors.csv

# Common causes:
# - Required field is NULL
# - Invalid value for CHECK constraint
# - Foreign key reference not found
```

---

## 🔒 Security Best Practices

1. **Never commit `.Renviron` to Git**
   ```bash
   # Verify .gitignore includes:
   cat .gitignore | grep Renviron
   ```

2. **Use environment variables for all credentials**
   ```r
   # Good 
   user = Sys.getenv("DB_USER")
   
   # Bad 
   user = "hardcoded_username"
   ```

3. **Restrict database access**
   ```sql
   -- Grant minimum necessary permissions
   GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO tcsi_user;
   ```

---

## ✅ Setup Checklist

- [ ] Project code downloaded (Step 0)
- [ ] PostgreSQL 16 installed (Step 1)
- [ ] Database `tcsi_db` created (Step 2)
- [ ] `.Renviron` configured (Step 3)
- [ ] R/RStudio restarted after .Renviron (Step 3)
- [ ] Environment variables verified (Step 3)
- [ ] R packages installed (Step 4)
- [ ] All 27 tables created (Step 5)
- [ ] ETL configuration verified (Step 6)
- [ ] Sample CSV files verified (Step 7) 
- [ ] ETL executed successfully (Step 8) 
- [ ] Data import verified (Step 9) 
- [ ] Backup strategy implemented

---

## 📚 Additional Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [R DBI Package](https://dbi.r-dbi.org/)
- [TCSI Support](https://www.tcsisupport.gov.au/)

