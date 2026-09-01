USE sales_analysis_db;

-- ============================================================
-- DAY 32
-- PRODUCT CUSTOMER AFFINITY & CROSS-SELLING ANALYSIS
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
-- 2. PRODUCT PAIR ANALYSIS
-- ============================================================

WITH customer_products AS (
    SELECT DISTINCT
        o.customer_id,
        oi.product_id
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
)

SELECT
    cp1.product_id AS product_1_id,
    p1.product_name AS product_1,
    cp2.product_id AS product_2_id,
    p2.product_name AS product_2,
    COUNT(DISTINCT cp1.customer_id) AS customers_buying_both
FROM customer_products cp1
JOIN customer_products cp2
    ON cp1.customer_id = cp2.customer_id
    AND cp1.product_id < cp2.product_id
JOIN products p1
    ON cp1.product_id = p1.product_id
JOIN products p2
    ON cp2.product_id = p2.product_id
GROUP BY
    cp1.product_id,
    p1.product_name,
    cp2.product_id,
    p2.product_name
ORDER BY
    customers_buying_both DESC;


-- ============================================================
-- 3. TOP PRODUCT PAIRS BY CUSTOMER COUNT
-- ============================================================

WITH customer_products AS (
    SELECT DISTINCT
        o.customer_id,
        oi.product_id
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
),

product_pairs AS (
    SELECT
        cp1.product_id AS product_1_id,
        cp2.product_id AS product_2_id,
        COUNT(DISTINCT cp1.customer_id) AS customers_buying_both
    FROM customer_products cp1
    JOIN customer_products cp2
        ON cp1.customer_id = cp2.customer_id
        AND cp1.product_id < cp2.product_id
    GROUP BY
        cp1.product_id,
        cp2.product_id
)

SELECT
    pp.product_1_id,
    p1.product_name AS product_1,
    pp.product_2_id,
    p2.product_name AS product_2,
    pp.customers_buying_both
FROM product_pairs pp
JOIN products p1
    ON pp.product_1_id = p1.product_id
JOIN products p2
    ON pp.product_2_id = p2.product_id
ORDER BY
    pp.customers_buying_both DESC
LIMIT 10;


-- ============================================================
-- 4. PRODUCT PAIR REVENUE ANALYSIS
-- ============================================================

WITH customer_products AS (
    SELECT DISTINCT
        o.customer_id,
        oi.product_id
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
),

product_pairs AS (
    SELECT
        cp1.product_id AS product_1_id,
        cp2.product_id AS product_2_id,
        COUNT(DISTINCT cp1.customer_id) AS customers_buying_both
    FROM customer_products cp1
    JOIN customer_products cp2
        ON cp1.customer_id = cp2.customer_id
        AND cp1.product_id < cp2.product_id
    GROUP BY
        cp1.product_id,
        cp2.product_id
)

SELECT
    pp.product_1_id,
    p1.product_name AS product_1,
    pp.product_2_id,
    p2.product_name AS product_2,
    pp.customers_buying_both,

    ROUND(
        (p1.price + p2.price),
        2
    ) AS combined_product_value

FROM product_pairs pp
JOIN products p1
    ON pp.product_1_id = p1.product_id
JOIN products p2
    ON pp.product_2_id = p2.product_id
ORDER BY
    combined_product_value DESC;


-- ============================================================
-- 5. PRODUCT AFFINITY SCORE
-- ============================================================

WITH customer_products AS (
    SELECT DISTINCT
        o.customer_id,
        oi.product_id
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
),

product_pairs AS (
    SELECT
        cp1.product_id AS product_1_id,
        cp2.product_id AS product_2_id,
        COUNT(DISTINCT cp1.customer_id) AS customers_buying_both
    FROM customer_products cp1
    JOIN customer_products cp2
        ON cp1.customer_id = cp2.customer_id
        AND cp1.product_id < cp2.product_id
    GROUP BY
        cp1.product_id,
        cp2.product_id
),

product_customer_counts AS (
    SELECT
        product_id,
        COUNT(DISTINCT customer_id) AS customers_buying_product
    FROM customer_products
    GROUP BY product_id
)

SELECT
    pp.product_1_id,
    p1.product_name AS product_1,
    pp.product_2_id,
    p2.product_name AS product_2,

    pp.customers_buying_both,

    pc1.customers_buying_product AS product_1_customers,
    pc2.customers_buying_product AS product_2_customers,

    ROUND(
        pp.customers_buying_both /
        LEAST(
            pc1.customers_buying_product,
            pc2.customers_buying_product
        ) * 100,
        2
    ) AS affinity_score_percent

FROM product_pairs pp

JOIN products p1
    ON pp.product_1_id = p1.product_id

JOIN products p2
    ON pp.product_2_id = p2.product_id

JOIN product_customer_counts pc1
    ON pp.product_1_id = pc1.product_id

JOIN product_customer_counts pc2
    ON pp.product_2_id = pc2.product_id

ORDER BY
    affinity_score_percent DESC;


-- ============================================================
-- 6. RANK PRODUCT PAIRS BY AFFINITY
-- ============================================================

