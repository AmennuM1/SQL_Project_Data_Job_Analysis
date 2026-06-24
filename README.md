# Introduciton 
📊 This project explores the Data Analyst job market using real-world job posting data. Through SQL analysis, it uncovers:

💰 The highest-paying Data Analyst roles

🔥 The most in-demand technical skills

📈 Skills associated with the highest salaries

🎯 The overlap between high demand and high compensation

🔍 Want to see how the insights were generated? Browse the SQL queries used throughout this analysis here: [project_sql folder](/project_sql/)

## Dataset

This project uses a real-world dataset of over **785,000 job postings** collected throughout **2023** by Luke Barousse for educational and career analysis. The data was gathered from **Google Job Search**, aggregating listings from sources such as LinkedIn, Indeed, company career pages, and other major job boards. It was then cleaned, standardized, and structured into a relational PostgreSQL database containing job postings, companies, and skills, making it well suited for practicing real-world SQL analysis.
The goal is to identify which skills provide the strongest career opportunities for aspiring and current data analysts.


# Background 
As I transition into Data Analytics, I wanted to better understand which skills create the strongest career opportunities in today's job market. This project was designed to analyze real-world Data Analyst job postings and identify the skills, technologies, and trends that drive both demand and compensation.

Using SQL, I explored 2023 job market data to uncover insights into salaries, required skills, and hiring patterns across the Data Analytics field.

The dataset contains thousands of job postings and includes information on job titles, salaries, locations, companies, and skill requirements.

### The questions I wanted to answer through my SQL analysis were:
1. What are the highest-paying Data Analyst jobs?
2. What skills are required for those high-paying roles?
3. Which skills are most in demand for Data Analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:
- **SQL:** Core tool used to query and analyze the dataset.
- **PostgreSQL:** Database management system used to store and query job market data.
- **Visual Studio Code:** SQL development environment and project workspace.
- **Git:** Version control system for tracking project changes.
- **GitHub:** Repository hosting and project portfolio presentation.
# The Analysis 
### **1. Top-Paying Data Analyst Jobs**
**Goal:** Identify the highest-paying Data Analyst positions and gain insight into where the most lucrative opportunities exist within the job market.

**Method:**  I used a ```LEFT JOIN``` to combine job postings with company information, filtered for remote Data Analyst positions with non-null salaries using ```WHERE```, sorted the results by salary in descending order with ```ORDER BY```, and returned the top 10 highest-paying jobs using ```LIMIT```.

### SQL Query
```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    company_dim.name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' 
AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL 
ORDER BY 
   salary_year_avg DESC
LIMIT 10;
```
**Results:**
![Top Paying Roles](assets\1_top_paying_jobs_img.png)
*Figure 1. Horizontal bar chart visualizing the average annual salary of the top 10 highest-paying remote Data Analyst jobs in 2023, AI generated from the SQL query results.*

**Insights:**
- The highest-paying role in the dataset was a Data Analyst position at Mantys, offering an annual salary of **$650,000**, nearly double the next highest-paying role.
- Several of the **top-paying positions were senior leadership** roles such as **Director of Analytics, Associate Director – Data Insights, and Director**. Suggesting that compensation increases significantly when analytics expertise is combined with **management responsibilities**.
- Remote work appears prevalent among high-paying opportunities, with all top 10 positions listed as "Anywhere", indicating that employers are willing to pay premium salaries for specialized analytical talent regardless of location.
- **Meta, AT&T, and SmartAsset** were among the companies offering some of the highest salaries, highlighting strong compensation within **large technology and data-driven organizations**.

**Key Takeaway:**
The highest salaries in the Data Analytics field are concentrated in senior-level, leadership, and principal analyst positions, particularly within technology-focused organizations. Additionally, the prevalence of remote opportunities among top-paying roles suggests that experienced analysts can access premium compensation without being restricted to a specific geographic market.
### **2. Skills Required for Top-Paying Data Analyst Jobs**
**Goal:** Determine which technical skills are most commonly associated with the highest-paying Data Analyst positions.

**Method:** I used a **CTE** to isolate the top 10 highest-paying remote Data Analyst jobs, then joined that result to the skills tables using ```INNER JOIN``` to identify which skills were required for those roles. The final results were ordered by salary to show the skills connected to the highest-paying opportunities first
### SQL Query
```sql
WITH  top_paying_jobs AS
(
SELECT
    job_id,
    job_title,
    salary_year_avg,
    company_dim.name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL 
ORDER BY 
   salary_year_avg DESC
LIMIT 10
)

SELECT 
  top_paying_jobs.*,
  skills
FROM top_paying_jobs 
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id  
ORDER BY salary_year_avg DESC; 
``` 
**Results:**

