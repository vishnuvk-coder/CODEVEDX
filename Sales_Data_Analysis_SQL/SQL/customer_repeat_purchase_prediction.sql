USE sales_analysis_db;


-- ============================================================
-- DAY 52
-- CUSTOMER REPEAT PURCHASE PREDICTION & ANALYSIS
-- ============================================================


-- ============================================================
-- ANALYSIS 1
-- TOTAL ORDERS PER CUSTOMER
-- ============================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
GROUP BY o.customer_id
ORDER BY total_orders DESC;


-- ============================================================
-- ANALYSIS 2
-- TOTAL UNITS PURCHASED PER CUSTOMER
-- ============================================================

SELECT
    o.customer_id,
    SUM(oi.quantity) AS total_units_purchased
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_units_purchased DESC;


-- ============================================================
-- ANALYSIS 3
-- TOTAL REVENUE PER CUSTOMER
-- ============================================================

SELECT
    o.customer_id,
    ROUND(SUM(oi.quantity * p.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY total_revenue DESC;


-- ============================================================
-- ANALYSIS 4
-- FIRST PURCHASE DATE
-- ============================================================

SELECT
    o.customer_id,
    MIN(o.order_date) AS first_purchase_date
FROM orders o
GROUP BY o.customer_id
ORDER BY first_purchase_date;


-- ============================================================
-- ANALYSIS 5
-- LATEST PURCHASE DATE
-- ============================================================

SELECT
    o.customer_id,
    MAX(o.order_date) AS latest_purchase_date
FROM orders o
GROUP BY o.customer_id
ORDER BY latest_purchase_date DESC;


-- ============================================================
-- ANALYSIS 6
-- DAYS SINCE LAST PURCHASE
-- ============================================================

SELECT
    o.customer_id,
    MAX(o.order_date) AS latest_purchase_date,
    DATEDIFF(
        (SELECT MAX(order_date) FROM orders),
        MAX(o.order_date)
    ) AS days_since_last_purchase
FROM orders o
GROUP BY o.customer_id
ORDER BY days_since_last_purchase DESC;


-- ============================================================
-- ANALYSIS 7
-- AVERAGE DAYS BETWEEN PURCHASES
-- ============================================================

WITH customer_purchase_dates AS (
    SELECT DISTINCT
        customer_id,
        order_date
    FROM orders
),

purchase_intervals AS (
    SELECT
        customer_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_purchase_date
    FROM customer_purchase_dates
)

SELECT
    customer_id,
    ROUND(
        AVG(
            DATEDIFF(
                order_date,
                previous_purchase_date
            )
        ),
        2
    ) AS average_days_between_purchases
FROM purchase_intervals
WHERE previous_purchase_date IS NOT NULL
GROUP BY customer_id
ORDER BY average_days_between_purchases;


-- ============================================================
-- ANALYSIS 8
-- REPEAT PURCHASE COUNT
-- ============================================================

SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders,
    GREATEST(
        COUNT(DISTINCT order_id) - 1,
        0
    ) AS repeat_purchase_count
FROM orders
GROUP BY customer_id
ORDER BY repeat_purchase_count DESC;


-- ============================================================
-- ANALYSIS 9
-- CUSTOMER PURCHASE FREQUENCY
-- ============================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        MIN(order_date) AS first_purchase_date,
        MAX(order_date) AS latest_purchase_date
    FROM orders
    GROUP BY customer_id
)

SELECT
    customer_id,
    total_orders,
    first_purchase_date,
    latest_purchase_date,
    DATEDIFF(
        latest_purchase_date,
        first_purchase_date
    ) AS customer_lifetime_days,
    ROUND(
        total_orders /
        NULLIF(
            DATEDIFF(
                latest_purchase_date,
                first_purchase_date
            ),
            0
        ),
        4
    ) AS orders_per_day
FROM customer_orders
ORDER BY orders_per_day DESC;


-- ============================================================
-- ANALYSIS 10
-- CUSTOMER REPEAT-PURCHASE CLASSIFICATION
-- ============================================================

WITH customer_orders AS (
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
        WHEN total_orders = 1
            THEN 'One-Time Customer'
        WHEN total_orders BETWEEN 2 AND 3
            THEN 'Occasional Repeat Customer'
        WHEN total_orders BETWEEN 4 AND 6
            THEN 'Regular Repeat Customer'
        WHEN total_orders >= 7
            THEN 'Highly Loyal Customer'
        ELSE 'Unknown'
    END AS repeat_purchase_category
FROM customer_orders
ORDER BY total_orders DESC;


-- ============================================================
-- ANALYSIS 11
-- CUSTOMER PURCHASE ACTIVITY SCORE
-- ============================================================

WITH customer_metrics AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        MAX(order_date) AS latest_purchase_date
    FROM orders
    GROUP BY customer_id
),

scored_customers AS (
    SELECT
        customer_id,
        total_orders,
        latest_purchase_date,
        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            latest_purchase_date
        ) AS days_since_last_purchase
    FROM customer_metrics
)

