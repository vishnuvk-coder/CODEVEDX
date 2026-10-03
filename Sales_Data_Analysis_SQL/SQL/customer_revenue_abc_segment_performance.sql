USE sales_analysis_db;

-- ============================================================
-- DAY 63
-- CUSTOMER REVENUE ABC SEGMENT PERFORMANCE ANALYSIS
-- ============================================================


-- ============================================================
-- 1. CUSTOMER REVENUE BASE
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(oi.quantity * p.price) AS total_revenue,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.quantity) AS total_units

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

SELECT
    customer_id,
    customer_name,
    total_revenue,
    total_orders,
    total_units

FROM customer_revenue

ORDER BY total_revenue DESC;


-- ============================================================
-- 2. CUSTOMER REVENUE RANKING
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(oi.quantity * p.price) AS total_revenue,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.quantity) AS total_units

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

ranked_customers AS (
    SELECT
        customer_id,
        customer_name,
        total_revenue,
        total_orders,
        total_units,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,
    revenue_rank,
    total_revenue,
    total_orders,
    total_units

FROM ranked_customers

ORDER BY revenue_rank;


-- ============================================================
-- 3. CUSTOMER REVENUE CONTRIBUTION
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(oi.quantity * p.price) AS total_revenue,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.quantity) AS total_units

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

customer_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER ()
            AS overall_revenue

    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,
    total_revenue,
    total_orders,
    total_units,

    ROUND(
        total_revenue / overall_revenue * 100,
        2
    ) AS revenue_contribution_percentage

FROM customer_metrics

ORDER BY total_revenue DESC;


-- ============================================================
-- 4. CUMULATIVE REVENUE CONTRIBUTION
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(oi.quantity * p.price) AS total_revenue,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.quantity) AS total_units

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

customer_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER ()
            AS overall_revenue

    FROM customer_revenue
),

ranked_customers AS (
    SELECT
        *,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM customer_metrics
)

SELECT
    customer_id,
    customer_name,
    revenue_rank,
    total_revenue,
    total_orders,
    total_units,

    ROUND(
        total_revenue / overall_revenue * 100,
        2
    ) AS revenue_contribution_percentage,

    ROUND(
        SUM(total_revenue) OVER (
            ORDER BY revenue_rank
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) / overall_revenue * 100,
        2
    ) AS cumulative_revenue_percentage

FROM ranked_customers

ORDER BY revenue_rank;


-- ============================================================
-- 5. ABC CUSTOMER CLASSIFICATION
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(oi.quantity * p.price) AS total_revenue,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.quantity) AS total_units

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

customer_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER ()
            AS overall_revenue

    FROM customer_revenue
),

ranked_customers AS (
    SELECT
        *,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM customer_metrics
),

revenue_metrics AS (
    SELECT
        *,

        ROUND(
            total_revenue / overall_revenue * 100,
            2
        ) AS revenue_contribution_percentage,

        ROUND(
            SUM(total_revenue) OVER (
                ORDER BY revenue_rank
                ROWS BETWEEN UNBOUNDED PRECEDING
                AND CURRENT ROW
            ) / overall_revenue * 100,
            2
        ) AS cumulative_revenue_percentage

    FROM ranked_customers
)

SELECT
    customer_id,
    customer_name,
    revenue_rank,
    total_revenue,
    total_orders,
    total_units,
    revenue_contribution_percentage,
    cumulative_revenue_percentage,

    CASE
        WHEN cumulative_revenue_percentage <= 80
            THEN 'A'

        WHEN cumulative_revenue_percentage <= 95
            THEN 'B'

        ELSE 'C'

    END AS abc_segment

FROM revenue_metrics

ORDER BY revenue_rank;


-- ============================================================
-- 6. ABC SEGMENT PERFORMANCE
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(oi.quantity * p.price) AS total_revenue,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.quantity) AS total_units

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

customer_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER ()
            AS overall_revenue

    FROM customer_revenue
),

ranked_customers AS (
    SELECT
        *,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM customer_metrics
),

revenue_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER (
            ORDER BY revenue_rank
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) / overall_revenue * 100
            AS cumulative_revenue_percentage

    FROM ranked_customers
),

abc_customers AS (
    SELECT
        *,

        CASE
            WHEN cumulative_revenue_percentage <= 80
                THEN 'A'

            WHEN cumulative_revenue_percentage <= 95
                THEN 'B'

            ELSE 'C'

        END AS abc_segment

    FROM revenue_metrics
)

