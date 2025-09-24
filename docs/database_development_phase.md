# Database Development Phase Deliverables (Week 4–9)

## 1. Schema & Tooling Overview
- Curated schema defined in [`docs/database_schema_design.md`](database_schema_design.md).
- SQLite schema instantiated by [`database/schema.sql`](database/schema.sql).
- Loader pipeline implemented in [`scripts/load_tcsi.py`](scripts/load_tcsi.py) builds staging tables on the fly, enforces dimensional integrity, and populates the curated layer plus the `wide_student_course` reporting view.

## 2. Running the Loader
### Python CLI
```
python3 scripts/load_tcsi.py "Deidentified Sample Data/12Mar2025_extracted" "Deidentified Sample Data/09July2025_extracted"
```
Key behaviour:
- Derives the extraction timestamp from the folder name (e.g. `12Mar2025_extracted → 2025-03-12T00:00:00Z`).
- Creates/updates `tcsi.db` in the repository root.
- Writes a load audit trail to `etl_load_history` with a JSON snapshot of staging row counts.

### RStudio Wrapper
R users can stay in RStudio via:
```
Rscript r/upload_extract.R /path/to/extract_dir
```
The wrapper resolves `python3` (or `$PYTHON`) and calls the same loader. Run without arguments to ingest the bundled two-month sample.

## 3. Post-load Validation
After loading the March & July 2025 samples the curated row counts are:

| Table | Rows |
| --- | ---: |
| `dim_provider` | 1 |
| `dim_student` | 50 |
| `bridge_student_contact` | 100 |
| `bridge_student_citizenship` | 50 |
| `bridge_student_disability` | 28 |
| `dim_course_of_study` | 1,433 |
| `dim_course` | 2,684 |
| `dim_campus` | 47 |
| `bridge_course_campus` | 715 |
| `bridge_course_field_of_education` | 3,846 |
| `fact_course_admission` | 117 |
| `fact_course_prior_credit` | 11 |
| `fact_course_specialisation` | 98 |
| `fact_unit_enrolment` | 1,255 |
| `fact_unit_enrolment_aou` | 1,334 |
| `fact_student_loan` | 173 |
| `fact_scholarship` | 164 |
| `fact_course_fee` | 1,077 |
| `fact_aggregated_award` | 0 (no records in sample)

Audit queries (`python3 - <<'PY'` or R `DBI`) confirm `wide_student_course` returns joined snapshots with the expected extraction timestamp alignment.

## 4. RStudio Integration Examples
[`r/import_examples.R`](r/import_examples.R) demonstrates how to:
1. Connect via `DBI::dbConnect(RSQLite::SQLite(), "db_path/tcsi.db")`.
2. Make sure your connection object exists `con <- DBI::dbConnect(RSQLite::SQLite(), "TCSIExtractDatabaseProject/tcsi.db")`
3. List curated tables (`dbListTables`).
4. Use `dplyr` to join `fact_course_admission` with `dim_student`.
5. Fetch the `wide_student_course` view for KPI-ready analysis.
Set `TCSI_DB_PATH` before sourcing if the database lives elsewhere.

## 5. Monthly Update Playbook
1. **Extract arrival** – drop the new month’s folder under a staging area (keep the original folder name to preserve the timestamp parser).
2. **Load** – run `scripts/load_tcsi.py` with the folder(s). The script automatically appends history without overwriting earlier months.
3. **Validate** – review stdout row counts. Optionally compare `etl_load_history.notes` with expectations or run targeted `COUNT(*)` checks.
4. **Backup** – archive the updated `tcsi.db` (e.g., copy to date-stamped location or promote to the team’s shared environment).
5. **Publish** – R analysts can refresh their connections by re-running their queries; no further changes are required if they depend on curated tables or the `wide_student_course` view.
6. **Rollback plan** – because loads are idempotent per extraction timestamp, rerunning the loader for the same folder will replace the previous run without duplicates.

## 6. Outstanding Enhancements (tracked for Week 10+)
- Extend the curated layer to include the `HEPHDREndUsersEngagement` and `Undetermined*` staging tables once business rules are defined.
- Add automated validation tests (row deltas, FK checks) as GitHub Actions or R Markdown QA report.
- Surface standard reports/views for common KPIs (completion rates, HELP debt trends) building on `wide_student_course`.

These artefacts complete the Database Development Phase requirements: schema design, implemented database with historical load support, tooling for ingesting monthly extracts, and RStudio-ready examples.
