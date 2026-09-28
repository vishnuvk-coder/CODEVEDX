USE sales_analysis_db;

-- ============================================================
-- DAY 58: CUSTOMER REVENUE PARETO & 80/20 ANALYSIS
-- ============================================================


-- ============================================================
-- 1. Total Revenue per Customer
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
)

SELECT
    customer_id,
    customer_name,
    ROUND(total_revenue, 2) AS total_revenue

FROM customer_revenue

ORDER BY total_revenue DESC;


-- ============================================================
-- 2. Customer Revenue Ranking
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
)

SELECT
    customer_id,
    customer_name,
    ROUND(total_revenue, 2) AS total_revenue,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank

FROM customer_revenue

ORDER BY revenue_rank;


-- ============================================================
-- 3. Customer Revenue Contribution Percentage
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
)

SELECT
    customer_id,
    customer_name,
    ROUND(total_revenue, 2) AS total_revenue,

    ROUND(
        total_revenue /
        SUM(total_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_percentage

FROM customer_revenue

ORDER BY total_revenue DESC;


-- ============================================================
-- 4. Cumulative Revenue Percentage
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

ranked_customers AS (

    SELECT
        customer_id,
        customer_name,
        total_revenue,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS customer_rank,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS cumulative_revenue,

        SUM(total_revenue) OVER () AS overall_revenue

    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,

    ROUND(total_revenue, 2) AS total_revenue,

    customer_rank,

    ROUND(
        total_revenue / overall_revenue * 100,
        2
    ) AS revenue_contribution_percentage,

    ROUND(
        cumulative_revenue / overall_revenue * 100,
        2
    ) AS cumulative_revenue_percentage

FROM ranked_customers

ORDER BY customer_rank;


-- ============================================================
-- 5. Customers Required to Reach 50% Revenue
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

ranked_customers AS (

    SELECT
        customer_id,
        customer_name,
        total_revenue,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS customer_rank,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS cumulative_revenue,

        SUM(total_revenue) OVER () AS overall_revenue

    FROM customer_revenue
)

SELECT
    MIN(customer_rank) AS customers_needed_for_50_percent_revenue

FROM ranked_customers

WHERE cumulative_revenue / overall_revenue * 100 >= 50;


-- ============================================================
-- 6. Customers Required to Reach 80% Revenue
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

ranked_customers AS (

    SELECT
        customer_id,
        customer_name,
        total_revenue,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS customer_rank,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS cumulative_revenue,

        SUM(total_revenue) OVER () AS overall_revenue

    FROM customer_revenue
)

SELECT
    MIN(customer_rank) AS customers_needed_for_80_percent_revenue

FROM ranked_customers

WHERE cumulative_revenue / overall_revenue * 100 >= 80;


-- ============================================================
-- 7. Percentage of Customers Generating 80% Revenue
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

ranked_customers AS (

    SELECT
        customer_id,
        total_revenue,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS customer_rank,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS cumulative_revenue,

        SUM(total_revenue) OVER () AS overall_revenue,

        COUNT(*) OVER () AS total_customers

    FROM customer_revenue
),

pareto_point AS (

    SELECT
        MIN(customer_rank) AS customers_for_80_percent,
        MAX(total_customers) AS total_customers

    FROM ranked_customers

    WHERE cumulative_revenue / overall_revenue * 100 >= 80
)

SELECT
    customers_for_80_percent,
    total_customers,

    ROUND(
        customers_for_80_percent /
        total_customers * 100,
        2
    ) AS percentage_of_customers

FROM pareto_point;


-- ============================================================
-- 8. Top 10% Customers Revenue Contribution
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

ranked_customers AS (

    SELECT
        *,
        NTILE(10) OVER (
            ORDER BY total_revenue DESC
        ) AS customer_decile

    FROM customer_revenue
)

SELECT
    ROUND(
        SUM(
            CASE
                WHEN customer_decile = 1
                THEN total_revenue
                ELSE 0
            END
        ),
        2
    ) AS top_10_customer_revenue,

    ROUND(
        SUM(
            CASE
                WHEN customer_decile = 1
                THEN total_revenue
                ELSE 0
            END
        )
        /
        SUM(total_revenue)
        * 100,
        2
    ) AS top_10_revenue_percentage

FROM ranked_customers;


-- ============================================================
-- 9. Top 20% Customers Revenue Contribution
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

ranked_customers AS (

    SELECT
        *,
        NTILE(5) OVER (
            ORDER BY total_revenue DESC
        ) AS customer_quintile

    FROM customer_revenue
)

SELECT
    ROUND(
        SUM(
            CASE
                WHEN customer_quintile = 1
                THEN total_revenue
                ELSE 0
            END
        ),
        2
    ) AS top_20_customer_revenue,

    ROUND(
        SUM(
            CASE
                WHEN customer_quintile = 1
                THEN total_revenue
                ELSE 0
            END
        )
        /
        SUM(total_revenue)
        * 100,
        2
    ) AS top_20_revenue_percentage

FROM ranked_customers;


-- ============================================================
-- 10. Top 30% Customers Revenue Contribution
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

ranked_customers AS (

    SELECT
        *,
        NTILE(10) OVER (
            ORDER BY total_revenue DESC
        ) AS customer_decile

    FROM customer_revenue
)

SELECT
    ROUND(
        SUM(
            CASE
                WHEN customer_decile <= 3
                THEN total_revenue
                ELSE 0
            END
        ),
        2
    ) AS top_30_customer_revenue,

    ROUND(
        SUM(
            CASE
                WHEN customer_decile <= 3
                THEN total_revenue
                ELSE 0
            END
        )
        /
        SUM(total_revenue)
        * 100,
        2
    ) AS top_30_revenue_percentage

FROM ranked_customers;


-- ============================================================
-- 11. Pareto Customer Classification
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

ranked_customers AS (

    SELECT
        customer_id,
        customer_name,
        total_revenue,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS customer_rank,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        )
        /
        SUM(total_revenue) OVER () * 100
        AS cumulative_revenue_percentage

    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,

    ROUND(total_revenue, 2) AS total_revenue,

    customer_rank,

    ROUND(
        cumulative_revenue_percentage,
        2
    ) AS cumulative_revenue_percentage,

    CASE
        WHEN cumulative_revenue_percentage <= 50
            THEN 'Top Revenue Core'

        WHEN cumulative_revenue_percentage <= 80
            THEN 'Pareto Revenue Group'

        ELSE 'Long-Tail Revenue Group'
    END AS pareto_segment

FROM ranked_customers

ORDER BY customer_rank;


-- ============================================================
-- 12. Revenue Above and Below 80% Pareto Threshold
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

ranked_customers AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS customer_rank,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        )
        /
        SUM(total_revenue) OVER () * 100
        AS cumulative_revenue_percentage

    FROM customer_revenue
)

SELECT

    ROUND(
        SUM(
            CASE
                WHEN cumulative_revenue_percentage <= 80
                THEN total_revenue
                ELSE 0
            END
        ),
        2
    ) AS revenue_within_80_percent_group,

    ROUND(
        SUM(
            CASE
                WHEN cumulative_revenue_percentage > 80
                THEN total_revenue
                ELSE 0
            END
        ),
        2
    ) AS revenue_after_80_percent_group

FROM ranked_customers;


-- ============================================================
-- 13. Pareto Revenue Concentration Summary
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

ranked_customers AS (

    SELECT
        customer_id,
        customer_name,
        total_revenue,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS customer_rank,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS cumulative_revenue,

        SUM(total_revenue) OVER () AS overall_revenue,

        COUNT(*) OVER () AS total_customers

    FROM customer_revenue
),

summary AS (

    SELECT
        MIN(
            CASE
                WHEN cumulative_revenue / overall_revenue * 100 >= 50
                THEN customer_rank
            END
        ) AS customers_for_50_percent,

        MIN(
            CASE
                WHEN cumulative_revenue / overall_revenue * 100 >= 80
                THEN customer_rank
            END
        ) AS customers_for_80_percent,

        MAX(total_customers) AS total_customers,

        MAX(overall_revenue) AS overall_revenue

    FROM ranked_customers
)

SELECT

    total_customers,

    ROUND(overall_revenue, 2)
        AS total_customer_revenue,

    customers_for_50_percent,

    ROUND(
        customers_for_50_percent /
        total_customers * 100,
        2
    ) AS customer_percentage_for_50_revenue,

    customers_for_80_percent,

    ROUND(
        customers_for_80_percent /
        total_customers * 100,
        2
    ) AS customer_percentage_for_80_revenue,

    ROUND(
        100 -
        (
            customers_for_80_percent /
            total_customers * 100
        ),
        2
    ) AS remaining_customer_percentage

FROM summary;


-- ============================================================
-- 14. Final Day 58 Pareto Analysis
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

final_analysis AS (

    SELECT
        customer_id,
        customer_name,
        total_revenue,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        )
        /
        SUM(total_revenue) OVER () * 100
        AS cumulative_revenue_percentage,

        SUM(total_revenue) OVER ()
        AS overall_revenue

    FROM customer_revenue
)

SELECT

    customer_id,
    customer_name,

    ROUND(
        total_revenue,
        2
    ) AS total_revenue,

    revenue_rank,

    ROUND(
        total_revenue /
        overall_revenue * 100,
        2
    ) AS revenue_contribution_percentage,

    ROUND(
        cumulative_revenue_percentage,
        2
    ) AS cumulative_revenue_percentage,

    CASE
        WHEN cumulative_revenue_percentage <= 50
            THEN 'Top 50% Revenue Group'

        WHEN cumulative_revenue_percentage <= 80
            THEN 'Pareto 80% Revenue Group'

        ELSE 'Long-Tail Revenue Group'
    END AS pareto_segment

FROM final_analysis

ORDER BY revenue_rank;