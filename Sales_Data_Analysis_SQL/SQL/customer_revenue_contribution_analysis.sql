-- ============================================================
-- Day 56: Customer Revenue Contribution & Concentration Analysis
-- Project: Sales Data Analysis Using SQL
-- Database: sales_analysis_db
-- ============================================================

USE sales_analysis_db;


-- ============================================================
-- Analysis 1: Total Revenue per Customer
-- ============================================================

SELECT
    o.customer_id,
    ROUND(SUM(oi.quantity * p.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY total_revenue DESC;


-- ============================================================
-- Analysis 2: Overall Business Revenue
-- ============================================================

SELECT
    ROUND(SUM(oi.quantity * p.price), 2) AS overall_business_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id;


-- ============================================================
-- Analysis 3: Customer Revenue Contribution Percentage
-- ============================================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        total_revenue * 100.0 /
        NULLIF(SUM(total_revenue) OVER (), 0),
        2
    ) AS revenue_contribution_percentage
FROM customer_revenue
ORDER BY total_revenue DESC;


-- ============================================================
-- Analysis 4: Customer Revenue Ranking
-- ============================================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM customer_revenue
ORDER BY revenue_rank;


-- ============================================================
-- Analysis 5: Cumulative Revenue Contribution Percentage
-- ============================================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
),

revenue_contribution AS (
    SELECT
        customer_id,
        total_revenue,
        total_revenue * 100.0 /
        NULLIF(SUM(total_revenue) OVER (), 0)
        AS revenue_contribution_percentage
    FROM customer_revenue
)

SELECT
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(revenue_contribution_percentage, 2)
        AS revenue_contribution_percentage,
    ROUND(
        SUM(revenue_contribution_percentage) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_revenue_contribution_percentage
FROM revenue_contribution
ORDER BY total_revenue DESC;


-- ============================================================
-- Analysis 6: Top 10 Customers by Revenue
-- ============================================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM customer_revenue
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- Analysis 7: Top 20% Customers' Revenue Contribution
-- ============================================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
),

ranked_customers AS (
    SELECT
        customer_id,
        total_revenue,
        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS customer_rank,
        COUNT(*) OVER () AS total_customers
    FROM customer_revenue
),

top_20_percent AS (
    SELECT
        customer_id,
        total_revenue
    FROM ranked_customers
    WHERE customer_rank <= CEIL(total_customers * 0.20)
)

SELECT
    COUNT(*) AS top_20_percent_customer_count,
    ROUND(SUM(total_revenue), 2) AS top_20_percent_revenue,
    ROUND(
        SUM(total_revenue) * 100.0 /
        NULLIF(
            (SELECT SUM(total_revenue)
             FROM customer_revenue),
            0
        ),
        2
    ) AS top_20_percent_revenue_contribution_percentage
FROM top_20_percent;


-- ============================================================
-- Analysis 8: Customer Revenue Contribution Classification
-- ============================================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
),

revenue_contribution AS (
    SELECT
        customer_id,
        total_revenue,
        total_revenue * 100.0 /
        NULLIF(SUM(total_revenue) OVER (), 0)
        AS revenue_contribution_percentage
    FROM customer_revenue
)

SELECT
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(revenue_contribution_percentage, 2)
        AS revenue_contribution_percentage,
    CASE
        WHEN revenue_contribution_percentage >= 10
            THEN 'Very High Revenue Contributor'
        WHEN revenue_contribution_percentage >= 5
            THEN 'High Revenue Contributor'
        WHEN revenue_contribution_percentage >= 2
            THEN 'Moderate Revenue Contributor'
        WHEN revenue_contribution_percentage >= 1
            THEN 'Low Revenue Contributor'
        ELSE 'Very Low Revenue Contributor'
    END AS revenue_contribution_classification
FROM revenue_contribution
ORDER BY total_revenue DESC;


-- ============================================================
-- Analysis 9: High-Value Revenue Customers
-- ============================================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,
    CASE
        WHEN total_revenue >= 10000
            THEN 'High-Value Revenue Customer'
        ELSE 'Standard Revenue Customer'
    END AS customer_value_category
FROM customer_revenue
WHERE total_revenue >= 10000
ORDER BY total_revenue DESC;


-- ============================================================
-- Analysis 10: Low-Value Revenue Customers
-- ============================================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,
    CASE
        WHEN total_revenue < 1000
            THEN 'Low-Value Revenue Customer'
        ELSE 'Standard Revenue Customer'
    END AS customer_value_category
FROM customer_revenue
WHERE total_revenue < 1000
ORDER BY total_revenue ASC;


-- ============================================================
-- Analysis 11: Revenue Concentration Analysis
-- ============================================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
),

ranked_revenue AS (
    SELECT
        customer_id,
        total_revenue,
        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS customer_rank,
        COUNT(*) OVER () AS total_customers,
        SUM(total_revenue) OVER () AS overall_revenue,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue
    FROM customer_revenue
)

SELECT
    customer_id,
    customer_rank,
    total_customers,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        total_revenue * 100.0 /
        NULLIF(overall_revenue, 0),
        2
    ) AS revenue_contribution_percentage,
    ROUND(
        cumulative_revenue * 100.0 /
        NULLIF(overall_revenue, 0),
        2
    ) AS cumulative_revenue_percentage,
    CASE
        WHEN cumulative_revenue * 100.0 /
             NULLIF(overall_revenue, 0) <= 20
            THEN 'Top Revenue Concentration'
        WHEN cumulative_revenue * 100.0 /
             NULLIF(overall_revenue, 0) <= 50
            THEN 'High Revenue Concentration'
        WHEN cumulative_revenue * 100.0 /
             NULLIF(overall_revenue, 0) <= 80
            THEN 'Moderate Revenue Concentration'
        ELSE 'Long-Tail Revenue'
    END AS revenue_concentration_segment
FROM ranked_revenue
ORDER BY customer_rank;


-- ============================================================
-- Analysis 12: Final Customer Revenue Contribution Summary
-- ============================================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * p.price) AS total_revenue,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
),

final_analysis AS (
    SELECT
        customer_id,
        total_orders,
        total_units,
        total_revenue,

        total_revenue * 100.0 /
        NULLIF(SUM(total_revenue) OVER (), 0)
        AS revenue_contribution_percentage,

        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) * 100.0 /
        NULLIF(SUM(total_revenue) OVER (), 0)
        AS cumulative_revenue_percentage
    FROM customer_revenue
)

SELECT
    customer_id,
    total_orders,
    total_units,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(revenue_contribution_percentage, 2)
        AS revenue_contribution_percentage,
    revenue_rank,
    ROUND(cumulative_revenue_percentage, 2)
        AS cumulative_revenue_percentage,

    CASE
        WHEN revenue_contribution_percentage >= 10
            THEN 'Very High Contributor'
        WHEN revenue_contribution_percentage >= 5
            THEN 'High Contributor'
        WHEN revenue_contribution_percentage >= 2
            THEN 'Moderate Contributor'
        WHEN revenue_contribution_percentage >= 1
            THEN 'Low Contributor'
        ELSE 'Very Low Contributor'
    END AS revenue_contribution_category,

    CASE
        WHEN total_revenue >= 10000
            THEN 'High-Value Customer'
        WHEN total_revenue >= 5000
            THEN 'Medium-Value Customer'
        WHEN total_revenue >= 1000
            THEN 'Standard-Value Customer'
        ELSE 'Low-Value Customer'
    END AS customer_value_category

FROM final_analysis
ORDER BY revenue_rank;


-- ============================================================
-- End of Day 56 Analysis
-- ============================================================