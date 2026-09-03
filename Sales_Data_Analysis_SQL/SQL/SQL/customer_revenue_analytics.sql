-- ============================================================
-- DAY 18: CUSTOMER & REVENUE ANALYTICS
-- Project: Sales Data Analysis using SQL
-- Database: sales_analysis_db
-- Author: Vishnu Kumar
-- ============================================================

USE sales_analysis_db;


-- ============================================================
-- 1. CUSTOMER REVENUE ANALYSIS
-- ============================================================

SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    c.customer_id
ORDER BY total_revenue DESC;


-- ============================================================
-- 2. CUSTOMER AVERAGE ORDER VALUE
-- ============================================================

SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        SUM(oi.quantity * p.price) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    c.customer_id
ORDER BY average_order_value DESC;


-- ============================================================
-- 3. REPEAT CUSTOMER ANALYSIS
-- ============================================================

SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_orders DESC;


-- ============================================================
-- 4. TOP 5 CUSTOMERS BY REVENUE
-- ============================================================

SELECT
    c.customer_id,
    SUM(oi.quantity * p.price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    c.customer_id
ORDER BY total_revenue DESC
LIMIT 5;


-- ============================================================
-- 5. CUSTOMER REVENUE RANKING
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id
)

SELECT
    customer_id,
    total_revenue,
    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM customer_revenue
ORDER BY revenue_rank;


-- ============================================================
-- 6. CUSTOMER REVENUE CONTRIBUTION %
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id
)

SELECT
    customer_id,
    total_revenue,
    ROUND(
        total_revenue /
        SUM(total_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_percentage
FROM customer_revenue
ORDER BY revenue_contribution_percentage DESC;


-- ============================================================
-- 7. CUSTOMER SEGMENTATION
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id
)

SELECT
    customer_id,
    total_revenue,
    CASE
        WHEN total_revenue >= 10000 THEN 'High Value'
        WHEN total_revenue >= 5000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_revenue
ORDER BY total_revenue DESC;


-- ============================================================
-- 8. CUSTOMER PURCHASE FREQUENCY
-- ============================================================

SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS latest_order_date
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id
ORDER BY total_orders DESC;


-- ============================================================
-- 9. CUSTOMER TOTAL QUANTITY PURCHASED
-- ============================================================

SELECT
    c.customer_id,
    SUM(oi.quantity) AS total_quantity_purchased
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id
ORDER BY total_quantity_purchased DESC;


-- ============================================================
-- 10. CUSTOMER SALES SUMMARY
-- ============================================================

SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS total_items,
    SUM(oi.quantity * p.price) AS total_revenue,
    ROUND(
        SUM(oi.quantity * p.price) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    c.customer_id
ORDER BY total_revenue DESC;


-- ============================================================
-- 11. HIGH-VALUE CUSTOMER ANALYSIS
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id
)

SELECT
    customer_id,
    total_revenue
FROM customer_revenue
WHERE total_revenue >= 10000
ORDER BY total_revenue DESC;


-- ============================================================
-- 12. CUSTOMER RANK WITH TOTAL ORDERS
-- ============================================================

WITH customer_summary AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id
)

SELECT
    customer_id,
    total_orders,
    total_revenue,
    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank,
    DENSE_RANK() OVER (
        ORDER BY total_orders DESC
    ) AS order_rank
FROM customer_summary
ORDER BY revenue_rank;


-- ============================================================
-- 13. FINAL CUSTOMER PERFORMANCE REPORT
-- ============================================================

WITH customer_summary AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_items,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id
)

SELECT
    customer_id,
    total_orders,
    total_items,
    total_revenue,
    ROUND(
        total_revenue / total_orders,
        2
    ) AS average_order_value,
    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank,
    ROUND(
        total_revenue /
        SUM(total_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_percentage,
    CASE
        WHEN total_revenue >= 10000 THEN 'High Value'
        WHEN total_revenue >= 5000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_summary
ORDER BY total_revenue DESC;


-- ============================================================
-- END OF DAY 18
-- ============================================================