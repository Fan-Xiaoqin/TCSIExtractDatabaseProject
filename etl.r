library(dplyr)

## filter out columns containing "Provider"
filter_out_provider_cols <- function(df) {
  df <- select(df, -matches("Provider", ignore.case = TRUE))
  return(df)
}

## main tables: students, courses, course admissions, unit enrolments
## filter out overlapping columns for related tables related to main tables, ensuring each table only has attributes specific to it
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
      stop(paste("Primary key", pks_for_children[[i]], "not found in the dataframe for child table"))
    }
    # Columns to keep
    colnames_for_parent <- setdiff(colnames(parent_df),pks_for_children[[i]])
    colnames_for_child <- unique(c(colnames(child_dfs[[i]]), pk_for_parent))

    # Join tables
    if(pk_for_parent %in% colnames(child_dfs[[i]])){
      parent_df <- parent_df %>% select(-any_of(pks_for_children[[i]]))  
      jointed_tb <- full_join(parent_df, child_dfs[[i]] , by = pk_for_parent)
    }
    else {jointed_tb <- full_join(parent_df, child_dfs[[i]] , by = pks_for_children[[i]])}
    parent_df <- jointed_tb[,colnames_for_parent, drop = FALSE] %>%
    select(all_of(pk_for_parent), everything())
    child_dfs[[i]] <- jointed_tb[,colnames_for_child, drop = FALSE] %>%
    select(all_of(pks_for_children[[i]]), everything())
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

students_related_entities <- list(
  list(data = students_data, pk = "UID8_StudentsResKey"),
  list(data = disabilities_data, pk = "UID11_StudentDisabilitiesResKey"),
  list(data = citizenships_data, pk = "UID10_StudentCitizenshipsResKey"),
  list(data = common_wealth_scholarships_data, pk = "UID12_StudentCommonwealthScholarshipsResKey")
)

courses_related_entities <- list(
  list(data = course_data, pk = "UID5_CoursesResKey"),
  list(data = course_of_study_data, pk = "UID3_CoursesOfStudyResKey"),
  list(data = course_fields_of_education_data, pk = "UID48_CourseFieldsOfEducationResKey"),
  list(data = courses_special_interest_data, pk = "UID30_SpecialInterestCoursesResKey"),
  list(data = course_on_campus_data, pk = "UID4_CoursesOnCampusResKey")
)

course_admission_related_entities <- list(
  list(data = course_admissions_data, pk = "UID15_CourseAdmissionsResKey"),
  list(data = course_specialisations_data, pk = "UID33_CourseSpecialisationsResKey"),
  list(data = rtp_scholarships_data, pk = "UID35_RTPScholarshipsResKey"),
  list(data = rtp_stipends_data, pk = "UID18_RTPStipendsResKey"),
  list(data = HDRendUserEngagement_data, pk = "UID37_HDREndUserEngagementsResKey"),
  list(data = basis_for_admission_data, pk = "UID17_BasisForAdmissionResKey"),
  list(data = course_prior_credits_data, pk = "UID32_CoursePriorCreditsResKey")
)

unit_enrollments_related_entities <- list(
  list(data = unit_enrolments_data, pk = "UID16_UnitEnrolmentsResKey"),
  list(data = units_aou, pk = "UID19_UnitEnrolmentAOUsResKey")
)

files_list <- c(
  "Students.csv", 
  "Disabilities.csv", 
  "Citizenships.csv", 
  "CommonWealthScholarships.csv",
  "Courses.csv", 
  "CourseOfStudy.csv", 
  "CourseFieldsOfEducation.csv", 
  "CoursesSpecialInterest.csv", 
  "CourseOnCampus.csv",
  "CourseAdmissions.csv",
  "CourseSpecialisations.csv",
  "RTPScholarships.csv",
  "RTPStipends.csv",
  "HDREndUserEngagements.csv",
  "BasisForAdmission.csv",
  "CoursePriorCredits.csv",
  "UnitEnrolments.csv",
  "UnitsAOU.csv"
)

