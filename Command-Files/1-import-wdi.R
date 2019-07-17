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

# Install pacman package for easy package loading

# Load packages
library("WDI")
library("rio")
library("tidyverse")

# IMPORT WDI DATA
# Indicators: NY.GDP.PCAP.CD (GDP per capita), NE.CON.GOVT.ZS (General government final consumption expenditure (% of GDP))
# Countries (ISO-2 codes): China (CN), India (IN), Indonesia (ID), Jordan (JO), Pakistan (PK), Russia (RU), United States (US)
# Year: 2002

original_wdi <- WDI(country = c("CN", "IN", "ID", "JO", "PK", "RU", "US"),
                    indicator = c("NY.GDP.PCAP.CD", "NE.CON.GOVT.ZS"),
                    start = 2002,
                    end = 2002)

str(original_wdi)

# Alternative: read in WDI data from the .xlsx spreadsheet

# TBD

# Rename WDI variables

original_wdi <- rename(original_wdi, inc = NY.GDP.PCAP.CD, exp = NE.CON.GOVT.ZS)

# SO THAT WE CAN MERGE THIS WDI DATA WITH THE PEW DATA,
# GENERATE A VARIABLE country THAT CODES THE COUNTRIES
# IN THE SAME WAY AS THE PEW DATA.

original_wdi$ccode_pew <- -99
original_wdi[original_wdi$iso2c == "CN", ]$ccode_pew <- 8  # China
original_wdi[original_wdi$iso2c == "IN", ]$ccode_pew <- 17 # India
original_wdi[original_wdi$iso2c == "ID", ]$ccode_pew <- 18 # Indonesia
original_wdi[original_wdi$iso2c == "JO", ]$ccode_pew <- 45 # Jordan
original_wdi[original_wdi$iso2c == "PK", ]$ccode_pew <- 27 # Pakistan
original_wdi[original_wdi$iso2c == "RU", ]$ccode_pew <- 31 # Russia
original_wdi[original_wdi$iso2c == "US", ]$ccode_pew <- 40 # United States

table(original_wdi$ccode_pew)
  
# SAVE IMPORTABLE DATA 

export(original_wdi, file = "../Importable-Data/wdi.csv")
saveRDS(original_wdi, file = "../Importable-Data/wdi.rds")
