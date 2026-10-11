-- ============================================================
-- Day 71: Customer Purchase Trends and Repeat Purchase Analysis
-- Database: sales_analysis_db
-- MySQL Version: 8.0+
-- ============================================================

USE sales_analysis_db;

-- ============================================================
-- QUERY 1: Customer Purchase Summary
-- Orders, units purchased, and revenue per customer
-- ============================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(SUM(oi.quantity), 0) AS total_units,
    ROUND(
        COALESCE(SUM(oi.quantity * p.price), 0),
        2
    ) AS total_revenue,
    ROUND(
        COALESCE(SUM(oi.quantity * p.price), 0)
        / NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_order_value
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 2: One-Time vs Repeat Customers
-- A repeat customer has placed more than one order overall.
-- ============================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percentage
FROM customer_orders
GROUP BY
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END
ORDER BY customer_count DESC;


-- ============================================================
-- QUERY 3: Repeat Purchase Rate
-- Percentage of customers with more than one order.
-- ============================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS customers_with_orders,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
        AS repeat_customers,
    SUM(CASE WHEN total_orders = 1 THEN 1 ELSE 0 END)
        AS one_time_customers,
    ROUND(
        100.0 * SUM(
            CASE WHEN total_orders > 1 THEN 1 ELSE 0 END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_purchase_rate_pct
FROM customer_orders;


-- ============================================================
-- QUERY 4: Purchase Frequency Segmentation
-- ============================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN total_orders = 1 THEN '1 Order'
        WHEN total_orders BETWEEN 2 AND 3 THEN '2-3 Orders'
        WHEN total_orders BETWEEN 4 AND 5 THEN '4-5 Orders'
        ELSE '6+ Orders'
    END AS purchase_frequency_group,
    COUNT(*) AS customer_count
FROM customer_orders
GROUP BY
    CASE
        WHEN total_orders = 1 THEN '1 Order'
        WHEN total_orders BETWEEN 2 AND 3 THEN '2-3 Orders'
        WHEN total_orders BETWEEN 4 AND 5 THEN '4-5 Orders'
        ELSE '6+ Orders'
    END
ORDER BY MIN(total_orders);


-- ============================================================
-- QUERY 5: Days Between Consecutive Orders
-- LAG() compares each order date with the previous order date.
-- ============================================================

WITH distinct_orders AS (
    SELECT DISTINCT
        customer_id,
        order_id,
        order_date
    FROM orders
),
order_intervals AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS previous_order_date
    FROM distinct_orders
)
SELECT
    customer_id,
    order_id,
    previous_order_date,
    order_date AS current_order_date,
    DATEDIFF(order_date, previous_order_date)
        AS days_since_previous_order
FROM order_intervals
WHERE previous_order_date IS NOT NULL
ORDER BY customer_id, order_date, order_id;


-- ============================================================
-- QUERY 6: Average Purchase Interval per Customer
-- Customers with fewer than two dated orders are excluded.
-- ============================================================

WITH distinct_orders AS (
    SELECT DISTINCT
        customer_id,
        order_id,
        order_date
    FROM orders
),
order_intervals AS (
    SELECT
        customer_id,
        DATEDIFF(
            order_date,
            LAG(order_date) OVER (
                PARTITION BY customer_id
                ORDER BY order_date, order_id
            )
        ) AS days_between_orders
    FROM distinct_orders
)
SELECT
    customer_id,
    COUNT(days_between_orders) AS repeat_intervals,
    ROUND(AVG(days_between_orders), 2)
        AS average_days_between_orders,
    MIN(days_between_orders) AS shortest_interval_days,
    MAX(days_between_orders) AS longest_interval_days
FROM order_intervals
WHERE days_between_orders IS NOT NULL
GROUP BY customer_id
ORDER BY average_days_between_orders ASC;


-- ============================================================
-- QUERY 7: Monthly Repeat Customer Trends
-- A repeat customer in a month has placed 2+ orders that month.
-- ============================================================

WITH monthly_customer_orders AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS order_month,
        customer_id,
        COUNT(DISTINCT order_id) AS monthly_orders
    FROM orders
    WHERE order_date IS NOT NULL
    GROUP BY
        DATE_FORMAT(order_date, '%Y-%m'),
        customer_id
)
SELECT
    order_month,
    COUNT(*) AS active_customers,
    SUM(
        CASE WHEN monthly_orders > 1 THEN 1 ELSE 0 END
    ) AS customers_with_multiple_monthly_orders,
    ROUND(
        100.0 * SUM(
            CASE WHEN monthly_orders > 1 THEN 1 ELSE 0 END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS monthly_repeat_customer_rate_pct
FROM monthly_customer_orders
GROUP BY order_month
ORDER BY order_month;


-- ============================================================
-- QUERY 8: Customer Revenue Ranking
-- ============================================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(
            COALESCE(SUM(oi.quantity * p.price), 0),
            2
        ) AS total_revenue
    FROM orders o
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    LEFT JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
)
SELECT
    customer_id,
    total_orders,
    total_revenue,
    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM customer_revenue
ORDER BY revenue_rank, customer_id;


-- ============================================================
-- END OF DAY 71 ANALYSIS
-- ============================================================