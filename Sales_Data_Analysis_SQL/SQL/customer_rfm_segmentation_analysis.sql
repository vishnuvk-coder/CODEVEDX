USE sales_analysis_db;


-- ============================================================
-- DAY 37 — CUSTOMER RFM SEGMENTATION ANALYSIS
-- ============================================================


-- ============================================================
-- ANALYSIS 1: CUSTOMER RECENCY
-- How recently did each customer purchase?
-- ============================================================

SELECT
    o.customer_id,
    DATEDIFF(
        (SELECT MAX(order_date) FROM orders),
        MAX(o.order_date)
    ) AS recency_days
FROM orders o
GROUP BY o.customer_id
ORDER BY recency_days ASC;


-- ============================================================
-- ANALYSIS 2: CUSTOMER FREQUENCY
-- How many orders did each customer place?
-- ============================================================

SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS frequency_orders
FROM orders
GROUP BY customer_id
ORDER BY frequency_orders DESC;


-- ============================================================
-- ANALYSIS 3: CUSTOMER MONETARY VALUE
-- How much revenue did each customer generate?
-- ============================================================

SELECT
    o.customer_id,
    ROUND(
        SUM(oi.quantity * p.price),
        2
    ) AS monetary_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY monetary_value DESC;


-- ============================================================
-- ANALYSIS 4: COMPLETE CUSTOMER RFM METRICS
-- Recency + Frequency + Monetary
-- ============================================================

WITH customer_rfm AS (
    SELECT
        o.customer_id,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS recency_days,

        COUNT(DISTINCT o.order_id) AS frequency_orders,

        ROUND(
            SUM(oi.quantity * p.price),
            2
        ) AS monetary_value

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY o.customer_id
)

SELECT *
FROM customer_rfm
ORDER BY monetary_value DESC;


-- ============================================================
-- ANALYSIS 5: RECENCY SCORE
-- More recent customers receive a higher score.
-- ============================================================

WITH customer_rfm AS (
    SELECT
        o.customer_id,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS recency_days,

        COUNT(DISTINCT o.order_id) AS frequency_orders,

        SUM(oi.quantity * p.price) AS monetary_value

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY o.customer_id
)

SELECT
    customer_id,
    recency_days,

    NTILE(5) OVER (
        ORDER BY recency_days DESC
    ) AS recency_score

FROM customer_rfm
ORDER BY recency_score DESC;


-- ============================================================
-- ANALYSIS 6: FREQUENCY SCORE
-- More orders receive a higher score.
-- ============================================================

WITH customer_rfm AS (
    SELECT
        o.customer_id,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS recency_days,

        COUNT(DISTINCT o.order_id) AS frequency_orders,

        SUM(oi.quantity * p.price) AS monetary_value

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY o.customer_id
)

SELECT
    customer_id,
    frequency_orders,

    NTILE(5) OVER (
        ORDER BY frequency_orders
    ) AS frequency_score

FROM customer_rfm
ORDER BY frequency_score DESC;


-- ============================================================
-- ANALYSIS 7: MONETARY SCORE
-- Higher spending receives a higher score.
-- ============================================================

WITH customer_rfm AS (
    SELECT
        o.customer_id,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS recency_days,

        COUNT(DISTINCT o.order_id) AS frequency_orders,

        SUM(oi.quantity * p.price) AS monetary_value

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY o.customer_id
)

SELECT
    customer_id,
    ROUND(monetary_value, 2) AS monetary_value,

    NTILE(5) OVER (
        ORDER BY monetary_value
    ) AS monetary_score

FROM customer_rfm
ORDER BY monetary_score DESC;


-- ============================================================
-- ANALYSIS 8: COMPLETE RFM SCORE
-- Combine Recency + Frequency + Monetary scores.
-- ============================================================

WITH customer_rfm AS (
    SELECT
        o.customer_id,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS recency_days,

        COUNT(DISTINCT o.order_id) AS frequency_orders,

        SUM(oi.quantity * p.price) AS monetary_value

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY o.customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency_days,
        frequency_orders,
        monetary_value,

        NTILE(5) OVER (
            ORDER BY recency_days DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency_orders
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary_value
        ) AS monetary_score

    FROM customer_rfm
)

SELECT
    customer_id,
    recency_days,
    frequency_orders,
    ROUND(monetary_value, 2) AS monetary_value,
    recency_score,
    frequency_score,
    monetary_score,

    CONCAT(
        recency_score,
        frequency_score,
        monetary_score
    ) AS rfm_score

FROM rfm_scores
ORDER BY
    recency_score DESC,
    frequency_score DESC,
    monetary_score DESC;


-- ============================================================
-- ANALYSIS 9: CUSTOMER SEGMENTATION
-- Business-oriented RFM customer segments.
-- ============================================================

