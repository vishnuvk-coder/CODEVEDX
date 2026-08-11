USE sales_analysis_db;

-- ==========================================
-- DAY 11: SQL INDEXES & QUERY PERFORMANCE
-- ==========================================

-- 1. View existing indexes on Customers
SHOW INDEX FROM Customers;

-- 2. Create an index on customer city
CREATE INDEX idx_customer_city
ON Customers(city);

-- 3. Create an index on customer email
CREATE INDEX idx_customer_email
ON Customers(email);

-- 4. Create an index on order date
CREATE INDEX idx_order_date
ON Orders(order_date);

-- 5. Create an index on order status
CREATE INDEX idx_order_status
ON Orders(order_status);

-- 6. Create an index on product category
CREATE INDEX idx_product_category
ON Products(category);

-- 7. Verify indexes
SHOW INDEX FROM Customers;
SHOW INDEX FROM Orders;
SHOW INDEX FROM Products;

-- 8. Test a query using an indexed column
EXPLAIN
SELECT *
FROM Customers
WHERE city = 'Badlapur';

-- 9. Test order search
EXPLAIN
SELECT *
FROM Orders
WHERE order_status = 'Completed';

-- 10. Test product category search
EXPLAIN
SELECT *
FROM Products
WHERE category = 'Electronics';