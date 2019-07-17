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

# OPEN THE IMPORTABLE PEW DATA
pew <- readRDS("../Importable-Data/pew.rds")

# OPEN THE IMPORTABLE WDI DATA
wdi <- readRDS("../Importable-Data/wdi.rds")

# MERGE both datasets
di <- merge(x = pew, y = wdi, by = "ccode_pew")

di <- rename(di, CountryName = country)

# SAVE THE INDIVIDUAL-LEVEL DATA WITH THE NAME individual-analysis.ext
# Save this file in the "Analysis-Data" folder.
export(di, file = "../Analysis-Data/individual-analysis.csv")
saveRDS(di, file = "../Analysis-Data/individual-analysis.rds")

# CREATE A COUNTRY-LEVEL DATA SET 
# WITH COUNTRIES IDENTIFIED BY countryname AND country 
# INCLUDING THE VARIABLES satis exp AND inc
# IN WHICH

	# THE VALUE OF cm_satis IS EQUAL TO THE MEAN VALUE
	# FOR ALL INDIVIDUALS IN THE COUNTRY
	
	# THE VALUES OF exp AND inc ARE THE VALUES
	# OF THESE VARIABLES FOR THE COUNTRY IN THE YEAR 2002
	
dc <- summarize(group_by(di, ccode_pew),
                         CountryName = first(CountryName),
                         cm_satis = mean(satis),
                         exp = mean(exp),
                         inc = mean(inc))
 
# SAVE THE COUNTRY-LEVEL DATA WITH THE NAME country-analysis.ext
# Save this file in the "Analysis-Data" folder.
export(dc, file = "../Analysis-Data/country-analysis.csv")
saveRDS(dc, file = "../Analysis-Data/country-analysis.rds")
