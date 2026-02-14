CREATE DATABASE Academy

USE Academy;

CREATE TABLE Groups (
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(10) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
    Rating INT NOT NULL CHECK (Rating >= 0 AND Rating <= 5),
    Year INT NOT NULL CHECK (Year >= 1 AND Year <= 5)
);

INSERT INTO Groups (Name, Rating, Year)
VALUES 
('G1',1,1),
('G2',2,2),
('G3',3,3),
('G4',4,4);

SELECT * FROM Groups;

CREATE TABLE Departments
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Financing MONEY NOT NULL
        CONSTRAINT DF_Departments_Financing DEFAULT 0
        CHECK (Financing >=0),
    Name NVARCHAR(100) NOT NULL
        UNIQUE
        CHECK (LEN(Name) > 0)
);

INSERT INTO Departments (Name, Financing)
VALUES
('Computer Science', 120000),
('Mathematics', 80000),
('Physics', 95000),
('Chemistry', 60000),
('Medicine', 70000),
('Business', 30000),
('Philosophy', 20000),
('Economics', 110000),
('Law', 90000),
('Engineering', 150000),
('Art', 20000);

SELECT * FROM Departments;

CREATE TABLE Faculties
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
);

INSERT INTO Faculties (Name)
VALUES
('Computer Science'),
('Mathematics'),
('Physics'),
('Chemistry'),
('Biology'),
('Law'),
('Economics'),
('History'),
('Philosophy'),
('Engineering');

SELECT * FROM Faculties;

CREATE TABLE Teachers
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    EmploymentDate DATE NOT NULL
        CHECK (EmploymentDate >= '1990-01-01'),
    Name NVARCHAR(MAX) NOT NULL
        CHECK (LEN(Name) > 0),
    Premium MONEY NOT NULL
        CONSTRAINT DF_Teachers_Premium DEFAULT 0
        CHECK (Premium >= 0),
    Salary MONEY NOT NULL
        CHECK (Salary > 0),
    Surname NVARCHAR(MAX) NOT NULL
        CHECK (LEN(Surname) > 0)
);

INSERT INTO Teachers (EmploymentDate, Name, Premium, Salary, Surname)
VALUES
('2015-08-15', 'John', 800, 12500, 'Smith'),
('2017-03-20', 'Emma', 450, 14200, 'Johnson'),
('2012-11-05', 'Michael', 1200, 16800, 'Williams'),
('2019-09-10', 'Sophia', 300, 13500, 'Brown'),
('2014-04-22', 'William', 0, 15200, 'Jones'),
('2020-01-13', 'Olivia', 600, 11800, 'Garcia'),
('2011-07-18', 'James', 950, 17500, 'Miller'),
('2018-10-30', 'Isabella', 200, 12800, 'Davis'),
('2016-05-09', 'Robert', 700, 14500, 'Rodriguez'),
('2013-12-01', 'Mia', 1500, 18200, 'Martinez'),
('2021-02-25', 'David', 100, 9500, 'Anderson'),
('2022-06-14', 'Emily', 0, 8700, 'Taylor');

SELECT * FROM Teachers;

--до домашнього завдання за 06.02

--Вивести таблицю кафедр, але розташувати її поля у зворотному порядку

SELECT Financing, Name, Id
FROM Departments;

-- Вивести назви груп та їх рейтинги з псевдонімами

SELECT Name AS [Group Name],
       Rating AS [Group Rating]
FROM Groups;

--Прізвище, відсоток ставки до надбавки та до загальної зарплати

SELECT Surname,
       CASE 
           WHEN Premium = 0 THEN NULL
           ELSE (Salary * 100.0 / Premium) 
       END AS [Salary% of Premium],
       (Salary * 100.0 / (Salary + Premium)) AS [Salary% of Total]
FROM Teachers;

--Назви кафедр з фінансуванням < 11000 або > 25000

SELECT Name
FROM Departments
WHERE Financing < 11000
   OR Financing > 25000;

--Назви факультетів, окрім «Computer Science»

SELECT Name
FROM Faculties
WHERE Name <> 'Computer Science';

--Викладачі, прийняті до 2000 року

SELECT Surname, EmploymentDate
FROM Teachers
WHERE EmploymentDate < '2000-01-01';

--Назви кафедр перед «Software Development»

SELECT Name AS [Name of Department]
FROM Departments
WHERE Name < 'Software Development'
ORDER BY Name;

--Групи 5-го курсу з рейтингом 2–4

SELECT Name
FROM Groups
WHERE Year = 5
  AND Rating BETWEEN 2 AND 4;

--Всі викладачі з зарплатою (Salary) більше 10000

SELECT Surname, Name, Salary
FROM Teachers
WHERE Salary > 10000;

--Кафедри з мінімальним та максимальним фінансуванням

SELECT MIN(Financing) AS MinFinancing, 
       MAX(Financing) AS MaxFinancing
FROM Departments;