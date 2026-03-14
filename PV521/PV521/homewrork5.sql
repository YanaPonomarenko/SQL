CREATE DATABASE SportShop;

USE SportShop;

--DROP DATABASE IF EXISTS SportShop;

CREATE TABLE Employees
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    FullName NVARCHAR(30) NOT NULL CHECK (LEN(FullName) > 0),
    Position NVARCHAR(30) NOT NULL CHECK (LEN(Position) > 0),
    HireDate DATE NOT NULL CHECK (HireDate <= GETDATE()),
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F')),
    Salary MONEY NOT NULL CHECK (Salary > 0),
    IsActive BIT NOT NULL DEFAULT 1
);


CREATE TABLE EmployeesArchive
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    EmployeeId INT NOT NULL,
    FullName NVARCHAR(30) NOT NULL,
    Position NVARCHAR(30) NOT NULL,
    HireDate DATE NOT NULL,
    FireDate DATE NOT NULL,
    Gender CHAR(1) NOT NULL,
    Salary MONEY NOT NULL,
    ArchivedAt DATETIME NOT NULL DEFAULT GETDATE()
);


CREATE TABLE Manufacturers
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(50) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
    Country NVARCHAR(50) NOT NULL
);


CREATE TABLE Categories
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(50) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
);


CREATE TABLE Products
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(50) NOT NULL CHECK (LEN(Name) > 0),
    CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    CostPrice MONEY NOT NULL CHECK (CostPrice > 0),
    ManufacturerId INT NOT NULL FOREIGN KEY REFERENCES Manufacturers(Id),
    SalePrice MONEY NOT NULL CHECK (SalePrice > 0)
);


CREATE TABLE Customers
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    FullName NVARCHAR(100) NOT NULL CHECK (LEN(FullName) > 0),
    Email NVARCHAR(50) UNIQUE CHECK (Email LIKE '%_@__%.__%'),
    Phone NVARCHAR(15) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    DiscountPercent DECIMAL(5,2) NOT NULL DEFAULT 0 CHECK (DiscountPercent >= 0 AND DiscountPercent <= 100),
    IsSubscribedToNewsletter BIT NOT NULL DEFAULT 0,
    RegistrationDate DATE NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Sales
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    ProductId INT NOT NULL FOREIGN KEY REFERENCES Products(Id),
    Quantity INT NOT NULL CHECK (Quantity > 0),
    SalePrice MONEY NOT NULL CHECK (SalePrice > 0),
    SaleDate DATETIME NOT NULL DEFAULT GETDATE(),
    EmployeeId INT NOT NULL FOREIGN KEY REFERENCES Employees(Id),
    CustomerId INT NULL FOREIGN KEY REFERENCES Customers(Id)
);


CREATE TABLE OrderHistory
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    CustomerId INT NOT NULL FOREIGN KEY REFERENCES Customers(Id),
    SaleId INT NOT NULL FOREIGN KEY REFERENCES Sales(Id),
    TotalAmount MONEY NOT NULL,
    OrderDate DATETIME NOT NULL
);


INSERT INTO Employees (FullName, Position, HireDate, Gender, Salary) VALUES
('Іван Петренко', 'Продавець', '2022-01-15', 'M', 15000),
('Марія Коваленко', 'Ст.продавець', '2021-03-10', 'F', 18500),
('Олександр Шевченко', 'Менеджер', '2020-05-20', 'M', 25000),
('Олена Бондаренко', 'Продавець', '2023-02-01', 'F', 14000),
('Андрій Мельник', 'Продавець', '2022-11-12', 'M', 14500);


INSERT INTO Categories (Name) VALUES
('Одяг'), ('Взуття'), ('М''ячі'), ('Тренажери'), ('Аксесуари');


INSERT INTO Manufacturers (Name, Country) VALUES
('Nike', 'США'),
('Adidas', 'Німеччина'),
('Puma', 'Німеччина'),
('Reebok', 'Великобританія'),
('Under Armour', 'США');


INSERT INTO Products (Name, CategoryId, Quantity, CostPrice, ManufacturerId, SalePrice) VALUES
('Футболка Nike', 1, 50, 300, 1, 650),
('Кросівки Adidas', 2, 30, 800, 2, 1800),
('М''яч Puma', 3, 20, 400, 3, 950),
('Гантелі 5кг', 4, 15, 200, 4, 450),
('Шапка спортивна', 1, 40, 150, 5, 350);


INSERT INTO Customers (FullName, Email, Phone, Gender, DiscountPercent, IsSubscribedToNewsletter) VALUES
('Тарас Гриценко', 'taras@gmail.com', '0951234567', 'M', 5, 1),
('Оксана Лисенко', 'oksana@ukr.net', '0977654321', 'F', 10, 1),
('Микола Савченко', 'mykola@yahoo.com', '0639876543', 'M', 0, 0);


INSERT INTO Sales (ProductId, Quantity, SalePrice, EmployeeId, CustomerId) VALUES
(1, 2, 650, 1, 1),
(2, 1, 1800, 2, 2),
(3, 3, 950, 1, NULL),
(4, 2, 450, 3, 3),
(5, 1, 350, 4, NULL);

--
GO

CREATE TRIGGER EmployeesFireTrigger
ON Employees
INSTEAD OF DELETE
AS
BEGIN
    INSERT INTO EmployeesArchive (EmployeeId, FullName, Position, HireDate, FireDate, Gender, Salary)
    SELECT Id, FullName, Position, HireDate, GETDATE(), Gender, Salary
    FROM deleted;

    UPDATE Employees SET IsActive = 0
    WHERE Id IN (SELECT Id FROM deleted);
END;


DELETE FROM Employees WHERE Id = 5;


SELECT 'Активні співробітники:' AS Info, * FROM Employees WHERE IsActive = 1;
SELECT 'Архів співробітників:' AS Info, * FROM EmployeesArchive;