SELECT
    abc_segment,

    COUNT(*) AS customer_count,

    ROUND(
        SUM(total_revenue),
        2
    ) AS total_revenue,

    ROUND(
        SUM(total_revenue)
        / MAX(overall_revenue) * 100,
        2
    ) AS revenue_contribution_percentage,

    SUM(total_orders) AS total_orders,

    SUM(total_units) AS total_units,

    ROUND(
        AVG(total_revenue),
        2
    ) AS average_revenue_per_customer,

    ROUND(
        AVG(total_orders),
        2
    ) AS average_orders_per_customer,

    ROUND(
        AVG(total_units),
        2
    ) AS average_units_per_customer,

    ROUND(
        SUM(total_revenue)
        / NULLIF(SUM(total_orders), 0),
        2
    ) AS revenue_per_order,

    ROUND(
        SUM(total_revenue)
        / NULLIF(SUM(total_units), 0),
        2
    ) AS revenue_per_unit

FROM abc_customers

GROUP BY abc_segment

ORDER BY
    CASE abc_segment
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
    END;


-- ============================================================
-- 7. ABC SEGMENT CUSTOMER DETAILS
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(oi.quantity * p.price) AS total_revenue,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.quantity) AS total_units

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

customer_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER ()
            AS overall_revenue

    FROM customer_revenue
),

ranked_customers AS (
    SELECT
        *,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM customer_metrics
),

revenue_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER (
            ORDER BY revenue_rank
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) / overall_revenue * 100
            AS cumulative_revenue_percentage

    FROM ranked_customers
)

SELECT
    customer_id,
    customer_name,
    revenue_rank,
    total_revenue,
    total_orders,
    total_units,

    ROUND(
        total_revenue / overall_revenue * 100,
        2
    ) AS revenue_contribution_percentage,

    ROUND(
        cumulative_revenue_percentage,
        2
    ) AS cumulative_revenue_percentage,

    CASE
        WHEN cumulative_revenue_percentage <= 80
            THEN 'A'

        WHEN cumulative_revenue_percentage <= 95
            THEN 'B'

        ELSE 'C'

    END AS abc_segment

FROM revenue_metrics

ORDER BY
    CASE
        WHEN cumulative_revenue_percentage <= 80 THEN 1
        WHEN cumulative_revenue_percentage <= 95 THEN 2
        ELSE 3
    END,

    revenue_rank;


-- ============================================================
-- 8. ABC SEGMENT REVENUE CONCENTRATION
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

customer_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER ()
            AS overall_revenue

    FROM customer_revenue
),

ranked_customers AS (
    SELECT
        *,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM customer_metrics
),

revenue_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER (
            ORDER BY revenue_rank
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) / overall_revenue * 100
            AS cumulative_revenue_percentage

    FROM ranked_customers
),

abc_customers AS (
    SELECT
        *,

        CASE
            WHEN cumulative_revenue_percentage <= 80
                THEN 'A'

            WHEN cumulative_revenue_percentage <= 95
                THEN 'B'

            ELSE 'C'

        END AS abc_segment

    FROM revenue_metrics
)

SELECT
    abc_segment,

    COUNT(*) AS customer_count,

    ROUND(
        SUM(total_revenue),
        2
    ) AS total_revenue,

    ROUND(
        SUM(total_revenue)
        / MAX(overall_revenue) * 100,
        2
    ) AS revenue_contribution_percentage

FROM abc_customers

GROUP BY abc_segment

ORDER BY
    CASE abc_segment
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
    END;


-- ============================================================
-- 9. A SEGMENT CUSTOMER ANALYSIS
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(oi.quantity * p.price) AS total_revenue,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.quantity) AS total_units

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

customer_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER ()
            AS overall_revenue

    FROM customer_revenue
),

ranked_customers AS (
    SELECT
        *,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM customer_metrics
),

revenue_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER (
            ORDER BY revenue_rank
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) / overall_revenue * 100
            AS cumulative_revenue_percentage

    FROM ranked_customers
),

abc_customers AS (
    SELECT
        *,

        CASE
            WHEN cumulative_revenue_percentage <= 80
                THEN 'A'

            WHEN cumulative_revenue_percentage <= 95
                THEN 'B'

            ELSE 'C'

        END AS abc_segment

    FROM revenue_metrics
)

SELECT
    customer_id,
    customer_name,
    revenue_rank,
    total_revenue,
    total_orders,
    total_units,

    ROUND(
        total_revenue / NULLIF(total_orders, 0),
        2
    ) AS average_order_value,

    ROUND(
        total_revenue / NULLIF(total_units, 0),
        2
    ) AS revenue_per_unit

FROM abc_customers

WHERE abc_segment = 'A'

ORDER BY total_revenue DESC;


