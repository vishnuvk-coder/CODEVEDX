# 📈 Day 48 — Sales Growth & Month-over-Month Performance Analysis

## 📌 Introduction

Day 48 focuses on **Sales Growth and Month-over-Month (MoM) Performance Analysis** using MySQL.

The objective is to analyze how sales performance changes over time by examining **monthly revenue, order volume, units sold, revenue changes, growth percentages, cumulative revenue, and monthly performance trends**.

This analysis builds on the sales KPI analysis completed in Day 47 and introduces advanced SQL techniques such as **CTEs, Window Functions, `LAG()`, `RANK()`, `SUM() OVER()`, percentage calculations, and `CASE` statements**.

The analysis is designed to simulate a real-world business reporting scenario where a Data Analyst needs to identify sales growth, declining periods, and overall revenue trends.

---

## 🎯 Objectives

The main objectives of Day 48 are:

* Analyze monthly sales revenue.
* Measure monthly order volume.
* Calculate monthly units sold.
* Compare current-month revenue with previous-month revenue.
* Calculate month-over-month revenue changes.
* Calculate month-over-month growth percentages.
* Classify monthly sales performance.
* Calculate cumulative revenue over time.
* Rank months based on revenue.
* Identify the month with the highest revenue growth.
* Identify the month with the largest revenue decline.
* Create a final monthly sales growth summary.

---

## 🗄️ Database Used

```text
Database: sales_analysis_db
Database System: MySQL
```

---

## 📋 Tables Used

### 1. `orders`

Used for:

* Order information
* Order dates
* Order counts
* Monthly sales grouping

Important columns:

```text
order_id
customer_id
order_date
```

### 2. `order_items`

Used for:

* Quantity sold
* Product-level sales quantities

Important columns:

```text
order_id
product_id
quantity
```

### 3. `products`

Used for:

* Product information
* Product prices

Important columns:

```text
product_id
product_name
price
```

---

## 💰 Important Revenue Calculation

Revenue is calculated using the quantity sold multiplied by the product price:

```sql
oi.quantity * p.price
```

The required relationship is:

```text
orders
   │
   │ order_id
   ▼
order_items
   │
   │ product_id
   ▼
products
```

This allows the analysis to calculate revenue from the available database structure.

---

# 📊 Analyses Performed

## 1. Monthly Revenue

The first analysis calculates the total revenue generated during each month.

### Business Question

> How much revenue was generated in each month?

### SQL Concept

* `DATE_FORMAT()`
* `SUM()`
* `GROUP BY`
* `JOIN`

The result provides a month-by-month revenue overview.

---

## 2. Monthly Order Count

This analysis calculates the number of orders placed during each month.

### Business Question

> How many orders were generated each month?

### SQL Concept

```sql
COUNT(DISTINCT o.order_id)
```

This ensures that individual orders are counted rather than individual order-item rows.

---

## 3. Monthly Units Sold

This analysis calculates the total number of product units sold in each month.

### Business Question

> How many units were sold each month?

### SQL Concept

```sql
SUM(oi.quantity)
```

This helps measure sales volume independently of revenue.

---

## 4. Monthly Revenue with Previous Month Revenue

This analysis compares monthly revenue with the revenue generated in the previous month.

The SQL uses the `LAG()` window function.

### Business Question

> What was the revenue in the previous month?

### Important SQL Concept

```sql
LAG(monthly_revenue) OVER (
    ORDER BY sales_month
)
```

`LAG()` allows the current row to access a value from the previous row.

For monthly sales analysis, this makes it possible to compare:

```text
Current Month
      ↓
Previous Month
```

---

## 5. Month-over-Month Revenue Change

This analysis calculates the absolute change in revenue between the current month and previous month.

### Formula

```text
Revenue Change =
Current Month Revenue - Previous Month Revenue
```

### Business Question

> How much did revenue increase or decrease compared with the previous month?

A positive value indicates an increase, while a negative value indicates a decrease.

---

## 6. Month-over-Month Revenue Growth Percentage

This analysis calculates the percentage change in revenue compared with the previous month.

### Formula

```text
MoM Growth % =
(Current Month Revenue - Previous Month Revenue)
÷ Previous Month Revenue
× 100
```

The SQL uses:

```sql
NULLIF(previous_month_revenue, 0)
```

to avoid division-by-zero errors.

### Business Question

> What percentage did revenue grow or decline compared with the previous month?

This is one of the key performance metrics in the Day 48 analysis.

