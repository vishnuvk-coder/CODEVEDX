# 📊 Day 34 — Customer Cross-Selling & Product Recommendation Analysis

## 📌 Overview

Day 34 focuses on analyzing customer purchasing relationships between products to identify cross-selling and product recommendation opportunities.

The analysis examines products purchased by the same customers, identifies frequently purchased product pairs, measures product affinity, ranks product combinations, generates cross-selling recommendations, and estimates potential revenue opportunities.

This analysis extends the project from individual customer-product purchase analysis into **product relationship and recommendation analytics**.

---

# 🎯 Objectives

The main objectives of Day 34 are:

* Identify products purchased by the same customers
* Analyze customer-product purchasing relationships
* Identify frequently purchased product pairs
* Measure the number of customers purchasing product combinations
* Calculate product affinity scores
* Rank product pairs based on purchasing affinity
* Identify high-affinity product combinations
* Discover cross-selling opportunities
* Generate product recommendations
* Analyze customer-based product recommendations
* Estimate potential revenue opportunities
* Provide actionable business insights

---

# 🗄️ Database Used

```text
sales_analysis_db
```

---

# 📋 Tables Used

## 1. Orders

The `orders` table is used to identify customers and their orders.

Important columns:

* `order_id`
* `customer_id`

---

## 2. Order_Items

The `order_items` table is used to identify products purchased within each order.

Important columns:

* `order_id`
* `product_id`
* `quantity`

---

## 3. Products

The `products` table is used to retrieve product information and product pricing.

Important columns:

* `product_id`
* `product_name`
* `price`

---

# 🔎 Day 34 Analyses

## 1. Customer-Product Purchase Mapping

This analysis identifies which products have been purchased by each customer.

### Purpose

The result provides the foundation for understanding customer purchasing behavior and product relationships.

### Business Application

Businesses can use this information to understand:

* Customer product preferences
* Product ownership
* Customer purchase history
* Potential recommendation opportunities

---

# 2. Product Pair Analysis

This analysis identifies pairs of products purchased by the same customers.

A self-join approach is used to compare products associated with the same customers.

### Purpose

To identify products that customers commonly purchase together.

### Business Application

Product pairs can be used for:

* Product bundles
* Cross-selling
* Recommendation systems
* Promotional campaigns

---

# 3. Top Product Pairs by Customer Count

This analysis ranks product combinations according to the number of customers who purchased both products.

### Purpose

To identify the most frequently associated product combinations.

### Business Application

High-frequency product pairs can be prioritized for:

* Cross-selling campaigns
* Bundle offers
* Product recommendations
* Marketing promotions

---

# 4. Product Pair Revenue Analysis

This analysis measures the combined revenue associated with product pairs.

The calculation considers product quantity and product price.

### Purpose

To identify product combinations that have strong revenue potential.

### Business Application

Businesses can use the results to determine which product combinations may generate higher sales when promoted together.

---

# 5. Product Affinity Score

Product affinity measures the strength of the relationship between two products based on customer purchasing overlap.

The analysis compares the number of customers purchasing both products with the number of customers purchasing either product.

### Purpose

To measure how strongly two products are associated with each other.

### Business Interpretation

A higher affinity score indicates a stronger relationship between the products.

### Business Application

High-affinity products can be considered for:

* Product bundles
* Recommendations
* Cross-selling
* Personalized offers

---

# 6. Product Pair Affinity Ranking

Product pairs are ranked from highest to lowest according to their affinity score.

### Purpose

To prioritize the strongest product relationships.

### Business Application

The ranking can help management identify the most valuable product combinations for recommendation and marketing strategies.

---

# 7. High-Affinity Product Pairs

This analysis filters product combinations that have meaningful customer overlap and strong purchasing relationships.

### Purpose

To identify product pairs with strong cross-selling potential.

### Business Application

High-affinity combinations can be used for:

* Bundle creation
* Discount campaigns
* Recommendation engines
* Targeted advertising

---

# 8. Cross-Selling Opportunities

Cross-selling analysis identifies additional products that can be recommended to customers based on products they have already purchased.

### Example

```text
Customer purchases Product A
            ↓
Analyze related products
            ↓
Identify Product B
            ↓
Recommend Product B
```

### Purpose

To increase the number of products purchased by existing customers.

### Business Application

Cross-selling can help improve:

* Average order value
* Customer revenue
* Product visibility
* Customer engagement
* Sales opportunities

---

# 9. Top Cross-Selling Product Pairs

This analysis ranks the strongest product combinations that can be used for cross-selling.

### Purpose

To identify the most promising product combinations for recommendation campaigns.

### Business Application

Sales and marketing teams can focus their efforts on the highest-performing product relationships.

---