# filter out provider columns
# filter out overlapping columns for tables related to main tables
# students related tables
for(i in seq_along(students_related_entities)) {
  students_related_entities[[i]]$data <- filter_out_provider_cols(students_related_entities[[i]]$data)
  if(i == 1){next}
  students_related_entities[[i]]$data <- filter_out_overlapping_cols(
    students_related_entities[[i]]$data, students_related_entities[[i]]$pk, 
    students_related_entities[[1]]$data, students_related_entities[[1]]$pk
  )
}
# courses related tables
for( i in seq_along(courses_related_entities)) {
  courses_related_entities[[i]]$data <- filter_out_provider_cols(courses_related_entities[[i]]$data)
  if(i == 1 ){next}
  courses_related_entities[[i]]$data <- filter_out_overlapping_cols(
  courses_related_entities[[i]]$data, courses_related_entities[[i]]$pk,
  courses_related_entities[[1]]$data, courses_related_entities[[1]]$pk
  )
}
# course admissions related tables
for (i in seq_along(course_admission_related_entities)) {
  course_admission_related_entities[[i]]$data <- filter_out_provider_cols(course_admission_related_entities[[i]]$data)
  if(i == 1 ){next}
  course_admission_related_entities[[i]]$data <- filter_out_overlapping_cols(
  course_admission_related_entities[[i]]$data, course_admission_related_entities[[i]]$pk,
  course_admission_related_entities[[1]]$data, course_admission_related_entities[[1]]$pk
  )
}
course_admission_related_entities[[1]]$data <- filter_out_overlapping_cols(
  course_admission_related_entities[[1]]$data, course_admission_related_entities[[1]]$pk,
  courses_related_entities[[1]]$data, courses_related_entities[[1]]$pk
)
course_admission_related_entities[[1]]$data <- filter_out_overlapping_cols(
  course_admission_related_entities[[1]]$data, course_admission_related_entities[[1]]$pk,
  students_related_entities[[1]]$data, students_related_entities[[1]]$pk
)

# unit enrolments related tables
for (i in seq_along(unit_enrollments_related_entities)) {
  unit_enrollments_related_entities[[i]]$data <- filter_out_provider_cols(unit_enrollments_related_entities[[i]]$data)
  if(i == 1 ){next}
  unit_enrollments_related_entities[[i]]$data <- filter_out_overlapping_cols(
    unit_enrollments_related_entities[[i]]$data, unit_enrollments_related_entities[[i]]$pk,
    unit_enrollments_related_entities[[1]]$data, unit_enrollments_related_entities[[1]]$pk
  )
}
unit_enrollments_related_entities[[1]]$data <- filter_out_overlapping_cols(
  unit_enrollments_related_entities[[1]]$data, unit_enrollments_related_entities[[1]]$pk,
  course_admission_related_entities[[1]]$data, course_admission_related_entities[[1]]$pk
)


# process parent tables and child tables
# students related tables
# parent table : child tables
# student : disabilities, citizenships, common_wealth_scholarships
students_related_dfs <- process_parent_child_tables(
  students_related_entities[[1]]$data, students_related_entities[[1]]$pk,
  students_related_entities[[2]]$data, students_related_entities[[3]]$data, students_related_entities[[4]]$data,
  students_related_entities[[2]]$pk, students_related_entities[[3]]$pk, students_related_entities[[4]]$pk
)
students <- students_related_dfs$parent_df
disabilities <- students_related_dfs$child_dfs[[1]]
citizenships <- students_related_dfs$child_dfs[[2]]
common_wealth_scholarships <- students_related_dfs$child_dfs[[3]]

