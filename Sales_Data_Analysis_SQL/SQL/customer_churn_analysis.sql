USE sales_analysis_db;

-- ============================================================
-- DAY 27
-- CUSTOMER CHURN & RETENTION RISK ANALYSIS
-- ============================================================


-- ============================================================
-- 1. CUSTOMER LAST ORDER DATE
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    MAX(o.order_date) AS last_order_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY last_order_date DESC;


-- ============================================================
-- 2. CUSTOMER ORDER FREQUENCY
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_orders DESC;


-- ============================================================
-- 3. CUSTOMER RECENCY ANALYSIS
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,

    MAX(o.order_date) AS last_order_date,

    DATEDIFF(
        (SELECT MAX(order_date) FROM orders),
        MAX(o.order_date)
    ) AS days_since_last_order

FROM customers c

LEFT JOIN orders o
    ON c.customer_id = o.customer_id

GROUP BY
    c.customer_id,
    c.customer_name

ORDER BY days_since_last_order DESC;


-- ============================================================
-- 4. CUSTOMER CHURN RISK CLASSIFICATION
-- ============================================================

WITH customer_recency AS (

    SELECT
        c.customer_id,
        c.customer_name,

        MAX(o.order_date) AS last_order_date,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS days_since_last_order

    FROM customers c

    LEFT JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,
    last_order_date,
    days_since_last_order,

    CASE

        WHEN last_order_date IS NULL
            THEN 'No Purchase'

        WHEN days_since_last_order <= 30
            THEN 'Active'

        WHEN days_since_last_order <= 60
            THEN 'At Risk'

        WHEN days_since_last_order <= 90
            THEN 'High Risk'

        ELSE 'Churn Risk'

    END AS churn_risk

FROM customer_recency

ORDER BY days_since_last_order DESC;


-- ============================================================
-- 5. CUSTOMER REVENUE + CHURN RISK
-- ============================================================

WITH customer_analysis AS (

    SELECT
        c.customer_id,
        c.customer_name,

        MAX(o.order_date) AS last_order_date,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(
            oi.quantity * p.price
        ) AS total_revenue

    FROM customers c

    LEFT JOIN orders o
        ON c.customer_id = o.customer_id

    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id

    LEFT JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,

    last_order_date,

    total_orders,

    ROUND(
        COALESCE(total_revenue, 0),
        2
    ) AS total_revenue,

    DATEDIFF(
        (SELECT MAX(order_date) FROM orders),
        last_order_date
    ) AS days_since_last_order,

    CASE

        WHEN last_order_date IS NULL
            THEN 'No Purchase'

        WHEN DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_order_date
        ) <= 30
            THEN 'Active'

        WHEN DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_order_date
        ) <= 60
            THEN 'At Risk'

        WHEN DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_order_date
        ) <= 90
            THEN 'High Risk'

        ELSE 'Churn Risk'

    END AS churn_risk

FROM customer_analysis

ORDER BY
    total_revenue DESC;


-- ============================================================
-- 6. HIGH-VALUE CUSTOMERS AT CHURN RISK
-- ============================================================

