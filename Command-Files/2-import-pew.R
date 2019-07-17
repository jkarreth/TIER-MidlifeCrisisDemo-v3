### 
# Created by Johannes Karreth
# Last updated:  2018-05-24
# Written for R 3.5.0, Mac OS X 
### 

# WHEN THIS DO-FILE IS RUN, R'S WORKING DIRECTORY 
# SHOULD BE SET TO THE "Command-Files" FOLDER.
# The following two lines do this automatically.

command_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(command_dir)

rm(list = ls())

# Load packages
library("rio")
library("tidyverse")

# OPEN THE ORIGINAL PEW DATA
original_pew <- rio::import("../Original-Data/original-pew.sav")

# KEEP ONLY THE VARIABLES THAT WILL BE USED FOR 
# THIS STUDY
pew <- original_pew[, c("country", "q2", "q74")]
pew <- select(original_pew, country, q2, q74) # tidyverse equivalent

# GIVE THE VARIABLES NICER NAMES AND LABELS
pew <- rename(pew, satis = q2, age = q74)

# FOR VARIABLES satis AND age
# RECODE "DON'T KNOW" and "REFUSED" AS NA

# To see how missing values and refusals are coded for satis
table(pew$satis)

# Consult ../Original-Data/metadata/supplements/2-Pew-GAP-Survey-details 1.1.pdf
# page 6:
# Range 0-10
# 11 Don’t know (DO NOT READ)
# 12 Refused (DO NOT READ)

pew$satis <- ifelse(pew$satis == 11, NA, pew$satis)
pew$satis <- ifelse(pew$satis == 12, NA, pew$satis)

table(pew$satis)

# To see how missing values and refusals are coded for age
table(pew$age)

# Consult ../Original-Data/metadata/supplements/2-Pew-GAP-Survey-details 1.1.pdf
# page 6:
# Range 18-96
# 97 97 or older
# 98 Don’t know (DO NOT READ)
# 99 Refused (DO NOT READ)

pew$age <- ifelse(pew$age == 98, NA, pew$age)
pew$age <- ifelse(pew$age == 99, NA, pew$age)

table(pew$age)

# DROP OBSERVATIONS FOR ALL INDIVIDUALS FOR WHOM 
# THE VALUE OF THE VARIABLE satis IS MISSING OR REFUSED
pew <- pew[!is.na(pew$satis), ]
pew <- filter(pew, !is.na(satis)) # tidyverse equivalent

# DROP OBSERVATIONS FOR ALL INDIVIDUALS WHO ARE 
# LESS THAN 21 OR MORE THAN 70 YEARS OF AGE
# OR FOR WHOM THE VALUE OF THE VARIABLE age IS MISSING

# To drop observations where the value of age is either
# greater than 70, or missing or refused
pew <- pew[pew$age <= 70, ]
pew <- filter(pew, age <= 70) # tidyverse equivalent

# To drop observations where the value of age is less than 21
pew <- pew[pew$age >= 21, ]
pew <- filter(pew, age >= 21) # tidyverse equivalent


# KEEP DATA ONLY FOR COUNTRIES WITH AT LEAST 900 OBSERVATIONS
# REMAINING IN THE SAMPLE AFTER REMOVAL OF INDIVIDUALS WITH 
# MISSING OR REFUSED VALUES OF satis 0R age, AS WELL AS REMOVAL
# OF INDIVIDUALS UNDER 21 OR OVER 70 YEARS OF AGE

# First, generate a variable called country_n that, for each
# individual, equals the total number of observations that remain 
# in the sample representing individuals from her/his own country

pew <- mutate(group_by(pew, country),
              country_n = n())

# Then drop all individuals for whom country_n is less than 900
pew <- filter(pew, country_n >= 900)

table(pew$country)

# The variable country_n is no longer needed, so drop it
pew <- select(pew, -country_n)

# Rename variables
pew <- rename(pew, ccode_pew = country)

# IN SOME OF THE ANALYSIS I WILL WANT TO USE BOTH AGE AND
# THE SQUARE OF AGE.  SO GENERATE A NEW VARIABLE age2 EQUAL
# TO THE SQUARE OF AGE.
pew$age2 <- pew$age^2

# SAVE IMPORTABLE DATA 

export(pew, file = "../Importable-Data/pew.csv")
saveRDS(pew, file = "../Importable-Data/pew.rds")
