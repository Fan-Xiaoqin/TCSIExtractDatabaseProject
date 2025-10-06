# PostgreSQL Setup Guide for TCSI ETL Project

## ✅ Installation Complete

PostgreSQL 16 has been successfully installed and configured for the TCSI ETL project.

## 📊 Database Information

- **Database Name**: `tcsi_db`
- **PostgreSQL Version**: 16.10
- **Installation Method**: Homebrew
- **Service Status**: Running (auto-start enabled)
- **Tables Created**: 27 tables
- **Indexes Created**: 10 indexes

## 🗄️ Database Structure

### Student Tables (6)
1. `hep_students` - Master student records
2. `hep_student_citizenships` - Student citizenship data
3. `hep_student_disabilities` - Student disability records
4. `student_contacts_first_reported_address` - First reported addresses
5. `student_residential_address` - Residential addresses
6. `commonwealth_scholarships` - Commonwealth scholarship data

### Course Tables (4)
7. `courses_of_study` - Course programs
8. `hep_courses` - HEP course details
9. `special_interest_courses` - Special interest courses
10. `course_fields_of_education` - Course field mappings

### Admission Tables (5)
11. `hep_course_admissions` - Course admission records
12. `hep_basis_for_admission` - Admission basis data
13. `hep_course_prior_credits` - Prior credit records
14. `course_specialisations` - Course specializations
15. `hep_hdr_end_users_engagement` - HDR end user engagement

### Financial Tables (4)
16. `oshelp` - OS-HELP loan data
17. `sahelp` - SA-HELP loan data
18. `rtp_scholarships` - RTP scholarship records
19. `rtp_stipend` - RTP stipend data

### Campus Tables (4)
20. `campuses` - Campus master data
21. `hep_courses_on_campuses` - Course-campus relationships
22. `campus_course_fees_itsp` - Campus course fees
23. `campuses_tac` - Campus TAC data

### Award Tables (2)
24. `aggregated_awards` - Aggregated award data
25. `exit_awards` - Exit award records

### Unit Enrollment Tables (2)
26. `unit_enrolments` - Unit enrollment records
27. `unit_enrolments_aous` - Unit AOU records

## 🔧 PostgreSQL Commands

### Service Management
```bash
# Start PostgreSQL
brew services start postgresql@16

# Stop PostgreSQL
brew services stop postgresql@16

# Restart PostgreSQL
brew services restart postgresql@16

# Check status
brew services info postgresql@16
```

### Database Access
```bash
# Add to PATH (add to ~/.zshrc for permanent)
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# Connect to database
psql -d tcsi_db

# List all databases
psql -l

# List all tables in tcsi_db
psql -d tcsi_db -c "\dt"

# Describe a table
psql -d tcsi_db -c "\d hep_students"

# Run a query
psql -d tcsi_db -c "SELECT COUNT(*) FROM hep_students;"
```

### Database Operations
```bash
# Create database
createdb database_name

# Drop database
dropdb database_name

# Backup database
pg_dump tcsi_db > tcsi_db_backup.sql

# Restore database
psql tcsi_db < tcsi_db_backup.sql

# Export table to CSV
psql -d tcsi_db -c "COPY hep_students TO '/tmp/students.csv' CSV HEADER;"
```

## 📝 Connection Details for R

### Using RPostgreSQL
```r
library(RPostgreSQL)

# Create connection
drv <- dbDriver("PostgreSQL")
conn <- dbConnect(
  drv,
  dbname = "tcsi_db",
  host = "localhost",
  port = 5432,
  user = Sys.getenv("USER")  # Your macOS username
)

# Query data
data <- dbGetQuery(conn, "SELECT * FROM hep_students LIMIT 10")

# Disconnect
dbDisconnect(conn)
```

### Connection String Format
```
postgresql://localhost:5432/tcsi_db
```

## 🚀 Using PostgreSQL with ETL

### Update Configuration

Edit `config/database_config.R`:

