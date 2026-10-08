USE sales_analysis_db;

-- ============================================================
-- DAY 67
-- Customer Payment Method Performance Analysis
-- ============================================================


-- ============================================================
-- STEP 0: VERIFY PAYMENT STATUS AND PAYMENT METHODS
-- ============================================================

SELECT DISTINCT payment_status
FROM payments
ORDER BY payment_status;

SELECT DISTINCT payment_method
FROM payments
ORDER BY payment_method;


-- ============================================================
-- ANALYSIS 1: Payment Method Transaction Count
-- ============================================================

SELECT
    payment_method,
    COUNT(*) AS payment_transactions
FROM payments
GROUP BY payment_method
ORDER BY payment_transactions DESC;


-- ============================================================
-- ANALYSIS 2: Payment Method Unique Orders
-- ============================================================

SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS unique_orders
FROM payments
GROUP BY payment_method
ORDER BY unique_orders DESC;


-- ============================================================
-- ANALYSIS 3: Payment Method Customer Count
-- ============================================================

SELECT
    p.payment_method,
    COUNT(DISTINCT o.customer_id) AS customer_count
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
GROUP BY p.payment_method
ORDER BY customer_count DESC;


-- ============================================================
-- ANALYSIS 4: Payment Method Success Count
-- ============================================================

SELECT
    p.payment_method,
    COUNT(*) AS successful_transactions
FROM payments p
WHERE LOWER(p.payment_status) IN
      ('paid', 'completed', 'success', 'successful')
GROUP BY p.payment_method
ORDER BY successful_transactions DESC;


-- ============================================================
-- ANALYSIS 5: Payment Method Failure Count
-- ============================================================

SELECT
    p.payment_method,
    COUNT(*) AS failed_transactions
FROM payments p
WHERE LOWER(p.payment_status) IN
      ('failed', 'failure')
GROUP BY p.payment_method
ORDER BY failed_transactions DESC;


-- ============================================================
-- ANALYSIS 6: Payment Method Pending Count
-- ============================================================

SELECT
    p.payment_method,
    COUNT(*) AS pending_transactions
FROM payments p
WHERE LOWER(p.payment_status) = 'pending'
GROUP BY p.payment_method
ORDER BY pending_transactions DESC;


-- ============================================================
-- ANALYSIS 7: Payment Method Success Rate
-- ============================================================

SELECT
    p.payment_method,
    COUNT(*) AS total_transactions,

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
    ) AS success_rate

FROM payments p
GROUP BY p.payment_method
ORDER BY success_rate DESC;


-- ============================================================
-- ANALYSIS 8: Payment Method Failure Rate
-- ============================================================

SELECT
    p.payment_method,
    COUNT(*) AS total_transactions,

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
    ) AS failure_rate

FROM payments p
GROUP BY p.payment_method
ORDER BY failure_rate DESC;


-- ============================================================
-- ANALYSIS 9: Payment Method Pending Rate
-- ============================================================

