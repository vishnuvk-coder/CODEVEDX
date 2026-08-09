# 📊 Sales Data Analysis using SQL

A hands-on SQL portfolio project focused on **relational database design, data manipulation, SQL analysis, and business reporting** using MySQL.

This project simulates a real-world sales management system and demonstrates practical SQL skills relevant to **Data Analyst and SQL Developer roles**.

---

## 🚀 Project Overview

This project follows a structured SQL data-analysis workflow:

- Designing a relational database
- Creating tables with Primary Keys and Foreign Keys
- Inserting and managing business data
- Writing SQL queries for data analysis
- Filtering and sorting data
- Performing SQL JOIN operations
- Using Aggregate Functions
- Implementing SQL Subqueries
- Creating SQL Views
- Developing Stored Procedures
- Generating business-oriented reports
- Managing the project using Git and GitHub

---

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| **MySQL 8.0** | Database management and SQL analysis |
| **MySQL Workbench** | Database development and query execution |
| **SQL** | Data querying and business analysis |
| **Git** | Version control |
| **GitHub** | Project management and portfolio |

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
│   ├── views.sql
│   └── stored_procedures.sql
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
│   └── Day 9/
│
├── Presentation/
│
├── Report/
│   ├── Week1_Report.md
│   └── Week2_Report.md
│
└── README.md
```

---

# 🗃️ Database Schema

The database consists of five related tables:

| Table | Description |
|---|---|
| `Customers` | Stores customer information |
| `Products` | Stores product details and pricing |
| `Orders` | Stores customer order records |
| `Order_Items` | Stores products included in each order |
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
- Verified records using `SELECT *`

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

Created a business-oriented SQL analysis report covering:

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

### Customer Order View
Combines customer information with order details.

### Product Sales View
Provides product-wise quantity sold and revenue.

### Payment Details View
Combines customer, order, and payment information.

### Completed Orders View
Displays completed customer orders.

### Customer Sales Summary View
Provides:

- Total Orders
- Total Sales
- Average Order Value

---

## 🔄 Day 9 – SQL Stored Procedures

Currently working on reusable Stored Procedures for business analysis.

Implemented procedures for:

- Retrieving all customers
- Retrieving customer-specific orders
- Filtering orders by status
- Filtering products by category
- Generating customer sales summaries

### Stored Procedures

```text
Get_All_Customers()
Get_Customer_Orders(customer_id)
Get_Orders_By_Status(status)
Get_Products_By_Category(category)
Get_Customer_Sales_Summary(customer_id)
```

Each procedure is tested using `CALL` statements in MySQL Workbench.

---

# 📚 SQL Concepts Covered

### Database Fundamentals

- Relational Database Design
- Primary Keys
- Foreign Keys
- Table Relationships
- Database Constraints

### SQL Data Operations

- DDL
- DML
- Data Retrieval
- Data Filtering
- Sorting

### SQL Analysis

- Aggregate Functions
- `GROUP BY`
- `HAVING`
- JOIN Operations
- Subqueries
- SQL Views
- Stored Procedures

### Development & Version Control

- Git
- GitHub
- SQL Project Organization
- Daily Development Tracking

---

# 💼 Business Analysis

The project supports several real-world business analysis scenarios:

- Customer purchasing behavior
- Product performance
- Revenue analysis
- Order analysis
- Payment status analysis
- Completed vs Pending Orders
- Customer sales performance
- Product revenue performance
- Average Order Value
- Customer order history
- Category-based product analysis

---

# 📸 Project Screenshots

Screenshots are organized by project day:

| Day | Module |
|---|---|
| Day 1 | Database Design |
| Day 2 | Data Insertion |
| Day 3 | Basic SQL Queries |
| Day 4 | JOIN Operations |
| Day 5 | Aggregate Functions |
| Day 6 | Subqueries |
| Day 7 | Sales Analysis Report |
| Day 8 | SQL Views |
| Day 9 | Stored Procedures |

---

# 📄 Project Reports

Project documentation is maintained in the `Report` folder.

### Reports

- ✅ Week 1 Report
- 🔄 Week 2 Report
- ⏳ Final Project Report

The reports document the SQL concepts, business analysis, screenshots, and progress completed during each project phase.

---

# 📈 Current Project Status

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
| Stored Procedures | 🔄 In Progress |
| Triggers | ⏳ Upcoming |
| Indexes | ⏳ Upcoming |
| Window Functions | ⏳ Upcoming |
| CTEs | ⏳ Upcoming |
| SQL Optimization | ⏳ Upcoming |
| Power BI Dashboard | ⏳ Upcoming |
| Final Business Report | ⏳ Upcoming |
| Project Presentation | ⏳ Upcoming |

---

# 🎯 Upcoming Topics

The next phase of the project will focus on advanced SQL and Business Intelligence:

1. **Stored Procedures**
2. **Triggers**
3. **Indexes**
4. **Window Functions**
5. **Common Table Expressions (CTEs)**
6. **SQL Query Optimization**
7. **Advanced Business Case Studies**
8. **Power BI Integration**
9. **Interactive Power BI Dashboard**
10. **Final Business Report**
11. **Project Presentation**

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

# ⭐ Project Status

**🚀 Active Development**

This project is being developed progressively with new SQL concepts, business analysis techniques, reports, screenshots, and Business Intelligence components.

---

## 📌 Current Focus

**Week 2 – Day 9**

> 🔄 SQL Stored Procedures

**Next:** Triggers → Indexes → Window Functions → CTEs → SQL Optimization → Power BI Dashboard