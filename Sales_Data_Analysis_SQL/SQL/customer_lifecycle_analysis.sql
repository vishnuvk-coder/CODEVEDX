USE sales_analysis_db;


-- ============================================================
-- DAY 41
-- CUSTOMER LIFECYCLE & REPEAT PURCHASE ANALYSIS
-- ============================================================


-- ============================================================
-- QUERY 01: CUSTOMER FIRST PURCHASE
-- ============================================================

SELECT
    customer_id,
    MIN(order_date) AS first_purchase_date
FROM orders
GROUP BY customer_id
ORDER BY first_purchase_date;


-- ============================================================
-- QUERY 02: CUSTOMER SECOND PURCHASE
-- ============================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        order_id,
        order_date,

        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS purchase_number

    FROM orders
)

SELECT
    customer_id,
    order_id AS second_order_id,
    order_date AS second_purchase_date

FROM customer_orders

WHERE purchase_number = 2

ORDER BY customer_id;


-- ============================================================
-- QUERY 03: DAYS TO SECOND PURCHASE
-- ============================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        order_id,
        order_date,

        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS purchase_number

    FROM orders
),

customer_purchase_dates AS (
    SELECT
        customer_id,

        MAX(
            CASE
                WHEN purchase_number = 1
                THEN order_date
            END
        ) AS first_purchase_date,

        MAX(
            CASE
                WHEN purchase_number = 2
                THEN order_date
            END
        ) AS second_purchase_date

    FROM customer_orders

    GROUP BY customer_id
)

SELECT
    customer_id,
    first_purchase_date,
    second_purchase_date,

    DATEDIFF(
        second_purchase_date,
        first_purchase_date
    ) AS days_to_second_purchase

FROM customer_purchase_dates

WHERE second_purchase_date IS NOT NULL

ORDER BY days_to_second_purchase;


-- ============================================================
-- QUERY 04: REPEAT PURCHASE RATE
-- ============================================================

