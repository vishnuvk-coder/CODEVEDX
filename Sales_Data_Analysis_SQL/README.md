# 📊 Sales Data Analysis Using SQL

A hands-on SQL portfolio project focused on **relational database design, advanced SQL analytics, query optimization, customer analytics, product analytics, business intelligence, and business reporting** using MySQL.

This project simulates a real-world sales management system and demonstrates practical SQL skills relevant to **Data Analyst, Business Analyst, and SQL Developer roles**.

---

## 🚀 Project Overview

This project follows a structured, end-to-end SQL data-analysis workflow, progressing from database fundamentals to advanced analytical and business-oriented SQL.

The primary objective is to transform raw sales data into meaningful business insights using SQL.

The project covers:

- Database design
- Data manipulation
- SQL querying
- JOIN operations
- Aggregation
- Advanced SQL
- Query optimization
- Customer analytics
- Product analytics
- Revenue analysis
- Business KPI analysis
- Customer segmentation
- Retention analysis
- Customer Lifetime Value
- Sales trend analysis
- Product performance analysis
- Customer revenue contribution
- Business intelligence
- Business reporting

---

# 🎯 Project Objectives

The main objectives of this project are to:

- Build and manage a relational sales database.
- Develop strong SQL querying skills.
- Analyze customer purchasing behavior.
- Analyze product sales and revenue performance.
- Calculate important business KPIs.
- Perform customer segmentation.
- Analyze customer retention and lifetime value.
- Identify sales trends and business patterns.
- Analyze customer revenue contribution.
- Identify high-value customers.
- Optimize SQL queries for better performance.
- Convert raw sales data into actionable business insights.
- Create structured business reports using SQL analysis.

---

# 📚 Core Areas Covered

## 🗄️ Database & SQL Fundamentals

- Relational database design
- Database creation
- Table creation
- Primary Keys
- Foreign Keys
- Data insertion
- Data manipulation
- Data retrieval
- Filtering
- Sorting
- DISTINCT
- LIMIT
- Pattern matching
- Date-based filtering

## 🔗 SQL JOIN Operations

- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- Multi-table JOINs
- Customer-order analysis
- Order-product analysis
- Payment analysis

## 📊 SQL Aggregation & Analysis

- COUNT()
- SUM()
- AVG()
- MIN()
- MAX()
- GROUP BY
- HAVING
- Revenue calculations
- Order calculations
- Customer-level aggregation
- Product-level aggregation

## 🧠 Advanced SQL

- Subqueries
- Views
- Stored Procedures
- Triggers
- Indexes
- Window Functions
- Common Table Expressions (CTEs)
- CASE statements
- Advanced JOIN analysis
- RANK()
- NTILE()
- Cumulative calculations
- Revenue contribution analysis

## ⚡ SQL Optimization

- SQL indexes
- Query execution analysis
- EXPLAIN
- Query performance analysis
- Query optimization
- Efficient JOIN strategies
- Performance-oriented SQL design

## 👥 Customer Analytics

- Customer revenue analysis
- Customer behavior analysis
- Customer purchase frequency
- Customer retention analysis
- Customer Lifetime Value
- RFM customer segmentation
- Customer revenue contribution
- High-value customer identification
- Customer ranking
- Customer segmentation

## 📦 Product Analytics

- Product sales analysis
- Product revenue analysis
- Product sales ranking
- Product performance classification
- Product revenue contribution
- Top-selling products
- Product-level business insights
- Product profitability analysis

## 💰 Revenue & KPI Analysis

- Total revenue
- Total orders
- Total customers
- Total units sold
- Average Order Value
- Customer Lifetime Value
- Revenue contribution
- Customer purchase frequency
- Product revenue
- Sales performance
- Customer revenue contribution
- Average customer revenue

## 📈 Sales Trend Analysis

- Daily sales trends
- Monthly sales trends
- Revenue trends
- Order trends
- Time-series analysis
- Period-based performance analysis

