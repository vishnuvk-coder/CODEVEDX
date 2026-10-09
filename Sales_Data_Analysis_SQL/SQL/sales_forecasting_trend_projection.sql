USE sales_analysis_db;

-- =========================================================
-- DAY 69: SALES FORECASTING & TREND PROJECTION
-- =========================================================

-- 1. Monthly Sales Revenue
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
)
SELECT sales_month, ROUND(revenue, 2) AS monthly_revenue
FROM monthly_sales
ORDER BY sales_month;


-- 2. Monthly Order Count
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
ORDER BY sales_month;


-- 3. Monthly Units Sold
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
    SUM(oi.quantity) AS units_sold
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
ORDER BY sales_month;


-- 4. Average Order Value by Month
WITH order_revenue AS (
    SELECT
        o.order_id,
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
        SUM(oi.quantity * p.price) AS order_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY o.order_id, DATE_FORMAT(o.order_date, '%Y-%m-01')
)
SELECT
    sales_month,
    ROUND(AVG(order_revenue), 2) AS average_order_value
FROM order_revenue
GROUP BY sales_month
ORDER BY sales_month;


-- 5. Previous-Month Revenue
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS current_revenue,
    ROUND(LAG(revenue) OVER (ORDER BY sales_month), 2)
        AS previous_available_month_revenue
FROM monthly_sales
ORDER BY sales_month;


-- 6. Month-over-Month Revenue Change
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
),
revenue_comparison AS (
    SELECT
        sales_month,
        revenue,
        LAG(revenue) OVER (ORDER BY sales_month) AS previous_revenue
    FROM monthly_sales
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS current_revenue,
    ROUND(previous_revenue, 2) AS previous_revenue,
    ROUND(revenue - previous_revenue, 2) AS revenue_change
FROM revenue_comparison
ORDER BY sales_month;


-- 7. Month-over-Month Revenue Growth Percentage
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
),
revenue_comparison AS (
    SELECT
        sales_month,
        revenue,
        LAG(revenue) OVER (ORDER BY sales_month) AS previous_revenue
    FROM monthly_sales
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS current_revenue,
    ROUND(previous_revenue, 2) AS previous_revenue,
    ROUND(
        100.0 * (revenue - previous_revenue)
        / NULLIF(previous_revenue, 0),
        2
    ) AS growth_percentage
FROM revenue_comparison
ORDER BY sales_month;


-- 8. Three-Month Moving Average Revenue
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND(
        AVG(revenue) OVER (
            ORDER BY sales_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS three_month_moving_average
FROM monthly_sales
ORDER BY sales_month;


-- 9. Six-Month Moving Average Revenue
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND(
        AVG(revenue) OVER (
            ORDER BY sales_month
            ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS six_month_moving_average
FROM monthly_sales
ORDER BY sales_month;


-- 10. Monthly Revenue Trend Classification
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
),
revenue_comparison AS (
    SELECT
        sales_month,
        revenue,
        LAG(revenue) OVER (ORDER BY sales_month) AS previous_revenue
    FROM monthly_sales
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS monthly_revenue,
    CASE
        WHEN previous_revenue IS NULL THEN 'No Previous Month'
        WHEN revenue > previous_revenue THEN 'Growing'
        WHEN revenue < previous_revenue THEN 'Declining'
        ELSE 'Stable'
    END AS revenue_trend
FROM revenue_comparison
ORDER BY sales_month;


-- 11. Highest-Revenue Month
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
),
ranked_sales AS (
    SELECT
        sales_month,
        revenue,
        RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
    FROM monthly_sales
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS monthly_revenue
FROM ranked_sales
WHERE revenue_rank = 1
ORDER BY sales_month;


-- 12. Lowest-Revenue Month
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
),
ranked_sales AS (
    SELECT
        sales_month,
        revenue,
        RANK() OVER (ORDER BY revenue ASC) AS revenue_rank
    FROM monthly_sales
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS monthly_revenue
FROM ranked_sales
WHERE revenue_rank = 1
ORDER BY sales_month;


-- 13. Revenue Volatility Overview
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
)
SELECT
    COUNT(*) AS months_with_sales,
    ROUND(AVG(revenue), 2) AS average_monthly_revenue,
    ROUND(MIN(revenue), 2) AS minimum_monthly_revenue,
    ROUND(MAX(revenue), 2) AS maximum_monthly_revenue,
    ROUND(STDDEV_POP(revenue), 2) AS revenue_standard_deviation
FROM monthly_sales;


-- 14. Baseline Next-Month Revenue Projection
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
),
recent_months AS (
    SELECT
        sales_month,
        revenue,
        ROW_NUMBER() OVER (ORDER BY sales_month DESC) AS month_rank
    FROM monthly_sales
),
forecast AS (
    SELECT
        AVG(revenue) AS projected_revenue,
        MAX(sales_month) AS last_observed_month,
        COUNT(*) AS months_used
    FROM recent_months
    WHERE month_rank <= 3
)
SELECT
    last_observed_month,
    DATE_FORMAT(
        DATE_ADD(
            STR_TO_DATE(last_observed_month, '%Y-%m-%d'),
            INTERVAL 1 MONTH
        ),
        '%Y-%m'
    ) AS forecast_month,
    months_used,
    ROUND(projected_revenue, 2) AS baseline_projected_revenue
FROM forecast
WHERE months_used = 3;


-- 15. Final Sales Forecasting Summary
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
),
monthly_metrics AS (
    SELECT
        sales_month,
        revenue,
        LAG(revenue) OVER (ORDER BY sales_month) AS previous_revenue,
        AVG(revenue) OVER (
            ORDER BY sales_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS moving_average_3_months
    FROM monthly_sales
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND(previous_revenue, 2) AS previous_revenue,
    ROUND(revenue - previous_revenue, 2) AS revenue_change,
    ROUND(
        100.0 * (revenue - previous_revenue)
        / NULLIF(previous_revenue, 0),
        2
    ) AS growth_percentage,
    ROUND(moving_average_3_months, 2) AS moving_average_3_months
FROM monthly_metrics
ORDER BY sales_month;