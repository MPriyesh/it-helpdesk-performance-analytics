CREATE DATABASE it_helpdesk;
USE it_helpdesk;

CREATE TABLE departments (
    dept_id VARCHAR(10) PRIMARY KEY,
    dept_name VARCHAR(100),
    location VARCHAR(50),
    head_count INT,
    annual_budget_lakhs INT
);

CREATE TABLE employees (
    emp_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    dept_id VARCHAR(10),
    designation VARCHAR(50),
    experience_years INT,
    salary_lakhs DECIMAL(5,1),
    gender VARCHAR(10),
    joining_date DATE,
    performance_rating INT,
    certifications INT,
    attrition VARCHAR(5),
    work_mode VARCHAR(10),
    overtime VARCHAR(5),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE tickets (
    ticket_id VARCHAR(10) PRIMARY KEY,
    emp_id VARCHAR(10),
    dept_id VARCHAR(10),
    ticket_type VARCHAR(50),
    category VARCHAR(50),
    priority VARCHAR(20),
    status VARCHAR(20),
    raised_date DATE,
    resolved_date DATETIME,
    resolution_hrs DECIMAL(6,1),
    sla_breached VARCHAR(5),
    reopen_count INT,
    satisfaction_score INT,
    assigned_to VARCHAR(10),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);