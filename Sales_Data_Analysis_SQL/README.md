# 📊 Sales Data Analysis Using SQL

A hands-on SQL portfolio project focused on **relational database design, advanced SQL analytics, query optimization, customer analytics, product analytics, business intelligence, customer retention, cohort analysis, customer lifecycle analysis, repeat purchase analysis, purchase frequency analysis, payment analysis, payment performance analysis, payment status analysis, payment method analysis, payment trend analysis, payment risk analysis, customer payment behavior analysis, customer payment success analysis, customer payment failure analysis, customer payment method preference analysis, customer payment risk classification, customer payment method performance analysis, and payment method trend and reliability analysis using MySQL.**

This project simulates a real-world sales management system and demonstrates practical SQL skills relevant to **Data Analyst, Business Analyst, SQL Developer, Reporting Analyst, and MIS Analyst roles.**

---

# 🚀 Project Overview

This project follows a structured, end-to-end SQL data-analysis workflow, progressing from database fundamentals to advanced analytical and business-oriented SQL.

The primary objective is to transform raw sales data into meaningful business insights using SQL.

The project covers:

* Database design
* SQL fundamentals
* Data manipulation
* SQL querying
* JOIN operations
* Aggregation
* Advanced SQL
* Query optimization
* Customer analytics
* Product analytics
* Revenue analysis
* Business KPI analysis
* Customer segmentation
* RFM customer segmentation
* Customer retention and churn analysis
* Cohort and lifecycle analysis
* Repeat purchase analysis
* Purchase frequency analysis
* Customer Lifetime Value analysis
* Product purchase behavior
* Product affinity and cross-selling
* Customer-product analysis
* Customer purchase journey analysis
* Basket size analysis
* Order value analysis
* Revenue forecasting
* Product demand forecasting
* Customer repeat purchase prediction
* Customer purchase propensity analysis
* Customer purchase value analysis
* Customer value segmentation
* Customer revenue contribution
* Customer revenue ranking
* Customer revenue concentration
* Pareto and 80/20 analysis
* Customer revenue decile analysis
* Customer revenue quartile analysis
* Customer revenue quintile analysis
* Customer revenue ABC analysis
* ABC segment performance analysis
* ABC segment comparison
* ABC segment business priority analysis
* Payment performance analysis
* Payment status analysis
* Payment method analysis
* Payment trend analysis
* Payment risk analysis
* Customer payment behavior analysis
* Customer payment success analysis
* Customer payment failure analysis
* Customer payment method preference
* Multiple payment method analysis
* Repeated payment failure analysis
* Pending payment analysis
* Customer payment success rate
* Customer payment failure rate
* Customer payment risk classification
* High-risk customer identification
* Payment method performance analysis
* Payment method success rate
* Payment method failure rate
* Payment method pending rate
* Customer adoption by payment method
* Payment method risk classification
* Payment method trend analysis
* Monthly payment method analysis
* Payment method growth analysis
* Payment method reliability analysis
* Month-over-month payment analysis
* Business intelligence
* Business reporting

---

# 📊 Day 67 — Customer Payment Method Performance Analysis

Day 67 focused on **Customer Payment Method Performance Analysis** using MySQL.

The analysis extends the Day 66 customer payment behavior and risk analysis by evaluating the performance of individual payment methods.

## 🎯 Objective

The objective was to understand how different payment methods perform across the sales system and identify payment methods with strong or weak payment performance.

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

* SELECT
* COUNT()
* COUNT(DISTINCT)
* SUM()
* ROUND()
* NULLIF()
* CASE
* WHERE
* GROUP BY
* ORDER BY
* JOIN
* CTEs
* Conditional Aggregation
* Window Functions
* RANK()
* KPI Analysis
* Payment Method Analysis
* Payment Status Analysis
* Success Rate Calculation
* Failure Rate Calculation
* Pending Rate Calculation
* Risk Classification

## 💳 Payment Method Performance

Payment methods were compared using transaction volume, customer adoption, successful transactions, failed transactions, pending transactions, and performance rates.

This helps identify which payment channels are most frequently used and which methods provide stronger payment performance.

## 📈 Payment Method Success Rate

