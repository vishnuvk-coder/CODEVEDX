-- =========================================================
-- Day 70: Advanced Sales Seasonality and YoY Analysis
-- Database: sales_analysis_db
-- MySQL: 8.0+
-- Revenue = order_items.quantity * products.price
-- =========================================================

USE sales_analysis_db;

-- 1. Monthly sales revenue by year
WITH monthly_sales AS (
    SELECT
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        SUM(oi.quantity * p.price) AS revenue,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS units_sold
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE o.order_date IS NOT NULL
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
)
SELECT *
FROM monthly_sales
ORDER BY sales_year, sales_month;


-- 2. Year-over-year revenue comparison for the same month
WITH monthly_sales AS (
    SELECT
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE o.order_date IS NOT NULL
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
)
SELECT
    current_year.sales_year,
    current_year.sales_month,
    current_year.revenue AS current_revenue,
    previous_year.revenue AS previous_year_revenue,
    current_year.revenue - previous_year.revenue
        AS revenue_change,
    ROUND(
        100.0 * (current_year.revenue - previous_year.revenue)
        / NULLIF(previous_year.revenue, 0),
        2
    ) AS yoy_growth_percentage
FROM monthly_sales current_year
LEFT JOIN monthly_sales previous_year
    ON previous_year.sales_year = current_year.sales_year - 1
   AND previous_year.sales_month = current_year.sales_month
ORDER BY current_year.sales_year, current_year.sales_month;


-- 3. Average revenue for each calendar month across years
WITH monthly_sales AS (
    SELECT
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE o.order_date IS NOT NULL
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
)
SELECT
    sales_month,
    DATE_FORMAT(
        STR_TO_DATE(
            CONCAT('2000-', LPAD(sales_month, 2, '0'), '-01'),
            '%Y-%m-%d'
        ),
        '%M'
    ) AS month_name,
    COUNT(*) AS years_with_sales,
    ROUND(AVG(revenue), 2) AS average_monthly_revenue,
    ROUND(MIN(revenue), 2) AS lowest_observed_revenue,
    ROUND(MAX(revenue), 2) AS highest_observed_revenue
FROM monthly_sales
GROUP BY sales_month
ORDER BY sales_month;


-- 4. Rank each month's revenue within its year
WITH monthly_sales AS (
    SELECT
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE o.order_date IS NOT NULL
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
)
SELECT
    sales_year,
    sales_month,
    revenue,
    RANK() OVER (
        PARTITION BY sales_year
        ORDER BY revenue DESC
    ) AS revenue_rank
FROM monthly_sales
ORDER BY sales_year, revenue_rank, sales_month;


-- 5. Highest- and lowest-revenue observed month in each year
WITH monthly_sales AS (
    SELECT
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE o.order_date IS NOT NULL
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
),
ranked_months AS (
    SELECT
        sales_year,
        sales_month,
        revenue,
        RANK() OVER (
            PARTITION BY sales_year
            ORDER BY revenue DESC
        ) AS highest_rank,
        RANK() OVER (
            PARTITION BY sales_year
            ORDER BY revenue ASC
        ) AS lowest_rank
    FROM monthly_sales
)
SELECT
    sales_year,
    sales_month,
    revenue,
    CASE
        WHEN highest_rank = 1 AND lowest_rank = 1
            THEN 'Highest and Lowest'
        WHEN highest_rank = 1 THEN 'Highest Revenue'
        WHEN lowest_rank = 1 THEN 'Lowest Revenue'
    END AS month_category
FROM ranked_months
WHERE highest_rank = 1 OR lowest_rank = 1
ORDER BY sales_year, sales_month;


-- 6. Quarterly sales seasonality
WITH quarterly_sales AS (
    SELECT
        YEAR(o.order_date) AS sales_year,
        QUARTER(o.order_date) AS sales_quarter,
        SUM(oi.quantity * p.price) AS revenue,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE o.order_date IS NOT NULL
    GROUP BY YEAR(o.order_date), QUARTER(o.order_date)
)
SELECT
    sales_year,
    sales_quarter,
    revenue,
    total_orders,
    RANK() OVER (
        PARTITION BY sales_year
        ORDER BY revenue DESC
    ) AS quarterly_revenue_rank
FROM quarterly_sales
ORDER BY sales_year, quarterly_revenue_rank;


-- 7. Year-over-year units sold comparison
WITH monthly_units AS (
    SELECT
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        SUM(oi.quantity) AS units_sold
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_date IS NOT NULL
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
)
SELECT
    current_year.sales_year,
    current_year.sales_month,
    current_year.units_sold,
    previous_year.units_sold AS previous_year_units,
    current_year.units_sold - previous_year.units_sold
        AS unit_change,
    ROUND(
        100.0 * (
            current_year.units_sold - previous_year.units_sold
        ) / NULLIF(previous_year.units_sold, 0),
        2
    ) AS yoy_units_growth_percentage
FROM monthly_units current_year
LEFT JOIN monthly_units previous_year
    ON previous_year.sales_year = current_year.sales_year - 1
   AND previous_year.sales_month = current_year.sales_month
ORDER BY current_year.sales_year, current_year.sales_month;


-- 8. Annual sales summary
WITH monthly_sales AS (
    SELECT
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        SUM(oi.quantity * p.price) AS revenue,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE o.order_date IS NOT NULL
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
)
SELECT
    sales_year,
    ROUND(SUM(revenue), 2) AS annual_revenue,
    SUM(total_orders) AS annual_orders,
    ROUND(AVG(revenue), 2) AS average_observed_monthly_revenue,
    MAX(revenue) AS highest_observed_monthly_revenue,
    MIN(revenue) AS lowest_observed_monthly_revenue,
    COUNT(*) AS months_with_sales
FROM monthly_sales
GROUP BY sales_year
ORDER BY sales_year;