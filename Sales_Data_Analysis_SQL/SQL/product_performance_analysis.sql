USE sales_analysis_db;

-- ============================================================
-- DAY 24: ADVANCED PRODUCT PERFORMANCE & PROFITABILITY ANALYSIS
-- ============================================================


-- ============================================================
-- 1. PRODUCT SALES PERFORMANCE
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * p.price) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_revenue DESC;


-- ============================================================
-- 2. PRODUCT REVENUE RANKING
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(oi.quantity * p.price) DESC
    ) AS revenue_rank
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY revenue_rank;


-- ============================================================
-- 3. PRODUCT UNITS SOLD RANKING
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    DENSE_RANK() OVER (
        ORDER BY SUM(oi.quantity) DESC
    ) AS sales_rank
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY sales_rank;


-- ============================================================
-- 4. PRODUCT REVENUE CONTRIBUTION
-- ============================================================

WITH product_sales AS
(
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name
)

SELECT
    product_id,
    product_name,
    total_revenue,
    ROUND(
        total_revenue /
        SUM(total_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_percentage
FROM product_sales
ORDER BY total_revenue DESC;


-- ============================================================
-- 5. TOP 5 PRODUCTS BY REVENUE
-- ============================================================

WITH product_sales AS
(
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name
)

SELECT
    product_id,
    product_name,
    total_revenue
FROM product_sales
ORDER BY total_revenue DESC
LIMIT 5;


-- ============================================================
-- 6. LOWEST PERFORMING PRODUCTS
-- ============================================================

WITH product_sales AS
(
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name
)

SELECT
    product_id,
    product_name,
    units_sold,
    total_revenue
FROM product_sales
ORDER BY total_revenue ASC
LIMIT 5;


-- ============================================================
-- 7. PRODUCT ORDER FREQUENCY
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    COUNT(DISTINCT oi.order_id) AS order_frequency,
    SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY order_frequency DESC;


-- ============================================================
-- 8. AVERAGE REVENUE PER ORDER FOR EACH PRODUCT
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue,
    ROUND(
        SUM(oi.quantity * p.price) /
        COUNT(DISTINCT oi.order_id),
        2
    ) AS average_revenue_per_order
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY average_revenue_per_order DESC;


-- ============================================================
-- 9. PRODUCT PERFORMANCE SUMMARY
-- ============================================================

WITH product_summary AS
(
    SELECT
        p.product_id,
        p.product_name,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name
)

SELECT
    product_id,
    product_name,
    total_orders,
    units_sold,
    total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank,
    ROUND(
        total_revenue /
        SUM(total_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_percentage
FROM product_summary
ORDER BY revenue_rank;


-- ============================================================
-- 10. BUSINESS PERFORMANCE CLASSIFICATION
-- ============================================================

WITH product_summary AS
(
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name
)

SELECT
    product_id,
    product_name,
    units_sold,
    total_revenue,
    CASE
        WHEN total_revenue >=
             (SELECT AVG(total_revenue)
              FROM product_summary)
        THEN 'High Performer'

        ELSE 'Low Performer'
    END AS performance_category
FROM product_summary
ORDER BY total_revenue DESC;


-- ============================================================
-- 11. FINAL PRODUCT BUSINESS REPORT
-- ============================================================

WITH product_summary AS
(
    SELECT
        p.product_id,
        p.product_name,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name
)

SELECT
    product_id,
    product_name,
    total_orders,
    units_sold,
    total_revenue,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank,

    ROUND(
        total_revenue /
        SUM(total_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_percentage,

    CASE
        WHEN total_revenue >=
             (SELECT AVG(total_revenue)
              FROM product_summary)
        THEN 'High Performer'
        ELSE 'Low Performer'
    END AS performance_category

FROM product_summary
ORDER BY revenue_rank;