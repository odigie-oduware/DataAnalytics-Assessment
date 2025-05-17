-- Question 2: Transaction Frequency Analysis
-- Task: Calculate the average number of transactions per customer per month
--       and group customers into frequency categories: High (≥10), Medium (3–9), Low (≤2).
-- Tables: users_customuser, savings_savingsaccount

-- Step 1: Get total transactions and estimated active months per customer
WITH customer_activity AS (
    SELECT 
        sa.owner_id,
        COUNT(*) AS total_transactions,
        GREATEST(1, DATEDIFF(MAX(sa.transaction_date), MIN(sa.transaction_date)) / 30) AS months_active
    FROM savings_savingsaccount sa
    GROUP BY sa.owner_id
),

-- Step 2: Calculate average transactions per month for each customer
customer_frequency AS (
    SELECT 
        ca.owner_id,
        ROUND(ca.total_transactions / ca.months_active, 2) AS transactions_per_month
    FROM customer_activity ca
),

-- Step 3: Assign frequency category based on transaction volume
categorized_customers AS (
    SELECT 
        CASE 
            WHEN transactions_per_month >= 10 THEN 'High Frequency'
            WHEN transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        transactions_per_month
    FROM customer_frequency
)

-- Step 4: Aggregate and display customer counts and average transaction rates per category
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(transactions_per_month), 2) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