![Top Paying Skills](/assets/2_top_paying_skills_%20image.png)
*Figure 2. Horizontal bar chart showing the frequency of skills required across the top 10 highest-paying remote Data Analyst jobs in 2023, AI generated from the SQL query results.*


**Insights:**
- **SQL** is the most consistently required skill, appearing in **8 of the top 10** highest-paying remote Data Analyst roles. This reinforces SQL as the foundational skill for high-paying analytics positions.
- **Python and Tableau are also highly sought after**, appearing in **7 and 6** of the top-paying jobs, respectively. Together with SQL, they form the core technical stack most frequently requested by employers.
- **Cloud and modern data platform technologies are common differentiators**. Skills such as **Snowflake, Azure, AWS, Databricks, and Oracle** appear across several high-paying roles, indicating that experience with cloud-based data ecosystems is valuable for senior positions.
- **High-paying roles require diverse skill sets beyond analytics**. Many positions also list collaboration and engineering tools—including **GitLab, Bitbucket, Jira, Confluence, Atlassian, and Power BI.** Showing that senior Data Analysts are expected to work across cross-functional teams and modern data workflows.

**Key Takeaway:** The highest-paying Data Analyst roles require **more than strong analytical skills alone**. Employers consistently seek proficiency in **SQL, Python, and Tableau**, while experience with **cloud platforms, big data technologies, and collaboration** tools can further differentiate candidates pursuing senior and higher-paying opportunities.

### **3. Most In-Demand Skills for Data Analysts**
**Goal:** Identify the skills that appear most frequently across Data Analyst job postings.

**Method:** I used ```INNER JOIN``` to combine job postings with their associated skills, filtered for remote Data Analyst positions using ```WHERE```, counted skill occurrences with ```COUNT()```, grouped the results using ```GROUP BY```, and ranked the top 10 most in-demand skills with ```ORDER BY``` and ```LIMIT```.
### SQL Query
```sql
SELECT
  skills,
  COUNT(skills_job_dim.job_id) demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id 
WHERE job_title_short = 'Data Analyst'AND 
      job_work_from_home = TRUE  /*added to see remote jobs*/
GROUP BY 
  skills
ORDER BY 
  demand_count DESC
LIMIT 10 ; 
``` 
**Results:**

![Skills Demand](/assets/3_top_demanded_skills.png)

*Figure 3. Horizontal bar chart illustrating the 10 most frequently requested skills in remote Data Analyst job postings, based on demand count from the SQL query results.*

**Insights:**
- **SQL** was the most in-demand skill by a significant margin, appearing in **7,291 job postings**. This reinforces its position as the foundational language for querying, analyzing, and managing data across nearly all Data Analyst roles.
- **Excel** remains highly relevant in modern analytics, appearing in **4,611 postings**, making it the second most requested skill. Despite the rise of advanced analytics tools, **employers still value spreadsheet-based analysis, reporting, and business workflows**.
- **Python** ranked third with **4,330 postings**, highlighting the **growing demand** for analysts who can **automate processes, manipulate large datasets, and perform advanced analytical tasks** beyond traditional reporting.
- Data visualization skills are essential for analysts, with **Tableau (3,745 postings)** and **Power BI (2,609 postings)** both ranking in the top five. Employers continue to prioritize candidates who can transform data into actionable business insights through dashboards and visual storytelling.

**Key Takeaway:** The most **in-demand** Data Analyst skill set combines **data querying (SQL), spreadsheet analysis (Excel), programming (Python), and data visualization (Tableau and Power BI)**. Analysts who build proficiency across these core areas position themselves to qualify for the largest share of opportunities in the job market while **developing a strong foundation for future career growth**.

### 4. Highest-Paying Skills
**Goal:** Analyze which skills are associated with the highest average salaries across Data Analyst positions.

**Method:** I used ```INNER JOIN``` to combine job postings with their associated skills, filtered for remote Data Analyst positions with salary data using ```WHERE```, calculated the average salary for each skill with ```AVG()```, rounded the results using ```ROUND()```, grouped the data by skill with ```GROUP BY```, and ranked the top 25 highest-paying skills using ```ORDER BY``` and ```LIMIT```.
### SQL Query
```sql
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
``` 
**Results:**
![Top Paying Skills img](/assets/4_top_paying_skills_img.png)
*Figure 4. Horizontal bar chart displaying the top 15 highest-paying technical skills for remote Data Analyst roles, ranked by average annual salary from the SQL query results.*

**Insights:**
- PySpark commands the highest average salary at $208,172, significantly outperforming every other skill in the dataset. This suggests that expertise in distributed data processing and big data technologies is highly valued in remote Data Analyst roles.
- Many of the highest-paying skills extend beyond traditional data analysis, including technologies such as Databricks, Kubernetes, Airflow, Elasticsearch, and Golang. This indicates that employers are willing to pay a premium for analysts who can work with modern data infrastructure and engineering tools.
- Machine learning and data science libraries are well represented, with Pandas, NumPy, Scikit-learn, Jupyter, and DataRobot all appearing among the top-paying skills. This reflects the growing convergence between Data Analytics, Data Science, and AI-driven decision making.
- Collaboration and DevOps technologies also appear among the highest-paying skills, including GitLab, Bitbucket, Atlassian, and Jenkins. This suggests that organizations increasingly value analysts who can collaborate within software development workflows and contribute to production-ready data solutions.

