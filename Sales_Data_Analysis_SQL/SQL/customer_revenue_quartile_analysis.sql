-- ============================================================
-- DAY 60
-- CUSTOMER REVENUE QUARTILE & VALUE DISTRIBUTION ANALYSIS
-- ============================================================

USE sales_analysis_db;


-- ============================================================
-- 1. VERIFY DATABASE
-- ============================================================

SELECT DATABASE();


-- ============================================================
-- 2. VERIFY TABLES
-- ============================================================

SHOW TABLES;


-- ============================================================
-- 3. TOTAL CUSTOMER COUNT
-- ============================================================

SELECT
    COUNT(*) AS total_customers
FROM customers;


-- ============================================================
-- 4. CUSTOMER REVENUE CALCULATION
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT *
FROM customer_revenue
ORDER BY total_revenue DESC;


-- ============================================================
-- 5. CUSTOMER REVENUE QUARTILE CLASSIFICATION
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
),

customer_quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,
    total_orders,
    total_units,
    total_revenue,
    revenue_quartile,
    CASE
        WHEN revenue_quartile = 1 THEN 'Q1 - Highest Revenue'
        WHEN revenue_quartile = 2 THEN 'Q2 - High Revenue'
        WHEN revenue_quartile = 3 THEN 'Q3 - Low Revenue'
        WHEN revenue_quartile = 4 THEN 'Q4 - Lowest Revenue'
    END AS revenue_segment
FROM customer_quartiles
ORDER BY
    revenue_quartile,
    total_revenue DESC;


-- ============================================================
-- 6. QUARTILE CUSTOMER COUNT
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id
),

customer_quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_revenue
)

SELECT
    revenue_quartile,
    COUNT(*) AS customer_count
FROM customer_quartiles
GROUP BY revenue_quartile
ORDER BY revenue_quartile;


-- ============================================================
-- 7. REVENUE BY QUARTILE
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id
),

customer_quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_revenue
)

SELECT
    revenue_quartile,
    COUNT(*) AS customer_count,
    ROUND(SUM(total_revenue), 2) AS quartile_revenue,
    ROUND(AVG(total_revenue), 2) AS average_customer_revenue,
    ROUND(MIN(total_revenue), 2) AS minimum_customer_revenue,
    ROUND(MAX(total_revenue), 2) AS maximum_customer_revenue
FROM customer_quartiles
GROUP BY revenue_quartile
ORDER BY revenue_quartile;


-- ============================================================
-- 8. QUARTILE REVENUE CONTRIBUTION %
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id
),

customer_quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_revenue
),

quartile_summary AS (
    SELECT
        revenue_quartile,
        COUNT(*) AS customer_count,
        SUM(total_revenue) AS quartile_revenue
    FROM customer_quartiles
    GROUP BY revenue_quartile
)

SELECT
    revenue_quartile,
    customer_count,
    ROUND(quartile_revenue, 2) AS quartile_revenue,
    ROUND(
        quartile_revenue /
        SUM(quartile_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_percentage
FROM quartile_summary
ORDER BY revenue_quartile;


-- ============================================================
-- 9. CUMULATIVE REVENUE CONTRIBUTION BY QUARTILE
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id
),

customer_quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_revenue
),

quartile_summary AS (
    SELECT
        revenue_quartile,
        SUM(total_revenue) AS quartile_revenue
    FROM customer_quartiles
    GROUP BY revenue_quartile
)

SELECT
    revenue_quartile,
    ROUND(quartile_revenue, 2) AS quartile_revenue,
    ROUND(
        quartile_revenue /
        SUM(quartile_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_percentage,
    ROUND(
        SUM(quartile_revenue) OVER (
            ORDER BY revenue_quartile
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        )
        /
        SUM(quartile_revenue) OVER () * 100,
        2
    ) AS cumulative_revenue_percentage
FROM quartile_summary
ORDER BY revenue_quartile;


-- ============================================================
-- 10. QUARTILE ORDER & UNIT ANALYSIS
-- ============================================================

WITH customer_metrics AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id
),

customer_quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_metrics
)

SELECT
    revenue_quartile,
    COUNT(*) AS customers,
    SUM(total_orders) AS total_orders,
    SUM(total_units) AS total_units,
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer,
    ROUND(AVG(total_units), 2) AS avg_units_per_customer,
    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_customer
FROM customer_quartiles
GROUP BY revenue_quartile
ORDER BY revenue_quartile;


-- ============================================================
-- 11. TOP QUARTILE CUSTOMER ANALYSIS
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
),

customer_quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,
    total_orders,
    total_units,
    ROUND(total_revenue, 2) AS total_revenue
FROM customer_quartiles
WHERE revenue_quartile = 1
ORDER BY total_revenue DESC;


-- ============================================================
-- 12. BOTTOM QUARTILE CUSTOMER ANALYSIS
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
),

customer_quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,
    total_orders,
    total_units,
    ROUND(total_revenue, 2) AS total_revenue
FROM customer_quartiles
WHERE revenue_quartile = 4
ORDER BY total_revenue ASC;


-- ============================================================
-- 13. CUSTOMER VALUE CLASSIFICATION
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
),

customer_quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,
    ROUND(total_revenue, 2) AS total_revenue,
    CASE
        WHEN revenue_quartile = 1
            THEN 'Premium Customer'
        WHEN revenue_quartile = 2
            THEN 'High-Value Customer'
        WHEN revenue_quartile = 3
            THEN 'Standard Customer'
        WHEN revenue_quartile = 4
            THEN 'Low-Value Customer'
    END AS customer_value_segment
FROM customer_quartiles
ORDER BY total_revenue DESC;


-- ============================================================
-- 14. FINAL DAY 60 SUMMARY
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id
),

customer_quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_revenue
),

quartile_summary AS (
    SELECT
        revenue_quartile,
        COUNT(*) AS customer_count,
        SUM(total_revenue) AS quartile_revenue
    FROM customer_quartiles
    GROUP BY revenue_quartile
)

SELECT
    SUM(customer_count) AS total_customers,
    ROUND(SUM(quartile_revenue), 2) AS total_customer_revenue,

    MAX(
        CASE
            WHEN revenue_quartile = 1
            THEN customer_count
        END
    ) AS top_quartile_customers,

    ROUND(
        MAX(
            CASE
                WHEN revenue_quartile = 1
                THEN quartile_revenue
            END
        ), 2
    ) AS top_quartile_revenue,

    ROUND(
        MAX(
            CASE
                WHEN revenue_quartile = 1
                THEN quartile_revenue
            END
        )
        /
        SUM(quartile_revenue) * 100,
        2
    ) AS top_quartile_revenue_percentage,

    ROUND(
        MAX(
            CASE
                WHEN revenue_quartile = 4
                THEN quartile_revenue
            END
        ), 2
    ) AS bottom_quartile_revenue,

    ROUND(
        MAX(
            CASE
                WHEN revenue_quartile = 4
                THEN quartile_revenue
            END
        )
        /
        SUM(quartile_revenue) * 100,
        2
    ) AS bottom_quartile_revenue_percentage

FROM quartile_summary;


-- ============================================================
-- END OF DAY 60
-- CUSTOMER REVENUE QUARTILE ANALYSIS
-- ============================================================