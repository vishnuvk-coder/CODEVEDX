USE sales_analysis_db;

-- ============================================================
-- DAY 34
-- CUSTOMER CROSS-SELLING & PRODUCT RECOMMENDATION ANALYSIS
-- ============================================================
-- Objective:
-- Identify products frequently purchased together, measure
-- product affinity, and discover cross-selling opportunities.
-- ============================================================


-- ============================================================
-- QUERY 1
-- CUSTOMER-PRODUCT PURCHASE MAPPING
-- ============================================================

SELECT DISTINCT
    o.customer_id,
    oi.product_id,
    p.product_name
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
ORDER BY
    o.customer_id,
    oi.product_id;


-- ============================================================
-- QUERY 2
-- PRODUCT PAIR ANALYSIS
-- Find products purchased together by the same customer
-- ============================================================

SELECT
    oi1.product_id AS product_1_id,
    p1.product_name AS product_1,
    oi2.product_id AS product_2_id,
    p2.product_name AS product_2,
    COUNT(DISTINCT o1.customer_id) AS customers_purchasing_both
FROM orders o1
JOIN order_items oi1
    ON o1.order_id = oi1.order_id
JOIN products p1
    ON oi1.product_id = p1.product_id

JOIN orders o2
    ON o1.customer_id = o2.customer_id
JOIN order_items oi2
    ON o2.order_id = oi2.order_id
JOIN products p2
    ON oi2.product_id = p2.product_id

WHERE oi1.product_id < oi2.product_id

GROUP BY
    oi1.product_id,
    p1.product_name,
    oi2.product_id,
    p2.product_name

ORDER BY
    customers_purchasing_both DESC;


-- ============================================================
-- QUERY 3
-- TOP PRODUCT PAIRS BY CUSTOMER COUNT
-- ============================================================

SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    COUNT(DISTINCT o1.customer_id) AS customer_count
FROM orders o1
JOIN order_items oi1
    ON o1.order_id = oi1.order_id
JOIN products p1
    ON oi1.product_id = p1.product_id

JOIN orders o2
    ON o1.customer_id = o2.customer_id
JOIN order_items oi2
    ON o2.order_id = oi2.order_id
JOIN products p2
    ON oi2.product_id = p2.product_id

WHERE oi1.product_id < oi2.product_id

GROUP BY
    oi1.product_id,
    p1.product_name,
    oi2.product_id,
    p2.product_name

ORDER BY
    customer_count DESC

LIMIT 10;


-- ============================================================
-- QUERY 4
-- PRODUCT PAIR REVENUE ANALYSIS
-- ============================================================

SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    COUNT(DISTINCT o1.customer_id) AS customers,
    SUM(oi1.quantity * p1.price) +
    SUM(oi2.quantity * p2.price) AS combined_revenue
FROM orders o1

JOIN order_items oi1
    ON o1.order_id = oi1.order_id

JOIN products p1
    ON oi1.product_id = p1.product_id

JOIN orders o2
    ON o1.customer_id = o2.customer_id

JOIN order_items oi2
    ON o2.order_id = oi2.order_id

JOIN products p2
    ON oi2.product_id = p2.product_id

WHERE oi1.product_id < oi2.product_id

GROUP BY
    oi1.product_id,
    p1.product_name,
    p1.price,
    oi2.product_id,
    p2.product_name,
    p2.price

ORDER BY
    combined_revenue DESC

LIMIT 10;


-- ============================================================
-- QUERY 5
-- PRODUCT AFFINITY SCORE
--
-- Affinity Score =
-- Customers purchasing both products /
-- Customers purchasing either product
-- ============================================================

WITH product_customers AS
(
    SELECT DISTINCT
        o.customer_id,
        oi.product_id
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
),

product_pairs AS
(
    SELECT
        a.product_id AS product_1_id,
        b.product_id AS product_2_id,
        COUNT(DISTINCT a.customer_id) AS customers_both
    FROM product_customers a
    JOIN product_customers b
        ON a.customer_id = b.customer_id
       AND a.product_id < b.product_id
    GROUP BY
        a.product_id,
        b.product_id
),

product_totals AS
(
    SELECT
        product_id,
        COUNT(DISTINCT customer_id) AS total_customers
    FROM product_customers
    GROUP BY product_id
)