**Key Takeaway:** The highest-paying remote Data Analyst positions reward professionals who combine traditional analytics expertise with modern data engineering, cloud, and machine learning technologies. While foundational tools remain essential, analysts who expand their skills into big data platforms, automation, and software development workflows position themselves for substantially higher earning potential.

### 5. Optimal Skills to Learn
**Goal:** Determine which skills offer the strongest combination of employer demand and salary potential.

**Method:** I used two CTEs to calculate skill demand with ```COUNT()``` and average salary with ```AVG()```, combined the results using an ```INNER JOIN```, filtered for skills appearing in more than 10 job postings, and ranked them by salary and demand using ```ORDER BY``` to identify the most valuable skills for remote Data Analyst roles.
### SQL Query
```sql
--CTE 1 Skill Demand 
WITH skills_demand AS (
    SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
   GROUP BY
    skills_dim.skill_id,
    skills_dim.skills
), 
--CTE 2 average salary
average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY 
        skills_job_dim.skill_id
)
-- JOINING SALARY AND SKILL DEMAND 
SELECT 
    skills_demand.skill_id, 
    skills_demand.Skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN 
    average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE demand_count > 10
ORDER BY 
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
``` 
**Results:**

![Optimal Skills](/assets/5_optimal_skills_img.png)

*Figure 5. Scatter plot comparing skill demand and average annual salary for remote Data Analyst roles, highlighting the technologies that provide the best balance between market demand and earning potential.*

**Insights:**
- **Python** stands out as the most well-rounded skill, combining the highest demand (236 job postings) with an average salary exceeding $101K. This places it firmly in the "sweet spot" for professionals seeking both abundant opportunities and strong earning potential.
- Cloud and big data technologies command premium salaries, with skills such as Go ($115K), Snowflake ($113K), Azure ($111K), and AWS ($108K) offering some of the highest average salaries. While these skills appear in fewer job postings, they provide excellent opportunities for specialization and salary growth.
- Tableau and R strike a strong balance between demand and compensation, appearing in 230 and 148 job postings respectively while maintaining salaries near or above $100K. This highlights the continued importance of data visualization and statistical analysis in the analytics field.
- Specialized enterprise technologies represent valuable niche opportunities. Skills such as Confluence, Hadoop, BigQuery, and Looker offer above-average salaries despite lower demand, suggesting they can differentiate candidates pursuing roles in enterprise data environments.

**Key Takeaway:** The optimal skills to learn are those that balance high market demand with strong salary potential. While foundational skills like Python, Tableau, and R provide the greatest number of career opportunities, expanding into cloud platforms (Azure, AWS), big data technologies (Snowflake, Hadoop), and modern data engineering tools can significantly increase long-term earning potential. A well-rounded Data Analyst skill set should combine widely requested core technologies with a select group of high-value specialized skills to maximize both employability and salary growth.
# What I learned 
### Working through this project strengthened both my SQL skills and my ability to extract meaningful insights from real-world data. Throughout the analysis, I gained hands-on experience with:
- Writing complex SQL queries using **CTEs, JOINs, subqueries, aggregate functions, and window functions**.
- **Cleaning, filtering, and transforming data** to answer specific business questions.
- Analyzing salary and skill trends to identify **actionable insights** from large datasets.
- **Connecting multiple relational tables** to build comprehensive analyses.
- Presenting technical findings through **clear visualizations** and **well-documented results**.
- Using **Git** and **GitHub** to manage version control and publish a professional data analytics portfolio project.

This project not only reinforced the importance of using data to support decision-making and demonstrated how SQL can be leveraged to uncover valuable insights from real-world datasets but also have me a personal roadmap of skills to learn as I dive deaper into my Data Analytics journey. 

# Conclusions 

This project explored the Data Analyst job market through the lens of salary, employer demand, and technical skill requirements. By analyzing thousands of job postings, I was able to identify which skills are most valuable, which technologies command the highest salaries, and where demand is strongest.

The findings show that while foundational skills like SQL remain essential across the industry, specialized technologies often provide greater earning potential. Evaluating both salary and demand together provides a more complete picture of which skills offer the best long-term career opportunities.

Overall, this project demonstrates the power of SQL for transforming raw data into actionable business insights and reflects the analytical thinking required of a Data Analyst. It also serves as a strong foundation for more advanced data analytics and data engineering projects in the future.

