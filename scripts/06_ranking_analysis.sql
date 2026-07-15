--Top 5 products with the highest revenue
WITH ProductDetails AS (
SELECT
o.ProductKey,
p.ProductName,
SUM(Sales) AS TotalRevenue,
RANK() OVER (ORDER BY SUM(Sales) DESC) AS ProductRank
FROM gold.fact_orders o
LEFT JOIN gold.dim_products p
ON o.ProductKey = p.ProductKey
GROUP BY
o.ProductKey,
p.ProductName
)
SELECT
ProductKey,
ProductName,
TotalRevenue,
ProductRank
FROM ProductDetails
WHERE ProductRank <= 5

-- 5 worst performing products in terms of  total revenue
SELECT TOP 5
o.ProductKey,
p.ProductName,
ROUND(SUM(Sales), 2) AS TotalRevenue
FROM gold.fact_orders o
LEFT JOIN gold.dim_products p
ON o.ProductKey = p.ProductKey
GROUP BY
o.ProductKey,
p.ProductName
ORDER BY TotalRevenue ASC

-- Top 10 customers with the highest revenue
SELECT TOP 10
c.CustomerKey,
c.CompanyName,
ROUND(SUM(Sales), 2) AS TotalRevenue
FROM gold.fact_orders o
LEFT JOIN gold.dim_customers c
ON o.CustomerKey = c.CustomerKey
GROUP BY
c.CustomerKey,
c.CompanyName
ORDER BY TotalRevenue DESC

--  Top 10 countries with the highest revenue
SELECT TOP 10
c.Country,
ROUND(SUM(Sales), 2) AS TotalRevenue
FROM gold.fact_orders o
LEFT JOIN gold.dim_customers c
ON o.CustomerKey = c.CustomerKey
GROUP BY
c.Country
ORDER BY TotalRevenue DESC

-- Top 5 categories with the highest number of items sold
SELECT TOP 5
p.CategoryName,
SUM(Quantity) AS TotalItemsSold
FROM gold.fact_orders o
LEFT JOIN gold.dim_products p
ON o.ProductKey = p.ProductKey
GROUP BY
p.CategoryName
ORDER BY TotalItemsSold DESC
--  Top 5 employees who handled the most orders
SELECT TOP 5    
o.EmployeeKey,
e.EmployeeName,
e.JobTitle,
COUNT(DISTINCT o.OrderID) AS TotalOrders
FROM gold.fact_orders o
LEFT JOIN gold.dim_employees e
ON o.EmployeeKey = e.EmployeeKey
GROUP BY 
o.EmployeeKey,
e.EmployeeName,
e.JobTitle
ORDER BY TotalOrders DESC
