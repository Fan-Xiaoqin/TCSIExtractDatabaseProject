# This script handles student and its subclass (only for citizenships and disabilities)

# sample data, only for development
students_data <- data.frame(
  UID1_ProvidersResKey = "P001",
  E306_ProviderCode = "306",
  E781_ProviderType = "University",
  UID8_StudentsResKey = "S001",
  E313_StudentIdentificationCode = "STU12345",
  E488_CHESSN = "123456789",
  E584_USI = "USI0001234",
  A170_USIVerificationStatus = "Verified",
  A167_TFNVerificationStatus = "Verified",
  E314_DateOfBirth = as.Date("2000-05-15"),
  E402_StudentFamilyName = "Wang",
  E403_StudentGivenNameFirst = "Li",
  E404_StudentGivenNameOthers = "Ming",
  E410_ResidentialAddressLine1 = "123 Main Street",
  E469_ResidentialAddressSuburb = "Perth",
  E320_ResidentialAddressPostcode = "6000",
  E470_ResidentialAddressState = "WA",
  E658_ResidentialAddressCountryCode = "AU",
  E787_FirstResidentialAddressLine1 = "45 First St",
  E789_FirstResidentialAddressSuburb = "Fremantle",
  E790_FirstResidentialAddressPostcode = "6160",
  E791_FirstResidentialAddressState = "WA",
  E659_FirstResidentialAddressCountryCode = "AU",
  E319_TermResidencePostcode = "6001",
  E661_TermResidenceCountryCode = "AU",
  E315_GenderCode = "M",
  E316_ATSICode = "N",
  E346_CountryOfBirthCode = "036",  # 036 = Australia
  E347_ArrivalInAustraliaYear = 2005,
  E348_LanguageSpokenAtHomeCode = "1201", # Mandarin
  E572_YearLeftSchool = 2018,
  E612_LevelLeftSchool = "12",
  E573_HighestEducationParent1 = "Bachelor",
  E574_HighestEducationParent2 = "Diploma",
  stringsAsFactors = FALSE
)
citizenships_data <- data.frame(
  UID1_ProvidersResKey = "P001",
  E306_ProviderCode = "306",
  E781_ProviderType = "University",
  UID8_StudentsResKey = "S001",
  E313_StudentIdentificationCode = "ST12345",
  E488_CHESSN = "123456789",
  UID10_StudentCitizenshipsResKey = "CIT001",
  E358_CitizenResidentCode = "AU",
  E609_EffectiveFromDate = as.Date("2020-01-01"),
  E610_EffectiveToDate = as.Date("2025-12-31"),
  stringsAsFactors = FALSE
)
disabilities_data <- data.frame(
  UID1_ProvidersResKey = c("P001", "P002", "P003"),
  E306_ProviderCode = c("PRV1", "PRV2", "PRV3"),
  E781_ProviderType = c("TypeA", "TypeB", "TypeC"),
  UID8_StudentsResKey = c("S001", "S002", "S003"),
  E313_StudentIdentificationCode = c("ID001", "ID002", "ID003"),
  E488_CHESSN = c("CH001", "CH002", "CH003"),
  UID11_StudentDisabilitiesResKey = c("D001", "D002", "D003"),
  E615_DisabilityCode = c("DISA", "DISB", "DISC"),
  E609_EffectiveFromDate = as.Date(c("2025-01-01", "2025-02-01", "2025-03-01")),
  E610_EffectiveToDate = as.Date(c("2025-12-31", "2025-12-31", "2025-12-31"))
)

# Alternatively, you can load the data form local device
# read data from local device
# student_path = <path>
# citizenship_path = <path>
# disabilities_path = <path>
# students_data = read.sv(student_path)
# citizenships_data = read.csv(citizenship_path)
# disabilities_data = read.csv(disabilities_data)

