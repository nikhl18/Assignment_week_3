USE superstoredb;

-- =========================================
-- 1. Above Average Sales Orders (Subquery)
-- =========================================

SELECT *
FROM orders
WHERE Sales >
(
    SELECT AVG(Sales)
    FROM orders
);

-- =========================================
-- 2. Highest Order Per Customer
-- =========================================

SELECT o.*
FROM orders o
JOIN
(
    SELECT
        `Customer ID`,
        MAX(Sales) AS max_sales
    FROM orders
    GROUP BY `Customer ID`
) m
ON o.`Customer ID` = m.`Customer ID`
AND o.Sales = m.max_sales;

-- =========================================
-- 3. CTE - Total Sales Per Customer
-- =========================================

WITH customer_sales AS
(
    SELECT
        `Customer ID`,
        SUM(Sales) AS total_sales
    FROM orders
    GROUP BY `Customer ID`
)
SELECT *
FROM customer_sales;

-- =========================================
-- 4. ROW_NUMBER()
-- =========================================

SELECT
    `Customer ID`,
    Sales,
    ROW_NUMBER() OVER (ORDER BY Sales DESC) AS row_num
FROM orders;

-- =========================================
-- 5. RANK()
-- =========================================

SELECT
    `Customer ID`,
    Sales,
    RANK() OVER (ORDER BY Sales DESC) AS sales_rank
FROM orders;

-- =========================================
-- 6. DENSE_RANK()
-- =========================================

SELECT
    `Customer ID`,
    Sales,
    DENSE_RANK() OVER (ORDER BY Sales DESC) AS dense_rank_num
FROM orders;

-- =========================================
-- 7. Final Query
-- JOIN + CTE + Window Function
-- =========================================

WITH customer_sales AS
(
    SELECT
        `Customer ID`,
        SUM(Sales) AS total_sales
    FROM orders
    GROUP BY `Customer ID`
)
SELECT
    c.`Customer ID`,
    c.`Customer Name`,
    cs.total_sales,
    RANK() OVER (ORDER BY cs.total_sales DESC) AS customer_rank
FROM customers c
JOIN customer_sales cs
ON c.`Customer ID` = cs.`Customer ID`;

-- =========================================
-- 8. Top 10 Customers
-- =========================================

SELECT
    `Customer ID`,
    SUM(Sales) AS total_sales
FROM orders
GROUP BY `Customer ID`
ORDER BY total_sales DESC
LIMIT 10;

-- =========================================
-- 9. Lowest 10 Customers
-- =========================================

SELECT
    `Customer ID`,
    SUM(Sales) AS total_sales
FROM orders
GROUP BY `Customer ID`
ORDER BY total_sales ASC
LIMIT 10;

-- =========================================
-- 10. Single Order Customers
-- =========================================

SELECT
    `Customer ID`,
    COUNT(*) AS order_count
FROM orders
GROUP BY `Customer ID`
HAVING COUNT(*) = 1;