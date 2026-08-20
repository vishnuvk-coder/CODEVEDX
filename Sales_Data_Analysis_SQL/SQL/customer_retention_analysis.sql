USE sales_analysis_db;

-- ============================================================
-- DAY 20
-- CUSTOMER RETENTION & REPEAT PURCHASE ANALYSIS
-- ============================================================


-- ============================================================
-- 1. CUSTOMER ORDER FREQUENCY
-- ============================================================

SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;


-- ============================================================
-- 2. CUSTOMER CLASSIFICATION
-- One-Time Customer vs Repeat Customer
-- ============================================================

SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders,
    CASE
        WHEN COUNT(DISTINCT order_id) = 1
            THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;


-- ============================================================
-- 3. CUSTOMER TYPE SUMMARY
-- ============================================================

SELECT
    customer_type,
    COUNT(*) AS total_customers
FROM
(
    SELECT
        customer_id,
        CASE
            WHEN COUNT(DISTINCT order_id) = 1
                THEN 'One-Time Customer'
            ELSE 'Repeat Customer'
        END AS customer_type
    FROM orders
    GROUP BY customer_id
) AS customer_summary
GROUP BY customer_type
ORDER BY total_customers DESC;


-- ============================================================
-- 4. REPEAT CUSTOMER RATE
-- ============================================================

SELECT
    ROUND(
        100.0 * SUM(
            CASE
                WHEN total_orders > 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS repeat_customer_rate
FROM
(
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
) AS customer_orders;


-- ============================================================
-- 5. CUSTOMER REVENUE ANALYSIS
-- Revenue = Quantity × Product Price
-- ============================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY total_revenue DESC;


-- ============================================================
-- 6. HIGH-VALUE REPEAT CUSTOMERS
-- ============================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.customer_id
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_revenue DESC;


-- ============================================================
-- 7. CUSTOMER AVERAGE ORDER VALUE
-- ============================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        SUM(oi.quantity * p.price) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY average_order_value DESC;


-- ============================================================
-- 8. TOP CUSTOMERS BY REVENUE
-- ============================================================

SELECT
    o.customer_id,
    SUM(oi.quantity * p.price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 9. TOP CUSTOMERS BY ORDER FREQUENCY
-- ============================================================

SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 10;


-- ============================================================
-- 10. REPEAT CUSTOMERS WITH REVENUE
-- ============================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue,
    CASE
        WHEN COUNT(DISTINCT o.order_id) >= 3
            THEN 'Highly Engaged'
        WHEN COUNT(DISTINCT o.order_id) > 1
            THEN 'Repeat Customer'
        ELSE 'One-Time Customer'
    END AS customer_segment
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY total_revenue DESC;


-- ============================================================
-- 11. CUSTOMER REVENUE CONTRIBUTION
-- ============================================================

WITH customer_revenue AS
(
    SELECT
        o.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
)
SELECT
    customer_id,
    total_revenue,
    ROUND(
        100.0 * total_revenue /
        SUM(total_revenue) OVER (),
        2
    ) AS revenue_contribution_percentage
FROM customer_revenue
ORDER BY total_revenue DESC;


-- ============================================================
-- 12. FINAL CUSTOMER RETENTION SUMMARY
-- ============================================================

SELECT
    COUNT(*) AS total_customers,
    SUM(
        CASE
            WHEN total_orders = 1 THEN 1
            ELSE 0
        END
    ) AS one_time_customers,
    SUM(
        CASE
            WHEN total_orders > 1 THEN 1
            ELSE 0
        END
    ) AS repeat_customers,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN total_orders > 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS repeat_customer_rate
FROM
(
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
) AS customer_summary;