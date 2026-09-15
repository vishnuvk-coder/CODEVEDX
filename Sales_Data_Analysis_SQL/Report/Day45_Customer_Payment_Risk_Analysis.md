# Day 45 — Customer Payment Risk & Pending Payment Analysis

## 1. Introduction

Day 45 focuses on analyzing customer payment risks using MySQL.

The analysis examines payment statuses, payment methods, monthly payment activity, pending payments, failed payments, repeated payment records, and customer-level payment behavior.

The main purpose is to identify payment-related issues and support better payment monitoring and business decision-making.

> **Note:** The `payments` table does not contain a payment amount column. Therefore, this project focuses on payment records, payment statuses, payment methods, and risk indicators instead of payment revenue.

---

## 2. Objectives

* Identify all payment statuses available in the database.
* Analyze payment status distribution.
* Analyze payment method usage.
* Compare payment methods and payment statuses.
* Study monthly payment activity.
* Analyze monthly payment statuses.
* Analyze monthly payment methods.
* Identify pending payments.
* Identify failed payments.
* Find orders with multiple payment records.
* Analyze payment behavior at customer level.
* Classify customer payment risk.

---

## 3. Database Tables Used

### `payments`

The following columns were used:

* `payment_id`
* `order_id`
* `payment_date`
* `payment_method`
* `payment_status`

### `orders`

The following columns were used:

* `order_id`
* `customer_id`
* `order_date`

The tables were joined using:

```sql
payments.order_id = orders.order_id
```

---

## 4. SQL Concepts Used

The following SQL concepts were used in this analysis:

* `USE`
* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `INNER JOIN`
* `COUNT()`
* `COUNT(DISTINCT)`
* `CASE`
* `LOWER()`
* `DATE_FORMAT()`
* `MIN()`
* `MAX()`
* Common Table Expressions
* Customer-level aggregation
* Payment status analysis
* Payment method analysis
* Monthly payment analysis
* Risk classification

---

## 5. Analyses Performed

### Query 1: Identify All Payment Statuses

Identified the different payment statuses available in the `payments` table.

This helps understand the possible payment conditions in the database.

### Query 2: Payment Status Distribution

Calculated the total number and percentage of payment records for each payment status.

This helps identify the most common payment statuses.

### Query 3: Payment Method Distribution

Analyzed the usage of different payment methods.

This helps identify the payment methods most frequently used by customers.

### Query 4: Payment Status by Payment Method

Compared payment statuses across different payment methods.

This helps identify whether certain payment methods have more pending or failed records.

### Query 5: Monthly Payment Activity

Analyzed the total number of payment records and orders for each month.

This helps identify monthly payment activity patterns.

### Query 6: Monthly Payment Status Analysis

Analyzed payment statuses across different months.

This helps monitor changes in pending, failed, completed, or other payment statuses over time.

### Query 7: Monthly Payment Method Analysis

Analyzed payment method usage on a monthly basis.

This helps identify changes in customer payment preferences.

### Query 8: Pending Payment Analysis

Identified payment records whose status was marked as pending.

This helps businesses follow up on payments that may require additional action.

### Query 9: Failed Payment Analysis

Identified payment records whose status was marked as failed.

This helps businesses investigate payment failures and possible customer issues.

### Query 10: Orders with Multiple Payment Records

Identified orders associated with more than one payment record.

Multiple payment records may indicate repeated payment attempts, retries, or payment-processing issues.

### Query 11: Customer-Level Payment Risk Analysis

Analyzed each customer’s:

* Total payment records
* Total orders
* Pending payment count
* Failed payment count
* First payment date
* Last payment date

This helps identify customers who may require payment-related attention.

### Query 12: Final Customer Payment Risk Classification

Classified customers into different payment activity and risk categories based on pending payments, failed payments, and total payment records.

---

## 6. Customer Payment Risk Categories

| Category                 | Description                                   |
| ------------------------ | --------------------------------------------- |
| High Payment Risk        | Customer has both pending and failed payments |
| Failed Payment Risk      | Customer has at least one failed payment      |
| Pending Payment Risk     | Customer has at least one pending payment     |
| High Payment Activity    | Customer has 10 or more payment records       |
| Regular Payment Activity | Customer has 5–9 payment records              |
| Low Payment Activity     | Customer has fewer than 5 payment records     |

---

## 7. Business Applications

This analysis can help businesses to:

* Monitor pending payment records.
* Identify failed payment records.
* Detect customers with repeated payment issues.
* Understand customer payment preferences.
* Analyze payment method usage.
* Monitor monthly payment activity.
* Identify orders with multiple payment attempts.
* Improve payment follow-up processes.
* Identify customers requiring payment support.
* Improve payment operations.
* Support business reporting and decision-making.

---

## 8. Key Learning Outcomes

After completing Day 45, the following skills were strengthened:

* Payment data analysis
* Payment status monitoring
* Payment method analysis
* Monthly payment trend analysis
* Customer-level aggregation
* Customer payment risk classification
* Common Table Expressions
* SQL joins
* Grouping and filtering
* Repeated payment analysis
* Business-oriented SQL reporting

---

## 9. Project Files

```text
SQL/payment_risk_pending_analysis.sql
Report/Day45_Customer_Payment_Risk_Analysis.md
Screenshots/Day 45/
```

The screenshots contain the outputs of the twelve SQL queries executed in MySQL Workbench.

---

## 10. Conclusion

Day 45 demonstrated how SQL can be used to analyze customer payment behavior and identify possible payment risks.

The analysis focused on payment statuses, payment methods, monthly payment activity, pending payments, failed payments, repeated payment records, and customer-level payment behavior.

These insights can help businesses improve payment monitoring, identify operational problems, and provide better customer payment support.
