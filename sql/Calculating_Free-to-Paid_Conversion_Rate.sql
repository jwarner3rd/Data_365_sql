/*This practice project allows you to apply your SQL knowledge to a real-world dataset. Once you complete all tasks, you will have found the answer to the following questions:

- What is the free-to-paid conversion rate of students who have watched a lecture on the 365 platform?
- What is the average duration between the registration date and when a student has watched a lecture for the first time (date of first-time engagement)?
- What is the average duration between the date of first-time engagement and when a student purchases a subscription for the first time (date of first-time purchase)?
- How can we interpret these results, and what are their implications?

*/

-- Selecting the database to use

USE db_course_conversions;

-- The main query.  Testing to make sure there are no errors and exporting.

SELECT
    student_info.student_id,
    student_info.date_registered AS date_registered,
    MIN(student_engagement.date_watched) AS first_date_watched,
    MIN(student_purchases.date_purchased) AS first_date_purchased,
    DATEDIFF(MIN(student_engagement.date_watched), student_info.date_registered) AS date_diff_reg_watch,
    DATEDIFF(MIN(student_purchases.date_purchased), MIN(student_engagement.date_watched)) AS date_diff_watch_purch
FROM
    student_info
JOIN
    student_engagement ON student_info.student_id = student_engagement.student_id
LEFT JOIN
    student_purchases ON student_info.student_id = student_purchases.student_id
GROUP BY
    student_info.student_id
HAVING
    first_date_watched IS NOT NULL
    AND (first_date_purchased IS NULL OR first_date_watched <= first_date_purchased);

-- Main query worked without error. Exporting to Python for further analysis.  Creating query and subquery to answer project questions. 

SELECT 
    ROUND(COUNT(a.first_date_purchased) / COUNT(a.first_date_watched) * 100, 2) AS conversion_rate,
    ROUND(SUM(a.date_diff_reg_watch) / COUNT(a.first_date_watched), 2) AS av_reg_watch,
    ROUND(SUM(a.date_diff_watch_purch) / COUNT(a.first_date_purchased), 2) AS av_watch_purch
FROM
    (
        -- Subquery
        SELECT 
            i.student_id,
            i.date_registered AS date_registered,
            MIN(e.date_watched) AS first_date_watched,
            MIN(p.date_purchased) AS first_date_purchased,
            DATEDIFF(MIN(e.date_watched), i.date_registered) AS date_diff_reg_watch,
            DATEDIFF(MIN(p.date_purchased), MIN(e.date_watched)) AS date_diff_watch_purch
        FROM
            student_info i
        LEFT JOIN
            student_engagement e ON i.student_id = e.student_id
        LEFT JOIN
            student_purchases p ON i.student_id = p.student_id
        GROUP BY
            i.student_id
        HAVING
            first_date_watched IS NOT NULL
            AND (first_date_purchased IS NULL OR first_date_watched <= first_date_purchased)
    ) a;

/* returned the following 

Conversion rate = 11.29% 
Average Registration to watch = 3.42 days 
Average Watch to purchase = 26.25 days  

Additional ideas Interpretation 

Well done in reaching this final part of the project! What you should’ve retrieved by now are the free-to-paid conversion rate of students  
who’ve started a lecture, the average duration between the registration date and date of first-time engagement, and the average duration  
between the dates of first-time engagement and first-time purchase. Now, it’s time to interpret the numbers you’ve obtained. 

First, consider the conversion rate and compare this metric to industry benchmarks or historical data. Second, examine the duration between  
the registration date and date of first-time engagement. A short duration—watching on the same or the next day—could indicate that the  
registration process and initial platform experience are user-friendly. At the same time, a longer duration may suggest that users are hesitant 
or facing challenges. Third, regarding the time it takes students to convert to paid subscriptions after their first lecture, a shorter span  
would suggest compelling content or effective up-sell strategies. A longer duration might indicate that students have been waiting for the  
product to be offered at an exclusive price. 

Optional: Using a tool different from SQL (e.g., Python), calculate the median and mode values of the date difference between registering and  
watching a lecture. Do the same for the date difference between watching a lecture and purchasing a subscription. Compare the two metrics of  
each set to their respective mean values. To interpret the results even better, create a distribution graph and try to understand the  
relationship between these metrics (mean, median, and mode). Focus on the following key points. 

Distribution Symmetry 

The distribution is likely symmetrical when the mean, median, and mode are equal or very close, forming a bell curve. If they differ, the data  
might be skewed to the left—indicated by a long tail on the left side—or to the right with a long tail on the right side. 

Outliers 

If the mean is much higher or lower than the median, it suggests that there are outliers. For instance, if the average time to purchase a  
subscription is significantly higher than the median, it may imply that a few students took an exceptionally long time to decide. 

Common Patterns 

If a specific value or set of values has a high frequency—corresponding to the mode of the dataset—it can spotlight common behaviors. For  
instance, a mode of zero or one day between registration and lecture viewing suggests that most students begin watching on the registration day 
or the day after. */ 

         