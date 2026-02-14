--constrains
USE pv521;

GO

DROP TABLE students;

GO

CREATE TABLE students
(
	id INT PRIMARY KEY IDENTITY(1,1) NOT  NULL,
	name varchar(30) DEFAULT ('JOHN') NOT NULL,
	age int NOT NULL
)
GO

INSERT INTO students (age)
VALUES (20),(30);

GO

SELECT * FROM students;

DROP DATABASE book_store;

USE book_store;

CREATE TABLE books 
(
	id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	title varchar(30) 
		CHECK (LEN (title) >= 5 )  DEFAULT ('book') NOT NULL,
	author varchar(30) UNIQUE NOT NULL,
	year INT
	CHECK (year >= 1800 AND year <= YEAR(GETDATE()))
	DEFAULT (2020) NOT NULL
);

INSERT INTO books 
VALUES ('Story', 'Bob', 2008) , 
('Story2','Alex', 1938),
('Story3','John',1994);

SELECT * FROM books;

TRUNCATE TABLE books;