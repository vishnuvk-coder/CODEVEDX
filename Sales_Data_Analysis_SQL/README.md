# 📊 Sales Data Analysis Using SQL

A hands-on SQL portfolio project focused on **relational database design, advanced SQL analytics, query optimization, customer analytics, product analytics, business intelligence, customer retention, cohort analysis, customer lifecycle analysis, repeat purchase analysis, purchase frequency analysis, payment analysis, payment performance analysis, payment risk analysis, payment-method trend and reliability analysis, and sales forecasting using MySQL.**

This project simulates a real-world sales management system and demonstrates practical SQL skills relevant to **Data Analyst, Business Analyst, SQL Developer, Reporting Analyst, and MIS Analyst roles.**

---

# 🚀 Project Overview

This project follows a structured, end-to-end SQL data-analysis workflow, progressing from database fundamentals to advanced analytical and business-oriented SQL.

The primary objective is to transform raw sales data into meaningful business insights using SQL.

The project covers:

* Database design and SQL fundamentals
* Data manipulation and querying
* JOIN operations and aggregation
* Advanced SQL and query optimization
* Customer and product analytics
* Revenue and business KPI analysis
* Customer segmentation and RFM analysis
* Customer retention, churn, and cohort analysis
* Customer lifecycle and repeat purchase analysis
* Purchase frequency and customer lifetime value
* Product purchase behavior and cross-selling
* Basket size and order value analysis
* Revenue and product demand forecasting
* Customer repeat purchase prediction and purchase propensity analysis
* Customer purchase value and value segmentation
* Customer revenue contribution and ranking
* Revenue concentration, Pareto, and 80/20 analysis
* Customer revenue decile, quartile, quintile, and ABC analysis
* ABC segment performance and business-priority analysis
* Payment performance, status, and method analysis
* Customer payment behavior and risk classification
* Payment success, failure, and pending-rate analysis
* Payment method preference and customer adoption
* Payment method trend, growth, and reliability analysis
* Monthly sales revenue and order analysis
* Month-over-month revenue growth analysis
* Three-month and six-month moving averages
* Revenue trend classification and volatility analysis
* Baseline next-month revenue projection
* Business intelligence and business reporting

---

# 📊 Day 67 — Customer Payment Method Performance Analysis

Day 67 focused on **Customer Payment Method Performance Analysis** using MySQL.

## 🎯 Objective

Understand how different payment methods perform across the sales system and identify payment methods with stronger or weaker transaction performance.

## 🔍 Key Analyses

* Payment Method Transaction Count
* Payment Method Unique Orders
* Payment Method Customer Count
* Payment Method Success Count
* Payment Method Failure Count
* Payment Method Pending Count
* Payment Method Success Rate
* Payment Method Failure Rate
* Payment Method Pending Rate
* Customer Count by Payment Method
* Most Preferred Payment Method
* Best Performing Payment Method
* Highest Failure Payment Method
* Payment Method Risk Classification
* Final Payment Method Performance Summary

## 🧠 SQL Techniques Used

* `SELECT`, `COUNT()`, `SUM()`, `ROUND()`
* `COUNT(DISTINCT)`
* `NULLIF()` and `CASE`
* `WHERE`, `GROUP BY`, `ORDER BY`
* JOINs and CTEs
* Conditional aggregation
* Window functions and `RANK()`
* KPI analysis and risk classification

## 🚨 Payment Method Risk Classification

| Payment Method Behavior                  | Risk Classification |
| ---------------------------------------- | ------------------- |
| Failure rate ≥ 50%                       | High Risk           |
| Failure rate ≥ 20% OR pending rate ≥ 20% | Medium Risk         |
| Otherwise                                | Low Risk            |

This is a rule-based business-analysis framework, not a machine-learning prediction or statistically validated risk model.

## 📁 Project Files

```text
SQL/
└── customer_payment_method_performance_analysis.sql

Report/
└── Day67_Customer_Payment_Method_Performance_Analysis.md

Screenshots/
└── Day 67/
```

## 🏆 Day 67 Achievement

Customer Payment Method Performance Analysis completed successfully. ✅

---

# 📊 Day 68 — Payment Method Trend & Reliability Analysis

Day 68 focused on **Payment Method Trend & Reliability Analysis** using MySQL.

## 🎯 Objective

Understand how payment-method usage, customer adoption, transaction performance, and reliability change over time.

## 🔍 Key Analyses

