2. File Name: hourly_intensities_cleaning.sql
/*
===============================================================================
🎯 PART 1: HOURLY INTENSITIES TABLE TRANSFORMATION & PIPELINE
===============================================================================
Objective: 
- Standardize the tracking ID format and exclude irrelevant source metrics.
- Sort chronologically by the tracking hour interval in descending order.
*/

CREATE OR REPLACE TABLE `skilful-answer-498915-k5.user_data.cleaned_hourly_intensities` AS
SELECT 
  TRIM(CAST(Id AS STRING)) as Id, -- Removes spaces and converts Id to String
  ActivityHour,
  TotalIntensity -- Keeps analytical focus narrow and clean
FROM `skilful-answer-498915-k5.user_data.hourly_intensities`
ORDER BY ActivityHour DESC;


/*
===============================================================================
🧪 PART 2: QUALITY ASSURANCE & VALIDATION CHECKS
===============================================================================
*/

-- 1. NULL / Blank Cell Validation Check
SELECT *
FROM `skilful-answer-498915-k5.user_data.cleaned_hourly_intensities`
WHERE
 Id IS NOT NULL
 AND ActivityHour IS NOT NULL
 AND TotalIntensity IS NOT NULL
 AND activity_level IS NOT NULL;

-- 2. Duplicate Entry Validation Check
SELECT
 Id,
 ActivityHour,
 COUNT(*) AS row_count
FROM `skilful-answer-498915-k5.user_data.cleaned_hourly_intensities`
GROUP BY Id, ActivityHour
HAVING COUNT(*) > 1;

-- 3. Distinct User Volume Baseline Verification (Expected output: 33)
SELECT
 COUNT(DISTINCT Id) AS users_count
FROM `skilful-answer-498915-k5.user_data.cleaned_hourly_intensities`;
