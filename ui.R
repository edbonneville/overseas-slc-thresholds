# Set sidebar width globally
width_sidebar <- 400

# Build sidebar
sidebar <- dashboardSidebar(
  width = width_sidebar,
  
  # Menu selections
  sidebarMenu(
    id = "nav",
    menuItem("Information", tabName = "app_descrip", icon = icon("info")),
    menuItem("Calculator", tabName = "calc", icon = icon("calculator"), selected = TRUE),
    menuItem("Source code", href = "https://github.com/edbonneville/overseas-slc-thresholds", icon = icon("code-branch"))
  ),
  
  # Start calculator if selected
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
        "Plan 1 (undergraduate)" = "Plan 1",
        "Plan 2 (undergraduate)" = "Plan 2",
        "Postgraduate" = "postgraduate"
      ), 
      selected = "Plan 2"
    ),
    
    # Enter annual income
    uiOutput("income_ui")
  )
)

# Customise body
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "app_descrip", includeMarkdown("README.md")),
    tabItem(
      tabName = "calc",
      # Value boxes on first row
      fluidRow(
        valueBoxOutput("gbp_yearly"),
        valueBoxOutput("gbp_monthly"),
        valueBoxOutput("local_monthly")
      ),
      # Salary statement on second
      fluidRow(
        box(
          title = "Salary statement", 
          width = 12, 
          solidHeader = FALSE,
          status = "primary",
          textOutput("pre_statement")
        )
      ),
      # Explanations table on third
      fluidRow(
        box(
          title = "Explanations", 
          width = 12, 
          solidHeader = FALSE, 
          status = "primary",
          uiOutput("explanations_table")
        )
      ),
      # Add raw table at bottom, collapsible
      fluidRow(
        box(
          title = "Show raw table", 
          width = 12, 
          solidHeader = FALSE, 
          status = "primary",
          collapsible = TRUE, 
          collapsed = TRUE,
          uiOutput("raw_table"),
          footer = "This is the table shown on the gov.uk official website."
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
