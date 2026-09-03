USE sales_analysis_db;

-- ============================================
-- DAY 13: COMMON TABLE EXPRESSIONS (CTEs)
-- ============================================


-- 1. Basic CTE
-- Retrieve high-value orders

WITH high_value_orders AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        total_amount
    FROM orders
    WHERE total_amount > 500
)
SELECT *
FROM high_value_orders;


-- 2. CTE with ORDER BY

WITH high_value_orders AS (
    SELECT
        order_id,
        customer_id,
        total_amount
    FROM orders
    WHERE total_amount > 500
)
SELECT *
FROM high_value_orders
ORDER BY total_amount DESC;


-- 3. CTE with GROUP BY
-- Calculate total sales for each customer

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(total_amount) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM customer_sales
ORDER BY total_sales DESC;


-- 4. CTE with HAVING
-- Customers whose total sales exceed 1000

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(total_amount) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM customer_sales
WHERE total_sales > 1000
ORDER BY total_sales DESC;


-- 5. CTE with JOIN
-- Display customer names and their total sales

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(total_amount) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.customer_name,
    cs.total_sales
FROM customers c
JOIN customer_sales cs
    ON c.customer_id = cs.customer_id
ORDER BY cs.total_sales DESC;


-- 6. Multiple CTEs
-- Calculate customer sales and overall average sales

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(total_amount) AS total_sales
    FROM orders
    GROUP BY customer_id
),
average_sales AS (
    SELECT
        AVG(total_sales) AS avg_customer_sales
    FROM customer_sales
)
SELECT
    cs.customer_id,
    cs.total_sales,
    a.avg_customer_sales
FROM customer_sales cs
CROSS JOIN average_sales a
ORDER BY cs.total_sales DESC;


-- 7. Customers above average sales

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(total_amount) AS total_sales
    FROM orders
    GROUP BY customer_id
),
average_sales AS (
    SELECT
        AVG(total_sales) AS avg_sales
    FROM customer_sales
)
SELECT
    cs.customer_id,
    cs.total_sales
FROM customer_sales cs
CROSS JOIN average_sales a
WHERE cs.total_sales > a.avg_sales
ORDER BY cs.total_sales DESC;


-- 8. Product sales analysis

WITH product_sales AS (
    SELECT
        oi.product_id,
        SUM(oi.quantity) AS total_quantity
    FROM order_items oi
    GROUP BY oi.product_id
)
SELECT
    p.product_id,
    p.product_name,
    ps.total_quantity
FROM products p
JOIN product_sales ps
    ON p.product_id = ps.product_id
ORDER BY ps.total_quantity DESC;


-- 9. Product Revenue Analysis

WITH product_revenue AS (
    SELECT
        oi.product_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY oi.product_id
)
SELECT
    p.product_id,
    p.product_name,
    pr.total_revenue
FROM products p
JOIN product_revenue pr
    ON p.product_id = pr.product_id
ORDER BY pr.total_revenue DESC;


-- 10. Top 5 customers

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(total_amount) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM customer_sales
ORDER BY total_sales DESC
LIMIT 5;


-- 11. CTE with Window Function
-- Rank customers according to total sales

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(total_amount) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_sales,
    RANK() OVER (
        ORDER BY total_sales DESC
    ) AS sales_rank
FROM customer_sales;


-- 12. Customer names with ranking

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(total_amount) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.customer_name,
    cs.total_sales,
    RANK() OVER (
        ORDER BY cs.total_sales DESC
    ) AS sales_rank
FROM customers c
JOIN customer_sales cs
    ON c.customer_id = cs.customer_id
ORDER BY sales_rank;


-- 13. Customer order statistics

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(total_amount) AS total_sales,
        AVG(total_amount) AS average_order_value
    FROM orders
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.customer_name,
    co.total_orders,
    co.total_sales,
    co.average_order_value
FROM customers c
JOIN customer_orders co
    ON c.customer_id = co.customer_id
ORDER BY co.total_sales DESC;


-- 14. High-performing customers

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(total_amount) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.customer_name,
    co.total_orders,
    co.total_sales
FROM customers c
JOIN customer_orders co
    ON c.customer_id = co.customer_id
WHERE co.total_sales > 1000
ORDER BY co.total_sales DESC;


-- 15. Business Summary using CTE

WITH sales_summary AS (
    SELECT
        COUNT(order_id) AS total_orders,
        SUM(total_amount) AS total_revenue,
        AVG(total_amount) AS average_order_value,
        MAX(total_amount) AS highest_order_value,
        MIN(total_amount) AS lowest_order_value
    FROM orders
)
SELECT *
FROM sales_summary;