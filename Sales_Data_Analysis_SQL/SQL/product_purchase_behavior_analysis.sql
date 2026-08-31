USE sales_analysis_db;

-- ============================================================
-- DAY 31
-- PRODUCT PURCHASE BEHAVIOR ANALYSIS
-- ============================================================


-- ============================================================
-- 1. PRODUCT PURCHASE SUMMARY
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(oi.quantity) AS units_sold,
    ROUND(
        SUM(oi.quantity * p.price),
        2
    ) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_revenue DESC;


-- ============================================================
-- 2. PRODUCT CUSTOMER REACH
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY unique_customers DESC;


-- ============================================================
-- 3. PRODUCT PURCHASE FREQUENCY
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    COUNT(oi.order_item_id) AS purchase_count,
    SUM(oi.quantity) AS total_units_sold,
    ROUND(
        AVG(oi.quantity),
        2
    ) AS average_quantity_per_purchase
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY purchase_count DESC;


-- ============================================================
-- 4. REPEAT PURCHASE PRODUCTS
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
GROUP BY
    p.product_id,
    p.product_name
HAVING COUNT(DISTINCT oi.order_id) > 1
ORDER BY total_orders DESC;


-- ============================================================
-- 5. PRODUCT REVENUE CONTRIBUTION %
-- ============================================================

WITH product_revenue AS (
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
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        total_revenue /
        SUM(total_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_percent
FROM product_revenue
ORDER BY total_revenue DESC;


-- ============================================================
-- 6. PRODUCT REVENUE RANKING
-- ============================================================

WITH product_revenue AS (
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
    ROUND(total_revenue, 2) AS total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM product_revenue
ORDER BY revenue_rank;


-- ============================================================
-- 7. PRODUCT PERFORMANCE CLASSIFICATION
-- ============================================================

WITH product_sales AS (
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
    ROUND(total_revenue, 2) AS total_revenue,

    CASE
        WHEN total_revenue >= 10000
            THEN 'High Performer'

        WHEN total_revenue >= 5000
            THEN 'Medium Performer'

        ELSE 'Low Performer'
    END AS performance_category

FROM product_sales
ORDER BY total_revenue DESC;


-- ============================================================
-- 8. TOP PRODUCTS BY CUSTOMER REACH
-- ============================================================

WITH product_customers AS (
    SELECT
        p.product_id,
        p.product_name,
        COUNT(DISTINCT o.customer_id) AS unique_customers
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    JOIN orders o
        ON oi.order_id = o.order_id
    GROUP BY
        p.product_id,
        p.product_name
),

ranked_products AS (
    SELECT
        product_id,
        product_name,
        unique_customers,

        RANK() OVER (
            ORDER BY unique_customers DESC
        ) AS customer_reach_rank

    FROM product_customers
)

SELECT
    product_id,
    product_name,
    unique_customers,
    customer_reach_rank
FROM ranked_products
ORDER BY customer_reach_rank;


-- ============================================================
-- 9. PRODUCT SALES SEGMENTATION
-- ============================================================

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS units_sold
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

    CASE
        WHEN units_sold >= 50
            THEN 'High Volume'

        WHEN units_sold >= 20
            THEN 'Medium Volume'

        ELSE 'Low Volume'
    END AS sales_volume_segment

FROM product_sales
ORDER BY units_sold DESC;


-- ============================================================
-- 10. PRODUCT BUSINESS SUMMARY
-- ============================================================

WITH product_summary AS (
    SELECT
        p.product_id,
        p.product_name,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        COUNT(DISTINCT o.customer_id) AS unique_customers,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    JOIN orders o
        ON oi.order_id = o.order_id
    GROUP BY
        p.product_id,
        p.product_name
)

SELECT
    product_id,
    product_name,
    total_orders,
    unique_customers,
    units_sold,
    ROUND(total_revenue, 2) AS total_revenue,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank,

    ROUND(
        total_revenue /
        SUM(total_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_percent,

    CASE
        WHEN total_revenue >= 10000
            THEN 'High Performer'

        WHEN total_revenue >= 5000
            THEN 'Medium Performer'

        ELSE 'Low Performer'
    END AS performance_category

FROM product_summary
ORDER BY revenue_rank;