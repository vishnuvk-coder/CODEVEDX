USE sales_analysis_db;

-- ============================================
-- DAY 12: SQL WINDOW FUNCTIONS
-- ============================================


-- 1. ROW_NUMBER()
-- Assign a unique row number to each order
SELECT
    order_id,
    customer_id,
    order_date,
    total_amount,
    ROW_NUMBER() OVER (
        ORDER BY total_amount DESC
    ) AS order_rank
FROM orders;


-- 2. RANK()
-- Rank orders based on total amount
SELECT
    order_id,
    customer_id,
    total_amount,
    RANK() OVER (
        ORDER BY total_amount DESC
    ) AS sales_rank
FROM orders;


-- 3. DENSE_RANK()
-- Rank orders without gaps
SELECT
    order_id,
    customer_id,
    total_amount,
    DENSE_RANK() OVER (
        ORDER BY total_amount DESC
    ) AS dense_sales_rank
FROM orders;


-- 4. PARTITION BY
-- Rank orders separately for each customer
SELECT
    customer_id,
    order_id,
    order_date,
    total_amount,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY total_amount DESC
    ) AS customer_order_rank
FROM orders;


-- 5. Running Total
SELECT
    order_id,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        ORDER BY order_date
    ) AS running_total
FROM orders;


-- 6. Overall Average Order Value
SELECT
    order_id,
    customer_id,
    total_amount,
    AVG(total_amount) OVER () AS average_order_value
FROM orders;


-- 7. Customer Average Order Value
SELECT
    customer_id,
    order_id,
    total_amount,
    AVG(total_amount) OVER (
        PARTITION BY customer_id
    ) AS customer_average_order
FROM orders;


-- 8. LAG()
-- Compare each order with the previous order
SELECT
    order_id,
    order_date,
    total_amount,
    LAG(total_amount) OVER (
        ORDER BY order_date
    ) AS previous_order_amount
FROM orders;


-- 9. LEAD()
-- Compare each order with the next order
SELECT
    order_id,
    order_date,
    total_amount,
    LEAD(total_amount) OVER (
        ORDER BY order_date
    ) AS next_order_amount
FROM orders;


-- 10. Difference from Previous Order
SELECT
    order_id,
    order_date,
    total_amount,
    LAG(total_amount) OVER (
        ORDER BY order_date
    ) AS previous_order_amount,
    
    total_amount -
    LAG(total_amount) OVER (
        ORDER BY order_date
    ) AS difference_from_previous
FROM orders;


-- 11. Customer Sales Ranking
SELECT
    customer_id,
    SUM(total_amount) AS total_sales,
    RANK() OVER (
        ORDER BY SUM(total_amount) DESC
    ) AS customer_rank
FROM orders
GROUP BY customer_id;


-- 12. Monthly/Date Sales Running Total
SELECT
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales
FROM orders;


-- 13. Top Orders
-- Identify the highest-value orders
SELECT *
FROM (
    SELECT
        order_id,
        customer_id,
        total_amount,
        RANK() OVER (
            ORDER BY total_amount DESC
        ) AS sales_rank
    FROM orders
) ranked_orders
WHERE sales_rank <= 5;


-- 14. Customer Order Ranking
SELECT
    customer_id,
    order_id,
    total_amount,
    RANK() OVER (
        PARTITION BY customer_id
        ORDER BY total_amount DESC
    ) AS customer_order_rank
FROM orders;


-- 15. Business Analysis
-- Compare each order with the customer's average order value
SELECT
    order_id,
    customer_id,
    total_amount,
    AVG(total_amount) OVER (
        PARTITION BY customer_id
    ) AS customer_average,
    
    total_amount -
    AVG(total_amount) OVER (
        PARTITION BY customer_id
    ) AS difference_from_customer_average
FROM orders;