# Day 77 — Customer Revenue Growth and Trend Analysis Using SQL

## Objective
Analyze monthly customer revenue, measure month-over-month changes, and identify growing, declining, and stable customer revenue trends.

## Analyses Performed
1. Monthly revenue per customer.
2. Comparison with previous-month revenue.
3. Month-over-month revenue change and growth percentage.
4. Customer revenue trend classification.
5. Overall monthly revenue growth analysis.
6. Identification of customers with declining latest-month revenue.

## SQL Concepts Used
- Common Table Expressions (CTEs)
- JOINs and aggregate functions
- `GROUP BY` and `ORDER BY`
- `DATE_FORMAT()`
- `LAG()` window function
- `ROW_NUMBER()` window function
- `CASE` expressions
- Growth percentage calculations
- `NULLIF()` for division-by-zero protection

## Business Applications
- Monitor customer revenue trends.
- Identify customers with declining revenue.
- Find customers whose spending is increasing.
- Support customer retention and marketing decisions.
- Track monthly business revenue performance.

## Methodology Note
Revenue is calculated as quantity multiplied by current product price. Historical item prices, discounts, refunds, and costs are not available in the stated schema. Customers with no purchase in a month are not represented in the monthly customer revenue results, so a decline in recorded monthly revenue should be interpreted carefully.

## Results
Complete this section after running the SQL queries. Include actual monthly revenue, growth rates, and the number of growing or declining customers. Do not invent results.

## Deliverables
- SQL: `SQL/customer_revenue_growth_trend_analysis.sql`
- Report: `Report/Day77_Customer_Revenue_Growth_Trend_Analysis.md`
- Screenshots: `Screenshots/Day 77/`

## Status
Analysis prepared. SQL execution and result verification are pending.