SELECT
    p.payment_method,
    COUNT(*) AS total_transactions,

    SUM(
        CASE
            WHEN LOWER(p.payment_status) = 'pending'
            THEN 1
            ELSE 0
        END
    ) AS pending_transactions,

    ROUND(
        SUM(
            CASE
                WHEN LOWER(p.payment_status) = 'pending'
                THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS pending_rate

FROM payments p
GROUP BY p.payment_method
ORDER BY pending_rate DESC;


-- ============================================================
-- ANALYSIS 10: Customer Count by Payment Method
-- ============================================================

SELECT
    p.payment_method,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    COUNT(*) AS payment_transactions
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
GROUP BY p.payment_method
ORDER BY unique_customers DESC;


-- ============================================================
-- ANALYSIS 11: Most Preferred Payment Method
-- ============================================================

SELECT
    p.payment_method,
    COUNT(*) AS payment_transactions,
    RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS payment_method_rank
FROM payments p
GROUP BY p.payment_method
ORDER BY payment_method_rank;


-- ============================================================
-- ANALYSIS 12: Best Performing Payment Method
-- ============================================================

WITH payment_method_performance AS
(
    SELECT
        payment_method,
        COUNT(*) AS total_transactions,

        SUM(
            CASE
                WHEN LOWER(payment_status) IN
                     ('paid', 'completed', 'success', 'successful')
                THEN 1
                ELSE 0
            END
        ) AS successful_transactions

    FROM payments
    GROUP BY payment_method
)
SELECT
    payment_method,
    total_transactions,
    successful_transactions,
    ROUND(
        successful_transactions /
        NULLIF(total_transactions, 0) * 100,
        2
    ) AS success_rate,
    RANK() OVER (
        ORDER BY
            successful_transactions /
            NULLIF(total_transactions, 0) DESC
    ) AS performance_rank
FROM payment_method_performance
ORDER BY performance_rank;


-- ============================================================
-- ANALYSIS 13: Highest Failure Payment Method
-- ============================================================

WITH payment_method_failure AS
(
    SELECT
        payment_method,
        COUNT(*) AS total_transactions,

        SUM(
            CASE
                WHEN LOWER(payment_status) IN
                     ('failed', 'failure')
                THEN 1
                ELSE 0
            END
        ) AS failed_transactions

    FROM payments
    GROUP BY payment_method
)
SELECT
    payment_method,
    total_transactions,
    failed_transactions,
    ROUND(
        failed_transactions /
        NULLIF(total_transactions, 0) * 100,
        2
    ) AS failure_rate,
    RANK() OVER (
        ORDER BY
            failed_transactions /
            NULLIF(total_transactions, 0) DESC
    ) AS failure_rank
FROM payment_method_failure
ORDER BY failure_rank;


-- ============================================================
-- ANALYSIS 14: Payment Method Risk Classification
-- ============================================================

WITH payment_method_metrics AS
(
    SELECT
        payment_method,
        COUNT(*) AS total_transactions,

        SUM(
            CASE
                WHEN LOWER(payment_status) IN
                     ('paid', 'completed', 'success', 'successful')
                THEN 1
                ELSE 0
            END
        ) AS successful_transactions,

        SUM(
            CASE
                WHEN LOWER(payment_status) IN
                     ('failed', 'failure')
                THEN 1
                ELSE 0
            END
        ) AS failed_transactions,

        SUM(
            CASE
                WHEN LOWER(payment_status) = 'pending'
                THEN 1
                ELSE 0
            END
        ) AS pending_transactions

    FROM payments
    GROUP BY payment_method
)

SELECT
    payment_method,
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

    ROUND(
        pending_transactions /
        NULLIF(total_transactions, 0) * 100,
        2
    ) AS pending_rate,

    CASE
        WHEN failed_transactions /
             NULLIF(total_transactions, 0) >= 0.50
            THEN 'High Risk'

        WHEN failed_transactions /
             NULLIF(total_transactions, 0) >= 0.20
             OR pending_transactions /
                NULLIF(total_transactions, 0) >= 0.20
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS payment_method_risk

FROM payment_method_metrics
ORDER BY
    CASE
        WHEN failed_transactions /
             NULLIF(total_transactions, 0) >= 0.50
            THEN 1

        WHEN failed_transactions /
             NULLIF(total_transactions, 0) >= 0.20
             OR pending_transactions /
                NULLIF(total_transactions, 0) >= 0.20
            THEN 2

        ELSE 3
    END,
    failure_rate DESC;


-- ============================================================
-- ANALYSIS 15: Final Payment Method Performance Summary
-- ============================================================

WITH payment_method_summary AS
(
    SELECT
        payment_method,

        COUNT(*) AS total_transactions,

        COUNT(DISTINCT order_id) AS unique_orders,

        SUM(
            CASE
                WHEN LOWER(payment_status) IN
                     ('paid', 'completed', 'success', 'successful')
                THEN 1
                ELSE 0
            END
        ) AS successful_transactions,

        SUM(
            CASE
                WHEN LOWER(payment_status) IN
                     ('failed', 'failure')
                THEN 1
                ELSE 0
            END
        ) AS failed_transactions,

        SUM(
            CASE
                WHEN LOWER(payment_status) = 'pending'
                THEN 1
                ELSE 0
            END
        ) AS pending_transactions

    FROM payments
    GROUP BY payment_method
)

SELECT
    payment_method,
    total_transactions,
    unique_orders,
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

    ROUND(
        pending_transactions /
        NULLIF(total_transactions, 0) * 100,
        2
    ) AS pending_rate,

    CASE
        WHEN failed_transactions /
             NULLIF(total_transactions, 0) >= 0.50
            THEN 'High Risk'

        WHEN failed_transactions /
             NULLIF(total_transactions, 0) >= 0.20
             OR pending_transactions /
                NULLIF(total_transactions, 0) >= 0.20
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS payment_method_risk

FROM payment_method_summary
ORDER BY
    success_rate DESC;