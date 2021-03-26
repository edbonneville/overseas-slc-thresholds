get_thresholds_data <- function() {
  
  urls <- list(
    "plan_1" = "https://www.gov.uk/government/publications/overseas-earnings-thresholds-for-plan-1-student-loans/overseas-earnings-thresholds-for-plan-1-student-loans-2020-21",
    "plan_2" = "https://www.gov.uk/government/publications/overseas-earnings-thresholds-for-plan-2-student-loans/overseas-earnings-thresholds-for-plan-2-student-loans-2020-21",
    "postgraduate" = "https://www.gov.uk/government/publications/overseas-earnings-thresholds-for-postgraduate-student-loans/overseas-earnings-thresholds-for-postgraduate-student-loans-2020-21"
  )
  
  # Check that the websites still exist
  #check_sites_exist <- RCurl::url.exists(urls)
  #if (!any(check_sites_exist)) stop("One or more of the websites no longer exist.")
  
  # If they exist, check they all contain a html table with the thresholds
  tables_ls <- lapply(urls, function(url) rvest::html_table(rvest::read_html(url)))
  tables_check <- vapply(tables_ls, length, FUN.VALUE = integer(1))
  
  if (any(tables_check == 0)) {
    locs <- paste(names(tables_ls[which(tables_check == 0)]), collapse = ", ")
    mssg <- paste0("The website(s) for ", locs, " loan thresholds do not contain any tables.")
    stop(mssg)
  } 
  
  # Read-in
  plan_1 <- data.table::data.table(tables_ls[["plan_1"]][[1]])
  plan_2 <- data.table::data.table(tables_ls[["plan_2"]][[1]])
  data.table::setnames(x = plan_2, old = "Lower earnings threshold (GBP)", new = "Earnings threshold (GBP)")
  postgrad <- data.table::data.table(tables_ls[["postgraduate"]][[1]])
  
  # Bind together
  thresholds_df <- rbind(plan_1, plan_2, postgrad, fill = TRUE, idcol = "loan_type")
  thresholds_df <- janitor::clean_names(thresholds_df)
  
  # Label loan types and prepare data
  thresholds_df[, loan_type := factor(loan_type,
    levels = c(1, 2, 3),
    labels = c("Plan 1", "Plan 2", "postgraduate")
  )]
  
  thresholds_df[, study_type := ifelse(
    loan_type == "postgraduate", 
    "postgraduate", 
    "undergraduate"
  )]

  thresholds_df[, prop_over_threshold := ifelse(
    loan_type == "postgraduate",
    0.06, # 6 % above
    0.09 # 9 % above
  )]
  
  # Prepare currency columns
  currency_cols <- grep(x = colnames(thresholds_df), pattern = "gbp$")
  thresholds_df[, (currency_cols) := lapply(
    .SD, function(col) strex::str_first_currency(string = col)$amount
  ), .SDcols = currency_cols]
  
  return(thresholds_df)
}
