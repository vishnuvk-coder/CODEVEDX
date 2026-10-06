# 📊 Day 66 — Customer Payment Behavior & Risk Analysis

Day 66 focused on **Customer Payment Behavior & Risk Analysis** using MySQL.

The analysis evaluates customer-level payment activity, successful and unsuccessful payments, payment method usage, repeated payment failures, pending payments, and customer payment risk classification.

## 🎯 Objective

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

## 🔍 Key Analyses

* Customer Payment Transaction Count
* Customers with Successful Payments
* Customers with Failed Payments
* Customers with Pending Payments
* Customer Payment Success Rate
* Customer Payment Failure Rate
* Payment Method Preference by Customer
* Customers Using Multiple Payment Methods
* Customers with Repeated Payment Failures
* Customers with Pending Payments
* Customer Payment Risk Classification
* High-Risk Customer Identification
* Customer Payment Status Distribution
* Customer Payment Method and Status Analysis
* Final Customer Payment Behavior Summary

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

## 💳 Customer Payment Behavior

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

## 📈 Payment Success Rate

The customer payment success rate is calculated as the percentage of successful payment transactions compared with the customer's total payment transactions.

This metric helps identify customers with consistently successful payment activity.

## ⚠️ Payment Failure Rate

The customer payment failure rate measures the percentage of failed payment transactions compared with the customer's total payment transactions.

A higher failure rate may indicate payment friction, repeated transaction issues, or the need for operational follow-up.

## 💳 Payment Method Preference

Customer payment methods are analyzed to understand:

* Which payment methods customers use
* How frequently each method is used
* Customers who use multiple payment methods
* Payment method and payment-status combinations

This can help businesses understand customer payment-channel preferences.

## 🚨 Repeated Payment Failure Analysis

Customers with multiple failed payment transactions are identified separately.

Customers with repeated payment failures may require additional investigation because repeated failures can create:

* Payment friction
* Order-processing issues
* Customer dissatisfaction
* Operational follow-up requirements

## ⏳ Pending Payment Analysis

Customers with pending payment transactions are identified to help monitor transactions that may require further processing or confirmation.

Pending transactions can represent an operational risk because the associated order may not have reached a final payment state.

## 🔐 Customer Payment Risk Classification

Customers are classified using a rule-based payment-risk framework:

| Customer Behavior                                     | Risk Classification |
| ----------------------------------------------------- | ------------------- |
| No significant payment issues                         | Low Risk            |
| At least one failed or pending transaction            | Medium Risk         |
| Two or more failed transactions OR failure rate ≥ 50% | High Risk           |

The classification is based on the payment behavior observed in the available dataset.

## 🎯 High-Risk Customer Identification

High-risk customers are identified using:

* Number of failed transactions
* Customer payment failure rate

The analysis prioritizes customers with repeated failures or a high proportion of failed transactions.

This allows businesses to focus attention on customers showing stronger payment-related risk signals.

## 💼 Business Applications

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

## 📊 Business Priority Framework

The analysis can support the following operational approach:

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

## ⚠️ Methodology Limitation

The analysis is based on the payment transactions available in the sales database.

The `payments` table does not contain a direct payment amount field, so this analysis focuses on payment transactions, payment statuses, payment methods, orders, and customer-level payment behavior.

The customer risk classification is a **rule-based business-analysis framework**.

It is not a machine-learning prediction or statistically validated credit-risk model.

Payment statuses must be interpreted according to the actual values present in the database.

Customer payment behavior may also change over time.

## 📁 Project Files

```text
SQL/
└── customer_payment_behavior_risk_analysis.sql

Report/
└── Day66_Customer_Payment_Behavior_Risk_Analysis.md

Screenshots/
└── Day 66/
```

## 🏆 Day 66 Achievement

Customer Payment Behavior & Risk Analysis completed successfully. ✅

The analysis covered customer payment activity, payment success and failure rates, payment method preferences, repeated payment failures, pending payments, and rule-based customer payment risk classification.

**66 Days of continuous SQL business analysis completed. 🚀**

**Customer Payment Behavior & Risk Analysis completed successfully. 💳📊**

**66/66 Milestone Achieved. 🔥🏆**
