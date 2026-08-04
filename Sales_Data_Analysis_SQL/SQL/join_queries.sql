SELECT c.customer_name, o.order_id
FROM Customers c
INNER JOIN Orders o
ON c.customer_id = o.customer_id;

SELECT c.customer_name, o.total_amount
FROM Customers c
INNER JOIN Orders o
ON c.customer_id = o.customer_id;

SELECT o.order_id,
       p.payment_method,
       p.payment_status
FROM Orders o
INNER JOIN Payments p
ON o.order_id = p.order_id;

SELECT oi.order_id,
       pr.product_name,
       oi.quantity
FROM Order_Items oi
INNER JOIN Products pr
ON oi.product_id = pr.product_id;

SELECT
    c.customer_name,
    pr.product_name,
    oi.quantity,
    o.total_amount
FROM Customers c
INNER JOIN Orders o
ON c.customer_id = o.customer_id
INNER JOIN Order_Items oi
ON o.order_id = oi.order_id
INNER JOIN Products pr
ON oi.product_id = pr.product_id;