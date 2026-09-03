USE sales_analysis_db;


-- =========================================
-- DAY 8: SQL VIEWS
-- =========================================


-- 1. Customer Order View
-- Shows customer information with their orders

CREATE OR REPLACE VIEW Customer_Order_View AS
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    c.state,
    o.order_id,
    o.order_date,
    o.total_amount,
    o.order_status
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id;


-- Check Customer Order View
SELECT * FROM Customer_Order_View;


-- =========================================


-- 2. Product Sales View
-- Shows products, quantity sold and revenue

CREATE OR REPLACE VIEW Product_Sales_View AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM Products p
JOIN Order_Items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category;


-- Check Product Sales View
SELECT * FROM Product_Sales_View;


-- =========================================


-- 3. Payment Details View
-- Shows order and payment information

CREATE OR REPLACE VIEW Payment_Details_View AS
SELECT
    o.order_id,
    c.customer_name,
    o.order_date,
    o.total_amount,
    p.payment_date,
    p.payment_method,
    p.payment_status
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
JOIN Payments p
    ON o.order_id = p.order_id;


-- Check Payment Details View
SELECT * FROM Payment_Details_View;


-- =========================================


-- 4. Completed Orders View
-- Shows only completed orders

CREATE OR REPLACE VIEW Completed_Orders_View AS
SELECT
    o.order_id,
    c.customer_name,
    o.order_date,
    o.total_amount,
    o.order_status
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'Completed';


-- Check Completed Orders View
SELECT * FROM Completed_Orders_View;


-- =========================================


-- 5. Customer Sales Summary View
-- Shows total orders and sales for each customer

CREATE OR REPLACE VIEW Customer_Sales_Summary_View AS
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_sales,
    AVG(o.total_amount) AS average_order_value
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name;


-- Check Customer Sales Summary
SELECT * FROM Customer_Sales_Summary_View;


-- =========================================
-- View List
-- =========================================

SHOW FULL TABLES
WHERE Table_type = 'VIEW';