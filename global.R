# Load necessary packages
library(shiny)
library(shinydashboard)
library(markdown)
library(RCurl)
library(rvest)
library(data.table)
library(janitor)
library(strex)

# Source thresholds data
source("R/calculate_repayments.R")
source("R/get_thresholds_data.R")

# Load
thresholds_df <- get_thresholds_data()

# Prepare countries and currencies
unique_df <- unique(thresholds_df[, c("country_of_residence", "currency")])
countries_ls <- unique_df[["country_of_residence"]]
currencies_ls <- unique_df[["currency"]]
names(countries_ls) <- names(currencies_ls) <- countries_ls
