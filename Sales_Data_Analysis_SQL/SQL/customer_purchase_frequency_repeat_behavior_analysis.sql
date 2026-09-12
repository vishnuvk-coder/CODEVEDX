USE sales_analysis_db;


-- ============================================================
-- DAY 42
-- CUSTOMER PURCHASE FREQUENCY & REPEAT BEHAVIOR ANALYSIS
-- ============================================================


-- ============================================================
-- QUERY 01: Customer Purchase Frequency
-- ============================================================

WITH customer_frequency AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders o
    GROUP BY o.customer_id
)
SELECT
    customer_id,
    total_orders
FROM customer_frequency
ORDER BY total_orders DESC;


-- ============================================================
-- QUERY 02: Orders per Month per Customer
-- ============================================================

SELECT
    o.customer_id,
    DATE_FORMAT(o.order_date, '%Y-%m') AS purchase_month,
    COUNT(DISTINCT o.order_id) AS monthly_orders
FROM orders o
GROUP BY
    o.customer_id,
    DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY
    o.customer_id,
    purchase_month;



-- ============================================================
-- QUERY 03: Average Days Between Purchases
-- ============================================================

WITH purchase_intervals AS (
    SELECT
        o.customer_id,
        o.order_id,
        o.order_date,
        LAG(o.order_date) OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date
        ) AS previous_order_date
    FROM orders o
)
SELECT
    customer_id,
    ROUND(
        AVG(
            CASE
                WHEN previous_order_date IS NOT NULL
                THEN DATEDIFF(order_date, previous_order_date)
            END
        ),
        2
    ) AS average_days_between_purchases
FROM purchase_intervals
GROUP BY customer_id
ORDER BY average_days_between_purchases ASC;


-- ============================================================
-- QUERY 04: Repeat Purchase Rate
-- ============================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS total_customers,
    SUM(
        CASE
            WHEN total_orders > 1 THEN 1
            ELSE 0
        END
    ) AS repeat_customers,
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN total_orders > 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS repeat_customer_rate_percentage
FROM customer_orders;


-- ============================================================
-- QUERY 05: Purchase Interval Distribution
-- ============================================================

WITH purchase_intervals AS (
    SELECT
        o.customer_id,
        o.order_id,
        o.order_date,
        LAG(o.order_date) OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date
        ) AS previous_order_date
    FROM orders o
),
intervals AS (
    SELECT
        customer_id,
        DATEDIFF(order_date, previous_order_date) AS days_between_purchases
    FROM purchase_intervals
    WHERE previous_order_date IS NOT NULL
)
SELECT
    CASE
        WHEN days_between_purchases <= 7 THEN '0-7 Days'
        WHEN days_between_purchases <= 30 THEN '8-30 Days'
        WHEN days_between_purchases <= 60 THEN '31-60 Days'
        WHEN days_between_purchases <= 90 THEN '61-90 Days'
        ELSE '90+ Days'
    END AS purchase_interval,
    COUNT(*) AS purchase_count
FROM intervals
GROUP BY
    CASE
        WHEN days_between_purchases <= 7 THEN '0-7 Days'
        WHEN days_between_purchases <= 30 THEN '8-30 Days'
        WHEN days_between_purchases <= 60 THEN '31-60 Days'
        WHEN days_between_purchases <= 90 THEN '61-90 Days'
        ELSE '90+ Days'
    END
ORDER BY
    CASE
        WHEN purchase_interval = '0-7 Days' THEN 1
        WHEN purchase_interval = '8-30 Days' THEN 2
        WHEN purchase_interval = '31-60 Days' THEN 3
        WHEN purchase_interval = '61-90 Days' THEN 4
        ELSE 5
    END;


-- ============================================================
-- QUERY 06: High-Frequency Customers
-- ============================================================

WITH customer_frequency AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_orders
FROM customer_frequency
WHERE total_orders >= 7
ORDER BY total_orders DESC;


-- ============================================================
-- QUERY 07: Low-Frequency Customers
-- ============================================================

WITH customer_frequency AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_orders
FROM customer_frequency
WHERE total_orders <= 2
ORDER BY total_orders ASC;


