# Day 28 — Customer Cohort & Retention Analysis

## 📊 Project

**Sales Data Analysis Using SQL**

**Day:** 28
**Topic:** Customer Cohort & Retention Analysis
**Database:** MySQL 8.0

---

## 🎯 Objective

The objective of Day 28 is to analyze customer retention and purchasing behavior using cohort analysis.

The analysis identifies when customers first purchased, groups customers into cohorts, tracks their activity over subsequent months, and measures customer retention.

The analysis also identifies one-time, repeat, and loyal customers.

---

## 🧠 Concepts Covered

* Customer first purchase analysis
* Cohort identification
* Cohort month calculation
* Monthly customer activity
* Customer retention analysis
* Cohort retention rate
* Month 0 retention
* Month 1 retention
* Month 2 retention
* Repeat customer analysis
* One-time customer analysis
* Customer retention segmentation
* Customer purchasing frequency
* CTEs
* Date functions
* TIMESTAMPDIFF()
* DATE_FORMAT()
* COUNT(DISTINCT)
* CASE statements
* Aggregation
* Business reporting

---

## 🔍 Analysis Performed

### 1. Customer First Purchase

Identified the first purchase date for every customer.

This provides the foundation for assigning customers to cohorts.

### 2. Customer Cohort Assignment

Customers were grouped according to the month of their first purchase.

For example:

```text
2025-01
2025-02
2025-03
```

Each group represents customers who started purchasing during that month.

### 3. Monthly Customer Activity

Tracked the months in which each customer placed an order.

This allows customer activity to be compared against the customer's original cohort.

### 4. Cohort Retention

Measured how many customers from each cohort remained active in subsequent months.

The retention rate is calculated by comparing active customers with the original cohort size.

### 5. Repeat Customer Analysis

Customers with more than one order were identified as repeat customers.

### 6. One-Time Customer Analysis

Customers with exactly one order were identified as one-time customers.

### 7. Retention Segmentation

Customers were classified into:

* One-Time Customer
* Repeat Customer
* Loyal Customer

---

## 📈 Key Business Metrics

The analysis produces the following metrics:

| Metric                      | Description                                     |
| --------------------------- | ----------------------------------------------- |
| Cohort Size                 | Number of customers in a cohort                 |
| Active Customers            | Customers active in a particular month          |
| Retention Rate              | Percentage of cohort customers remaining active |
| Month 0 Retention           | Initial cohort activity                         |
| Month 1 Retention           | Customers retained after one month              |
| Month 2 Retention           | Customers retained after two months             |
| Repeat Customer Rate        | Percentage of customers with multiple orders    |
| Average Orders per Customer | Average purchasing frequency                    |

---

## 💼 Business Value

Cohort analysis helps businesses understand customer behavior over time.

It can be used to:

* Identify customer retention trends
* Measure repeat purchasing behavior
* Identify strong customer cohorts
* Detect customer drop-off
* Compare retention across acquisition periods
* Improve customer engagement strategies
* Develop customer retention programs
* Identify loyal customers
* Support customer lifecycle management

---

## 🧮 SQL Techniques Used

The Day 28 analysis uses:

```sql
WITH
DATE_FORMAT()
TIMESTAMPDIFF()
COUNT()
COUNT(DISTINCT)
GROUP BY
HAVING
CASE
JOIN
MIN()
MAX()
```

---

## 📂 Files Created

```text
SQL/
└── customer_cohort_analysis.sql

Report/
└── Day28_Customer_Cohort_Analysis.md

Screenshots/
└── Day 28/
```

---

## 🏆 Day 28 Outcome

Day 28 expanded the project from customer churn analysis into deeper customer lifecycle analytics.

The project now covers:

**Customer Revenue → Customer Behavior → Retention → Lifetime Value → RFM Segmentation → Customer Churn → Cohort & Retention Analysis**

This strengthens the project's relevance to Data Analyst and Business Analyst roles by demonstrating practical customer lifecycle and retention analytics using SQL.
