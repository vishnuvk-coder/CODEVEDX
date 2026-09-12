# Day 42 — Customer Purchase Frequency & Repeat Behavior Analysis

## Project

**Sales Data Analysis Using SQL**

## Objective

The objective of Day 42 is to analyze customer purchase frequency and repeat purchasing behavior.

This analysis focuses on how often customers place orders, how frequently they return, the time between purchases, high-frequency customers, low-frequency customers, and the relationship between purchase frequency and customer revenue.

---

## Dataset

Database:

```sql
sales_analysis_db
```

Main tables used:

* `orders`
* `order_items`
* `products`

Revenue is calculated using:

```sql
order_items.quantity * products.price
```

---

# Analysis Performed

## 1. Customer Purchase Frequency

Calculated the total number of orders placed by each customer.

### SQL Concepts

* `COUNT()`
* `COUNT(DISTINCT)`
* `GROUP BY`

### Business Use

Helps identify customers who purchase frequently and customers who purchase only once.

### Screenshot

`Screenshots/Day 42/Query_01.png`

---

## 2. Orders per Month per Customer

Analyzed the number of orders each customer places during each month.

### SQL Concepts

* `DATE_FORMAT()`
* `COUNT(DISTINCT)`
* `GROUP BY`

### Business Use

Helps identify monthly purchasing patterns and changes in customer engagement.

### Screenshot

`Screenshots/Day 42/Query_02.png`

---

## 3. Average Days Between Purchases

Calculated the average number of days between consecutive purchases for each customer.

### SQL Concepts

* `LAG()`
* `DATEDIFF()`
* Window functions
* `AVG()`

### Business Use

Helps estimate the typical time customers take before making another purchase.

### Screenshot

`Screenshots/Day 42/Query_03.png`

---

## 4. Repeat Purchase Rate

Calculated the percentage of customers who placed more than one order.

### SQL Concepts

* CTE
* `COUNT()`
* `SUM()`
* `CASE`
* Percentage calculation

### Business Use

Repeat purchase rate is an important indicator of customer retention and engagement.

### Screenshot

`Screenshots/Day 42/Query_04.png`

---

## 5. Purchase Interval Distribution

Grouped customer purchase intervals into:

* 0–7 Days
* 8–30 Days
* 31–60 Days
* 61–90 Days
* 90+ Days

### SQL Concepts

* `LAG()`
* `DATEDIFF()`
* `CASE`
* CTE
* `GROUP BY`

### Business Use

Helps understand how quickly customers return and supports campaign timing decisions.

### Screenshot

`Screenshots/Day 42/Query_05.png`

---

## 6. High-Frequency Customers

Identified customers with 7 or more orders.

### Business Use

These customers demonstrate strong purchasing engagement and can be targeted for loyalty programs, premium offers, and personalized campaigns.

### Screenshot

`Screenshots/Day 42/Query_06.png`

---

## 7. Low-Frequency Customers

Identified customers with two or fewer orders.

### Business Use

These customers can be targeted with re-engagement, follow-up, and repeat-purchase campaigns.

### Screenshot

`Screenshots/Day 42/Query_07.png`

---

## 8. Customer Purchase Frequency Classification

Customers were classified into four groups:

| Category   | Orders |
| ---------- | -----: |
| One-Time   |      1 |
| Occasional |    2–3 |
| Regular    |    4–6 |
| Frequent   |     7+ |

### Business Use

This classification makes it easier to segment customers according to purchasing behavior.

### Screenshot

`Screenshots/Day 42/Query_08.png`

---

## 9. Frequency Category Distribution

Calculated the number and percentage of customers belonging to each purchase-frequency category.

### Business Use

Helps understand the overall distribution of customer purchasing behavior.

### Screenshot

`Screenshots/Day 42/Query_09.png`

---

## 10. Purchase Frequency vs Revenue

Compared customer purchase-frequency categories with total revenue and average customer revenue.

### SQL Concepts

* CTEs
* `JOIN`
* `SUM()`
* `AVG()`
* `CASE`
* Aggregation

### Business Use

Helps determine whether more frequent customers contribute more revenue and identifies the most valuable purchasing groups.

### Screenshot

`Screenshots/Day 42/Query_10.png`

---

## 11. Top Customers by Purchase Frequency

Ranked customers according to the number of orders they placed.

### SQL Concepts

* `RANK()`
* Window functions
* CTE

### Business Use

Helps identify highly engaged customers who may be suitable for loyalty programs and retention initiatives.

### Screenshot

`Screenshots/Day 42/Query_11.png`

---

## 12. Final Customer Purchase Frequency Summary

Created a customer-level summary containing:

* Customer ID
* Total orders
* First purchase date
* Last purchase date
* Customer lifetime duration
* Total revenue
* Average order value
* Purchase-frequency category

### Business Use

This final dataset provides a consolidated view of customer purchasing behavior and can support customer segmentation, retention, CRM, and revenue analysis.

### Screenshot

`Screenshots/Day 42/Query_12.png`

---

# SQL Skills Practiced

During Day 42, the following SQL concepts were practiced:

* `USE`
* `SELECT`
* `FROM`
* `JOIN`
* `GROUP BY`
* `ORDER BY`
* `WHERE`
* `COUNT()`
* `COUNT(DISTINCT)`
* `SUM()`
* `AVG()`
* `MIN()`
* `MAX()`
* `ROUND()`
* `DATEDIFF()`
* `DATE_FORMAT()`
* `CASE`
* CTEs
* `LAG()`
* `RANK()`
* Window functions
* Customer-level aggregation
* Revenue calculation
* Percentage calculation
* Customer frequency classification

---

# Business Insights

Day 42 demonstrates how SQL can be used to understand customer purchasing behavior.

The analysis can help businesses:

* Identify frequent customers
* Identify one-time customers
* Measure repeat purchase behavior
* Understand purchase intervals
* Improve customer retention
* Build loyalty programs
* Design re-engagement campaigns
* Identify high-value purchasing groups
* Understand frequency versus revenue
* Improve customer segmentation
* Support CRM strategies
* Improve personalized marketing

---

# Key Learning

Customer purchase frequency is an important indicator of customer engagement.

A customer who purchases frequently may have stronger loyalty and higher long-term value, while a one-time or low-frequency customer may require targeted re-engagement.

Combining purchase frequency with revenue provides a stronger understanding of customer value than looking at order count alone.

---

# Project Progress

**Day 42 / 55 Completed**

Next milestone:

**Day 43 → 43/55 🔥**
