
-- ============================================================
-- DAY 76: CUSTOMER SPENDING SEGMENTATION ANALYSIS
-- Database: sales_analysis_db
-- Purpose: Analyze customer spending and spending segments
-- ============================================================

USE sales_analysis_db;

-- ------------------------------------------------------------
-- ANALYSIS 1: CUSTOMER SPENDING SUMMARY
-- ------------------------------------------------------------

WITH order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity) AS total_quantity,
        SUM(oi.quantity * p.price) AS order_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.order_id, o.customer_id
)
SELECT
    c.customer_id,
    COUNT(ot.order_id) AS total_orders,
    COALESCE(SUM(ot.total_quantity), 0) AS total_quantity_purchased,
    ROUND(COALESCE(SUM(ot.order_revenue), 0), 2)
        AS total_spending,
    ROUND(COALESCE(AVG(ot.order_revenue), 0), 2)
        AS average_order_value
FROM customers c
LEFT JOIN order_totals ot
    ON c.customer_id = ot.customer_id
GROUP BY c.customer_id
ORDER BY total_spending DESC;


-- ------------------------------------------------------------
-- ANALYSIS 2: CUSTOMER SPENDING SEGMENTATION
-- NTILE(3) divides purchasing customers into three groups
-- based on their total spending.
-- ------------------------------------------------------------

WITH order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * p.price) AS order_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.order_id, o.customer_id
),
customer_summary AS (
    SELECT
        c.customer_id,
        COUNT(ot.order_id) AS total_orders,
        ROUND(COALESCE(SUM(ot.order_revenue), 0), 2)
            AS total_spending
    FROM customers c
    LEFT JOIN order_totals ot
        ON c.customer_id = ot.customer_id
    GROUP BY c.customer_id
),
ranked_customers AS (
    SELECT
        customer_id,
        NTILE(3) OVER (
            ORDER BY total_spending, customer_id
        ) AS spending_bucket
    FROM customer_summary
    WHERE total_orders > 0
)
SELECT
    cs.customer_id,
    cs.total_orders,
    cs.total_spending,
    CASE
        WHEN cs.total_orders = 0 THEN 'Never Purchased'
        WHEN rc.spending_bucket = 1 THEN 'Low Spending'
        WHEN rc.spending_bucket = 2 THEN 'Medium Spending'
        WHEN rc.spending_bucket = 3 THEN 'High Spending'
    END AS spending_segment
FROM customer_summary cs
LEFT JOIN ranked_customers rc
    ON cs.customer_id = rc.customer_id
ORDER BY cs.total_spending DESC;


-- ------------------------------------------------------------
-- ANALYSIS 3: SPENDING SEGMENT PERFORMANCE
-- ------------------------------------------------------------

WITH order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * p.price) AS order_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.order_id, o.customer_id
),
customer_summary AS (
    SELECT
        c.customer_id,
        COUNT(ot.order_id) AS total_orders,
        ROUND(COALESCE(SUM(ot.order_revenue), 0), 2)
            AS total_spending,
        ROUND(COALESCE(AVG(ot.order_revenue), 0), 2)
            AS average_order_value
    FROM customers c
    LEFT JOIN order_totals ot
        ON c.customer_id = ot.customer_id
    GROUP BY c.customer_id
),
ranked_customers AS (
    SELECT
        customer_id,
        NTILE(3) OVER (
            ORDER BY total_spending, customer_id
        ) AS spending_bucket
    FROM customer_summary
    WHERE total_orders > 0
),
customer_segments AS (
    SELECT
        cs.*,
        CASE
            WHEN cs.total_orders = 0 THEN 'Never Purchased'
            WHEN rc.spending_bucket = 1 THEN 'Low Spending'
            WHEN rc.spending_bucket = 2 THEN 'Medium Spending'
            WHEN rc.spending_bucket = 3 THEN 'High Spending'
        END AS spending_segment
    FROM customer_summary cs
    LEFT JOIN ranked_customers rc
        ON cs.customer_id = rc.customer_id
)
SELECT
    spending_segment,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_spending), 2) AS segment_revenue,
    ROUND(AVG(total_spending), 2) AS average_customer_spending,
    ROUND(AVG(average_order_value), 2) AS average_order_value
FROM customer_segments
GROUP BY spending_segment
ORDER BY segment_revenue DESC;


-- ------------------------------------------------------------
-- ANALYSIS 4: TOP 10 CUSTOMERS BY TOTAL SPENDING
-- ------------------------------------------------------------

WITH order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * p.price) AS order_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.order_id, o.customer_id
)
SELECT
    c.customer_id,
    COUNT(ot.order_id) AS total_orders,
    ROUND(COALESCE(SUM(ot.order_revenue), 0), 2)
        AS total_spending
FROM customers c
LEFT JOIN order_totals ot
    ON c.customer_id = ot.customer_id
GROUP BY c.customer_id
HAVING total_orders > 0
ORDER BY total_spending DESC
LIMIT 10;


-- ------------------------------------------------------------
-- ANALYSIS 5: HIGH-SPENDING CUSTOMER DETAILS
-- ------------------------------------------------------------

WITH order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * p.price) AS order_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.order_id, o.customer_id
),
customer_summary AS (
    SELECT
        c.customer_id,
        COUNT(ot.order_id) AS total_orders,
        ROUND(COALESCE(SUM(ot.order_revenue), 0), 2)
            AS total_spending
    FROM customers c
    LEFT JOIN order_totals ot
        ON c.customer_id = ot.customer_id
    GROUP BY c.customer_id
),
ranked_customers AS (
    SELECT
        customer_id,
        NTILE(3) OVER (
            ORDER BY total_spending, customer_id
        ) AS spending_bucket
    FROM customer_summary
    WHERE total_orders > 0
)
SELECT
    cs.customer_id,
    cs.total_orders,
    cs.total_spending,
    'High Spending' AS spending_segment
FROM customer_summary cs
JOIN ranked_customers rc
    ON cs.customer_id = rc.customer_id
WHERE rc.spending_bucket = 3
ORDER BY cs.total_spending DESC;


-- ============================================================
-- END OF DAY 76 ANALYSIS
-- ============================================================
