/*
Project is part of Data 365: Student Streaks Analysis with SQL Project

Background: A key metric that stands out in the online education field is the streak—the number of consecutive interactions counted by days. 
EdTech businesses and learning platforms leverage this type of user data to reveal patterns of commitment, consistency, and dedication. 
Steaks are a crucial part of such companies’ data analysis processes as they communicate important insights about how (and how often) people engage 
with the product. In this Student Steaks Analysis with SQL project, you’ll work with real-world data in SQL and a provided learning streak table to 
identify those students who’ve spent the most time on the 365 Data Science website.  

The Database: To identify the most engaged students, the SQL practice project provides a MySQL database for you to use in Workbench. Inside, you’ll 
find a user streaks table that includes the following fields:

 streak_id  – Unique identifier for each streak record
 user_id  – Identifier for each user
 streak_active  – A Boolean field indicating whether the streak is currently active (True) or not (False)
 streak_frozen  – A Boolean field indicating whether the streak is currently frozen (True) or not (False)
 streak_platform  – The platform on which the streak was recorded
 streak_created  – The date when the streak was started or updated

Calculating Longest Streaks: Calculate each user’s most extended streak length. The metric’s duration increments each day the user remains active, 
and they haven’t frozen their streak manually to preserve their progress. The length is not extended when there’s no new interactions or when the 
streak is frozen. */

-- selecting the database.

use streaks; 

-- Initialize the Variables.
SET @streak_count := 0;
SET @streak_length := 0;
SET @prev_user_id_count := null;
SET @prev_streak_created := null;

-- Making sure temp table does not already exist. 
DROP TABLE IF EXISTS streaks_temp;

-- Creating temporary table for main question and creating further queries for additional analysis.
CREATE TEMPORARY TABLE streaks_temp AS
SELECT
    user_id,
    streak_id,
    streak_platform,
    streak_frozen,
    streak_active,
    streak_created,
    @streak_count := IF(user_id <> @prev_user_id_count OR DATEDIFF(streak_created, @prev_streak_created) > 1, 1, IF(DATEDIFF(streak_created, @prev_streak_created) = 1 AND streak_active = 1, @streak_count + 1, @streak_count)) AS streak_count,
    @streak_length := IF(user_id <> @prev_user_id_count OR DATEDIFF(streak_created, @prev_streak_created) > 1 OR streak_active = 0, 0,
                        IF(DATEDIFF(streak_created, @prev_streak_created) = 0, @streak_length, 
                           IF(streak_active = 1, @streak_length + 1, 1))) AS streak_length,
    IF(user_id <> @prev_user_id_count, NULL, DATEDIFF(streak_created, @prev_streak_created)) AS days_between_created,
    @prev_user_id_count := user_id,
    @prev_streak_created := streak_created
FROM
    user_streaks_sql
ORDER BY
    user_id, streak_created;

-- Checking for users with highest streak_length.
    
SELECT
    user_id,
    MAX(streak_length) AS max_streak_length
FROM
    streaks_temp
GROUP BY
    user_id
HAVING
    max_streak_length >= 30;
    
-- this returned 36 users that had a streak length of 30, as 30 being the highest streak_length returned.  

-- Checking for user with highest streak_count.

SELECT
    user_id,
    MAX(streak_count) AS max_streak_count,
    MAX(streak_length) AS max_streak_length
FROM
    streaks_temp
GROUP BY
    user_id
Order by
	max_streak_count desc;
    
-- the same 36 user were listed with a max_streak_count of 31.

/* answer the questions asked the streaks of activity and length. Beginning to look at additional areas of analysis such as patterns of freezing streaks,  
days of the week analysis, and total activity vs. inactivity.  
*/ 

-- Looking for patterns in freezing streaks.

Select user_id, streak_frozen, streak_created
From streaks_temp
WHERE streak_frozen > 0
Order by user_id, streak_created Desc;

-- 459 instances of streaks being frozen.  Exporting for further analysis.

-- Looking at sums of frozen streaks compared to max streak length to see the relationship between the two variables.  Only a limited number of users used the freezing function.
Select user_id, sum(streak_frozen), max(streak_length)
from streaks_temp
Group by user_id
Order by sum(streak_frozen) desc;

-- Looking at the number days between activity for users.

select user_id, days_between_created, streak_created  
from streaks_temp
Order by days_between_created desc;
    
-- For day of the week and day of month summary.  

SELECT
    DATE(streak_created) AS streak_date,
    DAYNAME(streak_created) AS day_of_week,
    SUM(CASE WHEN streak_active = 1 THEN 1 ELSE 0 END) AS active_streaks,
    SUM(CASE WHEN streak_frozen > 0 THEN 1 ELSE 0 END) AS frozen_streaks
FROM
    streaks_temp
GROUP BY
    streak_date, day_of_week
ORDER BY
    streak_date, day_of_week;
    
-- Exploring the total activity, inactivity, frozen activities, and length between the first an last activity.

SELECT
    user_id,
    SUM(streak_active) AS total_activity_count, -- this allows for days where users had more than one entry
    CASE WHEN DATEDIFF(MAX(streak_created), MIN(streak_created)) + 1 = 0 THEN 1 ELSE DATEDIFF(MAX(streak_created), MIN(streak_created)) + 1 END AS days_between_first_last_streak,
    GREATEST(0, CASE WHEN DATEDIFF(MAX(streak_created), MIN(streak_created))+ 1 = 0 THEN 1 ELSE DATEDIFF(MAX(streak_created), MIN(streak_created)) + 1 END - SUM(streak_active)) AS total_days_inactive, -- this prevents negative days of activity for user that had multiple entries in a single day
    SUM(streak_frozen) AS total_frozen_streaks,
    MAX(streak_created) AS max_streak_created,
    MIN(streak_created) AS min_streak_created
FROM
    streaks_temp
GROUP BY
    user_id;