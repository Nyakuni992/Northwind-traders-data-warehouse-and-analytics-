-- Categories with the highest  amount of sales
WITH CategorySales AS (
SELECT
CategoryID,
CategoryName,
SUM(Sales) AS CategorySales
FROM gold.fact_orders o
LEFT JOIN gold.dim_products p
ON o.ProductKey = p.ProductKey
GROUP BY
CategoryID,
CategoryName
)
SELECT
CategoryName,
CategorySales,
SUM(CategorySales) OVER () AS TotalSales,
CONCAT(ROUND((CategorySales / SUM(CategorySales) OVER ()) * 100, 2), '%') AS SalesPercentage
FROM CategorySales
ORDER BY CategorySales DESC

-- Customers with the highest number of orders
WITH CustomerOrders AS (
SELECT
CustomerID,
CompanyName,
Country,
COUNT(DISTINCT OrderID) AS TotalOrders
FROM gold.fact_orders o
LEFT JOIN gold.dim_customers c
ON o.CustomerKey = c.CustomerKey
GROUP BY
CustomerID,
CompanyName,
Country
)
SELECT
CustomerID,
CompanyName,
Country,
TotalOrders,
SUM(TotalOrders) OVER () AS OverallOrders,
CONCAT(ROUND((CAST(TotalOrders AS FLOAT) / SUM(TotalOrders) OVER ()) * 100, 2), '%') AS OrderPercentage
FROM CustomerOrders
ORDER BY TotalOrders DESC

-- The contribution of each shipper to total freight costs
WITH ShipperDetails AS (
SELECT
OrderID,
s.ShipperID,
s.ShipperName,
MAX(FreightCost) AS OrderFreightCost
FROM gold.fact_orders o
LEFT JOIN gold.dim_shippers s
ON o.ShipperKey = s.ShipperKey
GROUP BY
OrderID,
s.ShipperID,
s.ShipperName
)
SELECT
ShipperID,
ShipperName,
SUM(OrderFreightCost) AS TotalFreightCost,
SUM(SUM(OrderFreightCost)) OVER () AS OverallFreightCost,
CONCAT(ROUND((SUM(OrderFreightCost) / SUM(SUM(OrderFreightCost)) OVER ()) * 100, 2), '%') AS FreightPercentage
FROM ShipperDetails
GROUP BY
ShipperID,
ShipperName
ORDER BY SUM(OrderFreightCost) DESC

-- Total freight costs distribution by country
WITH ShipperDetails AS (
SELECT
OrderID,
c.Country,
MAX(FreightCost) AS OrderFreightCost
FROM gold.fact_orders o
LEFT JOIN gold.dim_customers c
ON o.CustomerKey = c.CustomerKey
GROUP BY
OrderID,
c.Country
)
SELECT
Country,
SUM(OrderFreightCost) AS TotalFreightCost,
SUM(SUM(OrderFreightCost)) OVER () AS OverallFreightCost,
CONCAT(ROUND((SUM(OrderFreightCost) / SUM(SUM(OrderFreightCost)) OVER ()) * 100, 2), '%') AS FreightPercentage
FROM ShipperDetails
GROUP BY
Country
ORDER BY SUM(OrderFreightCost) DESC