---

## 7. Monthly Sales Growth Classification

This analysis classifies monthly performance based on the comparison with the previous month.

The categories are:

```text
First Recorded Month
Revenue Increased
Revenue Decreased
Revenue Unchanged
```

### Business Question

> Did sales performance improve or decline compared with the previous month?

### SQL Concept

```sql
CASE
    WHEN previous_month_revenue IS NULL
        THEN 'First Recorded Month'
    WHEN monthly_revenue > previous_month_revenue
        THEN 'Revenue Increased'
    WHEN monthly_revenue < previous_month_revenue
        THEN 'Revenue Decreased'
    ELSE 'Revenue Unchanged'
END
```

This converts numerical comparisons into business-friendly categories.

---

## 8. Cumulative Revenue Over Time

This analysis calculates the running total of revenue from the beginning of the available sales period.

### Business Question

> How much cumulative revenue has been generated over time?

### SQL Concept

```sql
SUM(monthly_revenue) OVER (
    ORDER BY sales_month
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)
```

The cumulative value increases as each month is added.

Example structure:

```text
Month 1 → Revenue
Month 2 → Month 1 + Month 2
Month 3 → Month 1 + Month 2 + Month 3
...
```

This is useful for understanding the overall accumulation of sales revenue.

---

## 9. Monthly Revenue Ranking

This analysis ranks all months according to their revenue.

### Business Question

> Which months generated the highest revenue?

### SQL Concept

```sql
RANK() OVER (
    ORDER BY monthly_revenue DESC
)
```

The month with the highest revenue receives the highest ranking position.

This allows monthly performance to be compared using a ranked structure.

---

## 10. Highest Revenue Growth Month

This analysis identifies the month with the highest month-over-month revenue growth percentage.

### Business Question

> Which month recorded the highest revenue growth compared with the previous month?

The analysis:

1. Calculates monthly revenue.
2. Retrieves the previous month's revenue.
3. Calculates MoM growth percentage.
4. Sorts the results in descending order.
5. Returns the highest-growth month.

### SQL Concepts

* CTE
* `LAG()`
* Percentage calculation
* `ORDER BY`
* `LIMIT`

---

## 11. Largest Revenue Decline Month

This analysis identifies the month with the largest negative month-over-month revenue change.

### Business Question

> Which month experienced the largest revenue decline compared with the previous month?

The analysis sorts MoM growth percentages in ascending order and returns the lowest value.

This can help businesses investigate periods of declining sales performance.

---

## 12. Final Monthly Sales Growth Summary

The final analysis combines the main Day 48 metrics into one monthly performance dataset.

The summary contains:

```text
Sales Month
Monthly Revenue
Total Orders
Total Units Sold
Previous Month Revenue
Revenue Change
MoM Growth Percentage
Performance Status
```

### Business Question

> What is the complete monthly sales performance picture?

The final output provides a consolidated view of sales growth and decline.

---

# 🧠 Advanced SQL Concepts Used

Day 48 introduced and practiced several important SQL techniques.

### 1. Common Table Expressions — CTE

Example:

```sql
WITH monthly_sales AS (
    ...
)
```

CTEs make complex analytical queries easier to organize and understand.

---

### 2. `LAG()` Window Function

```sql
LAG(monthly_revenue) OVER (
    ORDER BY sales_month
)
```

Used to retrieve the previous month's revenue.

This is especially useful for:

* MoM analysis
* Previous-period comparison
* Trend analysis
* Growth calculations

---

### 3. `RANK()`

```sql
RANK() OVER (
    ORDER BY monthly_revenue DESC
)
```

Used to rank months according to revenue.

---

### 4. Running Total

```sql
SUM(monthly_revenue) OVER (
    ORDER BY sales_month
)
```

Used to calculate cumulative revenue.

---

### 5. `CASE`

Used to convert numerical comparisons into business categories:

```text
Growth
Decline
Stable
First Recorded Month
```

---

### 6. `NULLIF()`

Used to safely handle division:

```sql
NULLIF(previous_month_revenue, 0)
```

This prevents division-by-zero errors during percentage calculations.

---

### 7. Date Formatting

```sql
DATE_FORMAT(o.order_date, '%Y-%m')
```

Used to group sales data by month.

---

# 📈 Key Business Metrics

Day 48 focuses on these important sales metrics:

