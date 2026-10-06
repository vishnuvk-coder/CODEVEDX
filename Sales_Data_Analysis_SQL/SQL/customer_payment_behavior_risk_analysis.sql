USE sales_analysis_db;

-- ============================================================
-- DAY 66
-- Customer Payment Behavior & Risk Analysis
-- ============================================================


-- ============================================================
-- STEP 0: VERIFY PAYMENT STATUSES AND METHODS
-- ============================================================

SELECT DISTINCT payment_status
FROM payments
ORDER BY payment_status;

SELECT DISTINCT payment_method
FROM payments
ORDER BY payment_method;


-- ============================================================
-- ANALYSIS 1: Customer Payment Transaction Count
-- ============================================================

SELECT
    o.customer_id,
    COUNT(*) AS payment_transactions
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY o.customer_id
ORDER BY payment_transactions DESC;


-- ============================================================
-- ANALYSIS 2: Customers with Successful Payments
-- ============================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT p.order_id) AS successful_payment_orders
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
WHERE LOWER(p.payment_status) IN
      ('paid', 'completed', 'success', 'successful')
GROUP BY o.customer_id
ORDER BY successful_payment_orders DESC;


-- ============================================================
-- ANALYSIS 3: Customers with Failed Payments
-- ============================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT p.order_id) AS failed_payment_orders
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
WHERE LOWER(p.payment_status) IN
      ('failed', 'failure')
GROUP BY o.customer_id
ORDER BY failed_payment_orders DESC;


-- ============================================================
-- ANALYSIS 4: Customers with Pending Payments
-- ============================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT p.order_id) AS pending_payment_orders
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
WHERE LOWER(p.payment_status) = 'pending'
GROUP BY o.customer_id
ORDER BY pending_payment_orders DESC;


-- ============================================================
-- ANALYSIS 5: Customer Payment Success Rate
-- ============================================================

