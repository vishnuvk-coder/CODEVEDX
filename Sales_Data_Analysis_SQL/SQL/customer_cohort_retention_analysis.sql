USE sales_analysis_db;

-- ============================================================
-- DAY 40
-- CUSTOMER COHORT & RETENTION TREND ANALYSIS
-- ============================================================


-- ============================================================
-- ANALYSIS 1: CUSTOMER COHORT IDENTIFICATION
-- Identify each customer's first purchase month.
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    first_purchase_date,
    DATE_FORMAT(first_purchase_date, '%Y-%m-01') AS cohort_month
FROM customer_first_purchase
ORDER BY first_purchase_date;


-- ============================================================
-- ANALYSIS 2: COHORT CUSTOMER DISTRIBUTION
-- Count customers belonging to each cohort.
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
)
SELECT
    DATE_FORMAT(first_purchase_date, '%Y-%m-01') AS cohort_month,
    COUNT(DISTINCT customer_id) AS cohort_customers
FROM customer_first_purchase
GROUP BY DATE_FORMAT(first_purchase_date, '%Y-%m-01')
ORDER BY cohort_month;


-- ============================================================
-- ANALYSIS 3: MONTHLY CUSTOMER ACTIVITY
-- Track customer activity after their first purchase month.
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
),
customer_activity AS (
    SELECT DISTINCT
        o.customer_id,
        DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01') AS cohort_month,
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS activity_month
    FROM orders o
    JOIN customer_first_purchase cfp
        ON o.customer_id = cfp.customer_id
)
SELECT
    cohort_month,
    activity_month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM customer_activity
GROUP BY
    cohort_month,
    activity_month
ORDER BY
    cohort_month,
    activity_month;


-- ============================================================
-- ANALYSIS 4: COHORT RETENTION RATE
-- Calculate retention percentage for each cohort and month.
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
),
cohort_data AS (
    SELECT DISTINCT
        o.customer_id,
        DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01') AS cohort_month,
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS activity_month
    FROM orders o
    JOIN customer_first_purchase cfp
        ON o.customer_id = cfp.customer_id
),
cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_customers
    FROM cohort_data
    GROUP BY cohort_month
)
SELECT
    cd.cohort_month,
    cd.activity_month,
    COUNT(DISTINCT cd.customer_id) AS active_customers,
    cs.cohort_customers,
    ROUND(
        COUNT(DISTINCT cd.customer_id) * 100.0
        / cs.cohort_customers,
        2
    ) AS retention_rate_percent
FROM cohort_data cd
JOIN cohort_size cs
    ON cd.cohort_month = cs.cohort_month
GROUP BY
    cd.cohort_month,
    cd.activity_month,
    cs.cohort_customers
ORDER BY
    cd.cohort_month,
    cd.activity_month;


-- ============================================================
-- ANALYSIS 5: MONTH-1 RETENTION
-- Measure customers returning one month after their first purchase.
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
),
customer_month_activity AS (
    SELECT DISTINCT
        o.customer_id,
        DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01') AS cohort_month,
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS activity_month
    FROM orders o
    JOIN customer_first_purchase cfp
        ON o.customer_id = cfp.customer_id
),
cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_customers
    FROM customer_month_activity
    GROUP BY cohort_month
)
SELECT
    cma.cohort_month,
    cs.cohort_customers,
    COUNT(DISTINCT cma.customer_id) AS month_1_returning_customers,
    ROUND(
        COUNT(DISTINCT cma.customer_id) * 100.0
        / cs.cohort_customers,
        2
    ) AS month_1_retention_percent
FROM customer_month_activity cma
JOIN cohort_size cs
    ON cma.cohort_month = cs.cohort_month
WHERE TIMESTAMPDIFF(
    MONTH,
    cma.cohort_month,
    cma.activity_month
) = 1
GROUP BY
    cma.cohort_month,
    cs.cohort_customers
ORDER BY
    cma.cohort_month;


