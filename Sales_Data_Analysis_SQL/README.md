📊 Sales Data Analysis Using SQL
A hands-on SQL portfolio project focused on relational database design, advanced SQL analytics, query optimization, customer analytics, product analytics, business intelligence, payment analysis, sales forecasting, and seasonality analysis using MySQL.
This project simulates a real-world sales management system and demonstrates practical SQL skills relevant to Data Analyst, Business Analyst, SQL Developer, Reporting Analyst, and MIS Analyst roles.
🚀 Project Overview
The project follows a structured SQL learning and business analysis journey, progressing from database fundamentals to advanced analytical techniques and business decision-support use cases.
The project covers:
- Database design and SQL fundamentals
- Data querying, JOINs and aggregations
- Advanced SQL and query optimization
- CTEs and window functions
- Customer segmentation, RFM and customer lifetime value
- Customer retention, churn and cohort analysis
- Customer lifecycle and purchase frequency analysis
- Product performance, affinity and cross-selling
- Sales revenue, profitability and business KPIs
- Customer revenue contribution and segmentation
- Pareto, decile, quartile, quintile and ABC analysis
- Payment performance, method trends and reliability
- Sales forecasting and revenue projection
- Monthly sales seasonality and year-over-year comparisons
- Business reporting and actionable business insights
🏆 Latest Milestone: Day 76 Completed
Day 76 — Customer Spending Segmentation Analysis Using SQL
Day 76 analyzes customer spending behavior using MySQL, calculates customer-level order and spending metrics, groups purchasing customers into relative low-, medium-, and high-spending segments, compares segment performance, and identifies top-spending customers.
Day 76 Objectives
- Calculate each customer's total orders, total quantity purchased, total spending, and average order value.
- Segment purchasing customers into low-, medium-, and high-spending groups using NTILE(3).
- Compare customer counts, segment revenue, average customer spending, and average order value across segments.
- Identify the top 10 customers by total spending.
- List customers in the high-spending segment.
Day 76 Key Analyses
1. Customer spending summary.
2. Relative customer spending segmentation.
3. Spending segment performance comparison.
4. Top 10 customers by spending.
5. High-spending customer identification.
SQL Techniques Used
- JOINs and LEFT JOINs.
- SUM(), COUNT(), AVG(), ROUND(), and COALESCE().
- Common Table Expressions (CTEs).
- CASE expressions.
- NTILE() window function.
- GROUP BY, HAVING, ORDER BY, and LIMIT.
Business Applications
- Identify customers who contribute higher spending.
- Compare spending across customer groups.
- Support loyalty and customer engagement planning.
- Identify opportunities to encourage medium- and low-spending customers to purchase more.
- Support customer-level business reporting.
Methodology Limitations
- NTILE(3) creates relative spending groups, not fixed monetary thresholds.
- Customers with no orders are classified separately as Never Purchased.
- Revenue is calculated as quantity multiplied by current product price; historical prices, discounts, refunds, taxes, shipping, and product costs are not included unless modeled separately.
- Numerical findings should only be reported after reviewing actual query results.
Day 76 Project Files
- SQL/customer_spending_segmentation_analysis.sql
- Report/Day76_Customer_Spending_Segmentation_Analysis.md
- Screenshots/Day 76/
Day 76 Status: Completed
🏆 Previous Milestone: Day 75 Completed
Day 75 — Customer Purchase Recency and Inactivity Analysis Using SQL
Day 75 analyzes how recently customers purchased, segments customers by purchase recency, identifies customers at risk of inactivity, compares historical revenue from inactive customers, and assigns rule-based re-engagement priorities using MySQL.
Day 75 Objectives
- Calculate each customer's total orders and last purchase date.
- Measure days since the last purchase.
- Segment customers into Recently Active, Moderately Inactive, At Risk, Inactive, and Never Purchased groups.
- Summarize customer counts and percentages by recency segment.
- Identify customers whose last purchase was 61–90 days ago.
- Rank customers inactive for more than 90 days by historical revenue.
- Assign rule-based customer re-engagement priorities.
Day 75 Key Analyses
1. Customer purchase recency.
2. Customer inactivity summary.
3. Customers at risk of inactivity.
4. Historical revenue from inactive customers.
5. Customer re-engagement priority.
SQL Techniques Used
- JOINs and LEFT JOINs.
- COUNT(DISTINCT), MAX(), and SUM().
- Common Table Expressions (CTEs).
- CASE expressions.
- DATEDIFF() and CURRENT_DATE.
- COALESCE() and NULLIF().
- GROUP BY, HAVING, and ORDER BY.
Business Applications
- Identify customers who may need follow-up.
- Plan customer win-back campaigns.
- Prioritize outreach using historical purchasing value.
- Monitor customer inactivity and support customer lifecycle reporting.
Methodology Limitations
- Recency is measured against the date when the query is executed.
- The 30-, 60-, and 90-day thresholds are illustrative business rules.
- Inactivity does not necessarily mean a customer has permanently churned.
- Historical revenue uses current product prices and does not automatically account for discounts, refunds, taxes, shipping, or historical price changes.
- Re-engagement priority is a rule-based classification, not a predictive machine-learning model.
- Numerical findings should only be added after reviewing actual query results.
Day 75 Project Files
- SQL/customer_purchase_recency_inactivity_analysis.sql
- Report/Day75_Customer_Purchase_Recency_Inactivity_Analysis.md
- Screenshots/Day 75/
Day 75 Status: Completed
🏆 Previous Milestone: Day 74 Completed
Day 74 — Customer Repeat Purchase and Returning Customer Analysis Using SQL
Day 74 analyzes customer order frequency, returning-customer rate, purchase-frequency groups, days between consecutive orders, and revenue generated by returning customers using MySQL.
Day 74 Objectives
- Summarize each customer's orders, units purchased, revenue, and first and last order dates.
- Classify customers as No Orders, First-Time Customers, or Returning Customers.
- Calculate the returning-customer rate among customers who have placed at least one order.
- Group customers by purchase frequency.
- Calculate the number of days between consecutive orders using LAG() and DATEDIFF().
- Compare revenue and average revenue per order for returning customers.
Day 74 Key Analyses
1. Customer purchase summary.
2. Returning-customer rate.
3. Purchase-frequency groups.
4. Days between consecutive purchases.
5. Returning-customer revenue and customer activity period.
SQL Techniques Used
- JOINs and LEFT JOINs across customers, orders, order items, and products.
- COUNT(DISTINCT ...), SUM(), MIN(), and MAX().
- Common Table Expressions (CTEs).
- CASE expressions and conditional aggregation.
- LAG() window function.
- DATEDIFF() for purchase intervals.
- COALESCE() and NULLIF() for safe calculations.
Business Applications
- Identify one-time buyers and returning customers.
- Measure repeat-purchase behavior among customers who have ordered.
- Understand customer purchase frequency and time between orders.
- Identify returning customers with higher revenue contribution.
- Support customer retention and repeat-purchase campaigns.
Methodology Limitations
- Returning-customer classification is based on all available orders in the database.
- Purchase intervals require at least two orders with valid dates per customer.
- Revenue is quantity multiplied by current product price; historical prices, discounts, refunds, taxes, shipping, and product costs are not included unless modeled separately.
- Revenue and repeat-purchase rates should be interpreted using the actual query outputs; no numerical findings are asserted here.
Day 74 Project Files
- SQL/customer_repeat_purchase_returning_analysis.sql
- Report/Day74_Customer_Repeat_Purchase_Analysis.md
- Screenshots/Day 74/
Day 74 Status: Completed
🏆 Previous Milestone: Day 73 Completed
Day 73 — Customer Revenue Concentration and Pareto (80/20) Analysis Using SQL
Day 73 analyzes how revenue is distributed across purchasing customers using customer revenue ranking, individual revenue contribution, cumulative revenue contribution, a top-20%-versus-remaining-customers comparison, and the customer position needed to reach at least 80% of total revenue.
Day 73 Objectives
- Calculate total revenue generated by each customer.
- Rank customers by revenue and calculate individual contribution percentages.
- Calculate cumulative revenue and cumulative revenue contribution.
- Compare the revenue share of the top 20% of purchasing customers with the remaining customers.
- Identify the minimum customer position needed to reach or exceed 80% of total revenue.
Day 73 Key Analyses
1. Customer revenue summary.
2. Customer revenue ranking and contribution percentage.
3. Cumulative revenue contribution.
4. Top 20% customer revenue comparison.
5. Customer position needed to reach the 80% revenue target.
SQL Techniques Used
- JOINs across customers, orders, order items, and products.
- Aggregate functions and Common Table Expressions (CTEs).
- ROW_NUMBER(), DENSE_RANK(), and SUM() OVER().
- CASE expressions, CEIL(), and percentage calculations.
- NULLIF() safeguards for division.
Business Applications
- Identify customers who contribute a substantial share of revenue.
- Measure dependence on a small group of customers.
- Support customer retention and relationship-management decisions.
- Prioritize customer engagement and marketing strategies.
- Monitor revenue concentration risk.
Methodology Limitations
- The 80/20 principle is a hypothesis, not a guaranteed outcome; use actual query outputs to report findings.
- The top 20% group is based on purchasing-customer count, rounded up to a whole customer.
- Customers without qualifying order and order-item records are not included.
- Revenue is quantity multiplied by current product price; historical prices, discounts, refunds, taxes, shipping, and product costs are not included unless modeled separately.
- This is descriptive SQL analysis, not a machine-learning prediction.
- Record numerical findings only after reviewing the actual query results.
Day 73 Project Files
- SQL/customer_revenue_concentration_pareto_analysis.sql
- Report/Day73_Customer_Revenue_Concentration_Pareto_Analysis.md
- Screenshots/Day 73/
Day 73 Status: Completed
🏆 Previous Milestone: Day 72 Completed
Day 72 — Customer Segmentation and Revenue Contribution Analysis Using SQL
Day 72 focuses on customer-level revenue summaries, relative revenue-based customer segmentation, individual and cumulative revenue contribution, customer ranking, and segment-level sales analysis using MySQL 8.0.
🎯 Day 72 Objectives
- Calculate total orders, units purchased, revenue, and average order value for each customer.
- Segment positive-revenue customers into High Value, Medium Value, and Low Value groups.
- Calculate each customer's percentage contribution to total revenue.
- Rank customers by revenue using window functions.
- Measure cumulative revenue and cumulative revenue contribution.
- Compare customer counts and revenue across customer segments.
- Calculate each segment's share of total revenue.
- Identify the top revenue-contributing customers.
🔍 Day 72 Key Analyses
1. Customer Purchase and Revenue Summary
2. Relative Revenue-Based Customer Segmentation
3. Customer Revenue Contribution Percentage
4. Customer Revenue Ranking
5. Cumulative Revenue Contribution
6. Revenue Summary by Customer Segment
7. Segment Share of Total Revenue
8. Top 10 Revenue-Contributing Customers
🧠 SQL Techniques Used
- Aggregate functions and GROUP BY
- JOIN operations across customers, orders, order items, and products
- CASE expressions
- Common Table Expressions (CTEs)
- NTILE() for relative customer segmentation
- DENSE_RANK() for customer ranking
- SUM() OVER() for contribution and cumulative revenue
- COALESCE() and NULLIF() for safe calculations
💼 Business Applications
- Identify customers with relatively high revenue contribution.
- Understand how revenue is distributed across customers and segments.
- Support customer retention, loyalty, and targeted marketing plans.
- Monitor customer revenue concentration and prioritize relationship management.
- Prepare customer-level and segment-level business reports.
⚠️ Methodology Limitations
- Revenue-based segments are relative groups produced by NTILE(3), not fixed monetary thresholds.
- Customers with zero revenue are excluded from revenue-based segmentation and contribution rankings.
- Segment sizes may differ slightly depending on the number of purchasing customers.
- Revenue is calculated as quantity multiplied by the current product price; historical prices, discounts, refunds, taxes, shipping, and product costs are not included unless modeled separately.
- Revenue contribution alone does not measure customer profitability, acquisition cost, or customer lifetime value.
- Numerical findings should be reported only after reviewing the actual query results.
📁 Day 72 Project Files
SQL/
└── customer_segmentation_revenue_contribution.sql
Report/
└── Day72_Customer_Segmentation_Revenue_Contribution.md
Screenshots/
└── Day 72/
Day 72 Status: ✅ Completed
🏆 Latest Milestone: Day 71 Completed
Day 71 — Customer Purchase Trends and Repeat Purchase Analysis Using SQL
Day 71 focuses on customer order frequency, repeat-purchase behavior, the time between consecutive orders, monthly repeat activity, and customer revenue contribution using MySQL 8.0.
🎯 Day 71 Objectives
- Summarize orders, units purchased, revenue, and average order value by customer.
- Classify one-time and repeat customers.
- Calculate the overall repeat-purchase rate.
- Segment customers by purchase frequency.
- Calculate days between consecutive customer orders.
- Measure average purchase intervals for customers with multiple dated orders.
- Analyze monthly customers who place multiple orders within the same month.
- Rank customers by revenue contribution.
🔍 Day 71 Key Analyses
1. Customer Purchase Summary
2. One-Time vs Repeat Customer Classification
3. Overall Repeat-Purchase Rate
4. Purchase Frequency Segmentation
5. Days Between Consecutive Orders
6. Average Purchase Interval per Customer
7. Monthly Repeat Customer Trends
8. Customer Revenue Ranking
🧠 SQL Techniques Used
- Aggregate functions and GROUP BY
- CASE expressions and conditional aggregation
- Common Table Expressions (CTEs)
- LAG() for previous-order dates
- DATEDIFF() for purchase intervals
- DATE_FORMAT() for monthly analysis
- DENSE_RANK() for customer revenue ranking
- COALESCE() and NULLIF() for safe calculations
💼 Business Applications
- Identify one-time customers and repeat buyers.
- Understand purchase frequency and time between orders.
- Find high-revenue customers.
- Monitor customers placing multiple orders within a month.
- Support customer retention and engagement planning.
⚠️ Methodology Limitations
- Repeat-customer classification uses all available orders in the database.
- Monthly repeat-customer rate means multiple orders within the same calendar month; it does not measure every customer returning from a previous month.
- Purchase interval results require valid order dates and at least two dated orders per customer.
- Revenue uses quantity multiplied by the current product price in the products table; historical prices, discounts, refunds, taxes, shipping, and product costs are not included unless modeled separately.
- Numerical findings should be reported only after reviewing the actual query results.
📁 Day 71 Project Files
SQL/
└── customer_repeat_purchase_analysis.sql
Report/
└── Day71_Customer_Repeat_Purchase_Analysis.md
Screenshots/
└── Day 71/
Day 71 Status: ✅ Completed
🏆 Latest Milestone: Day 71 Completed
Day 70 — Advanced Sales Seasonality & Year-over-Year Performance Analysis Using SQL
Day 70 extends the sales forecasting work from Day 69 by comparing revenue across calendar months and years, examining quarterly performance, and identifying stronger and weaker observed sales periods.
🎯 Day 70 Objectives
- Analyze monthly sales revenue by year.
- Compare revenue for the same calendar month across consecutive years.
- Calculate year-over-year (YoY) revenue growth.
- Compare average revenue across calendar months.
- Rank monthly revenue within each year.
- Identify the highest- and lowest-revenue observed months.
- Compare quarterly sales performance.
- Analyze year-over-year changes in units sold.
- Summarize annual sales performance.
🔍 Day 70 Key Analyses
1. Monthly Sales Revenue by Year
2. Year-over-Year Revenue Comparison
3. YoY Revenue Change
4. YoY Revenue Growth Percentage
5. Calendar-Month Revenue Seasonality
6. Monthly Revenue Ranking Within Each Year
7. Highest- and Lowest-Revenue Observed Months
8. Quarterly Sales Performance
9. Quarterly Revenue Ranking
10. Year-over-Year Units Sold Comparison
11. Annual Revenue Summary
12. Annual Order Summary
13. Average Observed Monthly Revenue
14. Highest and Lowest Observed Monthly Revenue
15. Final Sales Seasonality and YoY Analysis
🧠 SQL Techniques Used
- SELECT, SUM(), COUNT(), AVG()
- MIN() and MAX()
- ROUND() and NULLIF()
- YEAR(), MONTH() and QUARTER()
- DATE_FORMAT() and STR_TO_DATE()
- GROUP BY and ORDER BY
- JOINs and Common Table Expressions (CTEs)
- Self-joins for prior-year comparisons
- Window functions and RANK()
- Percentage change calculations
- Conditional handling of missing comparisons
💼 Business Applications
- Compare sales performance against the same month in the previous year.
- Identify calendar months with stronger observed revenue.
- Support preliminary inventory and staffing discussions.
- Monitor quarterly sales performance.
- Compare revenue growth with units-sold growth.
- Prepare historical sales performance reports.
⚠️ Methodology Limitations
- Seasonality conclusions depend on the amount and quality of historical data.
- Months without orders are not automatically generated by the monthly aggregation.
- Average monthly revenue is based on observed months with sales.
- YoY growth is unavailable when the matching prior-year month is missing or its revenue is zero.
- Revenue is calculated from product quantity multiplied by product price; discounts, refunds, taxes, shipping and product costs are not included unless modeled separately.
- This is descriptive SQL analysis, not proof of seasonal causation or a machine-learning forecast.
- Numerical business findings should be reported only after reviewing the actual query results.
📁 Day 70 Project Files
SQL/
└── sales_seasonality_yoy_analysis.sql
Report/
└── Day70_Sales_Seasonality_YoY_Analysis.md
Screenshots/
└── Day 70/
Day 70 Status: ✅ Completed
📊 Day 69 — Sales Forecasting & Trend Projection Using SQL
Day 69 focused on analyzing historical sales performance and calculating a baseline projection for future revenue using MySQL.
Key Analyses
1. Monthly Sales Revenue
2. Monthly Order Count
3. Monthly Units Sold
4. Average Order Value by Month
5. Previous-Month Revenue
6. Month-over-Month Revenue Change
7. Month-over-Month Revenue Growth Percentage
8. Three-Month Moving Average Revenue
9. Six-Month Moving Average Revenue
10. Monthly Revenue Trend Classification
11. Highest-Revenue Month
12. Lowest-Revenue Month
13. Revenue Volatility Overview
14. Baseline Next-Month Revenue Projection
15. Final Sales Forecasting Summary
SQL Techniques
- CTEs and window functions
- LAG(), RANK() and ROW_NUMBER()
- Moving averages
- Revenue growth calculations
- Standard deviation analysis
- Historical trend classification
Forecasting Method
The baseline projection uses the average revenue from the three most recent available monthly records. It is a simple reference estimate, not a machine-learning prediction or guaranteed forecast.
Day 69 Project Files
SQL/sales_forecasting_trend_projection.sql
Report/Day69_Sales_Forecasting_Trend_Projection.md
Screenshots/Day 69/
Day 69 Status: ✅ Completed
💳 Day 68 — Payment Method Trend & Reliability Analysis
Day 68 analyzed payment method usage, transaction outcomes and reliability over time.
Key Analyses
1. Payment Method Usage by Date
2. Payment Method Usage by Month
3. Monthly Transactions by Payment Method
4. Monthly Unique Orders
5. Monthly Customer Count by Payment Method
6. Successful Transactions
7. Failed Transactions
8. Pending Transactions
9. Monthly Payment Success Rate
10. Monthly Payment Failure Rate
11. Monthly Payment Pending Rate
12. Payment Method Monthly Performance Ranking
13. Payment Method Reliability Classification
14. Highest-Growth Payment Method
15. Final Payment Method Trend Summary
Reliability Framework
| Success Rate | Classification |
|---|---|
| 90% or higher | Highly Reliable |
| 75% to below 90% | Moderately Reliable |
| Below 75% | Low Reliability |
These categories are rule-based business analysis classifications, not a machine-learning model.
Day 68 Project Files
SQL/payment_method_trend_reliability_analysis.sql
Report/Day68_Payment_Method_Trend_Reliability_Analysis.md
Screenshots/Day 68/
Day 68 Status: ✅ Completed
💰 Day 67 — Customer Payment Method Performance Analysis
Day 67 focused on comparing payment methods based on transaction activity and payment outcomes.
Key Analyses
- Payment method transaction count
- Unique orders by payment method
- Customer count by payment method
- Successful, failed and pending transaction counts
- Payment success, failure and pending rates
- Most preferred payment method
- Best-performing payment method
- Highest failure rate
- Rule-based payment method risk classification
- Final payment method performance summary
Day 67 Project Files
SQL/customer_payment_method_performance_analysis.sql
Report/Day67_Customer_Payment_Method_Performance_Analysis.md
Screenshots/Day 67/
Day 67 Status: ✅ Completed
📈 Sales Trend & Forecasting Analysis
The project includes:
- Daily and monthly sales trend analysis
- Monthly revenue and order analysis
- Month-over-month revenue comparison
- Revenue growth percentage
- Cumulative revenue analysis
- Monthly revenue ranking
- Revenue trend classification
- Historical revenue averages
- Three-month and six-month moving averages
- Revenue volatility analysis
- Baseline revenue projection
- Product demand and sales forecasting concepts
- Year-over-year sales comparisons
- Monthly seasonality and quarterly performance analysis
👥 Customer Analytics
The project includes:
- Customer purchase behavior
- Customer revenue contribution
- Customer lifetime value
- RFM customer segmentation
- Customer retention and churn analysis
- Customer cohort analysis
- Repeat purchase behavior
- Purchase frequency and purchase intervals
- Customer lifecycle classification
- Customer purchase propensity analysis
- Customer value segmentation
- Revenue concentration and Pareto analysis
- Customer revenue decile, quartile and quintile analysis
- Customer revenue ABC analysis
- ABC segment performance and business-priority analysis
📦 Product & Business Analytics
The project includes:
- Product performance analysis
- Product revenue contribution
- Product purchase behavior
- Product-customer affinity analysis
- Cross-selling analysis
- Product demand analysis
- Order value and basket analysis
- Sales profitability analysis
- Sales performance KPIs
- Business performance reporting
- Data quality and integrity analysis
🗄️ Database Design
Database: sales_analysis_db
The database includes the following tables:
| Table | Purpose |
|---|---|
| customers | Customer information |
| orders | Order records and dates |
| order_items | Products and quantities within orders |
| products | Product details and prices |
| payments | Payment methods, dates and statuses |
Database Relationships
Customers
   |
   └── Orders
         |
         ├── Order_Items ─── Products
         |
         └── Payments
