USE sales_analysis_db;

-- =========================================================
-- DAY 25: SALES & PROFITABILITY ANALYSIS
-- =========================================================

-- =========================================================
-- 1. CHECK TABLE STRUCTURES
-- =========================================================

DESCRIBE customers;
DESCRIBE products;
DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE payments;


-- =========================================================
-- 2. PRODUCT SALES PERFORMANCE
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * p.price) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_revenue DESC;


-- =========================================================
-- 3. PRODUCT-WISE QUANTITY SOLD
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_units_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_units_sold DESC;


-- =========================================================
-- 4. PRODUCT-WISE REVENUE
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY revenue DESC;


-- =========================================================
-- 5. AVERAGE PRODUCT PRICE
-- =========================================================

SELECT
    AVG(price) AS average_product_price
FROM products;


-- =========================================================
-- 6. HIGHEST-PRICED PRODUCTS
-- =========================================================

SELECT
    product_id,
    product_name,
    price
FROM products
ORDER BY price DESC
LIMIT 10;


-- =========================================================
-- 7. LOWEST-PRICED PRODUCTS
-- =========================================================

SELECT
    product_id,
    product_name,
    price
FROM products
ORDER BY price ASC
LIMIT 10;


-- =========================================================
-- 8. REVENUE BY ORDER
-- =========================================================

SELECT
    o.order_id,
    o.customer_id,
    SUM(oi.quantity * p.price) AS order_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    o.order_id,
    o.customer_id
ORDER BY order_revenue DESC;


-- =========================================================
-- 9. CUSTOMER REVENUE
-- =========================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    o.customer_id
ORDER BY total_revenue DESC;


-- =========================================================
-- 10. CUSTOMER AVERAGE ORDER VALUE
-- =========================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue,
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
GROUP BY
    o.customer_id
ORDER BY average_order_value DESC;


-- =========================================================
-- 11. OVERALL SALES KPIs
-- =========================================================

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * p.price) AS total_revenue,
    ROUND(
        SUM(oi.quantity * p.price) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id;


-- =========================================================
-- 12. TOP 5 PRODUCTS BY REVENUE
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY revenue DESC
LIMIT 5;


-- =========================================================
-- 13. TOP 5 PRODUCTS BY UNITS SOLD
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY units_sold DESC
LIMIT 5;


-- =========================================================
-- 14. REVENUE CONTRIBUTION BY PRODUCT
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS revenue,
    ROUND(
        SUM(oi.quantity * p.price) /
        (
            SELECT SUM(oi2.quantity * p2.price)
            FROM order_items oi2
            JOIN products p2
                ON oi2.product_id = p2.product_id
        ) * 100,
        2
    ) AS revenue_percentage
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY revenue_percentage DESC;


-- =========================================================
-- 15. PRODUCTS WITH REVENUE ABOVE AVERAGE
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
HAVING revenue >
(
    SELECT AVG(product_revenue)
    FROM
    (
        SELECT
            SUM(oi2.quantity * p2.price) AS product_revenue
        FROM products p2
        JOIN order_items oi2
            ON p2.product_id = oi2.product_id
        GROUP BY p2.product_id
    ) AS revenue_data
)
ORDER BY revenue DESC;


-- =========================================================
-- 16. MONTHLY SALES PERFORMANCE
-- =========================================================

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * p.price) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;


-- =========================================================
-- 17. DAILY SALES PERFORMANCE
-- =========================================================

SELECT
    DATE(o.order_date) AS sales_date,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    DATE(o.order_date)
ORDER BY sales_date;


-- =========================================================
-- 18. SALES RANKING BY PRODUCT
-- =========================================================

WITH product_sales AS
(
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity * p.price) AS revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name
)
SELECT
    product_id,
    product_name,
    revenue,
    RANK() OVER (
        ORDER BY revenue DESC
    ) AS revenue_rank
FROM product_sales
ORDER BY revenue_rank;


-- =========================================================
-- 19. PRODUCT PERFORMANCE CATEGORY
-- =========================================================

WITH product_sales AS
(
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.quantity * p.price) AS revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name
)
SELECT
    product_id,
    product_name,
    units_sold,
    revenue,
    CASE
        WHEN revenue >= 100000 THEN 'High Performer'
        WHEN revenue >= 50000 THEN 'Medium Performer'
        ELSE 'Low Performer'
    END AS performance_category
FROM product_sales
ORDER BY revenue DESC;


-- =========================================================
-- 20. BUSINESS SUMMARY
-- =========================================================

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * p.price) AS total_revenue,
    ROUND(
        SUM(oi.quantity * p.price) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id;