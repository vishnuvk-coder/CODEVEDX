USE sales_analysis_db;

-- ============================================================
-- DAY 45
-- CUSTOMER PAYMENT RISK & PENDING PAYMENT ANALYSIS
-- ============================================================


-- ============================================================
-- QUERY 01: Identify All Payment Statuses
-- ============================================================

SELECT
    payment_status,
    COUNT(*) AS total_payment_records,
    COUNT(DISTINCT order_id) AS total_orders
FROM payments
GROUP BY payment_status
ORDER BY total_payment_records DESC;


-- ============================================================
-- QUERY 02: Payment Status Distribution
-- ============================================================

SELECT
    payment_status,
    COUNT(*) AS payment_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM payments),
        2
    ) AS payment_percentage
FROM payments
GROUP BY payment_status
ORDER BY payment_count DESC;


-- ============================================================
-- QUERY 03: Payment Method Distribution
-- ============================================================

SELECT
    payment_method,
    COUNT(*) AS total_payment_records,
    COUNT(DISTINCT order_id) AS total_orders
FROM payments
GROUP BY payment_method
ORDER BY total_payment_records DESC;


-- ============================================================
-- QUERY 04: Payment Status by Payment Method
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
-- QUERY 05: Monthly Payment Activity
-- ============================================================

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    COUNT(*) AS total_payment_records,
    COUNT(DISTINCT order_id) AS total_orders
FROM payments
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY payment_month;


-- ============================================================
-- QUERY 06: Monthly Payment Status Analysis
-- ============================================================

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    payment_status,
    COUNT(*) AS total_payment_records
FROM payments
GROUP BY
    DATE_FORMAT(payment_date, '%Y-%m'),
    payment_status
ORDER BY
    payment_month,
    total_payment_records DESC;


-- ============================================================
-- QUERY 07: Monthly Payment Method Analysis
-- ============================================================

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    payment_method,
    COUNT(*) AS total_payment_records
FROM payments
GROUP BY
    DATE_FORMAT(payment_date, '%Y-%m'),
    payment_method
ORDER BY
    payment_month,
    total_payment_records DESC;


-- ============================================================
-- QUERY 08: Pending Payment Analysis
-- ============================================================

SELECT
    p.payment_id,
    p.order_id,
    p.payment_date,
    p.payment_method,
    p.payment_status
FROM payments AS p
WHERE LOWER(p.payment_status) = 'pending'
ORDER BY p.payment_date DESC;


-- ============================================================
-- QUERY 09: Failed Payment Analysis
-- ============================================================

SELECT
    p.payment_id,
    p.order_id,
    p.payment_date,
    p.payment_method,
    p.payment_status
FROM payments AS p
WHERE LOWER(p.payment_status) = 'failed'
ORDER BY p.payment_date DESC;


-- ============================================================
-- QUERY 10: Orders with Multiple Payment Records
-- ============================================================

SELECT
    order_id,
    COUNT(*) AS payment_record_count,
    MIN(payment_date) AS first_payment_date,
    MAX(payment_date) AS last_payment_date
FROM payments
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY payment_record_count DESC;


-- ============================================================
-- QUERY 11: Customer-Level Payment Risk Analysis
-- ============================================================

SELECT
    o.customer_id,
    COUNT(p.payment_id) AS total_payment_records,
    COUNT(DISTINCT p.order_id) AS total_orders,
    COUNT(
        CASE
            WHEN LOWER(p.payment_status) = 'pending'
            THEN 1
        END
    ) AS pending_payment_count,
    COUNT(
        CASE
            WHEN LOWER(p.payment_status) = 'failed'
            THEN 1
        END
    ) AS failed_payment_count,
    MIN(p.payment_date) AS first_payment_date,
    MAX(p.payment_date) AS last_payment_date
FROM payments AS p
INNER JOIN orders AS o
    ON p.order_id = o.order_id
GROUP BY o.customer_id
ORDER BY
    pending_payment_count DESC,
    failed_payment_count DESC;


-- ============================================================
-- QUERY 12: Final Customer Payment Risk Classification
-- ============================================================

WITH customer_payment_summary AS
(
    SELECT
        o.customer_id,
        COUNT(p.payment_id) AS total_payment_records,
        COUNT(DISTINCT p.order_id) AS total_orders,
        COUNT(
            CASE
                WHEN LOWER(p.payment_status) = 'pending'
                THEN 1
            END
        ) AS pending_payment_count,
        COUNT(
            CASE
                WHEN LOWER(p.payment_status) = 'failed'
                THEN 1
            END
        ) AS failed_payment_count,
        MIN(p.payment_date) AS first_payment_date,
        MAX(p.payment_date) AS last_payment_date
    FROM payments AS p
    INNER JOIN orders AS o
        ON p.order_id = o.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    total_payment_records,
    total_orders,
    pending_payment_count,
    failed_payment_count,
    first_payment_date,
    last_payment_date,
    CASE
        WHEN failed_payment_count > 0
             AND pending_payment_count > 0
            THEN 'High Payment Risk'

        WHEN failed_payment_count > 0
            THEN 'Failed Payment Risk'

        WHEN pending_payment_count > 0
            THEN 'Pending Payment Risk'

        WHEN total_payment_records >= 10
            THEN 'High Payment Activity'

        WHEN total_payment_records BETWEEN 5 AND 9
            THEN 'Regular Payment Activity'

        ELSE 'Low Payment Activity'
    END AS payment_risk_category
FROM customer_payment_summary
ORDER BY
    CASE
        WHEN failed_payment_count > 0
             AND pending_payment_count > 0
            THEN 1

        WHEN failed_payment_count > 0
            THEN 2

        WHEN pending_payment_count > 0
            THEN 3

        ELSE 4
    END,
    total_payment_records DESC;