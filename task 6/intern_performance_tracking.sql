DROP TABLE intern_performance;
CREATE TABLE intern_performance (
    intern_id             INT,
    intern_name           VARCHAR(100),
    department            VARCHAR(100),
    task_name             VARCHAR(150),
    assigned_date         DATE,
    submitted_date        DATE,
    quality_score         INT,
    mentor_rating         INT,
    task_completion_days  INT,
    quality_percent       INT,
    overall_score         FLOAT,
    status                VARCHAR(50)
);
COPY intern_performance
FROM 'D:\Internee.pk_internship_tasks\task 6\intern_performance_1.csv'
DELIMITER ','
CSV HEADER;
SELECT *
FROM intern_performance;

--Top performers overall:
SELECT intern_name, department,
       ROUND(AVG(overall_score)::NUMERIC, 2) AS avg_score,
       ROUND(AVG(mentor_rating)::NUMERIC, 2) AS avg_mentor,
       COUNT(*) AS tasks_done
FROM intern_performance
GROUP BY intern_id, intern_name, department
ORDER BY avg_score DESC;

--Interns needing improvement:
SELECT intern_name, department, task_name, overall_score, status
FROM intern_performance
WHERE status = 'Needs Improvement'
ORDER BY overall_score ASC;

---Monthly KPI summary (filter by month):
SELECT intern_name, department,
       COUNT(*)                                    AS tasks_completed,
       ROUND(AVG(task_completion_days)::NUMERIC,2) AS avg_days,
       ROUND(AVG(quality_score)::NUMERIC,2)        AS avg_quality,
       ROUND(AVG(mentor_rating)::NUMERIC,2)        AS avg_mentor,
       ROUND(AVG(overall_score)::NUMERIC,2)        AS avg_overall
FROM intern_performance
WHERE EXTRACT(MONTH FROM submitted_date) = EXTRACT(MONTH FROM CURRENT_DATE)
  AND EXTRACT(YEAR  FROM submitted_date) = EXTRACT(YEAR  FROM CURRENT_DATE)
GROUP BY intern_id, intern_name, department
ORDER BY avg_overall DESC;

--Department-level averages:
SELECT department,
       ROUND(AVG(overall_score)::NUMERIC,2)        AS avg_score,
       ROUND(AVG(task_completion_days)::NUMERIC,2)  AS avg_days,
       ROUND(AVG(mentor_rating)::NUMERIC,2)         AS avg_mentor,
       COUNT(DISTINCT intern_id)                    AS total_interns
FROM intern_performance
GROUP BY department
ORDER BY avg_score DESC;

---Status breakdown per intern:
SELECT intern_name,
       COUNT(*) FILTER (WHERE status = 'Excellent')         AS excellent,
       COUNT(*) FILTER (WHERE status = 'Good')              AS good,
       COUNT(*) FILTER (WHERE status = 'Needs Improvement') AS needs_improvement
FROM intern_performance
GROUP BY intern_id, intern_name
ORDER BY excellent DESC;

---  View for Reports
CREATE VIEW intern_kpi_summary AS
SELECT
    intern_id,
    intern_name,
    department,
    COUNT(*)                                         AS tasks_completed,
    ROUND(AVG(task_completion_days)::NUMERIC, 2)     AS avg_completion_days,
    ROUND(AVG(quality_score)::NUMERIC, 2)            AS avg_quality_score,
    ROUND(AVG(mentor_rating)::NUMERIC, 2)            AS avg_mentor_rating,
    ROUND(AVG(overall_score)::NUMERIC, 2)            AS avg_overall_score,
    COUNT(*) FILTER (WHERE status = 'Excellent')     AS excellent_count,
    COUNT(*) FILTER (WHERE status = 'Needs Improvement') AS needs_improvement_count
FROM intern_performance
GROUP BY intern_id, intern_name, department;


SELECT * FROM intern_kpi_summary ORDER BY avg_overall_score DESC;