SELECT
    pp.product_1_id,
    p1.product_name AS product_1,
    pp.product_2_id,
    p2.product_name AS product_2,
    pp.customers_both,
    pt1.total_customers AS product_1_customers,
    pt2.total_customers AS product_2_customers,
    ROUND(
        pp.customers_both /
        NULLIF(
            (pt1.total_customers + pt2.total_customers - pp.customers_both),
            0
        ) * 100,
        2
    ) AS affinity_score_percentage

FROM product_pairs pp

JOIN product_totals pt1
    ON pp.product_1_id = pt1.product_id

JOIN product_totals pt2
    ON pp.product_2_id = pt2.product_id

JOIN products p1
    ON pp.product_1_id = p1.product_id

JOIN products p2
    ON pp.product_2_id = p2.product_id

ORDER BY
    affinity_score_percentage DESC;


-- ============================================================
-- QUERY 6
-- RANK PRODUCT PAIRS BY AFFINITY
-- ============================================================

WITH product_customers AS
(
    SELECT DISTINCT
        o.customer_id,
        oi.product_id
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
),

pair_analysis AS
(
    SELECT
        a.product_id AS product_1_id,
        b.product_id AS product_2_id,
        COUNT(DISTINCT a.customer_id) AS customers_both
    FROM product_customers a
    JOIN product_customers b
        ON a.customer_id = b.customer_id
       AND a.product_id < b.product_id
    GROUP BY
        a.product_id,
        b.product_id
),

product_totals AS
(
    SELECT
        product_id,
        COUNT(DISTINCT customer_id) AS total_customers
    FROM product_customers
    GROUP BY product_id
),

affinity AS
(
    SELECT
        pa.product_1_id,
        pa.product_2_id,
        pa.customers_both,
        ROUND(
            pa.customers_both /
            NULLIF(
                pt1.total_customers +
                pt2.total_customers -
                pa.customers_both,
                0
            ) * 100,
            2
        ) AS affinity_score
    FROM pair_analysis pa
    JOIN product_totals pt1
        ON pa.product_1_id = pt1.product_id
    JOIN product_totals pt2
        ON pa.product_2_id = pt2.product_id
)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY affinity_score DESC
    ) AS affinity_rank,
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    customers_both,
    affinity_score
FROM affinity a
JOIN products p1
    ON a.product_1_id = p1.product_id
JOIN products p2
    ON a.product_2_id = p2.product_id
ORDER BY
    affinity_rank;


-- ============================================================
-- QUERY 7
-- HIGH-AFFINITY PRODUCT PAIRS
-- ============================================================

WITH product_customers AS
(
    SELECT DISTINCT
        o.customer_id,
        oi.product_id
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
),

pair_analysis AS
(
    SELECT
        a.product_id AS product_1_id,
        b.product_id AS product_2_id,
        COUNT(DISTINCT a.customer_id) AS customers_both
    FROM product_customers a
    JOIN product_customers b
        ON a.customer_id = b.customer_id
       AND a.product_id < b.product_id
    GROUP BY
        a.product_id,
        b.product_id
),

product_totals AS
(
    SELECT
        product_id,
        COUNT(DISTINCT customer_id) AS total_customers
    FROM product_customers
    GROUP BY product_id
)

SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    pa.customers_both,
    ROUND(
        pa.customers_both /
        NULLIF(
            pt1.total_customers +
            pt2.total_customers -
            pa.customers_both,
            0
        ) * 100,
        2
    ) AS affinity_score
FROM pair_analysis pa

JOIN product_totals pt1
    ON pa.product_1_id = pt1.product_id

JOIN product_totals pt2
    ON pa.product_2_id = pt2.product_id

JOIN products p1
    ON pa.product_1_id = p1.product_id

JOIN products p2
    ON pa.product_2_id = p2.product_id

WHERE
    pa.customers_both >= 2

ORDER BY
    affinity_score DESC;


-- ============================================================
-- QUERY 8
-- CROSS-SELLING OPPORTUNITIES
-- ============================================================

WITH customer_products AS
(
    SELECT DISTINCT
        o.customer_id,
        oi.product_id
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
)

SELECT
    cp1.product_id AS existing_product_id,
    p1.product_name AS existing_product,
    cp2.product_id AS recommended_product_id,
    p2.product_name AS recommended_product,
    COUNT(DISTINCT cp1.customer_id) AS customers_with_both
FROM customer_products cp1
JOIN customer_products cp2
    ON cp1.customer_id = cp2.customer_id
   AND cp1.product_id <> cp2.product_id

JOIN products p1
    ON cp1.product_id = p1.product_id

