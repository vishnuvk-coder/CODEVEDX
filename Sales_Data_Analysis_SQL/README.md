# 📊 Sales Data Analysis Using SQL

A hands-on SQL portfolio project focused on **relational database design, advanced SQL analytics, query optimization, customer analytics, product analytics, business intelligence, customer retention, cohort analysis, customer lifecycle analysis, repeat purchase analysis, purchase frequency analysis, payment analysis, data quality analysis, sales KPI analysis, sales growth analysis, order value analysis, basket analysis, revenue forecasting, product demand forecasting, customer repeat purchase prediction, customer purchase propensity analysis, customer purchase value analysis, basket-size classification, spending classification, customer value segmentation, customer revenue ranking, customer revenue concentration analysis, Pareto analysis, 80/20 revenue analysis, customer revenue decile analysis, customer revenue quartile analysis, customer revenue quintile analysis, customer revenue ABC analysis, ABC segment performance analysis, ABC segment comparison, ABC segment business priority analysis, payment performance analysis, payment status analysis, payment method analysis, payment trend analysis, payment risk analysis, customer payment behavior analysis, customer payment success analysis, customer payment failure analysis, customer payment method preference analysis, and customer payment risk classification using MySQL.**

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
* Sales performance KPI analysis
* Sales growth analysis
* Month-over-month comparison
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
* High-value order analysis
* Revenue forecasting
* Future sales projection
* Product demand analysis
* Product demand forecasting
* Customer repeat purchase prediction
* Customer purchase propensity analysis
* Customer propensity scoring
* Customer purchase recency analysis
* Customer purchase frequency classification
* Customer purchase value analysis
* Customer basket behavior analysis
* Customer spending classification
* Purchase value scoring
* Customer purchase value ranking
* Customer value segmentation
* High-value customer identification
* Customer revenue contribution
* Customer revenue ranking
* Customer revenue concentration
* Cumulative revenue contribution
* Top customer analysis
* Payment status analysis
* Payment method analysis
* Customer payment behavior
* Customer payment risk analysis
* Payment transaction analysis
* Payment trend analysis
* Payment business risk analysis
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
* Data quality and integrity analysis
* Sales KPI analysis
* Sales growth analysis
* Order value and basket analysis
* Customer Revenue Pareto Analysis
* 80/20 Revenue Concentration Analysis
* 50% and 80% Revenue Threshold Analysis
* Top 10%, 20%, and 30% Customer Revenue Analysis
* Customer Revenue Decile Analysis
* Customer Revenue Distribution Analysis
* Customer Revenue Quartile Analysis
* Customer Revenue Quintile Analysis
* Customer Value Distribution Analysis
* Customer Revenue ABC Analysis
* ABC Customer Classification
* Revenue Contribution by ABC Class
* Cumulative Revenue Contribution by ABC Class
* Class A Customer Analysis
* Class B Customer Analysis
* Class C Customer Analysis
* Customer Revenue Prioritization
* Customer Portfolio Classification
* ABC Segment Performance Analysis
* A Segment Performance
* B Segment Performance
* C Segment Performance
* Customer Count by ABC Segment
* Revenue by ABC Segment
* Revenue Contribution by ABC Segment
* Orders by ABC Segment
* Units by ABC Segment
* Average Revenue per Customer
* Average Orders per Customer
* Average Units per Customer
* Revenue per Order
* Revenue per Unit
* ABC Segment Comparison
* Highest Revenue Segment
* Highest Average Customer Value Segment
* Highest Order Activity Segment
* Highest Unit Activity Segment
* ABC Segment Business Priority Analysis
* Payment Performance Analysis
* Payment Status Distribution
* Payment Method Distribution
* Payment Transaction Analysis
* Payment Status Percentage
* Payment Method Percentage
* Payment Activity by Date
* Payment Activity by Month
* Successful Payment Analysis
* Unsuccessful Payment Analysis
* Payment Status and Method Cross-Analysis
* Payment Business Risk Analysis
* Business intelligence
* Business reporting

---

# 📊 Day 66 — Customer Payment Behavior & Risk Analysis

Day 66 focused on **Customer Payment Behavior & Risk Analysis** using MySQL.

