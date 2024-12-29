SELECT * 
FROM employee_salary 
WHERE salary <= 50000
;


SELECT * 
FROM employee_demographics 
WHERE birth_date > '1985-01-01' 
AND gender = 'male'
LIMIT 0, 1000;


SELECT * 
FROM employee_demographics 
WHERE (first_name = 'Leslie' AND age = 44) OR age > 55
;

-- AND OR NOT

-- like statement
-- % (anything like) and _

SELECT * 
FROM employee_demographics 
WHERE first_name LIKE 'Jer%'
;

SELECT * 
FROM employee_demographics 
WHERE first_name LIKE 'a%'
;
SELECT * 
FROM employee_demographics 
WHERE first_name LIKE 'a____%'
;

SELECT * 
FROM employee_demographics 
WHERE birth_date LIKE '1989%'
;

-- Groupby orderby


SELECT gender, AVG(age)
FROM employee_demographics 
GROUP BY gender 
;

SELECT occupation, salary
FROM employee_salary 
GROUP BY occupation, salary
;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics 
GROUP BY gender 
;

-- ORDER BY (sort by acending or decending order)--

SELECT *
FROM employee_demographics
ORDER BY first_name ASC;

SELECT *
FROM employee_demographics
ORDER BY age, gender ASC;

-- you can used position of the field

SELECT *
FROM employee_demographics
ORDER BY 5,4;

SELECT*
FROM employee_demographics
ORDER BY age DESC 
LIMIT 7, 1
;



-- ALIASING (HELP YOU REFER TO AN ITEM)
SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;

-- Joins allows u to join tables that are similar
SELECT *
FROM employee_demographics;


SELECT *
FROM employee_salary;


SELECT *
FROM employee_demographics
INNER JOIN employee_salary	
	on employee_demographics.employee_id = employee_salary.employee_id;
    


SELECT dem.employee_id,age, occupation
FROM employee_demographics AS dem
INNER JOIN employee_salary	AS sal
	on dem.employee_id = sal.employee_id;
    
-- outter joins
SELECT *
FROM employee_demographics
RIGHT JOIN employee_salary	
	on employee_demographics.employee_id = employee_salary.employee_id;    
    
    -- SELF JOIN
SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.first_name AS first_name_emp,
emp2.last_name AS last_name_emp
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id + 1 = emp2.employee_id
    ;
    
    
 -- joining multiple table
 
 
SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary	AS sal
	ON dem.employee_id = sal.employee_id
INNER JOIN Parks_departments pd
    ON sal.dept_id = pd.department_id
    ;
    
    
    -- unions (help join data in the same table
    
SELECT first_name, last_name
FROM employee_demographics 
UNION ALL
SELECT first_name, last_name
FROM employee_salary;


SELECT first_name, last_name, 'OLD' AS label
FROM employee_demographics 
WHERE age > 40 AND gender = 'male'
UNION 
SELECT first_name, last_name, 'OLD lady' AS label
FROM employee_demographics
WHERE age > 40 AND gender = 'Feamle'
UNION
SELECT first_name, last_name, 'Highly paid employee' AS label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name;
    
    
    
    -- string function

SELECT LENGTH ('skyfall');
SELECT  first_name, LENGTH (first_name)
FROM employee_demographics
ORDER BY   2;


SELECT  UPPER (first_name), UPPER(last_name)
FROM employee_demographics;


-- trim
SELECT  TRIM('.         SKY.   ');

-- window function allows u to group by but don't roll everything into one group. 
-- Allows you to loook ar a partition into group an keep there unique roles in the ouput


SELECT gender, AVG (salary) AS avg_salary 
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender;



SELECT gender, AVG (salary) OVER()
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;

-- window functions #end of intermediate
-- shows avg of all group
SELECT gender, AVG (salary) OVER(PARTITION BY gender) AS salary_avg
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;

-- roling total starts at a particular value and follow thru. this adds up salary to grand total
SELECT dem.first_name, dem.last_name, gender, salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_Total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;


SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER ()
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;



SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;

    

SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    


SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
 
    
-- ADVANCE SQL
-- CTE common table expressions that you can express in the main query

WITH CTE_Example AS
	(
SELECT gender, AVG(salary) avg_sal, MAX(salary) Max_sal, MIN(salary) Min_sal, COUNT(salary)Count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal)
FROM CTE_Example
;


SELECT AVG (avg_sal)
FROM (SELECT gender, AVG(salary) avg_sal, MAX(salary) Max_sal, MIN(salary) Min_sal, COUNT(salary)Count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
example_subquery
;
-- won't go thru
SELECT AVG(avg_sal)
FROM CTE_Example
;

WE_Example.employee_id = CTE_Example2.employee_id
    ;

WITH CTE_Example AS (
    SELECT employee_id, gender, birth_date 
    FROM employee_demographics  
    WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS (
    SELECT employee_id, salary 
    FROM employee_salary 
    WHERE salary > 50000
)
SELECT * 
FROM CTE_Example 
JOIN CTE_Example2 
ON CTE_Example.employee_id = CTE_Example2.employee_id;


-- Temporary  table- to manipulate data
CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);

SELECT * 
FROM temp_table;

INSERT INTO temp_table
VALUES('Amara', 'Obi','Home Alone');

SELECT * 
FROM temp_table;

CREATE TEMPORARY TABLE salary_over_50k
SELECT*
FROM employee_salary
WHERE salary > 50000;

SELECT * 
FROM salary_over_50k;


-- Create temp_table first
CREATE TEMPORARY TABLE temp_table (
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    movie_name VARCHAR(100)
);

-- Insert values into temp_table
INSERT INTO temp_table
VALUES ('Amara', 'Obi', 'Home Alone');

-- Select from temp_table
SELECT * 
FROM temp_table;

-- Create salary_over_50k temporary table
CREATE TEMPORARY TABLE salary_over_50k AS
SELECT *
FROM employee_salary
WHERE salary > 50000;

-- Select from salary_over_50k
SELECT * 
FROM salary_over_50k;


-- stored procedure are ways to store your sql so you can use them over again
CALL large_salaries;

CREATE PROCEDURE large_salaries()
SELECT * 
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries();

DELIMITER $$

CREATE PROCEDURE large_salaries3()
BEGIN	
    -- First result set
    SELECT * 
    FROM employee_salary
    WHERE salary >= 50000;

    -- Second result set
    SELECT * 
    FROM employee_salary
    WHERE salary >= 10000;
END$$

DELIMITER ;


CALL large_salaries3()



-- parameters, are variables passed as an input into a store procedure, allows stores to accept an input value in place into your code.

DELIMITER $$

CREATE PROCEDURE large_salaries4(employee_uno INT)
BEGIN	
    -- First result set
    SELECT * 
    FROM employee_salary
    WHERE employee_id  = employee_uno
   ;
END$$

DELIMITER ;
CALL large_salaries4(1);

-- Tiggers and events- block of codes that excute automatically on a specific tables

SELECT * 
FROM employee_salary;

SELECT * 
FROM employee_demographics;

DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics(employee_id, first_name, last_name)
    VALUES(NEW.employee_id, NEW.first_name, NEW.last_name);
END$$
DELIMITER ;
INSERT INTO employee_salary(employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(13,'AMARA','obi','athlete','300000',14);

-- events - schedule events like importing data, on a schedule, good for automation

SELECT * 
FROM employee_demographics;


DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	DELETE
    FROM employee_demographics
    WHERE age >= 60;
END $$
DELIMITER ;


SHOW VARIABLES LIKE 'events%';





















































    
    