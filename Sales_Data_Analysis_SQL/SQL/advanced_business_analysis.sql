USE sales_analysis_db;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * p.price) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_sales DESC;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * p.price) AS total_sales,

    CASE
        WHEN SUM(oi.quantity * p.price) >= 50000
            THEN 'High Value'

        WHEN SUM(oi.quantity * p.price) >= 20000
            THEN 'Medium Value'

        ELSE 'Low Value'
    END AS customer_category

FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id

GROUP BY
    c.customer_id,
    c.customer_name

ORDER BY total_sales DESC;

WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_sales
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,
    total_sales,
    DENSE_RANK() OVER (
        ORDER BY total_sales DESC
    ) AS sales_rank
FROM customer_sales;

WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_sales
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
),

ranked_customers AS (
    SELECT
        customer_id,
        customer_name,
        total_sales,
        DENSE_RANK() OVER (
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM customer_sales
)

SELECT *
FROM ranked_customers
WHERE sales_rank <= 3;

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * p.price) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_revenue DESC;

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * p.price) AS total_revenue,

    CASE
        WHEN SUM(oi.quantity * p.price) >= 50000
            THEN 'Top Performer'

        WHEN SUM(oi.quantity * p.price) >= 20000
            THEN 'Average Performer'

        ELSE 'Low Performer'
    END AS performance_category

FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id

GROUP BY
    p.product_id,
    p.product_name

ORDER BY total_revenue DESC;

WITH product_sales AS (
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

    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank

FROM product_sales
ORDER BY revenue_rank;

WITH product_sales AS (
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
),

ranked_products AS (
    SELECT
        product_id,
        product_name,
        total_revenue,

        DENSE_RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM product_sales
)

SELECT *
FROM ranked_products
WHERE revenue_rank <= 3
ORDER BY revenue_rank;

SELECT
    SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id;
    
WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS customer_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
),

total_sales AS (
    SELECT
        SUM(customer_revenue) AS total_revenue
    FROM customer_sales
)

SELECT
    cs.customer_id,
    cs.customer_name,
    cs.customer_revenue,
    ts.total_revenue,

    ROUND(
        (cs.customer_revenue / ts.total_revenue) * 100,
        2
    ) AS revenue_contribution_percent

FROM customer_sales cs
CROSS JOIN total_sales ts
ORDER BY revenue_contribution_percent DESC;

WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS customer_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
),

total_sales AS (
    SELECT
        SUM(customer_revenue) AS total_revenue
    FROM customer_sales
),

ranked_customers AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            ORDER BY customer_revenue DESC
        ) AS revenue_rank
    FROM customer_sales
)

SELECT
    rc.customer_id,
    rc.customer_name,
    rc.customer_revenue,
    ts.total_revenue,

    ROUND(
        (rc.customer_revenue / ts.total_revenue) * 100,
        2
    ) AS revenue_contribution_percent,

    rc.revenue_rank

FROM ranked_customers rc
CROSS JOIN total_sales ts
ORDER BY rc.revenue_rank;

SELECT
    o.order_id,
    o.customer_id,
    SUM(oi.quantity * p.price) AS order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    o.order_id,
    o.customer_id
ORDER BY order_value DESC;

WITH order_sales AS (
    SELECT
        o.order_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.order_id
)

SELECT
    AVG(order_value) AS average_order_value
FROM order_sales;

WITH order_sales AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.order_id,
        o.customer_id
),

average_order AS (
    SELECT
        AVG(order_value) AS average_order_value
    FROM order_sales
)

SELECT
    os.order_id,
    os.customer_id,
    os.order_value,
    ao.average_order_value,

    ROUND(
        os.order_value - ao.average_order_value,
        2
    ) AS difference_from_average

FROM order_sales os
CROSS JOIN average_order ao

WHERE os.order_value > ao.average_order_value

ORDER BY os.order_value DESC;

WITH order_sales AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.order_id,
        o.customer_id
),

average_order AS (
    SELECT
        AVG(order_value) AS average_order_value
    FROM order_sales
)

SELECT
    os.order_id,
    c.customer_name,
    os.order_value,
    ROUND(ao.average_order_value, 2) AS average_order_value,

    ROUND(
        os.order_value - ao.average_order_value,
        2
    ) AS above_average_amount

FROM order_sales os

JOIN customers c
    ON os.customer_id = c.customer_id

CROSS JOIN average_order ao

WHERE os.order_value > ao.average_order_value

ORDER BY os.order_value DESC;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * p.price) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_sales DESC;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * p.price) AS total_sales,

    CASE
        WHEN SUM(oi.quantity * p.price) >= 50000
            THEN 'Premium'

        WHEN SUM(oi.quantity * p.price) >= 20000
            THEN 'Regular'

        ELSE 'Low Value'
    END AS customer_segment

FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id

GROUP BY
    c.customer_id,
    c.customer_name

ORDER BY total_sales DESC;

WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_sales
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,
    total_sales,

    CASE
        WHEN total_sales >= 50000
            THEN 'Premium'

        WHEN total_sales >= 20000
            THEN 'Regular'

        ELSE 'Low Value'
    END AS customer_segment

FROM customer_sales
ORDER BY total_sales DESC;

WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_sales
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
),

segmented_customers AS (
    SELECT
        customer_id,
        customer_name,
        total_sales,

        CASE
            WHEN total_sales >= 50000
                THEN 'Premium'

            WHEN total_sales >= 20000
                THEN 'Regular'

            ELSE 'Low Value'
        END AS customer_segment

    FROM customer_sales
)

SELECT
    customer_segment,
    COUNT(*) AS customer_count
FROM segmented_customers
GROUP BY customer_segment
ORDER BY customer_count DESC;

WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_sales
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
),

segmented_customers AS (
    SELECT
        customer_id,
        customer_name,
        total_sales,

        CASE
            WHEN total_sales >= 50000
                THEN 'Premium'

            WHEN total_sales >= 20000
                THEN 'Regular'

            ELSE 'Low Value'
        END AS customer_segment

    FROM customer_sales
)

SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    SUM(total_sales) AS segment_revenue,
    ROUND(AVG(total_sales), 2) AS average_customer_sales
FROM segmented_customers
GROUP BY customer_segment
ORDER BY segment_revenue DESC;

WITH order_sales AS (
    SELECT
        o.order_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.order_id
)

SELECT *
FROM order_sales
ORDER BY order_value DESC;

WITH order_sales AS (
    SELECT
        o.order_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.order_id
)

SELECT
    (SELECT COUNT(*)
     FROM customers) AS total_customers,

    (SELECT COUNT(*)
     FROM orders) AS total_orders,

    ROUND(SUM(order_value), 2) AS total_revenue,

    ROUND(AVG(order_value), 2) AS average_order_value,

    ROUND(MAX(order_value), 2) AS highest_order_value,

    ROUND(MIN(order_value), 2) AS lowest_order_value

FROM order_sales;

WITH order_sales AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.order_id,
        o.customer_id
),

business_kpis AS (
    SELECT
        SUM(order_value) AS total_revenue,
        COUNT(DISTINCT order_id) AS total_orders
    FROM order_sales
)

SELECT
    total_revenue,
    total_orders,
    ROUND(
        total_revenue / total_orders,
        2
    ) AS average_order_value
FROM business_kpis;

WITH order_sales AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.order_id,
        o.customer_id
)

SELECT
    (SELECT COUNT(*)
     FROM customers) AS total_customers,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(SUM(order_value), 2) AS total_revenue,

    ROUND(AVG(order_value), 2) AS average_order_value,

    ROUND(MAX(order_value), 2) AS highest_order_value,

    ROUND(MIN(order_value), 2) AS lowest_order_value,

    ROUND(
        SUM(order_value) /
        (SELECT COUNT(*)
         FROM customers),
        2
    ) AS revenue_per_customer

FROM order_sales;

SELECT
    DATE(o.order_date) AS sales_date,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY DATE(o.order_date)
ORDER BY sales_date;

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)

SELECT
    sales_month,
    total_orders,
    total_revenue
FROM monthly_sales
ORDER BY total_revenue DESC
LIMIT 1;

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)

SELECT
    sales_month,
    total_orders,
    total_revenue,

    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank

FROM monthly_sales
ORDER BY revenue_rank;

WITH daily_sales AS (
    SELECT
        DATE(o.order_date) AS sales_date,
        SUM(oi.quantity * p.price) AS daily_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY DATE(o.order_date)
)

SELECT
    sales_date,
    daily_revenue,

    SUM(daily_revenue) OVER (
        ORDER BY sales_date
    ) AS cumulative_revenue

FROM daily_sales
ORDER BY sales_date;

WITH order_sales AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.order_id,
        o.customer_id
),

customer_sales AS (
    SELECT
        customer_id,
        SUM(order_value) AS customer_revenue
    FROM order_sales
    GROUP BY customer_id
),

product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity * p.price) AS product_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name
)

SELECT
    (SELECT COUNT(*)
     FROM customers) AS total_customers,

    (SELECT COUNT(*)
     FROM orders) AS total_orders,

    ROUND(SUM(os.order_value), 2) AS total_revenue,

    ROUND(AVG(os.order_value), 2) AS average_order_value,

    ROUND(MAX(os.order_value), 2) AS highest_order_value,

    ROUND(MIN(os.order_value), 2) AS lowest_order_value,

    (
        SELECT customer_id
        FROM customer_sales
        ORDER BY customer_revenue DESC
        LIMIT 1
    ) AS top_customer_id,

    (
        SELECT product_name
        FROM product_sales
        ORDER BY product_revenue DESC
        LIMIT 1
    ) AS top_product

FROM order_sales os;

WITH order_sales AS (
    SELECT
        o.order_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.order_id
),

business_summary AS (
    SELECT
        SUM(order_value) AS total_revenue,
        AVG(order_value) AS average_order_value
    FROM order_sales
)

SELECT
    ROUND(total_revenue, 2) AS total_revenue,

    ROUND(average_order_value, 2) AS average_order_value,

    CASE
        WHEN total_revenue >= 500000
            THEN 'Excellent'

        WHEN total_revenue >= 200000
            THEN 'Good'

        ELSE 'Needs Improvement'
    END AS business_performance

FROM business_summary;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_revenue DESC
LIMIT 5;