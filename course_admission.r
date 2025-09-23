n <- 10
course_admissions_data <- data.frame(
  UID1_ProvidersResKey = paste0("PRV", sprintf("%03d", sample(1:20, n, replace = TRUE))),
  E306_ProviderCode = paste0("P", sample(100:999, n, replace = TRUE)),
  E781_ProviderType = sample(c("University", "College", "Institute", "HighSchool"), n, replace = TRUE),
  UID8_StudentsResKey = paste0("STU", sprintf("%04d", sample(1:200, n, replace = TRUE))),
  E313_StudentIdentificationCode = paste0("SID", sprintf("%05d", sample(1:500, n, replace = TRUE))),
  E488_CHESSN = paste0("CH", sprintf("%06d", sample(1:500, n, replace = TRUE))),
  UID15_CourseAdmissionsResKey = paste0("CA", sprintf("%04d", sample(1:200, n, replace = TRUE))),
  UID5_CoursesResKey = paste0("CRS", sprintf("%03d", sample(1:50, n, replace = TRUE))),
  E307_CourseCode = paste0("C", sample(1000:1999, n, replace = TRUE)),
  E308_CourseName = sample(c("Algorithms", "Calculus", "Physics", "History"), n, replace = TRUE),
  E533_CourseOfStudyCode = paste0("COS", sample(100:199, n, replace = TRUE)),
  E310_CourseOfStudyType = sample(c("Undergraduate", "Postgraduate", "Vocational"), n, replace = TRUE),
  E534_CourseOfStudyCommencementDate = sample(seq(as.Date('2020-01-01'), as.Date('2024-12-31'), by="day"), n, replace = TRUE),
  UID37_HDREndUserEngagementsResKey = paste0("ENG", sprintf("%04d", sample(1:100, n, replace = TRUE))),
  E593_HDREndUserEngagementCode = sample(c("Research", "Thesis", "Project"), n, replace = TRUE),
  E609_HDREndUserEngageFromDate = sample(seq(as.Date('2021-01-01'), as.Date('2024-12-31'), by="day"), n, replace = TRUE),
  E610_HDREndUserEngageToDate = sample(seq(as.Date('2022-01-01'), as.Date('2025-12-31'), by="day"), n, replace = TRUE),
  E798_HDRDaysOfEngagement = sample(1:365, n, replace = TRUE)
)
course_specialisations_data <- data.frame(
  UID1_ProvidersResKey = paste0("PRV", sprintf("%03d", sample(1:20, n, replace = TRUE))),
  E306_ProviderCode = paste0("P", sample(100:999, n, replace = TRUE)),
  E781_ProviderType = sample(c("University", "College", "Institute", "HighSchool"), n, replace = TRUE),
  UID15_CourseAdmissionsResKey = paste0("CA", sprintf("%04d", sample(1:200, n, replace = TRUE))),
  E313_StudentIdentificationCode = paste0("SID", sprintf("%05d", sample(1:500, n, replace = TRUE))),
  E307_CourseCode = paste0("C", sample(1000:1999, n, replace = TRUE)),
  E534_CourseOfStudyCommencementDate = sample(seq(as.Date('2020-01-01'), as.Date('2024-12-31'), by="day"), n, replace = TRUE),
  UID47_AggregateAwardsResKey = paste0("AA", sprintf("%04d", sample(1:100, n, replace = TRUE))),
  UID33_CourseSpecialisationsResKey = paste0("CS", sprintf("%04d", sample(1:100, n, replace = TRUE))),
  E463_SpecialisationCode = paste0("SPC", sprintf("%03d", sample(1:50, n, replace = TRUE)))
)
rtp_scholarships_data <- data.frame(
  UID1_ProvidersResKey = paste0("PRV", sprintf("%03d", sample(1:20, n, replace = TRUE))),
  E306_ProviderCode = paste0("P", sample(100:999, n, replace = TRUE)),
  E781_ProviderType = sample(c("University", "College", "Institute", "HighSchool"), n, replace = TRUE),
  UID8_StudentsResKey = paste0("STU", sprintf("%04d", sample(1:200, n, replace = TRUE))),
  E313_StudentIdentificationCode = paste0("SID", sprintf("%05d", sample(1:500, n, replace = TRUE))),
  E488_CHESSN = paste0("CH", sprintf("%06d", sample(1:500, n, replace = TRUE))),
  UID15_CourseAdmissionsResKey = paste0("CA", sprintf("%04d", sample(1:200, n, replace = TRUE))),
  UID5_CoursesResKey = paste0("CRS", sprintf("%03d", sample(1:50, n, replace = TRUE))),
  E307_CourseCode = paste0("C", sample(1000:1999, n, replace = TRUE)),
  E308_CourseName = sample(c("Algorithms", "Calculus", "Physics", "History"), n, replace = TRUE),
  E533_CourseOfStudyCode = paste0("COS", sample(100:199, n, replace = TRUE)),
  E310_CourseOfStudyType = sample(c("Undergraduate", "Postgraduate", "Vocational"), n, replace = TRUE),
  E534_CourseOfStudyCommencementDate = sample(seq(as.Date('2020-01-01'), as.Date('2024-12-31'), by="day"), n, replace = TRUE),
  UID35_RTPScholarshipsResKey = paste0("RTP", sprintf("%04d", sample(1:100, n, replace = TRUE))),
  E487_RTPScholarshipType = sample(c("Full", "Partial", "Top-up"), n, replace = TRUE),
  E609_RTPScholarshipFromDate = sample(seq(as.Date('2021-01-01'), as.Date('2024-12-31'), by="day"), n, replace = TRUE),
  E610_RTPScholarshipToDate = sample(seq(as.Date('2022-01-01'), as.Date('2025-12-31'), by="day"), n, replace = TRUE)
)
rtp_stipends_data <- data.frame(
  UID1_ProvidersResKey = paste0("PRV", sprintf("%03d", sample(1:20, n, replace = TRUE))),
  E306_ProviderCode = paste0("P", sample(100:999, n, replace = TRUE)),
  E781_ProviderType = sample(c("University", "College", "Institute", "HighSchool"), n, replace = TRUE),
  UID15_CourseAdmissionsResKey = paste0("CA", sprintf("%04d", sample(1:200, n, replace = TRUE))),
  E313_StudentIdentificationCode = paste0("SID", sprintf("%05d", sample(1:500, n, replace = TRUE))),
  E307_CourseCode = paste0("C", sample(1000:1999, n, replace = TRUE)),
  E534_CourseOfStudyCommencementDate = sample(seq(as.Date('2020-01-01'), as.Date('2024-12-31'), by="day"), n, replace = TRUE),
  UID18_RTPStipendsResKey = paste0("STP", sprintf("%04d", sample(1:100, n, replace = TRUE))),
  E623_RTPStipendAmount = sample(seq(5000, 50000, by=500), n, replace = TRUE),
  E415_ReportingYear = sample(2020:2025, n, replace = TRUE)
)
basis_for_admission_data <- data.frame(
  UID1_ProvidersResKey = paste0("PRV", sprintf("%03d", sample(1:20, n, replace = TRUE))),
  E306_ProviderCode = paste0("P", sample(100:999, n, replace = TRUE)),
  E781_ProviderType = sample(c("University", "College", "Institute", "HighSchool"), n, replace = TRUE),
  UID15_CourseAdmissionsResKey = paste0("CA", sprintf("%04d", sample(1:150, n, replace = TRUE))),
  E313_StudentIdentificationCode = paste0("SID", sprintf("%05d", sample(1:500, n, replace = TRUE))),
  E307_CourseCode = paste0("C", sample(1000:1999, n, replace = TRUE)),
  E534_CourseOfStudyCommencementDate = sample(seq(as.Date('2015-01-01'), as.Date('2025-12-31'), by="day"), n, replace = TRUE),
  UID17_BasisForAdmissionResKey = paste0("BFA", sprintf("%04d", sample(1:50, n, replace = TRUE))),
  E327_BasisForAdmissionCode = sample(c("ATAR", "VET", "International", "Other"), n, replace = TRUE)
)
course_prior_credits_data <- data.frame(
  UID1_ProvidersResKey = paste0("PRV", sprintf("%03d", sample(1:10, n, replace = TRUE))),
  E306_ProviderCode = paste0("P", sample(100:999, n, replace = TRUE)),
  E781_ProviderType = sample(c("University", "College", "Institute", "HighSchool"), n, replace = TRUE),
  UID15_CourseAdmissionsResKey = paste0("CA", sprintf("%03d", sample(1:30, n, replace = TRUE))),
  E313_StudentIdentificationCode = paste0("SID", sprintf("%04d", sample(1:50, n, replace = TRUE))),
  E307_CourseCode = paste0("C", sample(1000:1100, n, replace = TRUE)),
  E534_CourseOfStudyCommencementDate = sample(seq(as.Date('2020-01-01'), as.Date('2023-12-31'), by="day"), n, replace = TRUE),
  UID32_CoursePriorCreditsResKey = paste0("CPC", sprintf("%03d", 1:n)),
  E560_CreditUsedValue = sample(c(0.25, 0.5, 0.75, 1), n, replace = TRUE),
  E561_CreditBasis = sample(c("Previous Course", "Work Experience", "Other"), n, replace = TRUE),
  E566_CreditProviderCode = paste0("CP", sample(200:299, n, replace = TRUE))
)

