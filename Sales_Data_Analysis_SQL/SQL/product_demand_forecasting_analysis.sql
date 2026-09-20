USE sales_analysis_db;


-- ============================================================
-- DAY 51
-- PRODUCT DEMAND & SALES FORECASTING ANALYSIS
-- ============================================================


-- ============================================================
-- QUERY 01
-- PRODUCT-WISE TOTAL UNITS SOLD
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_units_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    total_units_sold DESC;


-- ============================================================
-- QUERY 02
-- PRODUCT-WISE TOTAL REVENUE
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    total_revenue DESC;


-- ============================================================
-- QUERY 03
-- MONTHLY PRODUCT DEMAND
-- ============================================================

SELECT
    CAST(
        DATE_FORMAT(o.order_date, '%Y-%m-01')
        AS DATE
    ) AS sales_month,
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS monthly_units_sold
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    sales_month,
    p.product_id,
    p.product_name
ORDER BY
    sales_month,
    monthly_units_sold DESC;


-- ============================================================
-- QUERY 04
-- MONTHLY PRODUCT REVENUE
-- ============================================================

SELECT
    CAST(
        DATE_FORMAT(o.order_date, '%Y-%m-01')
        AS DATE
    ) AS sales_month,
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    sales_month,
    p.product_id,
    p.product_name
ORDER BY
    sales_month,
    monthly_revenue DESC;


-- ============================================================
-- QUERY 05
-- PREVIOUS-MONTH PRODUCT DEMAND
-- ============================================================

WITH monthly_product_demand AS
(
    SELECT
        CAST(
            DATE_FORMAT(o.order_date, '%Y-%m-01')
            AS DATE
        ) AS sales_month,
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS monthly_units_sold
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        sales_month,
        p.product_id,
        p.product_name
)

SELECT
    sales_month,
    product_id,
    product_name,
    monthly_units_sold,
    LAG(monthly_units_sold) OVER (
        PARTITION BY product_id
        ORDER BY sales_month
    ) AS previous_month_units
FROM monthly_product_demand
ORDER BY
    product_id,
    sales_month;


-- ============================================================
-- QUERY 06
-- MONTH-OVER-MONTH PRODUCT DEMAND GROWTH
-- ============================================================

WITH monthly_product_demand AS
(
    SELECT
        CAST(
            DATE_FORMAT(o.order_date, '%Y-%m-01')
            AS DATE
        ) AS sales_month,
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS monthly_units_sold
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        sales_month,
        p.product_id,
        p.product_name
),

product_growth AS
(
    SELECT
        sales_month,
        product_id,
        product_name,
        monthly_units_sold,
        LAG(monthly_units_sold) OVER (
            PARTITION BY product_id
            ORDER BY sales_month
        ) AS previous_month_units
    FROM monthly_product_demand
)

SELECT
    sales_month,
    product_id,
    product_name,
    monthly_units_sold,
    previous_month_units,
    monthly_units_sold - previous_month_units
        AS demand_change,
    ROUND(
        (
            (monthly_units_sold - previous_month_units)
            / NULLIF(previous_month_units, 0)
        ) * 100,
        2
    ) AS demand_growth_percentage
FROM product_growth
ORDER BY
    product_id,
    sales_month;


-- ============================================================
-- QUERY 07
-- 3-MONTH MOVING AVERAGE PRODUCT DEMAND
-- ============================================================

WITH monthly_product_demand AS
(
    SELECT
        CAST(
            DATE_FORMAT(o.order_date, '%Y-%m-01')
            AS DATE
        ) AS sales_month,
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS monthly_units_sold
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        sales_month,
        p.product_id,
        p.product_name
)

