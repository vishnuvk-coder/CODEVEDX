# Day 79: Customer Purchase Behavior and Segmentation Analysis Using SQL

## 1. Objective

The objective of this analysis is to understand customer purchasing behavior, measure customer spending, and group purchasing customers into spending segments using MySQL.

## 2. Tools and Technologies

- MySQL
- MySQL Workbench
- SQL CTEs
- Aggregate functions
- CASE statements
- Window functions (`NTILE`)
- Date functions

## 3. Analysis Performed

### Analysis 1: Customer Purchase Behavior Summary
Calculated each customer's total orders, first purchase date, last purchase date, days since last purchase, total spending, average order value, and purchase behavior.

### Analysis 2: Customer Spending Segmentation
Grouped customers who have purchased into High-Value, Regular, and Low-Value segments using the `NTILE(3)` window function.

### Analysis 3: Revenue Contribution by Segment
Compared customer counts, total orders, estimated segment revenue, revenue contribution percentage, and average customer spending across the three segments.

### Analysis 4: Repeat and One-Time Customer Summary
Classified customers as No Purchase, One-Time Customer, or Repeat Customer and calculated the percentage of customers in each group.

## 4. Business Value

This analysis can help a business identify valuable customers, understand repeat purchasing, compare customer segments, and plan targeted marketing and customer-retention campaigns.

## 5. Important Notes

- Spending is calculated using order-item quantities multiplied by current product prices.
- The calculation does not account for historical price changes, discounts, refunds, taxes, shipping, or product costs.
- The spending segments are relative groups based on `NTILE(3)`, not fixed monetary thresholds.
- Customer recency is calculated using the current date.
- Actual numerical findings should be added after reviewing the MySQL result grids.

## 6. Conclusion

Day 79 demonstrates how SQL can be used to analyze purchase frequency, customer spending, repeat purchasing, and customer segments to support business decisions.

## 7. Project Status

**Day 79: SQL analysis completed.**

Report and screenshot documentation should be finalized before committing and pushing the work to GitHub.
