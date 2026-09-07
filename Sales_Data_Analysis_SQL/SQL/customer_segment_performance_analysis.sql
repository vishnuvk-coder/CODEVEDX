USE sales_analysis_db;


-- ============================================================
-- DAY 38
-- CUSTOMER SEGMENT PERFORMANCE & REVENUE ANALYSIS
-- ============================================================


-- ============================================================
-- ANALYSIS 1: CUSTOMER SEGMENT DISTRIBUTION
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS frequency_orders,
        MAX(o.order_date) AS last_purchase_date,
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
        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS recency_days,
        frequency_orders,
        monetary_value
    FROM customer_metrics
),

scored_customers AS (
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
    FROM rfm_scores
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

    FROM scored_customers
)

SELECT
    customer_segment,
    COUNT(*) AS customer_count
FROM segmented_customers
GROUP BY customer_segment
ORDER BY customer_count DESC;


-- ============================================================
-- ANALYSIS 2: REVENUE BY RFM SEGMENT
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS frequency_orders,
        MAX(o.order_date) AS last_purchase_date,
        SUM(oi.quantity * p.price) AS monetary_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
),

scored_customers AS (
    SELECT
        customer_id,
        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS recency_days,
        frequency_orders,
        monetary_value,

        NTILE(5) OVER (ORDER BY
            DATEDIFF(
                (SELECT MAX(order_date) FROM orders),
                last_purchase_date
            ) DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency_orders
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary_value
        ) AS monetary_score
    FROM customer_metrics
),

segmented_customers AS (
    SELECT
        *,
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
    FROM scored_customers
)

SELECT
    customer_segment,
    ROUND(SUM(monetary_value), 2) AS total_revenue
FROM segmented_customers
GROUP BY customer_segment
ORDER BY total_revenue DESC;


-- ============================================================
-- ANALYSIS 3: TOTAL ORDERS BY RFM SEGMENT
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MAX(o.order_date) AS last_purchase_date,
        SUM(oi.quantity * p.price) AS monetary_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
),

scored_customers AS (
    SELECT
        *,
        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS recency_days
    FROM customer_metrics
),

rfm_scored AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY total_orders) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary_value) AS monetary_score
    FROM scored_customers
),

segmented AS (
    SELECT
        *,
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
    FROM rfm_scored
)

SELECT
    customer_segment,
    SUM(total_orders) AS total_orders
FROM segmented
GROUP BY customer_segment
ORDER BY total_orders DESC;


-- ============================================================
-- ANALYSIS 4: AVERAGE REVENUE PER CUSTOMER BY SEGMENT
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MAX(o.order_date) AS last_purchase_date,
        SUM(oi.quantity * p.price) AS monetary_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
),

rfm_scored AS (
    SELECT
        *,
        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS recency_days
    FROM customer_metrics
),

scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY total_orders) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary_value) AS monetary_score
    FROM rfm_scored
),

segmented AS (
    SELECT
        *,
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
    FROM scores
)

SELECT
    customer_segment,
    COUNT(*) AS customers,
    ROUND(AVG(monetary_value), 2) AS avg_revenue_per_customer
FROM segmented
GROUP BY customer_segment
ORDER BY avg_revenue_per_customer DESC;


-- ============================================================
-- ANALYSIS 5: AVERAGE ORDER VALUE BY SEGMENT
-- ============================================================

WITH customer_orders AS (
    SELECT
        o.customer_id,
        o.order_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.customer_id,
        o.order_id
),

customer_metrics AS (
    SELECT
        co.customer_id,
        COUNT(*) AS total_orders,
        SUM(co.order_value) AS monetary_value,
        AVG(co.order_value) AS avg_order_value,
        MAX(o.order_date) AS last_purchase_date
    FROM customer_orders co
    JOIN orders o
        ON co.order_id = o.order_id
    GROUP BY co.customer_id
),

rfm_scores AS (
    SELECT
        *,
        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS recency_days
    FROM customer_metrics
),

scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY total_orders) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary_value) AS monetary_score
    FROM rfm_scores
)

SELECT
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
    END AS customer_segment,

    ROUND(AVG(avg_order_value), 2) AS average_order_value

FROM scores
GROUP BY customer_segment
ORDER BY average_order_value DESC;


-- ============================================================
-- ANALYSIS 6: PURCHASE FREQUENCY BY SEGMENT
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MAX(o.order_date) AS last_purchase_date,
        SUM(oi.quantity * p.price) AS monetary_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
),

scores AS (
    SELECT
        *,
        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS recency_days
    FROM customer_metrics
),

rfm AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY total_orders) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary_value) AS monetary_score
    FROM scores
)

SELECT
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
    END AS customer_segment,

    COUNT(*) AS customers,
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer

FROM rfm
GROUP BY customer_segment
ORDER BY avg_orders_per_customer DESC;


-- ============================================================
-- ANALYSIS 7: REVENUE CONTRIBUTION % BY SEGMENT
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MAX(o.order_date) AS last_purchase_date,
        SUM(oi.quantity * p.price) AS monetary_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
),