# course related tables
# parent table : child tables
# courses : course_of_special_interest, course_on_campus
# course_fields_of_education : courses
# course_of_study : courses
courses_related_dfs_1 <- process_parent_child_tables(
  courses_related_entities[[1]]$data, courses_related_entities[[1]]$pk,
  courses_related_entities[[4]]$data, courses_related_entities[[5]]$data,courses_related_entities[[4]]$pk, courses_related_entities[[5]]$pk
)
courses_related_dfs_2 <- process_parent_child_tables(
  courses_related_entities[[3]]$data, courses_related_entities[[3]]$pk,
  courses_related_dfs_1$parent_df, courses_related_entities[[1]]$pk
)
courses_related_dfs_3 <- process_parent_child_tables(
  courses_related_entities[[2]]$data, courses_related_entities[[2]]$pk,
  courses_related_dfs_2$child_dfs[[1]], courses_related_entities[[1]]$pk
)
course_of_special_interest <- courses_related_dfs_1$child_dfs[[1]]
course_on_campus <- courses_related_dfs_1$child_dfs[[2]]
course_fields_of_education <- courses_related_dfs_2$parent_df
courses <- courses_related_dfs_3$child_dfs[[1]]
course_of_study <- courses_related_dfs_3$parent_df

# course admissions related tables
# parent table : child tables
# course_admissions : course_specialisations, rtp_scholarships, rtp_stipends, hdr_end_user_engagement, basis_for_admission, course_prior_credits
# courses : course_admissions
# students : course_admissions
course_admission_related_dfs <- process_parent_child_tables(
  course_admission_related_entities[[1]]$data, course_admission_related_entities[[1]]$pk,
  course_admission_related_entities[[2]]$data, course_admission_related_entities[[3]]$data,
  course_admission_related_entities[[4]]$data, course_admission_related_entities[[5]]$data,
  course_admission_related_entities[[6]]$data, course_admission_related_entities[[7]]$data,
  course_admission_related_entities[[2]]$pk, course_admission_related_entities[[3]]$pk,
  course_admission_related_entities[[4]]$pk, course_admission_related_entities[[5]]$pk,
  course_admission_related_entities[[6]]$pk, course_admission_related_entities[[7]]$pk
)
course_admission_related_dfs_2 <- process_parent_child_tables(
  courses, courses_related_entities[[1]]$pk,
  course_admission_related_dfs$parent_df, course_admission_related_entities[[1]]$pk
)
course_admission_related_dfs_3 <- process_parent_child_tables(
  students, students_related_entities[[1]]$pk,
  course_admission_related_dfs_2$child_dfs[[1]], course_admission_related_entities[[1]]$pk
)
course_specialisations <- course_admission_related_dfs$child_dfs[[1]]
rtp_scholarships <- course_admission_related_dfs$child_dfs[[2]]
rtp_stipends <- course_admission_related_dfs$child_dfs[[3]]
hdr_end_user_engagement <- course_admission_related_dfs$child_dfs[[4]]
basis_for_admission <- course_admission_related_dfs$child_dfs[[5]]
course_prior_credits <- course_admission_related_dfs$child_dfs[[6]]
courses <- course_admission_related_dfs_2$parent_df
students <- course_admission_related_dfs_3$parent_df
course_admissions <- course_admission_related_dfs_3$child_dfs[[1]]

# unit enrollments related tables
# parent table : child tables
# unit_enrollments : units_aou
# course_admissions : unit_enrollments
unit_enrollments_related_dfs <- process_parent_child_tables(
  unit_enrollments_related_entities[[1]]$data, unit_enrollments_related_entities[[1]]$pk,
  unit_enrollments_related_entities[[2]]$data, unit_enrollments_related_entities[[2]]$pk
)
unit_enrollments_related_entities_dfs_2 <- process_parent_child_tables(
  course_admissions, course_admission_related_entities[[1]]$pk,
  unit_enrollments_related_dfs$parent_df, unit_enrollments_related_entities[[1]]$pk
)
units_aou <- unit_enrollments_related_dfs$child_dfs[[1]]
course_admissions <- unit_enrollments_related_entities_dfs_2$parent_df
unit_enrollments <- unit_enrollments_related_entities_dfs_2$child_dfs[[1]]

