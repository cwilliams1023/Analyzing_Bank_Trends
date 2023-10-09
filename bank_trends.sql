--List all regions along with the number of users assigned to each region. (1)
SELECT wr.region_name, COUNT(DISTINCT(un.consumer_id)) AS num_user
FROM bank_trends.dbo.world_regions AS wr
LEFT JOIN bank_trends.dbo.user_nodes AS un 
ON wr.region_id = un.region_id
GROUP BY wr.region_name
ORDER BY num_user DESC;

--Find the user who made the largest deposit amount and the transaction type for that deposit. (2)
SELECT consumer_id, transaction_type
FROM bank_trends.dbo.user_transaction
WHERE transaction_amount = (SELECT MAX(transaction_amount) AS largest_deposit
                            FROM bank_trends.dbo.user_transaction
							WHERE transaction_type = 'deposit');

--Calculate the total amount deposited for each user in the "Europe" region.(3)
SELECT TOP 10 un.consumer_id, SUM(ut.transaction_amount) AS total_deposits
FROM bank_trends.dbo.user_transaction AS ut
INNER JOIN bank_trends.dbo.user_nodes AS un ON ut.consumer_id = un.consumer_id
INNER JOIN bank_trends.dbo.world_regions AS wr ON un.region_id = wr.region_id
WHERE wr.region_name = 'Europe' AND ut.transaction_type ='deposit'
GROUP BY un.consumer_id
ORDER BY total_deposits DESC;


--Calculate the total number of transactions made by each user in the "United States" region.(4)
SELECT un.consumer_id, COUNT(ut.transaction_type) AS total_transactions
FROM bank_trends.dbo.user_transaction AS ut
INNER JOIN bank_trends.dbo.user_nodes AS un ON ut.consumer_id = un.consumer_id
INNER JOIN bank_trends.dbo.world_regions AS wr ON un.region_id = wr.region_id
WHERE wr.region_name = 'United States' 
GROUP BY un.consumer_id
ORDER BY total_transactions DESC;

--Calculate the total number of users who made more than 5 transactions. (5)
SELECT COUNT(*) AS total_users
FROM (
      SELECT consumer_id, COUNT(*) AS num_transaction
	  FROM bank_trends.dbo.user_transaction
	  GROUP BY consumer_id
	  HAVING COUNT(*) > 5
) AS users_with_more_than_5_transactions;

--How many transactions were made by consumers from each region? (15)
SELECT wr.region_name, COUNT(ut.transaction_type) AS num_transactions
FROM bank_trends.dbo.user_transaction AS ut 
INNER JOIN bank_trends.dbo.user_nodes AS un ON ut.consumer_id = un.consumer_id
INNER JOIN bank_trends.dbo.world_regions AS wr ON un.region_id = wr.region_id
GROUP BY wr.region_name;

--What is the unique count and total amount for each transaction type (13)
SELECT transaction_type, COUNT(DISTINCT(transaction_type)) AS unique_count, SUM(transaction_amount) AS total_amount
FROM bank_trends.dbo.user_transaction
GROUP BY transaction_type

--Find the regions with the highest number of nodes assigned to them. (6)
SELECT wr.region_name, COUNT(un.node_id) AS num_nodes
FROM bank_trends.dbo.user_nodes AS un
INNER JOIN bank_trends.dbo.world_regions AS wr ON un.region_id = wr.region_id
GROUP BY wr.region_name
HAVING COUNT(un.node_id) = (SELECT TOP 1 COUNT(un2.node_id)
    FROM bank_trends.dbo.user_nodes AS un2
    GROUP BY un2.region_id
    ORDER BY COUNT(un2.node_id) DESC
);

--How many consumers are allocated to each region? (12)
SELECT wr.region_name, COUNT(un.consumer_id) AS num_consumers
FROM bank_trends.dbo.user_nodes AS un
INNER JOIN bank_trends.dbo.world_regions AS wr ON un.region_id = wr.region_id 
GROUP BY wr.region_name;

--Find the user who made the largest deposit amount in the "Australia" region. (7)
SELECT TOP 1 un.consumer_id, SUM(ut.transaction_amount) AS largest_deposit_amount
FROM bank_trends.dbo.user_transaction AS ut
INNER JOIN bank_trends.dbo.user_nodes AS un ON ut.consumer_id = un.consumer_id
INNER JOIN bank_trends.dbo.world_regions AS wr ON un.region_id = wr.region_id
WHERE ut.transaction_type = 'deposit' AND wr.region_name = 'Australia'
GROUP BY un.consumer_id
ORDER BY largest_deposit_amount DESC; 


--Calculate the total amount deposited by each user in each region (8)
SELECT un.consumer_id, wr.region_name, SUM(ut.transaction_amount) AS total_deposit_amount
FROM bank_trends.dbo.user_transaction AS ut
INNER JOIN bank_trends.dbo.user_nodes AS un ON ut.consumer_id = un.consumer_id
INNER JOIN bank_trends.dbo.world_regions AS wr ON un.region_id = wr.region_id
WHERE ut.transaction_type = 'deposit'
GROUP BY un.consumer_id, wr.region_name
ORDER BY un.consumer_id, wr.region_name;


--Retrieve the total number of transactions for each region (9)
SELECT wr.region_name, COUNT(ut.consumer_id) AS total_transactions
FROM bank_trends.dbo.user_transaction AS ut
INNER JOIN bank_trends.dbo.user_nodes AS un ON ut.consumer_id = un.consumer_id
INNER JOIN bank_trends.dbo.world_regions AS wr ON un.region_id = wr.region_id
GROUP BY wr.region_name
ORDER BY total_transactions DESC

-- What are the average deposit counts and amounts for each transaction type ('deposit') across all customers, grouped by transaction type?(14)
SELECT ut.transaction_type, COUNT(ut.consumer_id) AS deposit_count, AVG(ut.transaction_amount) AS average_deposit_amount
FROM bank_trends.dbo.user_transaction AS ut
WHERE ut.transaction_type = 'deposit'
GROUP BY ut.transaction_type

--Write a query to find the total deposit amount for each region (region_name) in the user_transaction table.(10)
SELECT wr.region_name, SUM(ut.transaction_amount) AS total_deposit_amount
FROM bank_trends.dbo.user_transaction AS ut
INNER JOIN bank_trends.dbo.user_nodes AS un ON ut.consumer_id = un.consumer_id
INNER JOIN bank_trends.dbo.world_regions AS wr ON un.region_id = wr.region_id
WHERE ut.transaction_type = 'deposit'
GROUP BY wr.region_name
ORDER BY total_deposit_amount DESC

--Write a query to find the top 5 consumers who have made the highest total transaction amount (sum of all their deposit transactions) in the user_transaction table.
SELECT TOP 5 un.consumer_id, SUM(ut.transaction_amount) AS total_deposit_amount
FROM bank_trends.dbo.user_transaction AS ut
INNER JOIN bank_trends.dbo.user_nodes AS un ON ut.consumer_id = un.consumer_id
WHERE ut.transaction_type = 'deposit'
GROUP BY un.consumer_id
ORDER BY total_deposit_amount DESC

--what month had the highest transaction amount for deposits?
SELECT DATEPART(MONTH, ut.transaction_date) AS transaction_month,
       SUM(ut.transaction_amount) AS total_deposit_amount
FROM bank_trends.dbo.user_transaction AS ut
WHERE ut.transaction_type = 'deposit'
GROUP BY DATEPART(MONTH, ut.transaction_date)
ORDER BY total_deposit_amount DESC;