-- ============================================================
-- ANALYSIS 6: MONTH-2 RETENTION
-- Measure customers returning two months after their first purchase.
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
),
customer_month_activity AS (
    SELECT DISTINCT
        o.customer_id,
        DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01') AS cohort_month,
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS activity_month
    FROM orders o
    JOIN customer_first_purchase cfp
        ON o.customer_id = cfp.customer_id
),
cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_customers
    FROM customer_month_activity
    GROUP BY cohort_month
)
SELECT
    cma.cohort_month,
    cs.cohort_customers,
    COUNT(DISTINCT cma.customer_id) AS month_2_returning_customers,
    ROUND(
        COUNT(DISTINCT cma.customer_id) * 100.0
        / cs.cohort_customers,
        2
    ) AS month_2_retention_percent
FROM customer_month_activity cma
JOIN cohort_size cs
    ON cma.cohort_month = cs.cohort_month
WHERE TIMESTAMPDIFF(
    MONTH,
    cma.cohort_month,
    cma.activity_month
) = 2
GROUP BY
    cma.cohort_month,
    cs.cohort_customers
ORDER BY
    cma.cohort_month;


-- ============================================================
-- ANALYSIS 7: MONTH-3 RETENTION
-- Measure customers returning three months after their first purchase.
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
),
customer_month_activity AS (
    SELECT DISTINCT
        o.customer_id,
        DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01') AS cohort_month,
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS activity_month
    FROM orders o
    JOIN customer_first_purchase cfp
        ON o.customer_id = cfp.customer_id
),
cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_customers
    FROM customer_month_activity
    GROUP BY cohort_month
)
SELECT
    cma.cohort_month,
    cs.cohort_customers,
    COUNT(DISTINCT cma.customer_id) AS month_3_returning_customers,
    ROUND(
        COUNT(DISTINCT cma.customer_id) * 100.0
        / cs.cohort_customers,
        2
    ) AS month_3_retention_percent
FROM customer_month_activity cma
JOIN cohort_size cs
    ON cma.cohort_month = cs.cohort_month
WHERE TIMESTAMPDIFF(
    MONTH,
    cma.cohort_month,
    cma.activity_month
) = 3
GROUP BY
    cma.cohort_month,
    cs.cohort_customers
ORDER BY
    cma.cohort_month;


-- ============================================================
-- ANALYSIS 8: COHORT REVENUE ANALYSIS
-- Calculate total revenue generated by each customer cohort.
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
),
cohort_revenue AS (
    SELECT
        DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01') AS cohort_month,
        oi.quantity * p.price AS revenue
    FROM customer_first_purchase cfp
    JOIN orders o
        ON cfp.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
)
SELECT
    cohort_month,
    ROUND(SUM(revenue), 2) AS total_cohort_revenue
FROM cohort_revenue
GROUP BY cohort_month
ORDER BY cohort_month;


-- ============================================================
-- ANALYSIS 9: COHORT REPEAT PURCHASE ANALYSIS
-- Compare one-time and repeat customers by cohort.
-- ============================================================

WITH customer_order_metrics AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
),
customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
)
SELECT
    DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01') AS cohort_month,
    COUNT(DISTINCT cfp.customer_id) AS total_customers,
    SUM(
        CASE
            WHEN com.total_orders = 1 THEN 1
            ELSE 0
        END
    ) AS one_time_customers,
    SUM(
        CASE
            WHEN com.total_orders > 1 THEN 1
            ELSE 0
        END
    ) AS repeat_customers,
    ROUND(
        SUM(
            CASE
                WHEN com.total_orders > 1 THEN 1
                ELSE 0
            END
        ) * 100.0
        / COUNT(DISTINCT cfp.customer_id),
        2
    ) AS repeat_customer_percent
FROM customer_first_purchase cfp
JOIN customer_order_metrics com
    ON cfp.customer_id = com.customer_id
GROUP BY
    DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01')
ORDER BY cohort_month;


