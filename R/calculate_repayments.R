calculate_repayments <- function(country,
                                 loan_plans,
                                 income,
                                 thresholds_data) {
  
  # Prepare country-specific data
  country_specific_df <- thresholds_data[country_of_residence == country & loan_type %in% loan_plans]
  country_specific_df[, income_gbp := income * exchange_rate]
  country_specific_df[, diff_threshold_gbp := income_gbp - earnings_threshold_gbp]
  country_specific_df[, amount_owed_gbp := prop_over_threshold * diff_threshold_gbp]
  country_specific_df[, amount_owed_local := amount_owed_gbp / exchange_rate]
  
  country_specific_df
  
  # List of values and explanations
  
  
  
  return(country_specific_df)
}

# Functions to create explanations
vec <- country_specific_df$loan_type

make_repayment_statements <- function(country_df,
                                      income) {
  
  # Prep global forestatement
  country <- country_df$country_of_residence[1]
  currency <- country_df$currency[1]

  # Overall income statement
  pre_statement <- paste0(
    "A total annual income of ", income, " ", currency, 
    " corresponds to an annual GBP income of ", country_df$income_gbp[1], 
    " (based on an exchange rate of ", country_df$exchange_rate[1], ")."
  )
  
  # Get plan-specific statements
  lapply(c("plan_1", "plan_2", "postgraduate"), function(loan) {
    
    # Set loan label
    if (loan == "plan_1") {
      loan_label <- " Plan 1 (undergraduate) "
    } else if (loan == "plan_2") {
      loan_label <- " Plan 2 (undergraduate) "
    } else loan_label <- " Postgraduate "
    
    # Take row 
    loan_row <- country_df[loan_type == loan]
    
    # If not taken out
    if (nrow(loan_row) == 0) {
      loan_statement <- paste0("No", loan_label, "loan was requested.")
      # make list here..
    } 
    
    # Check if below threshold
    if  (loan_row$diff_threshold_gbp <= 0) {
      
    }
    
    loan_statement <- paste0(
      "An annual GBP income of ", loan_row$income_gbp, " is"
    )
  })
  
}

