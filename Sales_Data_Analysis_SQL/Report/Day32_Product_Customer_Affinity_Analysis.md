# Day 32 — Product Customer Affinity & Cross-Selling Analysis

## 📊 Project

**Sales Data Analysis Using SQL**

**Day:** 32
**Topic:** Product Customer Affinity & Cross-Selling Analysis
**Database:** MySQL 8.0

---

## 🎯 Objective

The objective of Day 32 is to analyze relationships between products based on customer purchasing behavior.

The analysis identifies products that are frequently purchased by the same customers and uses these relationships to identify potential cross-selling and product-bundling opportunities.

---

## 🧠 Concepts Covered

* Customer-product mapping
* Product affinity analysis
* Product pair analysis
* Cross-selling analysis
* Product bundling
* Customer purchase relationships
* Unique customer analysis
* Product pair ranking
* Affinity score calculation
* Cross-selling opportunity classification
* CTEs
* Self JOIN
* Multi-table JOINs
* `COUNT(DISTINCT)`
* `SUM()`
* `GROUP BY`
* `HAVING`
* `CASE`
* Window functions
* `RANK()`
* Business reporting

---

## 🔍 Analysis Performed

### 1. Customer-Product Purchase Mapping

Identified the products purchased by each customer and calculated:

* Total units purchased
* Total revenue generated
* Customer-product relationships

This provides the foundation for product affinity analysis.

### 2. Product Pair Analysis

Identified pairs of products purchased by the same customers.

The analysis uses a self-join on customer-product relationships to determine which products are commonly purchased together.

### 3. Top Product Pairs

Ranked product combinations according to the number of customers who purchased both products.

This helps identify frequently associated products.

### 4. Product Pair Value Analysis

Calculated the combined value of products in each identified product pair.

This provides an additional perspective for evaluating potential product bundles.

### 5. Product Affinity Score

Calculated an affinity score based on the proportion of customers purchasing both products relative to the customer base of the individual products.

A higher affinity score indicates a stronger purchasing relationship between two products.

### 6. Product Pair Ranking

Applied the `RANK()` window function to rank product pairs according to their affinity score.

### 7. Cross-Selling Opportunity Analysis

Product pairs were classified into:

* High Cross-Sell Opportunity
* Medium Cross-Sell Opportunity
* Low Cross-Sell Opportunity

This converts SQL analysis into a practical business classification.

### 8. Top Cross-Selling Product Pairs

Identified the strongest product combinations that could potentially be used for:

* Product recommendations
* Bundle offers
* Cross-selling campaigns
* Promotional strategies

### 9. Product Affinity Business Summary

Created an overall summary containing:

* Total product pairs
* Highest customer count for a product pair
* Average customer count across product pairs

---

## 📈 Key Business Metrics

| Metric                 | Description                                         |
| ---------------------- | --------------------------------------------------- |
| Customers Buying Both  | Number of customers purchasing both products        |
| Product Pair           | Combination of two different products               |
| Affinity Score         | Strength of the purchasing relationship             |
| Product Customer Count | Number of customers purchasing a product            |
| Bundle Value           | Combined value of two products                      |
| Cross-Sell Category    | Business classification of the product relationship |
| Affinity Rank          | Ranking of product pairs by affinity                |

---

## 💼 Business Value

Product affinity analysis can help businesses:

* Identify products frequently purchased together
* Create product bundles
* Improve cross-selling strategies
* Build recommendation systems
* Increase average order value
* Design targeted promotions
* Improve product placement
* Identify complementary products
* Support personalized marketing
* Improve customer purchasing opportunities

---

## 🧮 SQL Techniques Used

```sql
WITH
SELECT
DISTINCT
JOIN
SELF JOIN
COUNT()
COUNT(DISTINCT)
SUM()
GROUP BY
HAVING
CASE
RANK()
ORDER BY
LIMIT
```

---

## 📂 Files Created

```text
SQL/
└── product_customer_affinity_analysis.sql

Report/
└── Day32_Product_Customer_Affinity_Analysis.md

Screenshots/
└── Day 32/
```

---

## 🏆 Day 32 Outcome

Day 32 expanded the project from individual product purchase behavior into relationships between products.

The project now demonstrates how customer purchasing data can be used to identify product combinations and cross-selling opportunities.

### Customer & Product Analytics Journey

**Customer Revenue**

↓

**Customer Behavior**

↓

**Customer Retention**

↓

**Customer Lifetime Value**

↓

**RFM Segmentation**

↓

**Customer Churn**

↓

**Customer Cohort & Retention**

↓

**Customer Purchase Frequency**

↓

**Product Purchase Behavior**

↓

**Product Customer Affinity**

↓

**Cross-Selling Opportunities**

Day 32 strengthens the project's relevance to **Data Analyst, Business Analyst, and Business Intelligence roles** by demonstrating practical product affinity and cross-selling analysis using SQL.
