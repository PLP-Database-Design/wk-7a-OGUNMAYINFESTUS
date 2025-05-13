-- Task: Achieving 1NF (First Normal Form) 🛠️
-- The original table ProductDetail contains multiple products in the "Products" column,
-- which violates 1NF as each row should contain atomic values. 
-- We need to transform the table into 1NF by ensuring each row represents a single product for an order.
-- Query to achieve 1NF
SELECT OrderID,
    CustomerName,
    TRIM(
        SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.n), ',', -1)
    ) AS Product
FROM ProductDetail
    JOIN (
        SELECT 1 AS n
        UNION ALL
        SELECT 2
        UNION ALL
        SELECT 3
        UNION ALL
        SELECT 4
        UNION ALL
        SELECT 5
    ) n ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= n.n - 1;
-- This query splits the Products column into individual rows using a numbers table (n).
-- The TRIM function removes any leading or trailing spaces from the product names.
-- Task: Achieving 2NF (Second Normal Form) 🧩
-- The original table OrderDetails is in 1NF, but it contains partial dependencies. 
-- Specifically, the "CustomerName" column depends only on the "OrderID", violating 2NF.
-- To achieve 2NF, we will remove partial dependencies by creating two tables:
-- 1. A table for order information (Orders) to store the "OrderID" and "CustomerName".
-- 2. A table for product details (OrderProducts) to store "OrderID", "Product", and "Quantity".
-- 1. Create the Orders table to store the order and customer information.
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);
-- 2. Insert the customer details from OrderDetails into the Orders table.
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID,
    CustomerName
FROM OrderDetails;
-- 3. Create the OrderProducts table to store the product details.
CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
-- 4. Insert the product details from OrderDetails into the OrderProducts table.
INSERT INTO OrderProducts (OrderID, Product, Quantity)
SELECT OrderID,
    Product,
    Quantity
FROM OrderDetails;
-- These queries break down the original table into two separate tables:
-- 1. Orders table: stores the order and customer details, ensuring "CustomerName" fully depends on "OrderID".
-- 2. OrderProducts table: stores product details, ensuring full dependency on the composite primary key ("OrderID", "Product").