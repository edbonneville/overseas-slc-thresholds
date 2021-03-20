calculate_repayments <- function(country,
                                 loan_plans,
                                 income,
                                 thresholds_data) {
  
  # Prepare country-specific data
  country_specific_df <- thresholds_df[country_of_residence == country & loan_type %in% loan_plans]
  country_specific_df[, income_gbp := income * exchange_rate]
  country_specific_df[, diff_threshold_gbp := income_gbp - earnings_threshold_gbp]
  country_specific_df[, amount_owed_gbp := prop_over_threshold * diff_threshold_gbp]
  country_specific_df[, amount_owed_local := amount_owed_gbp / exchange_rate]
  
  return(country_specific_df)
}
