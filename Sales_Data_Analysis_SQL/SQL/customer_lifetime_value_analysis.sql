USE sales_analysis_db;

-- ============================================================
-- DAY 36
-- CUSTOMER LIFETIME VALUE & REVENUE CONTRIBUTION ANALYSIS
-- ============================================================


-- ============================================================
-- 1. CUSTOMER LIFETIME REVENUE
-- ============================================================

SELECT
    o.customer_id,
    ROUND(SUM(oi.quantity * p.price), 2) AS lifetime_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY lifetime_revenue DESC;


-- ============================================================
-- 2. CUSTOMER TOTAL ORDERS
-- ============================================================

SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;


-- ============================================================
-- 3. CUSTOMER AVERAGE ORDER VALUE
-- ============================================================

SELECT
    o.customer_id,
    ROUND(
        SUM(oi.quantity * p.price) / COUNT(DISTINCT o.order_id),
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
-- 4. CUSTOMER LIFETIME DURATION
-- ============================================================

SELECT
    customer_id,
    MIN(order_date) AS first_purchase_date,
    MAX(order_date) AS last_purchase_date,
    DATEDIFF(
        MAX(order_date),
        MIN(order_date)
    ) AS customer_lifetime_days
FROM orders
GROUP BY customer_id
ORDER BY customer_lifetime_days DESC;


-- ============================================================
-- 5. CUSTOMER PURCHASE FREQUENCY
-- ============================================================

SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT order_id) /
        NULLIF(
            DATEDIFF(MAX(order_date), MIN(order_date)) / 30.0,
            0
        ),
        2
    ) AS orders_per_month
FROM orders
GROUP BY customer_id
ORDER BY orders_per_month DESC;


-- ============================================================
-- 6. CUSTOMER REVENUE RANKING
-- ============================================================

SELECT
    customer_id,
    ROUND(SUM(quantity * price), 2) AS lifetime_revenue,
    DENSE_RANK() OVER (
        ORDER BY SUM(quantity * price) DESC
    ) AS revenue_rank
FROM (
    SELECT
        o.customer_id,
        oi.quantity,
        p.price
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
) AS customer_sales
GROUP BY customer_id
ORDER BY revenue_rank;


-- ============================================================
-- 7. TOP 10 HIGHEST-VALUE CUSTOMERS
-- ============================================================

SELECT
    o.customer_id,
    ROUND(SUM(oi.quantity * p.price), 2) AS lifetime_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY lifetime_revenue DESC
LIMIT 10;


-- ============================================================
-- 8. CUSTOMER REVENUE CONTRIBUTION %
-- ============================================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * p.price) AS lifetime_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    ROUND(lifetime_revenue, 2) AS lifetime_revenue,
    ROUND(
        lifetime_revenue /
        SUM(lifetime_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_percentage
FROM customer_revenue
ORDER BY lifetime_revenue DESC;


-- ============================================================
-- 9. CUSTOMER VALUE CLASSIFICATION
-- ============================================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * p.price) AS lifetime_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    ROUND(lifetime_revenue, 2) AS lifetime_revenue,
    CASE
        WHEN lifetime_revenue >= 100000 THEN 'Platinum'
        WHEN lifetime_revenue >= 50000 THEN 'Gold'
        WHEN lifetime_revenue >= 20000 THEN 'Silver'
        ELSE 'Standard'
    END AS customer_value_segment
FROM customer_revenue
ORDER BY lifetime_revenue DESC;


-- ============================================================
-- 10. HIGH-VALUE CUSTOMER IDENTIFICATION
-- ============================================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * p.price) AS lifetime_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    ROUND(lifetime_revenue, 2) AS lifetime_revenue
FROM customer_revenue
WHERE lifetime_revenue >= (
    SELECT AVG(lifetime_revenue)
    FROM customer_revenue
)
ORDER BY lifetime_revenue DESC;


-- ============================================================
-- 11. REVENUE CONCENTRATION ANALYSIS
-- ============================================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * p.price) AS lifetime_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
),

ranked_customers AS (
    SELECT
        customer_id,
        lifetime_revenue,
        DENSE_RANK() OVER (
            ORDER BY lifetime_revenue DESC
        ) AS revenue_rank,
        SUM(lifetime_revenue) OVER () AS total_revenue,
        SUM(lifetime_revenue) OVER (
            ORDER BY lifetime_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue
    FROM customer_revenue
)

SELECT
    customer_id,
    revenue_rank,
    ROUND(lifetime_revenue, 2) AS lifetime_revenue,
    ROUND(
        lifetime_revenue / total_revenue * 100,
        2
    ) AS revenue_percentage,
    ROUND(
        cumulative_revenue / total_revenue * 100,
        2
    ) AS cumulative_revenue_percentage
FROM ranked_customers
ORDER BY revenue_rank;


-- ============================================================
-- 12. FINAL CUSTOMER LIFETIME VALUE BUSINESS SUMMARY
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MIN(o.order_date) AS first_purchase_date,
        MAX(o.order_date) AS last_purchase_date,
        DATEDIFF(
            MAX(o.order_date),
            MIN(o.order_date)
        ) AS lifetime_days,
        SUM(oi.quantity * p.price) AS lifetime_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    total_orders,
    first_purchase_date,
    last_purchase_date,
    lifetime_days,
    ROUND(lifetime_revenue, 2) AS lifetime_revenue,
    ROUND(
        lifetime_revenue / NULLIF(total_orders, 0),
        2
    ) AS average_order_value,
    CASE
        WHEN lifetime_revenue >= 100000 THEN 'Platinum'
        WHEN lifetime_revenue >= 50000 THEN 'Gold'
        WHEN lifetime_revenue >= 20000 THEN 'Silver'
        ELSE 'Standard'
    END AS customer_value_segment
FROM customer_metrics
ORDER BY lifetime_revenue DESC;