JOIN products p2
    ON cp2.product_id = p2.product_id

GROUP BY
    cp1.product_id,
    p1.product_name,
    cp2.product_id,
    p2.product_name

HAVING
    customers_with_both >= 2

ORDER BY
    customers_with_both DESC;


-- ============================================================
-- QUERY 9
-- TOP CROSS-SELLING PRODUCT PAIRS
-- ============================================================

WITH customer_products AS
(
    SELECT DISTINCT
        o.customer_id,
        oi.product_id
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
),

pair_counts AS
(
    SELECT
        a.product_id AS product_1_id,
        b.product_id AS product_2_id,
        COUNT(DISTINCT a.customer_id) AS customers_both
    FROM customer_products a
    JOIN customer_products b
        ON a.customer_id = b.customer_id
       AND a.product_id < b.product_id
    GROUP BY
        a.product_id,
        b.product_id
)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY customers_both DESC
    ) AS recommendation_rank,
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    customers_both
FROM pair_counts pc
JOIN products p1
    ON pc.product_1_id = p1.product_id
JOIN products p2
    ON pc.product_2_id = p2.product_id
ORDER BY
    recommendation_rank
LIMIT 10;


-- ============================================================
-- QUERY 10
-- CUSTOMER-BASED PRODUCT RECOMMENDATIONS
-- ============================================================

WITH customer_products AS
(
    SELECT DISTINCT
        o.customer_id,
        oi.product_id
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
),

customer_product_pairs AS
(
    SELECT
        a.customer_id,
        a.product_id AS purchased_product,
        b.product_id AS recommended_product
    FROM customer_products a
    JOIN customer_products b
        ON a.customer_id = b.customer_id
       AND a.product_id <> b.product_id
)

SELECT
    cpp.customer_id,
    p1.product_name AS purchased_product,
    p2.product_name AS recommended_product
FROM customer_product_pairs cpp
JOIN products p1
    ON cpp.purchased_product = p1.product_id
JOIN products p2
    ON cpp.recommended_product = p2.product_id
ORDER BY
    cpp.customer_id,
    cpp.purchased_product,
    cpp.recommended_product;


-- ============================================================
-- QUERY 11
-- REVENUE OPPORTUNITY FROM CROSS-SELLING
-- ============================================================

WITH customer_products AS
(
    SELECT DISTINCT
        o.customer_id,
        oi.product_id
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
),

product_pair_revenue AS
(
    SELECT
        a.product_id AS product_1_id,
        b.product_id AS product_2_id,
        COUNT(DISTINCT a.customer_id) AS customers_both
    FROM customer_products a
    JOIN customer_products b
        ON a.customer_id = b.customer_id
       AND a.product_id < b.product_id
    GROUP BY
        a.product_id,
        b.product_id
)

SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    ppr.customers_both,
    ROUND(
        p1.price + p2.price,
        2
    ) AS estimated_bundle_value,
    ROUND(
        ppr.customers_both * (p1.price + p2.price),
        2
    ) AS estimated_revenue_opportunity
FROM product_pair_revenue ppr
JOIN products p1
    ON ppr.product_1_id = p1.product_id
JOIN products p2
    ON ppr.product_2_id = p2.product_id
ORDER BY
    estimated_revenue_opportunity DESC
LIMIT 10;


-- ============================================================
-- QUERY 12
-- FINAL CROSS-SELLING BUSINESS SUMMARY
-- ============================================================

WITH customer_products AS
(
    SELECT DISTINCT
        o.customer_id,
        oi.product_id
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
),

product_pairs AS
(
    SELECT
        a.product_id AS product_1_id,
        b.product_id AS product_2_id,
        COUNT(DISTINCT a.customer_id) AS customers_both
    FROM customer_products a
    JOIN customer_products b
        ON a.customer_id = b.customer_id
       AND a.product_id < b.product_id
    GROUP BY
        a.product_id,
        b.product_id
)

SELECT
    COUNT(*) AS total_product_pairs,
    MAX(customers_both) AS maximum_pair_customer_count,
    ROUND(AVG(customers_both), 2) AS average_pair_customer_count,
    SUM(
        CASE
            WHEN customers_both >= 5 THEN 1
            ELSE 0
        END
    ) AS strong_cross_sell_pairs,
    SUM(
        CASE
            WHEN customers_both BETWEEN 2 AND 4 THEN 1
            ELSE 0
        END
    ) AS moderate_cross_sell_pairs
FROM product_pairs;