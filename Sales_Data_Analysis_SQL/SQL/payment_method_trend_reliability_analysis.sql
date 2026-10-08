USE sales_analysis_db;

-- ============================================================
-- DAY 68
-- Payment Method Trend & Reliability Analysis
-- ============================================================

-- STEP 0: VERIFY PAYMENT STATUS AND PAYMENT METHODS

SELECT DISTINCT payment_status
FROM payments
ORDER BY payment_status;

SELECT DISTINCT payment_method
FROM payments
ORDER BY payment_method;


-- ANALYSIS 1: Payment Method Usage by Date

SELECT
    payment_date,
    payment_method,
    COUNT(*) AS payment_transactions,
    COUNT(DISTINCT order_id) AS unique_orders
FROM payments
GROUP BY
    payment_date,
    payment_method
ORDER BY
    payment_date,
    payment_transactions DESC;


-- ANALYSIS 2: Payment Method Usage by Month

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    payment_method,
    COUNT(*) AS payment_transactions
FROM payments
GROUP BY
    DATE_FORMAT(payment_date, '%Y-%m'),
    payment_method
ORDER BY
    payment_month,
    payment_transactions DESC;


-- ANALYSIS 3: Monthly Transactions by Payment Method

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    payment_method,
    COUNT(*) AS total_transactions
FROM payments
GROUP BY
    DATE_FORMAT(payment_date, '%Y-%m'),
    payment_method
ORDER BY
    payment_month,
    total_transactions DESC;


-- ANALYSIS 4: Monthly Unique Orders by Payment Method

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    payment_method,
    COUNT(DISTINCT order_id) AS unique_orders
FROM payments
GROUP BY
    DATE_FORMAT(payment_date, '%Y-%m'),
    payment_method
ORDER BY
    payment_month,
    unique_orders DESC;


-- ANALYSIS 5: Monthly Customer Count by Payment Method

SELECT
    DATE_FORMAT(p.payment_date, '%Y-%m') AS payment_month,
    p.payment_method,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
GROUP BY
    DATE_FORMAT(p.payment_date, '%Y-%m'),
    p.payment_method
ORDER BY
    payment_month,
    unique_customers DESC;


-- ANALYSIS 6: Monthly Successful Transactions

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    payment_method,
    COUNT(*) AS successful_transactions
FROM payments
WHERE LOWER(payment_status) IN
      ('paid', 'completed', 'success', 'successful')
GROUP BY
    DATE_FORMAT(payment_date, '%Y-%m'),
    payment_method
ORDER BY
    payment_month,
    successful_transactions DESC;


-- ANALYSIS 7: Monthly Failed Transactions

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    payment_method,
    COUNT(*) AS failed_transactions
FROM payments
WHERE LOWER(payment_status) IN
      ('failed', 'failure')
GROUP BY
    DATE_FORMAT(payment_date, '%Y-%m'),
    payment_method
ORDER BY
    payment_month,
    failed_transactions DESC;


-- ANALYSIS 8: Monthly Pending Transactions

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    payment_method,
    COUNT(*) AS pending_transactions
FROM payments
WHERE LOWER(payment_status) = 'pending'
GROUP BY
    DATE_FORMAT(payment_date, '%Y-%m'),
    payment_method
ORDER BY
    payment_month,
    pending_transactions DESC;


-- ANALYSIS 9: Monthly Payment Success Rate

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
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
    ROUND(
        SUM(
            CASE
                WHEN LOWER(payment_status) IN
                     ('paid', 'completed', 'success', 'successful')
                THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS success_rate
FROM payments
GROUP BY
    DATE_FORMAT(payment_date, '%Y-%m'),
    payment_method
ORDER BY
    payment_month,
    success_rate DESC;


-- ANALYSIS 10: Monthly Payment Failure Rate

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    payment_method,
    COUNT(*) AS total_transactions,
    SUM(
        CASE
            WHEN LOWER(payment_status) IN
                 ('failed', 'failure')
            THEN 1
            ELSE 0
        END
    ) AS failed_transactions,
    ROUND(
        SUM(
            CASE
                WHEN LOWER(payment_status) IN
                     ('failed', 'failure')
                THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS failure_rate
FROM payments
GROUP BY
    DATE_FORMAT(payment_date, '%Y-%m'),
    payment_method
ORDER BY
    payment_month,
    failure_rate DESC;


-- ANALYSIS 11: Monthly Payment Pending Rate

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    payment_method,
    COUNT(*) AS total_transactions,
    SUM(
        CASE
            WHEN LOWER(payment_status) = 'pending'
            THEN 1
            ELSE 0
        END
    ) AS pending_transactions,
    ROUND(
        SUM(
            CASE
                WHEN LOWER(payment_status) = 'pending'
                THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS pending_rate
FROM payments
GROUP BY
    DATE_FORMAT(payment_date, '%Y-%m'),
    payment_method
ORDER BY
    payment_month,
    pending_rate DESC;


-- ANALYSIS 12: Payment Method Monthly Performance Ranking

WITH monthly_payment_performance AS
(
    SELECT
        DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
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
    GROUP BY
        DATE_FORMAT(payment_date, '%Y-%m'),
        payment_method
)
SELECT
    payment_month,
    payment_method,
    total_transactions,
    successful_transactions,
    ROUND(
        successful_transactions /
        NULLIF(total_transactions, 0) * 100,
        2
    ) AS success_rate,
    RANK() OVER (
        PARTITION BY payment_month
        ORDER BY
            successful_transactions /
            NULLIF(total_transactions, 0) DESC
    ) AS monthly_performance_rank
FROM monthly_payment_performance
ORDER BY
    payment_month,
    monthly_performance_rank;


-- ANALYSIS 13: Payment Method Reliability Analysis

WITH payment_method_reliability AS
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
        WHEN successful_transactions /
             NULLIF(total_transactions, 0) >= 0.90
            THEN 'Highly Reliable'
        WHEN successful_transactions /
             NULLIF(total_transactions, 0) >= 0.75
            THEN 'Moderately Reliable'
        ELSE 'Low Reliability'
    END AS reliability_classification
FROM payment_method_reliability
ORDER BY
    success_rate DESC;


-- ANALYSIS 14: Highest-Growth Payment Method

WITH monthly_payment_usage AS
(
    SELECT
        DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
        payment_method,
        COUNT(*) AS transaction_count
    FROM payments
    GROUP BY
        DATE_FORMAT(payment_date, '%Y-%m'),
        payment_method
),
payment_growth AS
(
    SELECT
        payment_month,
        payment_method,
        transaction_count,
        LAG(transaction_count) OVER (
            PARTITION BY payment_method
            ORDER BY payment_month
        ) AS previous_month_transactions
    FROM monthly_payment_usage
)
SELECT
    payment_month,
    payment_method,
    transaction_count,
    previous_month_transactions,
    ROUND(
        (
            transaction_count -
            previous_month_transactions
        ) / NULLIF(previous_month_transactions, 0) * 100,
        2
    ) AS month_over_month_growth
FROM payment_growth
WHERE previous_month_transactions IS NOT NULL
ORDER BY
    month_over_month_growth DESC;


-- ANALYSIS 15: Final Payment Method Trend & Reliability Summary

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
        WHEN successful_transactions /
             NULLIF(total_transactions, 0) >= 0.90
            THEN 'Highly Reliable'
        WHEN successful_transactions /
             NULLIF(total_transactions, 0) >= 0.75
            THEN 'Moderately Reliable'
        ELSE 'Low Reliability'
    END AS reliability_classification
FROM payment_method_summary
ORDER BY
    success_rate DESC;