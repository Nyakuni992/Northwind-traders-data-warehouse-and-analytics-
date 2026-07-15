/* Comparing the yearly sales performance of products by the average sales performance 
of the products and the previous year's sales*/
WITH ProductYearlySales AS (
SELECT 
YEAR(o.OrderDate) AS OrderYear,
p.ProductName,
ROUND(SUM(Sales),2) AS CurrentSales
FROM gold.fact_orders o
LEFT JOIN gold.dim_products p
ON o.ProductKey = p.ProductKey
GROUP BY YEAR(o.OrderDate),  p.ProductName

)
SELECT
OrderYear,
ProductName,
CurrentSales,
ROUND(AVG(CurrentSales) OVER (PARTITION BY ProductName ORDER BY OrderYear), 2) AS AvgSales,
CurrentSales - ROUND(AVG(CurrentSales) OVER (PARTITION BY ProductName ORDER BY OrderYear), 2) AS DiffInAvg,
CASE WHEN CurrentSales - ROUND(AVG(CurrentSales) OVER (PARTITION BY ProductName ORDER BY OrderYear), 2) < 0
     THEN 'Below Average'
     WHEN CurrentSales - AVG(CurrentSales) OVER (PARTITION BY ProductName ORDER BY OrderYear) > 0 
     THEN 'Above Average'
     ELSE 'No Change'
     END AS AvgChange,
-- Year Over Year Product Sales Analysis
LAG(CurrentSales) OVER ( PARTITION BY ProductName ORDER BY OrderYear) AS PySales,
CurrentSales - LAG(CurrentSales) OVER ( PARTITION BY ProductName ORDER BY OrderYear) AS DiffPy,
CASE WHEN CurrentSales - LAG(CurrentSales) OVER ( PARTITION BY ProductName ORDER BY OrderYear) < 0 
     THEN 'Decrease'
     WHEN CurrentSales - LAG(CurrentSales) OVER ( PARTITION BY ProductName ORDER BY OrderYear) > 0
     THEN 'Increase'
     ELSE 'No Change'
     END AS ChangeInSales
FROM ProductYearlySales
ORDER BY ProductName

/* Comparing the monthly quantity of products sold by their average quantity
of the products and the previous year's quantity sold*/
WITH ProductQuantity AS (
SELECT
DATETRUNC(MONTH,OrderDate) AS OrderMonth,
ProductName,
SUM(Quantity) AS CurrentQuantity
FROM gold.fact_orders o
LEFT JOIN gold.dim_products p
ON p.ProductKey = o.ProductKey
GROUP BY DATETRUNC(MONTH,OrderDate),ProductName
)
SELECT
OrderMonth,
ProductName,
CurrentQuantity,
AVG(CurrentQuantity) OVER (PARTITION BY ProductName) AS AvgQuantity,
CurrentQuantity - AVG(CurrentQuantity) OVER (PARTITION BY ProductName) AS DiffInAvg,
CASE WHEN CurrentQuantity - AVG(CurrentQuantity) OVER (PARTITION BY ProductName) > 0
     THEN 'Above Average'
     WHEN CurrentQuantity - AVG(CurrentQuantity) OVER (PARTITION BY ProductName) < 0
     THEN 'Below Average'
     ELSE 'No Change'
     END AS AvgChange,
     -- Month Over Month product quantity Analysis
LAG(CurrentQuantity) OVER (PARTITION BY ProductName ORDER BY OrderMonth) AS PyQuantity,
CurrentQuantity - LAG(CurrentQuantity) OVER (PARTITION BY ProductName ORDER BY OrderMonth) AS DiffInQuantity,
CASE WHEN CurrentQuantity - LAG(CurrentQuantity) OVER (PARTITION BY ProductName ORDER BY OrderMonth) > 0
     THEN 'Increase'
     WHEN CurrentQuantity - LAG(CurrentQuantity) OVER (PARTITION BY ProductName ORDER BY OrderMonth) < 0
     THEN 'Decrease'
     ELSE 'No Change'
     END AS QuantityChange
FROM ProductQuantity
ORDER BY ProductName, OrderMonth

/* Comparing the yearly total number of orders by the average orders
 and the previous year's number of orders */
WITH OrderNumber AS (
SELECT
YEAR(OrderDate) AS OrderYear,
COUNT(DISTINCT OrderID) AS CurrentOrders
FROM gold.fact_orders o
LEFT JOIN gold.dim_products p
ON p.ProductKey = o.ProductKey
GROUP BY YEAR(OrderDate)
)
SELECT
OrderYear,
CurrentOrders,
AVG(CurrentOrders) OVER () AS AvgOrders,
CurrentOrders - AVG(CurrentOrders) OVER () AS DiffInAvg,
CASE WHEN CurrentOrders - AVG(CurrentOrders) OVER () > 0
     THEN 'Above Average'
     WHEN CurrentOrders - AVG(CurrentOrders) OVER () < 0
     THEN 'Below Average'
     ELSE 'No Change'
     END AS AvgChange,
     -- Year Over Year product orders' Analysis
LAG(CurrentOrders) OVER (ORDER BY OrderYear) AS PyOrders,
CurrentOrders - LAG(CurrentOrders) OVER (ORDER BY OrderYear) AS DiffInOrders,
CASE WHEN CurrentOrders - LAG(CurrentOrders) OVER (ORDER BY OrderYear) > 0
     THEN 'Increase'
     WHEN CurrentOrders - LAG(CurrentOrders) OVER ( ORDER BY OrderYear) < 0
     THEN 'Decrease'
     ELSE 'No Change'
     END AS OrderChange
FROM OrderNumber
ORDER BY  OrderYear
