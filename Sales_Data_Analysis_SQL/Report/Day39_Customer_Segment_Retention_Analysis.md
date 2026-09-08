# Day 39 — Customer Segment Retention & Churn Risk Analysis

## 1. Introduction

Customer segmentation becomes more valuable when it is connected with customer retention and churn analysis.

During Day 37, customers were segmented using RFM analysis. Day 38 analyzed the revenue and performance of those segments.

Day 39 extends the analysis by studying customer retention, repeat purchasing behavior, inactivity, churn risk, customer lifetime, and revenue at risk.

The objective is to understand which customer segments are active, which customers are becoming inactive, and where the business may lose future revenue.

---

## 2. Objectives

The main objectives of Day 39 are:

1. Analyze customer retention by RFM segment.
2. Compare repeat and one-time customers.
3. Identify customer churn risk indicators.
4. Measure the number of at-risk customers.
5. Identify potentially lost customers.
6. Analyze Champion customer retention.
7. Analyze Loyal customer retention.
8. Measure customer lifetime behavior.
9. Analyze customer inactivity.
10. Estimate revenue associated with inactive customers.
11. Rank customer segments by retention performance.
12. Develop customer retention strategies.

---

## 3. Database Used

Database:

`sales_analysis_db`

Main tables used:

* `customers`
* `orders`
* `order_items`
* `products`
* `payments`

Revenue is calculated using:

`order_items.quantity × products.price`

This approach follows the actual database structure used throughout the project.

---

# 4. Analytical Approach

The analysis uses customer-level transaction data to calculate:

* Total orders
* Last purchase date
* First purchase date
* Customer revenue
* Inactive days
* Recency score
* Frequency score
* Monetary score
* RFM customer segment

RFM segmentation is then connected with retention and churn indicators.

The analysis uses the latest order date available in the database as the reference point for inactivity calculations.

---

# 5. Analysis 1 — Customer Retention by RFM Segment

### Objective

Measure the proportion of repeat customers within each RFM segment.

### Method

Customers are grouped according to their RFM segment.

A customer with two or more orders is considered a repeat customer.

Retention percentage is calculated as:

`Repeat Customers / Total Customers × 100`

### Business Insight

This analysis identifies which RFM segments demonstrate stronger repeat purchasing behavior.

Segments with high retention can be protected through loyalty programs, personalized offers, and relationship-building strategies.

---

# 6. Analysis 2 — Repeat vs One-Time Customers by Segment

### Objective

Compare one-time and repeat customers across customer segments.

### Categories

* One-Time Customer
* Repeat Customer

### Business Insight

A high number of one-time customers indicates an opportunity to improve customer conversion and retention.

Businesses can use:

* Follow-up campaigns
* Personalized recommendations
* Discounts
* Loyalty programs
* Email campaigns

to encourage customers to make additional purchases.

---

# 7. Analysis 3 — Customer Churn / Risk Indicators

### Objective

Classify customers according to their purchasing activity.

The analysis uses inactivity periods:

* Active Customer
* Low Churn Risk
* Medium Churn Risk
* High Churn Risk
* One-Time Customer

### Business Insight

Increasing inactivity generally indicates increasing customer churn risk.

Customers who have previously purchased multiple times but have not purchased recently should receive higher retention priority.

---

# 8. Analysis 4 — At-Risk Customer Count

### Objective

Identify customers who have previously purchased multiple times but have been inactive for more than 90 days.

### Business Value

At-risk customers represent an important retention opportunity because they already have an established relationship with the business.

Possible actions include:

* Personalized offers
* Reminder campaigns
* Product recommendations
* Loyalty rewards
* Re-engagement campaigns

---

# 9. Analysis 5 — Lost Customer Count

### Objective

Identify customers with low purchasing frequency and long periods of inactivity.

The analysis considers customers with:

* Low order frequency
* More than 180 inactive days

### Business Insight

Lost customers can help identify weaknesses in customer retention.

A business can investigate:

* Product dissatisfaction
* Pricing
* Competition
* Poor engagement
* Lack of follow-up
* Product availability

---

# 10. Analysis 6 — Champion Retention Performance

### Objective

Measure how many Champion customers remain active.

Champions are customers with strong:

* Recency
* Frequency
* Monetary value

### Business Importance

Champion customers are among the most valuable customers in an RFM framework.

They should receive strong retention attention.

Recommended strategies include:

* VIP loyalty programs
* Exclusive products
* Early access
* Personalized recommendations
* Premium customer support

---

# 11. Analysis 7 — Loyal Customer Retention Performance

### Objective

Analyze the retention performance of Loyal Customers.

Loyal customers demonstrate strong purchasing frequency and relatively good recency.

### Business Insight

Loyal customers represent a strong opportunity for long-term revenue.

The business can increase their value through:

* Loyalty rewards
* Cross-selling
* Upselling
* Personalized campaigns
* Membership programs

---

# 12. Analysis 8 — Average Customer Lifetime

### Objective

Measure the average customer lifetime according to purchasing behavior.

Customer lifetime is calculated as:

`Last Purchase Date − First Purchase Date`

Customer behavior categories include:

* One-Time Customers
* Occasional Customers
* Regular Customers
* Frequent Customers

### Business Insight

Customers with longer purchasing relationships generally provide more opportunities for repeat revenue.

Increasing customer lifetime can therefore contribute to stronger long-term business performance.

---

# 13. Analysis 9 — Customer Inactivity Analysis

### Objective

Group customers based on the number of days since their latest purchase.

Categories:

* Active: 0–30 Days
* Inactive: 31–90 Days
* At Risk: 91–180 Days
* Churn Risk: 180+ Days

### Business Insight

This analysis creates a simple operational framework for customer retention campaigns.

For example:

**0–30 days**

Maintain engagement.