The success rate measures the percentage of successful transactions compared with total transactions for each payment method.

This provides a standardized way to compare payment methods with different transaction volumes.

## ❌ Payment Method Failure Rate

The failure rate measures the percentage of failed transactions for each payment method.

A higher failure rate may indicate payment friction or operational issues associated with a payment channel.

## ⏳ Payment Method Pending Rate

The pending rate measures the percentage of pending transactions for each payment method.

This can help identify payment methods requiring additional monitoring.

## 👥 Customer Adoption by Payment Method

Customer usage was analyzed to identify:

* Number of customers using each payment method
* Most preferred payment methods
* Payment method transaction volume
* Customers using multiple payment methods

## 🚨 Payment Method Risk Classification

Payment methods are classified using a rule-based framework:

| Payment Method Behavior                  | Risk Classification |
| ---------------------------------------- | ------------------- |
| Failure rate ≥ 50%                       | High Risk           |
| Failure rate ≥ 20% OR pending rate ≥ 20% | Medium Risk         |
| Otherwise                                | Low Risk            |

## 💼 Business Applications

Payment method performance analysis can support:

* Payment-channel monitoring
* Payment method optimization
* Payment failure investigation
* Customer payment experience improvement
* Payment recovery
* Transaction monitoring
* Payment risk management
* Business reporting
* Operational decision-making

## ⚠️ Methodology Limitation

The analysis is based on the payment transactions available in the sales database.

The `payments` table does not contain a direct payment amount field, so the analysis focuses on payment transactions, payment methods, payment statuses, customers, orders, and performance rates.

The payment-method risk classification is a **rule-based business-analysis framework**, not a machine-learning prediction or statistically validated risk model.

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

The analysis covered payment method usage, customer adoption, transaction performance, success rate, failure rate, pending rate, payment method ranking, and payment method risk classification.

**67 Days of continuous SQL business analysis completed. 🚀**

**Customer Payment Method Performance Analysis completed successfully. 💳📊**

**67/67 Milestone Achieved. 🔥🏆**

---

# 📊 Day 68 — Payment Method Trend & Reliability Analysis

Day 68 focused on **Payment Method Trend & Reliability Analysis** using MySQL.

The analysis extends the Day 67 payment method performance analysis by evaluating payment-method behavior over time, monthly transaction activity, customer adoption, payment performance trends, month-over-month growth, and payment-method reliability.

## 🎯 Objective

The objective was to understand how different payment methods perform over time and identify payment methods that are becoming more or less popular and reliable.

The analysis focuses on:

* Payment method usage by date
* Payment method usage by month
* Monthly transaction volume
* Monthly unique orders
* Monthly customer adoption
* Successful transactions
* Failed transactions
* Pending transactions
* Monthly payment success rate
* Monthly payment failure rate
* Monthly payment pending rate
* Monthly payment-method performance
* Payment method reliability
* Month-over-month growth

## 🔍 Key Analyses

* Payment Method Usage by Date
* Payment Method Usage by Month
* Monthly Transactions by Payment Method
* Monthly Unique Orders by Payment Method
* Monthly Customer Count by Payment Method
* Monthly Successful Transactions
* Monthly Failed Transactions
* Monthly Pending Transactions
* Monthly Payment Success Rate
* Monthly Payment Failure Rate
* Monthly Payment Pending Rate
* Payment Method Monthly Performance Ranking
* Payment Method Reliability Analysis
* Highest-Growth Payment Method
* Final Payment Method Trend & Reliability Summary

## 🧠 SQL Techniques Used

* SELECT
* COUNT()
* COUNT(DISTINCT)
* SUM()
* ROUND()
* NULLIF()
* CASE
* WHERE
* GROUP BY
* ORDER BY
* JOIN
* CTEs
* Conditional Aggregation
* Window Functions
* RANK()
* LAG()
* DATE_FORMAT()
* Month-over-Month Growth Analysis
* Trend Analysis
* Payment Performance Analysis
* Reliability Classification
* KPI Analysis

## 📅 Payment Method Trend Analysis

Payment methods were analyzed across payment dates and months to understand how transaction activity changes over time.

Monthly analysis helps identify:

