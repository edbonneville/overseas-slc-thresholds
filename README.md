# Overseas UK Student Loan Repayments

> I took out a loan to study in the UK for university and now live/work overseas. How much will I have to pay back this year?

The shiny app hosted [here](http://edbonneville.shinyapps.io/overseas-slc-thresholds) answers the above question, as a means to a) plan your payments for the upcoming year, and b) fact-check correspondence between yourself and [Student Loans Company](https://www.gov.uk/government/organisations/student-loans-company) (SLC).

## Background

The data used in the app is based entirely on the official tables for overseas income thresholds on the gov.uk site, respectively for [Plan 1](https://www.gov.uk/government/publications/overseas-earnings-thresholds-for-plan-1-student-loans/overseas-earnings-thresholds-for-plan-1-student-loans-2023-24), [Plan 2](https://www.gov.uk/government/publications/overseas-earnings-thresholds-for-plan-2-student-loans/overseas-earnings-thresholds-for-plan-2-student-loans-2023-24) and [Postgraduate](https://www.gov.uk/government/publications/overseas-earnings-thresholds-for-postgraduate-student-loans/overseas-earnings-thresholds-for-postgraduate-student-loans-2023-24) loans. If you do not know which plan you are on, you can read the [relevant page](https://www.gov.uk/repaying-your-student-loan/which-repayment-plan-you-are-on) or [log in](https://www.gov.uk/sign-in-to-manage-your-student-loan-balance) to your account.

Depending on your country of residence, you will need an annual gross income above a certain threshold (in British pound sterling, GBP) to repay your loan. If your income is below this threshold, no repayments are required. If your income exceeds this threshold, you will need to pay back a percentage of the *difference* between your income and the threshold over a whole year. For Plan 1 and 2 undergraduate loans, this is set at 9%, while for Postgraduate loans this is set at 6%.

## Application usage

You must provide the application with three pieces of information:

- Your current country of residence.
- The type(s) of loan you have taken out. One or more options may be selected.
- Your gross (pre-tax) annual income in your **local** currency. For example, if you live in France this would be in Euros.

Given this information, the app will:

- Convert your salary to GBP.
- Applying repayment rules based on the selected loan types.
- Calculate and report total amount to repay, as well as provide explanations for it.

## Running the app locally

``` r
# Check for and install (if necessary) packages
if (!require("pacman")) install.packages("pacman"); library(pacman)

pacman::p_load(
  "shiny",
  "shinydashboard",
  "markdown",
  "RCurl",
  "rvest",
  "data.table",
  "janitor",
  "strex"
)

# Run app
shiny::runGitHub("overseas-slc-thresholds", "edbonneville")
```

## Is it worth making additional repayments?

There are already well developed calculators aimed at answering this, see for example [here](https://www.student-loan-calculator.co.uk/) and [here](https://yourslrc.co.uk/). You may take your income (converted to GBP by the current app), and supply it to one of these calculators along with your current debt balance to get your own assessment.