-- ============================================================
-- ANALYSIS 10: COHORT PERFORMANCE RANKING
-- Rank cohorts based on total revenue.
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
),
cohort_revenue AS (
    SELECT
        DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01') AS cohort_month,
        oi.quantity * p.price AS revenue
    FROM customer_first_purchase cfp
    JOIN orders o
        ON cfp.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
),
cohort_summary AS (
    SELECT
        cohort_month,
        SUM(revenue) AS total_revenue
    FROM cohort_revenue
    GROUP BY cohort_month
)
SELECT
    cohort_month,
    ROUND(total_revenue, 2) AS total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM cohort_summary
ORDER BY revenue_rank;


-- ============================================================
-- ANALYSIS 11: BEST & WORST PERFORMING COHORTS
-- Identify cohort performance using retention and revenue.
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
),
customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
),
cohort_summary AS (
    SELECT
        DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01') AS cohort_month,
        COUNT(DISTINCT cfp.customer_id) AS total_customers,
        SUM(
            CASE
                WHEN co.total_orders > 1 THEN 1
                ELSE 0
            END
        ) AS repeat_customers
    FROM customer_first_purchase cfp
    JOIN customer_orders co
        ON cfp.customer_id = co.customer_id
    GROUP BY
        DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01')
),
cohort_revenue AS (
    SELECT
        DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01') AS cohort_month,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customer_first_purchase cfp
    JOIN orders o
        ON cfp.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01')
)
SELECT
    cs.cohort_month,
    cs.total_customers,
    cs.repeat_customers,
    ROUND(
        cs.repeat_customers * 100.0
        / cs.total_customers,
        2
    ) AS repeat_customer_percent,
    ROUND(cr.total_revenue, 2) AS total_revenue,
    CASE
        WHEN
            cs.repeat_customers * 100.0 / cs.total_customers >= 50
            AND cr.total_revenue >= (
                SELECT AVG(total_revenue)
                FROM cohort_revenue
            )
        THEN 'High Performing Cohort'

        WHEN
            cs.repeat_customers * 100.0 / cs.total_customers < 25
            AND cr.total_revenue < (
                SELECT AVG(total_revenue)
                FROM cohort_revenue
            )
        THEN 'Low Performing Cohort'

        ELSE 'Average Performing Cohort'
    END AS cohort_performance
FROM cohort_summary cs
JOIN cohort_revenue cr
    ON cs.cohort_month = cr.cohort_month
ORDER BY
    total_revenue DESC;


-- ============================================================
-- ANALYSIS 12: FINAL COHORT RETENTION BUSINESS SUMMARY
-- Combine cohort size, repeat behavior and revenue.
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
),
customer_metrics AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
),
cohort_summary AS (
    SELECT
        DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01') AS cohort_month,
        COUNT(DISTINCT cfp.customer_id) AS total_customers,
        SUM(
            CASE
                WHEN cm.total_orders > 1 THEN 1
                ELSE 0
            END
        ) AS repeat_customers
    FROM customer_first_purchase cfp
    JOIN customer_metrics cm
        ON cfp.customer_id = cm.customer_id
    GROUP BY
        DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01')
),
cohort_revenue AS (
    SELECT
        DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01') AS cohort_month,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customer_first_purchase cfp
    JOIN orders o
        ON cfp.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        DATE_FORMAT(cfp.first_purchase_date, '%Y-%m-01')
)
SELECT
    cs.cohort_month,
    cs.total_customers,
    cs.repeat_customers,
    ROUND(
        cs.repeat_customers * 100.0
        / cs.total_customers,
        2
    ) AS repeat_customer_percent,
    ROUND(cr.total_revenue, 2) AS total_revenue,
    ROUND(
        cr.total_revenue / cs.total_customers,
        2
    ) AS revenue_per_customer,
    CASE
        WHEN
            cs.repeat_customers * 100.0
            / cs.total_customers >= 50
        THEN 'Strong Retention'

        WHEN
            cs.repeat_customers * 100.0
            / cs.total_customers >= 25
        THEN 'Moderate Retention'

        ELSE 'Weak Retention'
    END AS retention_category
FROM cohort_summary cs
JOIN cohort_revenue cr
    ON cs.cohort_month = cr.cohort_month
ORDER BY
    cs.cohort_month;