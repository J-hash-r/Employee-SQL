-- getting rid of preexisting tables
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles;

-- making sql locations for csvs and loading them in
CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "primarykey_departments" PRIMARY KEY ("dept_no")
);
--checking if data loaded OK
select * from departments;

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,--on original csv, Employee number will be used for joining/primary keys
    "dept_no" VARCHAR   NOT NULL--on original csv
)
;
--checking if data loaded OK
select * from dept_emp;

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,--on original csv
	"emp_no" INT   NOT NULL--on original csv, Employee number will be used for joining/primary keys
)
;
--checking if data loaded OK
select * from dept_manager;
--COPY PASTE FIRST TWO ROWS FROM CSV SO I CAN SEE WHAT I"M WORKING WITH
--emp_no	emp_title_id	birth_date	first_name	last_name	sex	hire_date
--473302	s0001	7/25/1953	Hideyuki	Zallocco	M	4/28/1990
--int      varchar  date  varchar  varchar  varchar  date
Create table "employees" (
	"emp_no" INT   NOT NULL,
	"emp_title_id" varchar(10)  NOT NULL,
	"birth_date" date   NOT NULL,
	"first_name" varchar (50)  NOT NULL,
	"last_name" varchar (50) NOT NULL,
	"sex" varchar (2) NOT NULL,
	"hire_date" date  NOT NULL,
	CONSTRAINT "Primarykey_employees" PRIMARY KEY("emp_no")
	);
--checking if data loaded OK
select * from employees;

-- title_id	title
-- s0001	Staff
Create table "titles" (
	"emp_title_id" varchar(10)  NOT NULL, --changing heading to emp_title_id to match it to employees table
	"title" varchar(40)  NOT NULL);
select * from titles;

-- emp_no	salary
-- 10001	60117
Create table "salaries" (
	"emp_no" INT   NOT NULL, 
	"salary" INT   NOT NULL);
select * from salaries;
--All tables imported succesfully!!!

-- 1.List the following details of each employee: employee number, last name, first name, sex, and salary.
-- employees table has: employee number, last name, first name, sex,
--salaries table has: employee number, &  salary
--make an inner join on employee number, 

SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
JOIN salaries
ON employees.emp_no = salaries.emp_no;

-- 2.List first name, last name, and hire date for employees who were hired in 1986
-- Employees table : First name, last name, hire date, 
-- select first name, last name, hire date where hire date is 1986, 1986/1/1 - 1986/12/31
select * from employees

SELECT first_name, last_name, hire_date 
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31'


-- 3.List the manager of each department with the following information: department number,.\
-- department name, the manager's employee number, last name, first name.
select * from titles
--manager id from titles = m0001
-- find emp number,last name, first name, from employees table where emp_title_id ==m0001
--find department number from dept_emp where emp number reoccurs
-- find dept name from dept no in departments

SELECT departments.dept_no, departments.dept_name, dept_manager.emp_no,employees.emp_title_id, employees.last_name, employees.first_name
FROM departments
JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no
JOIN employees
ON dept_manager.emp_no = employees.emp_no;

-- 4.List the department of each employee with the following information:.\
-- employee number, last name, first name, and department name.

--employee number, last name, first name from employees
-- employee number join on dept_emp
-- join dept_no on departments

SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no;

-- 5.List first name, last name, and sex 
-- for employees whose first name is "Hercules" and last names begin with "B."
--will need like operator for B, conditions of = first name declared as "hercules" and like b
-- show employees * first name, laste name where...
-- filter employees on hercules and B show sex
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

--6.List all employees in the Sales department, 
-- including their employee number, last name, first name, and department name.

-- selecting emp number, last name first name department name, 
-- joining on employess in dpeartment
-- second join on departments with conditional "sales"
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';

-- 7.List all employees in the Sales and Development departments, 
-- including their employee number, last name, first name, and department name.
--  As above, step 6 but with 2 dpartments

SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales' or departments.dept_name = 'Development';

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
-- selecting last name from employeses count last name as frequeency, group by last name and re order on the descending count
SELECT last_name,
COUNT(last_name) AS "frequency"
FROM employees
GROUP BY last_name
ORDER BY
COUNT(last_name) DESC;

