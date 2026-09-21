# 📊 Sales Data Analysis Using SQL

A hands-on SQL portfolio project focused on **relational database design, advanced SQL analytics, query optimization, customer analytics, product analytics, sales forecasting, business intelligence, and business reporting** using MySQL.

This project simulates a real-world sales management system and demonstrates practical SQL skills relevant to **Data Analyst, Business Analyst, and SQL Developer roles**.

---

## 🎯 Project Overview

The project analyzes a complete sales management database using SQL and focuses on extracting meaningful business insights from customer, order, product, and payment data.

The project covers:

* Database design
* SQL fundamentals
* JOINs and aggregations
* Advanced SQL
* CTEs
* Window functions
* Query optimization
* Customer analytics
* Product analytics
* Revenue analysis
* Sales KPI analysis
* Sales trend analysis
* Month-over-month growth analysis
* Order value and basket analysis
* Payment behavior analysis
* Data quality analysis
* Customer churn and retention
* Cohort analysis
* Customer purchase frequency
* Product demand analysis
* Revenue forecasting
* Product demand forecasting
* Business intelligence reporting

---

# 🎯 Project Objectives

The main objectives of this project are to:

1. Design and work with a relational sales database.
2. Develop strong SQL querying skills.
3. Analyze customer purchasing behavior.
4. Analyze product sales and demand.
5. Calculate revenue and business KPIs.
6. Identify sales trends and growth patterns.
7. Analyze customer retention and churn.
8. Analyze payment behavior and payment risks.
9. Perform sales order and basket analysis.
10. Perform data quality and integrity checks.
11. Build SQL-based forecasting models.
12. Convert raw sales data into actionable business insights.
13. Develop practical SQL skills for Data Analyst and Business Analyst roles.

---

# 🗄️ Database & SQL Fundamentals

The project began with the fundamentals of relational database management and SQL.

Topics covered include:

* Database creation
* Table creation
* Primary keys
* Foreign keys
* Constraints
* INSERT
* SELECT
* UPDATE
* DELETE
* WHERE
* ORDER BY
* GROUP BY
* HAVING
* DISTINCT
* Aggregate functions
* Data filtering
* Data sorting
* Relational database concepts

---

# 🔗 SQL JOIN Operations

The project includes practical use of:

* INNER JOIN
* LEFT JOIN
* RIGHT JOIN
* Multi-table JOINs
* JOIN-based aggregation
* Relational data analysis

JOINs are used extensively to connect:

```text
Customers
    ↓
Orders
    ↓
Order Items
    ↓
Products
```

and:

```text
Orders
    ↓
Payments
```

---

# 📊 SQL Aggregation & Analysis

Important SQL aggregation techniques used throughout the project include:

* COUNT()
* COUNT(DISTINCT)
* SUM()
* AVG()
* MIN()
* MAX()
* GROUP BY
* HAVING
* ORDER BY
* CASE
* ROUND()
* NULLIF()

These functions are used to calculate business metrics such as:

* Total orders
* Total customers
* Total products
* Total revenue
* Units sold
* Average order value
* Customer revenue
* Product revenue
* Payment activity
* Sales growth

---

# 🚀 Advanced SQL

Advanced SQL concepts covered include:

* Common Table Expressions (CTEs)
* Window Functions
* LAG()
* LEAD()
* RANK()
* ROW_NUMBER()
* Running totals
* Moving averages
* Ranking analysis
* Previous-period comparison
* Growth percentage calculations
* Conditional classification
* Multi-stage analytical queries

---

# ⚡ SQL Optimization

The project also covers SQL performance concepts such as:

* Indexes
* Query optimization
* Efficient JOINs
* Filtering strategies
* Aggregation optimization
* Execution-oriented query design

---

# 👥 Customer Analytics

Customer-focused analysis includes:

* Customer purchase behavior
* Customer revenue contribution
* Customer purchase frequency
* Customer retention
* Customer churn
* Customer lifetime value
* Customer segmentation
* Customer payment behavior
* Customer payment risk
* Customer cohort analysis
* Customer repeat purchasing behavior
* Customer lifecycle analysis
* RFM segmentation

---

# 🛍️ Product Analytics

Product analysis includes:

* Product sales performance
* Product revenue contribution
* Product purchase behavior
* Product customer affinity
* Cross-selling analysis
* Product ranking
* Product demand analysis
* Product demand trends
* Product demand growth
* Product demand forecasting
* Product revenue forecasting

