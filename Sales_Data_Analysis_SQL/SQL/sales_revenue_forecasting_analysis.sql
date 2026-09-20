USE sales_analysis_db;

-- ============================================================
-- DAY 50
-- SALES REVENUE FORECASTING & FUTURE PROJECTION
-- ============================================================
--
-- Purpose:
-- Analyze historical monthly sales performance and create
-- simple SQL-based baseline projections for future revenue.
--
-- IMPORTANT:
-- Revenue = order_items.quantity * products.price
--
-- These projections are baseline business estimates.
-- They are NOT statistical or machine-learning forecasts.
-- ============================================================


-- ============================================================
-- QUERY 01
-- MONTHLY HISTORICAL REVENUE
-- ============================================================

WITH monthly_sales AS
(
    SELECT
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE) AS sales_month,
        ROUND(SUM(oi.quantity * p.price), 2) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE)
)
SELECT
    DATE_FORMAT(sales_month, '%Y-%m') AS sales_month,
    monthly_revenue
FROM monthly_sales
ORDER BY sales_month;


-- ============================================================
-- QUERY 02
-- MONTHLY ORDER VOLUME
-- ============================================================

WITH monthly_orders AS
(
    SELECT
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE) AS sales_month,
        COUNT(DISTINCT o.order_id) AS monthly_orders
    FROM orders o
    GROUP BY
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE)
)
SELECT
    DATE_FORMAT(sales_month, '%Y-%m') AS sales_month,
    monthly_orders
FROM monthly_orders
ORDER BY sales_month;


-- ============================================================
-- QUERY 03
-- MONTHLY UNITS SOLD
-- ============================================================

WITH monthly_units AS
(
    SELECT
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE) AS sales_month,
        SUM(oi.quantity) AS monthly_units_sold
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE)
)
SELECT
    DATE_FORMAT(sales_month, '%Y-%m') AS sales_month,
    monthly_units_sold
FROM monthly_units
ORDER BY sales_month;


-- ============================================================
-- QUERY 04
-- PREVIOUS-MONTH REVENUE
-- ============================================================

WITH monthly_sales AS
(
    SELECT
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE) AS sales_month,
        ROUND(SUM(oi.quantity * p.price), 2) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE)
)
SELECT
    DATE_FORMAT(sales_month, '%Y-%m') AS sales_month,
    monthly_revenue,
    LAG(monthly_revenue) OVER
    (
        ORDER BY sales_month
    ) AS previous_month_revenue
FROM monthly_sales
ORDER BY sales_month;


-- ============================================================
-- QUERY 05
-- MONTH-OVER-MONTH REVENUE GROWTH
-- ============================================================

WITH monthly_sales AS
(
    SELECT
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE) AS sales_month,
        ROUND(SUM(oi.quantity * p.price), 2) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE)
),
revenue_growth AS
(
    SELECT
        sales_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER
        (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    DATE_FORMAT(sales_month, '%Y-%m') AS sales_month,
    monthly_revenue,
    previous_month_revenue,
    ROUND(
        monthly_revenue - previous_month_revenue,
        2
    ) AS revenue_change,
    ROUND(
        (
            (monthly_revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
        ) * 100,
        2
    ) AS mom_growth_percentage
FROM revenue_growth
ORDER BY sales_month;


-- ============================================================
-- QUERY 06
-- 3-MONTH MOVING AVERAGE REVENUE
-- ============================================================

WITH monthly_sales AS
(
    SELECT
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE) AS sales_month,
        ROUND(SUM(oi.quantity * p.price), 2) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE)
)
SELECT
    DATE_FORMAT(sales_month, '%Y-%m') AS sales_month,
    monthly_revenue,
    ROUND(
        AVG(monthly_revenue) OVER
        (
            ORDER BY sales_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS three_month_moving_average
FROM monthly_sales
ORDER BY sales_month;


-- ============================================================
-- QUERY 07
-- 3-MONTH MOVING AVERAGE ORDER VOLUME
-- ============================================================

WITH monthly_orders AS
(
    SELECT
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE) AS sales_month,
        COUNT(DISTINCT o.order_id) AS monthly_orders
    FROM orders o
    GROUP BY
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE)
)
SELECT
    DATE_FORMAT(sales_month, '%Y-%m') AS sales_month,
    monthly_orders,
    ROUND(
        AVG(monthly_orders) OVER
        (
            ORDER BY sales_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS three_month_moving_average_orders
FROM monthly_orders
ORDER BY sales_month;


-- ============================================================
-- QUERY 08
-- MONTHLY REVENUE TREND CLASSIFICATION
-- ============================================================

WITH monthly_sales AS
(
    SELECT
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE) AS sales_month,
        ROUND(SUM(oi.quantity * p.price), 2) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE)
),
revenue_growth AS
(
    SELECT
        sales_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER
        (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
),
growth_analysis AS
(
    SELECT
        sales_month,
        monthly_revenue,
        previous_month_revenue,
        ROUND(
            (
                (monthly_revenue - previous_month_revenue)
                / NULLIF(previous_month_revenue, 0)
            ) * 100,
            2
        ) AS mom_growth_percentage
    FROM revenue_growth
)
SELECT
    DATE_FORMAT(sales_month, '%Y-%m') AS sales_month,
    monthly_revenue,
    previous_month_revenue,
    mom_growth_percentage,
    CASE
        WHEN previous_month_revenue IS NULL
            THEN 'Baseline Month'
        WHEN mom_growth_percentage > 5
            THEN 'Strong Growth'
        WHEN mom_growth_percentage > 0
            THEN 'Growth'
        WHEN mom_growth_percentage = 0
            THEN 'Stable'
        WHEN mom_growth_percentage >= -5
            THEN 'Decline'
        ELSE 'Strong Decline'
    END AS revenue_trend
FROM growth_analysis
ORDER BY sales_month;


-- ============================================================
-- QUERY 09
-- AVERAGE HISTORICAL MONTHLY REVENUE
-- ============================================================

WITH monthly_sales AS
(
    SELECT
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE) AS sales_month,
        ROUND(SUM(oi.quantity * p.price), 2) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE)
)
SELECT
    COUNT(*) AS historical_months,
    ROUND(AVG(monthly_revenue), 2) AS average_monthly_revenue,
    ROUND(MIN(monthly_revenue), 2) AS minimum_monthly_revenue,
    ROUND(MAX(monthly_revenue), 2) AS maximum_monthly_revenue
