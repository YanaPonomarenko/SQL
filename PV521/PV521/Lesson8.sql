USE Library_PV521;

--bit
ALTER TABLE books
ADD is_active BIT DEFAULT(1);

SELECT * FROM books;

UPDATE books SET is_active=1;

GO

ALTER TABLE books 
DROP CONSTRAINT FK__books__id_author__6OA75COF;


GO
CREATE TRIGGER booksDeleteTrigger
ON books
INSTEAD OF DELETE
AS
BEGIN
	--print('Видалення заборонено')
	UPDATE books SET is_active=0
	WHERE id IN(
	SELECT id FROM deleted)
END


DROP TRIGGER booksDeleteTrigger


DELETE FROM books WHERE id IN(2,3);

SELECT * FROM books;

--
ALTER TABLE authors
ADD discount DECIMAL(5,2) DEFAULT 0;

ALTER TABLE books
ADD original_price DECIMAL(10,2);

UPDATE books SET original_price = price;

 GO

CREATE TRIGGER updateBooksPrice
ON authors
AFTER UPDATE
AS
BEGIN
    IF UPDATE(discount)
    BEGIN
        UPDATE b
        SET price = b.original_price * (1 - a.discount / 100)
        FROM books b
        INNER JOIN authors a ON b.id_author = a.id
        WHERE a.id IN (SELECT id FROM inserted);
    END
END;

SELECT * FROM authors;
SELECT * FROM books;