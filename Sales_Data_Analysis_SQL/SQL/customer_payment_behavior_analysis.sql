USE sales_analysis_db;

-- =========================================================
-- DAY 44: CUSTOMER PAYMENT BEHAVIOR ANALYSIS
-- =========================================================


-- =========================================================
-- QUERY 1: Total Payments per Customer
-- =========================================================

SELECT
    o.customer_id,
    COUNT(p.payment_id) AS total_payments
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
GROUP BY o.customer_id
ORDER BY total_payments DESC;


-- =========================================================
-- QUERY 2: Payment Methods Used by Each Customer
-- =========================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT p.payment_method) AS total_payment_methods,
    GROUP_CONCAT(DISTINCT p.payment_method
                 ORDER BY p.payment_method
                 SEPARATOR ', ') AS payment_methods_used
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
GROUP BY o.customer_id
ORDER BY total_payment_methods DESC;


-- =========================================================
-- QUERY 3: Customer Payment Status Distribution
-- =========================================================

SELECT
    o.customer_id,
    p.payment_status,
    COUNT(*) AS payment_count
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
GROUP BY
    o.customer_id,
    p.payment_status
ORDER BY
    o.customer_id,
    payment_count DESC;


-- =========================================================
-- QUERY 4: Customers Using Multiple Payment Methods
-- =========================================================

SELECT
    o.customer_id,
    COUNT(DISTINCT p.payment_method) AS payment_method_count
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
GROUP BY o.customer_id
HAVING COUNT(DISTINCT p.payment_method) > 1
ORDER BY payment_method_count DESC;


-- =========================================================
-- QUERY 5: Customers with Pending Payments
-- =========================================================

SELECT
    o.customer_id,
    COUNT(*) AS pending_payment_count
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
WHERE LOWER(p.payment_status) = 'pending'
GROUP BY o.customer_id
ORDER BY pending_payment_count DESC;


-- =========================================================
-- QUERY 6: Customers with Failed Payments
-- =========================================================

SELECT
    o.customer_id,
    COUNT(*) AS failed_payment_count
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
WHERE LOWER(p.payment_status) IN ('failed', 'failure')
GROUP BY o.customer_id
ORDER BY failed_payment_count DESC;


-- =========================================================
-- QUERY 7: Customer Payment Activity by Month
-- =========================================================

SELECT
    DATE_FORMAT(p.payment_date, '%Y-%m') AS payment_month,
    o.customer_id,
    COUNT(p.payment_id) AS total_payments
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
GROUP BY
    payment_month,
    o.customer_id
ORDER BY
    payment_month,
    total_payments DESC;


-- =========================================================
-- QUERY 8: Most Frequently Used Payment Method by Customer
-- =========================================================

WITH customer_payment_methods AS (
    SELECT
        o.customer_id,
        p.payment_method,
        COUNT(*) AS method_usage_count
    FROM payments p
    JOIN orders o
        ON p.order_id = o.order_id
    GROUP BY
        o.customer_id,
        p.payment_method
),

ranked_payment_methods AS (
    SELECT
        customer_id,
        payment_method,
        method_usage_count,
        RANK() OVER (
            PARTITION BY customer_id
            ORDER BY method_usage_count DESC
        ) AS method_rank
    FROM customer_payment_methods
)

SELECT
    customer_id,
    payment_method,
    method_usage_count
FROM ranked_payment_methods
WHERE method_rank = 1
ORDER BY customer_id;


-- =========================================================
-- QUERY 9: Customers with the Highest Number of Payments
-- =========================================================

WITH customer_payment_summary AS (
    SELECT
        o.customer_id,
        COUNT(p.payment_id) AS total_payments
    FROM payments p
    JOIN orders o
        ON p.order_id = o.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    total_payments,
    RANK() OVER (
        ORDER BY total_payments DESC
    ) AS customer_payment_rank
FROM customer_payment_summary
ORDER BY customer_payment_rank;


-- =========================================================
-- QUERY 10: Customer Payment Behavior Classification
-- =========================================================

WITH customer_payment_summary AS (
    SELECT
        o.customer_id,
        COUNT(p.payment_id) AS total_payments,
        COUNT(DISTINCT p.payment_method) AS payment_method_count,
        COUNT(DISTINCT p.payment_status) AS payment_status_count
    FROM payments p
    JOIN orders o
        ON p.order_id = o.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    total_payments,
    payment_method_count,
    payment_status_count,
    CASE
        WHEN total_payments = 1
            THEN 'Single Payment Customer'
        WHEN total_payments BETWEEN 2 AND 4
            THEN 'Occasional Payment Customer'
        WHEN total_payments BETWEEN 5 AND 9
            THEN 'Regular Payment Customer'
        ELSE 'High Activity Payment Customer'
    END AS payment_behavior_category
FROM customer_payment_summary
ORDER BY total_payments DESC;


-- =========================================================
-- QUERY 11: Customer Payment Activity Ranking
-- =========================================================

WITH customer_payment_activity AS (
    SELECT
        o.customer_id,
        COUNT(p.payment_id) AS total_payments,
        COUNT(DISTINCT p.payment_method) AS payment_method_count
    FROM payments p
    JOIN orders o
        ON p.order_id = o.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    total_payments,
    payment_method_count,
    DENSE_RANK() OVER (
        ORDER BY total_payments DESC
    ) AS activity_rank
FROM customer_payment_activity
ORDER BY activity_rank, customer_id;


-- =========================================================
-- QUERY 12: Final Customer Payment Behavior Summary
-- =========================================================

WITH customer_payment_summary AS (
    SELECT
        o.customer_id,
        COUNT(p.payment_id) AS total_payments,
        COUNT(DISTINCT p.payment_method) AS payment_method_count,
        COUNT(DISTINCT p.payment_status) AS payment_status_count,
        MIN(p.payment_date) AS first_payment_date,
        MAX(p.payment_date) AS last_payment_date,
        SUM(
            CASE
                WHEN LOWER(p.payment_status) = 'pending'
                THEN 1
                ELSE 0
            END
        ) AS pending_payment_count,
        SUM(
            CASE
                WHEN LOWER(p.payment_status) IN ('failed', 'failure')
                THEN 1
                ELSE 0
            END
        ) AS failed_payment_count
    FROM payments p
    JOIN orders o
        ON p.order_id = o.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    total_payments,
    payment_method_count,
    payment_status_count,
    first_payment_date,
    last_payment_date,
    pending_payment_count,
    failed_payment_count,
    CASE
        WHEN pending_payment_count > 0
             AND failed_payment_count > 0
            THEN 'Payment Issues Detected'
        WHEN pending_payment_count > 0
            THEN 'Pending Payment Customer'
        WHEN failed_payment_count > 0
            THEN 'Failed Payment Customer'
        WHEN total_payments >= 5
            THEN 'High Payment Activity Customer'
        ELSE 'Normal Payment Behavior'
    END AS final_payment_behavior
FROM customer_payment_summary
ORDER BY total_payments DESC;