# process data
student_cols_to_keep <- c(
  'UID8_StudentsResKey','E313_StudentIdentificationCode','E488_CHESSN',
  'E584_USI','A170_USIVerificationStatus','A167_TFNVerificationStatus',
  'E314_DateOfBirth','E402_StudentFamilyName','E403_StudentGivenNameFirst',
  'E404_StudentGivenNameOthers','E410_ResidentialAddressLine1',
  'E469_ResidentialAddressSuburb','E320_ResidentialAddressPostcode',
  'E470_ResidentialAddressState','E658_ResidentialAddressCountryCode',
  'E787_FirstResidentialAddressLine1','E789_FirstResidentialAddressSuburb',
  'E790_FirstResidentialAddressPostcode','E791_FirstResidentialAddressState',
  'E659_FirstResidentialAddressCountryCode','E319_TermResidencePostcode',
  'E661_TermResidenceCountryCode','E315_GenderCode','E316_ATSICode',
  'E346_CountryOfBirthCode','E347_ArrivalInAustraliaYear',
  'E348_LanguageSpokenAtHomeCode','E572_YearLeftSchool','E612_LevelLeftSchool',
  'E573_HighestEducationParent1','E574_HighestEducationParent2'
)
students_data <- students_data[,student_cols_to_keep]
# a function to process superclass and subclass
filter_columns <- function(superclass, subclass, primary_key_for_superclass) {
  super_columns <- setdiff(colnames(superclass), primary_key_for_superclass)
  subclass_filtered <- subclass %>%
    select(-any_of(super_columns))
  return(subclass_filtered)
}
# primary keys
pk_for_students = "UID8_StudentsResKey"
pk_for_citizenships = "UID10_StudentCitizenshipsResKey"
pk_for_disabilities = "UID11_StudentDisabilitiesResKey"
# a data frame for citizenships
citizenships <- filter_columns(students_data, citizenships_data, pk_for_students)
# a data frame for disabilities
disabilities <- filter_columns(students_data, disabilities_data, pk_for_students)

# handle address data frame
first_residential_address_cols_to_keep <- c(
  'E787_FirstResidentialAddressLine1','E789_FirstResidentialAddressSuburb',
  'E790_FirstResidentialAddressPostcode','E791_FirstResidentialAddressState',
  'E659_FirstResidentialAddressCountryCode')
residential_address_cols_to_keep <- c(
  'E410_ResidentialAddressLine1',
  'E469_ResidentialAddressSuburb','E320_ResidentialAddressPostcode',
  'E470_ResidentialAddressState','E658_ResidentialAddressCountryCode')
residential_address <- students_data[, residential_address_cols_to_keep
] 
first_residential_address <- students_data[, first_residential_address_cols_to_keep
  ]
address_cols <- c(
     "AddressLine", 'Suburb', "Postcode", "State", "CountryCode"
)
colnames(first_residential_address) <- address_cols
colnames(residential_address) <- address_cols
# address is a dataframe for address 
address <- rbind(residential_address, first_residential_address)
address$AddressKey <- 1:nrow(unique(address))
library(dplyr) # install.packages("dplyr")
# students is a data frame for students
students<- students_data %>%
    left_join(address, by= c(
            "E787_FirstResidentialAddressLine1" =  "AddressLine",
            'E789_FirstResidentialAddressSuburb' = 'Suburb',
            'E790_FirstResidentialAddressPostcode' = "Postcode",
            'E791_FirstResidentialAddressState' = "State",
            'E659_FirstResidentialAddressCountryCode' = "CountryCode"
        )
    ) %>%
    left_join(address, by= c(
        "E410_ResidentialAddressLine1" =  "AddressLine",
        'E469_ResidentialAddressSuburb' = 'Suburb',
        'E320_ResidentialAddressPostcode' = "Postcode",
        'E470_ResidentialAddressState' = "State",
        'E658_ResidentialAddressCountryCode' = "CountryCode"
    ), suffix = c("","_ResidentialAddress")
)
students <- students %>%
    rename(AddressKey_first_residence = AddressKey) %>%
    select(-all_of(first_residential_address_cols_to_keep)) %>%
    select(-all_of(residential_address_cols_to_keep))


# add indicators for student super class and subclass    
students_and_subclass <- students %>%
  inner_join(citizenships, by = pk_for_students) %>%
  left_join(disabilities, by = pk_for_students) %>%
  select(all_of(c(pk_for_students, pk_for_citizenships, pk_for_disabilities))) %>%
  mutate(
    IsCitizenship = !is.na(.data[[pk_for_citizenships]]),
    HasDisability = !is.na(.data[[pk_for_disabilities]])
  ) %>%
  select(all_of(c(pk_for_students,"IsCitizenship", "HasDisability")))

# write the data
write.csv(citizenships, file = "Citizenships.csv", row.names = FALSE)
write.csv(disabilities, file = "Disabilities.csv", row.names = FALSE)
write.csv(students_and_subclass, file = "StudentsAndSubclass.csv", row.names = FALSE)