WITH customer_rfm AS (
    SELECT
        o.customer_id,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS recency_days,

        COUNT(DISTINCT o.order_id) AS frequency_orders,

        SUM(oi.quantity * p.price) AS monetary_value

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY o.customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency_days,
        frequency_orders,
        monetary_value,

        NTILE(5) OVER (
            ORDER BY recency_days DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency_orders
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary_value
        ) AS monetary_score

    FROM customer_rfm
)

SELECT
    customer_id,
    recency_days,
    frequency_orders,
    ROUND(monetary_value, 2) AS monetary_value,
    recency_score,
    frequency_score,
    monetary_score,

    CASE

        WHEN recency_score >= 4
             AND frequency_score >= 4
             AND monetary_score >= 4
            THEN 'Champions'

        WHEN recency_score >= 3
             AND frequency_score >= 4
            THEN 'Loyal Customers'

        WHEN recency_score >= 4
             AND frequency_score <= 2
            THEN 'New Customers'

        WHEN recency_score <= 2
             AND frequency_score >= 3
            THEN 'At-Risk Customers'

        WHEN recency_score <= 2
             AND frequency_score <= 2
             AND monetary_score <= 2
            THEN 'Lost Customers'

        ELSE 'Potential Customers'

    END AS customer_segment

FROM rfm_scores

ORDER BY
    monetary_value DESC;


-- ============================================================
-- ANALYSIS 10: CHAMPION CUSTOMERS
-- Recently purchased, frequent and high-value customers.
-- ============================================================

WITH customer_rfm AS (
    SELECT
        o.customer_id,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS recency_days,

        COUNT(DISTINCT o.order_id) AS frequency_orders,

        SUM(oi.quantity * p.price) AS monetary_value

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY o.customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency_days,
        frequency_orders,
        monetary_value,

        NTILE(5) OVER (
            ORDER BY recency_days DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency_orders
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary_value
        ) AS monetary_score

    FROM customer_rfm
)

SELECT
    customer_id,
    recency_days,
    frequency_orders,
    ROUND(monetary_value, 2) AS monetary_value

FROM rfm_scores

WHERE recency_score >= 4
  AND frequency_score >= 4
  AND monetary_score >= 4

ORDER BY monetary_value DESC;


-- ============================================================
-- ANALYSIS 11: AT-RISK CUSTOMERS
-- Previously valuable/frequent customers who have not purchased recently.
-- ============================================================

WITH customer_rfm AS (
    SELECT
        o.customer_id,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS recency_days,

        COUNT(DISTINCT o.order_id) AS frequency_orders,

        SUM(oi.quantity * p.price) AS monetary_value

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY o.customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency_days,
        frequency_orders,
        monetary_value,

        NTILE(5) OVER (
            ORDER BY recency_days DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency_orders
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary_value
        ) AS monetary_score

    FROM customer_rfm
)

SELECT
    customer_id,
    recency_days,
    frequency_orders,
    ROUND(monetary_value, 2) AS monetary_value

FROM rfm_scores

WHERE recency_score <= 2
  AND frequency_score >= 3

ORDER BY monetary_value DESC;


-- ============================================================
-- ANALYSIS 12: FINAL RFM BUSINESS SUMMARY
-- ============================================================

WITH customer_rfm AS (
    SELECT
        o.customer_id,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS recency_days,

        COUNT(DISTINCT o.order_id) AS frequency_orders,

        SUM(oi.quantity * p.price) AS monetary_value

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY o.customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency_days,
        frequency_orders,
        monetary_value,

        NTILE(5) OVER (
            ORDER BY recency_days DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency_orders
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary_value
        ) AS monetary_score

    FROM customer_rfm
),

segmented_customers AS (
    SELECT
        customer_id,
        recency_days,
        frequency_orders,
        monetary_value,

        recency_score,
        frequency_score,
        monetary_score,

        CASE

            WHEN recency_score >= 4
                 AND frequency_score >= 4
                 AND monetary_score >= 4
                THEN 'Champions'

            WHEN recency_score >= 3
                 AND frequency_score >= 4
                THEN 'Loyal Customers'

            WHEN recency_score >= 4
                 AND frequency_score <= 2
                THEN 'New Customers'

            WHEN recency_score <= 2
                 AND frequency_score >= 3
                THEN 'At-Risk Customers'

            WHEN recency_score <= 2
                 AND frequency_score <= 2
                 AND monetary_score <= 2
                THEN 'Lost Customers'

            ELSE 'Potential Customers'

        END AS customer_segment

    FROM rfm_scores
)

SELECT
    customer_segment,

    COUNT(*) AS customer_count,

    ROUND(
        SUM(monetary_value),
        2
    ) AS total_revenue,

    ROUND(
        AVG(monetary_value),
        2
    ) AS average_customer_value,

    ROUND(
        AVG(frequency_orders),
        2
    ) AS average_orders,

    ROUND(
        AVG(recency_days),
        2
    ) AS average_recency_days

FROM segmented_customers

GROUP BY customer_segment

ORDER BY total_revenue DESC;