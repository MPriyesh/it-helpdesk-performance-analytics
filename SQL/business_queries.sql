1.cOverall SLA breach rate
SELECT 
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN sla_breached = 'Yes' THEN 1 ELSE 0 END) AS breached,
    ROUND(SUM(CASE WHEN sla_breached = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS breach_rate_pct
FROM tickets;

2. SLA breach by priority
SELECT 
    priority,
    COUNT(*) AS total,
    SUM(CASE WHEN sla_breached = 'Yes' THEN 1 ELSE 0 END) AS breached,
    ROUND(SUM(CASE WHEN sla_breached = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS breach_pct
FROM tickets
GROUP BY priority
ORDER BY breach_pct DESC;

3. Top 5 departments with most tickets
SELECT 
    d.dept_name,
    COUNT(t.ticket_id) AS total_tickets
FROM tickets t
JOIN departments d ON t.dept_id = d.dept_id
GROUP BY d.dept_name
ORDER BY total_tickets DESC
LIMIT 5;

4. Average resolution time by ticket type
SELECT 
    ticket_type,
    ROUND(AVG(resolution_hrs), 2) AS avg_resolution_hrs
FROM tickets
GROUP BY ticket_type
ORDER BY avg_resolution_hrs DESC;

5. Monthly ticket volume trend
SELECT 
    DATE_FORMAT(raised_date, '%Y-%m') AS month,
    COUNT(*) AS total_tickets
FROM tickets
GROUP BY month
ORDER BY month ASC;

6. Top 5 employees who resolved most tickets
SELECT 
    e.name,
    e.designation,
    COUNT(t.ticket_id) AS tickets_resolved
FROM tickets t
JOIN employees e ON t.assigned_to = e.emp_id
GROUP BY e.name, e.designation
ORDER BY tickets_resolved DESC
LIMIT 5;

7. Department wise attrition rate
SELECT 
    d.dept_name,
    COUNT(e.emp_id) AS total_employees,
    SUM(CASE WHEN e.attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(SUM(CASE WHEN e.attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(e.emp_id), 2) AS attrition_pct
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
ORDER BY attrition_pct DESC;

8. Overtime impact on attrition
SELECT 
    overtime,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_pct
FROM employees
GROUP BY overtime;

9. Average satisfaction score by ticket category
SELECT 
    category,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction,
    COUNT(*) AS total_tickets
FROM tickets
GROUP BY category
ORDER BY avg_satisfaction DESC;

10. Top 5 departments by budget vs head count
SELECT 
    dept_name,
    head_count,
    annual_budget_lakhs,
    ROUND(annual_budget_lakhs / head_count, 2) AS budget_per_employee_lakhs
FROM departments
ORDER BY budget_per_employee_lakhs DESC
LIMIT 5;

11. Tickets reopened more than once
SELECT 
    ticket_id,
    ticket_type,
    priority,
    reopen_count
FROM tickets
WHERE reopen_count > 1
ORDER BY reopen_count DESC; 

12. Work mode vs attrition
SELECT 
    work_mode,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_pct
FROM employees
GROUP BY work_mode
ORDER BY attrition_pct DESC;

13. Critical tickets by department
SELECT 
    d.dept_name,
    COUNT(t.ticket_id) AS critical_tickets
FROM tickets t
JOIN departments d ON t.dept_id = d.dept_id
WHERE t.priority = 'Critical'
GROUP BY d.dept_name
ORDER BY critical_tickets DESC;

14. High performers with low salary (flight risk)
SELECT 
    e.name,
    e.designation,
    e.performance_rating,
    e.salary_lakhs,
    d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.performance_rating = 5
AND e.salary_lakhs < (
    SELECT AVG(salary_lakhs) FROM employees
)
ORDER BY e.salary_lakhs ASC;

15. Overall company health summary
SELECT 
    (SELECT COUNT(*) FROM tickets) AS total_tickets,
    (SELECT ROUND(AVG(resolution_hrs),2) FROM tickets) AS avg_resolution_hrs,
    (SELECT ROUND(SUM(CASE WHEN sla_breached='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) FROM tickets) AS sla_breach_pct,
    (SELECT ROUND(AVG(satisfaction_score),2) FROM tickets) AS avg_satisfaction,
    (SELECT ROUND(SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) FROM employees) AS attrition_pct,
    (SELECT ROUND(AVG(performance_rating),2) FROM employees) AS avg_performance;