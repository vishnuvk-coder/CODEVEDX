USE sales_analysis_db;

-- ============================================================
-- DAY 64
-- Customer Revenue ABC Segment Comparison & Business Priority
-- ============================================================

-- ============================================================
-- ANALYSIS 1
-- Total Revenue per Customer
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
    ROUND(total_revenue, 2) AS total_revenue
FROM customer_revenue
ORDER BY total_revenue DESC;


-- ============================================================
-- ANALYSIS 2
-- Customer Revenue Ranking
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
    ROW_NUMBER() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM customer_revenue
ORDER BY revenue_rank;


-- ============================================================
-- ANALYSIS 3
-- Revenue Contribution Percentage
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
        total_revenue /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100,
        2
    ) AS revenue_contribution_pct
FROM customer_revenue
ORDER BY total_revenue DESC;


-- ============================================================
-- ANALYSIS 4
-- ABC Classification
-- A = Up to 80%
-- B = 80% to 95%
-- C = Above 95%
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
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100
        AS cumulative_revenue_pct
    FROM customer_revenue
)
SELECT
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(cumulative_revenue_pct, 2) AS cumulative_revenue_pct,
    CASE
        WHEN cumulative_revenue_pct <= 80 THEN 'A'
        WHEN cumulative_revenue_pct <= 95 THEN 'B'
        ELSE 'C'
    END AS abc_segment
FROM ranked_customers
ORDER BY total_revenue DESC;


-- ============================================================
-- ANALYSIS 5
-- Complete Customer ABC Metrics
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
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
        total_orders,
        total_units,
        total_revenue,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100
        AS cumulative_revenue_pct
    FROM customer_metrics
),
abc_customers AS (
    SELECT
        customer_id,
        total_orders,
        total_units,
        total_revenue,
        cumulative_revenue_pct,
        CASE
            WHEN cumulative_revenue_pct <= 80 THEN 'A'
            WHEN cumulative_revenue_pct <= 95 THEN 'B'
            ELSE 'C'
        END AS abc_segment
    FROM ranked_customers
)
SELECT
    customer_id,
    abc_segment,
    ROUND(total_revenue, 2) AS total_revenue,
    total_orders,
    total_units,
    ROUND(
        total_revenue / NULLIF(total_orders, 0),
        2
    ) AS revenue_per_order,
    ROUND(
        total_revenue / NULLIF(total_units, 0),
        2
    ) AS revenue_per_unit
FROM abc_customers
ORDER BY
    CASE abc_segment
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
    END,
    total_revenue DESC;


-- ============================================================
-- ANALYSIS 6
-- Customer Count by ABC Segment
-- ============================================================

WITH customer_metrics AS (
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
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100
        AS cumulative_revenue_pct
    FROM customer_metrics
),
abc_customers AS (
    SELECT
        customer_id,
        total_revenue,
        CASE
            WHEN cumulative_revenue_pct <= 80 THEN 'A'
            WHEN cumulative_revenue_pct <= 95 THEN 'B'
            ELSE 'C'
        END AS abc_segment
    FROM ranked_customers
)
SELECT
    abc_segment,
    COUNT(*) AS customer_count
FROM abc_customers
GROUP BY abc_segment
ORDER BY
    CASE abc_segment
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
    END;


-- ============================================================
-- ANALYSIS 7
-- Revenue by ABC Segment
-- ============================================================

WITH customer_metrics AS (
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
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100
        AS cumulative_revenue_pct
    FROM customer_metrics
),
abc_customers AS (
    SELECT
        customer_id,
        total_revenue,
        CASE
            WHEN cumulative_revenue_pct <= 80 THEN 'A'
            WHEN cumulative_revenue_pct <= 95 THEN 'B'
            ELSE 'C'
        END AS abc_segment
    FROM ranked_customers
)
SELECT
    abc_segment,
    ROUND(SUM(total_revenue), 2) AS segment_revenue
FROM abc_customers
GROUP BY abc_segment
ORDER BY
    CASE abc_segment
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
    END;


-- ============================================================
-- ANALYSIS 8
-- Revenue Contribution by ABC Segment
-- ============================================================