---

# 💰 Revenue & KPI Analysis

The project calculates and analyzes:

* Total Revenue
* Total Orders
* Total Customers
* Total Products
* Total Units Sold
* Average Order Value
* Average Units per Order
* Revenue per Customer
* Orders per Customer
* Customer Revenue Contribution
* Product Revenue Contribution

### Revenue Calculation

Revenue is calculated using:

```text
Revenue = Quantity × Product Price
```

Using:

```sql
oi.quantity * p.price
```

---

# 📈 Sales Trend & Time-Series Analysis

The project analyzes sales over time using:

* Monthly revenue
* Monthly orders
* Monthly units sold
* Previous-month comparison
* Month-over-month growth
* Revenue change
* Cumulative revenue
* Revenue ranking
* Moving averages
* Sales trend classification

---

# 🔮 Revenue Forecasting & Monthly Sales Projection

The project includes SQL-based revenue forecasting using:

* Historical monthly revenue
* Monthly order volume
* Monthly units sold
* Previous-month revenue
* Month-over-month growth
* 3-month moving average
* Historical average revenue
* Recent 3-month average
* Next-month revenue projection
* Revenue trend classification

The forecasting methods are **baseline SQL forecasting approaches**, not machine-learning or statistical forecasting models.

---

# 📦 Product Demand & Sales Forecasting Analysis

## Day 51

Day 51 focuses on **product-level demand analysis and sales forecasting**.

The objective is to understand which products generate demand, how product demand changes over time, and how recent demand can be used to create a simple next-month product demand projection.

### Day 51 Analyses

#### 1. Product-Wise Total Units Sold

Calculates the total quantity sold for every product.

#### 2. Product-Wise Total Revenue

Calculates total revenue generated by each product.

```text
Revenue = Quantity × Product Price
```

#### 3. Monthly Product Demand

Analyzes product units sold month by month.

#### 4. Monthly Product Revenue

Analyzes product revenue by month.

#### 5. Previous-Month Product Demand

Uses `LAG()` to compare current product demand with the previous available month.

#### 6. Month-over-Month Product Demand Growth

Calculates:

* Demand change
* Demand growth percentage

#### 7. 3-Month Moving Average Product Demand

Uses a window function to calculate a recent three-row moving average of product demand.

#### 8. Product Demand Trend Classification

Products are classified using demand growth:

| Demand Growth         | Classification |
| --------------------- | -------------- |
| First available month | Baseline Month |
| > 5%                  | Strong Growth  |
| > 0%                  | Growth         |
| = 0%                  | Stable         |
| >= -5%                | Decline        |
| < -5%                 | Strong Decline |

#### 9. Product Demand Ranking

Ranks products according to total units sold.

#### 10. Product Revenue Ranking

Ranks products according to total revenue.

#### 11. Next-Month Product Demand Projection

Uses the recent available product-demand rows to calculate a baseline next-month demand projection using the recent three-row average.

The projection uses:

```text
Projected Demand = Recent Average Product Demand
```

and applies `CEIL()` to produce an estimated whole-unit demand value.

#### 12. Final Product Demand Forecasting Summary

Combines important product-level forecasting metrics:

* Latest product demand
* Previous product demand
* Latest product revenue
* Latest demand growth
* Recent demand average
* Projected next-month demand
* Demand trend status

---

## 🧠 Day 51 SQL Concepts Used

Day 51 demonstrates:

* `SUM()`
* `COUNT()`
* `AVG()`
* `RANK()`
* `LAG()`
* `GROUP BY`
* `ORDER BY`
* `PARTITION BY`
* Window Functions
* CTEs
* `CASE`
* `ROUND()`
* `NULLIF()`
* `CEIL()`
* `DATE_FORMAT()`
* `CAST()`
* Monthly aggregation
* Growth percentage calculation
* Moving averages
* Product ranking
* Baseline forecasting

---

## 📊 Day 51 Business Metrics

The analysis produces the following business metrics:

* Total Product Units Sold
* Total Product Revenue
* Monthly Product Demand
* Monthly Product Revenue
* Previous-Month Demand
* Demand Change
* Demand Growth %
* 3-Month Average Demand
* Product Demand Rank
* Product Revenue Rank
* Projected Next-Month Demand
* Product Demand Status

---

