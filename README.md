# 📊 Intern Performance Tracking System

> A metrics-based system to evaluate, track, and report intern performance using KPIs, Python automation, and PostgreSQL.

## 🎯 Objective

Evaluate and track intern performance through a structured metrics-based system that automates data extraction and generates monthly reports for supervisors.

---

## 📌 KPIs Tracked

| KPI | Column | Description |
|-----|--------|-------------|
| ⏱️ Task Completion Time | `task_completion_days` | Days taken to complete a task |
| ⭐ Project Quality | `quality_score` / `quality_percent` | Output quality rated 1–10 |
| 🗣️ Mentor Feedback | `mentor_rating` | Supervisor rating per task |
| 📈 Overall Score | `overall_score` | Weighted composite score |

---

## Dataset 

| Column | Type | Description |
|--------|------|-------------|
| `intern_id` | INT | Unique intern identifier |
| `intern_name` | VARCHAR | Name of the intern |
| `department` | VARCHAR | Department (HR, Finance, Marketing, etc.) |
| `task_name` | VARCHAR | Name of the assigned task |
| `assigned_date` | DATE | Date task was assigned |
| `submitted_date` | DATE | Date task was submitted |
| `quality_score` | INT | Quality score (1–10) |
| `mentor_rating` | INT | Mentor rating (1–5) |
| `task_completion_days` | INT | Days to complete the task |
| `quality_percent` | INT | Quality as a percentage |
| `overall_score` | FLOAT | Weighted overall score |
| `status` | VARCHAR | Excellent / Good / Needs Improvement |

---

## 🗃️ PostgreSQL 

### Create Table

```sql
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
```

### Create KPI Summary View

```sql
CREATE VIEW intern_kpi_summary AS
SELECT
    intern_id,
    intern_name,
    department,
    COUNT(*)                                             AS tasks_completed,
    ROUND(AVG(task_completion_days)::NUMERIC, 2)         AS avg_completion_days,
    ROUND(AVG(quality_score)::NUMERIC, 2)                AS avg_quality_score,
    ROUND(AVG(mentor_rating)::NUMERIC, 2)                AS avg_mentor_rating,
    ROUND(AVG(overall_score)::NUMERIC, 2)                AS avg_overall_score,
    COUNT(*) FILTER (WHERE status = 'Excellent')         AS excellent_count,
    COUNT(*) FILTER (WHERE status = 'Needs Improvement') AS needs_improvement_count
FROM intern_performance
GROUP BY intern_id, intern_name, department;
```

---

## 📅 Automation (Monthly Scheduling)

### 

| Field | Value |
|-------|-------|
| Program/script | `C:\...\python.exe` |
| Arguments | `C:\...\scripts\monthly_report.py` |
| Trigger | Monthly — Day 1 — 8:00 AM |



---

## SQL Queries

**Top performers:**
```sql
SELECT intern_name, department, ROUND(AVG(overall_score)::NUMERIC, 2) AS avg_score
FROM intern_performance
GROUP BY intern_id, intern_name, department
ORDER BY avg_score DESC;
```

**Monthly report:**
```sql
SELECT intern_name, department,
       COUNT(*) AS tasks_completed,
       ROUND(AVG(overall_score)::NUMERIC, 2) AS avg_score
FROM intern_performance
WHERE EXTRACT(MONTH FROM submitted_date) = EXTRACT(MONTH FROM CURRENT_DATE)
  AND EXTRACT(YEAR  FROM submitted_date) = EXTRACT(YEAR  FROM CURRENT_DATE)
GROUP BY intern_id, intern_name, department
ORDER BY avg_score DESC;
```


## 👤 Author

 **Yasmeen Rafique**




