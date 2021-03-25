# Start server function
function(input, output, session) {
  
  repayment_data <- reactive({
    
    # Check at least one loan type selected
    validate(
      need(length(input$loan_types) > 0, "Select at least one loan type!"),
      need(input$income >= 0, "Income should be a positive number!")
    )
    
    # Calculate repayments and get statements
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
  
  # This allows currency to render dynamically in sidebar
  output$income_ui <- renderUI({
    numericInput(
      'income', 
      paste0("Annual gross income (", currencies_ls[input$country], ")"),
      value = 35000, 
      min = 0
    )
  })
  
  # Statement on annual salary conversion
  output$pre_statement <- renderText({
    repayment_data()$statements$pre_statement
  })
  
  # Explains the calculations for each loan
  output$explanations_table <- renderTable({
    repayment_data()$statements$explanations
  })
  
  # Output raw thresholds on gov.uk site
  output$raw_table <- renderTable({
    df_temp <- thresholds_df[country_of_residence == input$country, c(
      "loan_type",
      "country_of_residence",
      "currency",
      "exchange_rate",
      "earnings_threshold_gbp",
      "fixed_monthly_repayment_gbp"
    )]
    
    # Make sure exchange rate digits are not rounded
    df_temp[, exchange_rate := format(exchange_rate, digits = 6)]
    
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
    
    df_temp
  })
  
  # Value box for yearly GBP owed
  output$gbp_yearly <- renderValueBox({
    df <- repayment_data()$repayments_df[amount_owed_gbp >= 0]
    valueBox(
      paste0(round(sum(df$amount_owed_gbp), 2)),
      "Year repayment (GBP)",
      icon = icon("pound-sign"),
      color = "purple"
    )
  })
  
  # Value box for monthly GBP owed
  output$gbp_monthly <- renderValueBox({
    df <- repayment_data()$repayments_df[amount_owed_gbp >= 0]
    valueBox(
      paste0(round(sum(df$amount_owed_gbp) / 12, 2)),
      "Monthly repayment (GBP)",
      icon = icon("pound-sign"),
      color = "purple"
    )
  })
  
  # Value box for local amount owed
  output$local_monthly <- renderValueBox({
    df <- repayment_data()$repayments_df
    valueBox(
      paste0(round(sum(df[amount_owed_local >= 0]$amount_owed_local) / 12, 2)), 
      paste0("Monthly repayment (", df$currency[1],")"),
      icon = icon("money-bill-alt"),
      color = "green"
    )
  })
}
