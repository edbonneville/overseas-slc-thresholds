# Load necessary packages
library(shiny)
library(shinydashboard)
library(shinyWidgets)
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

# Prepare countries list
countries_ls <- unique(thresholds_df$country_of_residence)
names(countries_ls) <- countries_ls