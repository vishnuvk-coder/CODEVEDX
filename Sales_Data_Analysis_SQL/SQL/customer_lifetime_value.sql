USE sales_analysis_db;


-- ============================================================
-- DAY 21: CUSTOMER LIFETIME VALUE & RETENTION ANALYSIS
-- ============================================================


-- ============================================================
-- 1. CUSTOMER LIFETIME VALUE
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS lifetime_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY lifetime_value DESC;


-- ============================================================
-- 2. CUSTOMER ORDER FREQUENCY
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_orders DESC;


-- ============================================================
-- 3. AVERAGE ORDER VALUE BY CUSTOMER
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
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
    c.customer_id,
    c.customer_name
ORDER BY average_order_value DESC;


-- ============================================================
-- 4. TOP 5 CUSTOMERS BY LIFETIME VALUE
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * p.price) AS lifetime_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY lifetime_value DESC
LIMIT 5;


-- ============================================================
-- 5. CUSTOMERS WITH MORE THAN ONE ORDER
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_orders DESC;


-- ============================================================
-- 6. CUSTOMERS WITH ONLY ONE ORDER
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(DISTINCT o.order_id) = 1
ORDER BY c.customer_id;


-- ============================================================
-- 7. CUSTOMER REVENUE RANKING
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * p.price) AS lifetime_value,
    DENSE_RANK() OVER (
        ORDER BY SUM(oi.quantity * p.price) DESC
    ) AS customer_rank
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY customer_rank;


-- ============================================================
-- 8. CUSTOMER REVENUE CONTRIBUTION
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,
    revenue,
    ROUND(
        revenue / SUM(revenue) OVER () * 100,
        2
    ) AS revenue_contribution_percentage
FROM customer_revenue
ORDER BY revenue DESC;


-- ============================================================
-- 9. CUSTOMER VALUE SEGMENTATION
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS lifetime_value
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,
    lifetime_value,
    CASE
        WHEN lifetime_value >= 50000 THEN 'High Value'
        WHEN lifetime_value >= 20000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_revenue
ORDER BY lifetime_value DESC;


-- ============================================================
-- 10. CUSTOMER RETENTION CATEGORY
-- ============================================================

WITH customer_orders AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,
    total_orders,
    CASE
        WHEN total_orders >= 3 THEN 'Loyal Customer'
        WHEN total_orders = 2 THEN 'Returning Customer'
        ELSE 'One-Time Customer'
    END AS retention_category
FROM customer_orders
ORDER BY total_orders DESC;


-- ============================================================
-- 11. COMPLETE CUSTOMER PERFORMANCE REPORT
-- ============================================================

WITH customer_metrics AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity * p.price) AS lifetime_value
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,
    total_orders,
    lifetime_value,
    ROUND(
        lifetime_value / total_orders,
        2
    ) AS average_order_value,

    CASE
        WHEN lifetime_value >= 50000 THEN 'High Value'
        WHEN lifetime_value >= 20000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS value_segment,

    CASE
        WHEN total_orders >= 3 THEN 'Loyal Customer'
        WHEN total_orders = 2 THEN 'Returning Customer'
        ELSE 'One-Time Customer'
    END AS retention_category

FROM customer_metrics
ORDER BY lifetime_value DESC;