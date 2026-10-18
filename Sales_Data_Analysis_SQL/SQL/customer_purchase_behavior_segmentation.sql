
-- ============================================================
-- DAY 79: Customer Purchase Behavior and Segmentation Analysis
-- Database: sales_analysis_db
-- Tool: MySQL Workbench
-- ============================================================

USE sales_analysis_db;

-- ============================================================
-- ANALYSIS 1: Customer Purchase Behavior Summary
-- ============================================================

SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    MIN(o.order_date) AS first_purchase_date,
    MAX(o.order_date) AS last_purchase_date,
    DATEDIFF(CURRENT_DATE(), MAX(o.order_date))
        AS days_since_last_purchase,
    ROUND(COALESCE(SUM(oi.quantity * p.price), 0), 2)
        AS total_spending,
    ROUND(
        COALESCE(SUM(oi.quantity * p.price), 0)
        / NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_order_value,
    CASE
        WHEN COUNT(DISTINCT o.order_id) = 0
            THEN 'No Purchase'
        WHEN COUNT(DISTINCT o.order_id) = 1
            THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS purchase_behavior
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id
ORDER BY total_spending DESC;


-- ============================================================
-- ANALYSIS 2: Segment Customers by Spending
-- Uses NTILE(3) to create three roughly equal-sized groups
-- among customers who have placed at least one order.
-- ============================================================

WITH customer_spending AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(oi.quantity * p.price), 2) AS total_spending
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    INNER JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY c.customer_id
),
ranked_customers AS (
    SELECT
        customer_id,
        total_orders,
        total_spending,
        NTILE(3) OVER (
            ORDER BY total_spending DESC, customer_id
        ) AS spending_group
    FROM customer_spending
)
SELECT
    customer_id,
    total_orders,
    total_spending,
    CASE spending_group
        WHEN 1 THEN 'High-Value'
        WHEN 2 THEN 'Regular'
        WHEN 3 THEN 'Low-Value'
    END AS customer_segment
FROM ranked_customers
ORDER BY spending_group, total_spending DESC;


-- ============================================================
-- ANALYSIS 3: Revenue Contribution by Customer Segment
-- ============================================================

WITH customer_spending AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity * p.price) AS total_spending
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    INNER JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY c.customer_id
),
ranked_customers AS (
    SELECT
        customer_id,
        total_orders,
        total_spending,
        NTILE(3) OVER (
            ORDER BY total_spending DESC, customer_id
        ) AS spending_group
    FROM customer_spending
),
segmented_customers AS (
    SELECT
        customer_id,
        total_orders,
        total_spending,
        CASE spending_group
            WHEN 1 THEN 'High-Value'
            WHEN 2 THEN 'Regular'
            WHEN 3 THEN 'Low-Value'
        END AS customer_segment
    FROM ranked_customers
)
SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    SUM(total_orders) AS total_orders,
    ROUND(SUM(total_spending), 2) AS segment_revenue,
    ROUND(
        100.0 * SUM(total_spending)
        / NULLIF(SUM(SUM(total_spending)) OVER (), 0),
        2
    ) AS revenue_contribution_pct,
    ROUND(AVG(total_spending), 2) AS average_customer_spending
FROM segmented_customers
GROUP BY customer_segment
ORDER BY segment_revenue DESC;


-- ============================================================
-- ANALYSIS 4: Repeat Customer and One-Time Customer Summary
-- Includes customers with no purchases.
-- ============================================================

WITH customer_orders AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
)
SELECT
    CASE
        WHEN total_orders = 0 THEN 'No Purchase'
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS purchase_behavior,
    COUNT(*) AS customer_count,
    ROUND(
        100.0 * COUNT(*)
        / NULLIF(SUM(COUNT(*)) OVER (), 0),
        2
    ) AS customer_percentage
FROM customer_orders
GROUP BY
    CASE
        WHEN total_orders = 0 THEN 'No Purchase'
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END
ORDER BY customer_count DESC;
