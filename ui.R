# Load necessary packages
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(RCurl)
library(rvest)
library(data.table)
library(janitor)
library(strex)

# Set sidebar width globally
width_sidebar <- 375

# Source thresholds data
source("R/get_thresholds_data.R")
thresholds_df <- get_thresholds_data()

# Prepare countries list
countries_ls <- unique(thresholds_df$country_of_residence)
names(countries_ls) <- countries_ls

# Build sidebar
sidebar <- dashboardSidebar(
  width = width_sidebar,
  
  # Read description of app or run directly - icons from https://fontawesome.com
  sidebarMenu(
    id = "nav",
    menuItem("Information", tabName = "app_descrip", icon = icon("info")),
    menuItem("Calculator", tabName = "calc", icon = icon("arrow-circle-right"))
  ),
  
  # Start calculator
  conditionalPanel(
    condition = 'input.nav == "calc"',
    
    # Select country of residence
    selectInput(
      "country", 
      "Country of residence: ", 
      choices = countries_ls, 
      multiple = FALSE,
      selected = "Netherlands"
    ),
    
    # Select loan type
    checkboxGroupInput(
      "loan_types",
      "Loan types: ",
      choices = list(
        "Plan 1 (undergraduate)" = "plan_1",
        "Plan 2 (undergraduate)" = "plan_2",
        "Postgraduate" = "postgraduate"
      ), 
      selected = "plan_2"
    ),
    
    # Enter annual income
    numericInput('income', "Annual income (local currency)", value = 35000, min = 0)
  )
)

# Customise body
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "app_descrip", includeMarkdown("README.md")),
    tabItem(
      tabName = "calc",
      fluidRow(
        box(
          title = "Test output", width = 12, solidHeader = TRUE, status = "primary",
          uiOutput("test_table")
        )
      )
    )
  )
)

# Set-up dashboard page
dashboardPage(
  dashboardHeader(
    title = "Overseas UK Student Loan Repayments", 
    titleWidth = width_sidebar
  ),
  sidebar,
  body,
  skin = "blue"
)
