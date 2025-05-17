# Data Analytics SQL Assessment

This repository contains SQL solutions to a business-focused Data Analyst Proficiency Assessment. The tasks involve solving real-world problems using structured queries with emphasis on correctness, efficiency, and clarity.

---

## Overview

Each task was completed using SQL queries optimized for correctness, efficiency, and clarity. The dataset included four key tables:
- `users_customuser`: Customer demographic and registration data
- `savings_savingsaccount`: Records of deposit transactions
- `plans_plan`: Savings and investment plan information
- `withdrawals_withdrawal`: Withdrawal transaction history (not used)

---

## Question-by-Question Summary

### **Question 1 – High-Value Customers with Multiple Products**

**Approach:**  
Customers with at least one savings plan and one investment plan were identified using plan type flags (`is_a_fund = 0` for savings and `1` for investment). Common Table Expressions (CTEs) were used to:
- Count savings plans per user
- Count investment plans per user
- Sum total deposits from the savings accounts

These were joined with the customer table and filtered for customers who met both conditions. Final results were sorted by total deposits.

**Challenges & Resolution:**  
Joining the `plans_plan` table multiple times led to inefficient queries. This was resolved by isolating logic into separate CTEs for savings and investment plans. This structure improved clarity and performance.

---

### **Question 2 – Transaction Frequency Analysis**

**Approach:**  
This query calculated the average number of transactions per customer per month, then categorized customers into:
- High Frequency (≥10/month)
- Medium Frequency (3–9/month)
- Low Frequency (≤2/month)

CTEs were used to compute transaction counts, active periods in months (based on earliest and latest transaction dates), and per-user averages. A final aggregation step produced the count and average rate per category.

**Challenges & Resolution:**  
Handling varying transaction spans required estimating user activity periods accurately. `DATEDIFF()` was used to calculate the number of days active, and `GREATEST(1, ...)` ensured no division by zero errors. Using CTEs made each calculation step clean and traceable.

---

### **Question 3 – Account Inactivity Alert**

**Approach:**  
To find inactive accounts, the latest transaction date per plan was obtained using a `LEFT JOIN` between `plans_plan` and `savings_savingsaccount`. The query identified:
- Plans with no transactions at all
- Plans whose last transaction was over 365 days ago

The number of inactivity days was calculated using `DATEDIFF()`, and results were sorted by longest inactivity.

**Challenges & Resolution:**  
To include accounts with no transaction history, a `LEFT JOIN` was required instead of an `INNER JOIN`. This ensured all plans were evaluated, even those without any recorded transactions. Using `GROUP BY` and `MAX()` prevented duplicate rows per plan.

---

### **Question 4 – Customer Lifetime Value (CLV) Estimation**

**Approach:**  
Each customer’s CLV was estimated using total transaction volume, tenure (in months since signup), and a profit assumption of 0.1% per transaction. The final CLV formula incorporated:
- Total confirmed amount (converted from kobo to Naira)
- Total number of transactions
- Tenure in months (with a minimum of 1)

CTEs were used to calculate transaction summaries and tenure separately, keeping the logic organized.

**Challenges & Resolution:**  
Short account tenures could lead to division errors. This was handled by applying a minimum threshold of 1 month using `GREATEST(1, tenure)`. Modular CTE design helped clearly separate calculations, improve readability, and maintain performance.

---

## Author

**Odigie Oduware Collins**  
Data Analyst    

---
