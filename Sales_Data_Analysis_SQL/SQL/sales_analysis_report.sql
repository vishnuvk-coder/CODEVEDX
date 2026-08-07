SELECT SUM(total_amount) AS Total_Revenue
FROM Orders;

SELECT COUNT(*) AS Total_Customers
FROM Customers;

SELECT COUNT(*) AS Total_Orders
FROM Orders;

SELECT MAX(total_amount) AS Highest_Order
FROM Orders;

SELECT MIN(total_amount) AS Lowest_Order
FROM Orders;

SELECT AVG(total_amount) AS Average_Order
FROM Orders;

SELECT
    c.customer_name,
    SUM(o.total_amount) AS Total_Sales
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY Total_Sales DESC;

SELECT
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS Revenue
FROM Products p
JOIN Order_Items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY Revenue DESC;

SELECT
    payment_status,
    COUNT(*) AS Total
FROM Payments
GROUP BY payment_status;

SELECT *
FROM Orders
WHERE order_status = 'Completed';