WITH customer_purchase_count AS (
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
            WHEN total_orders >= 2
            THEN 1
            ELSE 0
        END
    ) AS repeat_customers,

    SUM(
        CASE
            WHEN total_orders = 1
            THEN 1
            ELSE 0
        END
    ) AS one_time_customers,

    ROUND(
        SUM(
            CASE
                WHEN total_orders >= 2
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS repeat_purchase_rate,

    ROUND(
        SUM(
            CASE
                WHEN total_orders = 1
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS one_time_customer_rate

FROM customer_purchase_count;


-- ============================================================
-- QUERY 05: CUSTOMER PURCHASE FREQUENCY
-- ============================================================

SELECT
    customer_id,

    COUNT(DISTINCT order_id) AS total_orders,

    CASE
        WHEN COUNT(DISTINCT order_id) = 1
            THEN 'One-Time'

        WHEN COUNT(DISTINCT order_id) BETWEEN 2 AND 3
            THEN 'Developing'

        WHEN COUNT(DISTINCT order_id) BETWEEN 4 AND 6
            THEN 'Loyal'

        ELSE 'Highly Engaged'
    END AS lifecycle_stage

FROM orders

GROUP BY customer_id

ORDER BY total_orders DESC;


-- ============================================================
-- QUERY 06: PURCHASE INTERVAL ANALYSIS
-- ============================================================

WITH customer_purchase_gaps AS (
    SELECT
        customer_id,
        order_id,
        order_date,

        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS previous_purchase_date

    FROM orders
)

SELECT
    customer_id,
    order_id,
    order_date,
    previous_purchase_date,

    DATEDIFF(
        order_date,
        previous_purchase_date
    ) AS days_between_purchases

FROM customer_purchase_gaps

WHERE previous_purchase_date IS NOT NULL

ORDER BY customer_id, order_date;


-- ============================================================
-- QUERY 07: CUSTOMER LIFECYCLE STAGE
-- ============================================================

WITH customer_orders AS (
    SELECT
        customer_id,

        COUNT(DISTINCT order_id) AS total_orders,

        MIN(order_date) AS first_purchase_date,

        MAX(order_date) AS last_purchase_date

    FROM orders

    GROUP BY customer_id
)

SELECT
    customer_id,
    first_purchase_date,
    last_purchase_date,
    total_orders,

    CASE
        WHEN total_orders = 1
            THEN 'New / One-Time'

        WHEN total_orders BETWEEN 2 AND 3
            THEN 'Developing'

        WHEN total_orders BETWEEN 4 AND 6
            THEN 'Loyal'

        ELSE 'Highly Engaged'
    END AS lifecycle_stage

FROM customer_orders

ORDER BY total_orders DESC;


-- ============================================================
-- QUERY 08: REPEAT CUSTOMER REVENUE
-- ============================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders

    FROM orders

    GROUP BY customer_id
),

customer_revenue AS (
    SELECT
        o.customer_id,

        SUM(
            oi.quantity * p.price
        ) AS total_revenue

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY o.customer_id
)

SELECT
    co.customer_id,
    co.total_orders,
    cr.total_revenue,

    CASE
        WHEN co.total_orders >= 2
            THEN 'Repeat Customer'

        ELSE 'One-Time Customer'
    END AS customer_type

FROM customer_orders co

JOIN customer_revenue cr
    ON co.customer_id = cr.customer_id

ORDER BY cr.total_revenue DESC;


-- ============================================================
-- QUERY 09: REPEAT VS ONE-TIME CUSTOMER COMPARISON
-- ============================================================

WITH customer_summary AS (
    SELECT
        o.customer_id,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(
            oi.quantity * p.price
        ) AS total_revenue

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY o.customer_id
)

SELECT

    CASE
        WHEN total_orders = 1
            THEN 'One-Time Customer'

        ELSE 'Repeat Customer'
    END AS customer_type,

    COUNT(*) AS customer_count,

    SUM(total_revenue) AS total_revenue,

    ROUND(
        AVG(total_revenue),
        2
    ) AS average_customer_revenue

FROM customer_summary

GROUP BY

    CASE
        WHEN total_orders = 1
            THEN 'One-Time Customer'

        ELSE 'Repeat Customer'
    END

ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 10: LOYAL CUSTOMERS
-- ============================================================

SELECT
    customer_id,

    COUNT(DISTINCT order_id) AS total_orders,

    MIN(order_date) AS first_purchase_date,

    MAX(order_date) AS last_purchase_date

FROM orders

GROUP BY customer_id

HAVING COUNT(DISTINCT order_id) >= 4

ORDER BY total_orders DESC;


-- ============================================================
-- QUERY 11: CUSTOMER LIFECYCLE RANKING
-- ============================================================

WITH customer_summary AS (
    SELECT
        customer_id,

        COUNT(DISTINCT order_id) AS total_orders,

        MIN(order_date) AS first_purchase_date,

        MAX(order_date) AS last_purchase_date

    FROM orders

    GROUP BY customer_id
)

SELECT
    customer_id,
    total_orders,
    first_purchase_date,
    last_purchase_date,

    RANK() OVER (
        ORDER BY total_orders DESC
    ) AS lifecycle_rank

FROM customer_summary

ORDER BY lifecycle_rank, customer_id;


-- ============================================================
-- QUERY 12: FINAL CUSTOMER LIFECYCLE BUSINESS SUMMARY
-- ============================================================

WITH customer_summary AS (
    SELECT
        o.customer_id,

        COUNT(DISTINCT o.order_id) AS total_orders,

        MIN(o.order_date) AS first_purchase_date,

        MAX(o.order_date) AS last_purchase_date,

        SUM(
            oi.quantity * p.price
        ) AS total_revenue

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

    DATEDIFF(
        last_purchase_date,
        first_purchase_date
    ) AS customer_lifetime_days,

    ROUND(
        total_revenue,
        2
    ) AS total_revenue,

    CASE
        WHEN total_orders = 1
            THEN 'New / One-Time'

        WHEN total_orders BETWEEN 2 AND 3
            THEN 'Developing'

        WHEN total_orders BETWEEN 4 AND 6
            THEN 'Loyal'

        ELSE 'Highly Engaged'
    END AS lifecycle_stage,

    RANK() OVER (
        ORDER BY total_orders DESC, total_revenue DESC
    ) AS lifecycle_rank

FROM customer_summary

ORDER BY lifecycle_rank, customer_id;