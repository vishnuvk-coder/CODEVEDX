USE sales_analysis_db;

-- ============================================================
-- DAY 29
-- CUSTOMER PURCHASE FREQUENCY & ORDER VALUE ANALYSIS
-- ============================================================

-- ============================================================
-- 1. CUSTOMER ORDER FREQUENCY
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
-- 2. CUSTOMER AVERAGE ORDER VALUE
-- ============================================================

WITH order_values AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.order_id,
        o.customer_id
)

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(ov.order_id) AS total_orders,
    ROUND(AVG(ov.order_value), 2) AS average_order_value
FROM customers c
JOIN order_values ov
    ON c.customer_id = ov.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY average_order_value DESC;


-- ============================================================
-- 3. CUSTOMER TOTAL SPENDING
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        SUM(oi.quantity * p.price),
        2
    ) AS total_spending
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
ORDER BY total_spending DESC;


-- ============================================================
-- 4. CUSTOMER PURCHASE FREQUENCY CATEGORY
-- ============================================================

WITH customer_orders AS (
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
)

SELECT
    customer_id,
    customer_name,
    total_orders,

    CASE
        WHEN total_orders >= 10 THEN 'Very Frequent'
        WHEN total_orders >= 5 THEN 'Frequent'
        WHEN total_orders >= 2 THEN 'Repeat'
        ELSE 'One-Time'
    END AS purchase_frequency_category

FROM customer_orders
ORDER BY total_orders DESC;


-- ============================================================
-- 5. ORDER VALUE ANALYSIS
-- ============================================================

WITH order_values AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.order_id,
        o.customer_id
)

SELECT
    order_id,
    customer_id,
    ROUND(order_value, 2) AS order_value,

    CASE
        WHEN order_value >= 10000 THEN 'High Value Order'
        WHEN order_value >= 5000 THEN 'Medium Value Order'
        ELSE 'Low Value Order'
    END AS order_value_category

FROM order_values
ORDER BY order_value DESC;


-- ============================================================
-- 6. TOP CUSTOMERS BY ORDER FREQUENCY
-- ============================================================

WITH customer_orders AS (
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
)

SELECT
    customer_id,
    customer_name,
    total_orders,

    RANK() OVER (
        ORDER BY total_orders DESC
    ) AS frequency_rank

FROM customer_orders
ORDER BY frequency_rank;


-- ============================================================
-- 7. CUSTOMER ORDER FREQUENCY PERCENTAGE
-- ============================================================

WITH customer_orders AS (
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
)

SELECT
    customer_id,
    customer_name,
    total_orders,

    ROUND(
        total_orders /
        SUM(total_orders) OVER () * 100,
        2
    ) AS order_frequency_contribution_percent

FROM customer_orders
ORDER BY total_orders DESC;


-- ============================================================
-- 8. PURCHASE FREQUENCY SEGMENT SUMMARY
-- ============================================================

WITH customer_orders AS (
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
),

segmented_customers AS (
    SELECT
        customer_id,
        customer_name,
        total_orders,

        CASE
            WHEN total_orders >= 10 THEN 'Very Frequent'
            WHEN total_orders >= 5 THEN 'Frequent'
            WHEN total_orders >= 2 THEN 'Repeat'
            ELSE 'One-Time'
        END AS purchase_frequency_category

    FROM customer_orders
)

SELECT
    purchase_frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_orders), 2) AS average_orders
FROM segmented_customers
GROUP BY purchase_frequency_category
ORDER BY average_orders DESC;


-- ============================================================
-- 9. HIGH-FREQUENCY HIGH-VALUE CUSTOMERS
-- ============================================================

WITH customer_analysis AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(
            SUM(oi.quantity * p.price),
            2
        ) AS total_revenue
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
    total_orders,
    total_revenue,

    CASE
        WHEN total_orders >= 5
             AND total_revenue >= 10000
        THEN 'High Frequency - High Value'

        WHEN total_orders >= 5
        THEN 'High Frequency - Lower Value'

        WHEN total_revenue >= 10000
        THEN 'Low Frequency - High Value'

        ELSE 'Standard Customer'
    END AS customer_profile

FROM customer_analysis
ORDER BY total_revenue DESC;


-- ============================================================
-- 10. CUSTOMER PURCHASE BEHAVIOR REPORT
-- ============================================================

WITH order_values AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.order_id,
        o.customer_id
),

customer_analysis AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(ov.order_id) AS total_orders,
        SUM(ov.order_value) AS total_revenue,
        AVG(ov.order_value) AS average_order_value
    FROM customers c
    JOIN order_values ov
        ON c.customer_id = ov.customer_id
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,
    total_orders,

    ROUND(total_revenue, 2) AS total_revenue,

    ROUND(average_order_value, 2) AS average_order_value,

    RANK() OVER (
        ORDER BY total_orders DESC
    ) AS purchase_frequency_rank,

    CASE
        WHEN total_orders >= 10
             AND total_revenue >= 10000
        THEN 'VIP Customer'

        WHEN total_orders >= 5
             OR total_revenue >= 10000
        THEN 'High Value Customer'

        WHEN total_orders >= 2
        THEN 'Repeat Customer'

        ELSE 'One-Time Customer'
    END AS customer_segment

FROM customer_analysis
ORDER BY total_revenue DESC;