WITH customer_analysis AS (

    SELECT
        c.customer_id,
        c.customer_name,

        MAX(o.order_date) AS last_order_date,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(
            oi.quantity * p.price
        ) AS total_revenue

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,

    ROUND(total_revenue, 2) AS total_revenue,

    total_orders,

    last_order_date,

    DATEDIFF(
        (SELECT MAX(order_date) FROM orders),
        last_order_date
    ) AS days_since_last_order

FROM customer_analysis

WHERE
    total_revenue >= 5000

    AND DATEDIFF(
        (SELECT MAX(order_date) FROM orders),
        last_order_date
    ) > 60

ORDER BY total_revenue DESC;


-- ============================================================
-- 7. CHURN RISK CUSTOMER COUNT
-- ============================================================

WITH customer_recency AS (

    SELECT
        c.customer_id,
        c.customer_name,

        MAX(o.order_date) AS last_order_date,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS days_since_last_order

    FROM customers c

    LEFT JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT

    CASE

        WHEN last_order_date IS NULL
            THEN 'No Purchase'

        WHEN days_since_last_order <= 30
            THEN 'Active'

        WHEN days_since_last_order <= 60
            THEN 'At Risk'

        WHEN days_since_last_order <= 90
            THEN 'High Risk'

        ELSE 'Churn Risk'

    END AS churn_risk,

    COUNT(*) AS customer_count

FROM customer_recency

GROUP BY
    CASE

        WHEN last_order_date IS NULL
            THEN 'No Purchase'

        WHEN days_since_last_order <= 30
            THEN 'Active'

        WHEN days_since_last_order <= 60
            THEN 'At Risk'

        WHEN days_since_last_order <= 90
            THEN 'High Risk'

        ELSE 'Churn Risk'

    END

ORDER BY customer_count DESC;


-- ============================================================
-- 8. CHURN RISK REVENUE ANALYSIS
-- ============================================================

WITH customer_analysis AS (

    SELECT
        c.customer_id,
        c.customer_name,

        MAX(o.order_date) AS last_order_date,

        SUM(
            oi.quantity * p.price
        ) AS total_revenue

    FROM customers c

    LEFT JOIN orders o
        ON c.customer_id = o.customer_id

    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id

    LEFT JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY
        c.customer_id,
        c.customer_name
),

risk_analysis AS (

    SELECT
        customer_id,
        customer_name,
        last_order_date,
        total_revenue,

        CASE

            WHEN last_order_date IS NULL
                THEN 'No Purchase'

            WHEN DATEDIFF(
                (SELECT MAX(order_date) FROM orders),
                last_order_date
            ) <= 30
                THEN 'Active'

            WHEN DATEDIFF(
                (SELECT MAX(order_date) FROM orders),
                last_order_date
            ) <= 60
                THEN 'At Risk'

            WHEN DATEDIFF(
                (SELECT MAX(order_date) FROM orders),
                last_order_date
            ) <= 90
                THEN 'High Risk'

            ELSE 'Churn Risk'

        END AS churn_risk

    FROM customer_analysis
)

SELECT
    churn_risk,

    COUNT(*) AS customers,

    ROUND(
        COALESCE(SUM(total_revenue), 0),
        2
    ) AS revenue_at_risk

FROM risk_analysis

GROUP BY churn_risk

ORDER BY revenue_at_risk DESC;


-- ============================================================
-- 9. CUSTOMER CHURN RISK RANKING
-- ============================================================

WITH customer_analysis AS (

    SELECT
        c.customer_id,
        c.customer_name,

        MAX(o.order_date) AS last_order_date,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(
            oi.quantity * p.price
        ) AS total_revenue

    FROM customers c

    LEFT JOIN orders o
        ON c.customer_id = o.customer_id

    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id

    LEFT JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY
        c.customer_id,
        c.customer_name
),

risk_analysis AS (

    SELECT
        customer_id,
        customer_name,
        last_order_date,
        total_orders,
        total_revenue,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_order_date
        ) AS days_since_last_order

    FROM customer_analysis
)

SELECT
    customer_id,
    customer_name,

    total_orders,

    ROUND(
        COALESCE(total_revenue, 0),
        2
    ) AS total_revenue,

    last_order_date,

    days_since_last_order,

    RANK() OVER (
        ORDER BY days_since_last_order DESC
    ) AS churn_risk_rank

FROM risk_analysis

WHERE last_order_date IS NOT NULL

ORDER BY churn_risk_rank;


-- ============================================================
-- 10. FINAL CUSTOMER CHURN BUSINESS REPORT
-- ============================================================

WITH customer_analysis AS (

    SELECT
        c.customer_id,
        c.customer_name,

        MAX(o.order_date) AS last_order_date,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(
            oi.quantity * p.price
        ) AS total_revenue

    FROM customers c

    LEFT JOIN orders o
        ON c.customer_id = o.customer_id

    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id

    LEFT JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY
        c.customer_id,
        c.customer_name
),

final_analysis AS (

    SELECT

        customer_id,
        customer_name,
        last_order_date,
        total_orders,

        COALESCE(
            total_revenue,
            0
        ) AS total_revenue,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_order_date
        ) AS days_since_last_order

    FROM customer_analysis
)

SELECT

    customer_id,

    customer_name,

    last_order_date,

    total_orders,

    ROUND(
        total_revenue,
        2
    ) AS total_revenue,

    days_since_last_order,

    CASE

        WHEN last_order_date IS NULL
            THEN 'No Purchase'

        WHEN days_since_last_order <= 30
            THEN 'Active'

        WHEN days_since_last_order <= 60
            THEN 'At Risk'

        WHEN days_since_last_order <= 90
            THEN 'High Risk'

        ELSE 'Churn Risk'

    END AS churn_risk,

    CASE

        WHEN last_order_date IS NULL
            THEN 'Immediate Engagement Required'

        WHEN days_since_last_order <= 30
            THEN 'Maintain Relationship'

        WHEN days_since_last_order <= 60
            THEN 'Send Re-engagement Offer'

        WHEN days_since_last_order <= 90
            THEN 'Priority Retention Campaign'

        ELSE 'Urgent Win-back Campaign'

    END AS recommended_action

FROM final_analysis

ORDER BY
    total_revenue DESC;