```r
# Change from DUMMY to POSTGRESQL
DB_MODE <- "POSTGRESQL"

# PostgreSQL connection settings
PG_HOST <- "localhost"
PG_PORT <- 5432
PG_DBNAME <- "tcsi_db"
PG_USER <- Sys.getenv("USER")
PG_PASSWORD <- ""  # No password for local connection
```

### Run ETL with PostgreSQL

```r
# Run test ETL
source("test_etl.R")

# Or run main ETL directly
source("src/main_etl_students.R")
```

## 🔐 Security Considerations

### Local Development (Current Setup)
- No password required (trusted local connection)
- Accessible only from localhost
- Safe for development and testing

### Production Setup (Future)
For production deployment, consider:

1. **Enable password authentication**
   ```bash
   # Edit pg_hba.conf
   psql -d tcsi_db -c "ALTER USER <username> WITH PASSWORD 'your_password';"
   ```

2. **Restrict network access**
   - Configure `pg_hba.conf` for specific hosts
   - Use SSL connections for remote access

3. **Regular backups**
   ```bash
   # Daily backup script
   pg_dump tcsi_db > "tcsi_backup_$(date +%Y%m%d).sql"
   ```

4. **Use environment variables for credentials**
   ```r
   PG_USER <- Sys.getenv("TCSI_DB_USER")
   PG_PASSWORD <- Sys.getenv("TCSI_DB_PASSWORD")
   ```

## 📊 Monitoring and Maintenance

### Check Database Size
```bash
psql -d tcsi_db -c "SELECT pg_size_pretty(pg_database_size('tcsi_db'));"
```

### Check Table Sizes
```bash
psql -d tcsi_db -c "
SELECT 
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
"
```

### Check Active Connections
```bash
psql -d tcsi_db -c "SELECT * FROM pg_stat_activity WHERE datname = 'tcsi_db';"
```

### Vacuum and Analyze
```bash
# Optimize database
psql -d tcsi_db -c "VACUUM ANALYZE;"
```

## 🐛 Troubleshooting

### Cannot Connect to PostgreSQL
```bash
# Check if service is running
brew services info postgresql@16

# Start service if not running
brew services start postgresql@16

# Check logs
tail -f /opt/homebrew/var/log/postgresql@16.log
```

### Port Already in Use
```bash
# Check what's using port 5432
lsof -i :5432

# Use different port in configuration
PG_PORT <- 5433
```

### Reset Database
```bash
# Drop and recreate database
dropdb tcsi_db
createdb tcsi_db

# Recreate all tables
cd <path-to-directory>/tcsi-etl-project
psql -d tcsi_db -f schema/01_students.sql
psql -d tcsi_db -f schema/02_courses.sql
psql -d tcsi_db -f schema/03_course_admissions.sql
psql -d tcsi_db -f schema/04_loans.sql
psql -d tcsi_db -f schema/05_awards.sql
psql -d tcsi_db -f schema/06_campuses.sql
psql -d tcsi_db -f schema/07_unit_enrolments.sql
psql -d tcsi_db -f schema/08_indexes.sql
# ... continue with all schema files
```

## 📚 Additional Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/16/)
- [RPostgreSQL Package](https://cran.r-project.org/web/packages/RPostgreSQL/)
- [Homebrew PostgreSQL](https://formulae.brew.sh/formula/postgresql@16)

## ✅ Next Steps

1. Install R PostgreSQL package:
   ```r
   install.packages("RPostgreSQL")
   ```

2. Update `config/database_config.R` to use PostgreSQL mode

3. Run ETL to load sample data:
   ```r
   source("test_etl.R")
   ```

4. Query loaded data:
   ```r
   library(RPostgreSQL)
   conn <- dbConnect(dbDriver("PostgreSQL"), dbname="tcsi_db", host="localhost")
   dbGetQuery(conn, "SELECT COUNT(*) FROM hep_students")
   dbDisconnect(conn)
   ```

---

**Installation Date**: September 30, 2025  
**Database Ready**: ✅ All 27 tables created  
**Status**: Production-ready for local development
