# 📊 Day 69 — Sales Forecasting & Trend Projection Using SQL

Day 69 focuses on **Sales Forecasting & Trend Projection using MySQL**.

This analysis evaluates historical monthly sales revenue, order activity, units sold, revenue growth, moving averages, revenue trends, and a baseline projection for the next month.

## 🎯 Objective

The objective is to understand historical sales performance and use SQL-based time-series analysis to support basic sales planning and business decision-making.

The analysis focuses on:

* Monthly sales revenue
* Monthly order count
* Monthly units sold
* Average order value
* Previous-month revenue comparison
* Month-over-month revenue change
* Month-over-month growth percentage
* Three-month moving average
* Six-month moving average
* Monthly revenue trend classification
* Highest-revenue month
* Lowest-revenue month
* Revenue volatility
* Baseline next-month revenue projection
* Final sales forecasting summary

## 🔍 Key Analyses

1. Monthly Sales Revenue
2. Monthly Order Count
3. Monthly Units Sold
4. Average Order Value by Month
5. Previous-Month Revenue
6. Month-over-Month Revenue Change
7. Month-over-Month Revenue Growth Percentage
8. Three-Month Moving Average Revenue
9. Six-Month Moving Average Revenue
10. Monthly Revenue Trend Classification
11. Highest-Revenue Month
12. Lowest-Revenue Month
13. Revenue Volatility Overview
14. Baseline Next-Month Revenue Projection
15. Final Sales Forecasting Summary

## 🧠 SQL Techniques Used

* `SELECT`
* `SUM()`
* `COUNT()`
* `AVG()`
* `MIN()` and `MAX()`
* `ROUND()`
* `NULLIF()`
* `CASE`
* `JOIN`
* Common Table Expressions (CTEs)
* `GROUP BY`
* `ORDER BY`
* `DATE_FORMAT()`
* `DATE_ADD()`
* `STR_TO_DATE()`
* `LAG()`
* `RANK()`
* `ROW_NUMBER()`
* Window Functions
* Moving Average Analysis
* Month-over-Month Growth Analysis
* Revenue Trend Classification
* Standard Deviation Analysis
* Baseline Sales Projection
* KPI Analysis

## 📅 Monthly Sales Revenue Analysis

Monthly revenue was calculated by multiplying the quantity of each product sold by its product price and aggregating the result by month.

**Revenue formula:**

`Total Revenue = SUM(quantity × product price)`

This analysis provides an overview of historical monthly sales performance and helps identify changes in revenue over time.

## 🛒 Monthly Order Count

The number of distinct orders was calculated for each month.

This KPI helps measure changes in order activity and provides context for interpreting monthly revenue changes.

A revenue increase may be associated with more orders, higher average order value, or a combination of both.

## 📦 Monthly Units Sold

The total quantity of products sold was calculated for each month.

This analysis helps evaluate sales volume and identify periods of higher or lower product demand.

## 💰 Average Order Value

Average Order Value (AOV) measures the average revenue generated per order.

**Formula:**

`AOV = Total Revenue / Total Orders`

The analysis calculates revenue for each order before taking the monthly average. This helps compare order values across different months.

## 🔄 Previous-Month Revenue Comparison

The `LAG()` window function retrieves the revenue value from the previous available monthly record.

This makes it possible to compare the current month's revenue with the preceding record and identify changes in sales performance.

The first available month has no previous record for comparison.

## 📈 Month-over-Month Revenue Change

The absolute revenue change is calculated by subtracting previous revenue from current revenue.

**Formula:**

`Revenue Change = Current Revenue − Previous Revenue`

* A positive value indicates revenue increased.
* A negative value indicates revenue decreased.
* Zero indicates revenue remained unchanged.

## 📊 Month-over-Month Revenue Growth

The percentage change in revenue is calculated to make comparisons easier across months with different revenue levels.

**Formula:**

`Growth % = ((Current Revenue − Previous Revenue) / Previous Revenue) × 100`

`NULLIF()` is used to prevent division by zero.

A positive growth percentage indicates an increase in revenue, while a negative percentage indicates a decrease. When previous revenue is zero, the growth percentage is undefined and is returned as `NULL`.

## 📉 Three-Month Moving Average

The three-month moving average calculates the average revenue across the current monthly record and the two preceding available monthly records.

This smooths some short-term fluctuations and helps reveal the general direction of sales performance.

The earliest records use fewer than three months when sufficient history is not yet available.

## 📉 Six-Month Moving Average

The six-month moving average calculates the average revenue across the current monthly record and up to five preceding available monthly records.

It provides a broader view of revenue performance than the three-month moving average.

The results depend on the amount of historical data available.

**Important:** Both moving averages use available monthly records. They do not automatically create missing calendar months with zero revenue.