WITH customer_metrics AS (
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
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100
        AS cumulative_revenue_pct
    FROM customer_metrics
),
abc_customers AS (
    SELECT
        customer_id,
        total_revenue,
        CASE
            WHEN cumulative_revenue_pct <= 80 THEN 'A'
            WHEN cumulative_revenue_pct <= 95 THEN 'B'
            ELSE 'C'
        END AS abc_segment
    FROM ranked_customers
)
SELECT
    abc_segment,
    ROUND(SUM(total_revenue), 2) AS segment_revenue,
    ROUND(
        SUM(total_revenue) /
        NULLIF(SUM(SUM(total_revenue)) OVER (), 0) * 100,
        2
    ) AS revenue_contribution_pct
FROM abc_customers
GROUP BY abc_segment
ORDER BY
    CASE abc_segment
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
    END;


-- ============================================================
-- ANALYSIS 9
-- Orders by ABC Segment
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
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
        *,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100
        AS cumulative_revenue_pct
    FROM customer_metrics
),
abc_customers AS (
    SELECT
        *,
        CASE
            WHEN cumulative_revenue_pct <= 80 THEN 'A'
            WHEN cumulative_revenue_pct <= 95 THEN 'B'
            ELSE 'C'
        END AS abc_segment
    FROM ranked_customers
)
SELECT
    abc_segment,
    SUM(total_orders) AS total_orders
FROM abc_customers
GROUP BY abc_segment
ORDER BY
    CASE abc_segment
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
    END;


-- ============================================================
-- ANALYSIS 10
-- Units by ABC Segment
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity) AS total_units,
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
        *,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100
        AS cumulative_revenue_pct
    FROM customer_metrics
),
abc_customers AS (
    SELECT
        *,
        CASE
            WHEN cumulative_revenue_pct <= 80 THEN 'A'
            WHEN cumulative_revenue_pct <= 95 THEN 'B'
            ELSE 'C'
        END AS abc_segment
    FROM ranked_customers
)
SELECT
    abc_segment,
    SUM(total_units) AS total_units
FROM abc_customers
GROUP BY abc_segment
ORDER BY
    CASE abc_segment
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
    END;


-- ============================================================
-- ANALYSIS 11
-- Average Revenue per Customer
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
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
        *,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100
        AS cumulative_revenue_pct
    FROM customer_metrics
),
abc_customers AS (
    SELECT
        *,
        CASE
            WHEN cumulative_revenue_pct <= 80 THEN 'A'
            WHEN cumulative_revenue_pct <= 95 THEN 'B'
            ELSE 'C'
        END AS abc_segment
    FROM ranked_customers
)
SELECT
    abc_segment,
    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_customer
FROM abc_customers
GROUP BY abc_segment
ORDER BY
    CASE abc_segment
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
    END;


-- ============================================================
-- ANALYSIS 12
-- Average Orders per Customer
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
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
        *,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100
        AS cumulative_revenue_pct
    FROM customer_metrics
),
abc_customers AS (
    SELECT
        *,
        CASE
            WHEN cumulative_revenue_pct <= 80 THEN 'A'
            WHEN cumulative_revenue_pct <= 95 THEN 'B'
            ELSE 'C'
        END AS abc_segment
    FROM ranked_customers
)
SELECT
    abc_segment,
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer
FROM abc_customers
GROUP BY abc_segment
ORDER BY
    CASE abc_segment
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
    END;


-- ============================================================
-- ANALYSIS 13
-- Average Units per Customer
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity) AS total_units,
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
        *,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100
        AS cumulative_revenue_pct
    FROM customer_metrics
),
abc_customers AS (
    SELECT
        *,
        CASE
            WHEN cumulative_revenue_pct <= 80 THEN 'A'
            WHEN cumulative_revenue_pct <= 95 THEN 'B'
            ELSE 'C'
        END AS abc_segment
    FROM ranked_customers
)
SELECT
    abc_segment,
    ROUND(AVG(total_units), 2) AS avg_units_per_customer
FROM abc_customers
GROUP BY abc_segment
ORDER BY
    CASE abc_segment
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
    END;


-- ============================================================
-- ANALYSIS 14
-- Revenue per Order by ABC Segment
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
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
        *,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100
        AS cumulative_revenue_pct
    FROM customer_metrics
),
abc_customers AS (
    SELECT
        *,
        CASE
            WHEN cumulative_revenue_pct <= 80 THEN 'A'
            WHEN cumulative_revenue_pct <= 95 THEN 'B'
            ELSE 'C'
        END AS abc_segment
    FROM ranked_customers
)
SELECT
    abc_segment,
    ROUND(
        SUM(total_revenue) /
        NULLIF(SUM(total_orders), 0),
        2
    ) AS revenue_per_order
