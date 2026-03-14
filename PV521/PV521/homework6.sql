USE Academy;

-- 1 Вивести назви аудиторій, де читає лекції викладач «Edward Hopper»
SELECT DISTINCT lr.Name AS LectureRoomName
FROM LectureRooms lr
JOIN Schedules s ON lr.Id = s.LectureRoomId
JOIN Lectures l ON s.LectureId = l.Id
JOIN Teachers t ON l.TeacherId = t.Id
WHERE t.Name = 'Edward' AND t.Surname = 'Hopper';


-- 2 Вивести прізвища асистентів, які читають лекції у групі «F505»
SELECT DISTINCT t.Surname
FROM Teachers t
JOIN Assistants a ON t.Id = a.TeacherId
JOIN Lectures l ON t.Id = l.TeacherId
JOIN GroupsLectures gl ON l.Id = gl.LectureId
JOIN Groups g ON gl.GroupId = g.Id
WHERE g.Name = 'F505';


-- 3Вивести дисципліни, які читає викладач «Alex Carmack» для груп 5 курсу
SELECT DISTINCT s.Name AS SubjectName
FROM Subjects s
JOIN Lectures l ON s.Id = l.SubjectId
JOIN Teachers t ON l.TeacherId = t.Id
JOIN GroupsLectures gl ON l.Id = gl.LectureId
JOIN Groups g ON gl.GroupId = g.Id
WHERE t.Name = 'Alex' AND t.Surname = 'Carmack' AND g.Year = 5;


-- 4 Вивести прізвища викладачів, які не читають лекції у понеділок
SELECT t.Surname
FROM Teachers t
WHERE t.Id NOT IN (
    SELECT DISTINCT l.TeacherId
    FROM Lectures l
    JOIN Schedules s ON l.Id = s.LectureId
    WHERE s.DayOfWeek = 1 -- понеділок
);


-- 5 Вивести назви аудиторій, із зазначенням їх корпусів, у яких немає лекцій у середу другого тижня на третій парі
SELECT lr.Name AS LectureRoomName, lr.Building
FROM LectureRooms lr
WHERE NOT EXISTS (
    SELECT 1
    FROM Schedules s
    WHERE s.LectureRoomId = lr.Id
    AND s.DayOfWeek = 3  --  середа
    AND s.Week = 2
    AND s.Class = 3
);


-- 6. Вивести повні імена викладачів факультету «Computer Science», які не курирують групи кафедри «Software Development»
SELECT DISTINCT t.Name + ' ' + t.Surname AS FullName
FROM Teachers t
JOIN Lectures l ON t.Id = l.TeacherId
JOIN GroupsLectures gl ON l.Id = gl.LectureId
JOIN Groups g ON gl.GroupId = g.Id
JOIN Departments d ON g.DepartmentId = d.Id
JOIN Faculties f ON d.FacultyId = f.Id
WHERE f.Name = 'Computer Science'
AND t.Id NOT IN (
    SELECT DISTINCT c.TeacherId
    FROM Curators c
    JOIN GroupsCurators gc ON c.Id = gc.CuratorId
    JOIN Groups g2 ON gc.GroupId = g2.Id
    JOIN Departments d2 ON g2.DepartmentId = d2.Id
    WHERE d2.Name = 'Software Development'
);


-- 7. Вивести список номерів усіх корпусів, які є у таблицях факультетів, кафедр та аудиторій
SELECT Building FROM Faculties
UNION
SELECT Building FROM Departments
UNION
SELECT Building FROM LectureRooms;


-- 8. Вивести повні імена викладачів у такому порядку: декани, завідувачі, викладачі, куратори, асистенти
-- Декани
SELECT t.Name + ' ' + t.Surname AS FullName, 'Dean' AS Type
FROM Teachers t
JOIN Deans d ON t.Id = d.TeacherId
UNION ALL
-- Завідувачі
SELECT t.Name + ' ' + t.Surname, 'Head'
FROM Teachers t
JOIN Heads h ON t.Id = h.TeacherId
UNION ALL
-- Всі виладачі
SELECT Name + ' ' + Surname, 'Teacher'
FROM Teachers
UNION ALL
-- Куратори
SELECT t.Name + ' ' + t.Surname, 'Curator'
FROM Teachers t
JOIN Curators c ON t.Id = c.TeacherId
UNION ALL
-- Асистенти
SELECT t.Name + ' ' + t.Surname, 'Assistant'
FROM Teachers t
JOIN Assistants a ON t.Id = a.TeacherId;


-- 9. Вивести дні тижня (без повторень), в які є заняття в аудиторіях «A311» та «A104» корпусу 6
SELECT DISTINCT s.DayOfWeek
FROM Schedules s
JOIN LectureRooms lr ON s.LectureRoomId = lr.Id
WHERE lr.Name IN ('A311', 'A104') AND lr.Building = 6
ORDER BY s.DayOfWeek;


-- 10. Додатковий запит: вивести розклад занять для групи «F505»
SELECT 
    g.Name AS GroupName,
    s.Week,
    s.DayOfWeek,
    s.Class,
    sub.Name AS SubjectName,
    t.Name + ' ' + t.Surname AS TeacherName,
    lr.Name AS LectureRoom,
    lr.Building
FROM Groups g
JOIN GroupsLectures gl ON g.Id = gl.GroupId
JOIN Lectures l ON gl.LectureId = l.Id
JOIN Subjects sub ON l.SubjectId = sub.Id
JOIN Teachers t ON l.TeacherId = t.Id
JOIN Schedules s ON l.Id = s.LectureId
JOIN LectureRooms lr ON s.LectureRoomId = lr.Id
WHERE g.Name = 'F505'
ORDER BY s.Week, s.DayOfWeek, s.Class;

