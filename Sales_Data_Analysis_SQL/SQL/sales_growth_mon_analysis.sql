USE sales_analysis_db;


-- =========================================================
-- DAY 48: SALES GROWTH & MONTH-OVER-MONTH PERFORMANCE
-- =========================================================


-- =========================================================
-- ANALYSIS 01
-- Monthly Revenue
-- =========================================================

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    SUM(oi.quantity * p.price) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;


-- =========================================================
-- ANALYSIS 02
-- Monthly Order Count
-- =========================================================

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;


-- =========================================================
-- ANALYSIS 03
-- Monthly Units Sold
-- =========================================================

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    SUM(oi.quantity) AS total_units_sold
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;


-- =========================================================
-- ANALYSIS 04
-- Monthly Revenue with Previous Month Revenue
-- =========================================================

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)

SELECT
    sales_month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (
        ORDER BY sales_month
    ) AS previous_month_revenue
FROM monthly_sales
ORDER BY sales_month;


-- =========================================================
-- ANALYSIS 05
-- Month-over-Month Revenue Change
-- =========================================================

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
),

sales_comparison AS (
    SELECT
        sales_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    sales_month,
    monthly_revenue,
    previous_month_revenue,
    monthly_revenue - previous_month_revenue AS revenue_change
FROM sales_comparison
ORDER BY sales_month;


-- =========================================================
-- ANALYSIS 06
-- Month-over-Month Revenue Growth Percentage
-- =========================================================

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
),

sales_comparison AS (
    SELECT
        sales_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

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
FROM sales_comparison
ORDER BY sales_month;


-- =========================================================
-- ANALYSIS 07
-- Monthly Sales Growth Classification
-- =========================================================

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
),

sales_comparison AS (
    SELECT
        sales_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    sales_month,
    monthly_revenue,
    previous_month_revenue,
    CASE
        WHEN previous_month_revenue IS NULL
            THEN 'First Recorded Month'
        WHEN monthly_revenue > previous_month_revenue
            THEN 'Revenue Increased'
        WHEN monthly_revenue < previous_month_revenue
            THEN 'Revenue Decreased'
        ELSE 'Revenue Unchanged'
    END AS growth_status
FROM sales_comparison
ORDER BY sales_month;


-- =========================================================
-- ANALYSIS 08
-- Cumulative Revenue Over Time
-- =========================================================

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)

SELECT
    sales_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY sales_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM monthly_sales
ORDER BY sales_month;


-- =========================================================
-- ANALYSIS 09
-- Monthly Revenue Ranking
-- =========================================================

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)

SELECT
    sales_month,
    monthly_revenue,
    RANK() OVER (
        ORDER BY monthly_revenue DESC
    ) AS revenue_rank
FROM monthly_sales
ORDER BY revenue_rank;


-- =========================================================
-- ANALYSIS 10
-- Highest Revenue Growth Month
-- =========================================================

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
),

growth_analysis AS (
    SELECT
        sales_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

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
FROM growth_analysis
WHERE previous_month_revenue IS NOT NULL
ORDER BY mom_growth_percentage DESC
LIMIT 1;


-- =========================================================
-- ANALYSIS 11
-- Largest Revenue Decline Month
-- =========================================================

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
),

growth_analysis AS (
    SELECT
        sales_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

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
FROM growth_analysis
WHERE previous_month_revenue IS NOT NULL
ORDER BY mom_growth_percentage ASC
LIMIT 1;


-- =========================================================
-- ANALYSIS 12
-- Final Monthly Sales Growth Summary
-- =========================================================

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * p.price) AS monthly_revenue,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units_sold
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
),

growth_analysis AS (
    SELECT
        sales_month,
        monthly_revenue,
        total_orders,
        total_units_sold,
        LAG(monthly_revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    sales_month,
    monthly_revenue,
    total_orders,
    total_units_sold,
    previous_month_revenue,
    monthly_revenue - previous_month_revenue AS revenue_change,
    ROUND(
        (
            (monthly_revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
        ) * 100,
        2
    ) AS mom_growth_percentage,
    CASE
        WHEN previous_month_revenue IS NULL
            THEN 'First Recorded Month'
        WHEN monthly_revenue > previous_month_revenue
            THEN 'Growth'
        WHEN monthly_revenue < previous_month_revenue
            THEN 'Decline'
        ELSE 'Stable'
    END AS performance_status
FROM growth_analysis
ORDER BY sales_month;