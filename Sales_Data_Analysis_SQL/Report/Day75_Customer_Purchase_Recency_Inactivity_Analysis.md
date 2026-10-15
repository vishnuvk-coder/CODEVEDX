# Day 75 — Customer Purchase Recency and Inactivity Analysis Using SQL

## 1. Objective

Analyze customer purchase recency, identify inactive and at-risk customers, summarize customer inactivity segments, and prioritize potential customer re-engagement opportunities using MySQL.

## 2. Business Questions

- When did each customer last purchase?
- How many days have passed since the last purchase?
- How many customers are active, at risk, inactive, or have never purchased?
- Which customers have not purchased in the last 61–90 days?
- Which inactive customers have generated higher historical revenue?
- Which customers should be prioritized for re-engagement?

## 3. SQL Techniques Used

- SELECT and filtering
- LEFT JOIN and JOIN
- COUNT(DISTINCT)
- MAX() and SUM()
- CASE expressions
- Common Table Expressions (CTEs)
- DATEDIFF() and CURRENT_DATE
- COALESCE() and NULLIF()
- GROUP BY, HAVING, and ORDER BY
- Conditional customer segmentation

## 4. Analyses Performed

### Customer Purchase Recency
Calculates the last purchase date and elapsed days since the last order.

### Customer Inactivity Summary
Counts customers in each recency segment and calculates their percentage of all customers.

### At-Risk Customer Identification
Identifies purchasing customers whose last order was 61–90 days ago.

### Historical Revenue from Inactive Customers
Ranks customers inactive for more than 90 days by historical revenue calculated from available order items and product prices.

### Customer Re-engagement Priority
Assigns rule-based priority categories using purchase recency, order history, and historical revenue.

## 5. Business Applications

- Identify customers who may need follow-up.
- Plan customer win-back campaigns.
- Prioritize outreach using historical purchasing value.
- Monitor changes in customer inactivity.
- Support customer lifecycle reporting.

## 6. Methodology Limitations

- Recency is measured against the current execution date.
- The 30-, 60-, and 90-day thresholds are illustrative business rules.
- Inactivity does not necessarily mean a customer has permanently churned.
- Historical revenue uses current product prices and does not automatically account for discounts, refunds, taxes, shipping, or historical price changes.
- Re-engagement priority is a rule-based classification, not a predictive machine-learning model.
- Actual numerical findings must be added only after reviewing the query results.

## 7. Conclusion

This analysis demonstrates how SQL can support customer recency measurement, inactivity segmentation, historical revenue analysis, and re-engagement planning.

## 8. Tools Used

- MySQL
- MySQL Workbench
- SQL
- Git and GitHub