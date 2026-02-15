USE pv521;

CREATE TABLE authors(
  id INT PRIMARY KEY IDENTITY(1,1),
  name NVARCHAR(30) NOT NULL,
  surname NVARCHAR(30) NOT NULL
);

CREATE TABLE genres(
  id INT PRIMARY KEY IDENTITY(1,1),
  name NVARCHAR(30) NOT NULL
);

CREATE TABLE books(
  id INT PRIMARY KEY IDENTITY(1,1),
  title NVARCHAR(30) NOT NULL,
  [year] INT NOT NULL CHECK ([year]>=1800 AND [year]<=YEAR(GETDATE())),
  author_id INT NOT NULL,
  genre_id INT NOT NULL,
  FOREIGN KEY (author_id) REFERENCES authors(id),
  FOREIGN KEY (genre_id) REFERENCES genres(id)
);

INSERT INTO authors (name, surname)
VALUES 
('Тарас', 'Шевченко'),
('Іван', 'Франко'),
('Леся', 'Українка'),
('Михайло', 'Коцюбинський');

INSERT INTO genres (name)
VALUES
('Поезія'),
('Роман'),
('Драма'),
('Новела');

INSERT INTO books (title, [year], author_id, genre_id)
VALUES
('Кобзар', 1840, 1, 1),
('Гайдамаки', 1841, 1, 1),
('Захар Беркут', 1883, 2, 2),
('Мойсей', 1905, 2, 1),
('Лісова пісня', 1911, 3, 3),
('Intermezzo', 1908, 4, 4);


SELECT b.id, b.title, b.[year], a.name, a.surname, g.name AS genre
FROM books AS b, authors AS a, genres AS g
WHERE b.author_id = a.id AND b.genre_id = g.id
ORDER BY b.[year] ASC;

ALTER TABLE books
ADD price DECIMAL(10,2);

UPDATE books SET price = 250.00 WHERE title = 'Кобзар';
UPDATE books SET price = 200.00 WHERE title = 'Гайдамаки';
UPDATE books SET price = 180.00 WHERE title = 'Захар Беркут';
UPDATE books SET price = 220.00 WHERE title = 'Мойсей';
UPDATE books SET price = 300.00 WHERE title = 'Лісова пісня';
UPDATE books SET price = 150.00 WHERE title = 'Intermezzo';

SELECT DISTINCT title FROM books;

SELECT TOP 5 * FROM books;

SELECT TOP 1 * FROM books ORDER BY price DESC;

SELECT AVG(price) AS average_price_after_1830 FROM books  WHERE year > 1830;

SELECT 
    a.name, 
    a.surname, 
    SUM(b.price) AS total_price
FROM books AS b
INNER JOIN authors AS a ON a.id = b.author_id
GROUP BY a.id, a.name, a.surname
ORDER BY total_price DESC;


SELECT  a.name, a.surname, COUNT(author_id) AS count_books 
FROM books AS b
INNER JOIN authors AS a
ON a.id = b.author_id
GROUP BY author_id, a.name, a.surname
HAVING a.name LIKE N'Тарас' OR a.name LIKE N'Леся';

SELECT year, COUNT(year) AS books_count 
FROM books
GROUP BY year
ORDER BY year;