## 🔮 Day 51 Forecasting Method

The forecasting approach uses recent historical product demand.

```text
Recent Product Demand
        ↓
Calculate Recent Average
        ↓
Use Average as Baseline
        ↓
Project Next-Month Demand
```

This provides a simple SQL-based demand forecasting baseline.

### Forecasting Limitation

This is a **baseline forecasting method** and does not account for:

* Seasonality
* Promotions
* Pricing changes
* Holidays
* Market conditions
* External factors
* Product lifecycle
* Statistical forecasting models
* Machine learning models

---

# 💳 Payment Status & Payment Method Analysis

The project analyzes:

* Payment method distribution
* Payment status distribution
* Payment method and status combinations
* Monthly payment activity
* Monthly payment status
* Payment method usage
* Pending payments
* Payment details
* Payment method ranking
* Payment status comparison

---

# 💳 Customer Payment Behavior Analysis

Customer payment behavior analysis includes:

* Total payments per customer
* Payment methods used by customers
* Customer payment status distribution
* Customers using multiple payment methods
* Customers with pending payments
* Customers with failed payments
* Monthly customer payment activity
* Most frequently used payment method
* Highest payment activity customers
* Customer payment behavior classification
* Customer payment activity ranking

### Customer Payment Activity Categories

| Payment Records | Category                       |
| --------------- | ------------------------------ |
| 1               | Single Payment Customer        |
| 2–4             | Occasional Payment Customer    |
| 5–9             | Regular Payment Customer       |
| 10+             | High Activity Payment Customer |

---

# ⚠️ Customer Payment Risk & Pending Payment Analysis

Payment risk analysis includes:

* Payment status identification
* Payment status distribution
* Payment method distribution
* Payment status by payment method
* Monthly payment activity
* Monthly payment status
* Monthly payment method
* Pending payment analysis
* Failed payment analysis
* Multiple payment records
* Customer-level payment risk
* Customer payment risk classification

### Payment Risk Categories

* High Payment Risk
* Failed Payment Risk
* Pending Payment Risk
* High Payment Activity
* Regular Payment Activity
* Low Payment Activity

---

# 🧹 Data Quality & Integrity Analysis

Data quality analysis checks:

* Table row counts
* Duplicate customer IDs
* Duplicate product IDs
* Duplicate order IDs
* Duplicate payment IDs
* Orphan order items
* Orphan product references
* Orphan payment records
* NULL values
* Invalid quantities
* Invalid prices
* Referential integrity
* Missing relationships
* Data validation issues

---

# 🧺 Sales Order Value & Basket Analysis

The project analyzes customer orders and purchasing baskets using:

* Order-level revenue
* Order value
* Items per order
* Units per order
* Average order value
* Minimum order value
* Maximum order value
* Customer basket behavior
* Order value classification
* Basket size analysis
* High-value orders
* Low-value orders

---

# 🧠 Customer RFM Segmentation

Customer segmentation includes:

* Recency
* Frequency
* Monetary value

RFM analysis helps identify customer groups based on their purchasing behavior.

---

# 🔄 Customer Retention & Churn Analysis

Customer lifecycle analysis includes:

* Customer retention
* Customer churn
* Repeat customers
* One-time customers
* Customer purchase frequency
* Cohort analysis
* Retention analysis
* Customer lifecycle analysis

---

# 📅 Customer Cohort & Retention Analysis

Cohort analysis includes:

* Customer acquisition month
* Cohort month
* Monthly customer activity
* Customer retention
* Cohort retention patterns
* Customer lifecycle behavior

---

# 🛒 Customer Purchase Frequency Analysis

Purchase frequency analysis includes:

* Number of orders per customer
* Average purchase frequency
* Repeat customers
* One-time customers
* Customer purchase classification
* Customer activity ranking

---

# 🤝 Product Customer Affinity & Cross-Selling

The project also explores relationships between products purchased by customers.

Analysis includes:

* Product affinity
* Product combinations
* Cross-selling opportunities
* Frequently purchased product pairs
* Customer-product relationships
* Product recommendation opportunities

---

# 📊 Business Intelligence

The project transforms SQL analysis into business intelligence insights.

The analysis supports:

* Sales reporting
* Customer reporting
* Product reporting
* Revenue monitoring
* KPI monitoring
* Payment monitoring
* Customer retention analysis
* Product demand planning
* Forecasting
* Business decision support
* Management reporting

