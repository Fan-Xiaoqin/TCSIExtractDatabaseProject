library(dplyr)
library(lubridate)
library(stringi)
setwd("/Users/judyfan/Desktop/LanguageTools/CapstoneProject/ETL")


# sample data from ChatGPT, only for development
n <- 10
course_data <- data.frame(
  UID5_CoursesResKey = paste0("CRS", sprintf("%03d", 1:n)),
  UID3_CoursesOfStudyResKey = paste0("COS", sprintf("%02d", sample(1:20, n, replace = TRUE))),
  E307_CourseCode = paste0("C", 1000 + 1:n),
  E308_CourseName = sample(c("Algorithms", "Calculus", "Quantum Mechanics", "History"), n, replace = TRUE),
  E596_StandardCourseDuration = sample(1:4, n, replace = TRUE),
  E609_EffectiveFromDate = sample(seq(as.Date("2020-01-01"), as.Date("2024-12-31"), by="day"), n),
  E610_EffectiveToDate = sample(seq(as.Date("2025-01-01"), as.Date("2030-12-31"), by="day"), n)
)
courses_special_interest_data <- data.frame(
  UID30_SpecialInterestCoursesResKey = paste0("SIC", sprintf("%03d", 1:n)),
  UID5_CoursesResKey = course_data$UID5_CoursesResKey, 
  E312_SpecialCourseType = sample(c("Honors", "Elective", "Workshop", "Seminar"), n, replace = TRUE),
  E609_EffectiveFromDate = course_data$E609_EffectiveFromDate,
  E610_EffectiveToDate = course_data$E610_EffectiveToDate
)
course_fields_of_education_data <- data.frame(
  UID48_CourseFieldsOfEducationResKey = paste0("FOE", sprintf("%03d", 1:n)),
  UID5_CoursesResKey = course_data$UID5_CoursesResKey, 
  E461_FieldOfEducationCode = paste0("FOECode", sample(101:200, n)),
  E462_FieldOfEducationSupplementaryCode = sample(1:20, n, replace = TRUE),
  E609_EffectiveFromDate = course_data$E609_EffectiveFromDate,
  E610_EffectiveToDate = course_data$E610_EffectiveToDate
)
course_of_study_data <- data.frame(
  UID3_CoursesOfStudyResKey = paste0("COS", sprintf("%02d", 1:20)),  # 20个方向
  E533_CourseOfStudyCode = paste0("CSC", 101:120),
  E394_CourseOfStudyName = c("Computer Science", "Mathematics", "Physics", "History", "Biology",
  "Chemistry", "Engineering", "Economics", "Law", "Psychology",
  "Philosophy", "Sociology", "Art", "Music", "Design",
  "Architecture", "Business", "Education", "Medicine", "Nursing"),
  E310_CourseOfStudyType = sample(c("Undergraduate", "Postgraduate", "Vocational"), 20, replace = TRUE),
  E350_CourseOfStudyLoad = sample(c("Full-time", "Part-time"), 20, replace = TRUE),
  E455_CombinedCourseOfStudyIndicator = sample(c("Y", "N"), 20, replace = TRUE)
)
course_on_campus_data <- data.frame(
  UID4_CoursesOnCampusResKey = paste0("CC", sprintf("%03d", 1:n)),
  UID5_CoursesResKey = course_data$UID5_CoursesResKey,  # 一对一
  UID2_CampusesResKey = paste0("CMP", sprintf("%03d", 1:n)),
  E525_CampusSuburb = sample(c("Sydney", "Melbourne", "Brisbane", "Perth", "Adelaide"), n, replace = TRUE),
  E644_CampusCountryCode = "AU",
  E559_CampusPostcode = sample(c("2000","3000","4000","5000","6000"), n, replace = TRUE),
  E569_CampusOperationType = sample(c("Full-time", "Part-time"), n, replace = TRUE),
  E570_PrincipalOffshoreDeliveryMode = sample(c("Onshore","Offshore"), n, replace = TRUE),
  E571_OffshoreDeliveryCode = NA_character_,
  E609_EffectiveFromDate = course_data$E609_EffectiveFromDate,
  E610_EffectiveToDate = course_data$E610_EffectiveToDate
)



## filter out columns containing "Provider"
filter_out_provider_cols <- function(df) {
  df <- select(df, -matches("Provider", ignore.case = TRUE))
  return(df)
}
## filter out overlapping columns for course related tables, ensuring each table only has attributes specific to it
## keeps columns for course table as it's a main table
filter_out_overlapping_cols <- function(df1, pk_for_df1, df2 = course_data, pk_for_df2 = pk_for_courses){
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
  course_data, 
  course_of_study_data, 
  course_fields_of_education_data, 
  courses_special_interest_data, 
  course_on_campus_data
)
pk_for_tables <- list(
  'UID5_CoursesResKey', 
  "UID3_CoursesOfStudyResKey", 
  "UID48_CourseFieldsOfEducationResKey", 
  "UID30_SpecialInterestCoursesResKey", 
  "UID4_CoursesOnCampusResKey"
)
files <- c(
  "Courses.csv", 
  "CourseOfStudy.csv", 
  "CourseFieldsOfEducation.csv", 
  "CoursesSpecialInterest.csv", 
  "CourseOnCampus.csv"
)
for (i in seq(tables)) {
  tables[[i]] <- filter_out_provider_cols(tables[[i]])
  if(i == 1 ){
    next
  }
  tables[[i]] <- filter_out_overlapping_cols(tables[[i]], pk_for_tables[[i]])
}

# parent table : child table
# courses : course_of_special_interest, course_on_campus
# course_fields_of_education : courses
# course_of_study : courses
list <- process_parent_child_tables(tables[[1]], pk_for_tables[[1]],tables[[4]], tables[[5]], pk_for_tables[[4]], pk_for_tables[[5]])
tables[[1]] <- list$parent_df
tables[[4]] <- list$child_dfs[[1]]
tables[[5]] <- list$child_dfs[[2]]
list <- process_parent_child_tables(tables[[2]], pk_for_tables[[2]],tables[[1]], pk_for_tables[[1]])
tables[[2]] <- list$parent_df
tables[[1]] <- list$child_dfs[[1]]
list <- process_parent_child_tables(tables[[3]], pk_for_tables[[3]],tables[[1]], pk_for_tables[[1]])
tables[[3]] <- list$parent_df
tables[[1]] <- list$child_dfs[[1]]
create_files(tables[[1]], tables[[2]], tables[[3]], tables[[4]], tables[[5]], files[[1]],  files[[2]], files[[3]], files[[4]],  files[[5]])
# for connecting other tables
courses <- tables[[1]]