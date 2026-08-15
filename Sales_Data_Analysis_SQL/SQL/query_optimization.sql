USE sales_analysis_db;

-- ============================================
-- DAY 15: SQL QUERY OPTIMIZATION
-- ============================================

-- 1. Check query execution plan
EXPLAIN
SELECT order_id, customer_id, order_date
FROM orders
WHERE customer_id = 5;

-- 2. Check available indexes
SHOW INDEX FROM orders;

-- 3. Create index for customer filtering
CREATE INDEX idx_orders_customer_id
ON orders(customer_id);

-- 4. Check execution plan after indexing
EXPLAIN
SELECT order_id, customer_id, order_date
FROM orders
WHERE customer_id = 5;

-- 5. Optimized sales analysis
EXPLAIN
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name;