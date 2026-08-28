# Day 27 – Customer Churn & Retention Risk Analysis

## 📌 Objective

The objective of this analysis is to identify customers who may be
at risk of becoming inactive or churning based on their purchasing
recency and historical purchasing behavior.

## 📊 Analysis Performed

1. Customer Last Order Date
2. Customer Order Frequency
3. Customer Recency Analysis
4. Customer Churn Risk Classification
5. Customer Revenue and Churn Risk
6. High-Value Customers at Churn Risk
7. Churn Risk Customer Distribution
8. Revenue at Risk Analysis
9. Customer Churn Risk Ranking
10. Final Customer Churn Business Report

## 🧠 SQL Concepts Used

- SELECT
- LEFT JOIN
- INNER JOIN
- GROUP BY
- CTEs
- Aggregate Functions
- MAX()
- COUNT()
- SUM()
- COALESCE()
- DATEDIFF()
- CASE
- RANK()
- Window Functions

## 🎯 Churn Risk Categories

| Category | Definition |
|---|---|
| Active | Customer purchased within 30 days |
| At Risk | No purchase for 31–60 days |
| High Risk | No purchase for 61–90 days |
| Churn Risk | No purchase for more than 90 days |
| No Purchase | Customer has no recorded order |

## 💼 Business Questions

- Which customers have not purchased recently?
- Which customers are at risk of churning?
- Which high-value customers are at risk?
- How much revenue is associated with risky customers?
- Which customers should receive retention campaigns?
- Which customers require urgent win-back actions?

## 📈 Business Value

Customer churn analysis helps businesses identify customers
who may become inactive and prioritize retention campaigns.

High-value customers with long periods since their last purchase
can be targeted with personalized offers and win-back campaigns.

## 🏆 Conclusion

SQL was used to transform customer transaction data into a
churn-risk analysis that can support customer retention,
re-engagement, and business decision-making.