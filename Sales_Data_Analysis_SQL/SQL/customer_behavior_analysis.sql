USE sales_analysis_db;

-- ============================================================
-- DAY 19: CUSTOMER BEHAVIOR & REVENUE ANALYTICS
-- Project: Sales Data Analysis using SQL
-- ============================================================


-- ============================================================
-- 1. CHECK TABLE STRUCTURES
-- ============================================================

DESCRIBE customers;
DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE products;


-- ============================================================
-- 2. CUSTOMER REVENUE ANALYSIS
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
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
    c.customer_id,
    c.customer_name
ORDER BY total_revenue DESC;


-- ============================================================
-- 3. CUSTOMER ORDER FREQUENCY
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
-- 4. AVERAGE ORDER VALUE BY CUSTOMER
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue,
    ROUND(
        SUM(oi.quantity * p.price)
        / COUNT(DISTINCT o.order_id),
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
-- 5. CUSTOMER SEGMENTATION
-- ============================================================

SELECT
    customer_id,
    customer_name,
    total_orders,
    CASE
        WHEN total_orders = 1
            THEN 'One-Time Customer'
        WHEN total_orders >= 2
            THEN 'Repeat Customer'
    END AS customer_type
FROM
(
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
) AS customer_orders
ORDER BY total_orders DESC;


-- ============================================================
-- 6. HIGH-VALUE CUSTOMER ANALYSIS
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * p.price) AS total_revenue
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
HAVING SUM(oi.quantity * p.price) >
(
    SELECT AVG(customer_revenue)
    FROM
    (
        SELECT
            SUM(oi2.quantity * p2.price) AS customer_revenue
        FROM orders o2
        JOIN order_items oi2
            ON o2.order_id = oi2.order_id
        JOIN products p2
            ON oi2.product_id = p2.product_id
        GROUP BY o2.customer_id
    ) AS revenue_summary
)
ORDER BY total_revenue DESC;


-- ============================================================
-- 7. CUSTOMER REVENUE RANKING
-- ============================================================

SELECT
    customer_id,
    customer_name,
    total_revenue,
    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM
(
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_revenue
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
) AS customer_revenue
ORDER BY revenue_rank;


-- ============================================================
-- 8. REVENUE CONTRIBUTION BY CUSTOMER
-- ============================================================

WITH customer_revenue AS
(
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_revenue
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
    total_revenue,
    ROUND(
        total_revenue * 100.0
        / SUM(total_revenue) OVER (),
        2
    ) AS revenue_contribution_percent
FROM customer_revenue
ORDER BY total_revenue DESC;


-- ============================================================
-- 9. TOP 5 CUSTOMERS BY REVENUE
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * p.price) AS total_revenue
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
ORDER BY total_revenue DESC
LIMIT 5;


-- ============================================================
-- 10. CUSTOMER BUSINESS SUMMARY
-- ============================================================

SELECT
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue,
    ROUND(
        SUM(oi.quantity * p.price)
        / COUNT(DISTINCT o.order_id),
        2
    ) AS overall_average_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id;


-- ============================================================
-- 11. REPEAT CUSTOMER SUMMARY
-- ============================================================

SELECT
    customer_type,
    COUNT(*) AS number_of_customers
FROM
(
    SELECT
        c.customer_id,
        CASE
            WHEN COUNT(DISTINCT o.order_id) = 1
                THEN 'One-Time Customer'
            ELSE 'Repeat Customer'
        END AS customer_type
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
) AS customer_segments
GROUP BY customer_type;


-- ============================================================
-- 12. FINAL CUSTOMER PERFORMANCE REPORT
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS total_items_purchased,
    SUM(oi.quantity * p.price) AS total_revenue,
    ROUND(
        SUM(oi.quantity * p.price)
        / COUNT(DISTINCT o.order_id),
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
ORDER BY total_revenue DESC;