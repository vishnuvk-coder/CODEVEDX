# Day 76 — Customer Spending Segmentation Analysis Using SQL

## 1. Objective

The objective of this analysis is to understand customer spending behavior, calculate customer-level spending metrics, and segment purchasing customers into low-, medium-, and high-spending groups.

## 2. Tools and Technologies

- MySQL 8.0+
- MySQL Workbench
- SQL CTEs
- Aggregate functions
- Window functions
- CASE expressions and JOINs

## 3. Business Questions

1. How much has each customer spent?
2. How many orders has each customer placed?
3. What is each customer's average order value?
4. How do low-, medium-, and high-spending customer groups compare?
5. Who are the top 10 customers by total spending?
6. Which customers belong to the high-spending segment?

## 4. Analysis Performed

- Customer spending summary
- Customer spending segmentation using `NTILE(3)`
- Spending segment performance comparison
- Top 10 customers by spending
- High-spending customer identification

## 5. SQL Concepts Demonstrated

- `JOIN` and `LEFT JOIN`
- `GROUP BY` and `HAVING`
- `SUM()`, `COUNT()` and `AVG()`
- `ROUND()` and `COALESCE()`
- Common Table Expressions (CTEs)
- `CASE` expressions
- `NTILE()` window function
- `ORDER BY` and `LIMIT`

## 6. Findings

Complete this section after executing the queries.

- Total customers analyzed: [Enter actual result]
- Number of customers who purchased: [Enter actual result]
- Number of customers in the low-spending segment: [Enter actual result]
- Number of customers in the medium-spending segment: [Enter actual result]
- Number of customers in the high-spending segment: [Enter actual result]
- Highest-spending customer ID: [Enter actual result]
- Total revenue represented in the analysis: [Enter actual result]

## 7. Business Recommendations

- Consider loyalty rewards for high-spending customers.
- Study the purchasing patterns of medium-spending customers to identify opportunities to increase spending.
- Evaluate suitable offers for low-spending customers.
- Analyze customers who have never purchased separately from purchasing customers.
- Use actual query results before making business recommendations.

## 8. Limitations

Revenue is calculated using quantity multiplied by the current product price. Historical product prices, discounts, refunds, and payment confirmation are not incorporated into this revenue calculation.

The spending segments are relative groups based on `NTILE(3)`, so group membership can change when the dataset changes.

## 9. Conclusion

This project demonstrates how SQL can be used to summarize customer spending, compare customer segments, and identify high-value customers. The actual business conclusions will be added after validating the query results.

## 10. Project Files

- SQL: `SQL/customer_spending_segmentation_analysis.sql`
- Report: `Report/Day76_Customer_Spending_Segmentation_Analysis.md`
- Screenshots: `Screenshots/Day 76/`
