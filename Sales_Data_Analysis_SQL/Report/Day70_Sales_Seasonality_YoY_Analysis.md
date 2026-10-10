# Day 70 — Advanced Sales Seasonality and Year-over-Year Analysis Using SQL

## 1. Project Overview

Day 70 extends the Sales Data Analysis Using SQL portfolio by examining recurring monthly sales patterns and comparing sales performance across years using MySQL 8.0.

The analysis focuses on revenue trends, year-over-year (YoY) growth, monthly and quarterly performance, and identification of the highest- and lowest-revenue observed periods.

## 2. Objectives

- Analyze monthly revenue by year.
- Compare revenue for the same calendar month across consecutive years.
- Calculate YoY revenue growth percentages.
- Compare average revenue across calendar months.
- Rank monthly revenue within each year.
- Identify the highest- and lowest-revenue observed months.
- Compare quarterly revenue performance.
- Measure YoY changes in units sold.
- Summarize annual sales performance.

## 3. Database and Revenue Calculation

**Database:** `sales_analysis_db`

Tables used:
- `orders`
- `order_items`
- `products`

Revenue is calculated using:

`Revenue = SUM(order_items.quantity * products.price)`

The analysis joins order items to orders and products using their corresponding keys. It does not assume that `order_items` contains a price column.

## 4. Analysis Performed

### Analysis 1: Monthly Revenue

Aggregates revenue, order count and units sold by year and calendar month.

### Analysis 2: Year-over-Year Revenue Growth

Compares a month's revenue with the same calendar month in the previous year. Calculates the revenue difference and percentage growth where the prior-year revenue is nonzero.

### Analysis 3: Calendar-Month Seasonality

Calculates average, minimum and maximum observed monthly revenue for each calendar month across available years.

### Analysis 4: Monthly Revenue Ranking

Ranks months within each year to identify stronger and weaker observed sales periods.

### Analysis 5: Highest- and Lowest-Revenue Months

Identifies the highest- and lowest-revenue observed months in each year. Ties are retained.

### Analysis 6: Quarterly Performance

Aggregates revenue and order counts by calendar quarter and ranks quarters within each year.

### Analysis 7: Units Sold Growth

Compares units sold for each calendar month against the same month in the previous year.

### Analysis 8: Annual Summary

Summarizes annual revenue, orders, average observed monthly revenue, highest and lowest observed monthly revenue, and the number of observed months with sales.

## 5. SQL Concepts Demonstrated

- Aggregate functions: `SUM`, `COUNT`, `AVG`, `MIN`, `MAX`
- Date functions: `YEAR`, `MONTH`, `QUARTER`, `DATE_FORMAT`
- Common Table Expressions (CTEs)
- Self-joins for prior-year comparisons
- Window functions: `RANK`
- Conditional handling with `NULLIF`
- Grouping and ordering of business data

## 6. Business Applications

This analysis can help a business:
- Compare performance against the same period in the previous year.
- Identify calendar months that tend to perform strongly.
- Plan inventory and staffing around observed demand patterns.
- Review quarterly sales performance.
- Monitor changes in units sold separately from revenue.

## 7. Limitations

- No actual numeric findings should be reported until the queries have been executed and their results reviewed.
- Months without orders are absent from the monthly aggregation. Therefore, average monthly revenue is calculated over observed months with sales, not all calendar months.
- Calendar-month averages alone do not prove seasonality. More years of comparable data provide stronger evidence.
- YoY growth is unavailable when the previous year's matching month is missing or its revenue is zero.
- Revenue uses listed product prices multiplied by quantity. Discounts, refunds, shipping, taxes and product costs are not included unless modeled separately.
- This is descriptive SQL analysis, not a machine-learning forecast or proof of seasonal causation.

## 8. Deliverables

- SQL script: `SQL/sales_seasonality_yoy_analysis.sql`
- Report: `Report/Day70_Sales_Seasonality_YoY_Analysis.md`
- Screenshots: `Screenshots/Day 70/`
- README: `README.md`

## 9. Completion Checklist

- [ ] Execute and validate all eight SQL analyses.
- [ ] Review results and record genuine business findings.
- [ ] Capture readable screenshots of query outputs.
- [ ] Save the report and update the project README.
- [ ] Commit and push the completed Day 70 deliverables to GitHub.

## 10. Conclusion

Day 70 introduces a structured SQL approach to calendar-month seasonality, year-over-year comparisons, quarterly ranking and annual performance summaries. Final conclusions should be written only after reviewing the actual query results.