SELECT
    customer_id,
    total_orders,
    days_since_last_purchase,

    (
        CASE
            WHEN total_orders >= 7 THEN 40
            WHEN total_orders BETWEEN 4 AND 6 THEN 30
            WHEN total_orders BETWEEN 2 AND 3 THEN 20
            ELSE 10
        END
        +
        CASE
            WHEN days_since_last_purchase <= 30 THEN 40
            WHEN days_since_last_purchase <= 60 THEN 30
            WHEN days_since_last_purchase <= 90 THEN 20
            ELSE 10
        END
    ) AS purchase_activity_score

FROM scored_customers
ORDER BY purchase_activity_score DESC;


-- ============================================================
-- ANALYSIS 12
-- FINAL CUSTOMER REPEAT-PURCHASE PREDICTION SUMMARY
-- ============================================================

WITH customer_metrics AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        MIN(order_date) AS first_purchase_date,
        MAX(order_date) AS latest_purchase_date
    FROM orders
    GROUP BY customer_id
),

purchase_intervals AS (
    SELECT
        customer_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_purchase_date
    FROM (
        SELECT DISTINCT
            customer_id,
            order_date
        FROM orders
    ) purchase_dates
),

average_intervals AS (
    SELECT
        customer_id,
        ROUND(
            AVG(
                DATEDIFF(
                    order_date,
                    previous_purchase_date
                )
            ),
            2
        ) AS average_days_between_purchases
    FROM purchase_intervals
    WHERE previous_purchase_date IS NOT NULL
    GROUP BY customer_id
),

final_metrics AS (
    SELECT
        cm.customer_id,
        cm.total_orders,
        cm.first_purchase_date,
        cm.latest_purchase_date,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            cm.latest_purchase_date
        ) AS days_since_last_purchase,

        COALESCE(
            ai.average_days_between_purchases,
            0
        ) AS average_days_between_purchases,

        GREATEST(
            cm.total_orders - 1,
            0
        ) AS repeat_purchase_count

    FROM customer_metrics cm
    LEFT JOIN average_intervals ai
        ON cm.customer_id = ai.customer_id
)

SELECT
    customer_id,
    total_orders,
    repeat_purchase_count,
    first_purchase_date,
    latest_purchase_date,
    days_since_last_purchase,
    average_days_between_purchases,

    CASE
        WHEN total_orders >= 4
             AND days_since_last_purchase <= 60
            THEN 'High Repeat Purchase Potential'

        WHEN total_orders >= 2
             AND days_since_last_purchase <= 90
            THEN 'Moderate Repeat Purchase Potential'

        WHEN total_orders >= 2
             AND days_since_last_purchase > 90
            THEN 'At-Risk Repeat Customer'

        WHEN total_orders = 1
             AND days_since_last_purchase <= 60
            THEN 'Potential New Repeat Customer'

        WHEN total_orders = 1
             AND days_since_last_purchase > 60
            THEN 'Low Repeat Purchase Potential'

        ELSE 'Unclassified'
    END AS repeat_purchase_prediction

FROM final_metrics
ORDER BY
    CASE
        WHEN total_orders >= 4
             AND days_since_last_purchase <= 60
            THEN 1

        WHEN total_orders >= 2
             AND days_since_last_purchase <= 90
            THEN 2

        WHEN total_orders >= 2
             AND days_since_last_purchase > 90
            THEN 3

        WHEN total_orders = 1
             AND days_since_last_purchase <= 60
            THEN 4

        ELSE 5
    END,
    total_orders DESC;