# 📊 Sales Data Analysis using SQL

A hands-on SQL portfolio project focused on **relational database design, SQL querying, data analysis, and business reporting** using MySQL.

The project simulates a real-world sales management system and demonstrates practical SQL skills relevant to **Data Analyst and SQL Developer roles**.

---

## 🚀 Project Overview

This project follows a complete SQL data-analysis workflow:

- Designing a relational database
- Creating tables with Primary Keys and Foreign Keys
- Inserting and managing business data
- Writing SQL queries for data analysis
- Filtering and sorting data
- Performing SQL JOIN operations
- Using Aggregate Functions
- Implementing SQL Subqueries
- Creating reusable SQL Views
- Generating business-oriented reports
- Managing the project using Git and GitHub

---

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| **MySQL 8.0** | Database & SQL analysis |
| **MySQL Workbench** | Database development |
| **SQL** | Data querying & analysis |
| **Git** | Version control |
| **GitHub** | Project management & portfolio |

---

# 📁 Project Structure

```text
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
│   └── views.sql
│
├── Screenshots/
│   ├── Day 1/
│   ├── Day 2/
│   ├── Day 3/
│   ├── Day 4/
│   ├── Day 5/
│   ├── Day 6/
│   ├── Day 7/
│   └── Day 8/
│
├── Presentation/
│
├── Report/
│   └── Week1_Report.md
│
└── README.md
```

---

# 🗃️ Database Schema

The project uses five related tables:

| Table | Description |
|---|---|
| `Customers` | Stores customer information |
| `Products` | Stores product details and pricing |
| `Orders` | Stores customer order records |
| `Order_Items` | Stores products included in each order |
| `Payments` | Stores payment information |

### 🔗 Main Relationships

```text
Customers
    │
    └── Orders
          │
          ├── Order_Items ─── Products
          │
          └── Payments
```

---

# 📅 Project Progress

## ✅ Day 1 – Database Design

Completed:

- Created `sales_analysis_db`
- Created five relational tables
- Created `Customers`
- Created `Products`
- Created `Orders`
- Created `Order_Items`
- Created `Payments`
- Defined Primary Keys
- Defined Foreign Keys
- Verified database structure

---

## ✅ Day 2 – Data Insertion

Completed:

- Inserted customer records
- Inserted product records
- Inserted order records
- Inserted order item records
- Inserted payment records
- Verified inserted data using `SELECT *`

---

## ✅ Day 3 – Basic SQL Queries

Implemented:

- `SELECT`
- `WHERE`
- `ORDER BY`
- `DISTINCT`
- `LIMIT`
- `LIKE`
- `BETWEEN`
- Data filtering
- Basic data analysis

---

## ✅ Day 4 – SQL JOIN Operations

Implemented:

- `INNER JOIN`
- `LEFT JOIN`
- `RIGHT JOIN`
- Multi-table JOINs

Created analysis reports for:

- Customer Orders
- Product Sales
- Payment Details

---

## ✅ Day 5 – Aggregate Functions

Implemented:

- `GROUP BY`
- `HAVING`
- `COUNT()`
- `SUM()`
- `AVG()`
- Revenue Analysis
- Customer Sales Analysis
- Product Sales Analysis

---

## ✅ Day 6 – SQL Subqueries

Implemented:

- Single-row Subqueries
- `IN` Subqueries
- Products Above Average Price
- Orders Above Average Value
- Most Expensive Product
- Cheapest Product
- Customers With Multiple Orders
- Business Analysis using Subqueries

---

## ✅ Day 7 – Sales Analysis Report

Created a business-oriented sales analysis report covering:

- Total Revenue
- Total Customers
- Total Orders
- Average Order Value
- Highest Order Value
- Lowest Order Value
- Customer-wise Sales
- Product Revenue
- Payment Status Analysis
- Completed Orders

---

## ✅ Day 8 – SQL Views

Created reusable SQL Views for business reporting:

### 1. Customer Order View
Combines customer information with order details.

### 2. Product Sales View
Provides product-wise quantity sold and revenue.

### 3. Payment Details View
Combines customer, order, and payment information.

### 4. Completed Orders View
Displays completed customer orders.

### 5. Customer Sales Summary View
Provides:

- Total Orders
- Total Sales
- Average Order Value

---

# 📚 SQL Concepts Covered

- Relational Database Design
- Primary Keys
- Foreign Keys
- DDL
- DML
- Data Retrieval
- Data Filtering
- Sorting
- SQL JOINs
- Aggregate Functions
- `GROUP BY`
- `HAVING`
- SQL Subqueries
- SQL Views
- Business Data Analysis
- Business Reporting

---

# 💼 Business Analysis Covered

The project currently supports analysis such as:

- Customer purchasing behavior
- Product performance
- Revenue analysis
- Order analysis
- Payment status analysis
- Completed vs pending orders
- Customer sales performance
- Product revenue performance
- Average order value

---

# 📸 Project Screenshots

Screenshots are organized according to the daily project progress:

| Day | Work |
|---|---|
| Day 1 | Database Design |
| Day 2 | Data Insertion |
| Day 3 | Basic SQL Queries |
| Day 4 | JOIN Queries |
| Day 5 | Aggregate Functions |
| Day 6 | Subqueries |
| Day 7 | Sales Analysis Report |
| Day 8 | SQL Views |

---

# 📄 Project Reports

Weekly project documentation is maintained in the `Report` folder.

### Completed

- ✅ `Week1_Report.md`

### Upcoming

- ⏳ `Week2_Report.md`
- ⏳ `Week3_Report.md`
- ⏳ `Week4_Report.md`
- ⏳ Final Project Report

---

# 📈 Current Progress

| Milestone | Status |
|---|---|
| Database Design | ✅ Completed |
| Data Insertion | ✅ Completed |
| Basic SQL Queries | ✅ Completed |
| SQL JOINs | ✅ Completed |
| Aggregate Functions | ✅ Completed |
| SQL Subqueries | ✅ Completed |
| Sales Analysis Report | ✅ Completed |
| SQL Views | ✅ Completed |
| Advanced SQL | ⏳ Upcoming |
| Power BI Dashboard | ⏳ Upcoming |
| Final Business Report | ⏳ Upcoming |
| Project Presentation | ⏳ Upcoming |

### 🏆 Week 1

**100% Completed**

### 🔄 Week 2

**Day 8 Completed – SQL Views**

---

# 🎯 Upcoming Topics

The next phase of the project will focus on advanced SQL:

- Stored Procedures
- Triggers
- Indexes
- Window Functions
- Common Table Expressions (CTEs)
- SQL Query Optimization
- Advanced Business Case Studies
- Power BI Integration
- Interactive Dashboard
- Final Business Report
- Project Presentation

---

# 🎓 Learning Outcomes

Through this project, I am developing practical skills in:

- Relational Database Management
- SQL Programming
- Data Analysis
- Business Intelligence
- Database Relationships
- Advanced SQL
- Business Reporting
- Git Version Control
- GitHub Project Management

---

# 👨‍💻 Author

## Vishnu Kumar

**Computer Science Graduate**

🔗 **GitHub:**  
https://github.com/vishnuvk-coder

---

## ⭐ Project Status

**Active Development 🚀**

This project is being developed progressively with new SQL concepts, business analysis techniques, reports, screenshots, and dashboards added throughout the project.