FROM monthly_sales;


-- ============================================================
-- QUERY 10
-- NEXT-MONTH REVENUE PROJECTION
-- USING HISTORICAL AVERAGE
-- ============================================================

WITH monthly_sales AS
(
    SELECT
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE) AS sales_month,
        ROUND(SUM(oi.quantity * p.price), 2) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE)
),
forecast_base AS
(
    SELECT
        MAX(sales_month) AS latest_month,
        AVG(monthly_revenue) AS historical_average_revenue
    FROM monthly_sales
)
SELECT
    DATE_FORMAT(
        DATE_ADD(latest_month, INTERVAL 1 MONTH),
        '%Y-%m'
    ) AS forecast_month,
    ROUND(historical_average_revenue, 2)
        AS projected_revenue_historical_average
FROM forecast_base;


-- ============================================================
-- QUERY 11
-- NEXT-MONTH REVENUE PROJECTION
-- USING RECENT 3-MONTH AVERAGE
-- ============================================================

WITH monthly_sales AS
(
    SELECT
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE) AS sales_month,
        ROUND(SUM(oi.quantity * p.price), 2) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE)
),
recent_three_months AS
(
    SELECT
        sales_month,
        monthly_revenue
    FROM monthly_sales
    ORDER BY sales_month DESC
    LIMIT 3
),
forecast_base AS
(
    SELECT
        MAX(sales_month) AS latest_month,
        AVG(monthly_revenue) AS recent_three_month_average
    FROM recent_three_months
)
SELECT
    DATE_FORMAT(
        DATE_ADD(latest_month, INTERVAL 1 MONTH),
        '%Y-%m'
    ) AS forecast_month,
    ROUND(recent_three_month_average, 2)
        AS projected_revenue_recent_3_month_average
FROM forecast_base;


-- ============================================================
-- QUERY 12
-- FINAL SALES FORECASTING SUMMARY
-- ============================================================

WITH monthly_sales AS
(
    SELECT
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE) AS sales_month,
        ROUND(SUM(oi.quantity * p.price), 2) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE)
),
revenue_growth AS
(
    SELECT
        sales_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER
        (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
),
recent_three_months AS
(
    SELECT
        sales_month,
        monthly_revenue
    FROM monthly_sales
    ORDER BY sales_month DESC
    LIMIT 3
),
latest_month_data AS
(
    SELECT
        sales_month AS latest_month,
        monthly_revenue AS latest_month_revenue,
        previous_month_revenue
    FROM revenue_growth
    ORDER BY sales_month DESC
    LIMIT 1
),
overall_average AS
(
    SELECT
        AVG(monthly_revenue) AS historical_average_revenue
    FROM monthly_sales
),
recent_average AS
(
    SELECT
        AVG(monthly_revenue) AS recent_three_month_average
    FROM recent_three_months
)
SELECT
    DATE_FORMAT(
        l.latest_month,
        '%Y-%m'
    ) AS latest_month,

    ROUND(
        l.latest_month_revenue,
        2
    ) AS latest_month_revenue,

    ROUND(
        l.previous_month_revenue,
        2
    ) AS previous_month_revenue,

    ROUND(
        (
            (l.latest_month_revenue - l.previous_month_revenue)
            / NULLIF(l.previous_month_revenue, 0)
        ) * 100,
        2
    ) AS latest_mom_growth_percentage,

    ROUND(
        o.historical_average_revenue,
        2
    ) AS historical_average_revenue,

    ROUND(
        r.recent_three_month_average,
        2
    ) AS recent_three_month_average,

    ROUND(
        r.recent_three_month_average
        - o.historical_average_revenue,
        2
    ) AS forecast_difference,

    CASE
        WHEN r.recent_three_month_average
             > o.historical_average_revenue
            THEN 'Recent Trend Above Historical Average'

        WHEN r.recent_three_month_average
             < o.historical_average_revenue
            THEN 'Recent Trend Below Historical Average'

        ELSE 'Recent Trend Matches Historical Average'
    END AS forecast_trend_summary

FROM latest_month_data l
CROSS JOIN overall_average o
CROSS JOIN recent_average r;