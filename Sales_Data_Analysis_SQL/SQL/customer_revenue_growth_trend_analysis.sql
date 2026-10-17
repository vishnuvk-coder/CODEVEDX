
USE sales_analysis_db;

-- DAY 77: CUSTOMER REVENUE GROWTH AND TREND ANALYSIS
-- Revenue is calculated using quantity * current product price.

-- 1. Calculate monthly revenue for each customer
WITH monthly_customer_revenue AS (
    SELECT
        o.customer_id,
        DATE_FORMAT(o.order_date, '%Y-%m') AS revenue_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.customer_id,
        DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT
    customer_id,
    revenue_month,
    monthly_revenue
FROM monthly_customer_revenue
ORDER BY customer_id, revenue_month;


-- 2. Compare monthly revenue with the previous month
WITH monthly_customer_revenue AS (
    SELECT
        o.customer_id,
        DATE_FORMAT(o.order_date, '%Y-%m') AS revenue_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.customer_id,
        DATE_FORMAT(o.order_date, '%Y-%m')
),
revenue_comparison AS (
    SELECT
        customer_id,
        revenue_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            PARTITION BY customer_id
            ORDER BY revenue_month
        ) AS previous_month_revenue
    FROM monthly_customer_revenue
)
SELECT
    customer_id,
    revenue_month,
    monthly_revenue,
    previous_month_revenue,
    monthly_revenue - previous_month_revenue
        AS revenue_change
FROM revenue_comparison
ORDER BY customer_id, revenue_month;


-- 3. Calculate month-over-month revenue growth percentage
WITH monthly_customer_revenue AS (
    SELECT
        o.customer_id,
        DATE_FORMAT(o.order_date, '%Y-%m') AS revenue_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.customer_id,
        DATE_FORMAT(o.order_date, '%Y-%m')
),
revenue_comparison AS (
    SELECT
        customer_id,
        revenue_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            PARTITION BY customer_id
            ORDER BY revenue_month
        ) AS previous_month_revenue
    FROM monthly_customer_revenue
)
SELECT
    customer_id,
    revenue_month,
    monthly_revenue,
    previous_month_revenue,
    ROUND(
        monthly_revenue - previous_month_revenue, 2
    ) AS revenue_change,
    ROUND(
        100.0 * (monthly_revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS growth_percentage
FROM revenue_comparison
ORDER BY customer_id, revenue_month;


-- 4. Classify customer revenue trends
WITH monthly_customer_revenue AS (
    SELECT
        o.customer_id,
        DATE_FORMAT(o.order_date, '%Y-%m') AS revenue_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.customer_id,
        DATE_FORMAT(o.order_date, '%Y-%m')
),
revenue_comparison AS (
    SELECT
        customer_id,
        revenue_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            PARTITION BY customer_id
            ORDER BY revenue_month
        ) AS previous_month_revenue
    FROM monthly_customer_revenue
)
SELECT
    customer_id,
    revenue_month,
    monthly_revenue,
    previous_month_revenue,
    CASE
        WHEN previous_month_revenue IS NULL
            THEN 'No Previous Month'
        WHEN monthly_revenue > previous_month_revenue
            THEN 'Growing'
        WHEN monthly_revenue < previous_month_revenue
            THEN 'Declining'
        ELSE 'Stable'
    END AS revenue_trend
FROM revenue_comparison
ORDER BY customer_id, revenue_month;


-- 5. Summarize revenue changes by month
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS revenue_month,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
),
monthly_comparison AS (
    SELECT
        revenue_month,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY revenue_month
        ) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    revenue_month,
    total_revenue,
    previous_month_revenue,
    ROUND(
        total_revenue - previous_month_revenue, 2
    ) AS revenue_change,
    ROUND(
        100.0 * (total_revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS growth_percentage
FROM monthly_comparison
ORDER BY revenue_month;


-- 6. Identify customers whose latest recorded revenue
-- is lower than their previous recorded month
WITH monthly_customer_revenue AS (
    SELECT
        o.customer_id,
        DATE_FORMAT(o.order_date, '%Y-%m') AS revenue_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.customer_id,
        DATE_FORMAT(o.order_date, '%Y-%m')
),
revenue_comparison AS (
    SELECT
        customer_id,
        revenue_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            PARTITION BY customer_id
            ORDER BY revenue_month
        ) AS previous_month_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY revenue_month DESC
        ) AS month_recency_rank
    FROM monthly_customer_revenue
)
SELECT
    customer_id,
    revenue_month AS latest_revenue_month,
    monthly_revenue AS latest_month_revenue,
    previous_month_revenue,
    ROUND(
        monthly_revenue - previous_month_revenue, 2
    ) AS revenue_change
FROM revenue_comparison
WHERE month_recency_rank = 1
  AND previous_month_revenue IS NOT NULL
  AND monthly_revenue < previous_month_revenue
ORDER BY revenue_change;
