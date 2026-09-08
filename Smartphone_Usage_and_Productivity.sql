select * from smartphone_usage_and_productivity
-- Total Number of Survey Respondents
select COUNT(users) as total_participated  from smartphone_usage_and_productivity
-- Distribution of Respondents Who Use Productivity Applications
select COUNT(users), use_productive_apps from smartphone_usage_and_productivity
group by use_productive_apps 
-- Total Smartphone Users in the Survey
select COUNT(users) from smartphone_usage_and_productivity
-- Distribution of Productivity App Users by Smartphone Ownership Duration
select COUNT(users), use_productive_apps, smartphone_duration from smartphone_usage_and_productivity
group by smartphone_duration, use_productive_apps
order by use_productive_apps, COUNT(users) DESC;
-- Average Perceived Phone Efficiency Among Productivity App Users
select efficiency_of_phone, use_productive_apps, ROUND(AVG(users:: numeric),2) from smartphone_usage_and_productivity
Where use_productive_apps = 'Yes'
group by efficiency_of_phone, use_productive_apps
-- Smartphone Usage Distribution by Region
select region, smartphone_usage from smartphone_usage_and_productivity
group by region, smartphone_usage
-- Occupations with the Highest Use of Productivity Applications
select occupation, use_productive_apps from smartphone_usage_and_productivity
Where use_productive_apps = 'Yes'
group by occupation, use_productive_apps
-- Gender Distribution of Respondents
select gender,COUNT(*) as user_per_gender from smartphone_usage_and_productivity
group by gender
-- Productivity App Usage by Gender
select gender, COUNT(*), use_productive_apps from smartphone_usage_and_productivity
group by gender, use_productive_apps
-- Distribution of Productivity App Users by Occupation
select COUNT(users), use_productive_apps, occupation from smartphone_usage_and_productivity
WHERE use_productive_apps = 'Yes'
group by occupation, use_productive_apps
-- Relationship Between Daily Smartphone Usage and Perceived Productivity
SELECT smartphone_daily,COUNT(*) AS total_users, productivity_impact AS average_productivity_score
FROM smartphone_usage_and_productivity
GROUP BY smartphone_daily, productivity_impact
ORDER BY average_productivity_score DESC;
-- Average Daily Smartphone Usage (Hours)
WITH usage_hours AS (
    SELECT *,
        CASE
            WHEN smartphone_daily = 'Less than 1 hour' THEN 0.5
            WHEN smartphone_daily = '1-2 hours' THEN 1.5
            WHEN smartphone_daily = '3-4 hours' THEN 3.5
            WHEN smartphone_daily = '5-6 hours' THEN 5.5
            WHEN smartphone_daily = '7-8 hours' THEN 7.5
            WHEN smartphone_daily = 'More than 8 hours' THEN 9
        END AS daily_hours
    FROM smartphone_usage_and_productivity
)

SELECT ROUND(AVG(daily_hours), 2) AS average_daily_usage
FROM usage_hours;
-- Average Number of Respondents by Productivity App Usage (although this query may not be very meaningful analytically)
select avg(users), use_productive_apps from smartphone_usage_and_productivity
group by use_productive_apps
-- Average Daily Smartphone Usage Across Age Groups
WITH age_groups AS (
    SELECT
        CASE
            WHEN age = 'Under 18' THEN 'Under 18'
            WHEN age = '18-25' THEN '18-25'
            WHEN age = '26-35' THEN '26-35'
        END AS age_group,

        CASE
            WHEN smartphone_daily = 'Less than 1 hour' THEN 0.5
            WHEN smartphone_daily = '1-2 hours' THEN 1.5
            WHEN smartphone_daily = '3-4 hours' THEN 3.5
            WHEN smartphone_daily = '5-6 hours' THEN 5.5
            WHEN smartphone_daily = '7-8 hours' THEN 7.5
            WHEN smartphone_daily = 'More than 8 hours' THEN 9
        END AS daily_hours

    FROM smartphone_usage_and_productivity
)

SELECT
    age_group,
    AVG(daily_hours) AS average_daily_usage
FROM age_groups
WHERE age_groups IS NOT NULL
GROUP BY age_group
ORDER BY average_daily_usage DESC;
-- Smartphone Usage Distribution by Gender
select gender, smartphone_daily from smartphone_usage_and_productivity
group by gender, smartphone_daily
-- Occupations with the Highest Average Daily Smartphone Usage
WITH usage_hours AS (
    SELECT
        occupation,
        CASE
            WHEN smartphone_daily = 'Less than 1 hour' THEN 0.5
            WHEN smartphone_daily = '1-2 hours' THEN 1.5
            WHEN smartphone_daily = '3-5 hours' THEN 4
            WHEN smartphone_daily = '6-8 hours' THEN 7
            WHEN smartphone_daily = 'More than 8 hours' THEN 9
        END AS daily_hours
    FROM smartphone_usage_and_productivity
)

