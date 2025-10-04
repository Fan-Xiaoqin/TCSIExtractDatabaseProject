# TCSI Extract Database Project

This repository contains a local database solution to store and manage TCSI (Tertiary Collection of Student Information) extracts, keep historical snapshots, and make the data analysis‑ready for RStudio.

Key capabilities:
- Ingests TCSI CSV extract folders and builds a curated relational schema (dims/facts/bridges).
- Preserves history by tagging every curated row with an extraction timestamp (monthly updates without overwriting prior months).
- Provides a wide, analysis‑ready reporting view to reduce ad‑hoc joining during analysis.
- Offers RStudio examples and an upload wrapper for analysts.

## Repository Layout
- `TCSIExtractDatabaseProject/scripts/load_tcsi.py ` — loader CLI. Scans extract folders, builds staging tables, and upserts curated tables in the SQLite DB.
- `TCSIExtractDatabaseProject/database/schema.sql ` — SQLite schema for curated tables, indexes, and `wide_student_course` view.
- `TCSIExtractDatabaseProject/docs/database_schema_design.md ` — data model and entity relationship outline.
- `TCSIExtractDatabaseProject/docs/database_development_phase.md ` — how to run the loader, validation notes, and monthly update playbook.
- `TCSIExtractDatabaseProject/r/upload_extract.R ` — R wrapper to run the Python loader from RStudio.
- `TCSIExtractDatabaseProject/r/import_examples.R ` — R examples using DBI/dplyr and the wide view.
- `TCSIExtractDatabaseProject/tcsi.db ` — SQLite database created after a successful load (generated artifact).
- `../Deidentified Sample Data ` — two‑month example extracts (input data for testing).
- `../TCSI Extract Database Project Plan.pdf ` — project context and milestone plan (PDF).

## Prerequisites
- Python 3.8+
- `openpyxl` Python package (only required when loading Excel extracts)
- R (optional, for RStudio workflows) with packages: DBI, RSQLite, dplyr.

## Quick Start (load the bundled sample months)
From the repository root:

```
python3 TCSIExtractDatabaseProject/scripts/load_tcsi.py \
  "Deidentified Sample Data/12Mar2025_extracted" \
  "Deidentified Sample Data/09July2025_extracted"
```

What happens:
- Creates/updates `TCSIExtractDatabaseProject/tcsi.db`.
- Writes a row to `etl_load_history` per folder with a JSON summary of staged counts.
- Populates curated tables and the `wide_student_course` view.

> **Tip:** The loader accepts CSV and Excel (`.xlsx`/`.xlsm`) files in each extract directory. Install `openpyxl` (`pip install openpyxl`) if your extracts include Excel workbooks.

To run the same from RStudio:

```
Rscript TCSIExtractDatabaseProject/r/upload_extract.R \
  "Deidentified Sample Data/12Mar2025_extracted" \
  "Deidentified Sample Data/09July2025_extracted"
```

## Using the Database in R
Examples are provided in `TCSIExtractDatabaseProject/r/import_examples.R `.

Basic pattern:
```
library(DBI); library(RSQLite); library(dplyr)
con <- dbConnect(SQLite(), "TCSIExtractDatabaseProject/tcsi.db")
tbl(con, "fact_course_admission") %>%
  left_join(tbl(con, "dim_student"), by = "student_res_key") %>%
  head(5) %>% collect()
```

You can also query the analysis‑ready view:
```
DBI::dbGetQuery(con, "SELECT * FROM wide_student_course LIMIT 5")
```

## Monthly Update Workflow
1. Place the new month’s extract folder locally. Keep its name in the same pattern (e.g., `09July2025_extracted`).
2. Load it with the loader CLI (or R wrapper). The loader derives the timestamp from the folder name and upserts curated tables.
3. Validate row counts (stdout summary) or inspect `etl_load_history`.
4. Back up or promote `tcsi.db` for analysts.

Re‑running for the same folder replaces that month’s snapshot without duplicating rows.

## Documentation
- Schema and entity relationships: `TCSIExtractDatabaseProject/docs/database_schema_design.md `
- Development phase instructions: `TCSIExtractDatabaseProject/docs/database_development_phase.md `
- Project plan (PDF): `../TCSI Extract Database Project Plan.pdf `

## Troubleshooting
- Optional/variant columns: The loader detects missing columns (e.g., `CRICOS`, Mode of Attendance, ATAR, SA/OS‑HELP fee fields) and substitutes `NULL` to stay compatible across vintages.
- Foreign keys: The upsert order is FK‑safe; course‑campus links are filtered to existing courses.
- Character encoding: CSV parsing is UTF‑8 with BOM tolerance.

If something fails, rerun the command and check the console for the specific file/entity. You can safely rerun a month’s folder to refresh its snapshot.
