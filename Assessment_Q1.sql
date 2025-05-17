-- Question 1: High-Value Customers with Multiple Products
-- Task: Find customers with at least one funded savings plan AND one funded investment plan,
--       and return their savings count, investment count, and total deposits in descending order.
-- Tables: users_customuser, savings_savingsaccount, plans_plan

-- Step 1: Get customers with at least one savings plan (is_a_fund = 0)
WITH savings_users AS (
    SELECT owner_id, COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_a_fund = 0
    GROUP BY owner_id
),
-- Step 2: Get customers with at least one investment plan (is_a_fund = 1)
investment_users AS (
    SELECT owner_id, COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1
    GROUP BY owner_id
),
-- Step 3: Calculate total confirmed deposits per customer 
user_deposits AS (
    SELECT owner_id, SUM(confirmed_amount) / 100 AS total_deposits
    FROM savings_savingsaccount
    GROUP BY owner_id
)

-- Step 4: Join all aggregated data and return final result
SELECT 
    u.id AS owner_id,
    u.name,
    su.savings_count,
    iu.investment_count,
    ROUND(ud.total_deposits, 2) AS total_deposits
FROM users_customuser u
JOIN savings_users su ON u.id = su.owner_id
JOIN investment_users iu ON u.id = iu.owner_id
JOIN user_deposits ud ON u.id = ud.owner_id
ORDER BY total_deposits DESC;

