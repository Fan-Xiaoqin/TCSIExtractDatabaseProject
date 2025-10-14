# Install Required R Packages for TCSI ETL Project

cat("========================================\n")
cat("INSTALLING R PACKAGES\n")
cat("========================================\n\n")

# List of required packages
packages <- c("shiny", "shinydashboard", "DBI", "RPostgres", "shinyFiles",
              "dplyr", "readr", "DT", "openxlsx", "lubridate", "getPass", "stringr")


# Install packages
for (pkg in packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("Installing", pkg, "...\n")
    install.packages(pkg, repos = "https://cloud.r-project.org", quiet = FALSE)
    cat(pkg, "installed successfully!\n\n")
  } else {
    cat(pkg, "is already installed.\n\n")
  }
}

cat("========================================\n")
cat("INSTALLATION COMPLETE\n")
cat("========================================\n")
cat("\nAll required packages are now installed.\n")