1. Payment Method Usage by Date
2. Payment Method Usage by Month
3. Monthly Transactions by Payment Method
4. Monthly Unique Orders by Payment Method
5. Monthly Customer Count by Payment Method
6. Monthly Successful Transactions
7. Monthly Failed Transactions
8. Monthly Pending Transactions
9. Monthly Payment Success Rate
10. Monthly Payment Failure Rate
11. Monthly Payment Pending Rate
12. Payment Method Monthly Performance Ranking
13. Payment Method Reliability Analysis
14. Highest-Growth Payment Method
15. Final Payment Method Trend & Reliability Summary

## 🧠 SQL Techniques Used

* `SELECT`, `COUNT()`, `SUM()`, `ROUND()`
* `COUNT(DISTINCT)` and `NULLIF()`
* `CASE`, `WHERE`, `GROUP BY`, `ORDER BY`
* JOINs and CTEs
* Conditional aggregation
* Window functions
* `RANK()` and `LAG()`
* `DATE_FORMAT()`
* Month-over-month growth analysis
* Payment performance and reliability classification
* KPI analysis

## 🔐 Payment Method Reliability Framework

| Success Rate        | Reliability Classification |
| ------------------- | -------------------------- |
| ≥ 90%               | Highly Reliable            |
| ≥ 75% and below 90% | Moderately Reliable        |
| < 75%               | Low Reliability            |

The reliability classifications are rule-based business-analysis categories.

## 💼 Business Applications

* Payment-channel monitoring
* Payment-method optimization
* Customer payment preference analysis
* Payment failure investigation
* Customer experience improvement
* Payment reliability monitoring
* Payment operations and business reporting

## ⚠️ Methodology Limitation

The `payments` table does not contain a direct payment amount field. This analysis therefore focuses on transactions, payment methods, payment statuses, orders, customers, and time-based payment activity.

The reliability classification is not a machine-learning prediction or statistically validated reliability model. Month-over-month comparisons depend on the available historical records.

## 📁 Project Files

```text
SQL/
└── payment_method_trend_reliability_analysis.sql

Report/
└── Day68_Payment_Method_Trend_Reliability_Analysis.md

Screenshots/
└── Day 68/
```

## 🏆 Day 68 Achievement

Payment Method Trend & Reliability Analysis completed successfully. ✅

---

# 📊 Day 69 — Sales Forecasting & Trend Projection Using SQL

Day 69 focused on **Sales Forecasting & Trend Projection using MySQL**.

The analysis evaluates historical monthly sales revenue, order activity, units sold, revenue growth, moving averages, revenue trends, revenue variability, and a baseline projection for the next month.

## 🎯 Objective

Understand historical sales performance and use SQL-based time-series analysis to support basic sales planning and business decision-making.

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
* `SUM()`, `COUNT()`, `AVG()`
* `MIN()` and `MAX()`
* `ROUND()` and `NULLIF()`
* `CASE`
* JOINs
* Common Table Expressions (CTEs)
* `GROUP BY` and `ORDER BY`
* `DATE_FORMAT()`
* `DATE_ADD()` and `STR_TO_DATE()`
* `LAG()`
* `RANK()`
* `ROW_NUMBER()`
* Window functions
* Moving average analysis
* Month-over-month growth analysis
* Revenue trend classification
* Standard deviation analysis
* Baseline sales projection
* Business KPI analysis

## 📅 Monthly Sales Revenue Analysis

Monthly revenue is calculated using product quantities and product prices.

**Revenue formula:**

`Total Revenue = SUM(quantity × product price)`

This provides a historical view of sales performance and helps compare revenue across available months.

## 🛒 Monthly Order and Unit Analysis

Monthly order counts measure order activity, while units sold measure product sales volume.

These KPIs provide additional context for revenue changes and help distinguish changes in order activity from changes in average order value.

## 💰 Average Order Value

Average Order Value (AOV) measures the average revenue generated per order.

**Formula:**

`AOV = Total Revenue / Total Orders`

The analysis calculates revenue at the order level before aggregating average order value by month.

## 📈 Month-over-Month Revenue Analysis

The `LAG()` window function retrieves revenue from the previous available monthly record.

**Revenue change:**

`Current Revenue − Previous Revenue`

**Growth percentage:**

`((Current Revenue − Previous Revenue) / Previous Revenue) × 100`

`NULLIF()` prevents division by zero. Growth is undefined when previous revenue is zero and is returned as `NULL`.

## 📉 Moving Average Analysis

### Three-Month Moving Average

Calculates average revenue over the current record and up to two preceding available monthly records.

### Six-Month Moving Average

Calculates average revenue over the current record and up to five preceding available monthly records.

