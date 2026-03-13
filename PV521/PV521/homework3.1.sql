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
DROP TABLE IF EXISTS Students;

CREATE TABLE Faculties
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
);

CREATE TABLE Departments
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Financing MONEY NOT NULL DEFAULT 0 CHECK (Financing >= 0),
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
    FacultyId INT FOREIGN KEY REFERENCES Faculties(Id)
);

CREATE TABLE Groups
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(10) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
    Rating INT NOT NULL CHECK (Rating >= 0 AND Rating <= 5),
    Year INT NOT NULL CHECK (Year >= 1 AND Year <= 5),
    DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)
);

CREATE TABLE Teachers
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    EmploymentDate DATE NOT NULL CHECK (EmploymentDate >= '1990-01-01'),
    Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
    Premium MONEY NOT NULL DEFAULT 0 CHECK (Premium >= 0),
    Salary MONEY NOT NULL CHECK (Salary > 0),
    Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0)
);

CREATE TABLE Curators 
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
    Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0)
);

CREATE TABLE Subjects 
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
);

CREATE TABLE Lectures 
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    LectureRoom NVARCHAR(MAX) NOT NULL CHECK (LEN(LectureRoom) > 0),
    SubjectId INT NOT NULL FOREIGN KEY REFERENCES Subjects(Id),
    TeacherId INT NOT NULL FOREIGN KEY REFERENCES Teachers(Id),
    LectureDate DATE
);

CREATE TABLE GroupsCurators 
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    CuratorId INT NOT NULL FOREIGN KEY REFERENCES Curators(Id),
    GroupId INT NOT NULL FOREIGN KEY REFERENCES Groups(Id)
);

CREATE TABLE GroupsLectures 
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    GroupId INT NOT NULL FOREIGN KEY REFERENCES Groups(Id),
    LectureId INT NOT NULL FOREIGN KEY REFERENCES Lectures(Id)
);

CREATE TABLE Students (
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
    Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0),
    GroupId INT FOREIGN KEY REFERENCES Groups(Id)
);

INSERT INTO Faculties (Name) VALUES
('Computer Science'), ('Mathematics'), ('Physics'), ('Chemistry'),
('Biology'), ('Law'), ('Economics'), ('History'), ('Philosophy'), ('Engineering');

INSERT INTO Departments (Name, Financing, FacultyId) VALUES
('Computer Science', 120000, 1),
('Mathematics', 80000, 2),
('Physics', 95000, 3),
('Chemistry', 60000, 4),
('Medicine', 70000, 5),
('Business', 30000, 6),
('Philosophy', 20000, 7),
('Economics', 110000, 8),
('Law', 90000, 9),
('Engineering', 150000, 10),
('Art', 20000, NULL);

INSERT INTO Groups (Name, Rating, Year, DepartmentId) VALUES 
('G1', 1, 1, 1),
('G2', 2, 2, 2),
('G3', 3, 3, 3),
('G4', 4, 4, 4);

INSERT INTO Teachers (EmploymentDate, Name, Premium, Salary, Surname) VALUES
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

INSERT INTO Curators (Name, Surname) VALUES
('Anna', 'Petrova'), ('Ivan', 'Ivanov'), ('Maria', 'Shevchenko'), ('Oleg', 'Kovalchuk');

INSERT INTO Subjects (Name) VALUES
('Mathematics'), ('Physics'), ('Programming'), ('Database Theory'), ('Algorithms');

INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId, LectureDate) VALUES
('B103', 1, 1, '2024-03-18'),
('A101', 2, 2, '2024-03-19'),
('B103', 3, 3, '2024-03-20'),
('C201', 4, 4, '2024-03-21'),
('B103', 5, 5, '2024-03-22');

INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES
(1, 1), (1, 2), (2, 3), (3, 4);

INSERT INTO GroupsLectures (GroupId, LectureId) VALUES
(1, 1), (2, 2), (3, 3), (4, 4);

INSERT INTO Students (Name, Surname, GroupId) VALUES
('John', 'Doe', 1),
('Jane', 'Smith', 1),
('Bob', 'Johnson', 2),
('Alice', 'Brown', 2),
('Charlie', 'Wilson', 3);


SELECT 'FACULTIES' AS TableName, * FROM Faculties;
SELECT 'DEPARTMENTS' AS TableName, * FROM Departments;
SELECT 'GROUPS' AS TableName, * FROM Groups;
SELECT 'STUDENTS' AS TableName, * FROM Students;
SELECT 'LECTURES' AS TableName, * FROM Lectures;

-- 1. Вивести прізвища кураторів груп та назви груп, які вони курують
SELECT c.Surname AS CuratorSurname, g.Name AS GroupName
FROM Curators c
JOIN GroupsCurators gc ON gc.CuratorId = c.Id
JOIN Groups g ON g.Id = gc.GroupId;

-- 2. Вивести прізвища викладачів, які читають лекції у групі «G1»
SELECT DISTINCT t.Surname
FROM Teachers t
JOIN Lectures l ON l.TeacherId = t.Id
JOIN GroupsLectures gl ON gl.LectureId = l.Id
JOIN Groups g ON g.Id = gl.GroupId
WHERE g.Name = 'G1';

-- 3. Вивести назви кафедр та назви груп, які до них відносяться
SELECT d.Name AS DepartmentName, g.Name AS GroupName
FROM Departments d
LEFT JOIN Groups g ON g.DepartmentId = d.Id;

-- 4. Вивести назви предметів, які викладає викладач «John Smith»
SELECT s.Name AS SubjectName
FROM Subjects s
JOIN Lectures l ON l.SubjectId = s.Id
JOIN Teachers t ON t.Id = l.TeacherId
WHERE t.Name = 'John' AND t.Surname = 'Smith';

