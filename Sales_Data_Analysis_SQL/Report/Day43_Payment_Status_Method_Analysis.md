# Day 43 — Payment Status & Payment Method Analysis

## Overview

Day 43 focuses on analysing payment methods, payment statuses, payment transaction trends, pending payments, and customer payment activity using SQL.

The analysis is based on the actual columns available in the `payments` table.

## Database Used

`sales_analysis_db`

## Tables Used

- `payments`
- `orders`

## Actual Payments Table Columns

- `payment_id`
- `order_id`
- `payment_date`
- `payment_method`
- `payment_status`

The `payments` table does not contain a payment amount column. Therefore, this analysis focuses on payment records, payment methods, payment statuses, and payment dates instead of payment revenue.

## Business Objectives

1. Identify the most commonly used payment methods.
2. Analyse the distribution of payment statuses.
3. Compare payment methods with payment statuses.
4. Analyse monthly payment transactions.
5. Analyse yearly payment transactions.
6. Compare paid and pending payments by month.
7. Calculate payment status percentages.
8. Identify pending payment orders.
9. Identify completed paid payment orders.
10. Combine order details with payment details.
11. Analyse customer payment activity.
12. Create a final payment analysis summary.

## Analyses Completed

### 1. Payment Method Distribution

Counts payment records for each payment method.

**Business use:** Helps identify commonly used payment methods.

### 2. Payment Status Distribution

Counts payment records according to their status.

**Business use:** Shows the number of paid and pending payments.

### 3. Payment Method and Status Analysis

Compares each payment method with its payment status.

**Business use:** Helps identify which payment methods have more pending or paid transactions.

### 4. Monthly Payment Transactions

Counts payment records for each month.

**Business use:** Helps understand payment transaction trends over time.

### 5. Yearly Payment Transactions

Counts payment records for each year.

**Business use:** Supports yearly payment activity analysis.

### 6. Monthly Paid and Pending Payments

Compares paid and pending payment records month by month.

**Business use:** Helps monitor payment completion trends.

### 7. Payment Status Percentage

Calculates the percentage contribution of each payment status.

**Business use:** Helps understand the overall payment completion rate.

### 8. Pending Payment Orders

Displays all orders with pending payment status.

**Business use:** Helps identify orders that may require payment follow-up.

### 9. Paid Payment Orders

Displays all orders with paid payment status.

**Business use:** Helps identify completed payment transactions.

### 10. Orders with Payment Details

Combines order information with payment information.

**Business use:** Provides a complete view of order and payment activity.

### 11. Customer Payment Status Analysis

Analyses total orders, paid payments, and pending payments for each customer.

**Business use:** Helps identify customers with pending payment activity.

### 12. Final Payment Analysis Summary

Provides a summary of payment records, orders, payment methods, payment statuses, paid records, pending records, and payment dates.

**Business use:** Provides a high-level view of payment activity.

## SQL Concepts Used

- `SELECT`
- `WHERE`
- `INNER JOIN`
- `GROUP BY`
- `ORDER BY`
- `COUNT`
- `COUNT(DISTINCT)`
- `SUM`
- `CASE`
- `ROUND`
- `DATE_FORMAT`
- `YEAR`
- `MIN`
- `MAX`
- Subqueries
- Conditional aggregation
- Payment status classification

## Business Applications

This analysis can help businesses:

- Identify preferred payment methods.
- Monitor paid and pending payments.
- Track monthly payment activity.
- Identify pending payment orders.
- Analyse customer payment behaviour.
- Improve payment follow-up.
- Monitor payment completion trends.
- Support operational reporting.

## Key Learning Outcomes

After completing Day 43, the following skills were practised:

- Payment method analysis.
- Payment status analysis.
- Conditional aggregation.
- Monthly and yearly grouping.
- Customer-level payment analysis.
- Order-payment joins.
- Percentage calculation.
- SQL business reporting.

## Project Status

**Day 43 completed successfully.**