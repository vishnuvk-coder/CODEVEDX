# Day 44 — Customer Payment Behavior Analysis

## 1. Introduction

Day 44 focuses on analyzing **customer payment behavior** using MySQL. The purpose of this analysis is to understand customer-level payment activity, payment method usage, payment status distribution, and payment-related issues.

This analysis uses the `payments` and `orders` tables to generate useful business insights.

The analysis does not use payment amount because the `payments` table does not contain a payment amount column.

---

## 2. Project Objectives

The main objectives of this analysis are:

* Calculate the total number of payments made by each customer.
* Identify the payment methods used by customers.
* Analyze payment status distribution by customer.
* Identify customers using multiple payment methods.
* Find customers with pending payments.
* Find customers with failed payments.
* Analyze customer payment activity by month.
* Identify the most frequently used payment method by customer.
* Rank customers according to payment activity.
* Classify customer payment behavior.
* Identify customers with payment-related issues.
* Generate a final customer payment behavior summary.

---

## 3. Database Used

```sql
USE sales_analysis_db;
```

---

## 4. Tables Used

### 4.1 Payments Table

The `payments` table contains payment transaction information.

Important columns include:

* `payment_id`
* `order_id`
* `payment_date`
* `payment_method`
* `payment_status`

### 4.2 Orders Table

The `orders` table contains order and customer information.

Important columns include:

* `order_id`
* `customer_id`
* `order_date`

The `orders` table is joined with the `payments` table using the `order_id` column.

---

## 5. Analysis Performed

### Query 1: Total Payments per Customer

This analysis calculates the total number of payment transactions associated with each customer.

It helps identify customers with high and low payment activity.

**Business Use:**

* Identify customers with frequent payment activity.
* Understand customer transaction volume.
* Support customer payment behavior analysis.

---

### Query 2: Payment Methods Used by Each Customer

This analysis identifies the number of different payment methods used by each customer.

It also displays the payment methods used by individual customers.

**Business Use:**

* Understand customer payment preferences.
* Identify customers using multiple payment methods.
* Improve payment method support.

---

### Query 3: Customer Payment Status Distribution

This analysis shows the number of payments for each payment status per customer.

It helps identify how customer payments are distributed across different statuses.

**Business Use:**

* Monitor customer payment statuses.
* Identify customers with different payment outcomes.
* Support payment transaction reporting.

---

### Query 4: Customers Using Multiple Payment Methods

This analysis identifies customers who use more than one payment method.

**Business Use:**

* Understand flexible payment behavior.
* Identify customers with multiple payment preferences.
* Support payment method personalization.

---

### Query 5: Customers with Pending Payments

This analysis identifies customers who have pending payment transactions.

**Business Use:**

* Monitor pending transactions.
* Identify customers requiring payment follow-up.
* Support payment issue resolution.

---

### Query 6: Customers with Failed Payments

This analysis identifies customers who have failed payment transactions.

**Business Use:**

* Detect payment failures.
* Identify possible transaction problems.
* Improve customer payment support.

---

### Query 7: Customer Payment Activity by Month

This analysis calculates the number of payment transactions made by each customer month by month.

**Business Use:**

* Understand monthly customer payment activity.
* Identify changes in payment behavior.
* Support monthly transaction reporting.

---

### Query 8: Most Frequently Used Payment Method by Customer

This analysis identifies the most frequently used payment method for each customer.

**Business Use:**

* Understand customer payment preferences.
* Identify the preferred payment method.
* Improve payment experience and convenience.

---

### Query 9: Customers with the Highest Number of Payments

This analysis ranks customers according to their total number of payment transactions.

**Business Use:**

* Identify high-activity customers.
* Compare customer payment activity.
* Support customer transaction ranking.

---

### Query 10: Customer Payment Behavior Classification

Customers are classified according to their total payment activity.

The classification includes:

| Payment Activity    | Customer Category              |
| ------------------- | ------------------------------ |
| 1 payment           | Single Payment Customer        |
| 2–4 payments        | Occasional Payment Customer    |
| 5–9 payments        | Regular Payment Customer       |
| 10 or more payments | High Activity Payment Customer |

**Business Use:**

* Group customers according to payment activity.
* Understand customer transaction behavior.
* Support customer segmentation.

---

### Query 11: Customer Payment Activity Ranking

This analysis ranks customers according to the total number of payments and the number of payment methods used.

**Business Use:**

* Identify customers with high payment activity.
* Compare payment behavior between customers.
* Support customer-level reporting.

---

### Query 12: Final Customer Payment Behavior Summary

This analysis combines multiple customer payment metrics into one summary.

The final summary includes:

* Customer ID
* Total payments
* Number of payment methods used
* Number of payment statuses
* First payment date
* Last payment date
* Pending payment count
* Failed payment count
* Final payment behavior category

**Business Use:**

* Create a complete customer payment profile.
* Identify payment-related issues.
* Monitor customer payment activity.
* Support business decision-making.

---

## 6. SQL Concepts Used

The following SQL concepts were used in this project:

* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `JOIN`
* `COUNT()`
* `COUNT(DISTINCT)`
* `MIN()`
* `MAX()`
* `SUM()`
* `CASE`
* `LOWER()`
* `DATE_FORMAT()`
* `GROUP_CONCAT()`
* Common Table Expressions
* `RANK()`
* `DENSE_RANK()`
* Window functions
* Customer-level aggregation
* Monthly transaction analysis
* Payment status classification
* Payment method comparison

---

## 7. Customer Payment Behavior Categories

Customer payment behavior was classified into the following categories:

### Single Payment Customer

A customer with only one payment transaction.

### Occasional Payment Customer

A customer with two to four payment transactions.

### Regular Payment Customer

A customer with five to nine payment transactions.

### High Activity Payment Customer

A customer with ten or more payment transactions.

These categories help compare customer payment activity and identify customers with higher transaction frequency.

---

## 8. Business Insights

This analysis can help businesses understand:

* Which customers make the highest number of payments.
* Which payment methods are used most frequently.
* Which customers use multiple payment methods.
* Which customers have pending payments.
* Which customers have failed payments.
* How payment activity changes monthly.
* Which customers have high payment activity.
* Which customers may require payment-related support.
* How customer payment behavior differs across customers.

---

## 9. Business Applications

The results of this analysis can be used for:

* Customer payment behavior analysis
* Payment transaction monitoring
* Payment method optimization
* Payment issue identification
* Pending payment follow-up
* Failed payment monitoring
* Customer support improvement
* Payment process improvement
* Operational reporting
* Business intelligence
* Customer transaction segmentation

---

## 10. Project Files

The project contains the following files:

```text
SQL/customer_payment_behavior_analysis.sql
Report/Day44_Customer_Payment_Behavior_Analysis.md
Screenshots/Day 44/
```

The `Screenshots/Day 44/` folder contains screenshots of the outputs of all 12 SQL queries.

---

## 11. Conclusion

Day 44 successfully focuses on **Customer Payment Behavior Analysis** using MySQL.

The analysis provides customer-level insights into payment frequency, payment method usage, payment status distribution, pending payments, failed payments, and payment activity classification.

These insights can help businesses improve payment monitoring, understand customer transaction behavior, and support better operational decision-making.
