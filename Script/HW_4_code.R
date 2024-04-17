# import WAVE dataset (STATA import) and rename dataset

# Assuming the dataset is already loaded into the variable F00011106_WV6_Data_stata_v20201117
df1 <- F00011106_WV6_Data_stata_v20201117

# Remove the dataset
rm(F00011106_WV6_Data_stata_v20201117)


# Load the dplyr package
library(dplyr)

# Selecting columns and assigning back to df1
df1 <- df1 %>% 
  select(C_COW_ALPHA, V192:V197, V217:V224, V228A:V228I)

getwd()
# Save the modified dataframe to a CSV file
write.csv(df1, "C:/Users/ricecakes/Desktop/Git1/HW-4/HW-4/Country/df1.csv", row.names = FALSE)


# Impute NAs to median value
df1 <- df1 %>%
  mutate(across(where(is.numeric), ~if_else(is.na(.), median(., na.rm = TRUE), .)))


# Create the new 'country' column
df1 <- df1 %>% 
  mutate(country = case_when(
    C_COW_ALPHA == "USA" ~ "United States of America",
    C_COW_ALPHA == "HAI" ~ "Haiti",
    C_COW_ALPHA == "TRI" ~ "Trinidad and Tobago",
    C_COW_ALPHA == "MEX" ~ "Mexico",
    C_COW_ALPHA == "COL" ~ "Colombia",
    C_COW_ALPHA == "ECU" ~ "Ecuador",
    C_COW_ALPHA == "PER" ~ "Peru",
    C_COW_ALPHA == "BRA" ~ "Brazil",
    C_COW_ALPHA == "CHL" ~ "Chile",
    C_COW_ALPHA == "ARG" ~ "Argentina",
    C_COW_ALPHA == "URU" ~ "Uruguay",
    C_COW_ALPHA == "NTH" ~ "Netherlands",
    C_COW_ALPHA == "SPN" ~ "Spain",
    C_COW_ALPHA == "GMY" ~ "Germany",
    C_COW_ALPHA == "POL" ~ "Poland",
    C_COW_ALPHA == "SLV" ~ "Slovenia",
    C_COW_ALPHA == "CYP" ~ "Cyprus",
    C_COW_ALPHA == "ROM" ~ "Romania",
    C_COW_ALPHA == "RUS" ~ "Russia",
    C_COW_ALPHA == "EST" ~ "Estonia",
    C_COW_ALPHA == "UKR" ~ "Ukraine",
    C_COW_ALPHA == "BLR" ~ "Belarus",
    C_COW_ALPHA == "ARM" ~ "Armenia",
    C_COW_ALPHA == "GRG" ~ "Georgia",
    C_COW_ALPHA == "AZE" ~ "Azerbaijan",
    C_COW_ALPHA == "SWD" ~ "Sweden",
    C_COW_ALPHA == "GHA" ~ "Ghana",
    C_COW_ALPHA == "NIG" ~ "Nigeria",
    C_COW_ALPHA == "RWA" ~ "Rwanda",
    C_COW_ALPHA == "ZIM" ~ "Zimbabwe",
    C_COW_ALPHA == "SAF" ~ "South Africa",
    C_COW_ALPHA == "MOR" ~ "Morocco",
    C_COW_ALPHA == "ALG" ~ "Algeria",
    C_COW_ALPHA == "TUN" ~ "Tunisia",
    C_COW_ALPHA == "LIB" ~ "Libya",
    C_COW_ALPHA == "TUR" ~ "Turkey",
    C_COW_ALPHA == "IRQ" ~ "Iraq",
    C_COW_ALPHA == "EGY" ~ "Egypt",
    C_COW_ALPHA == "LEB" ~ "Lebanon",
    C_COW_ALPHA == "JOR" ~ "Jordan",
    C_COW_ALPHA == "PSE" ~ "Palestine",
    C_COW_ALPHA == "YEM" ~ "Yemen",
    C_COW_ALPHA == "KUW" ~ "Kuwait",
    C_COW_ALPHA == "BAH" ~ "Bahrain",
    C_COW_ALPHA == "QAT" ~ "Qatar",
    C_COW_ALPHA == "KYR" ~ "Kyrgyzstan",
    C_COW_ALPHA == "UZB" ~ "Uzbekistan",
    C_COW_ALPHA == "KZK" ~ "Kazakhstan",
    C_COW_ALPHA == "CHN" ~ "China",
    C_COW_ALPHA == "TAW" ~ "Taiwan",
    C_COW_ALPHA == "HKG" ~ "Hong Kong",
    C_COW_ALPHA == "ROK" ~ "South Korea",
    C_COW_ALPHA == "JPN" ~ "Japan",
    C_COW_ALPHA == "IND" ~ "India",
    C_COW_ALPHA == "PAK" ~ "Pakistan",
    C_COW_ALPHA == "THI" ~ "Thailand",
    C_COW_ALPHA == "MAL" ~ "Malaysia",
    C_COW_ALPHA == "SIN" ~ "Singapore", 
    C_COW_ALPHA == "PHI" ~ "Philippines",
    C_COW_ALPHA == "AUL" ~ "Australia",
    C_COW_ALPHA == "NEW" ~ "New Zealand"))



# Remove the C_COW_ALPHA column from df1
df1 <- select(df1, -C_COW_ALPHA)
colnames(df1)
mean(df1$V228A)

# library(rsconnect)
# #shiny install
# install.packages('rsconnect')
getwd()
library(rsconnect)
rsconnect::deployApp('Country')

# Assuming 'df' is your dataframe
saveRDS(df1, "df1.rds")
print(getwd())  # This will print the current working directory


sessionInfo()
############################################################################
###############################################
##################################
##################
##########
