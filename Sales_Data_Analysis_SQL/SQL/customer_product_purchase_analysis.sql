USE sales_analysis_db;

-- ============================================================
-- DAY 33
-- CUSTOMER-PRODUCT PURCHASE ANALYSIS
-- ============================================================


-- ============================================================
-- 1. CUSTOMER-PRODUCT PURCHASE MAPPING
-- ============================================================

SELECT
    o.customer_id,
    oi.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_units_purchased,
    ROUND(SUM(oi.quantity * p.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    o.customer_id,
    oi.product_id,
    p.product_name
ORDER BY
    o.customer_id,
    total_revenue DESC;


-- ============================================================
-- 2. CUSTOMER PRODUCT PURCHASE FREQUENCY
-- ============================================================

SELECT
    o.customer_id,
    oi.product_id,
    p.product_name,
    COUNT(DISTINCT o.order_id) AS purchase_frequency,
    SUM(oi.quantity) AS total_units_purchased
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    o.customer_id,
    oi.product_id,
    p.product_name
ORDER BY
    purchase_frequency DESC,
    total_units_purchased DESC;


-- ============================================================
-- 3. CUSTOMER SPENDING BY PRODUCT
-- ============================================================

SELECT
    o.customer_id,
    oi.product_id,
    p.product_name,
    ROUND(SUM(oi.quantity * p.price), 2) AS customer_product_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    o.customer_id,
    oi.product_id,
    p.product_name
ORDER BY
    customer_product_revenue DESC;


-- ============================================================
-- 4. NUMBER OF UNIQUE PRODUCTS PURCHASED BY EACH CUSTOMER
-- ============================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT oi.product_id) AS unique_products_purchased
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.customer_id
ORDER BY
    unique_products_purchased DESC;


-- ============================================================
-- 5. TOP PRODUCT FOR EACH CUSTOMER
-- ============================================================

WITH customer_product_revenue AS (
    SELECT
        o.customer_id,
        oi.product_id,
        p.product_name,
        ROUND(SUM(oi.quantity * p.price), 2) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.customer_id,
        oi.product_id,
        p.product_name
),

ranked_products AS (
    SELECT
        customer_id,
        product_id,
        product_name,
        total_revenue,
        RANK() OVER (
            PARTITION BY customer_id
            ORDER BY total_revenue DESC
        ) AS product_rank
    FROM customer_product_revenue
)

SELECT
    customer_id,
    product_id,
    product_name,
    total_revenue,
    product_rank
FROM ranked_products
WHERE product_rank = 1
ORDER BY
    customer_id;


-- ============================================================
-- 6. CUSTOMERS PURCHASING MULTIPLE PRODUCTS
-- ============================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT oi.product_id) AS product_count
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.customer_id
HAVING
    COUNT(DISTINCT oi.product_id) > 1
ORDER BY
    product_count DESC;


-- ============================================================
-- 7. CUSTOMER PRODUCT DIVERSITY CLASSIFICATION
-- ============================================================

WITH customer_product_count AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT oi.product_id) AS product_count
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id
)

SELECT
    customer_id,
    product_count,
    CASE
        WHEN product_count = 1
            THEN 'Single Product Customer'

        WHEN product_count BETWEEN 2 AND 3
            THEN 'Multi-Product Customer'

        ELSE 'Highly Diverse Customer'
    END AS customer_product_segment

FROM customer_product_count
ORDER BY
    product_count DESC;


-- ============================================================
-- 8. CUSTOMER-PRODUCT REVENUE RANKING
-- ============================================================

WITH customer_product_revenue AS (
    SELECT
        o.customer_id,
        oi.product_id,
        p.product_name,
        ROUND(SUM(oi.quantity * p.price), 2) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.customer_id,
        oi.product_id,
        p.product_name
)

SELECT
    customer_id,
    product_id,
    product_name,
    total_revenue,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank

FROM customer_product_revenue
ORDER BY
    revenue_rank;


-- ============================================================
-- 9. CUSTOMER-PRODUCT PURCHASE CLASSIFICATION
-- ============================================================

WITH customer_product_summary AS (
    SELECT
        o.customer_id,
        oi.product_id,
        p.product_name,

        COUNT(DISTINCT o.order_id) AS order_count,

        SUM(oi.quantity) AS total_units,

        ROUND(
            SUM(oi.quantity * p.price),
            2
        ) AS total_revenue

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY
        o.customer_id,
        oi.product_id,
        p.product_name
)

SELECT
    customer_id,
    product_id,
    product_name,
    order_count,
    total_units,
    total_revenue,

    CASE
        WHEN order_count >= 3
            THEN 'Frequent Buyer'

        WHEN order_count = 2
            THEN 'Repeat Buyer'

        ELSE 'One-Time Buyer'
    END AS purchase_segment

FROM customer_product_summary

ORDER BY
    total_revenue DESC;


-- ============================================================
-- 10. HIGH-VALUE CUSTOMER-PRODUCT RELATIONSHIPS
-- ============================================================

WITH customer_product_summary AS (
    SELECT
        o.customer_id,
        oi.product_id,
        p.product_name,

        COUNT(DISTINCT o.order_id) AS order_count,

        SUM(oi.quantity) AS total_units,

        ROUND(
            SUM(oi.quantity * p.price),
            2
        ) AS total_revenue

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY
        o.customer_id,
        oi.product_id,
        p.product_name
)

SELECT
    customer_id,
    product_id,
    product_name,
    order_count,
    total_units,
    total_revenue,

    CASE
        WHEN total_revenue >= 10000
            THEN 'High Value'

        WHEN total_revenue >= 5000
            THEN 'Medium Value'

        ELSE 'Low Value'
    END AS value_segment

FROM customer_product_summary

ORDER BY
    total_revenue DESC;


-- ============================================================
-- 11. TOP 10 CUSTOMER-PRODUCT RELATIONSHIPS
-- ============================================================

WITH customer_product_revenue AS (
    SELECT
        o.customer_id,
        oi.product_id,
        p.product_name,
        ROUND(
            SUM(oi.quantity * p.price),
            2
        ) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.customer_id,
        oi.product_id,
        p.product_name
)

SELECT
    customer_id,
    product_id,
    product_name,
    total_revenue

FROM customer_product_revenue

ORDER BY
    total_revenue DESC

LIMIT 10;


-- ============================================================
-- 12. CUSTOMER-PRODUCT BUSINESS SUMMARY
-- ============================================================

WITH customer_product_summary AS (
    SELECT
        o.customer_id,
        oi.product_id,
        SUM(oi.quantity) AS total_units,
        ROUND(
            SUM(oi.quantity * p.price),
            2
        ) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.customer_id,
        oi.product_id
)

SELECT
    COUNT(*) AS total_customer_product_relationships,

    COUNT(DISTINCT customer_id)
        AS total_customers,

    COUNT(DISTINCT product_id)
        AS total_products,

    SUM(total_units)
        AS total_units_purchased,

    ROUND(
        SUM(total_revenue),
        2
    ) AS total_revenue

FROM customer_product_summary;


-- ============================================================
-- END OF DAY 33
-- ============================================================