Moving averages help smooth short-term variation and reveal broader patterns in historical revenue.

**Note:** The SQL uses available monthly records. Missing calendar months are not automatically created, so these moving averages may not represent consecutive calendar months when the dataset contains gaps.

## 🏆 Revenue Trend and Performance Analysis

The analysis identifies the highest- and lowest-revenue months using ranking functions.

Monthly revenue is also classified as:

| Condition                                 | Classification    |
| ----------------------------------------- | ----------------- |
| Current revenue exceeds previous revenue  | Growing           |
| Current revenue is below previous revenue | Declining         |
| Current revenue equals previous revenue   | Stable            |
| No previous record exists                 | No Previous Month |

This classification describes historical revenue changes and is not a statistical trend test.

## 📊 Revenue Volatility Analysis

The analysis measures:

* Number of months with sales
* Average monthly revenue
* Minimum monthly revenue
* Maximum monthly revenue
* Population standard deviation of revenue

Standard deviation indicates how widely observed monthly revenue values vary around their average. It does not independently explain why revenue changed.

## 🔮 Baseline Next-Month Revenue Projection

A simple baseline projection is calculated by averaging revenue from the three most recent available monthly records.

**Formula:**

`Projected Revenue = Average Revenue of the Last 3 Available Months`

The query requires at least three available monthly records.

This baseline can support preliminary sales planning, budget discussions, and comparisons with future actual revenue.

It is a simple moving-average baseline, **not a machine-learning forecast or a guaranteed prediction**. It does not explicitly model seasonality, long-term trends, promotions, market conditions, or external factors.

## 📊 KPI Framework

| KPI                         | Business Purpose                                |
| --------------------------- | ----------------------------------------------- |
| Monthly Revenue             | Measures sales value over time                  |
| Monthly Orders              | Measures order activity                         |
| Units Sold                  | Measures sales volume                           |
| Average Order Value         | Measures average revenue per order              |
| Revenue Change              | Measures absolute monthly change                |
| Growth Percentage           | Measures relative revenue change                |
| Three-Month Moving Average  | Highlights shorter-term revenue patterns        |
| Six-Month Moving Average    | Highlights broader revenue patterns             |
| Highest-Revenue Month       | Identifies the strongest observed month         |
| Lowest-Revenue Month        | Identifies the weakest observed month           |
| Revenue Standard Deviation  | Measures variation in monthly revenue           |
| Baseline Revenue Projection | Provides a simple next-month reference estimate |

## 💼 Business Applications

* Revenue planning
* Sales performance monitoring
* Budget preparation
* Business reporting
* Inventory-planning discussions
* Demand-planning discussions
* Monthly KPI tracking
* Identification of strong and weak sales periods
* Historical performance comparisons
* Preliminary sales forecasting

These are potential applications of the analysis, not claims of a specific business outcome.

## ⚠️ Methodology Limitations

* The analysis uses historical sales data available in the database.
* Revenue is calculated from product quantity and product price.
* Months without orders are not automatically generated.
* Moving averages use available monthly records.
* The first available month has no previous-month comparison.
* Growth percentage is undefined when previous revenue is zero.
* The projection requires at least three monthly records.
* The projection does not explicitly model seasonality or external business factors.
* Historical trends do not guarantee future performance.
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

Sales Forecasting & Trend Projection using SQL completed successfully. ✅

The analysis covers monthly revenue, order activity, units sold, average order value, revenue growth, moving averages, trend classification, revenue variability, and baseline next-month projection.

**69 Days of continuous SQL business analysis completed. 🚀**

**Sales Forecasting & Trend Projection completed successfully. 📈**

**69/69 Milestone Achieved. 🔥🏆**

---

# 📅 Daily Project Organization

