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
