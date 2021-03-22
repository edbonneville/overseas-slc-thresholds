# Source thresholds data
source("R/calculate_repayments.R")
source("R/get_thresholds_data.R")
thresholds_df <- get_thresholds_data()

# Prepare countries list
countries_ls <- unique(thresholds_df$country_of_residence)
names(countries_ls) <- countries_ls

# Start server function
function(input, output, session) {
  
  country_df <- reactive({
    
    # Check at least one loan type selected
    validate(
      need(length(input$loan_types) > 0, "Select at least one loan type!"),
      need(input$income >= 0, "Income should be a positive number!")
    )
    
    # Calculate repayments
    calculate_repayments(
      country = input$country,
      loan_plans = input$loan_types,
      income = input$income,
      thresholds_data = thresholds_df
    )
  }) 
  
  output$test_table <- renderTable({
    df <- country_df()
    print(df[, c("loan_type", "amount_owed_gbp", "amount_owed_local")])
  })
  
  #... Add nice value buttons/boxes, 'infoboxes'
  output$box_gbp_amount <- renderInfoBox({
    df <- country_df()
    #if ("plan_1" %in% df$loan_type)
    infoBox(
      "To repay this year (GBP)", paste0(25, "%"), icon = icon("list"),
      color = "purple"
    )
  })
  
  output$box_local_amount <- renderInfoBox({
    df <- country_df()
    #if ("plan_1" %in% df$loan_type)
    infoBox(
      "To repay this year (local)", paste0(25, "%"), icon = icon("list"),
      color = "purple"
    )
  })
}