The analysis extends the Day 65 payment performance work by moving from overall payment analysis to **customer-level payment behavior and risk analysis**.

The analysis evaluates customer payment activity, successful and unsuccessful payments, payment method usage, repeated payment failures, pending payments, payment success and failure rates, and rule-based customer payment risk classification.

## 🎯 Day 66 Objective

The objective was to understand how customers interact with the payment system and identify customers who may require additional monitoring based on their payment behavior.

The analysis focuses on:

* Customer payment activity
* Payment success and failure behavior
* Payment method preferences
* Repeated payment failures
* Pending payments
* Customer payment success rate
* Customer payment failure rate
* Customer payment risk classification

## 🔍 Day 66 Key Analyses

* Customer Payment Transaction Count
* Customers with Successful Payments
* Customers with Failed Payments
* Customers with Pending Payments
* Customer Payment Success Rate
* Customer Payment Failure Rate
* Payment Method Preference by Customer
* Customers Using Multiple Payment Methods
* Customers with Repeated Payment Failures
* Customers with Pending Payment Transactions
* Customer Payment Risk Classification
* High-Risk Customer Identification
* Customer Payment Status Distribution
* Customer Payment Method and Status Analysis
* Final Customer Payment Behavior Summary

## 🧠 Day 66 SQL Techniques Used

* SELECT
* COUNT()
* COUNT(DISTINCT)
* SUM()
* ROUND()
* NULLIF()
* CASE
* WHERE
* GROUP BY
* HAVING
* ORDER BY
* JOIN
* CTEs
* Conditional Aggregation
* Customer-Level Aggregation
* Payment Status Analysis
* Payment Method Analysis
* Success Rate Calculation
* Failure Rate Calculation
* Risk Classification
* Business KPI Analysis

## 💳 Day 66 Customer Payment Behavior

Customer payment behavior was analyzed by connecting customer information from the `orders` table with payment information from the `payments` table.

The analysis measures:

* Total payment transactions
* Unique orders with payments
* Successful transactions
* Failed transactions
* Pending transactions
* Payment methods used
* Payment success rate
* Payment failure rate

This provides a customer-level view of payment activity rather than only looking at overall payment statistics.

## 📈 Day 66 Payment Success Rate

The customer payment success rate is calculated as the percentage of successful payment transactions compared with the customer's total payment transactions.

This metric helps identify customers with consistently successful payment activity.

## ⚠️ Day 66 Payment Failure Rate

The customer payment failure rate measures the percentage of failed payment transactions compared with the customer's total payment transactions.

A higher failure rate may indicate payment friction, repeated transaction issues, or the need for operational follow-up.

## 💳 Day 66 Payment Method Preference

Customer payment methods are analyzed to understand:

* Which payment methods customers use
* How frequently each method is used
* Customers who use multiple payment methods
* Payment method and payment-status combinations

This can help businesses understand customer payment-channel preferences.

## 🚨 Day 66 Repeated Payment Failure Analysis

Customers with multiple failed payment transactions are identified separately.

Customers with repeated payment failures may require additional investigation because repeated failures can create:

* Payment friction
* Order-processing issues
* Customer dissatisfaction
* Operational follow-up requirements

## ⏳ Day 66 Pending Payment Analysis

Customers with pending payment transactions are identified to help monitor transactions that may require further processing or confirmation.

Pending transactions can represent an operational risk because the associated order may not have reached a final payment state.

## 🔐 Day 66 Customer Payment Risk Classification

Customers are classified using a rule-based payment-risk framework:

| Customer Behavior                                     | Risk Classification |
| ----------------------------------------------------- | ------------------- |
| No significant payment issues                         | Low Risk            |
| At least one failed or pending transaction            | Medium Risk         |
| Two or more failed transactions OR failure rate ≥ 50% | High Risk           |

The classification is based on the payment behavior observed in the available dataset.

## 🎯 Day 66 High-Risk Customer Identification

High-risk customers are identified using:

* Number of failed transactions
* Customer payment failure rate

The analysis prioritizes customers with repeated failures or a high proportion of failed transactions.

This allows businesses to focus attention on customers showing stronger payment-related risk signals.

## 💼 Day 66 Business Applications

