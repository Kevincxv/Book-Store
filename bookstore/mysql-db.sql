CREATE TABLE Users(
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Password VARCHAR(255),
    Name VARCHAR(255),
    Email VARCHAR(255),
    UserType ENUM('Admin', 'Customer')
);

CREATE TABLE Books(
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255),
    Author VARCHAR(255),
    Price DECIMAL(10,2),
    Stock INT
);

CREATE TABLE Orders(
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    BookID INT,
    Quantity INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

CREATE VIEW BookOrderSummary AS
SELECT b.BookID, b.Title, b.Author, COUNT(o.OrderID) AS TotalOrders
FROM Books b
LEFT JOIN Orders o ON b.BookID = o.BookID
GROUP BY b.BookID;


-- Stored Procedure for total sales
DELIMITER //
CREATE PROCEDURE GetTotalSales(IN book_id INT)
BEGIN
    SELECT Price * Quantity AS TotalSales FROM Books 
    JOIN Orders ON Books.BookID = Orders.BookID 
    WHERE Books.BookID = book_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateBookStock(IN book_id INT, quantity_sold INT)
BEGIN
    UPDATE Books SET Stock = Stock - quantity_sold WHERE BookID = book_id;
END //
DELIMITER ;


INSERT INTO Users (Password, Name, Email, UserType) VALUES ('password1', 'User1', 'user1@example.com', 'Customer');
INSERT INTO Users (Password, Name, Email, UserType) VALUES ('password2', 'User2', 'user2@example.com', 'Customer');
INSERT INTO Users (Password, Name, Email, UserType) VALUES ('password3', 'User3', 'user3@example.com', 'Customer');
INSERT INTO Users (Password, Name, Email, UserType) VALUES ('password4', 'User4', 'user4@example.com', 'Customer');
INSERT INTO Users (Password, Name, Email, UserType) VALUES ('password5', 'User5', 'user5@example.com', 'Customer');

INSERT INTO Books (Title, Author, Price, Stock) VALUES ('Book Title 1', 'Author 1', 11, 6);
INSERT INTO Books (Title, Author, Price, Stock) VALUES ('Book Title 2', 'Author 2', 12, 7);
INSERT INTO Books (Title, Author, Price, Stock) VALUES ('Book Title 3', 'Author 3', 13, 8);
INSERT INTO Books (Title, Author, Price, Stock) VALUES ('Book Title 4', 'Author 4', 14, 9);
INSERT INTO Books (Title, Author, Price, Stock) VALUES ('Book Title 5', 'Author 5', 15, 10);

INSERT INTO Orders (UserID, BookID, Quantity) VALUES (2, 2, 2);
INSERT INTO Orders (UserID, BookID, Quantity) VALUES (3, 3, 3);
INSERT INTO Orders (UserID, BookID, Quantity) VALUES (4, 4, 1);
INSERT INTO Orders (UserID, BookID, Quantity) VALUES (5, 5, 2);
INSERT INTO Orders (UserID, BookID, Quantity) VALUES (1, 1, 3);
INSERT INTO Orders (UserID, BookID, Quantity) VALUES (2, 2, 1);
INSERT INTO Orders (UserID, BookID, Quantity) VALUES (3, 3, 2);
INSERT INTO Orders (UserID, BookID, Quantity) VALUES (4, 4, 3);
INSERT INTO Orders (UserID, BookID, Quantity) VALUES (5, 5, 1);
INSERT INTO Orders (UserID, BookID, Quantity) VALUES (1, 1, 2);