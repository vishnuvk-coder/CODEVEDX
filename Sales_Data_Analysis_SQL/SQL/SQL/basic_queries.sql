SELECT customer_name, city
FROM Customers;

SELECT *
FROM Customers
WHERE city = 'Badlapur';

SELECT *
FROM Products
ORDER BY price DESC;

SELECT *
FROM Products
ORDER BY price ASC;

SELECT *
FROM Customers
LIMIT 3;

SELECT DISTINCT city
FROM Customers;

SELECT COUNT(*) AS Total_Customers
FROM Customers;

SELECT SUM(total_amount) AS Total_Sales
FROM Orders;

SELECT AVG(total_amount) AS Average_Order
FROM Orders;

SELECT MIN(price) AS Lowest_Price
FROM Products;

SELECT MAX(price) AS Highest_Price
FROM Products;