## 📈 Monthly Revenue Trend Classification

Monthly revenue was classified by comparing it with the previous available monthly record.

| Condition                    | Classification    |
| ---------------------------- | ----------------- |
| Current revenue is higher    | Growing           |
| Current revenue is lower     | Declining         |
| Current revenue is unchanged | Stable            |
| No previous record exists    | No Previous Month |

This is a simple rule-based classification of historical revenue changes, not a statistical trend test.

## 🏆 Highest-Revenue Month

The `RANK()` window function identifies the month or months with the highest recorded revenue.

This helps locate periods of strong historical sales performance.

## 📉 Lowest-Revenue Month

The analysis also identifies the month or months with the lowest recorded revenue.

This can help businesses investigate periods of weaker sales activity and consider whether further analysis is needed.

The lowest month in the dataset is not necessarily evidence of a business problem; seasonal effects and incomplete data may influence the result.

## 📊 Revenue Volatility Overview

Revenue volatility was summarized using:

* Number of months with recorded sales
* Average monthly revenue
* Minimum monthly revenue
* Maximum monthly revenue
* Population standard deviation of monthly revenue

Standard deviation describes how widely monthly revenue values vary around their average.

A larger standard deviation indicates greater variation in the observed revenue values. It does not, by itself, explain the cause of that variation.

## 🔮 Baseline Next-Month Revenue Projection

A simple baseline projection was calculated using the average revenue of the three most recent available monthly records.

**Formula:**

`Projected Revenue = Average Revenue of the Last 3 Available Months`

The SQL uses `ROW_NUMBER()` to identify the three latest available monthly records and calculates their average.

The query returns a projection only when at least three monthly records are available.

### Business Purpose

This baseline can support:

* Basic sales planning
* Preliminary revenue expectations
* Budget discussions
* Comparison with actual future revenue
* Further forecasting analysis

### Forecasting Limitation

This is a simple moving-average baseline, not a machine-learning model or a validated forecasting system.

It assumes recent average revenue provides a useful reference for the next month. It does not explicitly model seasonality, long-term trends, promotions, market conditions, or other external factors.

The projected value should therefore be treated as a reference estimate, not a guaranteed outcome.

## 📊 KPI Framework

| KPI                         | Business Purpose                                |
| --------------------------- | ----------------------------------------------- |
| Monthly Revenue             | Measures sales value over time                  |
| Monthly Orders              | Measures order activity                         |
| Units Sold                  | Measures product sales volume                   |
| Average Order Value         | Measures average revenue per order              |
| Revenue Change              | Measures absolute month-to-month change         |
| Growth Percentage           | Measures relative revenue change                |
| Three-Month Moving Average  | Highlights shorter-term revenue patterns        |
| Six-Month Moving Average    | Highlights broader revenue patterns             |
| Highest-Revenue Month       | Identifies the strongest observed month         |
| Lowest-Revenue Month        | Identifies the weakest observed month           |
| Revenue Standard Deviation  | Measures variation in monthly revenue           |
| Baseline Revenue Projection | Provides a simple next-month reference estimate |

## 💼 Business Applications

Sales forecasting and trend analysis can support:

* Revenue planning
* Sales performance monitoring
* Budget preparation
* Business reporting
* Inventory planning
* Demand-planning discussions
* Monthly KPI tracking
* Identification of strong and weak sales periods
* Historical performance comparisons
* Preliminary sales forecasting

These applications describe potential uses of the analysis; they do not establish that a specific business outcome was achieved.

## ⚠️ Methodology Limitations

* The analysis uses the historical sales data available in the database.
* Revenue is calculated from product quantity and product price.
* The analysis assumes the available order and product records are suitable for calculating sales revenue.
* Months without orders are not automatically generated in the monthly results.
* Moving averages operate on available monthly records.
* The first available month has no previous-month comparison.
* Growth percentage is undefined when previous revenue is zero.
* The baseline projection requires at least three monthly records.
* The projection does not explicitly model seasonality or external business factors.
* Historical trends do not guarantee future sales performance.
* This is SQL-based business analysis, not machine-learning forecasting.

## 📁 Project Files

```text
SQL/
└── sales_forecasting_trend_projection.sql

Report/
└── Day69_Sales_Forecasting_Trend_Projection.md

Screenshots/
└── Day 69/
```

## 🏆 Day 69 Achievement

**Sales Forecasting & Trend Projection using SQL** is the focus of Day 69.

The planned analysis covers monthly revenue, order activity, units sold, average order value, revenue growth, moving averages, trend classification, revenue variability, and a baseline next-month projection.

**69-Day SQL Business Analysis Journey — In Progress. 🚀**

**Day 69 milestone should be marked completed after the SQL queries have been executed, the results reviewed, the screenshots captured, and the project files committed and pushed to GitHub.**