## 💼 Business Intelligence

- Business performance analysis
- Customer segmentation
- Product performance analysis
- Revenue contribution analysis
- Business KPI analysis
- Advanced business case studies
- Customer analytics
- Product analytics
- Business reporting
- Actionable business insights

## 🔧 Development & Version Control

- Git
- GitHub
- VS Code
- MySQL Workbench
- SQL documentation

---

# 📅 Project Progress

| Phase | Days | Status |
|---|---:|---|
| SQL & Database Fundamentals | Day 1–7 | ✅ Completed |
| Intermediate SQL Analysis | Day 8–14 | ✅ Completed |
| Advanced SQL & Optimization | Day 15–17 | ✅ Completed |
| Customer & Business Analytics | Day 18–22 | ✅ Completed |
| Sales Trend & Time-Series Analysis | Day 23 | ✅ Completed |
| Product Performance Analysis | Day 24 | ✅ Completed |
| Sales Profitability Analysis | Day 25 | ✅ Completed |
| Customer Revenue Contribution Analysis | Day 26 | ✅ Completed |
| **Overall Progress** | **26 Days** | **✅ Completed** |

---

# 🏆 Current Milestone

## 26 Days of SQL Business Analysis Completed

The project has progressed from basic relational database operations to advanced SQL analytics and business intelligence.

### Current Learning Journey

**Database Design**

↓  

**SQL Fundamentals**

↓  

**JOINs & Aggregations**

↓  

**Subqueries**

↓  

**Advanced SQL**

↓  

**Views, Procedures & Triggers**

↓  

**Indexes & Query Optimization**

↓  

**Window Functions & CTEs**

↓  

**Customer Analytics**

↓  

**RFM Customer Segmentation**

↓  

**Customer Retention**

↓  

**Customer Lifetime Value**

↓  

**Sales Trend Analysis**

↓  

**Product Performance Analysis**

↓  

**Sales Profitability Analysis**

↓  

**Customer Revenue Contribution Analysis**

---

# 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| **MySQL 8.0** | Database management and SQL analysis |
| **MySQL Workbench** | Database development and query execution |
| **SQL** | Data querying, analysis, and optimization |
| **Git** | Version control |
| **GitHub** | Project management and portfolio |
| **VS Code** | SQL development and documentation |

---

# 🗄️ Database Design

The project uses a relational sales database consisting of five primary tables.

| Table | Description |
|---|---|
| `Customers` | Stores customer information |
| `Products` | Stores product details and pricing |
| `Orders` | Stores customer order records |
| `Order_Items` | Stores products included in orders |
| `Payments` | Stores payment information |

## 🔗 Database Relationships

```text
Customers
    │
    └── Orders
          │
          ├── Order_Items ─── Products
          │
          └── Payments

📁 Project Structure
Sales_Data_Analysis_SQL/
│
├── Database_Design/
│   └── sales_analysis.mwb
│
├── SQL/
│   ├── create_database.sql
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
│   ├── advanced_business_case_study.sql
│   ├── business_kpi_analysis.sql
│   ├── customer_revenue_analytics.sql
│   ├── customer_behavior_analysis.sql
│   ├── customer_retention_analysis.sql
│   ├── customer_lifetime_value.sql
│   ├── rfm_customer_segmentation.sql
│   ├── sales_trend_analysis.sql
│   ├── product_performance_analysis.sql
│   ├── sales_profitability_analysis.sql
│   └── customer_revenue_contribution.sql
│
├── Screenshots/
│   ├── Day 1/
│   ├── Day 2/
│   ├── Day 3/
│   ├── Day 4/
│   ├── Day 5/
│   ├── Day 6/
│   ├── Day 7/
│   ├── Day 8/
│   ├── Day 9/
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
│   └── Day 26/
│
├── Presentation/
│
├── Report/
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
│   └── Day26_Customer_Revenue_Contribution.md
│
└── README.md