---

# 🛠️ Technologies Used

* **MySQL 8.0**
* **MySQL Workbench**
* **SQL**
* **VS Code**
* **Git**
* **GitHub**
* **Markdown**

---

# 🗃️ Database Design

Main database:

```text
sales_analysis_db
```

Main tables:

```text
customers
orders
order_items
products
payments
```

### Database Relationship

```text
customers
    │
    │ customer_id
    ↓
orders
    │
    ├───────────────┐
    │               │
    │ order_id      │ order_id
    ↓               ↓
order_items      payments
    │
    │ product_id
    ↓
products
```

---

# 📁 Project Structure

```text
Sales_Data_Analysis_SQL/
│
├── README.md
│
├── SQL/
│   │
│   ├── create_tables.sql
│   ├── insert_data.sql
│   ├── basic_queries.sql
│   ├── join_queries.sql
│   ├── aggregate_queries.sql
│   ├── subqueries.sql
│   ├── sales_analysis_report.sql
│   ├── views.sql
│   ├── stored_procedures.sql
│   ├── triggers.sql
│   ├── indexes.sql
│   ├── window_functions.sql
│   ├── cte_queries.sql
│   ├── advanced_business_analysis.sql
│   ├── query_optimization.sql
│   │
│   ├── [Day 16–38 SQL files]
│   │
│   ├── customer_segment_retention_analysis.sql
│   ├── customer_cohort_retention_analysis.sql
│   │
│   ├── payment_status_method_analysis.sql
│   ├── customer_payment_behavior_analysis.sql
│   ├── payment_risk_pending_analysis.sql
│   ├── data_quality_integrity_analysis.sql
│   ├── sales_performance_kpi_analysis.sql
│   ├── sales_growth_mon_analysis.sql
│   ├── sales_order_value_basket_analysis.sql
│   ├── sales_revenue_forecasting_analysis.sql
│   └── product_demand_forecasting_analysis.sql
│
├── Report/
│   │
│   ├── Week1_Report.md
│   ├── Week2_Report.md
│   ├── Day17_Business_Analysis.md
│   ├── Day19_Customer_Behavior_Analysis.md
│   ├── Day20_Customer_Retention_Analysis.md
│   ├── Day21_Customer_Lifetime_Value.md
│   ├── Day22_RFM_Customer_Segmentation.md
│   ├── Day23_Sales_Trend_Analysis.md
│   ├── Day24_Product_Performance_Analysis.md
│   ├── Day25_Sales_Profitability_Analysis.md
│   ├── Day26_Customer_Revenue_Contribution.md
│   ├── Day27_Customer_Churn_Analysis.md
│   ├── Day28_Customer_Cohort_Analysis.md
│   ├── Day29_Customer_Purchase_Frequency_Analysis.md
│   ├── Day30_Analysis.md
│   │
│   ├── [Day 31–38 reports]
│   │
│   ├── Day39_Customer_Segment_Retention_Analysis.md
│   ├── Day40_Customer_Cohort_Retention_Analysis.md
│   │
│   ├── Day43_Payment_Status_Method_Analysis.md
│   ├── Day44_Customer_Payment_Behavior_Analysis.md
│   ├── Day45_Customer_Payment_Risk_Analysis.md
│   ├── Day46_Data_Quality_Integrity_Analysis.md
│   ├── Day47_Sales_Performance_KPI_Analysis.md
│   ├── Day48_Sales_Growth_MON_Analysis.md
│   ├── Day49_Sales_Order_Value_Basket_Analysis.md
│   ├── Day50_Sales_Revenue_Forecasting_Analysis.md
│   └── Day51_Product_Demand_Forecasting_Analysis.md
│
├── Screenshots/
│   │
│   ├── Day 01/
│   ├── Day 02/
│   ├── Day 03/
│   ├── Day 04/
│   ├── Day 05/
│   ├── Day 06/
│   ├── Day 07/
│   ├── Day 08/
│   ├── Day 09/
│   ├── Day 10/
│   ├── Day 11/
│   ├── Day 12/
│   ├── Day 13/
│   ├── Day 14/
│   ├── Day 15/
│   ├── Day 16/
│   ├── Day 17/
│   ├── Day 18/
│   ├── Day 19/
│   ├── Day 20/
│   ├── Day 21/
│   ├── Day 22/
│   ├── Day 23/
│   ├── Day 24/
│   ├── Day 25/
│   ├── Day 26/
│   ├── Day 27/
│   ├── Day 28/
│   ├── Day 29/
│   ├── Day 30/
│   ├── Day 31/
│   ├── Day 32/
│   ├── Day 33/
│   ├── Day 34/
│   ├── Day 35/
│   ├── Day 36/
│   ├── Day 37/
│   ├── Day 38/
│   ├── Day 39/
│   ├── Day 40/
│   ├── Day 41/
│   ├── Day 42/
│   ├── Day 43/
│   ├── Day 44/
│   ├── Day 45/
│   ├── Day 46/
│   ├── Day 47/
│   ├── Day 48/
│   ├── Day 49/
│   ├── Day 50/
│   └── Day 51/
│       ├── Query_01.png
│       ├── Query_02.png
│       ├── Query_03.png
│       ├── Query_04.png
│       ├── Query_05.png
│       ├── Query_06.png
│       ├── Query_07.png
│       ├── Query_08.png
│       ├── Query_09.png
│       ├── Query_10.png
│       ├── Query_11.png
│       └── Query_12.png
│
└── Database/
    ├── database_schema.sql
    ├── table_creation.sql
    └── sample_data.sql
```