-- ============================================================
-- 10. B SEGMENT CUSTOMER ANALYSIS
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(oi.quantity * p.price) AS total_revenue,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.quantity) AS total_units

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

customer_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER ()
            AS overall_revenue

    FROM customer_revenue
),

ranked_customers AS (
    SELECT
        *,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM customer_metrics
),

revenue_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER (
            ORDER BY revenue_rank
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) / overall_revenue * 100
            AS cumulative_revenue_percentage

    FROM ranked_customers
),

abc_customers AS (
    SELECT
        *,

        CASE
            WHEN cumulative_revenue_percentage <= 80
                THEN 'A'

            WHEN cumulative_revenue_percentage <= 95
                THEN 'B'

            ELSE 'C'

        END AS abc_segment

    FROM revenue_metrics
)

SELECT
    customer_id,
    customer_name,
    revenue_rank,
    total_revenue,
    total_orders,
    total_units,

    ROUND(
        total_revenue / NULLIF(total_orders, 0),
        2
    ) AS average_order_value,

    ROUND(
        total_revenue / NULLIF(total_units, 0),
        2
    ) AS revenue_per_unit

FROM abc_customers

WHERE abc_segment = 'B'

ORDER BY total_revenue DESC;


-- ============================================================
-- 11. C SEGMENT CUSTOMER ANALYSIS
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(oi.quantity * p.price) AS total_revenue,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.quantity) AS total_units

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

customer_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER ()
            AS overall_revenue

    FROM customer_revenue
),

ranked_customers AS (
    SELECT
        *,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM customer_metrics
),

revenue_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER (
            ORDER BY revenue_rank
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) / overall_revenue * 100
            AS cumulative_revenue_percentage

    FROM ranked_customers
),

abc_customers AS (
    SELECT
        *,

        CASE
            WHEN cumulative_revenue_percentage <= 80
                THEN 'A'

            WHEN cumulative_revenue_percentage <= 95
                THEN 'B'

            ELSE 'C'

        END AS abc_segment

    FROM revenue_metrics
)

SELECT
    customer_id,
    customer_name,
    revenue_rank,
    total_revenue,
    total_orders,
    total_units,

    ROUND(
        total_revenue / NULLIF(total_orders, 0),
        2
    ) AS average_order_value,

    ROUND(
        total_revenue / NULLIF(total_units, 0),
        2
    ) AS revenue_per_unit

FROM abc_customers

WHERE abc_segment = 'C'

ORDER BY total_revenue DESC;


-- ============================================================
-- 12. FINAL DAY 63 ABC PERFORMANCE SUMMARY
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(oi.quantity * p.price) AS total_revenue,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.quantity) AS total_units

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

customer_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER ()
            AS overall_revenue

    FROM customer_revenue
),

ranked_customers AS (
    SELECT
        *,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM customer_metrics
),

revenue_metrics AS (
    SELECT
        *,

        SUM(total_revenue) OVER (
            ORDER BY revenue_rank
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) / overall_revenue * 100
            AS cumulative_revenue_percentage

    FROM ranked_customers
),

abc_customers AS (
    SELECT
        *,

        CASE
            WHEN cumulative_revenue_percentage <= 80
                THEN 'A'

            WHEN cumulative_revenue_percentage <= 95
                THEN 'B'

            ELSE 'C'

        END AS abc_segment

    FROM revenue_metrics
)

SELECT
    abc_segment,

    COUNT(*) AS customer_count,

    ROUND(
        SUM(total_revenue),
        2
    ) AS total_revenue,

    ROUND(
        SUM(total_revenue)
        / MAX(overall_revenue) * 100,
        2
    ) AS revenue_contribution_percentage,

    SUM(total_orders) AS total_orders,

    SUM(total_units) AS total_units,

    ROUND(
        AVG(total_revenue),
        2
    ) AS average_revenue_per_customer,

    ROUND(
        AVG(total_orders),
        2
    ) AS average_orders_per_customer,

    ROUND(
        AVG(total_units),
        2
    ) AS average_units_per_customer,

    ROUND(
        SUM(total_revenue)
        / NULLIF(SUM(total_orders), 0),
        2
    ) AS revenue_per_order,

    ROUND(
        SUM(total_revenue)
        / NULLIF(SUM(total_units), 0),
        2
    ) AS revenue_per_unit

FROM abc_customers

GROUP BY abc_segment

ORDER BY
    CASE abc_segment
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
    END;
    



-- ============================================================
-- END OF DAY 63
-- CUSTOMER REVENUE ABC SEGMENT PERFORMANCE ANALYSIS
-- ============================================================