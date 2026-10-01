USE sales_analysis_db;

-- =========================================================
-- DAY 61
-- CUSTOMER REVENUE QUARTILE PERFORMANCE & SEGMENT ANALYSIS
-- =========================================================


-- =========================================================
-- 1. CUSTOMER REVENUE ANALYSIS
-- =========================================================

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


-- =========================================================
-- 2. CUSTOMER REVENUE RANKING
-- =========================================================

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
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_revenue, 2) AS total_revenue,
    ROW_NUMBER() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM customer_revenue
ORDER BY revenue_rank;


-- =========================================================
-- 3. CUSTOMER REVENUE QUARTILE
-- =========================================================

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
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_revenue, 2) AS total_revenue,
    NTILE(4) OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_quartile
FROM customer_revenue
ORDER BY revenue_quartile, total_revenue DESC;


-- =========================================================
-- 4. CUSTOMER COUNT BY QUARTILE
-- =========================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id
),
quartiles AS (
    SELECT
        customer_id,
        total_revenue,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_revenue
)
SELECT
    revenue_quartile,
    COUNT(*) AS customer_count
FROM quartiles
GROUP BY revenue_quartile
ORDER BY revenue_quartile;


-- =========================================================
-- 5. TOTAL REVENUE BY QUARTILE
-- =========================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id
),
quartiles AS (
    SELECT
        customer_id,
        total_revenue,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_revenue
)
SELECT
    revenue_quartile,
    ROUND(SUM(total_revenue), 2) AS quartile_revenue
FROM quartiles
GROUP BY revenue_quartile
ORDER BY revenue_quartile;


-- =========================================================
-- 6. REVENUE CONTRIBUTION BY QUARTILE
-- =========================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id
),
quartiles AS (
    SELECT
        customer_id,
        total_revenue,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_revenue
),
quartile_revenue AS (
    SELECT
        revenue_quartile,
        SUM(total_revenue) AS quartile_revenue
    FROM quartiles
    GROUP BY revenue_quartile
)
SELECT
    revenue_quartile,
    ROUND(quartile_revenue, 2) AS quartile_revenue,
    ROUND(
        quartile_revenue /
        SUM(quartile_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_percentage
FROM quartile_revenue
ORDER BY revenue_quartile;


-- =========================================================
-- 7. AVERAGE REVENUE PER CUSTOMER BY QUARTILE
-- =========================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id
),
quartiles AS (
    SELECT
        customer_id,
        total_revenue,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_revenue
)
SELECT
    revenue_quartile,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_revenue), 2) AS average_revenue_per_customer
FROM quartiles
GROUP BY revenue_quartile
ORDER BY revenue_quartile;


-- =========================================================
-- 8. ORDERS AND UNITS BY QUARTILE
-- =========================================================

WITH customer_metrics AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id
),
quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_metrics
)
SELECT
    revenue_quartile,
    SUM(total_orders) AS total_orders,
    ROUND(AVG(total_orders), 2) AS average_orders_per_customer,
    SUM(total_units) AS total_units,
    ROUND(AVG(total_units), 2) AS average_units_per_customer
FROM quartiles
GROUP BY revenue_quartile
ORDER BY revenue_quartile;


-- =========================================================
-- 9. CUMULATIVE REVENUE BY QUARTILE
-- =========================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id
),
quartiles AS (
    SELECT
        customer_id,
        total_revenue,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_revenue
),
quartile_summary AS (
    SELECT
        revenue_quartile,
        SUM(total_revenue) AS quartile_revenue
    FROM quartiles
    GROUP BY revenue_quartile
)
SELECT
    revenue_quartile,
    ROUND(quartile_revenue, 2) AS quartile_revenue,
    ROUND(
        SUM(quartile_revenue) OVER (
            ORDER BY revenue_quartile
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS cumulative_revenue,
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


-- =========================================================
-- 10. TOP REVENUE QUARTILE
-- =========================================================

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
quartiles AS (
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
FROM quartiles
WHERE revenue_quartile = 1
ORDER BY total_revenue DESC;


-- =========================================================
-- 11. BOTTOM REVENUE QUARTILE
-- =========================================================

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
quartiles AS (
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
FROM quartiles
WHERE revenue_quartile = 4
ORDER BY total_revenue DESC;


-- =========================================================
-- 12. FINAL QUARTILE DISTRIBUTION SUMMARY
-- =========================================================

WITH customer_metrics AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id
),
quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile
    FROM customer_metrics
)
SELECT
    revenue_quartile,
    COUNT(*) AS customer_count,
    SUM(total_orders) AS total_orders,
    SUM(total_units) AS total_units,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_customer_revenue,
    ROUND(
        SUM(total_revenue) /
        SUM(SUM(total_revenue)) OVER () * 100,
        2
    ) AS revenue_contribution_percentage
FROM quartiles
GROUP BY revenue_quartile
ORDER BY revenue_quartile;