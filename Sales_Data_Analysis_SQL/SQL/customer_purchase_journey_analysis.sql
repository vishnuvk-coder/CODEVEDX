USE sales_analysis_db;

-- ============================================================
-- DAY 35
-- CUSTOMER PURCHASE JOURNEY & BASKET ANALYSIS
-- ============================================================

-- ============================================================
-- QUERY 1
-- CUSTOMER PURCHASE JOURNEY
-- First and Last Purchase Date
-- ============================================================

SELECT
    o.customer_id,
    MIN(o.order_date) AS first_purchase_date,
    MAX(o.order_date) AS last_purchase_date,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
GROUP BY o.customer_id
ORDER BY total_orders DESC;


-- ============================================================
-- QUERY 2
-- FIRST PURCHASE DATE OF EACH CUSTOMER
-- ============================================================

SELECT
    customer_id,
    MIN(order_date) AS first_purchase_date
FROM orders
GROUP BY customer_id
ORDER BY first_purchase_date;


-- ============================================================
-- QUERY 3
-- LAST PURCHASE DATE OF EACH CUSTOMER
-- ============================================================

SELECT
    customer_id,
    MAX(order_date) AS last_purchase_date
FROM orders
GROUP BY customer_id
ORDER BY last_purchase_date DESC;


-- ============================================================
-- QUERY 4
-- TOTAL ORDERS PER CUSTOMER
-- ============================================================

SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;


-- ============================================================
-- QUERY 5
-- AVERAGE DAYS BETWEEN PURCHASES
-- ============================================================

WITH customer_orders AS
(
    SELECT
        customer_id,
        order_date,
        LAG(order_date) OVER
        (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_purchase_date
    FROM orders
),
purchase_gaps AS
(
    SELECT
        customer_id,
        DATEDIFF(order_date, previous_purchase_date) AS days_between_purchases
    FROM customer_orders
    WHERE previous_purchase_date IS NOT NULL
)
SELECT
    customer_id,
    ROUND(AVG(days_between_purchases), 2)
        AS average_days_between_purchases
FROM purchase_gaps
GROUP BY customer_id
ORDER BY average_days_between_purchases;


-- ============================================================
-- QUERY 6
-- PURCHASE FREQUENCY CLASSIFICATION
-- ============================================================

WITH customer_frequency AS
(
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_orders,
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        WHEN total_orders BETWEEN 2 AND 3 THEN 'Occasional Customer'
        WHEN total_orders BETWEEN 4 AND 6 THEN 'Regular Customer'
        ELSE 'Frequent Customer'
    END AS purchase_frequency_segment
FROM customer_frequency
ORDER BY total_orders DESC;



-- ============================================================
-- QUERY 7
-- AVERAGE ORDER VALUE BY CUSTOMER
-- ============================================================

WITH order_values AS
(
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
    ROUND(AVG(order_value), 2) AS average_order_value
FROM order_values
GROUP BY customer_id
ORDER BY average_order_value DESC;


-- ============================================================
-- QUERY 8
-- CUSTOMER BASKET SIZE
-- ============================================================

WITH order_baskets AS
(
    SELECT
        o.customer_id,
        o.order_id,
        SUM(oi.quantity) AS basket_quantity
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
    ROUND(AVG(basket_quantity), 2) AS average_basket_size,
    SUM(basket_quantity) AS total_items_purchased
FROM order_baskets
GROUP BY customer_id
ORDER BY average_basket_size DESC;


-- ============================================================
-- QUERY 9
-- AVERAGE PRODUCTS PER ORDER
-- ============================================================

WITH order_products AS
(
    SELECT
        o.customer_id,
        o.order_id,
        COUNT(DISTINCT oi.product_id) AS products_in_order
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
    ROUND(AVG(products_in_order), 2)
        AS average_products_per_order
FROM order_products
GROUP BY customer_id
ORDER BY average_products_per_order DESC;


-- ============================================================
-- QUERY 10
-- REPEAT PURCHASE ANALYSIS
-- ============================================================

WITH customer_orders AS
(
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM customer_orders
GROUP BY
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END
ORDER BY customer_count DESC;


-- ============================================================
-- QUERY 11
-- CUSTOMER PURCHASE BEHAVIOR CLASSIFICATION
-- ============================================================

WITH customer_metrics AS
(
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        MIN(order_date) AS first_purchase_date,
        MAX(order_date) AS last_purchase_date
    FROM orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_orders,
    first_purchase_date,
    last_purchase_date,
    DATEDIFF(
        last_purchase_date,
        first_purchase_date
    ) AS customer_lifetime_days,
    CASE
        WHEN total_orders = 1
            THEN 'One-Time'
        WHEN total_orders BETWEEN 2 AND 3
            THEN 'Developing'
        WHEN total_orders BETWEEN 4 AND 6
            THEN 'Loyal'
        ELSE 'Highly Engaged'
    END AS customer_behavior_segment
FROM customer_metrics
ORDER BY total_orders DESC;


-- ============================================================
-- QUERY 12
-- CUSTOMER PURCHASE JOURNEY BUSINESS SUMMARY
-- ============================================================

WITH customer_metrics AS
(
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        MIN(order_date) AS first_purchase_date,
        MAX(order_date) AS last_purchase_date
    FROM orders
    GROUP BY customer_id
),
order_values AS
(
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
),
customer_value AS
(
    SELECT
        customer_id,
        ROUND(AVG(order_value), 2) AS average_order_value,
        ROUND(SUM(order_value), 2) AS total_customer_revenue
    FROM order_values
    GROUP BY customer_id
)
SELECT
    cm.customer_id,
    cm.total_orders,
    cm.first_purchase_date,
    cm.last_purchase_date,
    DATEDIFF(
        cm.last_purchase_date,
        cm.first_purchase_date
    ) AS customer_lifetime_days,
    cv.average_order_value,
    cv.total_customer_revenue,
    CASE
        WHEN cm.total_orders = 1
            THEN 'One-Time Customer'
        WHEN cm.total_orders BETWEEN 2 AND 3
            THEN 'Occasional Customer'
        WHEN cm.total_orders BETWEEN 4 AND 6
            THEN 'Regular Customer'
        ELSE 'Frequent Customer'
    END AS customer_segment
FROM customer_metrics cm
JOIN customer_value cv
    ON cm.customer_id = cv.customer_id
ORDER BY
    cv.total_customer_revenue DESC;