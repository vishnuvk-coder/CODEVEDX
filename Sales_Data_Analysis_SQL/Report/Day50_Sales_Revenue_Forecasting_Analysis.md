# 📈 Day 50 — Sales Revenue Forecasting & Future Projection

## 📊 Project: Sales Data Analysis Using SQL

Day 50 focuses on **Sales Revenue Forecasting and Future Projection** using MySQL.

The analysis uses historical sales data to understand monthly revenue performance, revenue growth, moving averages, sales trends, and simple baseline projections for future revenue.

This analysis extends the previous **Sales Growth & Month-over-Month Analysis** and **Sales Order Value & Basket Analysis** performed in the project.

---

## 1. Introduction

Sales forecasting helps businesses estimate future revenue using historical sales information.

In this project, SQL is used to analyze historical monthly sales performance and create simple baseline revenue projections.

The analysis focuses on:

* Monthly revenue
* Monthly order volume
* Monthly units sold
* Previous-month revenue
* Month-over-month revenue growth
* 3-month moving average revenue
* 3-month moving average order volume
* Revenue trend classification
* Historical average revenue
* Next-month revenue projection
* Recent 3-month revenue projection
* Final forecasting summary

The objective is to demonstrate how SQL can support business planning, sales monitoring, and management reporting.

---

# 2. Objectives

The main objectives of Day 50 are:

1. Analyze historical monthly revenue.
2. Analyze monthly order volume.
3. Analyze monthly units sold.
4. Compare current revenue with previous-month revenue.
5. Calculate month-over-month revenue growth.
6. Calculate a 3-month moving average for revenue.
7. Calculate a 3-month moving average for order volume.
8. Classify monthly revenue trends.
9. Calculate average historical monthly revenue.
10. Create a baseline next-month revenue projection using historical average revenue.
11. Create a baseline next-month projection using the recent 3-month average.
12. Compare historical and recent revenue performance.

---

# 3. Database Used

The analysis uses the following MySQL database:

```text
sales_analysis_db
```

---

# 4. Tables Used

The following tables are used for the analysis.

### orders

Used for:

* Order information
* Order dates
* Order volume

### order_items

Used for:

* Order-product relationships
* Product quantities
* Units sold

### products

Used for:

* Product information
* Product prices

---

# 5. Revenue Calculation

Revenue is calculated using the quantity of products sold and the corresponding product price.

### Revenue Formula

```text
Revenue = Quantity × Product Price
```

SQL calculation:

```sql
oi.quantity * p.price
```

The `quantity` is obtained from the `order_items` table, while the `price` is obtained from the `products` table.

This calculation is used throughout the Day 50 revenue analyses.

---

# 6. Analyses Performed

## Query 01 — Monthly Historical Revenue

This analysis calculates the total revenue generated during each available month.

### Business Question

> How much revenue was generated in each month?

### Main SQL Concepts

* `SUM()`
* `JOIN`
* `GROUP BY`
* `DATE_FORMAT()`
* `ORDER BY`

The result provides a monthly historical revenue series that is used as the foundation for later forecasting analysis.

---

## Query 02 — Monthly Order Volume

This analysis calculates the number of unique orders generated during each month.

### Business Question

> How many orders were generated each month?

### Main SQL Concepts

* `COUNT()`
* `COUNT(DISTINCT)`
* `GROUP BY`
* Date-based aggregation

This metric helps understand changes in sales activity independently of revenue.

---

## Query 03 — Monthly Units Sold

This analysis calculates the total number of product units sold during each month.

### Business Question

> How many units were sold each month?

### Main SQL Concepts

* `SUM()`
* `JOIN`
* `GROUP BY`
* Date-based aggregation

Units sold can help identify changes in product demand and sales volume.

---

## Query 04 — Previous-Month Revenue

This analysis retrieves the revenue from the previous available month for comparison with the current month.

### Business Question

> What was the revenue during the previous available month?

The SQL `LAG()` window function is used to retrieve the previous month's revenue.

### SQL Concept

```sql
LAG()
```

This provides the foundation for month-over-month growth analysis.

---

## Query 05 — Month-over-Month Revenue Growth

This analysis compares the current month's revenue with the previous month's revenue.

