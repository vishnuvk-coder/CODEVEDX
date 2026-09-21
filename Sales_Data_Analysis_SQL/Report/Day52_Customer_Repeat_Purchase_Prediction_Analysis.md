📊 Day 52 — Customer Repeat Purchase Prediction & Analysis
Introduction

Day 52 focuses on Customer Repeat Purchase Prediction & Purchase Behavior Analysis using MySQL.

The objective is to analyze historical customer purchasing behavior and classify customers according to their potential for repeat purchasing.

This analysis uses a rule-based SQL classification approach based on customer order history, purchase frequency, purchase recency, and repeat-purchase behavior.

🎯 Objectives

The main objectives of Day 52 are:

Analyze total orders per customer
Calculate total units purchased by each customer
Calculate customer-level revenue
Identify each customer's first purchase date
Identify each customer's latest purchase date
Calculate days since the latest purchase
Calculate average days between purchases
Calculate repeat purchase count
Analyze customer purchase frequency
Classify customers based on repeat purchasing behavior
Create a customer purchase activity score
Build a rule-based repeat-purchase prediction
🗄️ Database Used
Database: sales_analysis_db
📋 Tables Used
orders

Contains customer order information.

Important columns:

order_id
customer_id
order_date
order_items

Contains products and quantities associated with orders.

Important columns:

order_id
product_id
quantity
products

Contains product information.

Important columns:

product_id
product_name
price
📊 Analyses Performed
1. Total Orders per Customer

Counts the number of unique orders placed by each customer.

Business Purpose

This identifies customers with higher and lower purchase frequency.

2. Total Units Purchased per Customer

Calculates the total number of product units purchased by each customer.

Business Purpose

This measures the customer's overall purchase volume.

3. Total Revenue per Customer

Customer revenue is calculated using:

Revenue = quantity × product price
Business Purpose

This identifies customers who contribute more revenue to the business.

4. First Purchase Date

Identifies the earliest recorded order date for every customer.

Business Purpose

This helps determine when customers first entered the business.

5. Latest Purchase Date

Identifies the most recent purchase date for every customer.

Business Purpose

This provides a measure of customer purchase recency.

6. Days Since Last Purchase

Calculates the number of days between a customer's latest purchase and the latest available order date in the dataset.

Business Purpose

This helps identify recently active customers and customers who may have become inactive.

7. Average Days Between Purchases

Uses the LAG() window function to compare consecutive purchase dates for each customer.

Business Purpose

This measures how frequently customers return to make purchases.

8. Repeat Purchase Count

Repeat purchases are calculated as:

Repeat Purchases = Total Orders - 1
Business Purpose

This separates one-time customers from customers who have purchased more than once.

9. Customer Purchase Frequency

The analysis calculates customer order frequency relative to the customer's observed purchase lifetime.

Business Purpose

This helps understand the purchasing intensity of different customers.

10. Customer Repeat-Purchase Classification

Customers are classified according to their number of orders.

Total Orders	Customer Classification
1	One-Time Customer
2–3	Occasional Repeat Customer
4–6	Regular Repeat Customer
7+	Highly Loyal Customer
Business Purpose

This provides a simple customer segmentation based on repeat purchasing.

11. Customer Purchase Activity Score

A rule-based purchase activity score is calculated using:

Total orders
Days since the last purchase

The score combines purchase frequency and purchase recency.

Business Purpose

This provides a simple method for identifying customers with stronger recent purchasing activity.

🔮 12. Final Customer Repeat-Purchase Prediction

The final analysis combines:

Total orders
Repeat purchase count
First purchase date
Latest purchase date
Days since last purchase
Average days between purchases

Customers are classified into the following categories:

Prediction Category	Description
High Repeat Purchase Potential	Customers with 4+ orders and recent activity
Moderate Repeat Purchase Potential	Customers with multiple orders and relatively recent activity
At-Risk Repeat Customer	Repeat customers whose latest purchase is older
Potential New Repeat Customer	One-time customers with relatively recent activity
Low Repeat Purchase Potential	One-time customers with older activity
🧠 SQL Concepts Used

Day 52 demonstrates:

