USE sales_analysis_db;

-- ============================================================
-- DAY 53
-- CUSTOMER PURCHASE PROPENSITY ANALYSIS
-- ============================================================

-- ============================================================
-- ANALYSIS 1
-- TOTAL ORDERS PER CUSTOMER
-- ============================================================

SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_orders DESC;


-- ============================================================
-- ANALYSIS 2
-- TOTAL REVENUE PER CUSTOMER
-- ============================================================

SELECT
    c.customer_id,
    COALESCE(SUM(oi.quantity * p.price), 0) AS total_revenue
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id
ORDER BY total_revenue DESC;


-- ============================================================
-- ANALYSIS 3
-- AVERAGE ORDER VALUE PER CUSTOMER
-- ============================================================

SELECT
    c.customer_id,
    ROUND(
        COALESCE(SUM(oi.quantity * p.price), 0)
        / NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_order_value
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id
ORDER BY average_order_value DESC;


-- ============================================================
-- ANALYSIS 4
-- CUSTOMER PURCHASE RECENCY
-- ============================================================

SELECT
    c.customer_id,
    MAX(o.order_date) AS last_purchase_date,
    DATEDIFF(
        (SELECT MAX(order_date) FROM orders),
        MAX(o.order_date)
    ) AS days_since_last_purchase
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY days_since_last_purchase;


-- ============================================================
-- ANALYSIS 5
-- AVERAGE DAYS BETWEEN CUSTOMER PURCHASES
-- ============================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_order_date
    FROM orders
),
purchase_gaps AS (
    SELECT
        customer_id,
        DATEDIFF(order_date, previous_order_date) AS days_between_orders
    FROM customer_orders
    WHERE previous_order_date IS NOT NULL
)
SELECT
    customer_id,
    ROUND(AVG(days_between_orders), 2)
        AS average_days_between_purchases
FROM purchase_gaps
GROUP BY customer_id
ORDER BY average_days_between_purchases;


-- ============================================================
-- ANALYSIS 6
-- CUSTOMER PURCHASE RECENCY CLASSIFICATION
-- ============================================================

WITH customer_recency AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_purchase_date
    FROM orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    last_purchase_date,
    DATEDIFF(
        (SELECT MAX(order_date) FROM orders),
        last_purchase_date
    ) AS days_since_last_purchase,
    CASE
        WHEN DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) <= 30 THEN 'Highly Recent'

        WHEN DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) <= 60 THEN 'Recent'

        WHEN DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) <= 90 THEN 'Moderately Recent'

        ELSE 'Inactive'
    END AS purchase_recency_status
FROM customer_recency
ORDER BY days_since_last_purchase;


-- ============================================================
-- ANALYSIS 7
-- CUSTOMER PURCHASE FREQUENCY CLASSIFICATION
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
        WHEN total_orders >= 10 THEN 'Very High Frequency'
        WHEN total_orders >= 5 THEN 'High Frequency'
        WHEN total_orders >= 2 THEN 'Repeat Customer'
        ELSE 'One-Time Customer'
    END AS purchase_frequency_status
FROM customer_orders
ORDER BY total_orders DESC;


-- ============================================================
-- ANALYSIS 8
-- CUSTOMER REVENUE CLASSIFICATION
-- ============================================================