## filter out columns containing "Provider"
filter_out_provider_cols <- function(df) {
  df <- select(df, -matches("Provider", ignore.case = TRUE))
  return(df)
}
## filter out overlapping columns for course related tables, ensuring each table only has attributes specific to it
## keeps columns for course table as it's a main table
filter_out_overlapping_cols <- function(df1, pk_for_df1, df2, pk_for_df2){
  overlapping_cols <- intersect(colnames(df1),colnames(df2) ) 
  filtered_cols <- setdiff(overlapping_cols, c(pk_for_df1, pk_for_df2))  
  df1 <- df1 %>% select(-all_of(filtered_cols))
  return(df1)
}
# process parent table and its child tables, write them to csv files
# assumming the parameter format is: parent_table,parent_pk, child_table1, child_pk1, child_table2, child_pk2, ...
process_parent_child_tables <- function(parent_df, pk_for_parent, ...){
  args <- list(...)
  # Check if args length is even
  mid = length(args)/2
  if(length(args) %% 2 != 0){stop("The parameters should be parent table and its primary key, and child tables followed by their primary keys")}
  # Ensure primary key exist
  if(!(pk_for_parent %in% colnames(parent_df))){stop("Primary key for parent table not found in the dataframe")}
  child_dfs <- args[seq(1, mid)]
  pks_for_children <- args[seq(mid+1, length(args))]
  for(i in seq_along(child_dfs)){
    # Ensure primary keys exist
    if(!(pks_for_children[[i]] %in% colnames(child_dfs[[i]]))){
      stop(paste("Primary key for child table", child_dfs[[i]], "not found in the dataframe"))
    }
    # Columns to keep
    colnames_for_parent <- setdiff(colnames(parent_df),pks_for_children[[i]])
    colnames_for_child <- unique(c(colnames(child_dfs[[i]]), pk_for_parent))

    # Join tables
    if(pk_for_parent %in% colnames(child_dfs[[i]])){jointed_tb <- full_join(parent_df, child_dfs[[i]] , by = pk_for_parent)}
    else {jointed_tb <- full_join(parent_df, child_dfs[[i]] , by = pks_for_children[[i]])}
    parent_df <- jointed_tb[,colnames_for_parent] %>%
    select(pk_for_parent, everything())
    child_dfs[[i]] <- jointed_tb[,colnames_for_child] %>%
    select(pks_for_children[[i]], everything())
  }
  return(list(parent_df = parent_df, child_dfs = child_dfs))
}
# create files for tables, the parameter is many dataframes followed by their file names
create_files <- function(...){
  args <- list(...)
  mid <- length(args)/2
  if(length(args) %% 2 != 0){stop("The parameters should be dataframes followed by their file names")}
  for(i in seq(1,mid)){
    write.csv(args[[i]], file = file.path(getwd(), as.character(args[[i+mid]])), row.names = FALSE)
  }
}

