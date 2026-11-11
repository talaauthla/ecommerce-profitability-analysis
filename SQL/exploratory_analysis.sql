-- Exploratory Data Analysis
SELECT *
FROM orders_final
limit 30;

-- Section 1: Overall business performance
-- Q1 How much revenue did the company generate from all its sales?
SELECT ROUND(SUM(sales),2) AS total_revenue
FROM orders_final;

-- Q2 How much profit did the business actually make?
SELECT ROUND(SUM(profit),2) AS total_profit
FROM orders_final;

-- Q3 what is the profit margin?
SELECT
    ROUND(SUM(Sales), 2) AS revenue,
    ROUND(SUM(Profit), 2) AS profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin
FROM orders_final;

-- Q4 How many orders did customers place during the period?
SELECT COUNT(DISTINCT `Order id`) AS total_orders
FROM orders_final;

-- Q5 On average, how much revenue does the business generate from one order?
SELECT
    ROUND(SUM(Sales) / COUNT(DISTINCT `Order ID`), 2) AS average_order_value
FROM orders_final;

-- Section 2 — Time Analysis
--  Q1 How much revenue did the business generate in each year, and how did its revenue change over time?
SELECT YEAR(`order date`) AS year, ROUND(SUM(sales),2) AS revenue
FROM orders_final
GROUP BY 1
ORDER BY 1;

-- Q2 How much profit did the business generate in each year, and did profit follow the same trend as revenue?
SELECT YEAR(`order date`) AS year, ROUND(SUM(profit),2) AS profit
FROM orders_final
GROUP BY 1
ORDER BY 1;

-- Q3 How did the company's profit margin change from 2014 to 2017?
SELECT
    YEAR(`Order Date`) AS year, ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin
FROM orders_final
GROUP BY 1
ORDER BY 1;

-- Which month generated the highest revenue in each year?
WITH CTE AS (
    SELECT YEAR(`Order Date`) AS years, MONTH(`Order Date`) AS months, ROUND(SUM(Sales), 2) AS revenue,
        RANK() OVER (
            PARTITION BY YEAR(`Order Date`)
            ORDER BY SUM(Sales) DESC
        ) AS ranking
    FROM orders_final
    GROUP BY 1, 2
)
SELECT *
FROM CTE
WHERE ranking = 1
ORDER BY years;

-- Section 3: Product & Category Analysis

-- Q1 Which product category generates the highest total revenue?
SELECT Category, ROUND(SUM(Sales), 2) AS revenue
FROM orders_final
GROUP BY 1
ORDER BY 2 DESC;

-- Which product category generates the highest total profit?
SELECT Category, ROUND(SUM(profit), 2) AS profit
FROM orders_final
GROUP BY 1
ORDER BY 2 DESC;


-- What percentage of revenue does each category retain as profit?
SELECT category,SUM(sales) AS revenue,SUM(profit) AS profit, ROUND(SUM(profit) / SUM(sales) * 100,2) AS profit_margin
FROM orders_final
GROUP BY 1
order by 4 desc;

-- Which sub-categories generate the highest and lowest total profit?
SELECT `sub-category`, ROUND(SUM(profit), 2) AS profit
FROM orders_final
GROUP BY 1
ORDER BY 2 DESC;

-- Which sub-categories generate the highest revenue, and do they also generate the highest profit?
SELECT `sub-category`,SUM(sales) AS revenue,SUM(profit) AS profit, ROUND(SUM(profit) / SUM(sales) * 100,2) AS profit_margin
FROM orders_final
GROUP BY 1
order by 2 desc;

-- Which individual products generate the  lowest profit?
SELECT `Product Name`, Category, `Sub-Category`, ROUND(SUM(Sales), 2) AS revenue, ROUND(SUM(Profit), 2) AS profit
FROM orders_final
GROUP BY 1, 2, 3
ORDER BY 5 ASC;

-- Which individual products generate the highest profit?
SELECT `Product Name`, Category, `Sub-Category`, ROUND(SUM(Sales), 2) AS revenue, ROUND(SUM(Profit), 2) AS profit
FROM orders_final
GROUP BY 1, 2, 3
ORDER BY 5 DESC;

-- Section 4: Regional Analysis
-- Q1 Which region generates the highest total revenue?
SELECT region, ROUND(SUM(sales),2) AS revenue
FROM orders_final
GROUP BY 1
order by 2 DESC;

-- Q2 Which region generates the highest total profit?
SELECT region, ROUND(SUM(profit),2) AS profit
FROM orders_final
GROUP BY 1
order by 2 DESC;

