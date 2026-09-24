USE sales_analysis_db;

-- ============================================================
-- DAY 55: CUSTOMER PURCHASE VALUE SEGMENTATION ANALYSIS
-- ============================================================
-- Objective:
-- Analyze customers based on their purchase value, order
-- frequency, units purchased, average order value, and
-- contribution to total business revenue.
--
-- Revenue Formula:
-- order_items.quantity * products.price
--
-- Customer Value Segmentation:
-- ₹10,000+      -> High-Value Customer
-- ₹5,000–9,999  -> Medium-Value Customer
-- Below ₹5,000  -> Low-Value Customer
--
-- This is a rule-based SQL segmentation, NOT a machine
-- learning model.
-- ============================================================


-- ============================================================
-- ANALYSIS 1
-- TOTAL REVENUE PER CUSTOMER
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    ROUND(SUM(oi.quantity * p.price), 2) AS total_revenue
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
ORDER BY total_revenue DESC;


-- ============================================================
-- ANALYSIS 2
-- TOTAL ORDERS PER CUSTOMER
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_orders DESC;


-- ============================================================
-- ANALYSIS 3
-- AVERAGE ORDER VALUE PER CUSTOMER
-- ============================================================

WITH customer_orders AS
(
    SELECT
        c.customer_id,
        c.customer_name,
        o.order_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name,
        o.order_id
)

SELECT
    customer_id,
    customer_name,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(order_value), 2) AS average_order_value
FROM customer_orders
GROUP BY
    customer_id,
    customer_name
ORDER BY average_order_value DESC;


-- ============================================================
-- ANALYSIS 4
-- TOTAL UNITS PURCHASED PER CUSTOMER
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity) AS total_units_purchased
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_units_purchased DESC;


-- ============================================================
-- ANALYSIS 5
-- CUSTOMER PURCHASE FREQUENCY
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    CASE
        WHEN COUNT(DISTINCT o.order_id) >= 10
            THEN 'Very Frequent Customer'
        WHEN COUNT(DISTINCT o.order_id) >= 5
            THEN 'Frequent Customer'
        WHEN COUNT(DISTINCT o.order_id) >= 2
            THEN 'Occasional Customer'
        ELSE 'One-Time Customer'
    END AS purchase_frequency
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_orders DESC;


-- ============================================================
-- ANALYSIS 6
-- CUSTOMER REVENUE PERCENTAGE CONTRIBUTION
-- ============================================================

WITH customer_revenue AS
(
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
ORDER BY revenue_contribution_percentage DESC;


-- ============================================================
-- ANALYSIS 7
-- CUSTOMER REVENUE RANK
-- ============================================================

WITH customer_revenue AS
(
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
    ) AS customer_revenue_rank
FROM customer_revenue
ORDER BY customer_revenue_rank;


-- ============================================================
-- ANALYSIS 8
-- CUSTOMER VALUE CLASSIFICATION
-- ============================================================

WITH customer_revenue AS
(
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
    CASE
        WHEN total_revenue >= 10000
            THEN 'High-Value Customer'
        WHEN total_revenue >= 5000
            THEN 'Medium-Value Customer'
        ELSE 'Low-Value Customer'
    END AS customer_value_segment
FROM customer_revenue
ORDER BY total_revenue DESC;


-- ============================================================
-- ANALYSIS 9
-- HIGH-VALUE CUSTOMER IDENTIFICATION
-- ============================================================

WITH customer_revenue AS
(
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
    'High-Value Customer' AS customer_segment
FROM customer_revenue
WHERE total_revenue >= 10000
ORDER BY total_revenue DESC;


-- ============================================================
-- ANALYSIS 10
-- MEDIUM-VALUE CUSTOMER IDENTIFICATION
-- ============================================================

WITH customer_revenue AS
(
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
    'Medium-Value Customer' AS customer_segment
FROM customer_revenue
WHERE total_revenue >= 5000
  AND total_revenue < 10000
ORDER BY total_revenue DESC;


-- ============================================================
-- ANALYSIS 11
-- LOW-VALUE CUSTOMER IDENTIFICATION
-- ============================================================

WITH customer_revenue AS
(
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
    'Low-Value Customer' AS customer_segment
FROM customer_revenue
WHERE total_revenue < 5000
ORDER BY total_revenue DESC;


-- ============================================================
-- ANALYSIS 12
-- FINAL CUSTOMER VALUE SEGMENTATION SUMMARY
-- ============================================================

WITH customer_metrics AS
(
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_units_purchased,
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

customer_value AS
(
    SELECT
        customer_id,
        customer_name,
        total_orders,
        total_units_purchased,
        total_revenue,
        ROUND(
            total_revenue / NULLIF(total_orders, 0),
            2
        ) AS average_order_value,

        CASE
            WHEN total_revenue >= 10000
                THEN 'High-Value Customer'
            WHEN total_revenue >= 5000
                THEN 'Medium-Value Customer'
            ELSE 'Low-Value Customer'
        END AS customer_value_segment
    FROM customer_metrics
)

SELECT
    customer_id,
    customer_name,
    total_orders,
    total_units_purchased,
    ROUND(total_revenue, 2) AS total_revenue,
    average_order_value,
    customer_value_segment,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS customer_value_rank,

    ROUND(
        total_revenue /
        SUM(total_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_percentage

FROM customer_value
ORDER BY customer_value_rank;


-- ============================================================
-- END OF DAY 55
-- ============================================================