Revenue Calculation
SUM(order_items.quantity \* products.price)
Revenue analyses use product quantity multiplied by product price. The order_items table does not contain the product price field in this schema, and the payments table is not assumed to contain a payment amount field.
📅 Daily Project Organization
| Day | Main Work |
|---|---|
| Day 1–7 | SQL and Database Fundamentals |
| Day 8–14 | Intermediate SQL Analysis |
| Day 15–17 | Advanced SQL and Optimization |
| Day 18–22 | Customer and Business Analytics |
| Day 23 | Sales Trend Analysis |
| Day 24 | Product Performance Analysis |
| Day 25 | Sales Profitability Analysis |
| Day 26 | Customer Revenue Contribution |
| Day 27 | Customer Churn Analysis |
| Day 28 | Customer Cohort and Retention |
| Day 29 | Customer Purchase Frequency |
| Day 30 | Customer Segmentation and Revenue |
| Day 31–42 | Customer and Product Analytics |
| Day 43–45 | Payment and Customer Payment Analysis |
| Day 46 | Data Quality and Integrity |
| Day 47 | Sales Performance KPI Analysis |
| Day 48 | Sales Growth and Month-over-Month Analysis |
| Day 49 | Sales Order Value and Basket Analysis |
| Day 50 | Sales Revenue Forecasting |
| Day 51 | Product Demand and Sales Forecasting |
| Day 52 | Customer Repeat Purchase Prediction |
| Day 53 | Customer Purchase Propensity Analysis |
| Day 54 | Customer Purchase Value and Basket Analysis |
| Day 55 | Customer Purchase Value Segmentation |
| Day 56–57 | Customer Revenue Contribution and Concentration |
| Day 58 | Customer Revenue Pareto and 80/20 Analysis |
| Day 59 | Customer Revenue Decile Analysis |
| Day 60 | Customer Revenue Quartile Analysis |
| Day 61 | Customer Revenue Quintile Analysis |
| Day 62 | Customer Revenue ABC Analysis |
| Day 63 | ABC Segment Performance |
| Day 64 | ABC Segment Comparison and Business Priority |
| Day 65 | Payment Performance and Business Analysis |
| Day 66 | Customer Payment Behavior and Risk Analysis |
| Day 67 | Customer Payment Method Performance |
| Day 68 | Payment Method Trend and Reliability |
| Day 69 | Sales Forecasting and Trend Projection |
| Day 70 | Advanced Sales Seasonality and YoY Analysis |
**
| Day 71 | Customer Repeat Purchase and Purchase Interval Analysis |
| Day 72 | Customer Segmentation and Revenue Contribution Analysis |
| Day 73 | Customer Revenue Concentration and Pareto (80/20) Analysis |
| Day 74 | Customer Repeat Purchase and Returning Customer Analysis |
| Day 75 | Customer Purchase Recency and Inactivity Analysis |
| Day 76 | Customer Spending Segmentation Analysis |
📁 Project Structure**
Sales_Data_Analysis_SQL/
│
├── Database_Design/
│   └── sales_analysis.mwb
│
├── SQL/
│   ├── create_database.sql
│   ├── create_tables.sql
│   ├── insert_data.sql
│   ├── basic_queries.sql
│   ├── join_queries.sql
│   ├── aggregate_queries.sql
│   ├── subqueries.sql
│   ├── sales_analysis_report.sql
│   ├── views.sql
│   ├── stored_procedures.sql
│   ├── triggers.sql
│   ├── indexes.sql
│   ├── window_functions.sql
│   ├── cte_queries.sql
│   ├── cte_analysis.sql
│   ├── advanced_business_analysis.sql
│   ├── query_optimization.sql
│   ├── business_kpi_analysis.sql
│   ├── customer_revenue_analytics.sql
│   ├── customer_behavior_analysis.sql
│   ├── customer_retention_analysis.sql
│   ├── customer_lifetime_value.sql
│   ├── rfm_customer_segmentation.sql
│   ├── sales_trend_analysis.sql
│   ├── product_performance_analysis.sql
│   ├── sales_profitability_analysis.sql
│   ├── customer_revenue_contribution.sql
│   ├── customer_churn_analysis.sql
│   ├── customer_cohort_analysis.sql
│   ├── customer_purchase_frequency_analysis.sql
│   ├── data_quality_integrity_analysis.sql
│   ├── sales_performance_kpi_analysis.sql
│   ├── sales_growth_mom_analysis.sql
│   ├── sales_order_value_basket_analysis.sql
│   ├── sales_revenue_forecasting_analysis.sql
│   ├── product_demand_forecasting_analysis.sql
│   ├── customer_repeat_purchase_prediction.sql
│   ├── customer_purchase_propensity_analysis.sql
│   ├── customer_purchase_value_basket_analysis.sql
│   ├── customer_purchase_value_segmentation.sql
│   ├── customer_revenue_contribution_analysis.sql
│   ├── customer_revenue_pareto_analysis.sql
│   ├── customer_revenue_decile_analysis.sql
│   ├── customer_revenue_quartile_analysis.sql
│   ├── customer_revenue_quintile_analysis.sql
│   ├── customer_revenue_abc_analysis.sql
│   ├── customer_revenue_abc_segment_performance.sql
│   ├── customer_revenue_abc_segment_comparison.sql
│   ├── payment_performance_business_analysis.sql
│   ├── customer_payment_behavior_risk_analysis.sql
│   ├── customer_payment_method_performance_analysis.sql
│   ├── payment_method_trend_reliability_analysis.sql
│   ├── sales_forecasting_trend_projection.sql
│   ├── sales_seasonality_yoy_analysis.sql
│   ├── customer_repeat_purchase_analysis.sql
│   ├── customer_segmentation_revenue_contribution.sql
│   ├── customer_revenue_concentration_pareto_analysis.sql
│   ├── customer_repeat_purchase_returning_analysis.sql
│   ├── customer_purchase_recency_inactivity_analysis.sql
│   └── customer_spending_segmentation_analysis.sql
│
├── Screenshots/
│   ├── Day 67/
│   ├── Day 68/
│   ├── Day 69/
│   ├── Day 70/
│   ├── Day 71/
│   ├── Day 72/
│   ├── Day 73/
│   ├── Day 74/
│   ├── Day 75/
│   └── Day 76/
│
├── Presentation/
│
├── Report/
│   ├── Week1_Report.md
│   ├── Week2_Report.md
│   ├── Day67_Customer_Payment_Method_Performance_Analysis.md
│   ├── Day68_Payment_Method_Trend_Reliability_Analysis.md
│   ├── Day69_Sales_Forecasting_Trend_Projection.md
│   ├── Day70_Sales_Seasonality_YoY_Analysis.md
│   ├── Day71_Customer_Repeat_Purchase_Analysis.md
│   ├── Day72_Customer_Segmentation_Revenue_Contribution.md
│   ├── Day73_Customer_Revenue_Concentration_Pareto_Analysis.md
│   ├── Day74_Customer_Repeat_Purchase_Analysis.md
│   ├── Day75_Customer_Purchase_Recency_Inactivity_Analysis.md
│   └── Day76_Customer_Spending_Segmentation_Analysis.md
│
└── README.md
*Note: The structure documents the main project files. Keep the filenames aligned with the actual files present in the repository.*
📌 Project Status
Current Status: 🟢 Active
Completed: 76 Days
Primary Focus: SQL Data Analysis and Business Intelligence
The project has progressed from database design and SQL fundamentals to advanced SQL analytics, customer analytics, product analytics, revenue segmentation, payment analysis, sales forecasting, seasonality analysis, repeat-purchase behavior, and customer revenue contribution analysis.
Day 70 added calendar-month revenue comparisons, year-over-year growth calculations, quarterly rankings, and annual performance summaries. Day 71 added repeat-customer classification, purchase frequency segmentation, purchase interval calculations, monthly repeat activity, and customer revenue ranking. Day 72 adds relative revenue-based customer segmentation, customer and segment revenue contribution, customer ranking, and cumulative revenue analysis. Day 74 adds returning-customer classification, repeat-purchase rate, purchase-frequency groups, consecutive-order intervals, and returning-customer revenue analysis. Day 75 adds customer purchase recency, inactivity segments, at-risk customer identification, and rule-based re-engagement priorities. Day 76 adds customer spending summaries, relative spending segmentation, segment performance comparisons, and top-spending customer identification.
🚀 76-Day Portfolio Progress
SQL Fundamentals
       ↓
