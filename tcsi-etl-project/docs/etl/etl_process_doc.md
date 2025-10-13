# ETL Process – TCSI Extract Database

## 1. Overview

The ETL (Extract, Transform, Load) process for the TCSI project automates the collection, processing, validation, and loading of student and related data into the PostgreSQL database. The ETL framework ensures data integrity, consistency, and readiness for reporting, KPI analysis and forecasting.  

The ETL pipeline is implemented using R, leveraging modular scripts for configuration, database operations, data transformations, validations, and logging.

---

## 2. ETL Workflow Summary

The ETL process consists of the following steps:

1. **Extraction**  
   - Data is extracted from source CSV files stored in the project `data/tcsiSamples/` directory.  
   - Database queries may also be used to pull existing reference data for validation or mapping purposes.

2. **Transformation**  
   - Data is cleaned, formatted, and transformed according to business rules and field mappings.  
   - Includes data type conversions, string cleaning, date formatting, and calculated fields.

3. **Validation**  
   - Transformed data is checked for completeness, uniqueness, and correctness.  
   - Validation ensures that records comply with required formats, missing values are handled, and referential integrity is maintained.

4. **Loading**  
   - Validated data is inserted into the PostgreSQL database.  
   - Triggers and flags are used to maintain record versioning (`is_current`) and enforce referential consistency.

5. **Logging & Monitoring**  
   - Each ETL run logs its progress, warnings, errors, and summary statistics for auditing and troubleshooting purposes.

---

## 3. Directory Structure
```graphql
tcsi-etl-project/
├── config/                  # Configuration files and field mappings
│   ├── database_config      # DB connection parameters
│   └── field_mappings.R     # Mapping of source columns to target DB columns
├── data/                    # Raw and error logs
│   ├── errors/
│   ├── logs/
│   └── tcsiSamples/         # Original CSV files
├── docs/                    # Documentation files
├── schema/                  # DB schema and triggers
├── src/                     # R scripts for ETL processing
```

---

## 4. R Scripts Overview

| Category | File | Purpose / Functionality |
|----------|------|------------------------|
| **Configuration** | `database_config.R` | Stores database connection parameters (host, port, user, password, database). Used across all scripts needing DB access. |
|  | `field_mappings.R` | Defines mappings between source CSV fields and target database columns, ensuring consistent transformations. |
| **Database Utilities** | `database_utils.R` | Functions to connect, disconnect, and execute queries on PostgreSQL. |
| **ETL Orchestration** | `main_etl_all_tables.R` | Main script to orchestrate the ETL workflow. Calls extraction, transformation, validation, and load functions for all tables. Handles logging and errors. |
|  | `generic_etl.R` | Provides general ETL functions reused across multiple datasets, such as standardized extract-transform-load routines. |
| **Transformation & Validation** | `transformation_utils.R` | Contains helper functions for data cleaning, string manipulation, date parsing, and numeric conversions. |
|  | `validation_utils.R` | Functions to validate data integrity, including checks for missing values, duplicates, and correct column types. |
| **Logging & Monitoring** | `logging_utils.R` | Implements logging functions to record ETL steps, warnings, errors, and process status. |

---

## 5. ETL Execution

- The ETL process is executed by running the `main_etl_all_tables.R` script.  
- It automatically loads configuration, establishes database connections, processes all datasets, validates data, logs execution details, and loads data into PostgreSQL.  
- Logs and errors are stored in `data/logs/` and `data/errors/` respectively for auditing and troubleshooting.

---

## 6. Key Notes

- All ETL scripts are modular, allowing individual components to be reused or updated without impacting the entire workflow.  
- Validation functions ensure only clean and consistent data enters the database, reducing manual corrections.  
- Logging provides transparency and traceability for every ETL run, essential for reporting and debugging.  

---

## 7. References

- PostgreSQL database: `tcsi_db`  
- Source data files: `data/tcsiSamples/`  
- R packages used include `DBI`, `RPostgres`, `dplyr`, `lubridate`, and `stringr` (among others).

---

**Document Version:** 1.0  
**Prepared by:** *Group 3 – CITS5206 2025 Semester 2*  
**Date:** *October 2025*