Customer payment behavior analysis can support:

* Payment monitoring
* Customer risk monitoring
* Payment failure investigation
* Payment recovery processes
* Customer support prioritization
* Payment method optimization
* Transaction monitoring
* Operational decision-making
* Customer experience improvement
* Business reporting

## 📊 Day 66 Business Priority Framework

### 🟢 Low-Risk Customers

Customers with stable successful payment behavior.

**Business focus:**

* Maintain normal payment processing
* Continue standard customer experience
* Monitor payment behavior periodically

### 🟡 Medium-Risk Customers

Customers with at least one failed or pending payment.

**Business focus:**

* Monitor payment activity
* Investigate unresolved transactions
* Provide payment assistance when required

### 🔴 High-Risk Customers

Customers with repeated payment failures or a failure rate of at least 50%.

**Business focus:**

* Prioritize investigation
* Monitor payment issues
* Consider payment recovery or support actions
* Identify possible payment-channel problems

## ⚠️ Day 66 Methodology Limitation

The analysis is based on the payment transactions available in the sales database.

The `payments` table does not contain a direct payment amount field, so this analysis focuses on payment transactions, payment statuses, payment methods, orders, and customer-level payment behavior.

The customer risk classification is a **rule-based business-analysis framework**.

It is not a machine-learning prediction or statistically validated credit-risk model.

Payment statuses must be interpreted according to the actual values present in the database.

Customer payment behavior may also change over time.

## 📁 Day 66 Project Files

```text
SQL/
└── customer_payment_behavior_risk_analysis.sql

Report/
└── Day66_Customer_Payment_Behavior_Risk_Analysis.md

Screenshots/
└── Day 66/
```

### 🏆 Day 66 Achievement

Customer Payment Behavior & Risk Analysis completed successfully. ✅

The analysis covered customer payment activity, payment success and failure rates, payment method preferences, repeated payment failures, pending payments, and rule-based customer payment risk classification.

**66 Days of continuous SQL business analysis completed. 🚀**

**Customer Payment Behavior & Risk Analysis completed successfully. 💳📊**

**66/66 Milestone Achieved. 🔥🏆**

---

# 📅 Daily Project Organization

