# 📊 Sales Data Analysis Using SQL

A hands-on SQL portfolio project focused on **relational database design, advanced SQL analytics, query optimization, customer analytics, business intelligence, and business reporting** using MySQL.

This project simulates a real-world sales management system and demonstrates practical SQL skills relevant to **Data Analyst, Business Analyst, and SQL Developer roles**.

---

## 🚀 Project Overview

This project follows a structured end-to-end SQL data-analysis workflow, progressing from database fundamentals to advanced analytical and business-oriented SQL.

The primary objective is to transform raw sales data into meaningful business insights using SQL.

### Core Areas Covered

- Relational database design
- Primary Keys and Foreign Keys
- Business data insertion and management
- Data retrieval, filtering, and sorting
- SQL JOIN operations
- Aggregate functions
- SQL Subqueries
- SQL Views
- Stored Procedures
- SQL Triggers
- SQL Indexes
- Query execution analysis using `EXPLAIN`
- Query optimization
- SQL Window Functions
- Common Table Expressions (CTEs)
- Advanced sales analysis
- Customer and product performance analysis
- Revenue and KPI analysis
- Customer segmentation
- Revenue contribution analysis
- Advanced business case studies
- Business performance analysis
- Customer revenue analytics
- Customer behavior analysis
- Customer retention analysis
- Product analytics
- Business KPI analysis
- Query performance analysis
- Business reporting
- Git and GitHub version control

---

## 🛠️ Technologies Used

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

### 🔗 Database Relationships

```text
Customers
    │
    └── Orders
          │
          ├── Order_Items ─── Products
          │
          └── Payments

### 📁 Project Structure
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
│   ├── customer_behavior_analysis.sql
│   └── customer_retention_analysis.sql
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
│   └── Day 20/
│
├── Presentation/
│
├── Report/
│   ├── Week1_Report.md
│   ├── Week2_Report.md
│   ├── Day17_Business_Analysis.md
│   ├── Day19_Customer_Behavior_Analysis.md
│   └── Day20_Customer_Retention_Analysis.md
│
└── README.md