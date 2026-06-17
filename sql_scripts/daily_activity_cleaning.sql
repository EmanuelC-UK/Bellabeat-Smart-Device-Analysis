1. File Name: daily_activity_cleaning.sql
/*
===============================================================================
🎯 PART 1: DAILY ACTIVITY TABLE TRANSFORMATION & PIPELINE
===============================================================================
Objective: 
- Exclude non-essential metrics to focus strictly on core engagement variables.
- Standardize the 'Id' column data type from INTEGER to STRING and trim margins.
- Discard entries containing 0 total steps to filter out non-wear time intervals.
- Order by 'ActivityDate' in descending order to review recent timelines first.
*/

CREATE OR REPLACE TABLE `skilful-answer-498915-k5.user_data.cleaned_daily_activity` AS
SELECT
  TRIM(CAST(Id AS STRING)) AS Id, -- Changes Id from INTEGER to STRING and trims whitespaces
  ActivityDate,
  TotalSteps -- Left out other columns / irrelevant data
FROM `skilful-answer-498915-k5.user_data.daily_activity`
WHERE TotalSteps > 0 -- Got rid of 0 step rows
ORDER BY ActivityDate DESC; -- Most recent date at the top


/*
===============================================================================
🧪 PART 2: QUALITY ASSURANCE & VALIDATION CHECKS
===============================================================================
Objective:
- Verify structural integrity, check for duplicates, and validate null values.
*/

-- 1. NULL / Blank Cell Validation Check
SELECT *
FROM `skilful-answer-498915-k5.user_data.cleaned_daily_activity`
WHERE Id IS NULL
 OR ActivityDate IS NULL
 OR TotalSteps IS NULL
 OR CAST(TotalSteps AS STRING) = '';

-- 2. Duplicate Entry Validation Check (Id + ActivityDate composite key)
SELECT
 Id,
 ActivityDate,
  COUNT(*) AS row_count -- Creates a tracking matrix column
FROM `skilful-answer-498915-k5.user_data.cleaned_daily_activity`
GROUP BY Id, ActivityDate
HAVING COUNT(*) > 1; -- Will return rows if duplicates exist

-- 3. Distinct User Volume Baseline Verification (Expected output: 33)
SELECT
 COUNT(DISTINCT Id) AS users_count
FROM `skilful-answer-498915-k5.user_data.cleaned_daily_activity`;
