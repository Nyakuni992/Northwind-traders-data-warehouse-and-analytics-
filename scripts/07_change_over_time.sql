-- Total sales (Month Over Month)
SELECT
DATETRUNC(MONTH, OrderDate) AS OrderMonth,
ROUND(SUM(Sales), 2) AS TotalSales
FROM gold.fact_orders
GROUP BY
DATETRUNC(MONTH, OrderDate)
ORDER BY DATETRUNC(MONTH, OrderDate) 

-- Total customers who placed an Order (Month Over Month)
SELECT
DATETRUNC(MONTH, OrderDate) AS OrderMonth,
COUNT(DISTINCT CustomerKey) TotalCustomers
FROM gold.fact_orders 
GROUP BY
DATETRUNC(MONTH, OrderDate)
ORDER BY DATETRUNC(MONTH, OrderDate) 

-- Total Orders (YOY)
SELECT
YEAR(OrderDate) AS OrderYear,
COUNT(DISTINCT OrderID) TotalOrders
FROM gold.fact_orders 
GROUP BY
YEAR(OrderDate)
ORDER BY YEAR(OrderDate) 

-- Total number of products sold (YOY).
SELECT
YEAR(OrderDate) AS OrderYear,
COUNT(DISTINCT ProductKey) TotalProducts
FROM gold.fact_orders 
GROUP BY
YEAR(OrderDate)
ORDER BY YEAR(OrderDate) 

-- Total quantity of each product category that was sold over time (YOY)
SELECT
YEAR(OrderDate) AS OrderYear,
CategoryName,
SUM(Quantity) AS TotalProducts
FROM gold.fact_orders o
LEFT JOIN gold.dim_products p
ON o.ProductKey = p.ProductKey
GROUP BY
YEAR(OrderDate),
CategoryName
ORDER BY 1,2
