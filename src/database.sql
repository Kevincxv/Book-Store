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
SELECT o.orderID,
    u.username,
    b.title,
    o.quantity,
    o.totalPrice
FROM Orders o
    JOIN Users u ON o.userID = u.userID
    JOIN Books b ON o.bookID = b.bookID
WHERE u.role = 'Customer';
-- Granting SELECT privilege on Books to a specific user (e.g., 'employeeUser')
GRANT SELECT ON Books TO employeeUser;
-- Revoking DELETE privilege on Orders from a user (e.g., 'customerUser')
REVOKE DELETE ON Orders
FROM customerUser;
-- Store Procedures
CREATE OR REPLACE FUNCTION calculateTotalPrice(order_id INT) RETURNS DECIMAL AS $$
DECLARE book_price DECIMAL;
order_quantity INT;
BEGIN
SELECT b.price,
    o.quantity INTO book_price,
    order_quantity
FROM Books b
    JOIN Orders o ON b.bookID = o.bookID
WHERE o.orderID = order_id;
RETURN book_price * order_quantity;
END;
$$ LANGUAGE plpgsql;
-- Inserting users
INSERT INTO Users (username, password, role)
VALUES ('adminUser', 'encryptedPassword', 'Admin');
INSERT INTO Users (username, password, role)
VALUES ('employeeUser', 'encryptedPassword', 'Employee');
INSERT INTO Users (username, password, role)
VALUES ('customerUser', 'encryptedPassword', 'Customer');
-- Inserting books
INSERT INTO Books (title, author, price, stock)
VALUES (
        'The Great Gatsby',
        'F. Scott Fitzgerald',
        12.99,
        75
    );
INSERT INTO Books (title, author, price, stock)
VALUES ('To Kill a Mockingbird', 'Harper Lee', 10.99, 60);
INSERT INTO Books (title, author, price, stock)
VALUES ('1984', 'George Orwell', 9.99, 80);
INSERT INTO Books (title, author, price, stock)
VALUES ('Pride and Prejudice', 'Jane Austen', 11.99, 45);
INSERT INTO Books (title, author, price, stock)
VALUES (
        'The Catcher in the Rye',
        'J.D. Salinger',
        14.99,
        55
    );
INSERT INTO Books (title, author, price, stock)
VALUES ('The Hobbit', 'J.R.R. Tolkien', 14.99, 70);
INSERT INTO Books (title, author, price, stock)
VALUES (
        'Harry Potter and the Sorcerer''s Stone',
        'J.K. Rowling',
        15.99,
        90
    );
INSERT INTO Books (title, author, price, stock)
VALUES (
        'The Lord of the Rings',
        'J.R.R. Tolkien',
        19.99,
        60
    );
INSERT INTO Books (title, author, price, stock)
VALUES ('The Hunger Games', 'Suzanne Collins', 11.99, 80);
INSERT INTO Books (title, author, price, stock)
VALUES ('Dune', 'Frank Herbert', 12.99, 55);
INSERT INTO Books (title, author, price, stock)
VALUES ('The Alchemist', 'Paulo Coelho', 9.99, 100);
INSERT INTO Books (title, author, price, stock)
VALUES ('The Da Vinci Code', 'Dan Brown', 12.99, 75);
INSERT INTO Books (title, author, price, stock)
VALUES (
        'The Girl with the Dragon Tattoo',
        'Stieg Larsson',
        14.99,
        85
    );
INSERT INTO Books (title, author, price, stock)
VALUES ('The Shining', 'Stephen King', 11.99, 70);
INSERT INTO Books (title, author, price, stock)
VALUES ('The Road', 'Cormac McCarthy', 10.99, 60);
INSERT INTO Books (title, author, price, stock)
VALUES ('Brave New World', 'Aldous Huxley', 13.99, 50);
INSERT INTO Books (title, author, price, stock)
VALUES ('The Odyssey', 'Homer', 8.99, 95);
INSERT INTO Books (title, author, price, stock)
VALUES ('The Iliad', 'Homer', 8.99, 85);
INSERT INTO Books (title, author, price, stock)
VALUES ('Moby-Dick', 'Herman Melville', 15.99, 45);
INSERT INTO Books (title, author, price, stock)
VALUES (
        'The Catcher in the Rye',
        'J.D. Salinger',
        14.99,
        55
    );
INSERT INTO Books (title, author, price, stock)
VALUES (
        'The Great Expectations',
        'Charles Dickens',
        11.99,
        40
    );
INSERT INTO Books (title, author, price, stock)
VALUES ('To the Lighthouse', 'Virginia Woolf', 13.99, 30);
INSERT INTO Books (title, author, price, stock)
VALUES (
        'The Road Less Traveled',
        'M. Scott Peck',
        10.99,
        50
    );
INSERT INTO Books (title, author, price, stock)
VALUES (
        'The Picture of Dorian Gray',
        'Oscar Wilde',
        12.99,
        45
    );
INSERT INTO Books (title, author, price, stock)
VALUES (
        'The Old Man and the Sea',
        'Ernest Hemingway',
        9.99,
        60
    );
INSERT INTO Books (title, author, price, stock)
VALUES (
        'The Grapes of Wrath',
        'John Steinbeck',
        11.99,
        55
    );
INSERT INTO Books (title, author, price, stock)
VALUES (
        'The Road to Serfdom',
        'Friedrich Hayek',
        14.99,
        35
    );
INSERT INTO Books (title, author, price, stock)
VALUES (
        'The Sun Also Rises',
        'Ernest Hemingway',
        10.99,
        65
    );
INSERT INTO Books (title, author, price, stock)
VALUES ('The Metamorphosis', 'Franz Kafka', 9.99, 70);
INSERT INTO Books (title, author, price, stock)
VALUES (
        'The Count of Monte Cristo',
        'Alexandre Dumas',
        13.99,
        40
    );