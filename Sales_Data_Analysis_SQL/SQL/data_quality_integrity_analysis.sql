USE sales_analysis_db;

-- =========================================================
-- DAY 46: DATA QUALITY & INTEGRITY ANALYSIS
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
-- 2. CHECK NULL VALUES IN CUSTOMERS
-- =========================================================

SELECT
    COUNT(*) AS total_customers,
    SUM(customer_id IS NULL) AS null_customer_ids
FROM customers;

-- =========================================================
-- 3. CHECK DUPLICATE CUSTOMER RECORDS
-- =========================================================

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- =========================================================
-- 4. CHECK DUPLICATE PRODUCT RECORDS
-- =========================================================

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- =========================================================
-- 5. CHECK DUPLICATE ORDER RECORDS
-- =========================================================

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- =========================================================
-- 6. CHECK DUPLICATE PAYMENT RECORDS
-- =========================================================

SELECT
    payment_id,
    COUNT(*) AS duplicate_count
FROM payments
GROUP BY payment_id
HAVING COUNT(*) > 1;


-- =========================================================
-- 7. FIND ORDERS WITHOUT MATCHING CUSTOMERS
-- =========================================================

SELECT
    o.order_id,
    o.customer_id,
    o.order_date
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- =========================================================
-- 8. FIND ORDER ITEMS WITHOUT MATCHING ORDERS
-- =========================================================

SELECT
    oi.order_id,
    oi.product_id,
    oi.quantity
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- =========================================================
-- 9. FIND ORDER ITEMS WITHOUT MATCHING PRODUCTS
-- =========================================================

SELECT
    oi.order_id,
    oi.product_id,
    oi.quantity
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- =========================================================
-- 10. FIND PAYMENTS WITHOUT MATCHING ORDERS
-- =========================================================

SELECT
    p.payment_id,
    p.order_id,
    p.payment_date,
    p.payment_method,
    p.payment_status
FROM payments p
LEFT JOIN orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;


-- =========================================================
-- 11. FIND INVALID ORDER QUANTITIES
-- =========================================================

SELECT
    order_id,
    product_id,
    quantity
FROM order_items
WHERE quantity IS NULL
   OR quantity <= 0;


-- =========================================================
-- 12. FIND INVALID PRODUCT PRICES
-- =========================================================

SELECT
    product_id,
    product_name,
    price
FROM products
WHERE price IS NULL
   OR price <= 0;


-- =========================================================
-- 13. FIND ORDERS WITHOUT ORDER ITEMS
-- =========================================================

SELECT
    o.order_id,
    o.customer_id,
    o.order_date
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;


-- =========================================================
-- 14. FIND PRODUCTS THAT HAVE NEVER BEEN ORDERED
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    p.price
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;


-- =========================================================
-- 15. CHECK ORDER ITEM COUNTS
-- =========================================================

SELECT
    o.order_id,
    COUNT(oi.product_id) AS total_order_items
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY total_order_items DESC;


-- =========================================================
-- 16. CHECK PAYMENT RECORD COUNTS PER ORDER
-- =========================================================

SELECT
    o.order_id,
    COUNT(p.payment_id) AS payment_record_count
FROM orders o
LEFT JOIN payments p
    ON o.order_id = p.order_id
GROUP BY o.order_id
ORDER BY payment_record_count DESC;


-- =========================================================
-- 17. FIND ORDERS WITH MULTIPLE PAYMENT RECORDS
-- =========================================================

SELECT
    order_id,
    COUNT(payment_id) AS payment_record_count
FROM payments
GROUP BY order_id
HAVING COUNT(payment_id) > 1
ORDER BY payment_record_count DESC;


-- =========================================================
-- 18. CHECK MISSING ORDER DATES
-- =========================================================

SELECT
    COUNT(*) AS orders_with_missing_dates
FROM orders
WHERE order_date IS NULL;


-- =========================================================
-- 19. CHECK MISSING PAYMENT DATES
-- =========================================================

SELECT
    COUNT(*) AS payments_with_missing_dates
FROM payments
WHERE payment_date IS NULL;


-- =========================================================
-- 20. FINAL DATABASE QUALITY SUMMARY
-- =========================================================

SELECT
    'Customers' AS table_name,
    COUNT(*) AS total_records
FROM customers

UNION ALL

SELECT
    'Products' AS table_name,
    COUNT(*) AS total_records
FROM products

UNION ALL

SELECT
    'Orders' AS table_name,
    COUNT(*) AS total_records
FROM orders

UNION ALL

SELECT
    'Order Items' AS table_name,
    COUNT(*) AS total_records
FROM order_items

UNION ALL

SELECT
    'Payments' AS table_name,
    COUNT(*) AS total_records
FROM payments;


-- =========================================================
-- 21. FINAL DATA QUALITY ISSUE SUMMARY
-- =========================================================

SELECT
    'Orders without customers' AS issue_type,
    COUNT(*) AS issue_count
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT
    'Order items without orders' AS issue_type,
    COUNT(*) AS issue_count
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT
    'Order items without products' AS issue_type,
    COUNT(*) AS issue_count
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL

UNION ALL

SELECT
    'Payments without orders' AS issue_type,
    COUNT(*) AS issue_count
FROM payments p
LEFT JOIN orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT
    'Invalid quantities' AS issue_type,
    COUNT(*) AS issue_count
FROM order_items
WHERE quantity IS NULL
   OR quantity <= 0

UNION ALL

SELECT
    'Invalid product prices' AS issue_type,
    COUNT(*) AS issue_count
FROM products
WHERE price IS NULL
   OR price <= 0

UNION ALL

SELECT
    'Orders without order items' AS issue_type,
    COUNT(*) AS issue_count
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;