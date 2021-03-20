# Source thresholds data
source("R/get_thresholds_data.R")
thresholds_df <- get_thresholds_data()

# Source further helper scripts
source("R/calculate_repayments.R")


# Start server function
function(input, output, session) {
  
  country_df <- reactive({
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
}