SELECT
    sales_month,
    product_id,
    product_name,
    monthly_units_sold,
    ROUND(
        AVG(monthly_units_sold) OVER (
            PARTITION BY product_id
            ORDER BY sales_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS three_month_moving_average
FROM monthly_product_demand
ORDER BY
    product_id,
    sales_month;


-- ============================================================
-- QUERY 08
-- PRODUCT DEMAND TREND CLASSIFICATION
-- ============================================================

WITH monthly_product_demand AS
(
    SELECT
        CAST(
            DATE_FORMAT(o.order_date, '%Y-%m-01')
            AS DATE
        ) AS sales_month,
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS monthly_units_sold
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        sales_month,
        p.product_id,
        p.product_name
),

product_growth AS
(
    SELECT
        sales_month,
        product_id,
        product_name,
        monthly_units_sold,
        LAG(monthly_units_sold) OVER (
            PARTITION BY product_id
            ORDER BY sales_month
        ) AS previous_month_units
    FROM monthly_product_demand
)

SELECT
    sales_month,
    product_id,
    product_name,
    monthly_units_sold,
    previous_month_units,
    ROUND(
        (
            (monthly_units_sold - previous_month_units)
            / NULLIF(previous_month_units, 0)
        ) * 100,
        2
    ) AS demand_growth_percentage,
    CASE
        WHEN previous_month_units IS NULL
            THEN 'Baseline Month'
        WHEN (
            (monthly_units_sold - previous_month_units)
            / NULLIF(previous_month_units, 0)
        ) * 100 > 5
            THEN 'Strong Growth'
        WHEN (
            (monthly_units_sold - previous_month_units)
            / NULLIF(previous_month_units, 0)
        ) * 100 > 0
            THEN 'Growth'
        WHEN (
            (monthly_units_sold - previous_month_units)
            / NULLIF(previous_month_units, 0)
        ) * 100 = 0
            THEN 'Stable'
        WHEN (
            (monthly_units_sold - previous_month_units)
            / NULLIF(previous_month_units, 0)
        ) * 100 >= -5
            THEN 'Decline'
        ELSE 'Strong Decline'
    END AS demand_trend
FROM product_growth
ORDER BY
    product_id,
    sales_month;


-- ============================================================
-- QUERY 09
-- PRODUCT DEMAND RANKING
-- ============================================================

WITH product_demand AS
(
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS total_units_sold
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name
)

SELECT
    product_id,
    product_name,
    total_units_sold,
    RANK() OVER (
        ORDER BY total_units_sold DESC
    ) AS demand_rank
FROM product_demand
ORDER BY
    demand_rank;


-- ============================================================
-- QUERY 10
-- PRODUCT REVENUE RANKING
-- ============================================================

WITH product_revenue AS
(
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name
)

SELECT
    product_id,
    product_name,
    total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM product_revenue
ORDER BY
    revenue_rank;


-- ============================================================
-- QUERY 11
-- NEXT-MONTH PRODUCT DEMAND PROJECTION
-- USING RECENT 3-MONTH AVERAGE
-- ============================================================

WITH monthly_product_demand AS
(
    SELECT
        CAST(
            DATE_FORMAT(o.order_date, '%Y-%m-01')
            AS DATE
        ) AS sales_month,
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS monthly_units_sold
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        sales_month,
        p.product_id,
        p.product_name
),

latest_product_month AS
(
    SELECT
        product_id,
        product_name,
        MAX(sales_month) AS latest_month
    FROM monthly_product_demand
    GROUP BY
        product_id,
        product_name
),

recent_demand AS
(
    SELECT
        m.product_id,
        m.product_name,
        m.sales_month,
        m.monthly_units_sold
    FROM monthly_product_demand m
    JOIN latest_product_month l
        ON m.product_id = l.product_id
        AND m.sales_month <= l.latest_month
        AND m.sales_month >= DATE_SUB(
            l.latest_month,
            INTERVAL 2 MONTH
        )
)

SELECT
    product_id,
    product_name,
    ROUND(
        AVG(monthly_units_sold),
        2
    ) AS recent_three_month_average_demand,
    CEIL(
        AVG(monthly_units_sold)
    ) AS projected_next_month_units
FROM recent_demand
GROUP BY
    product_id,
    product_name
ORDER BY
    projected_next_month_units DESC;


-- ============================================================
-- QUERY 12
-- FINAL PRODUCT DEMAND FORECASTING SUMMARY
-- ============================================================

WITH monthly_product_demand AS
(
    SELECT
        CAST(
            DATE_FORMAT(o.order_date, '%Y-%m-01')
            AS DATE
        ) AS sales_month,
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS monthly_units_sold,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        sales_month,
        p.product_id,
        p.product_name
),

latest_month AS
(
    SELECT
        MAX(sales_month) AS latest_sales_month
    FROM monthly_product_demand
),

latest_product_data AS
(
    SELECT
        m.product_id,
        m.product_name,
        m.sales_month,
        m.monthly_units_sold,
        m.monthly_revenue,
        LAG(m.monthly_units_sold) OVER (
            PARTITION BY m.product_id
            ORDER BY m.sales_month
        ) AS previous_month_units
    FROM monthly_product_demand m
),

recent_three_months AS
(
    SELECT
        m.product_id,
        AVG(m.monthly_units_sold) AS recent_three_month_average
    FROM monthly_product_demand m
    CROSS JOIN latest_month l
    WHERE
        m.sales_month >= DATE_SUB(
            l.latest_sales_month,
            INTERVAL 2 MONTH
        )
        AND m.sales_month <= l.latest_sales_month
    GROUP BY
        m.product_id
)

SELECT
    lpd.product_id,
    lpd.product_name,
    lpd.monthly_units_sold AS latest_month_units,
    lpd.previous_month_units,
    lpd.monthly_revenue AS latest_month_revenue,

    ROUND(
        (
            (
                lpd.monthly_units_sold
                - lpd.previous_month_units
            )
            / NULLIF(lpd.previous_month_units, 0)
        ) * 100,
        2
    ) AS latest_demand_growth_percentage,

    ROUND(
        rtm.recent_three_month_average,
        2
    ) AS recent_three_month_average_demand,

    CEIL(
        rtm.recent_three_month_average
    ) AS projected_next_month_units,

    CASE
        WHEN lpd.previous_month_units IS NULL
            THEN 'Baseline Product'
        WHEN lpd.monthly_units_sold >
             lpd.previous_month_units
            THEN 'Increasing Demand'
        WHEN lpd.monthly_units_sold =
             lpd.previous_month_units
            THEN 'Stable Demand'
        ELSE 'Declining Demand'
    END AS demand_status

FROM latest_product_data lpd
JOIN recent_three_months rtm
    ON lpd.product_id = rtm.product_id
CROSS JOIN latest_month lm

WHERE
    lpd.sales_month = lm.latest_sales_month

ORDER BY
    projected_next_month_units DESC;