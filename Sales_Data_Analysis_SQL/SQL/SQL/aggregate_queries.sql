SELECT customer_id, SUM(total_amount) AS Total_Spent
FROM Orders
GROUP BY customer_id;

SELECT customer_id, SUM(total_amount) AS Total_Spent
FROM Orders
GROUP BY customer_id
HAVING SUM(total_amount) > 10000;

SELECT customer_id, COUNT(order_id) AS Total_Orders
FROM Orders
GROUP BY customer_id;

SELECT customer_id, AVG(total_amount) AS Average_Order
FROM Orders
GROUP BY customer_id;

SELECT product_id,
       SUM(quantity * unit_price) AS Revenue
FROM Order_Items
GROUP BY product_id;

SELECT product_id,
       SUM(quantity) AS Total_Quantity
FROM Order_Items
GROUP BY product_id
ORDER BY Total_Quantity DESC;