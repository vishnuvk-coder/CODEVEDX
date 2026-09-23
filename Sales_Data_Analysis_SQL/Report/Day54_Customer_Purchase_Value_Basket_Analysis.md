📊 Day 54 — Customer Purchase Value & Basket Analysis
📌 Overview

Day 54 focuses on analyzing customer purchase value and basket behavior using SQL.

The analysis examines customer order volume, total units purchased, revenue contribution, average order value, average basket size, maximum and minimum order values, spending behavior, basket classification, purchase value scoring, and customer ranking.

This analysis transforms transactional sales data into customer-level purchasing insights that can support customer segmentation and business decision-making.

🎯 Objectives

The main objectives of Day 54 are:

Calculate total orders per customer.
Calculate total units purchased per customer.
Calculate total revenue per customer.
Calculate average order value.
Calculate average items purchased per order.
Identify maximum order value.
Identify minimum order value.
Classify customers according to basket size.
Classify customers according to spending level.
Create a rule-based purchase value score.
Rank customers based on purchase value.
Create a final customer purchase value summary.
🔎 Analyses Performed
1. Total Orders per Customer

Calculated the total number of unique orders placed by each customer.

SQL Concepts
COUNT(DISTINCT)
GROUP BY
Business Purpose

Helps identify customers with different levels of purchasing activity.

2. Total Units Purchased per Customer

Calculated the total number of product units purchased by each customer.

SQL Concepts
SUM()
JOIN
GROUP BY
Business Purpose

Shows the overall quantity of products purchased by each customer.

3. Total Revenue per Customer

Calculated total customer revenue using:

Revenue = Quantity × Product Price

The calculation uses:

order_items.quantity
products.price
Business Purpose

Helps identify customers contributing different amounts of revenue.

4. Average Order Value per Customer

Calculated the average revenue generated per order for each customer.

Average Order Value = Total Revenue / Total Orders

NULLIF() was used to prevent division-by-zero errors.

Business Purpose

Average Order Value helps understand the typical monetary value of a customer's purchase.

5. Average Items per Order

Calculated the average number of product units purchased in each order.

Business Purpose

This metric helps understand the typical size of a customer's purchase basket.

6. Maximum Order Value

Identified the highest-value individual order placed by each customer.

SQL Concept
MAX()
Business Purpose

Helps identify customers who have made particularly large purchases.

7. Minimum Order Value

Identified the lowest-value individual order placed by each customer.

SQL Concept
MIN()
Business Purpose

Helps understand the lower end of each customer's purchasing behavior.

🛒 8. Customer Basket Size Classification

Customers were classified according to their average number of items purchased per order.

Average Items per Order	Classification
< 2	Small Basket
2–4	Medium Basket
5–9	Large Basket
10+	Very Large Basket
Business Purpose

This classification provides a simple way to identify customers based on typical basket size.

💰 9. Customer Spending Classification

Customers were classified according to total revenue.

Total Revenue	Classification
< ₹1,000	Low Spender
₹1,000–₹4,999.99	Moderate Spender
₹5,000–₹9,999.99	High Spender
₹10,000+	Very High Spender
Business Purpose

This segmentation provides a straightforward view of customer spending levels.

⭐ 10. Customer Purchase Value Score

A rule-based purchase value score was created using two customer-level metrics:

Average Order Value
Average Items per Order
Average Order Value Score
Average Order Value	Score
₹10,000+	4
₹5,000–₹9,999	3
₹2,500–₹4,999	2
Below ₹2,500	1
Basket Score
Average Items per Order	Score
10+	4
5–9	3
2–4	2
Below 2	1
Final Score
Purchase Value Score
=
AOV Score + Basket Score

The maximum possible score is:

8
🏆 11. Customer Purchase Value Ranking

Customers were ranked according to their purchase value score.

The analysis uses the SQL window function:

RANK() OVER (
    ORDER BY purchase_value_score DESC
)
Business Purpose

Ranking makes it possible to compare customers according to their purchase-value characteristics.

📋 12. Final Customer Purchase Value Summary

The final analysis combines the major customer purchasing metrics:

Customer ID
Total Orders
Total Units
Total Revenue
Average Order Value
Average Items per Order
Maximum Order Value
Minimum Order Value
Basket Size Classification
Spending Classification
Purchase Value Score
Purchase Value Rank

This provides a consolidated customer purchasing profile.

🛠️ SQL Techniques Used

Day 54 uses the following SQL concepts:

SELECT
JOIN
GROUP BY
COUNT()
COUNT(DISTINCT)
SUM()
AVG()
MAX()
MIN()
ROUND()
CASE
NULLIF()
Common Table Expressions (CTEs)
Window Functions
RANK()
Key Analytical Techniques
Customer-level aggregation
Order-level aggregation
Revenue calculation
Basket-size analysis
Spending classification
Rule-based scoring
Customer ranking
Business segmentation
📈 Business Questions Answered

The analysis can be used to answer:

How many orders does each customer place?
How many units does each customer purchase?
How much revenue does each customer generate?
What is the average order value for each customer?
What is the typical basket size for each customer?
What is the largest order placed by each customer?
What is the smallest order placed by each customer?
Which customers have small or large baskets?
Which customers are low, moderate, high, or very high spenders?
Which customers have higher purchase-value scores?
How do customers rank according to purchase value?
How can customer purchasing behavior be segmented?
💼 Business Applications

The analysis can support:

Customer segmentation
Customer value analysis
High-value customer identification
Marketing segmentation
Personalized promotions
Basket-size analysis
Revenue analysis
Customer targeting
Sales reporting
Business intelligence
Sales strategy development
⚠️ Methodology Limitation

The purchase value score is a rule-based SQL scoring framework.

It is not a machine-learning model and does not represent a statistically validated probability of future customer behavior.

The scoring thresholds were created as analytical business rules for this portfolio project.

📁 Project Files
SQL/
└── customer_purchase_value_basket_analysis.sql

Report/
└── Day54_Customer_Purchase_Value_Basket_Analysis.md

Screenshots/
└── Day 54/
🏆 Day 54 Achievement
Customer Purchase Value & Basket Analysis Completed

Day 54 expanded the project from customer purchase propensity analysis into detailed customer purchase-value and basket behavior analysis.

The project now covers:

Customer Purchase Activity
        ↓
Repeat Purchase Analysis
        ↓
Purchase Propensity Analysis
        ↓
Purchase Value Analysis
        ↓
Basket Size Analysis
        ↓
Spending Classification
        ↓
Purchase Value Scoring
        ↓
Customer Ranking
Day 54 Status

✅ Completed

Next Milestone

Day 55 → Advanced Customer & Business Analytics