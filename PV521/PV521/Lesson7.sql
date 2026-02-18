USE Library_PV521;

CREATE VIEW books_genres_view
AS
SELECT DISTINCT b.id, b.title, b.price, g.title AS genre_title
FROM books b
INNER JOIN booktToGenres bg ON b.id = bg.id_book
INNER JOIN genres g ON bg.id_genre = g.id;

SELECT title FROM books_genres_view 
WHERE price > 12 AND genre_title != 'Fantasy';

--
CREATE TABLE authors_logs
(
  id INT PRIMARY KEY IDENTITY(1,1),
  id_author INT FOREIGN KEY REFERENCES authors(id),
  content NVARCHAR(100) NOT NULL
)

CREATE TRIGGER authorLogTrigger
ON authors
AFTER INSERT
AS
BEGIN
    INSERT INTO authors_logs (id_author, content)
    SELECT INSERTED.id, 'New author added with ID: ' + CONVERT(NVARCHAR(10), INSERTED.id)
    FROM INSERTED;
END;

SELECT * FROM authors_logs;