The query calculates:

* Current monthly revenue
* Previous monthly revenue
* Revenue change
* MoM growth percentage

### Revenue Change

```text
Current Revenue - Previous Revenue
```

### MoM Growth

```text
(Current Revenue - Previous Revenue)
/
Previous Revenue × 100
```

### Business Question

> How much did revenue increase or decrease compared with the previous available month?

---

## Query 06 — 3-Month Moving Average Revenue

This analysis calculates a moving average using the current month and the previous two available months.

### Business Question

> What is the recent average revenue trend?

A moving average helps reduce the effect of short-term fluctuations and provides a smoother view of the revenue trend.

### SQL Concepts

* `AVG()`
* Window functions
* `ROWS BETWEEN`
* `ORDER BY`

---

## Query 07 — 3-Month Moving Average Order Volume

This analysis calculates the moving average of monthly order volume.

### Business Question

> What is the recent average monthly order activity?

The moving average is calculated using the current month and the previous two available months.

This helps compare recent order activity with individual monthly values.

---

## Query 08 — Monthly Revenue Trend Classification

This analysis classifies monthly revenue performance based on month-over-month revenue growth.

### Classification Rules

|               MoM Growth | Classification |
| -----------------------: | -------------- |
|    First available month | Baseline Month |
|             More than 5% | Strong Growth  |
| Greater than 0% up to 5% | Growth         |
|                       0% | Stable         |
|          -5% to below 0% | Decline        |
|            Less than -5% | Strong Decline |

### Business Question

> How can monthly revenue performance be classified based on its change from the previous month?

The `CASE` expression is used to create the business categories.

---

## Query 09 — Average Historical Monthly Revenue

This analysis calculates overall historical revenue statistics.

The query provides:

* Number of historical months
* Average monthly revenue
* Minimum monthly revenue
* Maximum monthly revenue

### Business Question

> What is the overall historical monthly revenue level?

The historical average is later used as one of the baseline projection methods.

---

## Query 10 — Next-Month Revenue Projection Using Historical Average

This analysis creates a simple baseline projection for the next available month.

The projection uses the average revenue across all historical months.

### Business Question

> What would next month's revenue be if it followed the overall historical monthly average?

This is a simple baseline projection rather than an advanced statistical forecast.

---

## Query 11 — Next-Month Revenue Projection Using Recent 3-Month Average

This analysis creates another baseline projection using the average revenue from the latest three available months.

### Business Question

> What would next month's revenue look like if recent average performance continued?

This method gives greater emphasis to recent sales performance compared with the full historical average.

---

## Query 12 — Final Sales Forecasting Summary

The final analysis combines important forecasting metrics into a single summary.

The result includes:

* Latest month
* Latest month revenue
* Previous month revenue
* Latest MoM growth percentage
* Historical average revenue
* Recent 3-month average revenue
* Difference between recent and historical averages
* Forecast trend summary

This provides a compact business-level view of the current sales trend and baseline projection.

---

# 7. SQL Concepts Used

Day 50 demonstrates the following SQL concepts:

* `SELECT`
* `JOIN`
* `SUM()`
* `COUNT()`
* `COUNT(DISTINCT)`
* `AVG()`
* `MIN()`
* `MAX()`
* `GROUP BY`
* `ORDER BY`
* `DATE_FORMAT()`
* `DATE_ADD()`
* `CAST()`
* `LAG()`
* Window Functions
* Moving Averages
* CTEs
* `CASE`
* `ROUND()`
* `NULLIF()`
* Percentage Calculations
* Revenue Calculations
* Trend Classification
* Baseline Forecasting

---

# 8. Business Metrics

| Metric                     | Description                                                        |
| -------------------------- | ------------------------------------------------------------------ |
| Monthly Revenue            | Total revenue generated during a month                             |
| Monthly Orders             | Number of unique orders during a month                             |
| Monthly Units Sold         | Total product quantity sold during a month                         |
| Previous Month Revenue     | Revenue from the previous available month                          |
| Revenue Change             | Difference between current and previous revenue                    |
| MoM Growth %               | Percentage change in revenue from the previous month               |
| 3-Month Moving Average     | Average revenue over the current and previous two available months |
| Historical Average Revenue | Average revenue across all available historical months             |
| Recent 3-Month Average     | Average revenue across the latest three available months           |
| Forecast Difference        | Difference between recent and historical average revenue           |