Advanced SQL
       ↓
Business Analytics
       ↓
Customer Analytics
       ↓
Customer Retention and Lifecycle Analysis
       ↓
Customer Lifetime Value and RFM Segmentation
       ↓
Product and Customer Behavior Analysis
       ↓
Revenue Contribution and Segmentation
       ↓
ABC Segment Performance
       ↓
Payment Performance and Risk Analysis
       ↓
Payment Method Performance
       ↓
Payment Method Trend and Reliability
       ↓
Sales Revenue Trend Analysis
       ↓
Month-over-Month Growth
       ↓
Three-Month and Six-Month Moving Averages
       ↓
Revenue Volatility
       ↓
Baseline Next-Month Revenue Projection
       ↓
Calendar-Month Seasonality
       ↓
Year-over-Year Revenue and Units Sold Comparison
       ↓
Repeat Purchase and Purchase Interval Analysis
       ↓
Quarterly and Annual Performance Analysis
       ↓
Business Insights
🎯 Next Milestone
The next stage can explore:
- Advanced forecast evaluation
- Product demand seasonality
- Customer behavior forecasting
- Advanced business KPIs
- Dashboard-oriented analytics
- Executive business reporting
- Revenue performance dashboards
- Sales KPI dashboards
- Customer behavior dashboards
- Payment monitoring dashboards
- Data quality monitoring
- Business performance monitoring
Next Milestone: Day 77 🚀
⭐ Project Goal
The long-term goal is to develop a practical SQL and Business Analytics portfolio demonstrating the ability to:
Query
  ↓
Analyze
  ↓
Measure
  ↓
Validate
  ↓
Segment
  ↓
Compare
  ↓
Identify Problems
  ↓
Forecast
  ↓
Generate Insights
  ↓
Recommend Business Actions
🎉 76-Day Milestone
Day 71 — Customer Purchase Trends and Repeat Purchase Analysis completed. ✅
Day 72 — Customer Segmentation and Revenue Contribution Analysis completed. ✅
Day 73 — Customer Revenue Concentration and Pareto (80/20) Analysis completed. ✅
Day 74 — Customer Repeat Purchase and Returning Customer Analysis completed. ✅
Day 75 — Customer Purchase Recency and Inactivity Analysis completed. ✅
76 days of structured SQL business analysis documented. 🚀
Customer purchase recency, inactivity segments, at-risk customer identification, historical revenue from inactive customers, and rule-based re-engagement priorities added to the project. 📊
76/76 Milestone Achieved. 🏆
Day 75 — Customer Purchase Recency and Inactivity Analysis completed. ✅
Day 76 — Customer Spending Segmentation Analysis completed. ✅
Customer spending summary, relative spending segments, segment performance comparison, top-spending customer ranking, and high-spending customer identification added to the project. 📊
Next target: Day 77. 🚀