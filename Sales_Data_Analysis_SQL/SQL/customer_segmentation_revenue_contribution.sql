
-- ============================================================
-- Day 72: Customer Segmentation & Revenue Contribution Analysis
-- Database: sales_analysis_db
-- MySQL 8.0+
-- ============================================================

USE sales_analysis_db;

-- ============================================================
-- QUERY 1: Customer Purchase and Revenue Summary
-- ============================================================

SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(SUM(oi.quantity), 0) AS total_units_purchased,
    ROUND(
        COALESCE(SUM(oi.quantity * p.price), 0), 2
    ) AS total_revenue,
    ROUND(
        COALESCE(SUM(oi.quantity * p.price), 0)
        / NULLIF(COUNT(DISTINCT o.order_id), 0), 2
    ) AS average_order_value
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
-- QUERY 2: Revenue-Based Customer Segmentation
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        COALESCE(
            SUM(oi.quantity * p.price), 0
        ) AS total_revenue
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
        customer_id,
        total_revenue,
        NTILE(3) OVER (
            ORDER BY total_revenue DESC, customer_id
        ) AS revenue_group
    FROM customer_revenue
    WHERE total_revenue > 0
)
SELECT
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,
    CASE revenue_group
        WHEN 1 THEN 'High Value'
        WHEN 2 THEN 'Medium Value'
        WHEN 3 THEN 'Low Value'
    END AS customer_segment
FROM ranked_customers
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 3: Customer Revenue Contribution Percentage
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        COALESCE(
            SUM(oi.quantity * p.price), 0
        ) AS total_revenue
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
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        100.0 * total_revenue
        / NULLIF(SUM(total_revenue) OVER (), 0),
        2
    ) AS revenue_contribution_pct
FROM customer_revenue
WHERE total_revenue > 0
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 4: Rank Customers by Total Revenue
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        COALESCE(
            SUM(oi.quantity * p.price), 0
        ) AS total_revenue
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
    ROUND(total_revenue, 2) AS total_revenue,
    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM customer_revenue
WHERE total_revenue > 0
ORDER BY revenue_rank, customer_id;


-- ============================================================
-- QUERY 5: Cumulative Revenue Contribution
-- ============================================================

WITH customer_revenue AS (
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
    GROUP BY c.customer_id
),
contribution AS (
    SELECT
        customer_id,
        total_revenue,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC, customer_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,
        SUM(total_revenue) OVER () AS overall_revenue
    FROM customer_revenue
)
SELECT
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(cumulative_revenue, 2) AS cumulative_revenue,
    ROUND(
        100.0 * cumulative_revenue
        / NULLIF(overall_revenue, 0),
        2
    ) AS cumulative_revenue_pct
FROM contribution
ORDER BY total_revenue DESC, customer_id;


-- ============================================================
-- QUERY 6: Revenue Summary by Customer Segment
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        COALESCE(
            SUM(oi.quantity * p.price), 0
        ) AS total_revenue
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
        customer_id,
        total_revenue,
        NTILE(3) OVER (
            ORDER BY total_revenue DESC, customer_id
        ) AS revenue_group
    FROM customer_revenue
    WHERE total_revenue > 0
),
segmented_customers AS (
    SELECT
        customer_id,
        total_revenue,
        CASE revenue_group
            WHEN 1 THEN 'High Value'
            WHEN 2 THEN 'Medium Value'
            WHEN 3 THEN 'Low Value'
        END AS customer_segment
    FROM ranked_customers
)
SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(total_revenue), 2) AS segment_revenue,
    ROUND(AVG(total_revenue), 2) AS average_customer_revenue
FROM segmented_customers
GROUP BY customer_segment
ORDER BY
    CASE customer_segment
        WHEN 'High Value' THEN 1
        WHEN 'Medium Value' THEN 2
        WHEN 'Low Value' THEN 3
    END;


-- ============================================================
-- QUERY 7: Segment Share of Total Revenue
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        COALESCE(
            SUM(oi.quantity * p.price), 0
        ) AS total_revenue
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
        customer_id,
        total_revenue,
        NTILE(3) OVER (
            ORDER BY total_revenue DESC, customer_id
        ) AS revenue_group
    FROM customer_revenue
    WHERE total_revenue > 0
),
segment_totals AS (
    SELECT
        CASE revenue_group
            WHEN 1 THEN 'High Value'
            WHEN 2 THEN 'Medium Value'
            WHEN 3 THEN 'Low Value'
        END AS customer_segment,
        SUM(total_revenue) AS segment_revenue
    FROM ranked_customers
    GROUP BY revenue_group
)
SELECT
    customer_segment,
    ROUND(segment_revenue, 2) AS segment_revenue,
    ROUND(
        100.0 * segment_revenue
        / NULLIF(SUM(segment_revenue) OVER (), 0),
        2
    ) AS revenue_share_pct
FROM segment_totals
ORDER BY revenue_share_pct DESC;


-- ============================================================
-- QUERY 8: Top 10 Revenue-Contributing Customers
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COALESCE(
            SUM(oi.quantity), 0
        ) AS total_units_purchased,
        COALESCE(
            SUM(oi.quantity * p.price), 0
        ) AS total_revenue
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
        customer_id,
        total_orders,
        total_units_purchased,
        total_revenue,
        DENSE_RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM customer_revenue
    WHERE total_revenue > 0
)
SELECT
    customer_id,
    total_orders,
    total_units_purchased,
    ROUND(total_revenue, 2) AS total_revenue,
    revenue_rank
FROM ranked_customers
WHERE revenue_rank <= 10
ORDER BY revenue_rank, customer_id;