---

# 9. Business Applications

The analysis can be applied to several business intelligence use cases.

## Revenue Planning

Historical revenue averages can provide a baseline for planning future sales expectations.

## Sales Monitoring

Monthly revenue and order volume can be monitored to identify changes in business performance.

## Sales Trend Analysis

MoM growth and moving averages provide a structured way to analyze revenue trends.

## Management Reporting

The calculated metrics can be included in monthly management reports.

## Revenue Forecasting

Historical and recent averages can be used as simple baseline projections.

## Business Intelligence

The results can later be connected to Power BI or other business intelligence tools.

## Performance Monitoring

Businesses can compare recent revenue performance against historical performance.

---

# 10. Forecasting Methods Used

Two simple baseline projection methods were used in Day 50.

## Method 1 — Historical Average

The average revenue across all available historical months is used as the projected revenue for the next available month.

### Concept

```text
Projected Revenue = Historical Average Monthly Revenue
```

This method provides a general baseline based on the complete available history.

---

## Method 2 — Recent 3-Month Average

The average revenue of the latest three available months is used as the projected revenue for the next available month.

### Concept

```text
Projected Revenue = Recent 3-Month Average Revenue
```

This method gives more emphasis to recent sales performance.

---

# 11. Forecasting Limitation

The projections created in this analysis are **simple SQL-based baseline estimates**.

They should not be considered advanced statistical or machine-learning forecasts.

The calculations do not account for factors such as:

* Seasonality
* Holidays
* Marketing campaigns
* Economic conditions
* Product launches
* Customer acquisition
* Customer churn
* Price changes
* External market conditions
* Competitor activity
* Statistical forecasting models
* Machine learning models

Therefore, the projections are best treated as a starting point for business analysis and planning.

More advanced forecasting could later be performed using:

* Python
* Time-series models
* Regression
* Statistical forecasting
* Machine learning
* Power BI forecasting features

---

# 12. Project Files

```text
SQL/
└── sales_revenue_forecasting_analysis.sql

Report/
└── Day50_Sales_Revenue_Forecasting_Analysis.md

Screenshots/
└── Day 50/
    ├── Query_01.png
    ├── Query_02.png
    ├── Query_03.png
    ├── Query_04.png
    ├── Query_05.png
    ├── Query_06.png
    ├── Query_07.png
    ├── Query_08.png
    ├── Query_09.png
    ├── Query_10.png
    ├── Query_11.png
    └── Query_12.png
```

---

# 13. Key Learning Outcomes

After completing Day 50, the following SQL and business analysis skills were practiced:

* Monthly sales aggregation
* Revenue analysis
* Order volume analysis
* Units sold analysis
* Previous-period comparison
* Month-over-month growth analysis
* Window functions
* `LAG()`
* Moving averages
* Common Table Expressions
* Trend classification
* Business KPI calculation
* Baseline revenue forecasting
* Future projection
* Business reporting

---

# 14. Day 50 Achievement

## ✅ Sales Revenue Forecasting & Future Projection Completed

Day 50 extended the project from historical sales analysis into basic future revenue projection.

The analysis demonstrates how SQL can be used to:

* Understand historical sales performance
* Compare monthly revenue
* Identify revenue growth and decline
* Smooth sales trends using moving averages
* Classify revenue performance
* Calculate historical benchmarks
* Create simple baseline revenue projections

---

# 15. Conclusion

Day 50 demonstrates the use of SQL for **sales revenue forecasting and future projection**.

By combining historical revenue analysis, month-over-month growth, moving averages, trend classification, and baseline projection techniques, the project now covers another important area of business intelligence.

The analysis provides a foundation for more advanced forecasting work using statistical methods, Python, machine learning, or dedicated BI forecasting tools.

---

# 📊 Day 50 Status

**Status: 🟢 Completed**

**Primary Focus:** Sales Revenue Forecasting & Future Projection

**Database:** MySQL

**Analysis Type:** SQL Business Analysis

**SQL Level:** Advanced Business Analysis