* Increasing payment-method usage
* Decreasing payment-method usage
* Changes in transaction volume
* Changes in customer adoption
* Changes in payment performance

This provides a time-based view of payment-channel behavior.

## 💳 Monthly Payment Method Usage

Payment transactions were grouped by month and payment method.

The analysis measures the number of transactions associated with each payment method during each month.

This helps businesses understand which payment channels are most active during different periods.

## 🧾 Monthly Unique Orders

The analysis measures the number of unique orders associated with each payment method every month.

This provides an order-level view of payment-method usage and helps avoid relying only on raw transaction counts.

## 👥 Monthly Customer Adoption

The number of unique customers using each payment method was analyzed by month.

This helps identify payment methods with:

* Broad customer adoption
* Increasing customer usage
* Lower customer adoption
* Changing customer preferences

## ✅ Monthly Payment Success Analysis

Successful payment transactions were analyzed by month and payment method.

The analysis calculates:

* Successful transaction count
* Total transaction count
* Monthly success rate

The success rate provides a standardized measure for comparing payment methods across different transaction volumes.

## ❌ Monthly Payment Failure Analysis

Failed payment transactions were analyzed by month and payment method.

The analysis calculates:

* Failed transaction count
* Total transaction count
* Monthly failure rate

A higher failure rate may indicate payment friction or operational issues affecting a payment channel.

## ⏳ Monthly Pending Payment Analysis

Pending payment transactions were analyzed by month and payment method.

The analysis measures:

* Pending transaction count
* Total transaction count
* Pending rate

Pending payments may require additional monitoring because they have not reached a final payment state.

## 🏆 Monthly Payment Method Performance Ranking

Payment methods were ranked within each month according to their payment success rate.

The analysis uses the `RANK()` window function with monthly partitions.

This makes it possible to identify the strongest-performing payment method for each period.

## 📈 Payment Method Growth Analysis

Month-over-month payment-method transaction growth was calculated using the `LAG()` window function.

The comparison uses:

* Current-month transactions
* Previous-month transactions
* Month-over-month growth percentage

This helps identify payment methods experiencing stronger increases or decreases in transaction activity.

## 🔐 Payment Method Reliability Analysis

Payment methods were classified according to their overall payment success rate.

### Reliability Framework

| Success Rate | Reliability Classification |
| ------------ | -------------------------- |
| ≥ 90%        | 🟢 Highly Reliable         |
| ≥ 75%        | 🟡 Moderately Reliable     |
| < 75%        | 🔴 Low Reliability         |

This framework is used as a business-analysis rule for comparing payment-method reliability.

## 📊 KPI Framework

The main KPIs used in this analysis are:

| KPI                        | Purpose                                  |
| -------------------------- | ---------------------------------------- |
| Payment Transactions       | Measures payment-method activity         |
| Unique Orders              | Measures order-level usage               |
| Unique Customers           | Measures customer adoption               |
| Successful Transactions    | Measures successful payment activity     |
| Failed Transactions        | Measures payment failures                |
| Pending Transactions       | Measures unresolved payment activity     |
| Success Rate               | Measures payment effectiveness           |
| Failure Rate               | Measures payment failure level           |
| Pending Rate               | Measures unresolved payment activity     |
| Monthly Performance Rank   | Compares payment methods by month        |
| Month-over-Month Growth    | Measures changes in payment-method usage |
| Reliability Classification | Provides a business reliability view     |

## 💼 Business Applications

Payment method trend and reliability analysis can support:

* Payment-channel monitoring
* Payment-method optimization
* Customer payment preference analysis
* Payment failure investigation
* Payment reliability monitoring
* Payment operations
* Payment-channel planning
* Customer experience improvement
* Transaction monitoring
* Business reporting
* Operational decision-making

## 🎯 Business Interpretation

### 🟢 Highly Reliable Payment Methods

Payment methods with a success rate of at least 90%.

**Business focus:**

* Maintain availability
* Continue regular monitoring
* Support continued customer usage

### 🟡 Moderately Reliable Payment Methods

Payment methods with success rates between 75% and 89.99%.

**Business focus:**

* Monitor performance
* Investigate recurring failures
* Review operational performance

### 🔴 Low-Reliability Payment Methods

Payment methods with success rates below 75%.