FROM abc_customers
GROUP BY abc_segment
ORDER BY
    CASE abc_segment
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
    END;


-- ============================================================
-- ANALYSIS 15
-- Revenue per Unit by ABC Segment
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity) AS total_units,
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
        *,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100
        AS cumulative_revenue_pct
    FROM customer_metrics
),
abc_customers AS (
    SELECT
        *,
        CASE
            WHEN cumulative_revenue_pct <= 80 THEN 'A'
            WHEN cumulative_revenue_pct <= 95 THEN 'B'
            ELSE 'C'
        END AS abc_segment
    FROM ranked_customers
)
SELECT
    abc_segment,
    ROUND(
        SUM(total_revenue) /
        NULLIF(SUM(total_units), 0),
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
-- ANALYSIS 16
-- Complete ABC Segment Performance Comparison
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
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
        *,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100
        AS cumulative_revenue_pct
    FROM customer_metrics
),
abc_customers AS (
    SELECT
        *,
        CASE
            WHEN cumulative_revenue_pct <= 80 THEN 'A'
            WHEN cumulative_revenue_pct <= 95 THEN 'B'
            ELSE 'C'
        END AS abc_segment
    FROM ranked_customers
)
SELECT
    abc_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(
        SUM(total_revenue) /
        NULLIF(SUM(SUM(total_revenue)) OVER (), 0) * 100,
        2
    ) AS revenue_contribution_pct,
    SUM(total_orders) AS total_orders,
    SUM(total_units) AS total_units,
    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_customer,
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer,
    ROUND(AVG(total_units), 2) AS avg_units_per_customer,
    ROUND(
        SUM(total_revenue) /
        NULLIF(SUM(total_orders), 0),
        2
    ) AS revenue_per_order,
    ROUND(
        SUM(total_revenue) /
        NULLIF(SUM(total_units), 0),
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
-- ANALYSIS 17
-- Highest Revenue Segment
-- ============================================================

WITH customer_metrics AS (
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
        *,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100
        AS cumulative_revenue_pct
    FROM customer_metrics
),
abc_customers AS (
    SELECT
        *,
        CASE
            WHEN cumulative_revenue_pct <= 80 THEN 'A'
            WHEN cumulative_revenue_pct <= 95 THEN 'B'
            ELSE 'C'
        END AS abc_segment
    FROM ranked_customers
),
segment_revenue AS (
    SELECT
        abc_segment,
        SUM(total_revenue) AS segment_revenue
    FROM abc_customers
    GROUP BY abc_segment
)
SELECT
    abc_segment,
    ROUND(segment_revenue, 2) AS segment_revenue
FROM segment_revenue
ORDER BY segment_revenue DESC
LIMIT 1;


-- ============================================================
-- ANALYSIS 18
-- Final ABC Segment Business Priority Summary
-- ============================================================

WITH customer_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units,
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
        *,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100
        AS cumulative_revenue_pct
    FROM customer_metrics
),
abc_customers AS (
    SELECT
        *,
        CASE
            WHEN cumulative_revenue_pct <= 80 THEN 'A'
            WHEN cumulative_revenue_pct <= 95 THEN 'B'
            ELSE 'C'
        END AS abc_segment
    FROM ranked_customers
),
segment_summary AS (
    SELECT
        abc_segment,
        COUNT(*) AS customer_count,
        SUM(total_revenue) AS total_revenue,
        SUM(total_orders) AS total_orders,
        SUM(total_units) AS total_units,
        AVG(total_revenue) AS avg_revenue_per_customer
    FROM abc_customers
    GROUP BY abc_segment
)
SELECT
    abc_segment,
    customer_count,
    ROUND(total_revenue, 2) AS total_revenue,
    total_orders,
    total_units,
    ROUND(avg_revenue_per_customer, 2) AS avg_revenue_per_customer,
    CASE
        WHEN abc_segment = 'A'
            THEN 'Highest Priority - Protect and Retain'
        WHEN abc_segment = 'B'
            THEN 'Medium Priority - Develop and Grow'
        WHEN abc_segment = 'C'
            THEN 'Lower Priority - Monitor and Develop'
    END AS business_priority
FROM segment_summary
ORDER BY
    CASE abc_segment
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
    END;