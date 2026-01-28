--create database
CREATE DATABASE final_project;
USE final_project;

--create table 1
CREATE TABLE students (
    s_id INTEGER PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(100),
    birthdate DATE,
    enrolldate DATE
);

--table 1 records:
INSERT INTO students VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2000-01-15', '2022-08-01'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '1999-05-25', '2021-08-01');

--create table 2
CREATE TABLE courses (
    c_id INTEGER PRIMARY KEY,
    c_name VARCHAR(100) NOT NULL,
    dept_id INTEGER NOT NULL,
    credits INTEGER NOT NULL
);

--table 2 records:
INSERT INTO courses VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 2, 4);

--create table 3
CREATE TABLE instructors (
    i_id INTEGER PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    dept_id INTEGER NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);

--table 3 records:
INSERT INTO instructors VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@univ.com', 1, 80000),
(2, 'Bob', 'Lee', 'bob.lee@univ.com', 2, 75000);

--create table 4
CREATE TABLE enrollments (
    enroll_id INTEGER PRIMARY KEY,
    s_id INTEGER NOT NULL,
    c_id INTEGER NOT NULL,
    enrolldate DATE NOT NULL,
    FOREIGN KEY (s_id) REFERENCES students(s_id),
    FOREIGN KEY (c_id) REFERENCES courses(c_id)
);

--table 4 records:
INSERT INTO enrollments VALUES
(1, 1, 101, '2022-08-01'),
(2, 2, 102, '2021-08-01');

--create table 5
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

--table 5 records:
INSERT INTO departments VALUES
(1, 'Computer Science'),
(2, 'Mathematics');

--queries:
--1
-- INSERT on students table
INSERT INTO students VALUES (3, 'Keifer', 'Watson', 'keifer@email.com', '2001-02-02', '2023-08-01');

-- UPDATE on students table
UPDATE students SET email = 'john123@email.com' WHERE s_id = 1;

-- DELETE on students table
DELETE FROM students WHERE s_id = 3;

------------------

-- INSERT on courses table
INSERT INTO courses VALUES (103, 'Operating Systems', 1, 4);

-- UPDATE on courses table
UPDATE courses SET credits = 5 WHERE c_id = 103;

-- DELETE on courses table
DELETE FROM courses WHERE c_id = 103;

------------------

-- INSERT on instructors table
INSERT INTO instructors VALUES
(3, 'David', 'Miller', 'miller@univ.com', 1, 72000);

-- UPDATE on instructors table
UPDATE instructors SET salary = 78000 WHERE i_id = 3;

-- DELETE on instructors table
DELETE FROM instructors WHERE i_id = 3;

------------------

-- INSERT on enrollments table
INSERT INTO enrollments VALUES (3, 1, 102, '2023-08-01');

-- UPDATE on enrollments table
UPDATE enrollments SET c_id = 101 WHERE enroll_id = 3;

-- DELETE on enrollments table
DELETE FROM enrollments WHERE enroll_id = 3;

------------------

-- INSERT on departments table
INSERT INTO departments VALUES (3, 'Physics');

-- UPDATE on departments table
UPDATE departments SET dept_name = 'Applied Physics' WHERE dept_id = 3;

-- DELETE on departments table
DELETE FROM departments WHERE dept_id = 3;


--2
SELECT * FROM students
WHERE enrolldate > '2022-01-01';

--3
SELECT c.c_name
FROM courses c
JOIN departments d ON c.dept_id = d.dept_id
WHERE d.dept_name = 'Mathematics'
LIMIT 5;

--4
SELECT c_id, COUNT(s_id) AS StudentCount
FROM enrollments
GROUP BY c_id
HAVING COUNT(s_id) > 5;

--5
SELECT s.s_id, s.firstname
FROM students s
JOIN enrollments e1 ON s.s_id = e1.s_id
JOIN enrollments e2 ON s.s_id = e2.s_id
WHERE e1.c_id = 101 AND e2.c_id = 102;

--6
SELECT DISTINCT s.s_id, s.firstname
FROM students s
JOIN enrollments e ON s.s_id = e.s_id
WHERE e.c_id IN (101, 102);

--7
SELECT AVG(credits) AS AverageCredits FROM courses;

--8
SELECT MAX(i.salary) AS MaxSalary
FROM instructors i
JOIN departments d ON i.dept_id = d.dept_id
WHERE d.dept_name = 'Computer Science';

--9
SELECT d.dept_name, COUNT(e.s_id) AS TotalStudents
FROM departments d
JOIN courses c ON d.dept_id = c.dept_id
JOIN enrollments e ON c.c_id = e.c_id
GROUP BY d.dept_name;

--10
SELECT s.firstname, c.c_id
FROM students s
JOIN enrollments e ON s.s_id = e.s_id
JOIN courses c ON e.c_id = c.c_id;

--11
SELECT s.firstname, c.c_name
FROM students s
LEFT JOIN enrollments e ON s.s_id = e.s_id
LEFT JOIN courses c ON e.c_id = c.c_id;

--12
SELECT c_name
FROM courses
WHERE c_id IN (
    SELECT c_id
    FROM enrollments
    GROUP BY c_id
    HAVING COUNT(s_id) > 10
);

--13
SELECT s_id, YEAR(enrolldate) AS EnrollmentYear
FROM enrollments;

--14
SELECT CONCAT(firstname, ' ', lastname) AS InstructorName
FROM instructors;

--15
SELECT c_id,
       COUNT(s_id) OVER (PARTITION BY c_id) AS TotalStudents
FROM enrollments;

--16
SELECT s_id, firstname,
CASE
    WHEN TIMESTAMPDIFF(YEAR, enrolldate, CURDATE()) > 4 THEN 'Senior'
    ELSE 'Junior'
END AS Status
FROM students;