**Business focus:**

* Prioritize investigation
* Identify causes of payment failures
* Review payment-channel reliability
* Consider corrective operational actions

## ⚠️ Methodology Limitation

The analysis is based on payment transactions available in the sales database.

The `payments` table does not contain a direct payment amount field, so this analysis focuses on:

* Payment transactions
* Payment methods
* Payment statuses
* Orders
* Customers
* Time-based payment activity

The reliability classification is a **rule-based business-analysis framework**.

It is not a machine-learning prediction or statistically validated reliability model.

The month-over-month growth analysis depends on the months available in the dataset. The first available month for a payment method does not have a previous-month value for comparison.

Payment status values should be interpreted according to the actual values available in the database.

Payment-method usage and reliability may change over time.

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

The analysis covered payment-method trends, monthly transaction activity, customer adoption, payment success and failure rates, pending payments, monthly performance ranking, month-over-month growth, and payment-method reliability.

**68 Days of continuous SQL business analysis completed. 🚀**

**Payment Method Trend & Reliability Analysis completed successfully. 📈💳**

**68/68 Milestone Achieved. 🔥🏆**

---

# 📅 Daily Project Organization

| Day        | Main Work                                       |
| ---------- | ----------------------------------------------- |
| Day 1–7    | SQL & Database Fundamentals                     |
| Day 8–14   | Intermediate SQL Analysis                       |
| Day 15–17  | Advanced SQL & Optimization                     |
| Day 18–22  | Customer & Business Analytics                   |
| Day 23     | Sales Trend Analysis                            |
| Day 24     | Product Performance Analysis                    |
| Day 25     | Sales Profitability Analysis                    |
| Day 26     | Customer Revenue Contribution                   |
| Day 27     | Customer Churn Analysis                         |
| Day 28     | Customer Cohort & Retention                     |
| Day 29     | Customer Purchase Frequency                     |
| Day 30     | Customer Segmentation & Revenue                 |
| Day 31–42  | Customer & Product Analytics                    |
| Day 43–45  | Payment & Customer Payment Analysis             |
| Day 46     | Data Quality & Integrity                        |
| Day 47     | Sales Performance KPI                           |
| Day 48     | Sales Growth & Month-over-Month                 |
| Day 49     | Sales Order Value & Basket                      |
| Day 50     | Sales Revenue Forecasting                       |
| Day 51     | Product Demand & Sales Forecasting              |
| Day 52     | Customer Repeat Purchase Prediction             |
| Day 53     | Customer Purchase Propensity Analysis           |
| Day 54     | Customer Purchase Value & Basket Analysis       |
| Day 55     | Customer Purchase Value Segmentation            |
| Day 56–57  | Customer Revenue Contribution & Concentration   |
| Day 58     | Customer Revenue Pareto & 80/20 Analysis        |
| Day 59     | Customer Revenue Decile Analysis                |
| Day 60     | Customer Revenue Quartile Analysis              |
| Day 61     | Customer Revenue Quintile Analysis              |
| Day 62     | Customer Revenue ABC Analysis                   |
| Day 63     | Customer Revenue ABC Segment Performance        |
| Day 64     | ABC Segment Comparison & Business Priority      |
| Day 65     | Payment Performance & Business Analysis         |
| Day 66     | Customer Payment Behavior & Risk Analysis       |
| Day 67     | Customer Payment Method Performance Analysis    |
| **Day 68** | **Payment Method Trend & Reliability Analysis** |

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

Customer Retention

      ↓

Customer Lifetime Value

      ↓

RFM Segmentation

      ↓

Cohort & Lifecycle Analysis

      ↓

Repeat Purchase Analysis

      ↓

Payment Analysis

      ↓

Payment Performance Analysis

      ↓

Payment Risk Analysis

      ↓

Customer Payment Behavior Analysis

      ↓

Customer Payment Risk Classification

      ↓

Customer Payment Method Preference

      ↓

Payment Method Performance Analysis

      ↓

Payment Method Success / Failure / Pending Analysis

      ↓

Payment Method Trend Analysis

      ↓

Monthly Payment Method Analysis

      ↓

Payment Method Growth Analysis

      ↓

