USE sales_analysis_db;

-- =========================================
-- DAY 9: STORED PROCEDURES
-- =========================================


-- 1. Get All Customers
-- Returns all customer records

DROP PROCEDURE IF EXISTS Get_All_Customers;

DELIMITER $$

CREATE PROCEDURE Get_All_Customers()
BEGIN
    SELECT
        customer_id,
        customer_name,
        gender,
        age,
        city,
        state,
        email,
        phone
    FROM Customers;
END $$

DELIMITER ;


-- Test Procedure 1
CALL Get_All_Customers();


-- =========================================


-- 2. Get Customer Orders
-- Returns orders for a specific customer

DROP PROCEDURE IF EXISTS Get_Customer_Orders;

DELIMITER $$

CREATE PROCEDURE Get_Customer_Orders(IN p_customer_id INT)
BEGIN
    SELECT
        c.customer_name,
        o.order_id,
        o.order_date,
        o.total_amount,
        o.order_status
    FROM Customers c
    JOIN Orders o
        ON c.customer_id = o.customer_id
    WHERE c.customer_id = p_customer_id;
END $$

DELIMITER ;


-- Test Procedure 2
CALL Get_Customer_Orders(1);


-- =========================================


-- 3. Get Orders By Status
-- Returns orders based on order status

DROP PROCEDURE IF EXISTS Get_Orders_By_Status;

DELIMITER $$

CREATE PROCEDURE Get_Orders_By_Status(IN p_status VARCHAR(20))
BEGIN
    SELECT
        order_id,
        customer_id,
        order_date,
        total_amount,
        order_status
    FROM Orders
    WHERE order_status = p_status;
END $$

DELIMITER ;


-- Test Procedure 3
CALL Get_Orders_By_Status('Completed');


-- =========================================


-- 4. Get Products By Category
-- Returns products belonging to a category

DROP PROCEDURE IF EXISTS Get_Products_By_Category;

DELIMITER $$

CREATE PROCEDURE Get_Products_By_Category(IN p_category VARCHAR(50))
BEGIN
    SELECT
        product_id,
        product_name,
        category,
        price,
        cost_price
    FROM Products
    WHERE category = p_category;
END $$

DELIMITER ;


-- Test Procedure 4
CALL Get_Products_By_Category('Electronics');


-- =========================================


-- 5. Customer Sales Summary
-- Returns total orders, sales and average order value

DROP PROCEDURE IF EXISTS Get_Customer_Sales_Summary;

DELIMITER $$

CREATE PROCEDURE Get_Customer_Sales_Summary(IN p_customer_id INT)
BEGIN
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(o.order_id) AS total_orders,
        COALESCE(SUM(o.total_amount), 0) AS total_sales,
        COALESCE(AVG(o.total_amount), 0) AS average_order_value
    FROM Customers c
    LEFT JOIN Orders o
        ON c.customer_id = o.customer_id
    WHERE c.customer_id = p_customer_id
    GROUP BY
        c.customer_id,
        c.customer_name;
END $$

DELIMITER ;


-- Test Procedure 5
CALL Get_Customer_Sales_Summary(1);


-- =========================================
-- VIEW ALL STORED PROCEDURES
-- =========================================

SHOW PROCEDURE STATUS
WHERE Db = 'sales_analysis_db';