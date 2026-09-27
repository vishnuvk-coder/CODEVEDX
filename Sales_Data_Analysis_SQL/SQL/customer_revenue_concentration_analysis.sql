USE sales_analysis_db;

-- ============================================================
-- DAY 57: CUSTOMER REVENUE CONCENTRATION & PARETO ANALYSIS
-- ============================================================

-- 1. Total Revenue per Customer
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


-- 2. Customer Revenue Ranking
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


-- 3. Customer Revenue Contribution Percentage
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
    ) AS revenue_contribution_percentage
FROM customer_revenue
ORDER BY total_revenue DESC;


-- 4. Cumulative Revenue Contribution
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
        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,
        SUM(total_revenue) OVER () AS overall_revenue
    FROM customer_revenue
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_revenue, 2) AS total_revenue,
    revenue_rank,
    ROUND(
        total_revenue / overall_revenue * 100,
        2
    ) AS revenue_contribution_percentage,
    ROUND(
        cumulative_revenue / overall_revenue * 100,
        2
    ) AS cumulative_revenue_percentage
FROM ranked_customers
ORDER BY revenue_rank;


-- 5. Customer Revenue Concentration Classification
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
        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) / SUM(total_revenue) OVER () * 100
            AS cumulative_revenue_percentage
    FROM customer_revenue
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_revenue, 2) AS total_revenue,
    revenue_rank,
    ROUND(cumulative_revenue_percentage, 2)
        AS cumulative_revenue_percentage,
    CASE
        WHEN cumulative_revenue_percentage <= 20
            THEN 'Top Revenue Contributors'
        WHEN cumulative_revenue_percentage <= 50
            THEN 'Major Revenue Contributors'
        WHEN cumulative_revenue_percentage <= 80
            THEN 'Core Revenue Customers'
        ELSE 'Long-Tail Customers'
    END AS revenue_concentration_segment
FROM ranked_customers
ORDER BY revenue_rank;


-- 6. Top 20% Customers
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
        ) AS customer_quintile
    FROM customer_revenue
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_revenue, 2) AS total_revenue,
    customer_quintile
FROM ranked_customers
WHERE customer_quintile = 1
ORDER BY total_revenue DESC;


-- 7. Revenue Generated by Top 20% Customers
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
        ) AS customer_quintile
    FROM customer_revenue
)
SELECT
    ROUND(SUM(total_revenue), 2) AS top_20_customer_revenue,
    ROUND(
        SUM(total_revenue) /
        (SELECT SUM(total_revenue) FROM customer_revenue) * 100,
        2
    ) AS top_20_revenue_percentage
FROM ranked_customers
WHERE customer_quintile = 1;


-- 8. Final Customer Revenue Concentration Summary
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
final_analysis AS (
    SELECT
        customer_id,
        customer_name,
        total_revenue,
        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) / SUM(total_revenue) OVER () * 100
            AS cumulative_revenue_percentage
    FROM customer_revenue
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_revenue, 2) AS total_revenue,
    revenue_rank,
    ROUND(cumulative_revenue_percentage, 2)
        AS cumulative_revenue_percentage,
    CASE
        WHEN cumulative_revenue_percentage <= 20
            THEN 'Top Revenue Contributors'
        WHEN cumulative_revenue_percentage <= 50
            THEN 'Major Revenue Contributors'
        WHEN cumulative_revenue_percentage <= 80
            THEN 'Core Revenue Customers'
        ELSE 'Long-Tail Customers'
    END AS revenue_segment
FROM final_analysis
ORDER BY revenue_rank;