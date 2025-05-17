-- Question 4: Customer Lifetime Value (CLV) Estimation
-- Task: Calculate account tenure, total transactions, and estimated CLV for each customer.
--       The CLV is based on a 0.1% profit per transaction and is ordered from highest to lowest.
-- Tables: users_customuser, savings_savingsaccount

-- Step 1: Aggregate total transactions and total amount per customer
WITH transaction_summary AS (
    SELECT 
        sa.owner_id,
        COUNT(*) AS total_transactions,
        SUM(sa.confirmed_amount) / 100 AS total_amount_naira
    FROM savings_savingsaccount sa
    GROUP BY sa.owner_id
),

-- Step 2: Get customer tenure in months
user_tenure AS (
    SELECT 
        u.id AS customer_id,
        u.name,
        GREATEST(1, TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) AS tenure_months
    FROM users_customuser u
)

-- Step 3: Compute estimated CLV using the simplified model and sort by highest value
SELECT 
    ut.customer_id,
    ut.name,
    ut.tenure_months,
    ts.total_transactions,
    ROUND(
        (ts.total_transactions / ut.tenure_months) * 12 * 
        (0.001 * (ts.total_amount_naira / ts.total_transactions)), 2
    ) AS estimated_clv

FROM user_tenure ut
JOIN transaction_summary ts ON ut.customer_id = ts.owner_id
ORDER BY estimated_clv DESC;
