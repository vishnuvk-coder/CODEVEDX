
-- ============================================================
-- Day 78: Customer Purchase Recency and Repeat Purchase Analysis
-- Database: sales_analysis_db
-- ============================================================

USE sales_analysis_db;

-- ------------------------------------------------------------
-- Analysis 1: Customer Purchase Summary
-- Total orders, first purchase, and most recent purchase
-- ------------------------------------------------------------

SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    MIN(o.order_date) AS first_purchase_date,
    MAX(o.order_date) AS last_purchase_date
FROM orders o
GROUP BY o.customer_id
ORDER BY total_orders DESC;


-- ------------------------------------------------------------
-- Analysis 2: Days Since Last Purchase
-- ------------------------------------------------------------

SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    MAX(o.order_date) AS last_purchase_date,
    DATEDIFF(CURRENT_DATE(), MAX(o.order_date))
        AS days_since_last_purchase
FROM orders o
GROUP BY o.customer_id
ORDER BY days_since_last_purchase DESC;


-- ------------------------------------------------------------
-- Analysis 3: Repeat Purchase Classification
-- Repeat customers have placed more than one order
-- ------------------------------------------------------------

SELECT
    customer_id,
    total_orders,
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        WHEN total_orders > 1 THEN 'Repeat Customer'
        ELSE 'No Orders'
    END AS purchase_type
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
) AS customer_orders
ORDER BY total_orders DESC;


-- ------------------------------------------------------------
-- Analysis 4: Customer Activity Classification
-- Thresholds are illustrative business rules
-- ------------------------------------------------------------

SELECT
    customer_id,
    total_orders,
    last_purchase_date,
    days_since_last_purchase,
    CASE
        WHEN days_since_last_purchase <= 30
            THEN 'Recently Active'
        WHEN days_since_last_purchase <= 60
            THEN 'Needs Attention'
        WHEN days_since_last_purchase <= 90
            THEN 'At Risk'
        ELSE 'Inactive'
    END AS customer_activity_status
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        MAX(order_date) AS last_purchase_date,
        DATEDIFF(CURRENT_DATE(), MAX(order_date))
            AS days_since_last_purchase
    FROM orders
    GROUP BY customer_id
) AS customer_activity
ORDER BY days_since_last_purchase DESC;


-- ------------------------------------------------------------
-- Analysis 5: Overall Repeat Purchase Summary
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS customers_with_orders,
    SUM(CASE WHEN total_orders = 1 THEN 1 ELSE 0 END)
        AS one_time_customers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
        AS repeat_customers,
    ROUND(
        100.0 * SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
) AS customer_summary;
