# Day 46: Data Quality & Integrity Analysis

## 1. Introduction

Data quality is an important part of every data analysis project. Before performing business analysis, it is necessary to check whether the database contains complete, valid, consistent, and reliable data.

In **Day 46**, data quality and integrity checks were performed on the sales analysis database using **MySQL**.

The analysis focused on identifying duplicate records, missing relationships, invalid values, missing dates, and inconsistencies between related tables.

---

## 2. Database Used

```sql
sales_analysis_db
```

## 3. Tables Used

The following tables were used:

* `customers`
* `products`
* `orders`
* `order_items`
* `payments`

---

## 4. Objectives

The main objectives of this analysis were:

1. Check the structure of all database tables.
2. Identify duplicate customer records.
3. Identify duplicate product records.
4. Identify duplicate order records.
5. Identify duplicate payment records.
6. Find orders without matching customers.
7. Find order items without matching orders.
8. Find order items without matching products.
9. Find payments without matching orders.
10. Identify invalid order quantities.
11. Identify invalid product prices.
12. Find orders without order items.
13. Find products that have never been ordered.
14. Check missing order dates and payment dates.
15. Prepare a final database quality summary.

---

## 5. SQL Concepts Used

The following SQL concepts were used:

* `USE`
* `DESCRIBE`
* `SELECT`
* `COUNT()`
* `SUM()`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `LEFT JOIN`
* `WHERE`
* `IS NULL`
* `UNION ALL`
* Conditional expressions
* Duplicate record detection
* Referential integrity checking
* Data validation

---

## 6. Analyses Performed

### 6.1 Table Structure Checking

The structure of all five database tables was checked using the `DESCRIBE` command.

This helped verify the available columns and understand the relationships between the tables.

---

### 6.2 Null Customer ID Checking

The `customers` table was checked for missing customer IDs.

Missing customer IDs can create problems when joining customer information with order records.

---

### 6.3 Duplicate Customer Records

Customer IDs were grouped and checked for duplicate occurrences.

Duplicate customer records can affect customer counts, customer analysis, and revenue calculations.

---

### 6.4 Duplicate Product Records

Product IDs were grouped to identify duplicate product records.

Duplicate product records can produce incorrect product performance and revenue results.

---

### 6.5 Duplicate Order Records

Order IDs were checked for repeated records.

Duplicate orders may result in double-counting sales and customer activity.

---

### 6.6 Duplicate Payment Records

Payment IDs were checked for duplicate payment records.

Duplicate payment records may affect payment activity and payment status analysis.

---

### 6.7 Orders Without Matching Customers

The `orders` table was joined with the `customers` table using `customer_id`.

Orders without a matching customer were identified as possible referential integrity issues.

---

### 6.8 Order Items Without Matching Orders

The `order_items` table was joined with the `orders` table using `order_id`.

Order items without matching orders may represent incomplete or incorrect records.

---

### 6.9 Order Items Without Matching Products

The `order_items` table was joined with the `products` table using `product_id`.

These records may cause problems during product and revenue analysis.

---

### 6.10 Payments Without Matching Orders

The `payments` table was joined with the `orders` table using `order_id`.

Payments without matching orders were identified as possible orphan payment records.

---

### 6.11 Invalid Order Quantities

The `order_items` table was checked for:

* Missing quantities
* Zero quantities
* Negative quantities

Invalid quantities can produce incorrect sales calculations.

---

### 6.12 Invalid Product Prices

The `products` table was checked for:

* Missing prices
* Zero prices
* Negative prices

Invalid prices can affect revenue and profitability calculations.

---

### 6.13 Orders Without Order Items

Orders without related order items were identified.

An order without items may be incomplete or incorrectly recorded.

---

### 6.14 Products That Have Never Been Ordered

Products without matching order items were identified.

These products may represent inactive products or products that have not yet generated sales.

---

### 6.15 Missing Order Dates

Orders with missing order dates were counted.

Missing order dates can affect monthly, yearly, and time-series analysis.

---

### 6.16 Missing Payment Dates

Payments with missing payment dates were counted.

Missing payment dates can affect payment trends and monthly payment analysis.

---

### 6.17 Multiple Payment Records per Order

Orders with more than one payment record were identified.

Multiple payment records may be valid in some business cases. However, they should be reviewed to identify possible duplicate payments or partial-payment situations.

---

## 7. Data Quality Issue Categories

| Issue Category        | Description                                        |
| --------------------- | -------------------------------------------------- |
| Duplicate Records     | The same identifier appears multiple times         |
| Missing Relationships | A record has no matching record in a related table |
| Invalid Quantities    | Quantity is missing, zero, or negative             |
| Invalid Prices        | Price is missing, zero, or negative                |
| Missing Dates         | Order or payment date is unavailable               |
| Orphan Records        | A child record has no matching parent record       |
| Unused Products       | A product has no related order item                |

---

## 8. Business Applications

Data quality analysis can help businesses to:

1. Improve database accuracy.
2. Prevent duplicate sales records.
3. Improve customer reporting.
4. Identify incomplete orders.
5. Detect incorrect payment records.
6. Improve revenue calculations.
7. Improve product performance analysis.
8. Maintain reliable business dashboards.
9. Support accurate business decisions.
10. Improve database maintenance processes.

---

## 9. Key Learning Outcomes

After completing Day 46, the following skills were practiced:

* Detecting duplicate records.
* Checking null values.
* Finding orphan records.
* Validating numeric values.
* Checking relationships between tables.
* Using `LEFT JOIN` for integrity analysis.
* Using `GROUP BY` and `HAVING` for duplicate detection.
* Preparing a database quality summary.
* Understanding the importance of clean data before analysis.

---

## 10. Project Files

```text
SQL/
└── day46_data_quality_integrity_analysis.sql

Report/
└── Day46_Data_Quality_Integrity_Analysis.md

Screenshots/
└── Day 46/
    ├── Query_01.png
    ├── Query_02.png
    ├── Query_03.png
    ├── Query_04.png
    ├── Query_05.png
    ├── Query_06.png
    ├── Query_07.png
    ├── Query_08.png
    ├── Query_09.png
    ├── Query_10.png
    ├── Query_11.png
    └── Query_12.png
```

---

## 11. Conclusion

Day 46 focused on checking the quality and integrity of the sales analysis database.

The analysis examined different types of possible data issues, including duplicate records, missing relationships, invalid quantities, invalid prices, missing dates, and incomplete records.

Data quality analysis is an important step before performing advanced business intelligence and analytics because accurate results depend on reliable and consistent data.

This analysis improved understanding of database validation, referential integrity, duplicate detection, and data quality monitoring using MySQL.
