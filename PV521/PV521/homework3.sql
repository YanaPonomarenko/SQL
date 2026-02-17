USE Academy;

DROP TABLE IF EXISTS GroupsLectures;
DROP TABLE IF EXISTS GroupsCurators;
DROP TABLE IF EXISTS Lectures;
DROP TABLE IF EXISTS Subjects;
DROP TABLE IF EXISTS Curators;
DROP TABLE IF EXISTS Groups;
DROP TABLE IF EXISTS Teachers;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Faculties;

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

---
CREATE TABLE Curators (
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
    Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0)
);

INSERT INTO Curators (Name, Surname) VALUES
('Anna', 'Petrova'),
('Ivan', 'Ivanov'),
('Maria', 'Shevchenko'),
('Oleg', 'Kovalchuk');

CREATE TABLE Subjects (
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
);

INSERT INTO Subjects (Name) VALUES
('Mathematics'),
('Physics'),
('Programming'),
('Database Theory'),
('Algorithms');


CREATE TABLE Lectures (
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    LectureRoom NVARCHAR(MAX) NOT NULL CHECK (LEN(LectureRoom) > 0),
    SubjectId INT NOT NULL FOREIGN KEY REFERENCES Subjects(Id),
    TeacherId INT NOT NULL FOREIGN KEY REFERENCES Teachers(Id)
);


INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId) 
VALUES
('B103', 1, 1), 
('A101', 2, 2), 
('B103', 3, 3), 
('C201', 4, 4), 
('B103', 5, 5);


CREATE TABLE GroupsCurators (
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    CuratorId INT NOT NULL FOREIGN KEY REFERENCES Curators(Id),
    GroupId INT NOT NULL FOREIGN KEY REFERENCES Groups(Id)
);


INSERT INTO GroupsCurators (CuratorId, GroupId) 
VALUES
(1, 1), (1, 2), (2, 3), (3, 4);


CREATE TABLE GroupsLectures (
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    GroupId INT NOT NULL FOREIGN KEY REFERENCES Groups(Id),
    LectureId INT NOT NULL FOREIGN KEY REFERENCES Lectures(Id)
);


INSERT INTO GroupsLectures (GroupId, LectureId) 
VALUES
(1, 1), (2, 2), (3, 3), (4, 4);


--Вивести прізвища кураторів груп та назви груп, які вони курують
SELECT c.Surname AS CuratorSurname, g.Name AS GroupName
FROM Curators c
JOIN GroupsCurators gc ON gc.CuratorId = c.Id
JOIN Groups g ON g.Id = gc.GroupId;


--Вивести прізвища викладачів, які читають лекції у групі «G1»
SELECT DISTINCT t.Surname
FROM Teachers t
JOIN Lectures l ON l.TeacherId = t.Id
JOIN GroupsLectures gl ON gl.LectureId = l.Id
JOIN Groups g ON g.Id = gl.GroupId
WHERE g.Name = 'G1';


--Вивести назви кафедр та назви груп, які до них відносяться
ALTER TABLE Groups ADD DepartmentId INT FOREIGN KEY REFERENCES Departments(Id);
UPDATE Groups SET DepartmentId = 1 WHERE Name IN ('G1');
UPDATE Groups SET DepartmentId = 2 WHERE Name = 'G2';
UPDATE Groups SET DepartmentId = 3 WHERE Name = 'G3';
UPDATE Groups SET DepartmentId = 4 WHERE Name = 'G4';

SELECT d.Name AS DepartmentName, g.Name AS GroupName
FROM Departments d
LEFT JOIN Groups g ON g.DepartmentId = d.Id;


--Вивести назви предметів, які викладає викладач «John Smith»
SELECT s.Name AS SubjectName
FROM Subjects s
JOIN Lectures l ON l.SubjectId = s.Id
JOIN Teachers t ON t.Id = l.TeacherId
WHERE t.Name = 'John' AND t.Surname = 'Smith';


--Вивести прізвища викладачів та лекції, які вони читають (назви дисциплін та груп), в аудиторії «B103»
SELECT t.Surname AS TeacherSurname, s.Name AS SubjectName, g.Name AS GroupName
FROM Teachers t
JOIN Lectures l ON l.TeacherId = t.Id
JOIN Subjects s ON s.Id = l.SubjectId
JOIN GroupsLectures gl ON gl.LectureId = l.Id
JOIN Groups g ON g.Id = gl.GroupId
WHERE l.LectureRoom = 'B103';