-- ============================================================
-- QUERY 08: Customer Purchase Frequency Classification
-- ============================================================

WITH customer_frequency AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_orders,
    CASE
        WHEN total_orders = 1 THEN 'One-Time'
        WHEN total_orders BETWEEN 2 AND 3 THEN 'Occasional'
        WHEN total_orders BETWEEN 4 AND 6 THEN 'Regular'
        ELSE 'Frequent'
    END AS purchase_frequency_category
FROM customer_frequency
ORDER BY total_orders DESC;


-- ============================================================
-- QUERY 09: Frequency Category Distribution
-- ============================================================

WITH customer_frequency AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
),
frequency_categories AS (
    SELECT
        customer_id,
        total_orders,
        CASE
            WHEN total_orders = 1 THEN 'One-Time'
            WHEN total_orders BETWEEN 2 AND 3 THEN 'Occasional'
            WHEN total_orders BETWEEN 4 AND 6 THEN 'Regular'
            ELSE 'Frequent'
        END AS purchase_frequency_category
    FROM customer_frequency
)
SELECT
    purchase_frequency_category,
    COUNT(*) AS customer_count,
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*) FROM frequency_categories),
        2
    ) AS customer_percentage
FROM frequency_categories
GROUP BY purchase_frequency_category
ORDER BY customer_count DESC;


-- ============================================================
-- QUERY 10: Purchase Frequency vs Revenue
-- ============================================================

WITH customer_frequency AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
),
customer_revenue AS (
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
    CASE
        WHEN cf.total_orders = 1 THEN 'One-Time'
        WHEN cf.total_orders BETWEEN 2 AND 3 THEN 'Occasional'
        WHEN cf.total_orders BETWEEN 4 AND 6 THEN 'Regular'
        ELSE 'Frequent'
    END AS purchase_frequency_category,
    COUNT(*) AS customer_count,
    SUM(cr.total_revenue) AS total_revenue,
    ROUND(AVG(cr.total_revenue), 2) AS average_customer_revenue
FROM customer_frequency cf
JOIN customer_revenue cr
    ON cf.customer_id = cr.customer_id
GROUP BY
    CASE
        WHEN cf.total_orders = 1 THEN 'One-Time'
        WHEN cf.total_orders BETWEEN 2 AND 3 THEN 'Occasional'
        WHEN cf.total_orders BETWEEN 4 AND 6 THEN 'Regular'
        ELSE 'Frequent'
    END
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 11: Top Customers by Purchase Frequency
-- ============================================================

WITH customer_frequency AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT
        customer_id,
        total_orders,
        RANK() OVER (
            ORDER BY total_orders DESC
        ) AS frequency_rank
    FROM customer_frequency
)
SELECT
    customer_id,
    total_orders,
    frequency_rank
FROM ranked_customers
WHERE frequency_rank <= 10
ORDER BY frequency_rank, customer_id;


-- ============================================================
-- QUERY 12: Final Customer Purchase Frequency Summary
-- ============================================================

WITH customer_frequency AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        MIN(order_date) AS first_purchase_date,
        MAX(order_date) AS last_purchase_date
    FROM orders
    GROUP BY customer_id
),
customer_revenue AS (
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
    cf.customer_id,
    cf.total_orders,
    cf.first_purchase_date,
    cf.last_purchase_date,
    DATEDIFF(
        cf.last_purchase_date,
        cf.first_purchase_date
    ) AS customer_lifetime_days,
    ROUND(cr.total_revenue, 2) AS total_revenue,
    ROUND(
        cr.total_revenue / cf.total_orders,
        2
    ) AS average_order_value,
    CASE
        WHEN cf.total_orders = 1 THEN 'One-Time'
        WHEN cf.total_orders BETWEEN 2 AND 3 THEN 'Occasional'
        WHEN cf.total_orders BETWEEN 4 AND 6 THEN 'Regular'
        ELSE 'Frequent'
    END AS purchase_frequency_category
FROM customer_frequency cf
JOIN customer_revenue cr
    ON cf.customer_id = cr.customer_id
ORDER BY
    cf.total_orders DESC,
    cr.total_revenue DESC;