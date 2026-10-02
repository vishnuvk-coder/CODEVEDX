USE sales_analysis_db;

-- ============================================================
-- DAY 62
-- CUSTOMER REVENUE ABC CLASSIFICATION ANALYSIS
-- ============================================================


-- ============================================================
-- 1. CUSTOMER REVENUE
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,
    total_orders,
    total_units,
    ROUND(total_revenue, 2) AS total_revenue
FROM customer_revenue
ORDER BY total_revenue DESC;


-- ============================================================
-- 2. CUSTOMER REVENUE RANKING
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,
    total_orders,
    total_units,
    ROUND(total_revenue, 2) AS total_revenue,

    ROW_NUMBER() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank

FROM customer_revenue

ORDER BY revenue_rank;


-- ============================================================
-- 3. REVENUE CONTRIBUTION AND CUMULATIVE REVENUE
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.customer_name
),

revenue_analysis AS (
    SELECT
        *,
        
        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank,

        SUM(total_revenue) OVER () AS overall_revenue,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS cumulative_revenue

    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,
    total_orders,
    total_units,
    ROUND(total_revenue, 2) AS total_revenue,
    revenue_rank,

    ROUND(
        total_revenue / overall_revenue * 100,
        2
    ) AS revenue_contribution_percentage,

    ROUND(
        cumulative_revenue / overall_revenue * 100,
        2
    ) AS cumulative_revenue_percentage

FROM revenue_analysis

ORDER BY revenue_rank;


-- ============================================================
-- 4. ABC CUSTOMER CLASSIFICATION
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.customer_name
),

revenue_analysis AS (
    SELECT
        *,
        
        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank,

        SUM(total_revenue) OVER () AS overall_revenue,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS cumulative_revenue

    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,
    total_orders,
    total_units,
    ROUND(total_revenue, 2) AS total_revenue,
    revenue_rank,

    ROUND(
        total_revenue / overall_revenue * 100,
        2
    ) AS revenue_contribution_percentage,

    ROUND(
        cumulative_revenue / overall_revenue * 100,
        2
    ) AS cumulative_revenue_percentage,

    CASE
        WHEN cumulative_revenue / overall_revenue * 100 <= 80
            THEN 'A'
        WHEN cumulative_revenue / overall_revenue * 100 <= 95
            THEN 'B'
        ELSE 'C'
    END AS abc_class

FROM revenue_analysis

ORDER BY revenue_rank;


-- ============================================================
-- 5. ABC CLASS SUMMARY
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.customer_name
),

revenue_analysis AS (
    SELECT
        *,
        
        SUM(total_revenue) OVER () AS overall_revenue,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS cumulative_revenue

    FROM customer_revenue
),

abc_customers AS (
    SELECT
        *,
        CASE
            WHEN cumulative_revenue / overall_revenue * 100 <= 80
                THEN 'A'
            WHEN cumulative_revenue / overall_revenue * 100 <= 95
                THEN 'B'
            ELSE 'C'
        END AS abc_class

    FROM revenue_analysis
)

SELECT
    abc_class,
    COUNT(*) AS customer_count,
    SUM(total_orders) AS total_orders,
    SUM(total_units) AS total_units,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_revenue_per_customer,

    ROUND(
        SUM(total_revenue) /
        MAX(overall_revenue) * 100,
        2
    ) AS revenue_contribution_percentage

FROM abc_customers

GROUP BY abc_class

ORDER BY
    CASE abc_class
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
    END;


-- ============================================================
-- 6. CLASS A CUSTOMERS
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.customer_name
),

revenue_analysis AS (
    SELECT
        *,
        SUM(total_revenue) OVER () AS overall_revenue,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS cumulative_revenue

    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,
    ROUND(total_revenue, 2) AS total_revenue
FROM revenue_analysis

WHERE cumulative_revenue / overall_revenue * 100 <= 80

ORDER BY total_revenue DESC;


-- ============================================================
-- 7. CLASS B CUSTOMERS
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.customer_name
),

revenue_analysis AS (
    SELECT
        *,
        SUM(total_revenue) OVER () AS overall_revenue,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS cumulative_revenue

    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,
    ROUND(total_revenue, 2) AS total_revenue
FROM revenue_analysis

WHERE cumulative_revenue / overall_revenue * 100 > 80
  AND cumulative_revenue / overall_revenue * 100 <= 95

ORDER BY total_revenue DESC;


-- ============================================================
-- 8. CLASS C CUSTOMERS
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.customer_name
),

revenue_analysis AS (
    SELECT
        *,
        SUM(total_revenue) OVER () AS overall_revenue,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS cumulative_revenue

    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,
    ROUND(total_revenue, 2) AS total_revenue
FROM revenue_analysis

WHERE cumulative_revenue / overall_revenue * 100 > 95

ORDER BY total_revenue DESC;