# main program
tables <- list(
    list(data = course_admissions_data, pk = "UID15_CourseAdmissionsResKey"),
    list(data = course_specialisations_data, pk = "UID33_CourseSpecialisationsResKey"),
    list(data = rtp_scholarships_data, pk = "UID35_RTPScholarshipsResKey"),
    list(data = rtp_stipends_data, pk = "UID18_RTPStipendsResKey"),
    list(data = basis_for_admission_data, pk = "UID17_BasisForAdmissionResKey"),
    list(data = course_prior_credits_data, pk = "UID32_CoursePriorCreditsResKey")
)
files <- c("CourseAdmissions.csv", "CourseSpecialisations.csv", "RTPScholarships.csv", "RTPStipends.csv", "BasisForAdmission.csv", "CoursePriorCredits.csv")
# filter out provider columns and overlapping columns
for(i in seq_along(tables)){
    tables[[i]]$data <- filter_out_provider_cols(tables[[i]]$data)
    if(i>1){
   tables[[i]]$data <- filter_out_overlapping_cols(tables[[i]]$data, tables[[i]]$pk, tables[[1]]$data, tables[[1]]$pk)
   }
}
# process parent and child tables
list_dfs <- process_parent_child_tables(tables[[1]]$data, tables[[1]]$pk, tables[[2]]$data, tables[[3]]$data, tables[[4]]$data, tables[[5]]$data, tables[[6]]$data, tables[[2]]$pk, tables[[3]]$pk, tables[[4]]$pk, tables[[5]]$pk, tables[[6]]$pk)
# create files
create_files(list_dfs$parent_df, list_dfs$child_dfs[[1]], list_dfs$child_dfs[[2]], list_dfs$child_dfs[[3]], list_dfs$child_dfs[[4]], list_dfs$child_dfs[[5]], files[1], files[2], files[3], files[4], files[5], files[6])