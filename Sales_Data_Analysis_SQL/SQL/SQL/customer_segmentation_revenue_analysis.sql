USE sales_analysis_db;

-- ============================================================
-- DAY 30
-- CUSTOMER SEGMENTATION & REVENUE ANALYSIS
-- ============================================================


-- ============================================================
-- 1. CUSTOMER PURCHASE SUMMARY
-- ============================================================

WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.customer_name,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.quantity) AS total_units_purchased,

        SUM(oi.quantity * p.price) AS total_revenue

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
    total_orders,
    total_units_purchased,
    ROUND(total_revenue, 2) AS total_revenue

FROM customer_summary

ORDER BY total_revenue DESC;


-- ============================================================
-- 2. CUSTOMER AVERAGE ORDER VALUE
-- ============================================================

WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.customer_name,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.quantity * p.price) AS total_revenue

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
    total_orders,

    ROUND(total_revenue, 2) AS total_revenue,

    ROUND(
        total_revenue / NULLIF(total_orders, 0),
        2
    ) AS average_order_value

FROM customer_summary

ORDER BY average_order_value DESC;


-- ============================================================
-- 3. CUSTOMER REVENUE RANKING
-- ============================================================

WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(oi.quantity * p.price) AS total_revenue

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

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank

FROM customer_summary

ORDER BY revenue_rank;


-- ============================================================
-- 4. CUSTOMER REVENUE CONTRIBUTION
-- ============================================================

WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(oi.quantity * p.price) AS total_revenue

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

    ROUND(
        total_revenue /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100,
        2
    ) AS revenue_contribution_percent

FROM customer_summary

ORDER BY total_revenue DESC;


-- ============================================================
-- 5. CUSTOMER SEGMENTATION BY REVENUE
-- ============================================================

WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(oi.quantity * p.price) AS total_revenue

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

    CASE
        WHEN total_revenue >= 10000 THEN 'High Value'
        WHEN total_revenue >= 5000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment

FROM customer_summary

ORDER BY total_revenue DESC;


-- ============================================================
-- 6. CUSTOMER SEGMENT DISTRIBUTION
-- ============================================================

WITH customer_summary AS (
    SELECT
        c.customer_id,

        SUM(oi.quantity * p.price) AS total_revenue

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY
        c.customer_id
),

segmented_customers AS (
    SELECT
        customer_id,
        total_revenue,

        CASE
            WHEN total_revenue >= 10000 THEN 'High Value'
            WHEN total_revenue >= 5000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment

    FROM customer_summary
)

SELECT
    customer_segment,

    COUNT(*) AS customer_count,

    ROUND(SUM(total_revenue), 2) AS segment_revenue,

    ROUND(AVG(total_revenue), 2) AS average_segment_revenue

FROM segmented_customers

GROUP BY customer_segment

ORDER BY segment_revenue DESC;


-- ============================================================
-- 7. CUSTOMER REVENUE + ORDER FREQUENCY ANALYSIS
-- ============================================================

WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.customer_name,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.quantity) AS total_units_purchased,

        SUM(oi.quantity * p.price) AS total_revenue

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

    total_orders,

    total_units_purchased,

    ROUND(total_revenue, 2) AS total_revenue,

    ROUND(
        total_revenue / NULLIF(total_orders, 0),
        2
    ) AS average_order_value,

    CASE
        WHEN total_orders >= 10 THEN 'Frequent Customer'
        WHEN total_orders >= 5 THEN 'Regular Customer'
        ELSE 'Occasional Customer'
    END AS purchase_frequency_segment

FROM customer_summary

ORDER BY total_orders DESC, total_revenue DESC;


-- ============================================================
-- 8. TOP 20% CUSTOMERS BY REVENUE
-- ============================================================

WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(oi.quantity * p.price) AS total_revenue

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
),

ranked_customers AS (
    SELECT
        customer_id,
        customer_name,
        total_revenue,

        NTILE(5) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_group

    FROM customer_summary
)

SELECT
    customer_id,
    customer_name,

    ROUND(total_revenue, 2) AS total_revenue,

    revenue_group

FROM ranked_customers

WHERE revenue_group = 1

ORDER BY total_revenue DESC;


-- ============================================================
-- 9. FINAL CUSTOMER BUSINESS REPORT
-- ============================================================

WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.customer_name,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.quantity) AS total_units_purchased,

        SUM(oi.quantity * p.price) AS total_revenue

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
),

customer_analysis AS (
    SELECT
        customer_id,
        customer_name,

        total_orders,

        total_units_purchased,

        total_revenue,

        ROUND(
            total_revenue / NULLIF(total_orders, 0),
            2
        ) AS average_order_value,

        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank,

        ROUND(
            total_revenue /
            NULLIF(SUM(total_revenue) OVER (), 0) * 100,
            2
        ) AS revenue_contribution_percent

    FROM customer_summary
)

SELECT
    customer_id,
    customer_name,
    total_orders,
    total_units_purchased,

    ROUND(total_revenue, 2) AS total_revenue,

    average_order_value,

    revenue_rank,

    revenue_contribution_percent,

    CASE
        WHEN total_revenue >= 10000 THEN 'High Value'
        WHEN total_revenue >= 5000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment

FROM customer_analysis

ORDER BY revenue_rank;