# 10. Customer-Based Product Recommendations

This analysis connects products purchased by customers with other products purchased by customers with similar purchasing behavior.

### Purpose

To create a basic customer-product recommendation framework using SQL.

### Business Application

This type of analysis can support:

* Personalized recommendations
* E-commerce recommendation systems
* Targeted offers
* Customer-specific promotions

---

# 11. Revenue Opportunity from Cross-Selling

This analysis estimates potential revenue opportunities from product combinations.

The analysis considers:

* Customer overlap
* Product prices
* Product combinations

### Purpose

To identify product pairs that could generate significant additional revenue through cross-selling.

### Business Application

Businesses can prioritize product combinations that have both:

* Strong customer purchasing relationships
* High potential revenue value

---

# 12. Final Cross-Selling Business Summary

The final analysis provides an overall summary of product pair relationships.

The summary includes:

* Total product pairs
* Maximum customer overlap
* Average customer overlap
* Strong cross-selling pairs
* Moderate cross-selling pairs

### Purpose

To provide a high-level view of the cross-selling potential within the sales database.

---

# 🧠 SQL Concepts Used

Day 34 uses several intermediate and advanced SQL concepts:

* `SELECT`
* `DISTINCT`
* `INNER JOIN`
* Self-JOIN
* `GROUP BY`
* `COUNT()`
* `COUNT(DISTINCT)`
* `SUM()`
* `AVG()`
* `MAX()`
* `CASE`
* `HAVING`
* `ORDER BY`
* `LIMIT`
* Common Table Expressions (CTEs)
* Window Functions
* `ROW_NUMBER()`
* Subqueries
* Percentage calculations
* Revenue calculations
* Product affinity calculations

---

# 📊 Analytical Approach

The Day 34 analysis follows this process:

```text
Customer Purchase Data
        ↓
Customer-Product Mapping
        ↓
Product Pair Identification
        ↓
Customer Overlap Analysis
        ↓
Product Affinity Calculation
        ↓
Affinity Ranking
        ↓
Cross-Selling Opportunities
        ↓
Product Recommendations
        ↓
Revenue Opportunity Analysis
        ↓
Business Summary
```

---

# 💼 Business Insights

The analysis provides several important business applications.

## Product Bundling

Products frequently purchased together can be combined into bundles.

## Cross-Selling

Customers purchasing one product can be encouraged to purchase related products.

## Product Recommendations

Frequently associated products can be recommended to customers.

## Revenue Growth

Cross-selling related products can create additional revenue opportunities.

## Customer Personalization

Customer purchase history can be used to create personalized product recommendations.

## Marketing Optimization

High-affinity product combinations can be targeted through promotional campaigns.

---

# 📈 Cross-Selling Strategy

A practical cross-selling strategy can follow this process:

```text
Customer purchases Product A
            ↓
Find customers who also purchased other products
            ↓
Identify Product B with strong purchasing overlap
            ↓
Calculate product affinity
            ↓
Evaluate revenue opportunity
            ↓
Recommend Product B
            ↓
Measure additional sales
```

---

# 📂 Project Files

## SQL File

```text
SQL/customer_cross_selling_analysis.sql
```

## Report File

```text
Report/Day34_Customer_Cross_Selling_Analysis.md
```

## Screenshots

```text
Screenshots/Day 34/
```

---

# 📸 Screenshot Checklist

The following screenshots should be captured from MySQL Workbench after successfully executing each query:

```text
Query_01.png
Query_02.png
Query_03.png
Query_04.png
Query_05.png
Query_06.png
Query_07.png
Query_08.png
Query_09.png
Query_10.png
Query_11.png
Query_12.png
```

---

# 🏆 Outcome

Day 34 successfully extends the SQL sales analysis project into **customer cross-selling and product recommendation analytics**.

The analysis demonstrates how SQL can be used to identify product relationships, measure purchasing affinity, discover cross-selling opportunities, generate product recommendations, and estimate potential revenue opportunities.

This milestone strengthens the project's focus on practical business intelligence and data-driven decision making.

---

# 🚀 Skills Demonstrated

* Advanced SQL
* Customer Analytics
* Product Analytics
* Customer-Product Analysis
* Product Pair Analysis
* Product Affinity Analysis
* Cross-Selling Analysis
* Product Recommendation Analysis
* Revenue Opportunity Analysis
* CTEs
* Self-Joins
* Window Functions
* Business Intelligence
* Data-Driven Decision Making

---

# ✅ Day 34 Status

**Completed — Customer Cross-Selling & Product Recommendation Analysis**

The project now contains **34 days of SQL-based business analysis**, progressing from SQL fundamentals and database design to advanced customer, product, revenue, retention, affinity, recommendation, and cross-selling analytics.
