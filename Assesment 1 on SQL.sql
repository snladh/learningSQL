-- Databricks notebook source
-- Assessment on SQL

-- Schema and data for Employee table:

CREATE TABLE Employee1 (
    EmployeeID INT,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary INT,
    JoiningDate DATE
);

-- Inserting values in the table.

INSERT INTO Employee1 (EmployeeID, Name, Department, Salary, JoiningDate) VALUES
(1, 'Alice', 'Sales', 70000, '2021-03-15'),
(2, 'Bob', 'Sales', 68000, '2022-04-20'),
(3, 'Charlie', 'Marketing', 72000, '2020-07-30'),
(4, 'David', 'Marketing', 75000, '2021-11-25'),
(5, 'Eve', 'Sales', 69000, '2020-02-10'),
(6, 'Frank', 'HR', 66000, '2019-05-15'),
(7, 'Grace', 'HR', 64000, '2021-06-10'),
(8, 'Hannah', 'Finance', 73000, '2022-08-19'),
(9, 'Ian', 'Finance', 71000, '2020-03-05'),
(10, 'Jack', 'Sales', 78000, '2023-01-10'),
(11, 'Kara', 'Marketing', 80000, '2022-05-05'),
(12, 'Liam', 'Finance', 72000, '2021-01-30');


-- COMMAND ----------

-- Displaying the table

select * from Employee1;

-- COMMAND ----------

-- Question 1: Find the total number of employees and the average salary for each department.

SELECT Department, avg(SALARY) AS avg_salary, count(Department) AS num_employees
FROM Employee1
GROUP BY Department;

-- COMMAND ----------

-- Question 2: List each employee’s name, department, salary, and their rank based on salary within their department

SELECT Name, Department, Salary, rank() OVER (PARTITION BY Department ORDER BY Salary DESC) AS Salary_rank
FROM employee1;

-- COMMAND ----------

-- Question 3: For each department, find the employee with the highest salary.

SELECT Department, Name, Salary AS max_salary
FROM (SELECT Name, Department, Salary, rank() OVER (PARTITION BY Department ORDER BY Salary DESC) AS Salary_rank
      FROM employee1) ranked_employee
WHERE ranked_employee.Salary_rank = 1

-- COMMAND ----------

-- Question 4: Calculate the cumulative salary for each employee within their department, ordered by their salary in descending order.

SELECT Department, Name, Salary, SUM(Salary) OVER (PARTITION BY Department ORDER BY Salary DESC) AS Cumulative_Salary
FROM Employee1;

-- COMMAND ----------

-- Question 5: Find the average salary for each department and list the employees who earn above their department's average salary.

SELECT Department, dupli.avg_dept_salary AS avg_depart_salary, Name, Salary
FROM (
      SELECT Salary, Department, Name, avg(Salary) OVER (PARTITION BY Department) AS avg_dept_salary
      FROM Employee1) AS dupli
WHERE Salary > dupli.avg_dept_salary

-- COMMAND ----------

-- Question 6: For each department, determine the difference between each employee's salary and the highest salary in that department.

SELECT Department, Name, temp.max_dept_salary - Temp.Salary AS Salary_Difference
FROM (
      SELECT Department, Name, Salary, max(Salary) OVER ( PARTITION BY Department) as max_dept_salary
       FROM Employee1) AS Temp

-- COMMAND ----------

-- Question 7: List the number of employees hired each year, ordered by year.

SELECT year(JoiningDate) As Year, count(*) AS no_employees
 FROM Employee1
GROUP BY year(JoiningDate)
ORDER BY Year;

-- COMMAND ----------

-- Question 8: Find the top two highest-paid employees from each department.

SELECT temp.Department, temp.Name, temp.rank, temp.Salary
FROM ( SELECT Salary, Department, Name, dense_rank() OVER (PARTITION BY Department ORDER BY Salary) AS rank
       FROM Employee1) temp
WHERE rank < 3;

-- COMMAND ----------

-- Question 9: Calculate the running average salary for each department, ordered by salary in descending order.

SELECT Department, AVG(Salary) AS average_salary
FROM Employee1
GROUP BY Department
ORDER BY average_salary DESC;

-- COMMAND ----------

-- Question 10: Find each employee's tenure in years (as of today) and rank employees by tenure within each department.

SELECT Name, Department, JoiningDate, datediff(year,JoiningDate,Curdate()) AS tenure, rank() OVER (PARTITION BY Department ORDER BY datediff(year,JoiningDate,Curdate()) DESC) AS tenure_rank
 FROM employee1
 ORDER BY Department, tenure DESC;

-- COMMAND ----------