---

# 🔄 Business Analysis Journey

The project has developed through the following stages:

```text
Database Design
        ↓
SQL Fundamentals
        ↓
JOINs & Aggregations
        ↓
Advanced SQL
        ↓
Views, Procedures & Triggers
        ↓
Indexes & Query Optimization
        ↓
Window Functions & CTEs
        ↓
Customer Analytics
        ↓
RFM Customer Segmentation
        ↓
Customer Retention
        ↓
Customer Lifetime Value
        ↓
Sales Trend Analysis
        ↓
Product Performance Analysis
        ↓
Sales Profitability Analysis
        ↓
Customer Revenue Contribution
        ↓
Customer Churn Analysis
        ↓
Customer Cohort & Retention Analysis
        ↓
Customer Purchase Frequency Analysis
        ↓
Payment Analysis
        ↓
Payment Risk Analysis
        ↓
Data Quality & Integrity
        ↓
Sales Performance KPI Analysis
        ↓
Sales Growth & Month-over-Month Analysis
        ↓
Sales Order Value & Basket Analysis
        ↓
Sales Revenue Forecasting
        ↓
Product Demand Analysis
        ↓
Product Demand Forecasting
        ↓
Business Intelligence
```

---

# 💼 Skills Demonstrated

This project demonstrates practical skills in:

### SQL

* SQL fundamentals
* Advanced SQL
* JOINs
* Aggregations
* CTEs
* Window Functions
* Ranking
* Time-series analysis
* Growth analysis
* Moving averages
* Forecasting
* Data quality analysis
* Query optimization

### Data Analysis

* Customer analysis
* Product analysis
* Revenue analysis
* Sales analysis
* Payment analysis
* KPI analysis
* Churn analysis
* Retention analysis
* Cohort analysis
* Basket analysis
* Demand analysis
* Forecasting

### Business Analysis

* KPI development
* Business metrics
* Trend identification
* Customer segmentation
* Risk identification
* Revenue contribution
* Demand planning
* Business reporting
* Decision support

### Tools

* MySQL
* MySQL Workbench
* VS Code
* Git
* GitHub

---

# 📈 Project Progress

