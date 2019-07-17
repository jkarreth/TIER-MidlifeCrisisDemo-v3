## ----fileinfo, echo = FALSE----------------------------------------------
### 
# Created by Johannes Karreth
# Last updated:  2018-05-24
# Written for R 3.5.0, Mac OS X 
### 

## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
# command_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
# setwd(command_dir)
library("knitr")
library("tidyverse")
library("summarytools")
library("texreg")

## ----dataprep, eval = FALSE, echo = FALSE--------------------------------
## # Note: These command files create the data used in this paper.
## # eval is set to FALSE because these scripts need not be run each
## # time the paper is compiled.
## source("../Command-Files/1-import-wdi.R")
## source("../Command-Files/2-import-pew.R")
## source("../Command-Files/3-processing.R")

## ----loaddata, echo = FALSE----------------------------------------------
dc <- readRDS("../Analysis-Data/country-analysis.rds")
di <- readRDS("../Analysis-Data/individual-analysis.rds")

## ----freqtableCountryName, results = "asis"------------------------------
# table(di$CountryName)
freq(di$CountryName, report.nas = FALSE, style = "rmarkdown", omit.headings = TRUE)

## ----freqtableSatis, results = "asis"------------------------------------
# table(di$satis)
freq(di$satis, report.nas = FALSE, style = "rmarkdown", omit.headings = TRUE)

## ----barSatis------------------------------------------------------------
ggplot(data = di, aes(x = factor(satis))) + 
 geom_bar(aes(y = (..count..)/sum(..count..))) +
 scale_y_continuous() +
 xlab("Satisfaction (self-reported)") + 
 ylab("Share of respondents")

## ----descrAge, results = "asis"------------------------------------------
# summary(di$age)
descr(di$age, stats = c("mean", "sd", "min", "Q1", "med", "Q3", "max"), transpose = TRUE, 
      omit.headings = TRUE, style = "rmarkdown")

## ----histAge-------------------------------------------------------------
ggplot(data = di, aes(x = age)) +
 geom_histogram(aes(y = (..count..)/sum(..count..)), binwidth = 1) +
 xlab("Age (in years)") + 
 ylab("Share of respondents")

## ----descrCmSatis, results = "asis"--------------------------------------
# summary(dc$cm_satis)
descr(dc$cm_satis, stats = c("mean", "sd", "min", "Q1", "med", "Q3", "max"), transpose = TRUE, 
      omit.headings = TRUE, style = "rmarkdown")

## ----histCmSatis---------------------------------------------------------
ggplot(data = dc, aes(x = cm_satis)) +
  geom_histogram(binwidth = 1) +
  xlab("Country mean satisfaction") + 
  ylab("# of countries")

## ----descrExp, results = "asis"------------------------------------------
# summary(dc$exp)
descr(dc$exp, stats = c("mean", "sd", "min", "Q1", "med", "Q3", "max"), transpose = TRUE, 
      omit.headings = TRUE, style = "rmarkdown")

## ----histExp-------------------------------------------------------------
exp_freq_hist <- ggplot(data = dc, aes(x = exp)) +
  geom_histogram(binwidth = 4) +
  xlab("Government consumption, % of GDP") + 
  ylab("# of countries")

## ----descrInc, results = "asis"------------------------------------------
# summary(dc$inc)
descr(dc$inc, stats = c("mean", "sd", "min", "Q1", "med", "Q3", "max"), transpose = TRUE, 
      omit.headings = TRUE, style = "rmarkdown")

## ----histInc-------------------------------------------------------------
ggplot(data = dc, aes(x = inc)) +
  geom_histogram() +
  xlab("GDP per capita (current [2002] $ US)") + 
  ylab("# of countries")

## ----extractrcode, eval = FALSE, echo = FALSE----------------------------
## # Note: this command extracts the R code from this .Rmd file and
## # creates a pure R script, then places it in the
## # Command-Files folder. Highlight and run the next two lines if you wish to
## # generate the R script.
## purl(input = "4-data-appendix.Rmd", output = "4-data-appendix.R")
## file.rename("4-data-appendix.R", "../Command-Files/4-data-appendix.R")