-- 5. Вивести прізвища викладачів та лекції, які вони читають (назви дисциплін та груп), в аудиторії «B103»
SELECT t.Surname AS TeacherSurname, s.Name AS SubjectName, g.Name AS GroupName
FROM Teachers t
JOIN Lectures l ON l.TeacherId = t.Id
JOIN Subjects s ON s.Id = l.SubjectId
JOIN GroupsLectures gl ON gl.LectureId = l.Id
JOIN Groups g ON g.Id = gl.GroupId
WHERE l.LectureRoom = 'B103';

-- HW 11.02

-- 1. Вивести кількість викладачів кафедри «Software Development»
SELECT COUNT(DISTINCT t.Id) AS TeachersCount
FROM Teachers t
JOIN Lectures l ON l.TeacherId = t.Id
JOIN GroupsLectures gl ON gl.LectureId = l.Id
JOIN Groups g ON g.Id = gl.GroupId
JOIN Departments d ON d.Id = g.DepartmentId
WHERE d.Name = 'Software Development';

-- 2. Вивести кількість лекцій, які читає викладач «Dave McQueen»
SELECT COUNT(*) AS LecturesCount
FROM Lectures l
JOIN Teachers t ON t.Id = l.TeacherId
WHERE t.Name = 'Dave' AND t.Surname = 'McQueen';

-- 3. Вивести кількість занять, які проводяться в аудиторії «D201»
SELECT COUNT(*) AS ClassesCount
FROM Lectures
WHERE LectureRoom = 'D201';

-- 4. Вивести назви аудиторій та кількість лекцій, що проводяться в них
SELECT LectureRoom, COUNT(*) AS LecturesCount
FROM Lectures
GROUP BY LectureRoom;

-- 5. Вивести кількість студентів, які відвідують лекції викладача «Dave McQueen»
SELECT COUNT(DISTINCT s.Id) AS StudentsCount
FROM Students s
JOIN Groups g ON g.Id = s.GroupId
JOIN GroupsLectures gl ON gl.GroupId = g.Id
JOIN Lectures l ON l.Id = gl.LectureId
JOIN Teachers t ON t.Id = l.TeacherId
WHERE t.Name = 'Dave' AND t.Surname = 'McQueen';

-- 6. Вивести середню ставку викладачів факультету «Computer Science»
SELECT AVG(t.Salary + t.Premium) AS AverageRate
FROM Teachers t
JOIN Lectures l ON l.TeacherId = t.Id
JOIN GroupsLectures gl ON gl.LectureId = l.Id
JOIN Groups g ON g.Id = gl.GroupId
JOIN Departments d ON d.Id = g.DepartmentId
JOIN Faculties f ON f.Id = d.FacultyId
WHERE f.Name = 'Computer Science';

-- 7. Вивести мінімальну та максимальну кількість студентів серед усіх груп
SELECT 
    MIN(StudentCount) AS MinStudents, 
    MAX(StudentCount) AS MaxStudents
FROM (
    SELECT COUNT(s.Id) AS StudentCount
    FROM Groups g
    LEFT JOIN Students s ON s.GroupId = g.Id
    GROUP BY g.Id
) AS GroupStudentCounts;

-- 8. Вивести середній фонд фінансування кафедр
SELECT AVG(Financing) AS AverageFinancing
FROM Departments;

-- 9. Вивести повні імена викладачів та кількість читаних ними дисциплін
SELECT 
    t.Name + ' ' + t.Surname AS FullName, 
    COUNT(DISTINCT l.SubjectId) AS SubjectsCount
FROM Teachers t
LEFT JOIN Lectures l ON l.TeacherId = t.Id
GROUP BY t.Id, t.Name, t.Surname;

-- 10. Вивести кількість лекцій щодня протягом тижня
SELECT 
    DATEPART(weekday, LectureDate) AS DayOfWeek,
    COUNT(*) AS LecturesCount
FROM Lectures
GROUP BY DATEPART(weekday, LectureDate)
ORDER BY DayOfWeek;

-- 11. Вивести номери аудиторій та кількість кафедр, чиї лекції в них читаються
SELECT 
    l.LectureRoom, 
    COUNT(DISTINCT g.DepartmentId) AS DepartmentsCount
FROM Lectures l
JOIN GroupsLectures gl ON gl.LectureId = l.Id
JOIN Groups g ON g.Id = gl.GroupId
WHERE g.DepartmentId IS NOT NULL
GROUP BY l.LectureRoom;

-- 12. Вивести назви факультетів та кількість дисциплін, які на них читаються
SELECT 
    f.Name AS FacultyName, 
    COUNT(DISTINCT l.SubjectId) AS SubjectsCount
FROM Faculties f
JOIN Departments d ON d.FacultyId = f.Id
JOIN Groups g ON g.DepartmentId = d.Id
JOIN GroupsLectures gl ON gl.GroupId = g.Id
JOIN Lectures l ON l.Id = gl.LectureId
GROUP BY f.Id, f.Name;

-- 13. Вивести кількість лекцій для кожної пари викладач-аудиторія
SELECT 
    t.Surname + ' ' + t.Name AS TeacherName, 
    l.LectureRoom, 
    COUNT(*) AS LecturesCount
FROM Lectures l
JOIN Teachers t ON t.Id = l.TeacherId
GROUP BY t.Id, t.Surname, t.Name, l.LectureRoom
ORDER BY t.Surname, t.Name, l.LectureRoom;
