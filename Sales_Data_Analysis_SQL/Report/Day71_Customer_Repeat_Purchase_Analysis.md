# Day 71 — Customer Purchase Trends and Repeat Purchase Analysis Using SQL

## 1. Project Overview

This project analyzes customer purchasing behavior using MySQL 8.0. It focuses on customer order frequency, repeat purchases, purchase intervals, monthly activity, and revenue contribution.

## 2. Objectives

- Measure the number of orders placed by each customer.
- Identify one-time and repeat customers.
- Calculate the overall repeat-purchase rate.
- Segment customers by purchase frequency.
- Calculate the number of days between consecutive orders.
- Analyze customers who place multiple orders in the same month.
- Rank customers by total sales revenue.

## 3. SQL Concepts Used

- `GROUP BY` and aggregate functions
- `CASE` expressions
- Common Table Expressions (CTEs)
- `LAG()` window function
- `DENSE_RANK()` window function
- `DATEDIFF()`
- `DATE_FORMAT()`
- `NULLIF()` and `COALESCE()`
- Joins and revenue calculations

## 4. Analysis Performed

### Customer Purchase Summary
Measures customer order count, units purchased, total revenue, and average order value.

### One-Time vs Repeat Customers
Classifies customers as one-time buyers or repeat buyers based on their total number of orders.

### Repeat-Purchase Rate
Calculates the percentage of customers with more than one order.

### Purchase Frequency Segmentation
Groups customers into one-order, 2–3-order, 4–5-order, and 6-or-more-order segments.

### Purchase Interval Analysis
Uses `LAG()` and `DATEDIFF()` to calculate the number of days between consecutive orders.

### Monthly Repeat Customer Trends
Measures the number of active customers and the percentage who place multiple orders within the same calendar month.

### Customer Revenue Ranking
Ranks customers according to total revenue generated.

## 5. Revenue Calculation

Revenue is calculated using the product price and quantity:

`Revenue = SUM(order_items.quantity * products.price)`

The analysis uses the existing `orders`, `order_items`, and `products` tables.

## 6. Business Applications

The analysis can help businesses:

- Identify customers who may benefit from retention campaigns.
- Understand purchasing frequency.
- Explore typical gaps between orders.
- Identify high-revenue customers.
- Measure repeat ordering activity over time.
- Plan customer engagement and promotional campaigns.

## 7. Limitations

- Repeat-customer classification is based on all available orders in the database.
- The monthly repeat-customer rate measures multiple orders within the same month. It does not measure all customers returning from earlier months.
- Purchase intervals depend on valid order dates.
- Revenue uses product prices currently stored in the products table; historical prices may differ from the prices at the time of an order.
- Results describe the available dataset and should not be treated as proof of future customer behavior.

## 8. Project Files

- `SQL/customer_repeat_purchase_analysis.sql`
- `Report/Day71_Customer_Repeat_Purchase_Analysis.md`
- `Screenshots/Day 71/`

## 9. Conclusion

Day 71 applies SQL aggregation, CTEs, date functions, and window functions to understand repeat purchasing and customer revenue contribution. These analyses provide a foundation for customer retention, purchasing-frequency, and lifecycle analytics.