SELECT
    occupation,
    ROUND(AVG(daily_hours), 2) AS average_daily_usage
FROM usage_hours
WHERE average_daily_usage 
GROUP BY occupation
ORDER BY average_daily_usage DESC;
-- Relationship Between Daily Smartphone Usage and Perceived Productivity Impact
WITH productivity_analysis AS (
    SELECT
        CASE
            WHEN smartphone_daily = '2-4 hrs' THEN 3
            WHEN smartphone_daily = '4-6 hrs' THEN 5
            WHEN smartphone_daily = '6-8 hrs' THEN 7
            WHEN smartphone_daily = 'More than 8 hours' THEN 9
        END AS daily_hours,

        CASE
            WHEN smartphone_productivity_impact = 'Strongly disagree' THEN 1
            WHEN smartphone_productivity_impact = 'Disagree' THEN 2
            WHEN smartphone_productivity_impact = 'Neutral' THEN 3
            WHEN smartphone_productivity_impact = 'Agree' THEN 4
            WHEN smartphone_productivity_impact = 'Strongly agree' THEN 5
        END AS productivity_score
    FROM smartphone_usage_and_productivity
)

SELECT
    CASE
        WHEN daily_hours < 3 THEN 'Low Usage (<3 hrs)'
        WHEN daily_hours BETWEEN 3 AND 6 THEN 'Moderate Usage (3–6 hrs)'
        ELSE 'High Usage (>6 hrs)'
    END AS usage_category,
    ROUND(AVG(productivity_score), 2) AS average_productivity_score,
    COUNT(*) AS respondents
FROM productivity_analysis
WHERE daily_hours IS NOT NULL
  AND productivity_score IS NOT NULL
GROUP BY
    CASE
        WHEN daily_hours < 3 THEN 'Low Usage (<3 hrs)'
        WHEN daily_hours BETWEEN 3 AND 6 THEN 'Moderate Usage (3–6 hrs)'
        ELSE 'High Usage (>6 hrs)'
    END
ORDER BY average_productivity_score DESC;

-- Average Phone Checking Frequency Across Age Groups
WITH age_groups AS (
    SELECT
        CASE
            WHEN age = 'Under 18' THEN 'Under 18'
            WHEN age = '18-25' THEN '18-25'
            WHEN age = '26-35' THEN '26-35'
			WHEN age = '36-45' THEN '36-45'
        END AS age_group,

        CASE
            WHEN daily_phone_check = 'Rarely' THEN 1
            WHEN daily_phone_check = 'Every hour' THEN 2
            WHEN daily_phone_check = 'Occasionally' THEN 3
            WHEN daily_phone_check = 'Several times per hour' THEN 4
            WHEN daily_phone_check = 'Almost constantly' THEN 5
        END AS phone_checks
    FROM smartphone_usage_and_productivity
)

SELECT
    age_group,
    ROUND(AVG(phone_checks), 2) AS average_phone_checks
FROM age_groups
WHERE age_group IS NOT NULL
GROUP BY age_group
ORDER BY average_phone_checks DESC;
-- Most Common Productivity Challenges Reported by Respondents
SELECT productivity_usage_challenges, COUNT(*) AS respondent_count FROM smartphone_usage_and_productivity
GROUP BY productivity_usage_challenges
ORDER BY respondent_count DESC;
-- Most Frequently Used Productivity Applications
SELECT productive_applications, COUNT(*) as user_count FROM smartphone_usage_and_productivity
WHERE productive_applications IS NOT NULL
GROUP BY productive_applications
ORDER BY user_count DESC;
-- Most Common Smartphone Usage Management Strategies
SELECT smartphone_usage_management_strategies, COUNT(*) AS total_users FROM smartphone_usage_and_productivity
WHERE smartphone_usage_management_strategies IS NOT NULL
GROUP BY smartphone_usage_management_strategies
ORDER BY total_users DESC;
-- Average Daily Smartphone Usage by Region
WITH usage_hours AS (
    SELECT
        region,
        CASE
            WHEN smartphone_daily = 'Less than 1 hour' THEN 0.5
            WHEN smartphone_daily = '1-2 hours' THEN 1.5
            WHEN smartphone_daily = '3-5 hours' THEN 4
            WHEN smartphone_daily = '6-8 hours' THEN 7
            WHEN smartphone_daily = 'More than 8 hours' THEN 9
        END AS daily_hours
    FROM smartphone_usage_and_productivity
)

SELECT
    region,
    ROUND(AVG(daily_hours), 2) AS avg_phone_usage
