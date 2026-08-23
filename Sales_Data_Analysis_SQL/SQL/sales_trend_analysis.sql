USE sales_analysis_db;

-- =========================================================
-- DAY 23: SALES TREND & TIME-SERIES ANALYSIS
-- =========================================================


-- 1. Monthly Sales Revenue
-- Analyze total revenue generated each month.

SELECT
    YEAR(o.order_date) AS sales_year,
    MONTH(o.order_date) AS sales_month,
    SUM(oi.quantity * p.price) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY
    sales_year,
    sales_month;


-- 2. Monthly Order Volume
-- Analyze the number of orders placed each month.

SELECT
    YEAR(order_date) AS sales_year,
    MONTH(order_date) AS sales_month,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    sales_year,
    sales_month;


-- 3. Average Order Value by Month

SELECT
    YEAR(o.order_date) AS sales_year,
    MONTH(o.order_date) AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue,
    ROUND(
        SUM(oi.quantity * p.price) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY
    sales_year,
    sales_month;


-- 4. Daily Revenue Trend

SELECT
    DATE(o.order_date) AS order_day,
    SUM(oi.quantity * p.price) AS daily_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    DATE(o.order_date)
ORDER BY
    order_day;


-- 5. Revenue by Year

SELECT
    YEAR(o.order_date) AS sales_year,
    SUM(oi.quantity * p.price) AS yearly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    YEAR(o.order_date)
ORDER BY
    sales_year;


-- 6. Best-Selling Month

SELECT
    YEAR(o.order_date) AS sales_year,
    MONTH(o.order_date) AS sales_month,
    SUM(oi.quantity * p.price) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY
    monthly_revenue DESC
LIMIT 1;


-- 7. Monthly Product Sales

SELECT
    YEAR(o.order_date) AS sales_year,
    MONTH(o.order_date) AS sales_month,
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * p.price) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date),
    p.product_id,
    p.product_name
ORDER BY
    sales_year,
    sales_month,
    revenue DESC;


-- 8. Customer Revenue by Month

SELECT
    YEAR(o.order_date) AS sales_year,
    MONTH(o.order_date) AS sales_month,
    c.customer_id,
    SUM(oi.quantity * p.price) AS customer_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date),
    c.customer_id
ORDER BY
    sales_year,
    sales_month,
    customer_revenue DESC;


-- 9. Running Revenue Total

WITH monthly_sales AS (
    SELECT
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date)
)

SELECT
    sales_year,
    sales_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY sales_year, sales_month
    ) AS cumulative_revenue
FROM monthly_sales
ORDER BY
    sales_year,
    sales_month;


-- 10. Month-over-Month Revenue Growth

WITH monthly_sales AS (
    SELECT
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date)
),

revenue_comparison AS (
    SELECT
        sales_year,
        sales_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            ORDER BY sales_year, sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    sales_year,
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
FROM revenue_comparison
ORDER BY
    sales_year,
    sales_month;


-- 11. Monthly Sales Ranking

WITH monthly_sales AS (
    SELECT
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date)
)

SELECT
    sales_year,
    sales_month,
    monthly_revenue,
    RANK() OVER (
        ORDER BY monthly_revenue DESC
    ) AS revenue_rank
FROM monthly_sales
ORDER BY
    revenue_rank;


-- 12. Quarterly Revenue Analysis

SELECT
    YEAR(o.order_date) AS sales_year,
    QUARTER(o.order_date) AS sales_quarter,
    SUM(oi.quantity * p.price) AS quarterly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    YEAR(o.order_date),
    QUARTER(o.order_date)
ORDER BY
    sales_year,
    sales_quarter;