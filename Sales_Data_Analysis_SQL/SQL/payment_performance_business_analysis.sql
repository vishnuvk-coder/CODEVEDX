USE sales_analysis_db;

-- ============================================================
-- DAY 65
-- Payment Performance & Business Analysis
-- ============================================================


-- ============================================================
-- Analysis 1: Payment Status Distribution
-- ============================================================

SELECT
    payment_status,
    COUNT(*) AS payment_count
FROM payments
GROUP BY payment_status
ORDER BY payment_count DESC;


-- ============================================================
-- Analysis 2: Payment Method Distribution
-- ============================================================

SELECT
    payment_method,
    COUNT(*) AS payment_count
FROM payments
GROUP BY payment_method
ORDER BY payment_count DESC;


-- ============================================================
-- Analysis 3: Total Payment Transactions
-- ============================================================

SELECT
    COUNT(*) AS total_payment_transactions
FROM payments;


-- ============================================================
-- Analysis 4: Unique Orders with Payments
-- ============================================================

SELECT
    COUNT(DISTINCT order_id) AS unique_orders_with_payments
FROM payments;


-- ============================================================
-- Analysis 5: Payment Transactions by Method
-- ============================================================

SELECT
    payment_method,
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT order_id) AS unique_orders
FROM payments
GROUP BY payment_method
ORDER BY total_transactions DESC;


-- ============================================================
-- Analysis 6: Orders by Payment Status
-- ============================================================

SELECT
    payment_status,
    COUNT(DISTINCT order_id) AS unique_orders
FROM payments
GROUP BY payment_status
ORDER BY unique_orders DESC;


-- ============================================================
-- Analysis 7: Payment Status Percentage
-- ============================================================

SELECT
    payment_status,
    COUNT(*) AS payment_count,
    ROUND(
        COUNT(*) /
        NULLIF(SUM(COUNT(*)) OVER (), 0) * 100,
        2
    ) AS payment_percentage
FROM payments
GROUP BY payment_status
ORDER BY payment_count DESC;


-- ============================================================
-- Analysis 8: Payment Method Percentage
-- ============================================================

SELECT
    payment_method,
    COUNT(*) AS payment_count,
    ROUND(
        COUNT(*) /
        NULLIF(SUM(COUNT(*)) OVER (), 0) * 100,
        2
    ) AS payment_percentage
FROM payments
GROUP BY payment_method
ORDER BY payment_count DESC;


-- ============================================================
-- Analysis 9: Payment Activity by Date
-- ============================================================

SELECT
    payment_date,
    COUNT(*) AS payment_transactions,
    COUNT(DISTINCT order_id) AS unique_orders
FROM payments
GROUP BY payment_date
ORDER BY payment_date;


-- ============================================================
-- Analysis 10: Payment Activity by Month
-- ============================================================

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    COUNT(*) AS payment_transactions,
    COUNT(DISTINCT order_id) AS unique_orders
FROM payments
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY payment_month;


-- ============================================================
-- Analysis 11: Successful Payment Orders
-- ============================================================

SELECT
    COUNT(DISTINCT order_id) AS successful_payment_orders
FROM payments
WHERE LOWER(payment_status) IN ('paid', 'completed', 'success', 'successful');


-- ============================================================
-- Analysis 12: Unsuccessful Payment Orders
-- ============================================================

SELECT
    COUNT(DISTINCT order_id) AS unsuccessful_payment_orders
FROM payments
WHERE LOWER(payment_status) IN
      ('failed', 'failure', 'pending', 'cancelled', 'canceled');


-- ============================================================
-- Analysis 13: Payment Status × Payment Method
-- ============================================================

SELECT
    payment_status,
    payment_method,
    COUNT(*) AS payment_count,
    COUNT(DISTINCT order_id) AS unique_orders
FROM payments
GROUP BY
    payment_status,
    payment_method
ORDER BY
    payment_status,
    payment_count DESC;


-- ============================================================
-- Analysis 14: Payment Business Risk Analysis
-- ============================================================

SELECT
    payment_status,
    COUNT(*) AS payment_transactions,
    COUNT(DISTINCT order_id) AS affected_orders,
    CASE
        WHEN LOWER(payment_status) IN
             ('paid', 'completed', 'success', 'successful')
            THEN 'Low Risk - Successful Payment'

        WHEN LOWER(payment_status) IN
             ('pending')
            THEN 'Medium Risk - Payment Pending'

        WHEN LOWER(payment_status) IN
             ('failed', 'failure', 'cancelled', 'canceled')
            THEN 'High Risk - Payment Failure'

        ELSE 'Review Required'
    END AS business_risk
FROM payments
GROUP BY payment_status
ORDER BY affected_orders DESC;


-- ============================================================
-- Analysis 15: Final Payment Performance Summary
-- ============================================================

SELECT
    COUNT(*) AS total_payment_transactions,
    COUNT(DISTINCT order_id) AS unique_orders_with_payments,
    COUNT(DISTINCT payment_method) AS payment_methods_used,
    COUNT(DISTINCT payment_status) AS payment_status_types
FROM payments;


-- ============================================================
-- END OF DAY 65
-- ============================================================