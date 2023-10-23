-- Users Table
CREATE TABLE Users (
   userID SERIAL PRIMARY KEY,
   username VARCHAR(255) UNIQUE NOT NULL,
   password VARCHAR(255) NOT NULL,
   role VARCHAR(50) NOT NULL CHECK (role IN ('Admin', 'Employee', 'Customer'))
);

-- Books Table
CREATE TABLE Books (
   bookID SERIAL PRIMARY KEY,
   title VARCHAR(255) NOT NULL,
   author VARCHAR(255) NOT NULL,
   price DECIMAL NOT NULL,
   stock INT NOT NULL
);

-- Orders Table
CREATE TABLE Orders (
    orderID SERIAL PRIMARY KEY,
    userID INT REFERENCES Users(userID),
    bookID INT REFERENCES Books(bookID),
    quantity INT NOT NULL,
    totalPrice DECIMAL NOT NULL
);

-- Creating the Views
CREATE VIEW CustomerOrders AS
SELECT o.orderID, u.username, b.title, o.quantity, o.totalPrice
FROM Orders o
JOIN Users u ON o.userID = u.userID
JOIN Books b ON o.bookID = b.bookID
WHERE u.role = 'Customer';

-- Granting SELECT privilege on Books to a specific user (e.g., 'employeeUser')
GRANT SELECT ON Books TO employeeUser;

-- Revoking DELETE privilege on Orders from a user (e.g., 'customerUser')
REVOKE DELETE ON Orders FROM customerUser;

-- Store Procedures
CREATE OR REPLACE FUNCTION calculateTotalPrice(order_id INT) RETURNS DECIMAL AS $$
DECLARE
    book_price DECIMAL;
    order_quantity INT;
BEGIN
    SELECT b.price, o.quantity INTO book_price, order_quantity
    FROM Books b
    JOIN Orders o ON b.bookID = o.bookID
    WHERE o.orderID = order_id;

    RETURN book_price * order_quantity;
END;
$$ LANGUAGE plpgsql;

-- Inserting users
INSERT INTO Users (username, password, role) VALUES ('adminUser', 'encryptedPassword', 'Admin');
INSERT INTO Users (username, password, role) VALUES ('employeeUser', 'encryptedPassword', 'Employee');
INSERT INTO Users (username, password, role) VALUES ('customerUser', 'encryptedPassword', 'Customer');

-- Inserting books
INSERT INTO Books (title, author, price, stock) VALUES ('Book Title 1', 'Author Name 1', 19.99, 100);
INSERT INTO Books (title, author, price, stock) VALUES ('Book Title 2', 'Author Name 2', 24.99, 50);
