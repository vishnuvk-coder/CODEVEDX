USE sales_analysis_db;

-- ============================================================
-- DAY 43
-- PAYMENT STATUS & PAYMENT METHOD ANALYSIS
-- ============================================================


-- ============================================================
-- QUERY 01: Payment Method Distribution
-- ============================================================

SELECT
    payment_method,
    COUNT(*) AS total_payment_records
FROM payments
GROUP BY payment_method
ORDER BY total_payment_records DESC;


-- ============================================================
-- QUERY 02: Payment Status Distribution
-- ============================================================

SELECT
    payment_status,
    COUNT(*) AS total_payment_records
FROM payments
GROUP BY payment_status
ORDER BY total_payment_records DESC;


-- ============================================================
-- QUERY 03: Payment Method and Status Analysis
-- ============================================================

SELECT
    payment_method,
    payment_status,
    COUNT(*) AS total_payment_records
FROM payments
GROUP BY
    payment_method,
    payment_status
ORDER BY
    payment_method,
    total_payment_records DESC;


-- ============================================================
-- QUERY 04: Monthly Payment Transactions
-- ============================================================

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    COUNT(*) AS total_payment_records
FROM payments
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY payment_month;


-- ============================================================
-- QUERY 05: Yearly Payment Transactions
-- ============================================================

SELECT
    YEAR(payment_date) AS payment_year,
    COUNT(*) AS total_payment_records
FROM payments
GROUP BY YEAR(payment_date)
ORDER BY payment_year;


-- ============================================================
-- QUERY 06: Monthly Paid and Pending Payments
-- ============================================================

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    SUM(
        CASE
            WHEN payment_status = 'Paid' THEN 1
            ELSE 0
        END
    ) AS paid_payments,
    SUM(
        CASE
            WHEN payment_status = 'Pending' THEN 1
            ELSE 0
        END
    ) AS pending_payments
FROM payments
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY payment_month;


-- ============================================================
-- QUERY 07: Payment Status Percentage
-- ============================================================

SELECT
    payment_status,
    COUNT(*) AS total_payment_records,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM payments),
        2
    ) AS status_percentage
FROM payments
GROUP BY payment_status
ORDER BY status_percentage DESC;


-- ============================================================
-- QUERY 08: Pending Payment Orders
-- ============================================================

SELECT
    payment_id,
    order_id,
    payment_date,
    payment_method,
    payment_status
FROM payments
WHERE payment_status = 'Pending'
ORDER BY payment_date;


-- ============================================================
-- QUERY 09: Paid Payment Orders
-- ============================================================

SELECT
    payment_id,
    order_id,
    payment_date,
    payment_method,
    payment_status
FROM payments
WHERE payment_status = 'Paid'
ORDER BY payment_date DESC;


-- ============================================================
-- QUERY 10: Orders with Payment Details
-- ============================================================

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    p.payment_id,
    p.payment_date,
    p.payment_method,
    p.payment_status
FROM orders AS o
INNER JOIN payments AS p
    ON o.order_id = p.order_id
ORDER BY p.payment_date DESC;


-- ============================================================
-- QUERY 11: Customer Payment Status Analysis
-- ============================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(p.payment_id) AS total_payment_records,
    SUM(
        CASE
            WHEN p.payment_status = 'Paid' THEN 1
            ELSE 0
        END
    ) AS paid_payment_records,
    SUM(
        CASE
            WHEN p.payment_status = 'Pending' THEN 1
            ELSE 0
        END
    ) AS pending_payment_records
FROM orders AS o
INNER JOIN payments AS p
    ON o.order_id = p.order_id
GROUP BY o.customer_id
ORDER BY pending_payment_records DESC;


-- ============================================================
-- QUERY 12: Final Payment Analysis Summary
-- ============================================================

SELECT
    COUNT(*) AS total_payment_records,
    COUNT(DISTINCT order_id) AS total_orders_with_payments,
    COUNT(DISTINCT payment_method) AS payment_methods_used,
    COUNT(DISTINCT payment_status) AS payment_statuses_used,
    SUM(
        CASE
            WHEN payment_status = 'Paid' THEN 1
            ELSE 0
        END
    ) AS total_paid_records,
    SUM(
        CASE
            WHEN payment_status = 'Pending' THEN 1
            ELSE 0
        END
    ) AS total_pending_records,
    MIN(payment_date) AS first_payment_date,
    MAX(payment_date) AS latest_payment_date
FROM payments;