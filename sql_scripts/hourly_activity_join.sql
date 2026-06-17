4. File Name: hourly_activity_join.sql
/*
===============================================================================
🔀 PART 1: RELATIONAL DATA MERGE (LEFT JOIN)
===============================================================================
Objective: 
- Combine cleaned metrics utilizing shared composite keys (Id and ActivityHour).
- Import step metrics directly alongside baseline activity intensities.
*/

-- CREATE OR REPLACE TABLE `skilful-answer-498915-k5.user_data.hourly_activity` AS
SELECT
  intensity.Id,
  intensity.ActivityHour,
  intensity.TotalIntensity,
  intensity.Activity_Level,
  steps.StepTotal -- Imports tracking column from the steps view
FROM `skilful-answer-498915-k5.user_data.cleaned_hourly_intensities` AS intensity
LEFT JOIN `skilful-answer-498915-k5.user_data.cleaned_hourly_steps` AS steps
  ON intensity.Id = steps.Id
  AND intensity.ActivityHour = steps.ActivityHour;


/*
===============================================================================
🛠️ PART 2: DATE PARSING & FEATURE ENGINEERING FOR TABLEAU
===============================================================================
Objective: 
- Isolate explicit numeric hour streams (0-23) and categorical days of the week.
- Generate parsed dimensions ready for seamless heatmap visualization modeling.
*/

-- 1. Engineering Hourly Metrics View
SELECT
  Id,
  ActivityHour,
  -- Extracts just the hour baseline number (0 to 23)
  EXTRACT(HOUR FROM ActivityHour) AS HourOfDay,
  -- Extracts the day of the week as a full text name string (e.g., 'Sunday')
  FORMAT_TIMESTAMP('%A', ActivityHour) AS DayOfWeek,
  TotalIntensity,
  StepTotal
FROM `skilful-answer-498915-k5.user_data.hourly_activity`;

-- 2. Engineering Daily Metrics View
SELECT 
  Id,
  ActivityDate,
  -- Extracts the day of the week for macro lifestyle analyses
  FORMAT_DATE('%A', ActivityDate) AS DayOfWeek,
  TotalSteps
FROM `skilful-answer-498915-k5.user_data.cleaned_daily_activity`;
