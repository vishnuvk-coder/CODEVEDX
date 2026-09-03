USE sales_analysis_db;

-- =====================================================
-- DAY 10: SQL TRIGGERS
-- =====================================================

-- =====================================================
-- 1. CREATE ORDER AUDIT TABLE
-- =====================================================

CREATE TABLE IF NOT EXISTS Order_Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    action_type VARCHAR(20),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255)
);

-- Check audit table
DESCRIBE Order_Audit;


-- =====================================================
-- 2. AFTER INSERT TRIGGER
-- =====================================================

DROP TRIGGER IF EXISTS after_order_insert;

DELIMITER //

CREATE TRIGGER after_order_insert
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO Order_Audit
    (order_id, action_type, description)
    VALUES
    (
        NEW.order_id,
        'INSERT',
        CONCAT('New order created for Customer ID: ', NEW.customer_id)
    );
END //

DELIMITER ;


-- =====================================================
-- 3. TEST INSERT TRIGGER
-- =====================================================

INSERT INTO Orders
(customer_id, order_date, total_amount, order_status)
VALUES
(1, '2026-08-10', 2500, 'Completed');

SELECT * FROM Order_Audit;


-- =====================================================
-- 4. AFTER UPDATE TRIGGER
-- =====================================================

DROP TRIGGER IF EXISTS after_order_update;

DELIMITER //

CREATE TRIGGER after_order_update
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO Order_Audit
    (order_id, action_type, description)
    VALUES
    (
        NEW.order_id,
        'UPDATE',
        CONCAT(
            'Order status changed from ',
            OLD.order_status,
            ' to ',
            NEW.order_status
        )
    );
END //

DELIMITER ;


-- =====================================================
-- 5. TEST UPDATE TRIGGER
-- =====================================================

UPDATE Orders
SET order_status = 'Pending'
WHERE order_id = 6;

SELECT * FROM Order_Audit;


-- =====================================================
-- 6. AFTER DELETE TRIGGER
-- =====================================================

DROP TRIGGER IF EXISTS after_order_delete;

DELIMITER //

CREATE TRIGGER after_order_delete
AFTER DELETE ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO Order_Audit
    (order_id, action_type, description)
    VALUES
    (
        OLD.order_id,
        'DELETE',
        CONCAT(
            'Order deleted. Customer ID: ',
            OLD.customer_id
        )
    );
END //

DELIMITER ;


-- =====================================================
-- 7. TEST DELETE TRIGGER
-- =====================================================

DELETE FROM Orders
WHERE order_id = 6;

SELECT * FROM Order_Audit;


-- =====================================================
-- 8. VIEW ALL TRIGGERS
-- =====================================================

SHOW TRIGGERS;