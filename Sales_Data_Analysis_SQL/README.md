# 📊 Sales Data Analysis Using SQL

A hands-on SQL portfolio project focused on **relational database design, advanced SQL analytics, query optimization, customer analytics, product analytics, business intelligence, customer retention, cohort analysis, customer lifecycle analysis, repeat purchase analysis, purchase frequency analysis, payment analysis, payment performance analysis, payment status analysis, payment method analysis, payment trend analysis, payment risk analysis, customer payment behavior analysis, customer payment success analysis, customer payment failure analysis, customer payment method preference analysis, customer payment risk classification, and customer payment method performance analysis using MySQL.**

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
* Business intelligence
* Business reporting

---

# 📊 Day 67 — Customer Payment Method Performance Analysis

Day 67 focused on **Customer Payment Method Performance Analysis** using MySQL.

The analysis extends the Day 66 customer payment behavior and risk analysis by evaluating the performance of individual payment methods.

## 🎯 Objective

The objective was to understand how different payment methods perform across the sales system and identify payment methods with strong or weak payment performance.

The analysis focuses on:

* Payment method usage
* Payment transaction volume
* Customer adoption
* Successful transactions
* Failed transactions
* Pending transactions
* Success rate
* Failure rate
* Pending rate
* Payment method ranking
* Payment method risk classification

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

# 📅 Daily Project Organization

| Day        | Main Work                                        |
| ---------- | ------------------------------------------------ |
| Day 1–7    | SQL & Database Fundamentals                      |
| Day 8–14   | Intermediate SQL Analysis                        |
| Day 15–17  | Advanced SQL & Optimization                      |
| Day 18–22  | Customer & Business Analytics                    |
| Day 23     | Sales Trend Analysis                             |
| Day 24     | Product Performance Analysis                     |
| Day 25     | Sales Profitability Analysis                     |
| Day 26     | Customer Revenue Contribution                    |
| Day 27     | Customer Churn Analysis                          |
| Day 28     | Customer Cohort & Retention                      |
| Day 29     | Customer Purchase Frequency                      |
| Day 30     | Customer Segmentation & Revenue                  |
| Day 31–42  | Customer & Product Analytics                     |
| Day 43–45  | Payment & Customer Payment Analysis              |
| Day 46     | Data Quality & Integrity                         |
| Day 47     | Sales Performance KPI                            |
| Day 48     | Sales Growth & Month-over-Month                  |
| Day 49     | Sales Order Value & Basket                       |
| Day 50     | Sales Revenue Forecasting                        |
| Day 51     | Product Demand & Sales Forecasting               |
| Day 52     | Customer Repeat Purchase Prediction              |
| Day 53     | Customer Purchase Propensity Analysis            |
| Day 54     | Customer Purchase Value & Basket Analysis        |
| Day 55     | Customer Purchase Value Segmentation             |
| Day 56–57  | Customer Revenue Contribution & Concentration    |
| Day 58     | Customer Revenue Pareto & 80/20 Analysis         |
| Day 59     | Customer Revenue Decile Analysis                 |
| Day 60     | Customer Revenue Quartile Analysis               |
| Day 61     | Customer Revenue Quintile Analysis               |
| Day 62     | Customer Revenue ABC Analysis                    |
| Day 63     | Customer Revenue ABC Segment Performance         |
| Day 64     | ABC Segment Comparison & Business Priority       |
| Day 65     | Payment Performance & Business Analysis          |
| Day 66     | Customer Payment Behavior & Risk Analysis        |
| **Day 67** | **Customer Payment Method Performance Analysis** |

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
│   └── customer_payment_method_performance_analysis.sql

├── Screenshots/
│   ├── Day 1/
│   ├── Day 2/
│   ├── ...
│   ├── Day 65/
│   ├── Day 66/
│   └── Day 67/

├── Presentation/

├── Report/
│   ├── Week1_Report.md
│   ├── Week2_Report.md
│   ├── ...
│   ├── Day65_Payment_Performance_Business_Analysis.md
│   ├── Day66_Customer_Payment_Behavior_Risk_Analysis.md
│   └── Day67_Customer_Payment_Method_Performance_Analysis.md

└── README.md
```

---

# 📌 Project Status

**Current Status: 🟢 Active**

**Completed: 67 Days**

**Primary Focus: SQL Data Analysis & Business Intelligence**

The project has completed 67 days of structured SQL learning and business analysis.

The project now covers database design, SQL fundamentals, advanced SQL, query optimization, customer analytics, product analytics, customer segmentation, RFM analysis, customer retention, churn analysis, cohort analysis, customer lifecycle analysis, repeat purchase analysis, purchase frequency analysis, payment analysis, payment performance analysis, payment status analysis, payment method analysis, payment trend analysis, payment risk analysis, customer payment behavior analysis, customer payment success and failure analysis, payment method preference analysis, repeated payment failure analysis, pending payment analysis, customer payment risk classification, customer payment method performance analysis, payment method success/failure/pending analysis, customer payment method adoption, and payment method risk classification.

---

# 🚀 67-Day Portfolio Progress

**67 Days Completed 🚀**

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
* Data quality monitoring dashboards
* Business performance monitoring

**Next Milestone: Day 68 🔥**

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

# 🎉 67-Day Milestone

**Day 67 is completed successfully. ✅**

**67 Days of continuous SQL business analysis completed. 🚀**

**Customer Payment Method Performance Analysis completed successfully. 💳📊**

**Payment method usage, customer adoption, success rate, failure rate, pending rate, performance comparison, and payment method risk classification completed. 🎯**

**67/67 Milestone Achieved. 🔥🏆**

**Next target: Day 68. 🚀**