FROM usage_hours
WHERE daily_hours IS NOT NULL
GROUP BY region
ORDER BY avg_phone_usage DESC;
-- Comparison of Perceived Productivity Between Productivity App Users and Non-Users
WITH productivity_scores AS (
    SELECT
        use_productive_apps,
        CASE
            WHEN productive_usage_ = 'Always' THEN 5
            WHEN productive_usage_ = 'Often' THEN 4
            WHEN productive_usage_ = 'Sometimes' THEN 3
            WHEN productive_usage_ = 'Rarely' THEN 2
        END AS productivity_score
    FROM smartphone_usage_and_productivity
)

SELECT
    use_productive_apps,
    ROUND(AVG(productivity_score), 2) AS avg_productivity
FROM productivity_scores
GROUP BY use_productive_apps;
-- Average Smartphone Distraction Frequency Across Age Groups
WITH distraction_scores AS (
    SELECT 
        CASE
            WHEN age = 'Under 18' THEN 'Under 18'
            WHEN age = '18-25' THEN '18-25'
            WHEN age = '26-35' THEN '26-35'
			WHEN age = '36-45' THEN '36-45'
        END AS age_group,
        CASE
            WHEN smartphone_distraction_frequency = 'Never' THEN 1
            WHEN smartphone_distraction_frequency = 'Rarely' THEN 2
            WHEN smartphone_distraction_frequency = 'Sometimes' THEN 3
            WHEN smartphone_distraction_frequency = 'Often' THEN 4
            WHEN smartphone_distraction_frequency = 'Always' THEN 5
        END AS distraction_score
    FROM smartphone_usage_and_productivity
)

SELECT 
    age_group,
    ROUND(AVG(distraction_score), 2) AS average_distraction
FROM distraction_scores
GROUP BY age_group
ORDER BY average_distraction DESC;

-- Most Common Suggestions for Improving Smartphone Usage Habits
SELECT
    productivity_improvement_suggestions,
    COUNT(*) AS frequency
FROM smartphone_usage_and_productivity
WHERE productivity_improvement_suggestions IS NOT NULL
GROUP BY productivity_improvement_suggestions
ORDER BY frequency DESC;

-- adding new columns to change the text columns to numeric
ALTER TABLE smartphone_usage_and_productivity
ADD COLUMN daily_hours NUMERIC;
UPDATE smartphone_usage_and_productivity
SET daily_hours =
CASE
    WHEN smartphone_daily = '2-4 hrs' THEN 3
    WHEN smartphone_daily = '4-6 hrs' THEN 5
    WHEN smartphone_daily = '6-8 hrs' THEN 7
    WHEN smartphone_daily = 'More than 8 hours' THEN 9
END;

-- daily hours average
SELECT ROUND(AVG(daily_hours),2)
FROM smartphone_usage_and_productivity;

-- adding new column for phone check scores
ALTER TABLE smartphone_usage_and_productivity
ADD COLUMN phone_check_score INTEGER;
-- updating it
UPDATE smartphone_usage_and_productivity
SET phone_check_score =
CASE
    WHEN daily_phone_check = 'Rarely' THEN 1
    WHEN daily_phone_check = 'Every hour' THEN 2
    WHEN daily_phone_check = 'Occasionally' THEN 3
    WHEN daily_phone_check = 'Several times per hour' THEN 4
    WHEN daily_phone_check = 'Almost constantly' THEN 5
END;

-- phone_check_scores
SELECT ROUND(AVG(phone_check_score),2)
FROM smartphone_usage_and_productivity;

-- adding a new column
ALTER TABLE smartphone_usage_and_productivity
ADD COLUMN productivity_score INTEGER;
-- updating it
UPDATE smartphone_usage_and_productivity
SET productivity_score =
CASE
    WHEN smartphone_productivity_impact = 'Strongly disagree' THEN 1
    WHEN smartphone_productivity_impact = 'Disagree' THEN 2
    WHEN smartphone_productivity_impact = 'Neutral' THEN 3
    WHEN smartphone_productivity_impact = 'Agree' THEN 4
    WHEN smartphone_productivity_impact = 'Strongly agree' THEN 5
END;

-- productivity_score
SELECT ROUND(AVG(productivity_score),2)
FROM smartphone_usage_and_productivity;

-- adding new column
ALTER TABLE smartphone_usage_and_productivity
ADD COLUMN distraction_score INTEGER;
-- updating
UPDATE smartphone_usage_and_productivity
SET distraction_score =
CASE
    WHEN smartphone_distraction_frequency = 'Never' THEN 1
    WHEN smartphone_distraction_frequency = 'Rarely' THEN 2
    WHEN smartphone_distraction_frequency = 'Sometimes' THEN 3
    WHEN smartphone_distraction_frequency = 'Often' THEN 4
    WHEN smartphone_distraction_frequency = 'Always' THEN 5
END;

-- distraction_score
SELECT ROUND(AVG(distraction_score),2)
FROM smartphone_usage_and_productivity;

