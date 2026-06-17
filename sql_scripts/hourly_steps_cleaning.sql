3. File Name: hourly_steps_cleaning.sql
/*
===============================================================================
🎯 PART 1: HOURLY STEPS TABLE TRANSFORMATION & PIPELINE
===============================================================================
Objective: 
- Format integer IDs to structured string variables and trim whitespace margins.
- Order chronologically by descending timestamps.
*/

CREATE OR REPLACE TABLE `skilful-answer-498915-k5.user_data.cleaned_hourly_steps` AS
SELECT
  TRIM(CAST(Id AS STRING)) AS Id,
  ActivityHour,
  StepTotal
FROM `skilful-answer-498915-k5.user_data.hourly_steps`
ORDER BY ActivityHour DESC;


/*
===============================================================================
🧪 PART 2: QUALITY ASSURANCE & VALIDATION CHECKS
===============================================================================
*/

-- 1. Duplicate Entry Validation Check
SELECT
 Id,
 ActivityHour,
 COUNT(*) AS row_count
FROM `skilful-answer-498915-k5.user_data.cleaned_hourly_steps`
GROUP BY Id, ActivityHour
HAVING COUNT(*) > 1;

-- 2. Distinct User Volume Baseline Verification (Expected output: 33)
SELECT
 COUNT(DISTINCT Id) AS users_count
FROM `skilful-answer-498915-k5.user_data.cleaned_hourly_steps`;
