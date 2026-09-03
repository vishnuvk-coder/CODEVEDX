SELECT *
FROM Products
WHERE price > (
    SELECT AVG(price)
    FROM Products
);

SELECT *
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
);

SELECT *
FROM Orders
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM Orders
);

SELECT *
FROM Products
WHERE price = (
    SELECT MAX(price)
    FROM Products
);

SELECT *
FROM Products
WHERE price = (
    SELECT MIN(price)
    FROM Products
);

SELECT customer_id
FROM Orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

SELECT *
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
);