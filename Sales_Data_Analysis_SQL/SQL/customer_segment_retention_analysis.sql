USE sales_analysis_db;


/* ============================================================
   DAY 39
   CUSTOMER SEGMENT RETENTION & CHURN RISK ANALYSIS
   ============================================================

   Objective:
   Analyze customer retention, repeat behavior, inactivity,
   churn risk, and revenue at risk across RFM segments.

   RFM Segments:
   - Champions
   - Loyal Customers
   - New Customers
   - At-Risk Customers
   - Lost Customers
   - Potential Customers
*/


/* ============================================================
   COMMON RFM BASE
   ============================================================

   This logic is reused across the Day 39 analyses.
   ============================================================ */


/* ============================================================
   ANALYSIS 1
   Customer Retention by RFM Segment
   ============================================================ */

WITH customer_metrics AS
(
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS frequency_orders,
        MAX(o.order_date) AS last_purchase_date,

        SUM(
            oi.quantity * p.price
        ) AS monetary_value

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY c.customer_id
),

rfm_base AS
(
    SELECT
        customer_id,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS recency_days,

        frequency_orders,

        monetary_value

    FROM customer_metrics
),

rfm_scores AS
(
    SELECT
        customer_id,
        recency_days,
        frequency_orders,
        monetary_value,

        NTILE(5) OVER (
            ORDER BY recency_days DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency_orders
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary_value
        ) AS monetary_score

    FROM rfm_base
),

customer_segments AS
(
    SELECT
        customer_id,
        recency_days,
        frequency_orders,
        monetary_value,
        recency_score,
        frequency_score,
        monetary_score,

        CASE

            WHEN recency_score >= 4
             AND frequency_score >= 4
             AND monetary_score >= 4
                THEN 'Champions'

            WHEN recency_score >= 3
             AND frequency_score >= 4
                THEN 'Loyal Customers'

            WHEN recency_score >= 4
             AND frequency_score <= 2
                THEN 'New Customers'

            WHEN recency_score <= 2
             AND frequency_score >= 3
                THEN 'At-Risk Customers'

            WHEN recency_score <= 2
             AND frequency_score <= 2
             AND monetary_score <= 2
                THEN 'Lost Customers'

            ELSE 'Potential Customers'

        END AS customer_segment

    FROM rfm_scores
)

