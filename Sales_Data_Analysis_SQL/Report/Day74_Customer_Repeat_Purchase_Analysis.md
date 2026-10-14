# Day 74 — Customer Repeat Purchase and Returning Customer Analysis

## 1. Objective

The objective of this analysis is to understand customer purchasing frequency, identify returning customers, and measure the time between consecutive purchases using MySQL.

## 2. Business Questions

- How many orders has each customer placed?
- What percentage of purchasing customers are returning customers?
- How are customers distributed by purchase frequency?
- How many days pass between consecutive orders?
- Which returning customers generate the most revenue?

## 3. SQL Concepts Used

- `JOIN` and `LEFT JOIN`
- Aggregate functions: `COUNT`, `SUM`, `MIN`, and `MAX`
- `COUNT(DISTINCT ...)`
- Common Table Expressions (CTEs)
- `CASE` statements
- `COALESCE` and `NULLIF`
- Window function: `LAG()`
- Date functions: `DATEDIFF()`
- `GROUP BY`, `HAVING`, and `ORDER BY`

## 4. Analysis Performed

### Customer Purchase Summary
Summarizes order count, units purchased, revenue, first and last order dates, and customer type.

### Returning Customer Rate
Calculates the percentage of customers with orders who have placed more than one order.

### Purchase Frequency Groups
Groups customers into no orders, one order, two to three orders, four to five orders, and six or more orders.

### Purchase Interval Analysis
Calculates the number of days between consecutive purchases for each customer.

### Returning Customer Revenue
Identifies returning customers and calculates their total revenue, average revenue per order, and activity period.

## 5. Business Value

This analysis can help a business understand customer loyalty, recognize frequent buyers, identify opportunities for repeat-purchase campaigns, and prioritize customer-retention efforts.

## 6. Limitations

Revenue is calculated using order-item quantities and the current product prices. The analysis does not account for discounts, refunds, taxes, or historical price changes unless those are represented in the database.

## 7. Conclusion

Day 74 demonstrates how SQL can be used to analyze repeat purchases, customer frequency, purchase intervals, and returning-customer revenue. Actual business findings should be added after reviewing the query results.

## 8. Tools

- MySQL
- MySQL Workbench
- SQL
- Git and GitHub