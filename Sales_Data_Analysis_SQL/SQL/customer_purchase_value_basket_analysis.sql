USE sales_analysis_db;

-- ============================================================
-- DAY 54
-- CUSTOMER PURCHASE VALUE & BASKET ANALYSIS
-- ============================================================


-- ============================================================
-- ANALYSIS 1
-- TOTAL ORDERS PER CUSTOMER
-- ============================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
GROUP BY o.customer_id
ORDER BY total_orders DESC;


-- ============================================================
-- ANALYSIS 2
-- TOTAL PRODUCTS / UNITS PURCHASED PER CUSTOMER
-- ============================================================

SELECT
    o.customer_id,
    SUM(oi.quantity) AS total_units_purchased
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_units_purchased DESC;


-- ============================================================
-- ANALYSIS 3
-- TOTAL REVENUE PER CUSTOMER
-- Revenue = quantity × product price
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
-- ANALYSIS 4
-- AVERAGE ORDER VALUE PER CUSTOMER
-- ============================================================

WITH customer_orders AS (
    SELECT
        o.customer_id,
        o.order_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.customer_id,
        o.order_id
)
SELECT
    customer_id,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(order_value), 2) AS total_revenue,
    ROUND(
        SUM(order_value) / NULLIF(COUNT(order_id), 0),
        2
    ) AS average_order_value
FROM customer_orders
GROUP BY customer_id
ORDER BY average_order_value DESC;


-- ============================================================
-- ANALYSIS 5
-- AVERAGE ITEMS PER ORDER
-- ============================================================

WITH order_quantities AS (
    SELECT
        o.customer_id,
        o.order_id,
        SUM(oi.quantity) AS items_in_order
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id,
        o.order_id
)
SELECT
    customer_id,
    COUNT(order_id) AS total_orders,
    SUM(items_in_order) AS total_units,
    ROUND(
        AVG(items_in_order),
        2
    ) AS average_items_per_order
FROM order_quantities
GROUP BY customer_id
ORDER BY average_items_per_order DESC;


-- ============================================================
-- ANALYSIS 6
-- MAXIMUM ORDER VALUE PER CUSTOMER
-- ============================================================

WITH order_values AS (
    SELECT
        o.customer_id,
        o.order_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.customer_id,
        o.order_id
)
SELECT
    customer_id,
    ROUND(MAX(order_value), 2) AS maximum_order_value
FROM order_values
GROUP BY customer_id
ORDER BY maximum_order_value DESC;


-- ============================================================
-- ANALYSIS 7
-- MINIMUM ORDER VALUE PER CUSTOMER
-- ============================================================

WITH order_values AS (
    SELECT
        o.customer_id,
        o.order_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.customer_id,
        o.order_id
)
SELECT
    customer_id,
    ROUND(MIN(order_value), 2) AS minimum_order_value
FROM order_values
GROUP BY customer_id
ORDER BY minimum_order_value DESC;


-- ============================================================
-- ANALYSIS 8
-- CUSTOMER BASKET SIZE CLASSIFICATION
-- ============================================================

WITH order_quantities AS (
    SELECT
        o.customer_id,
        o.order_id,
        SUM(oi.quantity) AS items_in_order
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id,
        o.order_id
),
customer_basket AS (
    SELECT
        customer_id,
        ROUND(AVG(items_in_order), 2) AS average_items_per_order
    FROM order_quantities
    GROUP BY customer_id
)
SELECT
    customer_id,
    average_items_per_order,
    CASE
        WHEN average_items_per_order < 2
            THEN 'Small Basket'
        WHEN average_items_per_order BETWEEN 2 AND 4
            THEN 'Medium Basket'
        WHEN average_items_per_order BETWEEN 5 AND 9
            THEN 'Large Basket'
        ELSE 'Very Large Basket'
    END AS basket_size_classification
FROM customer_basket
ORDER BY average_items_per_order DESC;


-- ============================================================
-- ANALYSIS 9
-- CUSTOMER SPENDING CLASSIFICATION
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
            THEN 'Low Spender'
        WHEN total_revenue BETWEEN 1000 AND 4999.99
            THEN 'Moderate Spender'
        WHEN total_revenue BETWEEN 5000 AND 9999.99
            THEN 'High Spender'
        ELSE 'Very High Spender'
    END AS spending_classification
FROM customer_revenue
ORDER BY total_revenue DESC;


-- ============================================================
-- ANALYSIS 10
-- CUSTOMER PURCHASE VALUE SCORE
--
-- Average Order Value Score:
-- 10000+       = 4
-- 5000-9999    = 3
-- 2500-4999    = 2
-- Below 2500   = 1
--
-- Average Items per Order Score:
-- 10+ = 4
-- 5-9 = 3
-- 2-4 = 2
-- <2  = 1
-- ============================================================

