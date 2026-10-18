# Day 78 — Customer Purchase Recency and Repeat Purchase Analysis

## 1. Objective
Analyze customer purchasing behavior by identifying purchase frequency, first and last purchase dates, days since the last purchase, repeat customers, and customer activity categories.

## 2. Analyses Performed
- **Customer Purchase Summary:** Counts distinct orders and identifies first and latest purchase dates.
- **Purchase Recency:** Calculates the number of days since each customer's latest purchase.
- **Repeat Purchase Classification:** Separates one-time customers from repeat customers.
- **Customer Activity Classification:** Groups customers into Recently Active, Needs Attention, At Risk, and Inactive categories.
- **Repeat Purchase Summary:** Calculates one-time customers, repeat customers, and the repeat-customer percentage.

## 3. SQL Concepts Used
- `COUNT()` and `COUNT(DISTINCT ...)`
- `MIN()` and `MAX()`
- `DATEDIFF()`
- `CASE` expressions
- Subqueries
- Conditional aggregation with `SUM()`
- `ROUND()` and `NULLIF()`

## 4. Business Applications
- Identify customers who may need follow-up.
- Understand repeat purchasing behavior.
- Support customer retention campaigns.
- Help marketing teams prioritize customer engagement.
- Monitor the percentage of customers who place multiple orders.

## 5. Business Rule
The activity categories use illustrative thresholds based on days since the last purchase:
- 0–30 days: Recently Active
- 31–60 days: Needs Attention
- 61–90 days: At Risk
- More than 90 days: Inactive

These thresholds should be adjusted according to the business's normal purchase cycle.

## 6. Limitation
The analysis uses the current date and available order history. A customer classified as inactive has not purchased recently in the available data; this does not necessarily mean the customer has permanently churned.

## 7. Results
Add the actual findings after reviewing the MySQL Workbench result grids. Do not enter estimated customer counts or percentages.

## 8. Project Files
- SQL: `SQL/customer_purchase_recency_repeat_analysis.sql`
- Report: `Report/Day78_Customer_Purchase_Recency_Repeat_Analysis.md`
- Screenshots: `Screenshots/Day 78/`

## 9. Conclusion
This analysis demonstrates how SQL can measure purchase recency, distinguish one-time and repeat customers, and classify customer activity to support retention and marketing decisions.