SELECT
    o.customer_id,

    COUNT(*) AS total_payment_transactions,

    SUM(
        CASE
            WHEN LOWER(p.payment_status) IN
                 ('paid', 'completed', 'success', 'successful')
            THEN 1
            ELSE 0
        END
    ) AS successful_transactions,

    ROUND(
        SUM(
            CASE
                WHEN LOWER(p.payment_status) IN
                     ('paid', 'completed', 'success', 'successful')
                THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS payment_success_rate

FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY o.customer_id
ORDER BY payment_success_rate DESC;


-- ============================================================
-- ANALYSIS 6: Customer Payment Failure Rate
-- ============================================================

SELECT
    o.customer_id,

    COUNT(*) AS total_payment_transactions,

    SUM(
        CASE
            WHEN LOWER(p.payment_status) IN
                 ('failed', 'failure')
            THEN 1
            ELSE 0
        END
    ) AS failed_transactions,

    ROUND(
        SUM(
            CASE
                WHEN LOWER(p.payment_status) IN
                     ('failed', 'failure')
                THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS payment_failure_rate

FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY o.customer_id
ORDER BY payment_failure_rate DESC;


-- ============================================================
-- ANALYSIS 7: Payment Method Preference by Customer
-- ============================================================

SELECT
    o.customer_id,
    p.payment_method,
    COUNT(*) AS payment_transactions
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY
    o.customer_id,
    p.payment_method
ORDER BY
    o.customer_id,
    payment_transactions DESC;


-- ============================================================
-- ANALYSIS 8: Customers Using Multiple Payment Methods
-- ============================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT p.payment_method) AS payment_methods_used
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY o.customer_id
HAVING COUNT(DISTINCT p.payment_method) > 1
ORDER BY payment_methods_used DESC;


-- ============================================================
-- ANALYSIS 9: Customers with Repeated Payment Failures
-- ============================================================

SELECT
    o.customer_id,
    COUNT(*) AS failed_payment_transactions
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
WHERE LOWER(p.payment_status) IN
      ('failed', 'failure')
GROUP BY o.customer_id
HAVING COUNT(*) >= 2
ORDER BY failed_payment_transactions DESC;


-- ============================================================
-- ANALYSIS 10: Customers with Pending Payments
-- ============================================================

SELECT
    o.customer_id,
    COUNT(*) AS pending_payment_transactions
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
WHERE LOWER(p.payment_status) = 'pending'
GROUP BY o.customer_id
ORDER BY pending_payment_transactions DESC;


-- ============================================================
-- ANALYSIS 11: Customer Payment Risk Classification
-- ============================================================

WITH customer_payment_metrics AS
(
    SELECT
        o.customer_id,

        COUNT(*) AS total_transactions,

        SUM(
            CASE
                WHEN LOWER(p.payment_status) IN
                     ('paid', 'completed', 'success', 'successful')
                THEN 1
                ELSE 0
            END
        ) AS successful_transactions,

        SUM(
            CASE
                WHEN LOWER(p.payment_status) IN
                     ('failed', 'failure')
                THEN 1
                ELSE 0
            END
        ) AS failed_transactions,

        SUM(
            CASE
                WHEN LOWER(p.payment_status) = 'pending'
                THEN 1
                ELSE 0
            END
        ) AS pending_transactions

    FROM orders o
    JOIN payments p
        ON o.order_id = p.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    total_transactions,
    successful_transactions,
    failed_transactions,
    pending_transactions,

    ROUND(
        successful_transactions /
        NULLIF(total_transactions, 0) * 100,
        2
    ) AS success_rate,

    ROUND(
        failed_transactions /
        NULLIF(total_transactions, 0) * 100,
        2
    ) AS failure_rate,

    CASE
        WHEN failed_transactions >= 2
             OR failed_transactions / NULLIF(total_transactions, 0) >= 0.50
            THEN 'High Risk'

        WHEN pending_transactions >= 1
             OR failed_transactions >= 1
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS payment_risk

FROM customer_payment_metrics
ORDER BY
    CASE
        WHEN failed_transactions >= 2
             OR failed_transactions / NULLIF(total_transactions, 0) >= 0.50
            THEN 1
        WHEN pending_transactions >= 1
             OR failed_transactions >= 1
            THEN 2
        ELSE 3
    END,
    failure_rate DESC;


-- ============================================================
-- ANALYSIS 12: High-Risk Customer Identification
-- ============================================================

WITH customer_payment_metrics AS
(
    SELECT
        o.customer_id,

        COUNT(*) AS total_transactions,

        SUM(
            CASE
                WHEN LOWER(p.payment_status) IN
                     ('failed', 'failure')
                THEN 1
                ELSE 0
            END
        ) AS failed_transactions

    FROM orders o
    JOIN payments p
        ON o.order_id = p.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    total_transactions,
    failed_transactions,

    ROUND(
        failed_transactions /
        NULLIF(total_transactions, 0) * 100,
        2
    ) AS failure_rate

FROM customer_payment_metrics

WHERE failed_transactions >= 2
   OR failed_transactions / NULLIF(total_transactions, 0) >= 0.50

ORDER BY failure_rate DESC;


-- ============================================================
-- ANALYSIS 13: Customer Payment Status Distribution
-- ============================================================

SELECT
    o.customer_id,
    p.payment_status,
    COUNT(*) AS payment_transactions
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY
    o.customer_id,
    p.payment_status
ORDER BY
    o.customer_id,
    payment_transactions DESC;


-- ============================================================
-- ANALYSIS 14: Customer Payment Method and Status Analysis
-- ============================================================

SELECT
    o.customer_id,
    p.payment_method,
    p.payment_status,
    COUNT(*) AS payment_transactions
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY
    o.customer_id,
    p.payment_method,
    p.payment_status
ORDER BY
    o.customer_id,
    payment_transactions DESC;


-- ============================================================
-- ANALYSIS 15: Customer Payment Behavior Summary
-- ============================================================

WITH customer_payment_summary AS
(
    SELECT
        o.customer_id,

        COUNT(*) AS total_payment_transactions,

        COUNT(DISTINCT p.order_id) AS unique_orders_with_payments,

        COUNT(DISTINCT p.payment_method) AS payment_methods_used,

        SUM(
            CASE
                WHEN LOWER(p.payment_status) IN
                     ('paid', 'completed', 'success', 'successful')
                THEN 1
                ELSE 0
            END
        ) AS successful_transactions,

        SUM(
            CASE
                WHEN LOWER(p.payment_status) IN
                     ('failed', 'failure')
                THEN 1
                ELSE 0
            END
        ) AS failed_transactions,

        SUM(
            CASE
                WHEN LOWER(p.payment_status) = 'pending'
                THEN 1
                ELSE 0
            END
        ) AS pending_transactions

    FROM orders o
    JOIN payments p
        ON o.order_id = p.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    total_payment_transactions,
    unique_orders_with_payments,
    payment_methods_used,
    successful_transactions,
    failed_transactions,
    pending_transactions,

    ROUND(
        successful_transactions /
        NULLIF(total_payment_transactions, 0) * 100,
        2
    ) AS success_rate,

    ROUND(
        failed_transactions /
        NULLIF(total_payment_transactions, 0) * 100,
        2
    ) AS failure_rate,

    CASE
        WHEN failed_transactions >= 2
             OR failed_transactions /
                NULLIF(total_payment_transactions, 0) >= 0.50
            THEN 'High Risk'

        WHEN pending_transactions >= 1
             OR failed_transactions >= 1
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS payment_risk

FROM customer_payment_summary
ORDER BY
    failure_rate DESC,
    total_payment_transactions DESC;