Payment Method Reliability Analysis

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
│   └── payment_method_trend_reliability_analysis.sql
│
├── Screenshots/
│   ├── Day 1/
│   ├── Day 2/
│   ├── ...
│   ├── Day 66/
│   ├── Day 67/
│   └── Day 68/
│
├── Presentation/
│
├── Report/
│   ├── Week1_Report.md
│   ├── Week2_Report.md
│   ├── ...
│   ├── Day66_Customer_Payment_Behavior_Risk_Analysis.md
│   ├── Day67_Customer_Payment_Method_Performance_Analysis.md
│   └── Day68_Payment_Method_Trend_Reliability_Analysis.md
│
└── README.md
```

---

# 📌 Project Status

**Current Status: 🟢 Active**

**Completed: 68 Days**

**Primary Focus: SQL Data Analysis & Business Intelligence**

The project has completed 68 days of structured SQL learning and business analysis.

The project now covers database design, SQL fundamentals, advanced SQL, query optimization, customer analytics, product analytics, customer segmentation, RFM analysis, customer retention, churn analysis, cohort analysis, customer lifecycle analysis, repeat purchase analysis, purchase frequency analysis, payment analysis, payment performance analysis, payment status analysis, payment method analysis, payment trend analysis, payment risk analysis, customer payment behavior analysis, customer payment success and failure analysis, payment method preference analysis, repeated payment failure analysis, pending payment analysis, customer payment risk classification, customer payment method performance analysis, payment method success/failure/pending analysis, customer payment method adoption, payment method risk classification, payment method trend analysis, monthly payment-method performance, month-over-month payment-method growth, and payment-method reliability analysis.

---

# 🚀 68-Day Portfolio Progress

**68 Days Completed 🚀**

```text
SQL Fundamentals

      ↓

Advanced SQL

      ↓

Business Analytics

      ↓

Customer Analytics

      ↓

Customer Retention

      ↓

Customer Lifetime Value

      ↓

RFM Customer Segmentation

      ↓

Customer Segment Performance

      ↓

Customer Cohort & Lifecycle Analysis

      ↓

Repeat Purchase Analysis

      ↓

Payment Analysis

      ↓

Payment Performance Analysis

      ↓

Payment Risk Analysis

      ↓

Customer Payment Behavior Analysis

      ↓

Customer Payment Success & Failure Analysis

      ↓

Customer Payment Method Preference

      ↓

Customer Payment Risk Classification

      ↓

Customer Payment Method Performance Analysis

      ↓

Payment Method Success / Failure / Pending Analysis

      ↓

Payment Method Trend Analysis

      ↓

Monthly Payment Method Analysis

      ↓

Payment Method Growth Analysis

      ↓

Payment Method Reliability Analysis

      ↓

Business Insights
```

---

# 🎯 Next Stage

The next stage of the project can move toward:

* Advanced customer behavior forecasting
* Advanced revenue forecasting
* Advanced product demand forecasting
* Sales prediction concepts
* Customer purchase prediction
* Advanced business KPIs
* Dashboard-oriented analytics
* Management-level business analysis
* Executive business reporting
* Customer segmentation dashboards
* Revenue performance dashboards
* Sales KPI dashboards
* Product demand dashboards
* Customer behavior dashboards
* Payment monitoring dashboards
* Payment risk monitoring dashboards
* Customer payment method dashboards
* Payment trend dashboards
* Payment reliability dashboards
* Data quality monitoring dashboards
* Business performance monitoring

**Next Milestone: Day 69 🔥**

---

# ⭐ Project Goal

The long-term goal is to transform this project into a complete SQL + Business Analytics portfolio project demonstrating the ability to:

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

Predict

   ↓

Generate Insights

   ↓

Recommend Business Actions
```

---

# 🎉 68-Day Milestone

**Day 68 is completed successfully. ✅**

**68 Days of continuous SQL business analysis completed. 🚀**

**Payment Method Trend & Reliability Analysis completed successfully. 📈💳**

**Payment method trends, monthly performance, customer adoption, success rate, failure rate, pending rate, month-over-month growth, and reliability analysis completed. 🎯**

**68/68 Milestone Achieved. 🔥🏆**

**Next target: Day 69. 🚀**
