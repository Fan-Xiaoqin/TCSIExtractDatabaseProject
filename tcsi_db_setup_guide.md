# TCSI Database Complete Setup Guide

> **Version:** 1.0  
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
- **Total Tables:** 27 tables
- **Data Categories:** Students, Courses, Admissions, Financial, Awards, Units

---

## 📋 Prerequisites

Before starting, ensure you have:

### Software Requirements
- ✅ **Operating System:** macOS, Windows, or Linux
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

## ⚡ Quick Start

**For experienced users who want to get running immediately:**

```bash
# 1. Install PostgreSQL (macOS)
brew install postgresql@16
brew services start postgresql@16

# 2. Create database
createdb tcsi_db

# 3. Create schema
cd tcsi-etl-project
psql -d tcsi_db -f schema/init.sql

# 4. Configure R packages
Rscript install_packages.R

# 5. Set up environment variables
# Create ~/.Renviron with database credentials

# 6. Test connection
R -e "library(DBI); library(RPostgres); con <- dbConnect(RPostgres::Postgres(), dbname='tcsi_db', host='localhost'); dbGetQuery(con, 'SELECT version();'); dbDisconnect(con)"
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

**Restart R/RStudio** for changes to take effect.

#### 3.4 Verify Configuration

Open R or RStudio and run:
```r
Sys.getenv("DB_HOST")
Sys.getenv("DB_NAME")
# Should print: "localhost" and "tcsi_db"
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
cd path/to/tcsi-etl-project
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
DB_CONFIG <- list(
  host = "localhost",
  port = 5432,
  dbname = "tcsi_db",
  user = Sys.getenv("USER"),      # Will use .Renviron values
  password = ""                    # Empty for local Mac/Linux
)

# ETL Processing Settings
BATCH_SIZE <- 1000
MAX_ROWS_TO_PROCESS <- NULL       # NULL = process all rows
STOP_ON_ERROR <- FALSE            # Continue on errors

# File Paths
DATA_INPUT_DIR <- file.path(getwd(), "data", "tcsiSample")
DATA_LOGS_DIR <- file.path(getwd(), "data", "logs")
```

#### 6.2 Alternative: Use Shiny Configuration App

The project includes a graphical configuration tool:

```r
# Run Shiny app for easy configuration
cd tcsi-etl-project/src
Rscript -e "shiny::runApp('app.R')"
```

Features:
- ✅ Database connection testing
- ✅ Configuration file generation
- ✅ ETL process monitoring
- ✅ Real-time logs

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

Create a test script `test_connection.R`:

```r
library(DBI)
library(RPostgres)

# Create connection
con <- tryCatch({
  dbConnect(
    RPostgres::Postgres(),
    host = Sys.getenv("DB_HOST"),
    port = as.integer(Sys.getenv("DB_PORT")),
    dbname = Sys.getenv("DB_NAME"),
    user = Sys.getenv("DB_USER"),
    password = Sys.getenv("DB_PASSWORD")
  )
}, error = function(e) {
  cat("❌ Connection failed:", e$message, "\n")
  return(NULL)
})

if (!is.null(con)) {
  cat("✅ Database connection successful!\n")
  
  # Test query
  result <- dbGetQuery(con, "SELECT version();")
  cat("\nPostgreSQL Version:\n")
  print(result)
  
  # List tables
  tables <- dbListTables(con)
  cat("\nNumber of tables:", length(tables), "\n")
  cat("Sample tables:", paste(head(tables, 5), collapse=", "), "\n")
  
  # Disconnect
  dbDisconnect(con)
  cat("\n✅ All tests passed!\n")
} else {
  cat("❌ Unable to establish connection. Check your configuration.\n")
}
```

Run the test:
```r
source("test_connection.R")
```

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

## 💡 Usage Examples

### Example 1: Connect to Database from R

```r
library(DBI)
library(RPostgres)

# Function to create connection
create_db_connection <- function() {
  tryCatch({
    con <- dbConnect(
      RPostgres::Postgres(),
      host = Sys.getenv("DB_HOST"),
      port = as.integer(Sys.getenv("DB_PORT")),
      dbname = Sys.getenv("DB_NAME"),
      user = Sys.getenv("DB_USER"),
      password = Sys.getenv("DB_PASSWORD")
    )
    message("✅ Connection successful!")
    return(con)
  }, error = function(e) {
    stop("❌ Connection failed: ", e$message)
  })
}

# Use the connection
con <- create_db_connection()
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
# From project root directory
setwd("tcsi-etl-project")

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
dropdb tcsi_db
createdb tcsi_db
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

- [ ] PostgreSQL 16 installed
- [ ] PostgreSQL service running
- [ ] Database `tcsi_db` created
- [ ] All 27 tables created successfully
- [ ] Indexes created (08_indexes.sql executed)
- [ ] `.Renviron` file configured with credentials
- [ ] R packages installed (DBI, RPostgres, dplyr, readr, writexl)
- [ ] Database connection test from R successful
- [ ] ETL configuration file updated
- [ ] Sample data load test completed
- [ ] Backup strategy implemented

---

## 📝 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | Oct 2025 | Initial comprehensive guide |

---

**Document Status:** ✅ Production Ready  
**Maintained By:** TCSI ETL Project Team  
**Last Review:** October 2025