| Metric                 | Meaning                                       |
| ---------------------- | --------------------------------------------- |
| Monthly Revenue        | Revenue generated during a month              |
| Monthly Orders         | Number of orders during a month               |
| Monthly Units Sold     | Total units sold during a month               |
| Previous Month Revenue | Revenue generated in the previous month       |
| Revenue Change         | Absolute increase or decrease                 |
| MoM Growth %           | Percentage increase or decrease               |
| Cumulative Revenue     | Total revenue accumulated over time           |
| Revenue Rank           | Ranking of months by revenue                  |
| Growth Status          | Increase, decrease, unchanged, or first month |

---

# 💼 Business Applications

The analysis can support several real-world business decisions.

### 📊 Sales Performance Monitoring

Management can monitor monthly revenue and identify changes in sales performance.

### 📈 Growth Tracking

MoM growth percentages can be used to track short-term sales growth.

### ⚠️ Decline Detection

Large negative growth percentages can highlight months that require further investigation.

### 💰 Revenue Planning

Cumulative revenue helps businesses understand the progression of total sales.

### 📅 Monthly Reporting

The final summary can serve as a foundation for monthly sales reports and dashboards.

### 📊 Business Intelligence

The results can be integrated into BI dashboards for monitoring sales trends.

---

# 🔍 Business Questions Answered

Day 48 answers the following questions:

1. What is the monthly revenue?
2. How many orders are generated each month?
3. How many units are sold each month?
4. What was the previous month's revenue?
5. How much did revenue change?
6. What is the month-over-month growth percentage?
7. Did revenue increase or decrease?
8. What is the cumulative revenue?
9. Which months have the highest revenue?
10. Which month has the highest revenue growth?
11. Which month has the largest revenue decline?
12. What is the overall monthly sales performance?

---

# 📁 Project Files

```text
Sales_Data_Analysis_SQL/
│
├── SQL/
│   └── sales_growth_mom_analysis.sql
│
├── Report/
│   └── Day48_Sales_Growth_MOM_Analysis.md
│
├── Screenshots/
│   └── Day 48/
│       ├── Query_01.png
│       ├── Query_02.png
│       ├── Query_03.png
│       ├── Query_04.png
│       ├── Query_05.png
│       ├── Query_06.png
│       ├── Query_07.png
│       ├── Query_08.png
│       ├── Query_09.png
│       ├── Query_10.png
│       ├── Query_11.png
│       └── Query_12.png
│
└── README.md
```

---

# 🎓 Key Learning Outcomes

After completing Day 48, the following SQL and analytical skills were practiced:

* Monthly sales aggregation
* Revenue analysis
* Order-volume analysis
* Units-sold analysis
* Previous-period comparison
* `LAG()` window function
* `RANK()` window function
* Running totals
* CTE-based analysis
* MoM growth calculation
* Percentage calculations
* `CASE`-based classification
* Division-by-zero handling
* Time-series sales analysis
* Business performance reporting

---

# 🏆 Day 48 Achievement

### Sales Growth & Month-over-Month Analysis Completed

Day 48 extends the project from basic sales KPIs into **time-based sales performance analysis**.

The project now includes techniques for comparing monthly performance, calculating growth rates, identifying increases and declines, ranking sales periods, and tracking cumulative revenue.

This represents an important step toward practical **Data Analyst and Business Intelligence reporting**.

---

# 📊 Project Progress

```text
SQL Fundamentals
       ↓
JOINs & Aggregations
       ↓
Advanced SQL
       ↓
Window Functions & CTEs
       ↓
Customer Analytics
       ↓
Product Analytics
       ↓
Profitability Analysis
       ↓
Payment Analysis
       ↓
Data Quality Analysis
       ↓
Sales KPI Analysis
       ↓
Sales Growth & MoM Analysis
```

---

# ✅ Conclusion

Day 48 successfully applies SQL to **sales growth and monthly performance analysis**.

The analysis demonstrates how SQL can be used not only to retrieve business data but also to perform meaningful time-series comparisons.

By using `LAG()`, CTEs, window functions, ranking, cumulative calculations, and growth percentages, the project moves closer to real-world sales reporting and business intelligence workflows.

The Day 48 analysis provides a strong foundation for future work involving **advanced sales analytics, trend analysis, customer-product performance, forecasting, and business dashboards**.

---

## 🚀 Next Step

**Day 48 completed → Continue to Day 49**

The next analysis can build on this work by moving into another advanced business-analysis problem without repeating the Day 47 KPI or Day 48 MoM analysis.
