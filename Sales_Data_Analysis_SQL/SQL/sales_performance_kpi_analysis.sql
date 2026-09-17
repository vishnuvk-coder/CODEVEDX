USE sales_analysis_db;


-- ============================================================
-- DAY 47
-- SALES PERFORMANCE KPI ANALYSIS
-- ============================================================


-- ============================================================
-- QUERY 01: TOTAL ORDERS
-- ============================================================

SELECT
    COUNT(*) AS total_orders
FROM orders;


-- ============================================================
-- QUERY 02: TOTAL CUSTOMERS
-- ============================================================

SELECT
    COUNT(*) AS total_customers
FROM customers;


-- ============================================================
-- QUERY 03: TOTAL PRODUCTS
-- ============================================================

SELECT
    COUNT(*) AS total_products
FROM products;


-- ============================================================
-- QUERY 04: TOTAL REVENUE
-- ============================================================

SELECT
    ROUND(SUM(oi.quantity * p.price), 2) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id;


-- ============================================================
-- QUERY 05: TOTAL UNITS SOLD
-- ============================================================

SELECT
    SUM(quantity) AS total_units_sold
FROM order_items;


-- ============================================================
-- QUERY 06: AVERAGE ORDER VALUE
-- ============================================================

SELECT
    ROUND(AVG(order_revenue), 2) AS average_order_value
FROM
(
    SELECT
        o.order_id,
        SUM(oi.quantity * p.price) AS order_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.order_id
) AS order_sales;


-- ============================================================
-- QUERY 07: AVERAGE UNITS PER ORDER
-- ============================================================

SELECT
    ROUND(AVG(order_units), 2) AS average_units_per_order
FROM
(
    SELECT
        order_id,
        SUM(quantity) AS order_units
    FROM order_items
    GROUP BY order_id
) AS order_quantity;


-- ============================================================
-- QUERY 08: REVENUE PER CUSTOMER
-- ============================================================

SELECT
    ROUND(
        SUM(oi.quantity * p.price) / COUNT(DISTINCT o.customer_id),
        2
    ) AS revenue_per_customer
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id;


-- ============================================================
-- QUERY 09: ORDERS PER CUSTOMER
-- ============================================================

SELECT
    ROUND(
        COUNT(DISTINCT o.order_id) /
        COUNT(DISTINCT o.customer_id),
        2
    ) AS orders_per_customer
FROM orders o;


-- ============================================================
-- QUERY 10: MONTHLY SALES PERFORMANCE
-- ============================================================

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS total_units_sold,
    ROUND(SUM(oi.quantity * p.price), 2) AS total_revenue,
    ROUND(
        SUM(oi.quantity * p.price) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;


-- ============================================================
-- QUERY 11: CUSTOMER REVENUE CONTRIBUTION
-- ============================================================

SELECT
    o.customer_id,
    ROUND(SUM(oi.quantity * p.price), 2) AS customer_revenue,
    ROUND(
        SUM(oi.quantity * p.price) /
        (
            SELECT SUM(oi2.quantity * p2.price)
            FROM order_items oi2
            JOIN products p2
                ON oi2.product_id = p2.product_id
        ) * 100,
        2
    ) AS revenue_contribution_percentage
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY customer_revenue DESC;


-- ============================================================
-- QUERY 12: PRODUCT REVENUE CONTRIBUTION
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.quantity * p.price), 2) AS product_revenue,
    ROUND(
        SUM(oi.quantity * p.price) /
        (
            SELECT SUM(oi2.quantity * p2.price)
            FROM order_items oi2
            JOIN products p2
                ON oi2.product_id = p2.product_id
        ) * 100,
        2
    ) AS revenue_contribution_percentage
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY product_revenue DESC;


-- ============================================================
-- FINAL KPI SUMMARY
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM orders) AS total_orders,

    (SELECT COUNT(*) FROM customers) AS total_customers,

    (SELECT COUNT(*) FROM products) AS total_products,

    (
        SELECT ROUND(SUM(oi.quantity * p.price), 2)
        FROM order_items oi
        JOIN products p
            ON oi.product_id = p.product_id
    ) AS total_revenue,

    (
        SELECT SUM(quantity)
        FROM order_items
    ) AS total_units_sold,

    (
        SELECT ROUND(AVG(order_revenue), 2)
        FROM
        (
            SELECT
                o.order_id,
                SUM(oi.quantity * p.price) AS order_revenue
            FROM orders o
            JOIN order_items oi
                ON o.order_id = oi.order_id
            JOIN products p
                ON oi.product_id = p.product_id
            GROUP BY o.order_id
        ) AS order_summary
    ) AS average_order_value;