USE sales_analysis_db;

-- ============================================================
-- DAY 28
-- CUSTOMER COHORT & RETENTION ANALYSIS
-- ============================================================

-- ============================================================
-- 1. CUSTOMER FIRST PURCHASE DATE
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        c.customer_id,
        c.customer_name,
        MIN(o.order_date) AS first_purchase_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,
    first_purchase_date
FROM customer_first_purchase
ORDER BY first_purchase_date;


-- ============================================================
-- 2. CUSTOMER COHORT MONTH
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        c.customer_id,
        c.customer_name,
        MIN(o.order_date) AS first_purchase_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,
    first_purchase_date,
    DATE_FORMAT(
        first_purchase_date,
        '%Y-%m-01'
    ) AS cohort_month
FROM customer_first_purchase
ORDER BY cohort_month;


-- ============================================================
-- 3. MONTHLY CUSTOMER ACTIVITY
-- ============================================================

SELECT DISTINCT
    o.customer_id,
    DATE_FORMAT(
        o.order_date,
        '%Y-%m-01'
    ) AS activity_month
FROM orders o
ORDER BY
    o.customer_id,
    activity_month;


-- ============================================================
-- 4. CUSTOMER COHORT ACTIVITY
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
),

customer_activity AS (
    SELECT DISTINCT
        customer_id,
        DATE_FORMAT(
            order_date,
            '%Y-%m-01'
        ) AS activity_month
    FROM orders
)

SELECT
    ca.customer_id,
    DATE_FORMAT(
        cfp.first_purchase_date,
        '%Y-%m-01'
    ) AS cohort_month,
    ca.activity_month
FROM customer_activity ca
JOIN customer_first_purchase cfp
    ON ca.customer_id = cfp.customer_id
ORDER BY
    cohort_month,
    ca.customer_id,
    ca.activity_month;


-- ============================================================
-- 5. COHORT MONTH NUMBER
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
),

customer_activity AS (
    SELECT DISTINCT
        customer_id,
        DATE_FORMAT(
            order_date,
            '%Y-%m-01'
        ) AS activity_month
    FROM orders
),

cohort_activity AS (
    SELECT
        ca.customer_id,
        DATE_FORMAT(
            cfp.first_purchase_date,
            '%Y-%m-01'
        ) AS cohort_month,
        ca.activity_month
    FROM customer_activity ca
    JOIN customer_first_purchase cfp
        ON ca.customer_id = cfp.customer_id
)

SELECT
    customer_id,
    cohort_month,
    activity_month,

    TIMESTAMPDIFF(
        MONTH,
        cohort_month,
        activity_month
    ) AS cohort_month_number

FROM cohort_activity
ORDER BY
    cohort_month,
    customer_id,
    activity_month;


-- ============================================================
-- 6. COHORT CUSTOMER RETENTION COUNT
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
),

customer_activity AS (
    SELECT DISTINCT
        customer_id,
        DATE_FORMAT(
            order_date,
            '%Y-%m-01'
        ) AS activity_month
    FROM orders
),

cohort_activity AS (
    SELECT
        ca.customer_id,

        DATE_FORMAT(
            cfp.first_purchase_date,
            '%Y-%m-01'
        ) AS cohort_month,

        ca.activity_month

    FROM customer_activity ca

    JOIN customer_first_purchase cfp
        ON ca.customer_id = cfp.customer_id
),

cohort_data AS (
    SELECT
        customer_id,
        cohort_month,
        activity_month,

        TIMESTAMPDIFF(
            MONTH,
            cohort_month,
            activity_month
        ) AS cohort_month_number

    FROM cohort_activity
)

SELECT
    cohort_month,
    cohort_month_number,
    COUNT(DISTINCT customer_id) AS active_customers
FROM cohort_data
GROUP BY
    cohort_month,
    cohort_month_number
ORDER BY
    cohort_month,
    cohort_month_number;


-- ============================================================
-- 7. COHORT SIZE
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
)

SELECT
    DATE_FORMAT(
        first_purchase_date,
        '%Y-%m-01'
    ) AS cohort_month,

    COUNT(DISTINCT customer_id) AS cohort_size

FROM customer_first_purchase

GROUP BY
    cohort_month

ORDER BY
    cohort_month;


-- ============================================================
-- 8. COHORT RETENTION RATE
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
),

customer_activity AS (
    SELECT DISTINCT
        customer_id,
        DATE_FORMAT(
            order_date,
            '%Y-%m-01'
        ) AS activity_month
    FROM orders
),

cohort_activity AS (
    SELECT
        ca.customer_id,

        DATE_FORMAT(
            cfp.first_purchase_date,
            '%Y-%m-01'
        ) AS cohort_month,

        ca.activity_month

    FROM customer_activity ca

    JOIN customer_first_purchase cfp
        ON ca.customer_id = cfp.customer_id
),