| Day        | Main Work                                                            |
| ---------- | -------------------------------------------------------------------- |
| Day 1      | Database Fundamentals                                                |
| Day 2      | SQL Table & Data Operations                                          |
| Day 3      | Basic SQL Queries                                                    |
| Day 4      | SQL Filtering & Analysis                                             |
| Day 5      | SQL Aggregation                                                      |
| Day 6      | JOIN Operations                                                      |
| Day 7      | SQL Fundamentals Review                                              |
| Day 8      | Intermediate SQL                                                     |
| Day 9      | Stored Procedures                                                    |
| Day 10     | Advanced SQL                                                         |
| Day 11     | Views                                                                |
| Day 12     | Triggers                                                             |
| Day 13     | Indexes                                                              |
| Day 14     | Advanced Business Analysis                                           |
| Day 15     | Window Functions                                                     |
| Day 16     | CTEs                                                                 |
| Day 17     | Query Optimization & Business Analysis                               |
| Day 18     | Customer Analytics                                                   |
| Day 19     | Customer Behavior Analysis                                           |
| Day 20     | Customer Retention Analysis                                          |
| Day 21     | Customer Lifetime Value                                              |
| Day 22     | RFM Customer Segmentation                                            |
| Day 23     | Sales Trend Analysis                                                 |
| Day 24     | Product Performance Analysis                                         |
| Day 25     | Sales Profitability Analysis                                         |
| Day 26     | Customer Revenue Contribution                                        |
| Day 27     | Customer Churn Analysis                                              |
| Day 28     | Customer Cohort & Retention                                          |
| Day 29     | Customer Purchase Frequency                                          |
| Day 30     | Customer Segmentation & Revenue                                      |
| Day 31     | Product Purchase Behavior                                            |
| Day 32     | Product Customer Affinity                                            |
| Day 33     | Customer-Product Purchase Analysis                                   |
| Day 34     | Cross-Selling & Product Recommendation                               |
| Day 35     | Customer Purchase Journey & Basket                                   |
| Day 36     | Customer Lifetime Value & Revenue Contribution                       |
| Day 37     | Customer RFM Segmentation                                            |
| Day 38     | Customer Segment Performance                                         |
| Day 39     | Customer Segment Retention & Churn Risk                              |
| Day 40     | Customer Cohort & Retention Trend                                    |
| Day 41     | Customer Lifecycle & Repeat Purchase                                 |
| Day 42     | Customer Purchase Frequency & Repeat Behavior                        |
| Day 43     | Payment Status & Payment Method                                      |
| Day 44     | Customer Payment Behavior                                            |
| Day 45     | Customer Payment Risk & Pending Payments                             |
| Day 46     | Data Quality & Integrity                                             |
| Day 47     | Sales Performance KPI                                                |
| Day 48     | Sales Growth & Month-over-Month                                      |
| Day 49     | Sales Order Value & Basket                                           |
| Day 50     | Sales Revenue Forecasting                                            |
| Day 51     | Product Demand & Sales Forecasting                                   |
| Day 52     | Customer Repeat Purchase Prediction & Analysis                       |
| Day 53     | Customer Purchase Propensity Analysis                                |
| Day 54     | Customer Purchase Value & Basket Analysis                            |
| Day 55     | Customer Purchase Value Segmentation Analysis                        |
| Day 56     | Customer Revenue Contribution & Concentration Analysis               |
| Day 57     | Customer Revenue Concentration & Analysis                            |
| Day 58     | Customer Revenue Pareto & 80/20 Analysis                             |
| Day 59     | Customer Revenue Decile & Revenue Distribution Analysis              |
| Day 60     | Customer Revenue Quartile & Value Distribution Analysis              |
| Day 61     | Customer Revenue Quintile & Value Distribution Analysis              |
| Day 62     | Customer Revenue ABC Analysis                                        |
| Day 63     | Customer Revenue ABC Segment Performance Analysis                    |
| Day 64     | Customer Revenue ABC Segment Comparison & Business Priority Analysis |
| Day 65     | Payment Performance & Business Analysis                              |
| **Day 66** | **Customer Payment Behavior & Risk Analysis**                        |

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
Data Quality Analysis
      ↓
Sales Performance KPI
      ↓
Sales Growth Analysis
      ↓
Order Value & Basket Analysis
      ↓
Revenue Forecasting
      ↓
Product Demand Forecasting
      ↓
Customer Repeat Purchase Analysis
      ↓
Customer Purchase Propensity Analysis
      ↓
Customer Purchase Value & Basket Analysis
      ↓
Customer Value Segmentation
      ↓
Customer Revenue Contribution & Concentration
      ↓
Customer Revenue Pareto & 80/20 Analysis
      ↓
Customer Revenue Decile & Revenue Distribution
      ↓
Customer Revenue Quartile & Value Distribution
      ↓
Customer Revenue Quintile & Value Distribution
      ↓
Customer Revenue ABC Analysis
      ↓
ABC Segment Performance Analysis
      ↓
ABC Segment Comparison
      ↓
Business Priority Analysis
      ↓
Payment Performance Analysis
      ↓
Payment Risk Analysis
      ↓
Customer Payment Behavior Analysis
      ↓
Customer Payment Risk Classification
      ↓
Business Insights
```

---

# 📁 Project Structure

```text
Sales_Data_Analysis_SQL/