WITH order_metrics AS (
    SELECT
        o.customer_id,
        o.order_id,
        SUM(oi.quantity) AS items_in_order,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.customer_id,
        o.order_id
),
customer_metrics AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(items_in_order) AS total_units,
        SUM(order_value) AS total_revenue,
        AVG(items_in_order) AS average_items_per_order,
        AVG(order_value) AS average_order_value
    FROM order_metrics
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_orders,
    total_units,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(average_order_value, 2) AS average_order_value,
    ROUND(average_items_per_order, 2) AS average_items_per_order,

    CASE
        WHEN average_order_value >= 10000 THEN 4
        WHEN average_order_value >= 5000 THEN 3
        WHEN average_order_value >= 2500 THEN 2
        ELSE 1
    END AS aov_score,

    CASE
        WHEN average_items_per_order >= 10 THEN 4
        WHEN average_items_per_order >= 5 THEN 3
        WHEN average_items_per_order >= 2 THEN 2
        ELSE 1
    END AS basket_score,

    (
        CASE
            WHEN average_order_value >= 10000 THEN 4
            WHEN average_order_value >= 5000 THEN 3
            WHEN average_order_value >= 2500 THEN 2
            ELSE 1
        END
        +
        CASE
            WHEN average_items_per_order >= 10 THEN 4
            WHEN average_items_per_order >= 5 THEN 3
            WHEN average_items_per_order >= 2 THEN 2
            ELSE 1
        END
    ) AS purchase_value_score

FROM customer_metrics
ORDER BY purchase_value_score DESC;


-- ============================================================
-- ANALYSIS 11
-- CUSTOMER PURCHASE VALUE RANKING
-- ============================================================

WITH order_metrics AS (
    SELECT
        o.customer_id,
        o.order_id,
        SUM(oi.quantity) AS items_in_order,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.customer_id,
        o.order_id
),
customer_metrics AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(items_in_order) AS total_units,
        SUM(order_value) AS total_revenue,
        AVG(items_in_order) AS average_items_per_order,
        AVG(order_value) AS average_order_value
    FROM order_metrics
    GROUP BY customer_id
),
scored_customers AS (
    SELECT
        customer_id,
        total_orders,
        total_units,
        total_revenue,
        average_items_per_order,
        average_order_value,

        (
            CASE
                WHEN average_order_value >= 10000 THEN 4
                WHEN average_order_value >= 5000 THEN 3
                WHEN average_order_value >= 2500 THEN 2
                ELSE 1
            END
            +
            CASE
                WHEN average_items_per_order >= 10 THEN 4
                WHEN average_items_per_order >= 5 THEN 3
                WHEN average_items_per_order >= 2 THEN 2
                ELSE 1
            END
        ) AS purchase_value_score

    FROM customer_metrics
)
SELECT
    customer_id,
    total_orders,
    total_units,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(average_order_value, 2) AS average_order_value,
    ROUND(average_items_per_order, 2) AS average_items_per_order,
    purchase_value_score,

    RANK() OVER (
        ORDER BY purchase_value_score DESC
    ) AS purchase_value_rank

FROM scored_customers
ORDER BY purchase_value_rank;


-- ============================================================
-- ANALYSIS 12
-- FINAL CUSTOMER PURCHASE VALUE SUMMARY
-- ============================================================

WITH order_metrics AS (
    SELECT
        o.customer_id,
        o.order_id,
        SUM(oi.quantity) AS items_in_order,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.customer_id,
        o.order_id
),
customer_metrics AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(items_in_order) AS total_units,
        SUM(order_value) AS total_revenue,
        AVG(items_in_order) AS average_items_per_order,
        AVG(order_value) AS average_order_value,
        MAX(order_value) AS maximum_order_value,
        MIN(order_value) AS minimum_order_value
    FROM order_metrics
    GROUP BY customer_id
),
scored_customers AS (
    SELECT
        *,
        (
            CASE
                WHEN average_order_value >= 10000 THEN 4
                WHEN average_order_value >= 5000 THEN 3
                WHEN average_order_value >= 2500 THEN 2
                ELSE 1
            END
            +
            CASE
                WHEN average_items_per_order >= 10 THEN 4
                WHEN average_items_per_order >= 5 THEN 3
                WHEN average_items_per_order >= 2 THEN 2
                ELSE 1
            END
        ) AS purchase_value_score
    FROM customer_metrics
)
SELECT
    customer_id,
    total_orders,
    total_units,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(average_order_value, 2) AS average_order_value,
    ROUND(average_items_per_order, 2) AS average_items_per_order,
    ROUND(maximum_order_value, 2) AS maximum_order_value,
    ROUND(minimum_order_value, 2) AS minimum_order_value,

    CASE
        WHEN average_items_per_order < 2
            THEN 'Small Basket'
        WHEN average_items_per_order BETWEEN 2 AND 4
            THEN 'Medium Basket'
        WHEN average_items_per_order BETWEEN 5 AND 9
            THEN 'Large Basket'
        ELSE 'Very Large Basket'
    END AS basket_size_classification,

    CASE
        WHEN total_revenue < 1000
            THEN 'Low Spender'
        WHEN total_revenue < 5000
            THEN 'Moderate Spender'
        WHEN total_revenue < 10000
            THEN 'High Spender'
        ELSE 'Very High Spender'
    END AS spending_classification,

    purchase_value_score,

    RANK() OVER (
        ORDER BY purchase_value_score DESC
    ) AS purchase_value_rank

FROM scored_customers
ORDER BY purchase_value_rank, customer_id;