# 📊 Day 35 — Customer Purchase Journey & Basket Analysis

## 📌 Overview

Day 35 focuses on understanding the complete **customer purchase journey** using SQL.

The analysis examines when customers first purchased, when they last purchased, how frequently they purchase, how many orders they place, their average order value, basket size, number of products purchased per order, and their overall purchasing behavior.

This analysis helps transform raw transaction data into actionable **Customer Analytics and Business Intelligence insights**.

---

# 🎯 Objectives

The main objectives of Day 35 are:

* Analyze customer purchase journeys
* Identify first and last purchase dates
* Calculate total orders per customer
* Measure average time between purchases
* Classify customers according to purchase frequency
* Calculate average order value
* Analyze customer basket size
* Measure average products purchased per order
* Identify one-time and repeat customers
* Classify customer purchasing behavior
* Analyze customer lifetime duration
* Calculate customer revenue contribution
* Build a customer purchase journey summary

---

# 🗄️ Database Used

**Database:** `sales_analysis_db`

---

# 📋 Tables Used

## Orders

Important columns:

* `order_id`
* `customer_id`
* `order_date`

## Order_Items

Important columns:

* `order_id`
* `product_id`
* `quantity`

## Products

Important columns:

* `product_id`
* `product_name`
* `price`

---

# 🔍 Day 35 Analysis

## 1. Customer Purchase Journey

Identifies each customer's:

* First purchase date
* Last purchase date
* Total number of orders

This provides an overview of the customer's relationship with the business.

---

## 2. First Purchase Date

Determines the earliest purchase date for every customer.

### Business Application

Helps identify:

* New customers
* Customer acquisition periods
* Customer onboarding patterns
* Customer tenure

---

## 3. Last Purchase Date

Identifies the most recent purchase made by each customer.

### Business Application

Useful for:

* Identifying active customers
* Detecting inactive customers
* Retention monitoring
* Future churn analysis

---

## 4. Total Orders per Customer

Calculates the total number of unique orders placed by every customer.

### Business Application

Customers with more orders generally show stronger engagement with the business.

---

## 5. Average Days Between Purchases

Uses the SQL `LAG()` window function to compare consecutive purchases and calculate the average number of days between purchases.

### Business Application

Helps understand customer purchasing frequency and identify customers who purchase regularly.

---

## 6. Purchase Frequency Classification

Customers are classified into:

* One-Time Customer
* Occasional Customer
* Regular Customer
* Frequent Customer

### Business Application

This segmentation can support targeted marketing and retention campaigns.

---

## 7. Average Order Value

Calculates the average value of each customer's orders.

### Business Application

Helps identify customers who generate higher-value transactions.

---

## 8. Customer Basket Size

Measures the average number of items purchased per order.

### Business Application

Useful for:

* Bundle strategies
* Cross-selling
* Upselling
* Product recommendations

---

## 9. Average Products per Order

Measures the average number of unique products included in each customer's order.

### Business Application

Helps identify customers with diverse purchasing behavior.

---

## 10. Repeat Purchase Analysis

Customers are divided into:

* One-Time Customers
* Repeat Customers

### Business Application

Repeat customers are important for retention and long-term revenue growth.

---

## 11. Customer Purchase Behavior Classification

Customers are classified into:

* One-Time
* Developing
* Loyal
* Highly Engaged

The classification is based on purchasing frequency.

### Business Application

This provides a simple framework for customer relationship management.

---

## 12. Customer Purchase Journey Business Summary

The final analysis combines:

* Customer ID
* Total orders
* First purchase date
* Last purchase date
* Customer lifetime days
* Average order value
* Total customer revenue
* Customer segment

This creates a complete customer purchase journey view.

---

# 🧠 SQL Concepts Used

Day 35 demonstrates the following SQL concepts:

* `SELECT`
* `FROM`
* `JOIN`
* `GROUP BY`
* `ORDER BY`
* `COUNT`
* `COUNT(DISTINCT)`
* `SUM`
* `AVG`
* `MIN`
* `MAX`
* `ROUND`
* `DATEDIFF`
* `CASE`
* Common Table Expressions (`WITH`)
* Window Functions
* `LAG()`
* Customer Segmentation
* Aggregation
* Date Analysis
* Revenue Analysis

---

# 📊 Analytical Approach

The analysis follows this process:

```text
Orders
   ↓
Customer Purchase History
   ↓
First & Last Purchase
   ↓
Purchase Frequency
   ↓
Purchase Gaps
   ↓
Basket Analysis
   ↓
Order Value Analysis
   ↓
Repeat Purchase Analysis
   ↓
Customer Segmentation
   ↓
Business Summary
```

---

# 💡 Business Insights

The analysis can help businesses understand:

### Customer Engagement

Identify customers who purchase frequently and consistently.

### Customer Retention

Identify repeat customers and monitor their purchasing activity.

### Customer Lifetime

Measure the duration of the customer's relationship with the business.

### Revenue Contribution

Identify customers generating higher total revenue.

### Basket Behavior

Understand how many products customers typically purchase in an order.

### Marketing Opportunities

Create different marketing strategies for one-time, occasional, regular, and frequent customers.

---

# 📈 Customer Strategy

### One-Time Customers

Target with:

* Welcome-back campaigns
* Discount offers
* Personalized recommendations

### Occasional Customers

Target with:

* Product reminders
* Cross-selling campaigns
* Limited-time offers

### Regular Customers

Target with:

* Loyalty rewards
* Personalized offers
* Bundle promotions

### Frequent Customers

Target with:

* VIP programs
* Premium offers
* Exclusive products
* Early access campaigns

---

# 📁 Project Files

### SQL

```text
SQL/customer_purchase_journey_analysis.sql
```

### Report

```text
Report/Day35_Customer_Purchase_Journey_Analysis.md
```

### Screenshots

```text
Screenshots/Day 35/
```

---

# 📸 Screenshot Checklist

Capture the MySQL output for:

```text
Query_01.png
Query_02.png
Query_03.png
Query_04.png
Query_05.png
Query_06.png
Query_07.png
Query_08.png
Query_09.png
Query_10.png
Query_11.png
Query_12.png
```

Store them inside:

```text
Screenshots/Day 35/
```

---

# 🏆 Day 35 Outcome

Successfully analyzed the customer purchase journey using SQL.

The analysis demonstrates the ability to combine transaction-level data with customer-level metrics to understand:

* Purchase frequency
* Customer lifetime
* Repeat purchasing
* Basket behavior
* Order value
* Customer segmentation
* Revenue contribution

---

# 🚀 Skills Demonstrated

* SQL Analytics
* Customer Analytics
* Purchase Journey Analysis
* Customer Segmentation
* Date Analysis
* Window Functions
* CTEs
* Revenue Analysis
* Basket Analysis
* Retention Analysis
* Business Intelligence
* Data-Driven Decision Making

---

# ✅ Day 35 Status

**Completed — Customer Purchase Journey & Basket Analysis**

The project now contains **35 Days of SQL Business Analysis**.