│
├── Database_Design/
│   └── sales_analysis.mwb
│
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
│   └── customer_payment_behavior_risk_analysis.sql
│
├── Screenshots/
│   ├── Day 1/
│   ├── Day 2/
│   ├── ...
│   ├── Day 63/
│   ├── Day 64/
│   ├── Day 65/
│   └── Day 66/
│
├── Presentation/
│
├── Report/
│   ├── Week1_Report.md
│   ├── Week2_Report.md
│   ├── ...
│   ├── Day57_Customer_Revenue_Concentration_Analysis.md
│   ├── Day58_Customer_Revenue_Pareto_Analysis.md
│   ├── Day59_Customer_Revenue_Decile_Analysis.md
│   ├── Day60_Customer_Revenue_Quartile_Analysis.md
│   ├── Day61_Customer_Revenue_Quintile_Analysis.md
│   ├── Day62_Customer_Revenue_ABC_Analysis.md
│   ├── Day63_Customer_Revenue_ABC_Segment_Performance.md
│   ├── Day64_Customer_Revenue_ABC_Segment_Comparison.md
│   ├── Day65_Payment_Performance_Business_Analysis.md
│   └── Day66_Customer_Payment_Behavior_Risk_Analysis.md
│
└── README.md
```

---

# 📌 Project Status

**Current Status: 🟢 Active**

**Completed: 66 Days**

**Primary Focus: SQL Data Analysis & Business Intelligence**

The project has completed 66 days of structured SQL learning and business analysis.

The project now covers database design, SQL fundamentals, advanced SQL, query optimization, customer analytics, product analytics, customer segmentation, RFM analysis, customer retention, churn analysis, cohort analysis, customer lifecycle analysis, repeat purchase analysis, purchase frequency analysis, payment analysis, payment performance analysis, payment status analysis, payment method analysis, payment trend analysis, payment risk analysis, customer payment behavior analysis, customer payment success and failure analysis, payment method preference analysis, repeated payment failure analysis, pending payment analysis, customer payment risk classification, data quality analysis, sales KPI analysis, sales growth analysis, order value analysis, basket analysis, revenue forecasting, product demand forecasting, customer repeat-purchase prediction, customer purchase propensity analysis, customer purchase value analysis, customer value segmentation, customer revenue ranking, customer revenue concentration, Pareto analysis, 80/20 revenue distribution analysis, customer revenue decile analysis, customer revenue distribution analysis, customer revenue quartile analysis, customer revenue quintile analysis, customer value distribution analysis, customer revenue ABC analysis, ABC segment performance analysis, ABC segment comparison, and ABC segment business priority analysis.

---

# 🚀 66-Day Portfolio Progress

**66 Days Completed 🚀**

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
Customer Segment Retention & Churn Risk
      ↓
Customer Cohort & Retention Trend Analysis
      ↓
Customer Lifecycle & Repeat Purchase Analysis
      ↓
Customer Purchase Frequency & Repeat Behavior Analysis
      ↓
Payment Analysis
      ↓
Data Quality & Integrity Analysis
      ↓
Sales Performance KPI Analysis
      ↓
Sales Growth & Month-over-Month Analysis
      ↓
Sales Order Value & Basket Analysis
      ↓
Sales Revenue Forecasting
      ↓
Product Demand & Sales Forecasting
      ↓
Customer Repeat Purchase Prediction
      ↓
Customer Purchase Propensity Analysis
      ↓
Customer Purchase Value & Basket Analysis
      ↓
Customer Purchase Value Segmentation
      ↓
Customer Revenue Contribution & Concentration
      ↓
Customer Revenue Pareto & 80/20 Analysis
      ↓
Customer Revenue Decile & Revenue Distribution Analysis
      ↓
Customer Revenue Quartile & Value Distribution Analysis
      ↓
Customer Revenue Quintile & Value Distribution Analysis
      ↓
Customer Revenue ABC Analysis
      ↓
Customer Revenue ABC Segment Performance Analysis
      ↓
Customer Revenue ABC Segment Comparison
      ↓
ABC Segment Business Priority Analysis
      ↓
Payment Performance Analysis
      ↓
Payment Status & Method Analysis
      ↓
Payment Trend & Risk Analysis
      ↓
Customer Payment Behavior Analysis
      ↓
Customer Payment Success & Failure Analysis
      ↓
Customer Payment Method Preference
      ↓
Repeated Payment Failure Analysis
      ↓
Customer Payment Risk Classification
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
* Customer payment risk dashboards
* Data quality monitoring dashboards
* Business performance monitoring

**Next Milestone: Day 67 🔥**

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

# 🎉 66-Day Milestone

**Day 66 is completed successfully. ✅**

**66 Days of continuous SQL business analysis completed. 🚀**

**Customer Payment Behavior & Risk Analysis completed successfully. 💳📊**

**Customer payment success, failure, payment method, repeated failure, pending payment, and customer payment risk analysis completed. 🎯**

**66/66 Milestone Achieved. 🔥🏆**

**Next target: Day 67. 🚀**
