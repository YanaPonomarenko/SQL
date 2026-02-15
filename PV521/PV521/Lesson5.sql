CREATE DATABASE Library_PV521;

GO

USE Library_PV521;

GO

CREATE TABLE genres(
	id INT PRIMARY KEY IDENTITY(1,1),
	title NVARCHAR(50) NOT NULL
)

GO

CREATE TABLE authors(
	id INT PRIMARY KEY IDENTITY(1,1),
	name NVARCHAR(30) NOT NULL,
	surname NVARCHAR(30) NOT NULL
);

GO

CREATE TABLE books(
	id INT PRIMARY KEY IDENTITY(1,1),
	title NVARCHAR(50) NOT NULL,
	[year] INT NOT NULL,
	price DECIMAL(10,2) NOT NULL,
	id_author INT FOREIGN KEY REFERENCES authors(id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

GO

CREATE TABLE booktToGenres(
	id INT PRIMARY KEY IDENTITY(1,1),
	id_book INT FOREIGN KEY REFERENCES books(id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	id_genre INT FOREIGN KEY REFERENCES genres(id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO genres (title) VALUES 
('Fantasy'),
('Science Fiction'),
('Detective'),
('Romance'),
('Horror'),
('Historical'),
('Adventure'),
('Drama');

GO

INSERT INTO authors (name, surname) VALUES
('Stephen', 'King'),
('Agatha', 'Christie'),
('J.K.', 'Rowling'),
('George', 'Orwell'),
('Jane', 'Austen'),
('Ernest', 'Hemingway'),
('Mark', 'Twain'),
('Arthur', 'Doyle');

GO

INSERT INTO books (title, [year], price, id_author) VALUES
('The Shining', 1977, 15.99, 1),
('Murder on the Orient Express', 1934, 12.50, 2),
('Harry Potter and the Philosopher''s Stone', 1997, 20.00, 3),
('1984', 1949, 14.30, 4),
('Pride and Prejudice', 1813, 10.99, 5),
('The Old Man and the Sea', 1952, 13.45, 6),
('Adventures of Huckleberry Finn', 1884, 11.25, 7),
('Sherlock Holmes: A Study in Scarlet', 1887, 16.75, 8),
('Animal Farm', 1945, 9.99, 4),
('It', 1986, 18.60, 1);

GO

INSERT INTO booktToGenres (id_book, id_genre) VALUES
(1, 5),  -- The Shining -> Horror
(2, 3),  -- Murder on the Orient Express -> Detective
(3, 1),  -- Harry Potter -> Fantasy
(3, 7),  -- Harry Potter -> Adventure
(4, 2),  -- 1984 -> Science Fiction
(4, 8),  -- 1984 -> Drama
(5, 4),  -- Pride and Prejudice -> Romance
(6, 8),  -- The Old Man and the Sea -> Drama
(7, 7),  -- Huckleberry Finn -> Adventure
(8, 3),  -- Sherlock Holmes -> Detective
(9, 2),  -- Animal Farm -> Science Fiction
(10, 5); -- It -> Horror

GO

SELECT b.id, b.title+' '+CONVERT(nvarchar, b.year), b.price, g.title, a.name+' '+a.surname AS full_name 
FROM books b
INNER JOIN booktToGenres bg ON b.id = bg.id_book
INNER JOIN genres g ON bg.id_genre = g.id
INNER JOIN authors a ON b.id_author = a.id;

GO

SELECT b.id, b.title, b.year, b.price, g.title 
FROM books b, genres g, booktToGenres bg
WHERE b.id = bg.id_book AND g.id = bg.id_genre;

--Вивести всі книжки і скільки жанрів має кожна книжка
SELECT b.id, b.title, COUNT(b.id) AS genres_count 
FROM books b
INNER JOIN booktToGenres bg ON b.id = bg.id_book
INNER JOIN genres g ON bg.id_genre = g.id
GROUP BY b.id, b.title;

SELECT * FROM books WHERE id IN (1,2,7);
SELECT * FROM books WHERE id = 1 OR id = 2 OR id = 7;
SELECT * FROM books WHERE id NOT IN (1,2,7);
SELECT * FROM books WHERE id <> 1 AND id <> 2 AND id <> 7;

-- До якого жанру відноситься книга, яка вартує найбільше
SELECT DISTINCT g.id, g.title AS genre_title
FROM genres g
INNER JOIN booktToGenres bg ON g.id = bg.id_genre
WHERE bg.id_book = (
    SELECT TOP 1 id 
    FROM books 
    ORDER BY price DESC
);

SELECT * FROM authors WHERE id = (
	SELECT TOP 1 id_author 
	FROM books 
	ORDER BY price DESC
);