WITH customer_products AS (
    SELECT DISTINCT
        o.customer_id,
        oi.product_id
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
),

product_pairs AS (
    SELECT
        cp1.product_id AS product_1_id,
        cp2.product_id AS product_2_id,
        COUNT(DISTINCT cp1.customer_id) AS customers_buying_both
    FROM customer_products cp1
    JOIN customer_products cp2
        ON cp1.customer_id = cp2.customer_id
        AND cp1.product_id < cp2.product_id
    GROUP BY
        cp1.product_id,
        cp2.product_id
),

product_customer_counts AS (
    SELECT
        product_id,
        COUNT(DISTINCT customer_id) AS customer_count
    FROM customer_products
    GROUP BY product_id
),

affinity_analysis AS (
    SELECT
        pp.product_1_id,
        pp.product_2_id,
        pp.customers_buying_both,

        ROUND(
            pp.customers_buying_both /
            LEAST(
                pc1.customer_count,
                pc2.customer_count
            ) * 100,
            2
        ) AS affinity_score
    FROM product_pairs pp

    JOIN product_customer_counts pc1
        ON pp.product_1_id = pc1.product_id

    JOIN product_customer_counts pc2
        ON pp.product_2_id = pc2.product_id
)

SELECT
    aa.product_1_id,
    p1.product_name AS product_1,
    aa.product_2_id,
    p2.product_name AS product_2,
    aa.customers_buying_both,
    aa.affinity_score,

    RANK() OVER (
        ORDER BY aa.affinity_score DESC
    ) AS affinity_rank

FROM affinity_analysis aa

JOIN products p1
    ON aa.product_1_id = p1.product_id

JOIN products p2
    ON aa.product_2_id = p2.product_id

ORDER BY
    affinity_rank;


-- ============================================================
-- 7. CROSS-SELLING OPPORTUNITIES
-- ============================================================

WITH customer_products AS (
    SELECT DISTINCT
        o.customer_id,
        oi.product_id
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
),

product_pairs AS (
    SELECT
        cp1.product_id AS product_1_id,
        cp2.product_id AS product_2_id,
        COUNT(DISTINCT cp1.customer_id) AS customers_buying_both
    FROM customer_products cp1
    JOIN customer_products cp2
        ON cp1.customer_id = cp2.customer_id
        AND cp1.product_id < cp2.product_id
    GROUP BY
        cp1.product_id,
        cp2.product_id
)

SELECT
    pp.product_1_id,
    p1.product_name AS product_1,
    pp.product_2_id,
    p2.product_name AS product_2,
    pp.customers_buying_both,

    CASE
        WHEN pp.customers_buying_both >= 10
            THEN 'High Cross-Sell Opportunity'

        WHEN pp.customers_buying_both >= 5
            THEN 'Medium Cross-Sell Opportunity'

        ELSE 'Low Cross-Sell Opportunity'
    END AS cross_sell_category

FROM product_pairs pp

JOIN products p1
    ON pp.product_1_id = p1.product_id

JOIN products p2
    ON pp.product_2_id = p2.product_id

ORDER BY
    pp.customers_buying_both DESC;


-- ============================================================
-- 8. TOP CROSS-SELLING PRODUCT PAIRS
-- ============================================================

WITH customer_products AS (
    SELECT DISTINCT
        o.customer_id,
        oi.product_id
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
),

product_pairs AS (
    SELECT
        cp1.product_id AS product_1_id,
        cp2.product_id AS product_2_id,
        COUNT(DISTINCT cp1.customer_id) AS customers_buying_both
    FROM customer_products cp1
    JOIN customer_products cp2
        ON cp1.customer_id = cp2.customer_id
        AND cp1.product_id < cp2.product_id
    GROUP BY
        cp1.product_id,
        cp2.product_id
)

SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    pp.customers_buying_both,

    ROUND(
        (p1.price + p2.price),
        2
    ) AS bundle_value

FROM product_pairs pp

JOIN products p1
    ON pp.product_1_id = p1.product_id

JOIN products p2
    ON pp.product_2_id = p2.product_id

ORDER BY
    pp.customers_buying_both DESC,
    bundle_value DESC

LIMIT 10;


-- ============================================================
-- 9. PRODUCT AFFINITY BUSINESS SUMMARY
-- ============================================================

WITH customer_products AS (
    SELECT DISTINCT
        o.customer_id,
        oi.product_id
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
),

product_pairs AS (
    SELECT
        cp1.product_id AS product_1_id,
        cp2.product_id AS product_2_id,
        COUNT(DISTINCT cp1.customer_id) AS customers_buying_both
    FROM customer_products cp1
    JOIN customer_products cp2
        ON cp1.customer_id = cp2.customer_id
        AND cp1.product_id < cp2.product_id
    GROUP BY
        cp1.product_id,
        cp2.product_id
)

SELECT
    COUNT(*) AS total_product_pairs,

    MAX(customers_buying_both)
        AS highest_pair_customer_count,

    ROUND(
        AVG(customers_buying_both),
        2
    ) AS average_pair_customer_count

FROM product_pairs;