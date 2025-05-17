-- Question 3: Account Inactivity Alert
-- Task: Find all active savings or investment plans with no inflow transactions in the last 1 year (365 days).
-- Tables: plans_plan, savings_savingsaccount

-- Step 1: Join all plans with their related transaction records (if any)
SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Savings'
    END AS type,
    MAX(sa.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(sa.transaction_date)) AS inactivity_days
FROM plans_plan p
LEFT JOIN savings_savingsaccount sa 
    ON p.id = sa.plan_id

-- Step 2: Group by plan to compute last transaction and inactivity duration
GROUP BY p.id, p.owner_id, p.is_a_fund

-- Step 3: Filter for plans with no transactions in the last 365 days (or no transactions at all)
HAVING 
    last_transaction_date IS NULL 
    OR DATEDIFF(CURDATE(), last_transaction_date) > 365

-- Step 4: Sort by inactivity duration in descending order
ORDER BY inactivity_days DESC;
