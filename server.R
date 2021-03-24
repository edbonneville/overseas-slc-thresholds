# Source thresholds data
source("R/calculate_repayments.R")
source("R/get_thresholds_data.R")
thresholds_df <- get_thresholds_data()

# Prepare countries list
countries_ls <- unique(thresholds_df$country_of_residence)
names(countries_ls) <- countries_ls

# Start server function
function(input, output, session) {
  
  repayment_data <- reactive({
    
    # Check at least one loan type selected
    validate(
      need(length(input$loan_types) > 0, "Select at least one loan type!"),
      need(input$income >= 0, "Income should be a positive number!")
    )
    
    # Calculate repayments
    repayments_df <- calculate_repayments(
      country = input$country,
      loan_plans = input$loan_types,
      income = input$income,
      thresholds_data = thresholds_df
    )
    
    statements <- make_repayment_statements(
      country_df = repayments_df, 
      income = input$income
    )
    
    list("repayments_df" = repayments_df, "statements" = statements)
  }) 
  
  output$pre_statement <- renderText({
    repayment_data()$statements$pre_statement
  })
  
  output$test_table <- renderTable({
    df <- repayment_data()$statements$explanations
    print(df)
  })
  
  output$raw_table <- renderTable({
    df_temp <- thresholds_df[country_of_residence == input$country, c(
      "loan_type",
      "country_of_residence",
      "currency",
      "exchange_rate",
      "earnings_threshold_gbp",
      "fixed_monthly_repayment_gbp"
    )]
    
    data.table::setnames(
      df_temp, new = c(
        "Type", 
        "Country of residence",
        "Currency",
        "Exchange rate",
        "Lower earnings threshold (GBP)",
        "Fixed monthly repayment (GBP)"
      )
    )
    print(df_temp)
  })
  
  #... Add nice value buttons/boxes, 'infoboxes'
  output$gbp_yearly <- renderValueBox({
    df <- repayment_data()$repayments_df[amount_owed_gbp >= 0]
    valueBox(
      paste0(round(sum(df$amount_owed_gbp), 2)),
      "Year repayment (GBP)",
      icon = icon("pound-sign"),
      color = "purple"
    )
  })
  
  output$gbp_monthly <- renderValueBox({
    df <- repayment_data()$repayments_df[amount_owed_gbp >= 0]
    valueBox(
      paste0(round(sum(df$amount_owed_gbp) / 12, 2)),
      "Monthly repayment (GBP)",
      icon = icon("pound-sign"),
      color = "purple"
    )
  })
  
  output$local_monthly <- renderValueBox({
    df <- repayment_data()$repayments_df[amount_owed_local >= 0]
    valueBox(
      paste0(round(sum(df$amount_owed_local) / 12, 2)), 
      "Monthly repayment (local)",
      icon = icon("money-bill-alt"),
      color = "green"
    )
  })
}