| Day        | Main Work                                     |
| ---------- | --------------------------------------------- |
| Day 1–7    | SQL & Database Fundamentals                   |
| Day 8–14   | Intermediate SQL Analysis                     |
| Day 15–17  | Advanced SQL & Optimization                   |
| Day 18–22  | Customer & Business Analytics                 |
| Day 23     | Sales Trend Analysis                          |
| Day 24     | Product Performance Analysis                  |
| Day 25     | Sales Profitability Analysis                  |
| Day 26     | Customer Revenue Contribution                 |
| Day 27     | Customer Churn Analysis                       |
| Day 28     | Customer Cohort & Retention                   |
| Day 29     | Customer Purchase Frequency                   |
| Day 30     | Customer Segmentation & Revenue               |
| Day 31–42  | Customer & Product Analytics                  |
| Day 43–45  | Payment & Customer Payment Analysis           |
| Day 46     | Data Quality & Integrity                      |
| Day 47     | Sales Performance KPI                         |
| Day 48     | Sales Growth & Month-over-Month               |
| Day 49     | Sales Order Value & Basket                    |
| Day 50     | Sales Revenue Forecasting                     |
| Day 51     | Product Demand & Sales Forecasting            |
| Day 52     | Customer Repeat Purchase Prediction           |
| Day 53     | Customer Purchase Propensity Analysis         |
| Day 54     | Customer Purchase Value & Basket Analysis     |
| Day 55     | Customer Purchase Value Segmentation          |
| Day 56–57  | Customer Revenue Contribution & Concentration |
| Day 58     | Customer Revenue Pareto & 80/20 Analysis      |
| Day 59     | Customer Revenue Decile Analysis              |
| Day 60     | Customer Revenue Quartile Analysis            |
| Day 61     | Customer Revenue Quintile Analysis            |
| Day 62     | Customer Revenue ABC Analysis                 |
| Day 63     | Customer Revenue ABC Segment Performance      |
| Day 64     | ABC Segment Comparison & Business Priority    |
| Day 65     | Payment Performance & Business Analysis       |
| Day 66     | Customer Payment Behavior & Risk Analysis     |
| Day 67     | Customer Payment Method Performance           |
| Day 68     | Payment Method Trend & Reliability            |
| **Day 69** | **Sales Forecasting & Trend Projection**      |

---

# 📊 Business Analysis Journey

```text
Raw Sales Data
      ↓
Database Design
      ↓
SQL Fundamentals
      ↓
JOINs & Aggregations
      ↓
Advanced SQL
      ↓
Query Optimization
      ↓
Business KPIs
      ↓
Customer Analytics
      ↓
Customer Retention & Lifecycle Analysis
      ↓
Customer Lifetime Value & RFM Segmentation
      ↓
Repeat Purchase & Purchase Frequency Analysis
      ↓
Product Analytics & Cross-Selling
      ↓
Revenue Contribution & Customer Segmentation
      ↓
Pareto, Decile, Quartile & Quintile Analysis
      ↓
ABC Customer Revenue Analysis
      ↓
Payment Performance & Risk Analysis
      ↓
Customer Payment Behavior
      ↓
Payment Method Performance
      ↓
Payment Method Trend & Reliability
      ↓
Monthly Sales Revenue Analysis
      ↓
Month-over-Month Growth Analysis
      ↓
Moving Average Analysis
      ↓
Revenue Trend & Volatility Analysis
      ↓
Baseline Sales Projection
      ↓
Business Insights
```

---

# 📁 Project Structure

```text
Sales_Data_Analysis_SQL/
├── Database_Design/
│   └── sales_analysis.mwb
├── SQL/
│   ├── create_database.sql
│   ├── create_tables.sql
│   ├── insert_data.sql
│   ├── basic_queries.sql
│   ├── join_queries.sql
│   ├── aggregate_queries.sql
│   ├── subqueries.sql
│   ├── sales_analysis_report.sql
│   ├── views.sql
│   ├── stored_procedures.sql
│   ├── triggers.sql
│   ├── indexes.sql
│   ├── window_functions.sql
│   ├── cte_queries.sql
│   ├── cte_analysis.sql
│   ├── advanced_business_analysis.sql
│   ├── query_optimization.sql
│   ├── business_kpi_analysis.sql
│   ├── customer_revenue_analytics.sql
│   ├── customer_behavior_analysis.sql
│   ├── customer_retention_analysis.sql
│   ├── customer_lifetime_value.sql
│   ├── rfm_customer_segmentation.sql
│   ├── sales_trend_analysis.sql
│   ├── product_performance_analysis.sql
│   ├── sales_profitability_analysis.sql
│   ├── customer_revenue_contribution.sql
│   ├── customer_churn_analysis.sql
│   ├── customer_cohort_analysis.sql
│   ├── customer_purchase_frequency_analysis.sql
│   ├── product_purchase_behavior_analysis.sql
│   ├── product_customer_affinity_analysis.sql
│   ├── customer_product_purchase_analysis.sql
│   ├── customer_cross_selling_analysis.sql
│   ├── customer_purchase_journey_analysis.sql
│   ├── payment_status_method_analysis.sql
│   ├── customer_payment_behavior_analysis.sql
│   ├── payment_risk_pending_analysis.sql
│   ├── data_quality_integrity_analysis.sql
│   ├── sales_performance_kpi_analysis.sql
│   ├── sales_growth_mom_analysis.sql
│   ├── sales_order_value_basket_analysis.sql
│   ├── sales_revenue_forecasting_analysis.sql
│   ├── product_demand_forecasting_analysis.sql
│   ├── customer_repeat_purchase_prediction.sql
│   ├── customer_purchase_propensity_analysis.sql
│   ├── customer_purchase_value_basket_analysis.sql
│   ├── customer_purchase_value_segmentation.sql
│   ├── customer_revenue_contribution_analysis.sql
│   ├── customer_revenue_pareto_analysis.sql
│   ├── customer_revenue_decile_analysis.sql
│   ├── customer_revenue_quartile_analysis.sql
│   ├── customer_revenue_quintile_analysis.sql
│   ├── customer_revenue_abc_analysis.sql
│   ├── customer_revenue_abc_segment_performance.sql
│   ├── customer_revenue_abc_segment_comparison.sql
│   ├── payment_performance_business_analysis.sql
│   ├── customer_payment_behavior_risk_analysis.sql
│   ├── customer_payment_method_performance_analysis.sql
│   ├── payment_method_trend_reliability_analysis.sql
│   └── sales_forecasting_trend_projection.sql
├── Screenshots/
│   ├── Day 66/
│   ├── Day 67/
│   ├── Day 68/
│   └── Day 69/
├── Presentation/
├── Report/
│   ├── Week1_Report.md
│   ├── Week2_Report.md
│   ├── Day66_Customer_Payment_Behavior_Risk_Analysis.md
│   ├── Day67_Customer_Payment_Method_Performance_Analysis.md
│   ├── Day68_Payment_Method_Trend_Reliability_Analysis.md
│   └── Day69_Sales_Forecasting_Trend_Projection.md
└── README.md
```