-- Q3 Which region keeps the highest percentage of its revenue as profit?
SELECT region,SUM(sales) AS revenue,SUM(profit) AS profit, ROUND(SUM(profit) / SUM(sales) * 100,2) AS profit_margin
FROM orders_final
GROUP BY 1
order by 4 DESC;

-- Q4 Which 10 states generate the highest total profit, and which 10 states generate the lowest total profit?
SELECT state, ROUND(SUM(profit),2) AS profit
FROM orders_final
GROUP BY 1
order by 2 DESC;

-- Q5 Which product categories are responsible for the losses in the five worst-performing states?
SELECT
    State,
    Category,
    ROUND(SUM(Sales), 2) AS revenue,
    ROUND(SUM(Profit), 2) AS profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin
FROM orders_final
WHERE State IN (
    'Texas',
    'Ohio',
    'Pennsylvania',
    'Illinois',
    'North Carolina'
)
GROUP BY 1, 2
ORDER BY 4 ASC;

-- Q6 Which specific sub-categories are responsible for the losses in Texas, Ohio, Illinois, Pennsylvania, and North Carolina?
SELECT 
    State,
    `sub-Category`,
    ROUND(SUM(Sales), 2) AS revenue,
    ROUND(SUM(Profit), 2) AS profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin
FROM orders_final
WHERE State IN (
    'Texas',
    'Ohio',
    'Pennsylvania',
    'Illinois',
    'North Carolina'
)
GROUP BY 1, 2
ORDER BY 4 ASC;

-- Section 5: Discount Analysis
-- Q1 What discount levels does the company offer, and how frequently is each discount used?
SELECT discount, COUNT(*)
FROM orders_final
GROUP BY 1
ORDER BY 1;

-- Q2 How does profit change across different discount levels?
SELECT discount, COUNT(*)AS record, ROUND(SUM(Sales), 2) AS revenue, ROUND(SUM(Profit), 2) AS profit, ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin
FROM orders_final
GROUP BY 1
ORDER BY 4 ;

-- Q3 Which product categories are most affected by high discounts, and does the relationship between discounts and profitability differ across categories?
SELECT discount, category,COUNT(*)AS record, ROUND(SUM(Sales), 2) AS revenue, ROUND(SUM(Profit), 2) AS profit, ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin
FROM orders_final
GROUP BY 1,2
ORDER BY 2,1 ;

-- Q4 Which sub-categories are most affected by high discounts, and which ones remain profitable despite receiving discounts?
SELECT discount, `sub-category`,COUNT(*)AS record, ROUND(SUM(Sales), 2) AS revenue, ROUND(SUM(Profit), 2) AS profit, ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin
FROM orders_final
GROUP BY 1,2
ORDER BY 2,1 ;

-- Section 6: Customer Analysis
-- Q1 Which customer segments generate the highest revenue and profit?
SELECT segment, COUNT(*) AS records, ROUND(SUM(Sales), 2) AS revenue, ROUND(SUM(Profit), 2) AS profit, ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin
FROM orders_final
GROUP BY 1;

-- Q2 Who are the company's highest-value customers?
SELECT `customer id`, `customer name` , COUNT(DISTINCT `Order ID`), ROUND(SUM(Sales), 2) AS revenue, ROUND(SUM(Profit), 2) AS profit
FROM orders_final
GROUP BY 1,2
ORDER BY 4 DESC
LIMIT 10;

-- Q3 Who are the most profitable customers?
SELECT `customer id`, `customer name` , COUNT(DISTINCT `Order ID`), ROUND(SUM(Sales), 2) AS revenue, ROUND(SUM(Profit), 2) AS profit
FROM orders_final
GROUP BY 1,2
ORDER BY 5 DESC
LIMIT 10;

-- Q4 Which customers generate losses?
SELECT `customer id`, `customer name` , COUNT(DISTINCT `Order ID`), ROUND(SUM(Sales), 2) AS revenue, ROUND(SUM(Profit), 2) AS profit
FROM orders_final
GROUP BY 1,2
ORDER BY 5
LIMIT 10;

-- Q5 How many orders does each customer place, and what does the distribution of purchase frequency look like?
SELECT
    orders_per_customer,
    COUNT(*) AS number_of_customers
FROM (
    SELECT
        `Customer ID`,
        COUNT(DISTINCT `Order ID`) AS orders_per_customer
    FROM orders_final
    GROUP BY `Customer ID`
) AS customer_orders
GROUP BY orders_per_customer
ORDER BY orders_per_customer;