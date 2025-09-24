#!/usr/bin/env Rscript
#' Upload one or more TCSI extract directories into the local SQLite database.
#'
#' Usage: Rscript r/upload_extract.R /path/to/extract_dir [/path/to/another]
#'
#' The script is a thin wrapper around `scripts/load_tcsi.py` so R users can
#' stay inside RStudio. It locates `python3` by default, but respects the
#' `PYTHON` environment variable if you need a different interpreter.

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  message("No extract directory supplied. Using bundled two-month samples as a demo.")
  args <- c(
    file.path("Deidentified Sample Data", "12Mar2025_extracted"),
    file.path("Deidentified Sample Data", "09July2025_extracted")
  )
}

missing <- args[!file.exists(args)]
if (length(missing) > 0) {
  stop("These directories do not exist: ", paste(missing, collapse = ", "))
}

python <- Sys.getenv("PYTHON", unset = "python3")
loader <- file.path("scripts", "load_tcsi.py")
if (!file.exists(loader)) {
  stop("Expected loader script not found at ", loader)
}

cmd_args <- c(loader, args)
status <- system2(python, cmd_args)
if (!identical(status, 0L)) {
  stop("Load script returned non-zero status: ", status)
}

message("✓ Extract(s) uploaded successfully. The database is now ready in tcsi.db.")