SELECT
JOIN
GROUP BY
COUNT()
COUNT(DISTINCT)
SUM()
MIN()
MAX()
AVG()
DATEDIFF()
ROUND()
GREATEST()
COALESCE()
NULLIF()
CASE
Common Table Expressions (CTEs)
Window Functions
LAG()
Customer Segmentation
Purchase Frequency Analysis
Purchase Recency Analysis
Rule-Based Classification
📈 Key Business Metrics
Total Orders

Measures the customer's purchasing activity.

Total Units Purchased

Measures the customer's purchase volume.

Customer Revenue

Measures the customer's monetary contribution.

Days Since Last Purchase

Measures customer recency.

Average Days Between Purchases

Measures purchase frequency.

Repeat Purchase Count

Measures repeat customer behavior.

Purchase Activity Score

Provides a simplified measurement of customer activity.

Repeat Purchase Prediction

Classifies customers based on historical purchasing behavior.

💼 Business Applications

The analysis can support:

Customer retention
Repeat-purchase campaigns
Customer engagement
Loyalty programs
Personalized marketing
Re-engagement campaigns
Customer segmentation
Revenue growth
Customer lifecycle management

For example, customers classified as At-Risk Repeat Customers could be considered for re-engagement campaigns, while customers with strong recent repeat behavior could be considered for loyalty or cross-selling initiatives.

⚠️ Methodology Limitation

The Day 52 prediction is a rule-based SQL classification, not a statistical or machine-learning prediction model.

The classification is based only on historical transactional information available in the database.

It does not use:

Machine learning algorithms
Probability modeling
Logistic regression
Random forests
Neural networks
External customer attributes

Therefore, the results should be interpreted as a business-analysis framework for identifying repeat-purchase potential, rather than a production predictive model.

🔄 Business Intelligence Workflow
Customer Orders
      ↓
Purchase History
      ↓
Order Frequency
      ↓
Purchase Recency
      ↓
Average Purchase Interval
      ↓
Repeat Purchase Count
      ↓
Customer Activity Score
      ↓
Repeat-Purchase Classification
      ↓
Business Action
📁 Project Files
SQL/
└── customer_repeat_purchase_prediction.sql

Report/
└── Day52_Customer_Repeat_Purchase_Prediction_Analysis.md

Screenshots/
└── Day 52/
🎓 Key Learning Outcomes

After completing Day 52, the following skills were practiced:

Customer-level aggregation
Purchase frequency analysis
Purchase recency analysis
Repeat purchase measurement
Date-based customer analysis
LAG() window functions
CTE-based analysis
Rule-based customer classification
Customer activity scoring
Business prediction using SQL
Customer retention analysis
🏆 Day 52 Achievement
Customer Repeat Purchase Prediction & Analysis Completed

Day 52 extended the project from product-level demand forecasting into customer-level purchase behavior analysis.

The analysis demonstrates how historical transactional data can be transformed into customer insights using SQL.

The project now covers both:

Product Demand Forecasting
          ↓
Customer Purchase Behavior
          ↓
Repeat Purchase Analysis
          ↓
Customer Activity Classification
          ↓
Repeat-Purchase Potential
📊 Portfolio Progress
Day 1  → SQL Fundamentals
Day 10 → Intermediate SQL
Day 20 → Customer Analytics
Day 30 → Customer Segmentation
Day 40 → Cohort & Retention Analysis
Day 50 → Sales Revenue Forecasting
Day 51 → Product Demand Forecasting
Day 52 → Customer Repeat Purchase Prediction
✅ Day 52 Status

Status: 🟢 Completed

Primary Focus: Customer Repeat Purchase Prediction & Analysis

SQL Analyses: 12

Primary Techniques:

CTEs
Window Functions
LAG()
Date Analysis
Customer Segmentation
Purchase Frequency
Purchase Recency
Rule-Based Prediction

Project Milestone: 52 Days of SQL Business Analysis

Conclusion

Day 52 demonstrates how SQL can be used not only for reporting historical sales data but also for creating customer behavior indicators and business-oriented predictions.

By combining purchase frequency, recency, repeat purchase count, and historical purchase intervals, the analysis provides a structured way to identify different types of customer repeat-purchase behavior.

Day 52 — Customer Repeat Purchase Prediction & Analysis: ✅ Completed