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