| Phase                                           |        Days | Status          |
| ----------------------------------------------- | ----------: | --------------- |
| SQL & Database Fundamentals                     |     Day 1–7 | ✅ Completed     |
| Intermediate SQL Analysis                       |    Day 8–14 | ✅ Completed     |
| Advanced SQL & Optimization                     |   Day 15–17 | ✅ Completed     |
| Customer & Business Analytics                   |   Day 18–22 | ✅ Completed     |
| Sales Trend & Time-Series Analysis              |      Day 23 | ✅ Completed     |
| Product Performance Analysis                    |      Day 24 | ✅ Completed     |
| Sales Profitability Analysis                    |      Day 25 | ✅ Completed     |
| Customer Revenue Contribution Analysis          |      Day 26 | ✅ Completed     |
| Customer Churn Analysis                         |      Day 27 | ✅ Completed     |
| Customer Cohort & Retention Analysis            |      Day 28 | ✅ Completed     |
| Customer Purchase Frequency Analysis            |      Day 29 | ✅ Completed     |
| Day 30 Analysis                                 |      Day 30 | ✅ Completed     |
| Payment Status & Payment Method Analysis        |      Day 43 | ✅ Completed     |
| Customer Payment Behavior Analysis              |      Day 44 | ✅ Completed     |
| Customer Payment Risk Analysis                  |      Day 45 | ✅ Completed     |
| Data Quality & Integrity Analysis               |      Day 46 | ✅ Completed     |
| Sales Performance KPI Analysis                  |      Day 47 | ✅ Completed     |
| Sales Growth & Month-over-Month Analysis        |      Day 48 | ✅ Completed     |
| Sales Order Value & Basket Analysis             |      Day 49 | ✅ Completed     |
| Sales Revenue Forecasting & Future Projection   |      Day 50 | ✅ Completed     |
| **Product Demand & Sales Forecasting Analysis** |  **Day 51** | **✅ Completed** |
| **Overall Progress**                            | **51 Days** | **✅ Completed** |

---

# 🏆 Current Milestone

## 51 Days of SQL Business Analysis Completed 🎉

The project has progressed from SQL fundamentals and relational database design to:

* Advanced SQL
* Query optimization
* Customer analytics
* RFM segmentation
* Customer retention
* Customer lifetime value
* Sales trend analysis
* Product performance analysis
* Sales profitability analysis
* Customer revenue contribution
* Customer churn analysis
* Customer cohort analysis
* Customer purchase frequency
* Payment analysis
* Payment risk analysis
* Data quality analysis
* Sales KPI analysis
* Month-over-month growth analysis
* Order value and basket analysis
* Revenue forecasting
* Product demand analysis
* Product demand forecasting

---

# 📌 Day 51 Achievement

### Product Demand & Sales Forecasting Analysis

**Status:** ✅ Completed

**Day:** 51

**Focus:** Product Demand & Sales Forecasting

**SQL Analysis:** 12 Queries

**Primary Techniques:**

* Window Functions
* CTEs
* LAG()
* RANK()
* Moving Averages
* Growth Analysis
* Trend Classification
* Product Ranking
* Baseline Forecasting

**Business Focus:**

* Product demand
* Product revenue
* Demand growth
* Demand trends
* Product ranking
* Future demand projection

---

# 📊 Portfolio Progress

## 51 Days Completed 🚀

The project currently contains **51 days of SQL business analysis and portfolio development**.

Major areas completed:

```text
SQL Fundamentals
        ↓
Advanced SQL
        ↓
Customer Analytics
        ↓
Product Analytics
        ↓
Sales Analytics
        ↓
Payment Analytics
        ↓
Data Quality
        ↓
KPI Analysis
        ↓
Time-Series Analysis
        ↓
Basket Analysis
        ↓
Revenue Forecasting
        ↓
Product Demand Forecasting
```

---

# 🚀 Next Stage

The next stage of the project is:

```text
Day 52
   ↓
Day 53
   ↓
Day 54
   ↓
Day 55
```

The project will continue toward more advanced SQL business analysis and portfolio-level analytics.

---

# 🎯 Project Goal

The final goal of this project is to build a strong **SQL Data Analyst / Business Analyst portfolio project** that demonstrates the ability to:

* Work with relational databases
* Write complex SQL queries
* Analyze large datasets
* Build business KPIs
* Understand customer behavior
* Analyze product performance
* Identify sales trends
* Analyze payment behavior
* Detect data-quality issues
* Perform customer segmentation
* Analyze retention and churn
* Analyze purchasing behavior
* Forecast revenue
* Forecast product demand
* Convert data into business insights

---

# 🏁 51-Day Milestone

## 🎉 51 Days of SQL Business Analysis Completed

**Current Progress:** 51 Days

**Status:** 🟢 Active

**Primary Focus:** SQL Data Analysis & Business Intelligence

**Latest Completed Analysis:** Product Demand & Sales Forecasting Analysis

**Latest Day:** Day 51

**Next Target:** Day 52

---

## 🔥 Project Status

**🟢 Active**

**Completed: 51 Days**

**Primary Focus: SQL Data Analysis & Business Intelligence**

The project continues to expand toward advanced business analytics, customer lifecycle analysis, product analytics, sales forecasting, demand forecasting, and real-world business decision-support use cases.

---
