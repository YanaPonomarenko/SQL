USE Academy;


INSERT INTO Departments (Name, Financing, FacultyId) 
VALUES ('Software Development', 150000, 1);


INSERT INTO Groups (Name, Rating, Year, DepartmentId) 
VALUES ('D221', 4, 2, 1);


INSERT INTO Groups (Name, Rating, Year, DepartmentId) 
VALUES 
('G5', 5, 5, 1),
('G6', 4, 5, 2);


INSERT INTO Teachers (EmploymentDate, Name, Premium, Salary, Surname) 
VALUES ('2020-01-15', 'Dave', 1000, 15000, 'McQueen');


INSERT INTO Teachers (EmploymentDate, Name, Premium, Salary, Surname) 
VALUES ('2019-03-10', 'Jack', 800, 14000, 'Underhill');


INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId, LectureDate) 
VALUES 
('D201', 1, 13, '2024-03-25'),
('D201', 2, 13, '2024-03-26'),
('D201', 3, 14, '2024-03-27');


INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId, LectureDate) 
VALUES 
('A101', 1, 13, '2024-03-28'),
('B103', 2, 13, '2024-03-29');


INSERT INTO Students (Name, Surname, GroupId) 
VALUES 
('Mike', 'Johnson', 5),
('Sarah', 'Williams', 5),
('Tom', 'Brown', 5),
('Kate', 'Miller', 6);


INSERT INTO GroupsLectures (GroupId, LectureId) 
VALUES 
(1, 6), (1, 7), (2, 8), (3, 9), (3, 10);


INSERT INTO GroupsCurators (CuratorId, GroupId) 
VALUES 
(4, 1), 
(2, 5); 


INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId, LectureDate) 
VALUES 
('B103', 1, 1, '2024-04-01'),
('B103', 1, 2, '2024-04-02'),
('A101', 2, 3, '2024-04-03'),
('C201', 3, 4, '2024-04-04');


INSERT INTO GroupsLectures (GroupId, LectureId) 
VALUES 
(1, 11), (2, 12), (3, 13), (4, 14);


SELECT '1. Departments' AS TableName, * FROM Departments;
SELECT '2. Groups' AS TableName, * FROM Groups;
SELECT '3. Teachers' AS TableName, * FROM Teachers;
SELECT '4. Lectures' AS TableName, * FROM Lectures;
SELECT '5. Students' AS TableName, * FROM Students;
SELECT '6. GroupsCurators' AS TableName, * FROM GroupsCurators;
SELECT '7. GroupsLectures' AS TableName, * FROM GroupsLectures;

--
-- 1. Вивести номери корпусів, якщо сумарний фонд фінансування розташованих у них кафедр перевищує 100000.
SELECT DISTINCT LEFT(d.Name, 1) AS Building
FROM Departments d
GROUP BY LEFT(d.Name, 1)
HAVING SUM(d.Financing) > 100000;


-- 3. Вивести назви груп, які мають рейтинг більший, ніж рейтинг групи «D221».
SELECT g.Name AS GroupName, g.Rating
FROM Groups g
WHERE g.Rating > (SELECT Rating FROM Groups WHERE Name = 'D221');

-- 4. Вивести прізвища та імена викладачів, ставка яких вища за середню ставку всіх викладачів.
SELECT t.Surname, t.Name, (t.Salary + t.Premium) AS TotalRate
FROM Teachers t
WHERE (t.Salary + t.Premium) > (SELECT AVG(Salary + Premium) FROM Teachers);

-- 5. Вивести назви груп, які мають більше одного куратора.
SELECT g.Name AS GroupName, 
       (SELECT COUNT(*) FROM GroupsCurators gc WHERE gc.GroupId = g.Id) AS CuratorsCount
FROM Groups g
WHERE (
    SELECT COUNT(*) 
    FROM GroupsCurators gc 
    WHERE gc.GroupId = g.Id
) > 1;

-- 6. Вивести назви груп, які мають рейтинг менший, ніж мінімальний рейтинг груп 5-го курсу.
SELECT g.Name AS GroupName, g.Rating
FROM Groups g
WHERE g.Rating < (
    SELECT MIN(Rating) 
    FROM Groups 
    WHERE Year = 5
);


-- 8. Вивести назви дисциплін та повні імена викладачів, які читають найбільшу кількість лекцій з них.
SELECT s.Name AS SubjectName, t.Name + ' ' + t.Surname AS TeacherName, COUNT(l.Id) AS LecturesCount
FROM Subjects s
JOIN Lectures l ON l.SubjectId = s.Id
JOIN Teachers t ON t.Id = l.TeacherId
GROUP BY s.Id, s.Name, t.Id, t.Name, t.Surname
HAVING COUNT(l.Id) = (
    SELECT MAX(LectureCount)
    FROM (
        SELECT COUNT(*) AS LectureCount
        FROM Lectures
        WHERE SubjectId = s.Id
        GROUP BY TeacherId
    ) AS TeacherLectures
)
ORDER BY s.Name;

-- 9. Вивести назву дисципліни, за якою читається найменше лекцій.
SELECT TOP 1 s.Name AS SubjectName, COUNT(l.Id) AS LecturesCount
FROM Subjects s
LEFT JOIN Lectures l ON l.SubjectId = s.Id
GROUP BY s.Id, s.Name
ORDER BY COUNT(l.Id) ASC;


