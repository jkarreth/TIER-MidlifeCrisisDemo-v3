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
library("texreg")

## ----dataprep, eval = FALSE, echo = FALSE--------------------------------
## source("1-import-wdi.R")
## source("2-import-pew.R")
## source("3-processing.R")

## ----loaddata, echo = FALSE----------------------------------------------
dc <- readRDS("../Analysis-Data/country-analysis.rds")
di <- readRDS("../Analysis-Data/individual-analysis.rds")

## ----table1, echo = FALSE------------------------------------------------
table1 <- select(dc, -ccode_pew)
table1 <- arrange(table1, CountryName)
names(table1) <- c("Country", "Mean Satis.", "GDP per capita", "Gov. Cons.")
kable(table1, 
      digits = 2,
      caption = "Mean Satisfaction, GPD per capita and Government Consumption by Country")

## ----regressions, echo = FALSE-------------------------------------------
r1 <- lm(satis ~ age + age2, data = di)
r2 <- lm(satis ~ age + age2 + factor(CountryName), data = di)

## ----table2, results = 'asis', echo = FALSE------------------------------
# Note: comment out the texreg function if knitting to HTML,
#   or comment out the htmlreg function if knitting to PDF.

texreg(list(r1, r2),
       custom.coef.names = c("Constant", "Age", "Age squared"),
       omit.coef = "factor",
       digits = 3,
       caption = "Regression results",
       caption.above = TRUE,
       bold = 0.05, stars = 0,
       custom.note = "Standard errors in parentheses. Coefficients with $p < 0.05$ in bold font.")

# htmlreg(list(r1, r2),
#        custom.coef.names = c("Constant", "Age", "Age squared"),
#        omit.coef = "factor",
#        digits = 3,
#        caption = "Regression results",
#        caption.above = TRUE,
#        custom.model.names = c("Pooled", "Country fixed effects"),
#        bold = 0.05, stars = 0,
#        custom.note = "Standard errors in parentheses. Coefficients with p < 0.05 in bold font.")

## ----figure1, echo = FALSE, fig.cap = "Scatterplot of GDP per capita and mean satisfaction", fig.align = "center"----
ggplot(data = dc, aes(x = inc, y = cm_satis)) + 
  geom_point() + 
  geom_text(aes(label = CountryName), vjust = "inward", hjust = "inward") + 
  xlab("GDP per capita (current [2002] $ US)") + 
  ylab("Country mean satisfaction")

## ----figure2, echo = FALSE, fig.cap = "Scatterplot of General Government Consumption and mean satisfaction", fig.align = "center"----
ggplot(data = dc, aes(x = exp, y = cm_satis)) + 
  geom_point() + 
  geom_text(aes(label = CountryName), vjust = "inward", hjust = "inward") + 
  xlab("Government consumption, % of GDP") + 
  ylab("Country mean satisfaction")

## ----extractrcode, eval = TRUE, echo = FALSE-----------------------------
purl(input = "5-analysis.Rmd", output = "5-analysis.R")
file.rename("5-analysis.R", "../Command-Files/5-analysis.R")

