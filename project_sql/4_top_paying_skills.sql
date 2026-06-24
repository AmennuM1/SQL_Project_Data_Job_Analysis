/*
Answer: What are the top skills based on salary?
 - Look at the average salary associated with each skill for Data Analyst positions
 - Focuses on roles with specified salaries, regardless of location
 - Why? It reveals how different skills impact salary levels for Data Analysts and
   helps identify the most financially rewarding skills to acquire or improve
*/
SELECT
    skills,
   ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25


/*
### Top 5 Insights from the Highest-Paying Data Analyst Skills (2023)

* **Python is the biggest differentiator.** Skills like PySpark, Pandas, NumPy, and Jupyter dominate the top-paying roles, showing that coding is becoming essential for high-end analytics jobs.

* **Data Engineering skills command the highest salaries.** Tools such as PySpark, Databricks, Airflow, and PostgreSQL suggest that the best-paid analysts are often building and managing data pipelines, not just analyzing data.

* **Cloud and infrastructure knowledge is increasingly valuable.** Skills like GCP, Kubernetes, and Linux appear frequently, indicating that analysts are expected to work within modern cloud-based data environments.

* **Machine Learning skills create a salary premium.** Technologies such as DataRobot, Watson, and Scikit-Learn show that companies pay more for analysts who can move beyond reporting into predictive analytics and AI-driven insights.

* **The highest-paying roles are hybrid roles.** Rather than pure Data Analyst positions, the top salaries go to professionals who combine **Analytics + Programming + Data Engineering + Cloud**, blurring the line between Data Analyst, Analytics Engineer, and Data Engineer.

*/