*Note: This structure documents the main project files. Keep the filenames aligned with the files actually present in your repository.*

---

# 📌 Project Status

**Current Status: 🟢 Active**

**Completed: 69 Days**

**Primary Focus: SQL Data Analysis & Business Intelligence**

The project has progressed from SQL fundamentals and relational database design to advanced SQL analytics, customer analytics, product analytics, revenue segmentation, payment analysis, payment-method reliability, and sales forecasting.

The Day 69 analysis adds historical revenue comparisons, moving averages, revenue volatility analysis, and a baseline next-month projection to the portfolio.

---

# 🚀 69-Day Portfolio Progress

```text
SQL Fundamentals
      ↓
Advanced SQL
      ↓
Business Analytics
      ↓
Customer Analytics
      ↓
Customer Retention & Lifecycle Analysis
      ↓
Customer Lifetime Value & RFM Segmentation
      ↓
Product & Customer Behavior Analysis
      ↓
Revenue Contribution & Segmentation
      ↓
ABC Segment Performance
      ↓
Payment Performance & Risk Analysis
      ↓
Payment Method Performance
      ↓
Payment Method Trend & Reliability
      ↓
Sales Revenue Trend Analysis
      ↓
Month-over-Month Growth
      ↓
Three-Month & Six-Month Moving Averages
      ↓
Revenue Volatility
      ↓
Baseline Next-Month Revenue Projection
      ↓
Business Insights
```

---

# 🎯 Next Stage

The next stage of the project can explore:

* Advanced revenue forecasting
* Seasonality analysis
* Product demand trend analysis
* Customer behavior forecasting
* Advanced business KPIs
* Dashboard-oriented analytics
* Executive business reporting
* Revenue performance dashboards
* Sales KPI dashboards
* Customer behavior dashboards
* Payment monitoring dashboards
* Data quality monitoring dashboards
* Business performance monitoring

**Next Milestone: Day 70 🔥**

---

# ⭐ Project Goal

The long-term goal is to transform this project into a complete SQL and Business Analytics portfolio demonstrating the ability to:

```text
Query
   ↓
Analyze
   ↓
Measure
   ↓
Validate
   ↓
Segment
   ↓
Compare
   ↓
Identify Problems
   ↓
Forecast
   ↓
Generate Insights
   ↓
Recommend Business Actions
```

---

# 🎉 69-Day Milestone

**Day 69 — Sales Forecasting & Trend Projection completed. ✅**

**69 Days of continuous SQL business analysis completed. 🚀**

**Monthly revenue, order activity, revenue growth, moving averages, trend classification, volatility, and baseline revenue projection analysis added to the project. 📈**

**69/69 Milestone Achieved. 🔥🏆**

**Next target: Day 70. 🚀**