cohort_data AS (
    SELECT
        customer_id,
        cohort_month,
        activity_month,

        TIMESTAMPDIFF(
            MONTH,
            cohort_month,
            activity_month
        ) AS cohort_month_number

    FROM cohort_activity
),

cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS total_customers
    FROM cohort_data
    WHERE cohort_month_number = 0
    GROUP BY cohort_month
)

SELECT
    cd.cohort_month,
    cd.cohort_month_number,
    COUNT(DISTINCT cd.customer_id) AS active_customers,

    cs.total_customers AS cohort_size,

    ROUND(
        COUNT(DISTINCT cd.customer_id)
        / cs.total_customers * 100,
        2
    ) AS retention_rate_percent

FROM cohort_data cd

JOIN cohort_size cs
    ON cd.cohort_month = cs.cohort_month

GROUP BY
    cd.cohort_month,
    cd.cohort_month_number,
    cs.total_customers

ORDER BY
    cd.cohort_month,
    cd.cohort_month_number;


-- ============================================================
-- 9. MONTH 0 / MONTH 1 / MONTH 2 RETENTION
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
),

customer_activity AS (
    SELECT DISTINCT
        customer_id,
        DATE_FORMAT(
            order_date,
            '%Y-%m-01'
        ) AS activity_month
    FROM orders
),

cohort_data AS (
    SELECT
        ca.customer_id,

        DATE_FORMAT(
            cfp.first_purchase_date,
            '%Y-%m-01'
        ) AS cohort_month,

        TIMESTAMPDIFF(
            MONTH,
            DATE_FORMAT(
                cfp.first_purchase_date,
                '%Y-%m-01'
            ),
            ca.activity_month
        ) AS month_number

    FROM customer_activity ca

    JOIN customer_first_purchase cfp
        ON ca.customer_id = cfp.customer_id
),

cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_size
    FROM cohort_data
    WHERE month_number = 0
    GROUP BY cohort_month
),

retention_counts AS (
    SELECT
        cohort_month,
        month_number,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM cohort_data
    GROUP BY
        cohort_month,
        month_number
)

SELECT
    rc.cohort_month,

    ROUND(
        MAX(
            CASE
                WHEN rc.month_number = 0
                THEN rc.active_customers
                / cs.cohort_size * 100
            END
        ),
        2
    ) AS month_0_retention_percent,

    ROUND(
        MAX(
            CASE
                WHEN rc.month_number = 1
                THEN rc.active_customers
                / cs.cohort_size * 100
            END
        ),
        2
    ) AS month_1_retention_percent,

    ROUND(
        MAX(
            CASE
                WHEN rc.month_number = 2
                THEN rc.active_customers
                / cs.cohort_size * 100
            END
        ),
        2
    ) AS month_2_retention_percent

FROM retention_counts rc

JOIN cohort_size cs
    ON rc.cohort_month = cs.cohort_month

GROUP BY
    rc.cohort_month

ORDER BY
    rc.cohort_month;


-- ============================================================
-- 10. REPEAT CUSTOMERS
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY
    total_orders DESC;


-- ============================================================
-- 11. ONE-TIME CUSTOMERS
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(DISTINCT o.order_id) = 1
ORDER BY
    c.customer_id;


-- ============================================================
-- 12. CUSTOMER RETENTION SUMMARY
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
            WHEN total_orders = 1
            THEN 1
            ELSE 0
        END
    ) AS one_time_customers,

    SUM(
        CASE
            WHEN total_orders > 1
            THEN 1
            ELSE 0
        END
    ) AS repeat_customers,

    ROUND(
        SUM(
            CASE
                WHEN total_orders > 1
                THEN 1
                ELSE 0
            END
        )
        / COUNT(*) * 100,
        2
    ) AS repeat_customer_rate_percent

FROM customer_orders;


-- ============================================================
-- 13. AVERAGE ORDERS PER CUSTOMER
-- ============================================================

SELECT
    COUNT(DISTINCT customer_id) AS total_customers,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        COUNT(DISTINCT order_id)
        / COUNT(DISTINCT customer_id),
        2
    ) AS average_orders_per_customer

FROM orders;


-- ============================================================
-- 14. CUSTOMER RETENTION BUSINESS REPORT
-- ============================================================

WITH customer_orders AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MIN(o.order_date) AS first_order_date,
        MAX(o.order_date) AS last_order_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,
    total_orders,
    first_order_date,
    last_order_date,

    CASE
        WHEN total_orders = 1
            THEN 'One-Time Customer'

        WHEN total_orders BETWEEN 2 AND 3
            THEN 'Repeat Customer'

        ELSE 'Loyal Customer'
    END AS customer_retention_segment

FROM customer_orders

ORDER BY
    total_orders DESC;