USE sales_analysis_db;

-- Day 75: Customer Purchase Recency and Inactivity Analysis

-- Query 1: Customer Purchase Recency
SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    MAX(o.order_date) AS last_purchase_date,
    DATEDIFF(
        CURRENT_DATE,
        MAX(o.order_date)
    ) AS days_since_last_purchase,
    CASE
        WHEN COUNT(DISTINCT o.order_id) = 0
            THEN 'Never Purchased'
        WHEN DATEDIFF(CURRENT_DATE, MAX(o.order_date)) <= 30
            THEN 'Recently Active'
        WHEN DATEDIFF(CURRENT_DATE, MAX(o.order_date)) <= 60
            THEN 'Moderately Inactive'
        WHEN DATEDIFF(CURRENT_DATE, MAX(o.order_date)) <= 90
            THEN 'At Risk'
        ELSE 'Inactive'
    END AS recency_segment
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY days_since_last_purchase ASC;

-- Query 2: Customer Inactivity Summary
WITH customer_recency AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        DATEDIFF(
            CURRENT_DATE,
            MAX(o.order_date)
        ) AS days_since_last_purchase
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
),
customer_segments AS (
    SELECT
        customer_id,
        CASE
            WHEN total_orders = 0 THEN 'Never Purchased'
            WHEN days_since_last_purchase <= 30 THEN 'Recently Active'
            WHEN days_since_last_purchase <= 60 THEN 'Moderately Inactive'
            WHEN days_since_last_purchase <= 90 THEN 'At Risk'
            ELSE 'Inactive'
        END AS recency_segment
    FROM customer_recency
)
SELECT
    recency_segment,
    COUNT(*) AS customer_count,
    ROUND(
        100.0 * COUNT(*) / NULLIF((SELECT COUNT(*) FROM customers), 0),
        2
    ) AS percentage_of_all_customers
FROM customer_segments
GROUP BY recency_segment
ORDER BY CASE recency_segment
    WHEN 'Recently Active' THEN 1
    WHEN 'Moderately Inactive' THEN 2
    WHEN 'At Risk' THEN 3
    WHEN 'Inactive' THEN 4
    ELSE 5
END;

-- Query 3: Customers At Risk of Inactivity
SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    MAX(o.order_date) AS last_purchase_date,
    DATEDIFF(
        CURRENT_DATE,
        MAX(o.order_date)
    ) AS days_since_last_purchase
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING DATEDIFF(CURRENT_DATE, MAX(o.order_date))
       BETWEEN 61 AND 90
ORDER BY days_since_last_purchase DESC;

-- Query 4: Historical Revenue from Inactive Customers
SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    MAX(o.order_date) AS last_purchase_date,
    DATEDIFF(
        CURRENT_DATE,
        MAX(o.order_date)
    ) AS days_since_last_purchase,
    ROUND(
        COALESCE(SUM(oi.quantity * p.price), 0),
        2
    ) AS historical_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id
HAVING DATEDIFF(CURRENT_DATE, MAX(o.order_date)) > 90
ORDER BY historical_revenue DESC;

-- Query 5: Customer Re-engagement Priority
WITH customer_summary AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MAX(o.order_date) AS last_purchase_date,
        DATEDIFF(
            CURRENT_DATE,
            MAX(o.order_date)
        ) AS days_since_last_purchase,
        COALESCE(
            SUM(oi.quantity * p.price),
            0
        ) AS historical_revenue
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    LEFT JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY c.customer_id
)
SELECT
    customer_id,
    total_orders,
    last_purchase_date,
    days_since_last_purchase,
    ROUND(historical_revenue, 2) AS historical_revenue,
    CASE
        WHEN total_orders = 0
            THEN 'No Purchase History'
        WHEN days_since_last_purchase > 90
             AND historical_revenue > 0
            THEN 'High Priority'
        WHEN days_since_last_purchase BETWEEN 61 AND 90
            THEN 'Medium Priority'
        WHEN days_since_last_purchase BETWEEN 31 AND 60
            THEN 'Low Priority'
        ELSE 'No Immediate Action'
    END AS reengagement_priority
FROM customer_summary
ORDER BY
    CASE
        WHEN total_orders > 0
             AND days_since_last_purchase > 90
             AND historical_revenue > 0 THEN 1
        WHEN total_orders > 0
             AND days_since_last_purchase BETWEEN 61 AND 90 THEN 2
        WHEN total_orders > 0
             AND days_since_last_purchase BETWEEN 31 AND 60 THEN 3
        ELSE 4
    END,
    historical_revenue DESC;