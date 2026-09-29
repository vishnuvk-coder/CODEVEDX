USE sales_analysis_db;

-- ============================================================
-- DAY 59
-- Customer Revenue Decile & Revenue Distribution Analysis
-- ============================================================

-- 1. Total Revenue per Customer
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
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
SELECT *
FROM customer_revenue
ORDER BY total_revenue DESC;


-- 2. Customer Revenue Ranking and Decile
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
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
    total_units,
    total_revenue,
    ROW_NUMBER() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank,
    NTILE(10) OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_decile
FROM customer_revenue
ORDER BY revenue_rank;



-- 3. Revenue Contribution by Customer
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
    total_revenue,
    ROUND(
        total_revenue /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100,
        2
    ) AS revenue_contribution_percentage
FROM customer_revenue
ORDER BY total_revenue DESC;


-- 4. Revenue Distribution by Decile
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
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
decile_data AS (
    SELECT
        *,
        NTILE(10) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_decile
    FROM customer_revenue
)
SELECT
    revenue_decile,
    COUNT(*) AS customer_count,
    SUM(total_orders) AS total_orders,
    SUM(total_units) AS total_units,
    ROUND(SUM(total_revenue), 2) AS decile_revenue,
    ROUND(AVG(total_revenue), 2) AS average_revenue_per_customer,
    ROUND(
        SUM(total_revenue) /
        NULLIF(SUM(SUM(total_revenue)) OVER (), 0) * 100,
        2
    ) AS revenue_contribution_percentage
FROM decile_data
GROUP BY revenue_decile
ORDER BY revenue_decile;


-- 5. Average Orders and Units by Revenue Decile
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
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
decile_data AS (
    SELECT
        *,
        NTILE(10) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_decile
    FROM customer_revenue
)
SELECT
    revenue_decile,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer,
    ROUND(AVG(total_units), 2) AS avg_units_per_customer,
    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_customer
FROM decile_data
GROUP BY revenue_decile
ORDER BY revenue_decile;


-- 6. Cumulative Revenue Contribution by Decile
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
decile_data AS (
    SELECT
        *,
        NTILE(10) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_decile
    FROM customer_revenue
),
decile_summary AS (
    SELECT
        revenue_decile,
        SUM(total_revenue) AS decile_revenue
    FROM decile_data
    GROUP BY revenue_decile
)
SELECT
    revenue_decile,
    ROUND(decile_revenue, 2) AS decile_revenue,
    ROUND(
        decile_revenue /
        NULLIF(SUM(decile_revenue) OVER (), 0) * 100,
        2
    ) AS decile_revenue_percentage,
    ROUND(
        SUM(decile_revenue) OVER (
            ORDER BY revenue_decile
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(decile_revenue) OVER (), 0) * 100,
        2
    ) AS cumulative_revenue_percentage
FROM decile_summary
ORDER BY revenue_decile;


-- 7. Top Revenue Decile
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
decile_data AS (
    SELECT
        *,
        NTILE(10) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_decile
    FROM customer_revenue
)
SELECT
    customer_id,
    customer_name,
    total_revenue,
    revenue_decile
FROM decile_data
WHERE revenue_decile = 1
ORDER BY total_revenue DESC;


-- 8. Bottom Revenue Decile
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
decile_data AS (
    SELECT
        *,
        NTILE(10) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_decile
    FROM customer_revenue
)
SELECT
    customer_id,
    customer_name,
    total_revenue,
    revenue_decile
FROM decile_data
WHERE revenue_decile = 10
ORDER BY total_revenue DESC;


-- 9. Final Day 59 Revenue Decile Summary
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
decile_data AS (
    SELECT
        *,
        NTILE(10) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_decile
    FROM customer_revenue
),
decile_summary AS (
    SELECT
        revenue_decile,
        COUNT(*) AS customer_count,
        SUM(total_revenue) AS decile_revenue
    FROM decile_data
    GROUP BY revenue_decile
)
SELECT
    revenue_decile,
    customer_count,
    ROUND(decile_revenue, 2) AS decile_revenue,
    ROUND(
        customer_count /
        NULLIF(SUM(customer_count) OVER (), 0) * 100,
        2
    ) AS customer_percentage,
    ROUND(
        decile_revenue /
        NULLIF(SUM(decile_revenue) OVER (), 0) * 100,
        2
    ) AS revenue_percentage,
    ROUND(
        SUM(decile_revenue) OVER (
            ORDER BY revenue_decile
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(decile_revenue) OVER (), 0) * 100,
        2
    ) AS cumulative_revenue_percentage
FROM decile_summary
ORDER BY revenue_decile;