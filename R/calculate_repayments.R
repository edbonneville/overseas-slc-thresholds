calculate_repayments <- function(country,
                                 loan_plans,
                                 income,
                                 thresholds_data) {
  
  # Prepare country-specific data
  country_specific_df <- data.table::copy(thresholds_data)
  country_specific_df <- country_specific_df[country_of_residence == country & loan_type %in% loan_plans]
  country_specific_df[, income_gbp := income * exchange_rate]
  country_specific_df[, diff_threshold_gbp := income_gbp - earnings_threshold_gbp]
  country_specific_df[, amount_owed_gbp := prop_over_threshold * diff_threshold_gbp]
  country_specific_df[, amount_owed_local := amount_owed_gbp / exchange_rate]
  
  return(country_specific_df)
}

make_repayment_statements <- function(country_df,
                                      income) {
  
  # Prep global forestatement
  country <- country_df$country_of_residence[1]
  currency <- country_df$currency[1]

  # Overall income statement
  pre_statement <- paste0(
    "A total annual income of ", income, " ", currency, 
    " corresponds to an annual GBP income of ", 
    round(country_df$income_gbp[1], 2), 
    " (based on an exchange rate of ", country_df$exchange_rate[1], ")."
  )
  
  loan_types <- c("Plan 1", "Plan 2", "postgraduate")
  names(loan_types) <- loan_types
  
  # Get plan-specific statements
  ls_statements <- lapply(loan_types, function(loan) {
    
    loan_row <- country_df[loan_type == loan]
    
    # If not taken out
    if (nrow(loan_row) == 0) {
      loan_statement <- paste0("No ", loan, " loan was requested.")
    } else if (loan_row$diff_threshold_gbp <= 0) {
      loan_statement <- paste0(
        "Your income is ", round(abs(loan_row$diff_threshold_gbp), 2),
        " GBP below the threshold of ", loan_row$earnings_threshold_gbp,
        " GBP. Hence, no repayments are required this year for this loan."
      )
    } else {
      loan_statement <- paste0(
        "Your income is ", round(loan_row$diff_threshold_gbp, 2),
        " GBP above the threshold of ", loan_row$earnings_threshold_gbp,
        " GBP. You must thus repay ", loan_row$prop_over_threshold * 100,
        "% of this difference over the whole year, which equals ", 
        round(loan_row$amount_owed_gbp, 2), " GBP (", 
        round(loan_row$amount_owed_local, 2), " ", currency,
        "). These are monthly repayments of ", round(loan_row$amount_owed_gbp / 12, 2), 
        " GBP (", round(loan_row$amount_owed_local / 12, 2), " ", currency, ")."
      )
    }
    data.frame("Loan" = loan, "Explanation" = loan_statement)
  })
  
  explanations_df <- do.call(rbind, ls_statements)
  return(list("pre_statement" = pre_statement, "explanations" = explanations_df))
}
