# Data_365_sql

## Data 365 SQL Project: Free-to-Paid Conversion Rate Analysis

Description:
This project analyzes Data 365's dataset, focusing on student engagement and purchases. Key questions addressed include:

### Conversion Rate Analysis:

What is the free-to-paid conversion rate of students who watched a lecture on the 365 platform?

**Methodology:**

- Utilized MySQL for data processing and analysis.
- Joined tables on student engagement and purchases.
- Calculated additional fields for dates and duration.
- Conducted subqueries to determine conversion rate.

**Results:**

![Conversion rate](image/conversion_rate_chart.png)

Conversion rate: <b/>11.29%</b>

### Duration Analysis:

- What is the average duration between registration and the first lecture?
- What is the average duration between the first lecture and the first subscription purchase?

**Methodology:**

Exported results to Python for further analysis and visualizations.

**Results:**

![reg_engagement engagement_purchase](image/stripplot_subplots.png)

- Average days between registration and first lecture: <b/>3.42</b>
- Average days between engagement and purchase: <b/>26.24</b>

**Interpretation:**

- Explore reasons for registration to understand low conversion.
- Investigate topics with higher conversion rates.
- Address outliers in engagement duration.

### Additional Insights:

- Explored general relationship between registration and purchase.
![reg_purchase](image/reg_puchase.png)
    -    Interpretation: Identify potential areas for improvement in the user journey.

- Analyzed seasonal variations in registrations and purchases.
![change by month](image/grouped_bar_reg_purchase.png)
    -    Interpretation: Tailor marketing strategies based on seasonal trends.

## Data 365 SQL Project: Student Streaks Analysis

Description:
This project analyzes streak data to identify top learners for feedback. Key question:

What users have the longest streaks?

**Methodology:**

- Processed streak data in MySQL.
- Calculated streak lengths, considering activity and freezes.
- Identified top users and exported results to Python.

**Results:**

![Max Streak Length](image/max_streak_length_histogram.png)

<b/36 users</b> with streaks of 30 for additional feedback.



### Additional Insights:

- Explored relationships between streak length and freezes.
![Freezing correlation](image/correlation_heatmap.png)
    -    Interpretation: Relationship between streak length and use of freezes is exceptionally low.
- Analyzed user activity patterns by date and day of the week.
![date analysis](image/stacked_bar_chart.png)
    -    Interpretation: Recognized patterns of decreased use on weekends and during holidays.
- Investigated overall user activity, showing a dedicated user group.
![activity anaylsis](image/subplots_histograms.png)
    -    Interpretation: Most users try the platform for a short period, but a dedicated group completes the streak.