scores AS (
    SELECT
        *,
        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS recency_days
    FROM customer_metrics
),

rfm AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY total_orders) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary_value) AS monetary_score
    FROM scores
),

segmented AS (
    SELECT
        *,
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
    FROM rfm
)

SELECT
    customer_segment,
    ROUND(SUM(monetary_value), 2) AS segment_revenue,

    ROUND(
        SUM(monetary_value)
        / SUM(SUM(monetary_value)) OVER ()
        * 100,
        2
    ) AS revenue_contribution_percentage

FROM segmented
GROUP BY customer_segment
ORDER BY revenue_contribution_percentage DESC;


-- ============================================================
-- ANALYSIS 8: TOP CUSTOMERS WITHIN EACH RFM SEGMENT
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MAX(o.order_date) AS last_purchase_date,
        SUM(oi.quantity * p.price) AS monetary_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
),

scores AS (
    SELECT
        *,
        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS recency_days
    FROM customer_metrics
),

rfm AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY total_orders) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary_value) AS monetary_score
    FROM scores
),

segmented AS (
    SELECT
        *,
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
    FROM rfm
),

ranked_customers AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_segment
            ORDER BY monetary_value DESC
        ) AS segment_rank
    FROM segmented
)

SELECT
    customer_segment,
    customer_id,
    total_orders,
    monetary_value,
    segment_rank
FROM ranked_customers
WHERE segment_rank <= 5
ORDER BY customer_segment, segment_rank;


-- ============================================================
-- ANALYSIS 9: CHAMPION SEGMENT PERFORMANCE
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MAX(o.order_date) AS last_purchase_date,
        SUM(oi.quantity * p.price) AS monetary_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
),

scores AS (
    SELECT
        *,
        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS recency_days
    FROM customer_metrics
),

rfm AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY total_orders) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary_value) AS monetary_score
    FROM scores
)

SELECT
    COUNT(*) AS champion_customers,
    SUM(monetary_value) AS champion_revenue,
    ROUND(AVG(monetary_value), 2) AS avg_champion_revenue,
    ROUND(AVG(total_orders), 2) AS avg_champion_orders

FROM rfm

WHERE recency_score >= 4
  AND frequency_score >= 4
  AND monetary_score >= 4;


-- ============================================================
-- ANALYSIS 10: AT-RISK SEGMENT REVENUE ANALYSIS
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MAX(o.order_date) AS last_purchase_date,
        SUM(oi.quantity * p.price) AS monetary_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
),

scores AS (
    SELECT
        *,
        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS recency_days
    FROM customer_metrics
),

rfm AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY total_orders) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary_value) AS monetary_score
    FROM scores
)

SELECT
    COUNT(*) AS at_risk_customers,
    SUM(monetary_value) AS at_risk_revenue,
    ROUND(AVG(monetary_value), 2) AS avg_at_risk_revenue,
    ROUND(AVG(total_orders), 2) AS avg_at_risk_orders

FROM rfm

WHERE recency_score <= 2
  AND frequency_score >= 3;


-- ============================================================
-- ANALYSIS 11: SEGMENT PERFORMANCE RANKING
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MAX(o.order_date) AS last_purchase_date,
        SUM(oi.quantity * p.price) AS monetary_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
),

scores AS (
    SELECT
        *,
        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS recency_days
    FROM customer_metrics
),

rfm AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY total_orders) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary_value) AS monetary_score
    FROM scores
),

segmented AS (
    SELECT
        *,
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
    FROM rfm
),

segment_summary AS (
    SELECT
        customer_segment,
        COUNT(*) AS customer_count,
        SUM(monetary_value) AS total_revenue,
        AVG(monetary_value) AS avg_revenue
    FROM segmented
    GROUP BY customer_segment
)

SELECT
    customer_segment,
    customer_count,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(avg_revenue, 2) AS avg_revenue_per_customer,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank

FROM segment_summary
ORDER BY revenue_rank;


-- ============================================================
-- ANALYSIS 12: FINAL CUSTOMER SEGMENT BUSINESS SUMMARY
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MAX(o.order_date) AS last_purchase_date,
        SUM(oi.quantity * p.price) AS monetary_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
),

scores AS (
    SELECT
        *,
        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS recency_days
    FROM customer_metrics
),

rfm AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY total_orders) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary_value) AS monetary_score
    FROM scores
),

segmented AS (
    SELECT
        *,
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
    FROM rfm
)

SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    SUM(total_orders) AS total_orders,
    ROUND(SUM(monetary_value), 2) AS total_revenue,
    ROUND(AVG(monetary_value), 2) AS avg_customer_revenue,
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer,
    ROUND(
        SUM(monetary_value)
        / SUM(SUM(monetary_value)) OVER ()
        * 100,
        2
    ) AS revenue_contribution_percentage

FROM segmented
GROUP BY customer_segment
ORDER BY total_revenue DESC;