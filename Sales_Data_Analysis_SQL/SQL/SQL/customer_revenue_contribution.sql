USE sales_analysis_db;

-- ============================================================
-- DAY 26
-- CUSTOMER REVENUE CONTRIBUTION ANALYSIS
-- ============================================================

-- ============================================================
-- 1. CUSTOMER REVENUE
-- ============================================================

WITH customer_revenue AS (
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
    ROUND(total_revenue, 2) AS total_revenue
FROM customer_revenue
ORDER BY total_revenue DESC;


-- ============================================================
-- 2. CUSTOMER REVENUE RANKING
-- ============================================================

WITH customer_revenue AS (
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

FROM customer_revenue
ORDER BY revenue_rank;


-- ============================================================
-- 3. CUSTOMER REVENUE CONTRIBUTION %
-- ============================================================

WITH customer_revenue AS (
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
        SUM(total_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_percent

FROM customer_revenue
ORDER BY total_revenue DESC;


-- ============================================================
-- 4. CUMULATIVE REVENUE CONTRIBUTION
-- ============================================================

WITH customer_revenue AS (
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
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS cumulative_revenue,

    ROUND(
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        )
        /
        SUM(total_revenue) OVER () * 100,
        2
    ) AS cumulative_revenue_percent

FROM customer_revenue
ORDER BY total_revenue DESC;


-- ============================================================
-- 5. CUSTOMER REVENUE SEGMENTATION
-- ============================================================

WITH customer_revenue AS (
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

FROM customer_revenue
ORDER BY total_revenue DESC;


-- ============================================================
-- 6. TOP 20% CUSTOMERS BY REVENUE
-- ============================================================

WITH customer_revenue AS (
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

    FROM customer_revenue
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
-- 7. CUSTOMER CONTRIBUTION SUMMARY
-- ============================================================

WITH customer_revenue AS (
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
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_customer_revenue,
    ROUND(MAX(total_revenue), 2) AS highest_customer_revenue,
    ROUND(MIN(total_revenue), 2) AS lowest_customer_revenue
FROM customer_revenue;


-- ============================================================
-- 8. CUSTOMER REVENUE BUSINESS REPORT
-- ============================================================

WITH customer_revenue AS (
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

customer_analysis AS (
    SELECT
        customer_id,
        customer_name,
        total_revenue,

        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank,

        ROUND(
            total_revenue /
            SUM(total_revenue) OVER () * 100,
            2
        ) AS contribution_percent,

        CASE
            WHEN total_revenue >= 10000 THEN 'High Value'
            WHEN total_revenue >= 5000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment

    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,
    ROUND(total_revenue, 2) AS total_revenue,
    revenue_rank,
    contribution_percent,
    customer_segment
FROM customer_analysis
ORDER BY revenue_rank;