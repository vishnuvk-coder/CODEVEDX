# 📊 Day 68 — Payment Method Trend & Reliability Analysis

Day 68 focused on **Payment Method Trend & Reliability Analysis** using MySQL.

The analysis evaluates payment-method usage over time, monthly transaction activity, customer adoption, payment success and failure behavior, pending transactions, payment-method performance rankings, reliability, and month-over-month payment-method growth.

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
* Payment-method reliability
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

The analysis also measures the number of unique orders associated with each payment method every month.

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