WITH customer_revenue AS (
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
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,
    CASE
        WHEN total_revenue >= 10000 THEN 'High Value Customer'
        WHEN total_revenue >= 5000 THEN 'Medium Value Customer'
        WHEN total_revenue >= 1000 THEN 'Standard Value Customer'
        ELSE 'Low Value Customer'
    END AS customer_value_status
FROM customer_revenue
ORDER BY total_revenue DESC;


-- ============================================================
-- ANALYSIS 9
-- CUSTOMER PURCHASE PROPENSITY SCORE
-- ============================================================

WITH customer_metrics AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COALESCE(SUM(oi.quantity * p.price), 0)
            AS total_revenue,
        MAX(o.order_date) AS last_purchase_date
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
    ROUND(total_revenue, 2) AS total_revenue,
    last_purchase_date,

    DATEDIFF(
        (SELECT MAX(order_date) FROM orders),
        last_purchase_date
    ) AS days_since_last_purchase,

    (
        CASE
            WHEN total_orders >= 10 THEN 3
            WHEN total_orders >= 5 THEN 2
            WHEN total_orders >= 2 THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN DATEDIFF(
                (SELECT MAX(order_date) FROM orders),
                last_purchase_date
            ) <= 30 THEN 3

            WHEN DATEDIFF(
                (SELECT MAX(order_date) FROM orders),
                last_purchase_date
            ) <= 60 THEN 2

            WHEN DATEDIFF(
                (SELECT MAX(order_date) FROM orders),
                last_purchase_date
            ) <= 90 THEN 1

            ELSE 0
        END

        +

        CASE
            WHEN total_revenue >= 10000 THEN 3
            WHEN total_revenue >= 5000 THEN 2
            WHEN total_revenue >= 1000 THEN 1
            ELSE 0
        END
    ) AS purchase_propensity_score

FROM customer_metrics
ORDER BY purchase_propensity_score DESC;


-- ============================================================
-- ANALYSIS 10
-- PURCHASE PROPENSITY CLASSIFICATION
-- ============================================================

WITH customer_metrics AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COALESCE(SUM(oi.quantity * p.price), 0)
            AS total_revenue,
        MAX(o.order_date) AS last_purchase_date
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    LEFT JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY c.customer_id
),
scored_customers AS (
    SELECT
        *,
        (
            CASE
                WHEN total_orders >= 10 THEN 3
                WHEN total_orders >= 5 THEN 2
                WHEN total_orders >= 2 THEN 1
                ELSE 0
            END

            +

            CASE
                WHEN DATEDIFF(
                    (SELECT MAX(order_date) FROM orders),
                    last_purchase_date
                ) <= 30 THEN 3

                WHEN DATEDIFF(
                    (SELECT MAX(order_date) FROM orders),
                    last_purchase_date
                ) <= 60 THEN 2

                WHEN DATEDIFF(
                    (SELECT MAX(order_date) FROM orders),
                    last_purchase_date
                ) <= 90 THEN 1

                ELSE 0
            END

            +

            CASE
                WHEN total_revenue >= 10000 THEN 3
                WHEN total_revenue >= 5000 THEN 2
                WHEN total_revenue >= 1000 THEN 1
                ELSE 0
            END
        ) AS propensity_score
    FROM customer_metrics
)
SELECT
    customer_id,
    total_orders,
    ROUND(total_revenue, 2) AS total_revenue,
    propensity_score,

    CASE
        WHEN propensity_score >= 7
            THEN 'Very High Purchase Propensity'

        WHEN propensity_score >= 5
            THEN 'High Purchase Propensity'

        WHEN propensity_score >= 3
            THEN 'Moderate Purchase Propensity'

        WHEN propensity_score >= 1
            THEN 'Low Purchase Propensity'

        ELSE 'Very Low Purchase Propensity'
    END AS purchase_propensity_category

FROM scored_customers
ORDER BY propensity_score DESC;


-- ============================================================
-- ANALYSIS 11
-- CUSTOMER PURCHASE PROPENSITY RANKING
-- ============================================================

WITH customer_scores AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COALESCE(SUM(oi.quantity * p.price), 0)
            AS total_revenue,
        MAX(o.order_date) AS last_purchase_date
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    LEFT JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY c.customer_id
),
ranked_customers AS (
    SELECT
        *,
        RANK() OVER (
            ORDER BY
                total_orders DESC,
                total_revenue DESC,
                last_purchase_date DESC
        ) AS propensity_rank
    FROM customer_scores
)
SELECT
    customer_id,
    total_orders,
    ROUND(total_revenue, 2) AS total_revenue,
    last_purchase_date,
    propensity_rank
FROM ranked_customers
ORDER BY propensity_rank;


-- ============================================================
-- ANALYSIS 12
-- FINAL CUSTOMER PURCHASE PROPENSITY SUMMARY
-- ============================================================

WITH customer_metrics AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COALESCE(SUM(oi.quantity * p.price), 0)
            AS total_revenue,
        MAX(o.order_date) AS last_purchase_date
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    LEFT JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY c.customer_id
),
scored_customers AS (
    SELECT
        *,
        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS days_since_last_purchase,

        (
            CASE
                WHEN total_orders >= 10 THEN 3
                WHEN total_orders >= 5 THEN 2
                WHEN total_orders >= 2 THEN 1
                ELSE 0
            END

            +

            CASE
                WHEN DATEDIFF(
                    (SELECT MAX(order_date) FROM orders),
                    last_purchase_date
                ) <= 30 THEN 3

                WHEN DATEDIFF(
                    (SELECT MAX(order_date) FROM orders),
                    last_purchase_date
                ) <= 60 THEN 2

                WHEN DATEDIFF(
                    (SELECT MAX(order_date) FROM orders),
                    last_purchase_date
                ) <= 90 THEN 1

                ELSE 0
            END

            +

            CASE
                WHEN total_revenue >= 10000 THEN 3
                WHEN total_revenue >= 5000 THEN 2
                WHEN total_revenue >= 1000 THEN 1
                ELSE 0
            END
        ) AS propensity_score

    FROM customer_metrics
)
SELECT
    customer_id,
    total_orders,
    ROUND(total_revenue, 2) AS total_revenue,
    last_purchase_date,
    days_since_last_purchase,
    propensity_score,

    CASE
        WHEN propensity_score >= 7
            THEN 'Very High Purchase Propensity'

        WHEN propensity_score >= 5
            THEN 'High Purchase Propensity'

        WHEN propensity_score >= 3
            THEN 'Moderate Purchase Propensity'

        WHEN propensity_score >= 1
            THEN 'Low Purchase Propensity'

        ELSE 'Very Low Purchase Propensity'
    END AS purchase_propensity_category

FROM scored_customers
ORDER BY
    propensity_score DESC,
    total_revenue DESC;