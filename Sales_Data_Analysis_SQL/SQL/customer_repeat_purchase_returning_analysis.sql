USE sales_analysis_db;

-- Day 74: Customer Repeat Purchase and Returning Customer Analysis

-- Query 1: Customer Purchase Summary
SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(SUM(oi.quantity), 0) AS total_units_purchased,
    COALESCE(ROUND(SUM(oi.quantity * p.price), 2), 0) AS total_revenue,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date,
    CASE
        WHEN COUNT(DISTINCT o.order_id) > 1
            THEN 'Returning Customer'
        WHEN COUNT(DISTINCT o.order_id) = 1
            THEN 'First-Time Customer'
        ELSE 'No Orders'
    END AS customer_type
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id
ORDER BY total_revenue DESC;

-- Query 2: Returning Customer Rate
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
    COUNT(*) AS total_customers,
    SUM(CASE WHEN total_orders > 0 THEN 1 ELSE 0 END)
        AS customers_with_orders,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
        AS returning_customers,
    ROUND(
        100.0 * SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN total_orders > 0 THEN 1 ELSE 0 END), 0),
        2
    ) AS returning_customer_rate_pct
FROM customer_orders;

-- Query 3: Customer Purchase Frequency Groups
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
        WHEN total_orders = 0 THEN 'No Orders'
        WHEN total_orders = 1 THEN '1 Order'
        WHEN total_orders BETWEEN 2 AND 3 THEN '2-3 Orders'
        WHEN total_orders BETWEEN 4 AND 5 THEN '4-5 Orders'
        ELSE '6+ Orders'
    END AS purchase_frequency_group,
    COUNT(*) AS customer_count
FROM customer_orders
GROUP BY purchase_frequency_group
ORDER BY
    CASE purchase_frequency_group
        WHEN 'No Orders' THEN 1
        WHEN '1 Order' THEN 2
        WHEN '2-3 Orders' THEN 3
        WHEN '4-5 Orders' THEN 4
        ELSE 5
    END;
    
-- Query 4: Days Between Consecutive Purchases
WITH customer_purchase_dates AS (
    SELECT DISTINCT
        customer_id,
        order_id,
        order_date
    FROM orders
),
purchase_gaps AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS previous_order_date
    FROM customer_purchase_dates
)
SELECT
    customer_id,
    order_id,
    previous_order_date,
    order_date AS current_order_date,
    DATEDIFF(order_date, previous_order_date) AS days_between_orders
FROM purchase_gaps
WHERE previous_order_date IS NOT NULL
ORDER BY customer_id, current_order_date;

-- Query 5: Returning Customer Revenue Analysis
SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * p.price), 2) AS total_revenue,
    ROUND(
        SUM(oi.quantity * p.price) /
        NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_revenue_per_order,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date))
        AS customer_activity_days
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_revenue DESC;