SELECT
    customer_segment,

    COUNT(*) AS total_customers,

    COUNT(
        CASE
            WHEN frequency_orders >= 2
            THEN 1
        END
    ) AS repeat_customers,

    ROUND(
        COUNT(
            CASE
                WHEN frequency_orders >= 2
                THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS retention_rate_percentage

FROM customer_segments

GROUP BY customer_segment

ORDER BY retention_rate_percentage DESC;


/* ============================================================
   ANALYSIS 2
   Repeat vs One-Time Customers by Segment
   ============================================================ */

WITH customer_order_metrics AS
(
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_id
),

rfm_data AS
(
    SELECT
        com.customer_id,
        com.total_orders,

        NTILE(5) OVER (
            ORDER BY
            DATEDIFF(
                (SELECT MAX(order_date) FROM orders),
                (
                    SELECT MAX(o2.order_date)
                    FROM orders o2
                    WHERE o2.customer_id = com.customer_id
                )
            ) DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY com.total_orders
        ) AS frequency_score

    FROM customer_order_metrics com
),

segments AS
(
    SELECT
        customer_id,
        total_orders,

        CASE

            WHEN recency_score >= 4
             AND frequency_score >= 4
                THEN 'Champions'

            WHEN recency_score >= 3
             AND frequency_score >= 4
                THEN 'Loyal Customers'

            WHEN recency_score >= 4
             AND frequency_score <= 2
                THEN 'New Customers'

            WHEN recency_score <= 2
             AND frequency_score >= 3
                THEN 'At-Risk Customers'

            WHEN recency_score <= 2
             AND frequency_score <= 2
                THEN 'Lost Customers'

            ELSE 'Potential Customers'

        END AS customer_segment

    FROM rfm_data
)

SELECT
    customer_segment,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN total_orders = 1 THEN 1
            ELSE 0
        END
    ) AS one_time_customers,

    SUM(
        CASE
            WHEN total_orders >= 2 THEN 1
            ELSE 0
        END
    ) AS repeat_customers

FROM segments

GROUP BY customer_segment

ORDER BY total_customers DESC;


/* ============================================================
   ANALYSIS 3
   Customer Churn / Risk Indicators
   ============================================================ */

WITH customer_activity AS
(
    SELECT
        c.customer_id,

        COUNT(DISTINCT o.order_id) AS total_orders,

        MAX(o.order_date) AS last_purchase_date,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS inactive_days

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_id
)

SELECT

    CASE

        WHEN total_orders = 1
            THEN 'One-Time Customer'

        WHEN inactive_days > 180
            THEN 'High Churn Risk'

        WHEN inactive_days BETWEEN 91 AND 180
            THEN 'Medium Churn Risk'

        WHEN inactive_days BETWEEN 31 AND 90
            THEN 'Low Churn Risk'

        ELSE 'Active Customer'

    END AS churn_status,

    COUNT(*) AS customer_count

FROM customer_activity

GROUP BY churn_status

ORDER BY customer_count DESC;


/* ============================================================
   ANALYSIS 4
   At-Risk Customer Count
   ============================================================ */

WITH customer_activity AS
(
    SELECT
        c.customer_id,

        COUNT(DISTINCT o.order_id) AS total_orders,

        MAX(o.order_date) AS last_purchase_date,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS inactive_days

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_id
)

SELECT
    COUNT(*) AS at_risk_customer_count

FROM customer_activity

WHERE total_orders >= 2
  AND inactive_days > 90;


/* ============================================================
   ANALYSIS 5
   Lost Customer Count
   ============================================================ */

WITH customer_activity AS
(
    SELECT
        c.customer_id,

        COUNT(DISTINCT o.order_id) AS total_orders,

        MAX(o.order_date) AS last_purchase_date,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS inactive_days

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_id
)

SELECT
    COUNT(*) AS lost_customer_count

FROM customer_activity

WHERE total_orders <= 2
  AND inactive_days > 180;


/* ============================================================
   ANALYSIS 6
   Champion Retention Performance
   ============================================================ */

WITH customer_metrics AS
(
    SELECT
        c.customer_id,

        COUNT(DISTINCT o.order_id) AS frequency_orders,

        MAX(o.order_date) AS last_purchase_date,

        SUM(
            oi.quantity * p.price
        ) AS monetary_value

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY c.customer_id
),

scored AS
(
    SELECT
        customer_id,
        frequency_orders,
        monetary_value,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS recency_days,

        NTILE(5) OVER (
            ORDER BY
            DATEDIFF(
                (SELECT MAX(order_date) FROM orders),
                last_purchase_date
            ) DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency_orders
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary_value
        ) AS monetary_score

    FROM customer_metrics
),

segments AS
(
    SELECT
        *,

        CASE
            WHEN recency_score >= 4
             AND frequency_score >= 4
             AND monetary_score >= 4
                THEN 'Champions'

            WHEN recency_score >= 3
             AND frequency_score >= 4
                THEN 'Loyal Customers'

            WHEN recency_score >= 4
             AND frequency_score <= 2
                THEN 'New Customers'

            WHEN recency_score <= 2
             AND frequency_score >= 3
                THEN 'At-Risk Customers'

            WHEN recency_score <= 2
             AND frequency_score <= 2
             AND monetary_score <= 2
                THEN 'Lost Customers'

            ELSE 'Potential Customers'

        END AS customer_segment

    FROM scored
)

SELECT
    COUNT(*) AS champion_customers,

    SUM(
        CASE
            WHEN recency_days <= 90 THEN 1
            ELSE 0
        END
    ) AS active_champions,

    SUM(
        CASE
            WHEN recency_days > 90 THEN 1
            ELSE 0
        END
    ) AS inactive_champions,

    ROUND(
        SUM(
            CASE
                WHEN recency_days <= 90 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS champion_retention_percentage

FROM segments

WHERE customer_segment = 'Champions';


/* ============================================================
   ANALYSIS 7
   Loyal Customer Retention Performance
   ============================================================ */

WITH customer_metrics AS
(
    SELECT
        c.customer_id,

        COUNT(DISTINCT o.order_id) AS frequency_orders,

        MAX(o.order_date) AS last_purchase_date

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_id
),

scored AS
(
    SELECT
        customer_id,
        frequency_orders,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS recency_days,

        NTILE(5) OVER (
            ORDER BY
            DATEDIFF(
                (SELECT MAX(order_date) FROM orders),
                last_purchase_date
            ) DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency_orders
        ) AS frequency_score

    FROM customer_metrics
)

SELECT

    COUNT(*) AS loyal_customers,

    SUM(
        CASE
            WHEN recency_days <= 90 THEN 1
            ELSE 0
        END
    ) AS active_loyal_customers,

    SUM(
        CASE
            WHEN recency_days > 90 THEN 1
            ELSE 0
        END
    ) AS inactive_loyal_customers,

    ROUND(
        SUM(
            CASE
                WHEN recency_days <= 90 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS loyal_customer_retention_percentage

FROM scored

WHERE recency_score >= 3
  AND frequency_score >= 4;


/* ============================================================
   ANALYSIS 8
   Average Customer Lifetime by Segment
   ============================================================ */

WITH customer_lifetime AS
(
    SELECT
        c.customer_id,

        MIN(o.order_date) AS first_purchase_date,

        MAX(o.order_date) AS last_purchase_date,

        COUNT(DISTINCT o.order_id) AS total_orders

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_id
),

segment_data AS
(
    SELECT
        customer_id,
        first_purchase_date,
        last_purchase_date,
        total_orders,

        DATEDIFF(
            last_purchase_date,
            first_purchase_date
        ) AS lifetime_days

    FROM customer_lifetime
)

SELECT

    CASE

        WHEN total_orders >= 7 THEN 'Frequent Customers'
        WHEN total_orders BETWEEN 4 AND 6 THEN 'Regular Customers'
        WHEN total_orders BETWEEN 2 AND 3 THEN 'Occasional Customers'
        ELSE 'One-Time Customers'

    END AS customer_behavior,

    COUNT(*) AS customer_count,

    ROUND(
        AVG(lifetime_days),
        2
    ) AS average_lifetime_days

FROM segment_data

GROUP BY customer_behavior

ORDER BY average_lifetime_days DESC;


/* ============================================================
   ANALYSIS 9
   Customer Inactivity Analysis
   ============================================================ */

WITH customer_activity AS
(
    SELECT
        c.customer_id,

        COUNT(DISTINCT o.order_id) AS total_orders,

        MAX(o.order_date) AS last_purchase_date,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS inactive_days

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_id
)

SELECT

    CASE

        WHEN inactive_days <= 30
            THEN 'Active: 0-30 Days'

        WHEN inactive_days BETWEEN 31 AND 90
            THEN 'Inactive: 31-90 Days'

        WHEN inactive_days BETWEEN 91 AND 180
            THEN 'At Risk: 91-180 Days'

        ELSE 'Churn Risk: 180+ Days'

    END AS inactivity_category,

    COUNT(*) AS customer_count

FROM customer_activity

GROUP BY inactivity_category

ORDER BY customer_count DESC;


/* ============================================================
   ANALYSIS 10
   Revenue at Risk from Inactive Customers
   ============================================================ */

WITH customer_revenue AS
(
    SELECT
        c.customer_id,

        SUM(
            oi.quantity * p.price
        ) AS total_revenue,

        MAX(o.order_date) AS last_purchase_date,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS inactive_days

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY c.customer_id
)

SELECT

    CASE

        WHEN inactive_days BETWEEN 91 AND 180
            THEN 'At-Risk Revenue'

        WHEN inactive_days > 180
            THEN 'High Churn Risk Revenue'

        ELSE 'Active Revenue'

    END AS revenue_status,

    COUNT(*) AS customer_count,

    ROUND(
        SUM(total_revenue),
        2
    ) AS revenue_amount

FROM customer_revenue

GROUP BY revenue_status

ORDER BY revenue_amount DESC;


/* ============================================================
   ANALYSIS 11
   Segment Retention Ranking
   ============================================================ */

WITH customer_metrics AS
(
    SELECT
        c.customer_id,

        COUNT(DISTINCT o.order_id) AS total_orders,

        MAX(o.order_date) AS last_purchase_date,

        SUM(
            oi.quantity * p.price
        ) AS total_revenue

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY c.customer_id
),

scored AS
(
    SELECT
        customer_id,
        total_orders,
        total_revenue,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS recency_days,

        NTILE(5) OVER (
            ORDER BY
            DATEDIFF(
                (SELECT MAX(order_date) FROM orders),
                last_purchase_date
            ) DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY total_orders
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY total_revenue
        ) AS monetary_score

    FROM customer_metrics
),

segments AS
(
    SELECT

        customer_id,
        total_orders,
        total_revenue,
        recency_days,

        CASE

            WHEN recency_score >= 4
             AND frequency_score >= 4
             AND monetary_score >= 4
                THEN 'Champions'

            WHEN recency_score >= 3
             AND frequency_score >= 4
                THEN 'Loyal Customers'

            WHEN recency_score >= 4
             AND frequency_score <= 2
                THEN 'New Customers'

            WHEN recency_score <= 2
             AND frequency_score >= 3
                THEN 'At-Risk Customers'

            WHEN recency_score <= 2
             AND frequency_score <= 2
             AND monetary_score <= 2
                THEN 'Lost Customers'

            ELSE 'Potential Customers'

        END AS customer_segment

    FROM scored
),

segment_retention AS
(
    SELECT

        customer_segment,

        COUNT(*) AS total_customers,

        SUM(
            CASE
                WHEN recency_days <= 90
                THEN 1
                ELSE 0
            END
        ) AS active_customers,

        SUM(total_revenue) AS total_revenue

    FROM segments

    GROUP BY customer_segment
)

SELECT

    customer_segment,

    total_customers,

    active_customers,

    ROUND(
        active_customers * 100.0 / total_customers,
        2
    ) AS retention_percentage,

    ROUND(
        total_revenue,
        2
    ) AS total_revenue,

    RANK() OVER (
        ORDER BY
        active_customers * 100.0 / total_customers DESC
    ) AS retention_rank

FROM segment_retention

ORDER BY retention_rank;


/* ============================================================
   ANALYSIS 12
   FINAL CUSTOMER RETENTION BUSINESS SUMMARY
   ============================================================ */

WITH customer_metrics AS
(
    SELECT
        c.customer_id,

        COUNT(DISTINCT o.order_id) AS total_orders,

        MIN(o.order_date) AS first_purchase_date,

        MAX(o.order_date) AS last_purchase_date,

        SUM(
            oi.quantity * p.price
        ) AS total_revenue

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY c.customer_id
),

scored AS
(
    SELECT

        customer_id,
        total_orders,
        first_purchase_date,
        last_purchase_date,
        total_revenue,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            last_purchase_date
        ) AS inactive_days,

        NTILE(5) OVER (
            ORDER BY
            DATEDIFF(
                (SELECT MAX(order_date) FROM orders),
                last_purchase_date
            ) DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY total_orders
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY total_revenue
        ) AS monetary_score

    FROM customer_metrics
)

SELECT

    CASE

        WHEN recency_score >= 4
         AND frequency_score >= 4
         AND monetary_score >= 4
            THEN 'Champions'

        WHEN recency_score >= 3
         AND frequency_score >= 4
            THEN 'Loyal Customers'

        WHEN recency_score >= 4
         AND frequency_score <= 2
            THEN 'New Customers'

        WHEN recency_score <= 2
         AND frequency_score >= 3
            THEN 'At-Risk Customers'

        WHEN recency_score <= 2
         AND frequency_score <= 2
         AND monetary_score <= 2
            THEN 'Lost Customers'

        ELSE 'Potential Customers'

    END AS customer_segment,

    COUNT(*) AS customer_count,

    ROUND(
        AVG(total_orders),
        2
    ) AS average_orders,

    ROUND(
        AVG(total_revenue),
        2
    ) AS average_customer_revenue,

    ROUND(
        SUM(total_revenue),
        2
    ) AS total_segment_revenue,

    ROUND(
        AVG(inactive_days),
        2
    ) AS average_inactive_days,

    SUM(
        CASE
            WHEN inactive_days <= 90
            THEN 1
            ELSE 0
        END
    ) AS active_customers,

    SUM(
        CASE
            WHEN inactive_days > 90
            THEN 1
            ELSE 0
        END
    ) AS inactive_customers

FROM scored

GROUP BY customer_segment

ORDER BY total_segment_revenue DESC;


/* ============================================================
   END OF DAY 39 ANALYSIS
   ============================================================ */