**31–90 days**

Start re-engagement campaigns.

**91–180 days**

Use stronger retention offers.

**180+ days**

Launch win-back or churn recovery campaigns.

---

# 14. Analysis 10 — Revenue at Risk from Inactive Customers

### Objective

Estimate the amount of historical revenue associated with customers who have become inactive.

Revenue is divided into:

* Active Revenue
* At-Risk Revenue
* High Churn Risk Revenue

### Business Insight

Customer count alone does not show the complete business impact of churn.

A smaller group of inactive customers may represent a significant amount of historical revenue.

Therefore, revenue-at-risk analysis helps businesses prioritize retention activities.

---

# 15. Analysis 11 — Segment Retention Ranking

### Objective

Rank RFM segments according to their retention percentage.

The `RANK()` window function is used to determine the retention position of each segment.

### Business Insight

The ranking helps management quickly identify:

* Strongest-retained segment
* Weakest-retained segment
* Segments requiring intervention

This provides a simple framework for prioritizing retention efforts.

---

# 16. Analysis 12 — Final Customer Retention Business Summary

The final analysis combines:

* Customer segment
* Customer count
* Average orders
* Average customer revenue
* Total segment revenue
* Average inactive days
* Active customers
* Inactive customers

### Business Value

This final table provides a management-level view of customer retention performance.

It can be used as a foundation for:

* Customer retention dashboards
* CRM strategy
* Marketing campaigns
* Churn prevention
* Revenue protection

---

# 17. Key SQL Concepts Used

Day 39 demonstrates:

* `WITH`
* Common Table Expressions (CTEs)
* `JOIN`
* `GROUP BY`
* `COUNT`
* `SUM`
* `AVG`
* `CASE`
* `DATEDIFF()`
* `MAX()`
* `MIN()`
* `NTILE()`
* `RANK()`
* Window Functions
* Conditional aggregation
* Customer segmentation
* Retention analysis
* Churn analysis
* Revenue analysis

---

# 18. Business Insights

Day 39 provides several important business perspectives.

### 1. Retention is more valuable than customer count alone

A large customer base does not necessarily indicate strong customer relationships.

Repeat purchasing behavior provides a stronger indication of customer engagement.

### 2. Champions require protection

Champion customers are highly valuable and should receive priority retention strategies.

### 3. At-Risk customers represent an immediate opportunity

Customers with previous purchasing activity but increasing inactivity may still be recoverable.

### 4. Lost customers indicate retention challenges

Long-term inactive customers can help identify potential weaknesses in the customer experience.

### 5. Revenue at risk is important

A business should not only ask:

> "How many customers are inactive?"

It should also ask:

> "How much revenue is associated with those inactive customers?"

### 6. Customer lifetime matters

Increasing the length of customer relationships can create additional opportunities for repeat purchases.

---

# 19. Customer Retention Strategy

## Champions

Strategy:

* VIP programs
* Exclusive offers
* Early product access
* Personalized recommendations
* Premium support

## Loyal Customers

Strategy:

* Loyalty rewards
* Cross-selling
* Upselling
* Membership benefits
* Personalized campaigns

## New Customers

Strategy:

* Welcome campaigns
* First-to-second purchase incentives
* Product recommendations
* Educational content

## Potential Customers

Strategy:

* Personalized promotions
* Product discovery
* Cross-selling
* Engagement campaigns

## At-Risk Customers

Strategy:

* Win-back campaigns
* Special offers
* Personalized communication
* Reminder campaigns

## Lost Customers

Strategy:

* Re-engagement campaigns
* Customer feedback
* Win-back discounts
* Churn analysis

---

# 20. Strategic Business Applications

The Day 39 analysis can support:

* CRM strategy
* Customer retention
* Churn prevention
* Revenue protection
* Marketing prioritization
* Customer lifecycle management
* Loyalty programs
* Personalized marketing
* Revenue-at-risk analysis

---

# 21. Day 39 SQL Techniques

The project demonstrates practical use of:

### CTEs

Used to break complex customer analysis into manageable steps.

### Window Functions

Used for:

* `NTILE()`
* `RANK()`

### Conditional Aggregation

Used to calculate:

* Active customers
* Inactive customers
* Repeat customers
* One-time customers

### Date Analysis

`DATEDIFF()` is used to measure customer inactivity and lifetime.

### RFM Segmentation

Customer recency, frequency, and monetary value are used to classify customers.

---

# 22. Project Files

```text
SQL/
└── customer_segment_retention_analysis.sql

Report/
└── Day39_Customer_Segment_Retention_Analysis.md

Screenshots/
└── Day 39/
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

# 23. Skills Demonstrated

* Advanced SQL
* Customer analytics
* RFM segmentation
* Retention analysis
* Churn analysis
* Customer lifecycle analysis
* Revenue analysis
* Revenue-at-risk analysis
* Window functions
* CTEs
* Business intelligence
* Data-driven decision making

---

# 24. Day 39 Outcome

Day 39 successfully extends the customer analytics framework from RFM segmentation and segment performance into customer retention and churn-risk analysis.

The analysis identifies customer inactivity, repeat purchasing behavior, at-risk customers, potentially lost customers, customer lifetime patterns, and revenue associated with inactive customers.

This creates a practical framework for customer retention and revenue protection.

---

# 25. Conclusion

Customer segmentation becomes significantly more useful when businesses understand what happens after customers are classified.

Day 39 connects RFM segments with retention and churn behavior.

The analysis helps answer important business questions:

* Which customers are retained?
* Which customers are becoming inactive?
* Which customers are at risk?
* How many customers may be lost?
* How much revenue is associated with inactive customers?
* Which segments require the highest retention priority?

Therefore, Day 39 provides a strong foundation for customer retention strategy, churn prevention, and revenue protection.
