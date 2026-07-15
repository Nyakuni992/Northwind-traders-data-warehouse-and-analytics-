/*
======================================================================
Report Products
======================================================================
This report provides key product performance metrics such as total sales, units sold, average selling price, 
average order revenue and order frequency, enabling stakeholders to evaluate product performance across the business.

This report supports product performance analysis, category comparisons, inventory planning, and the identification of 
top- and low-performing products, providing actionable insights to drive data-informed business decisions.
======================================================================
*/
CREATE VIEW gold.report_products AS 
WITH Base_Query AS (
-- Base Query: Retrieves core columns from the tables
SELECT
o.OrderID,
o.OrderDate,
o.CustomerKey,
o.Quantity,
o.SellingPrice,
p.ProductKey,
p.ProductID,
p.ProductName,
p.CategoryID,
p.CategoryName,
p.PackageCount,
p.Packaging,
p.UnitPrice AS CurrentPrice,
p.Discontinued 
FROM gold.fact_orders o
LEFT JOIN gold.dim_products p
ON o.ProductKey = p.ProductKey
WHERE p.ProductKey IS NOT NULL
)
-- Product_Details: Consolidates 
, Product_Details AS (
SELECT
ProductKey,
ProductID,
ProductName,
CategoryName,
PackageCount,
Packaging,
Discontinued,
COUNT(DISTINCT OrderID)  AS TotalOrders,
SUM(Quantity) AS TotalQuantitySold,
CurrentPrice,
ROUND(SUM(Quantity * SellingPrice) / SUM(Quantity), 2) AS AvgSellingPrice,
SUM(Quantity * SellingPrice) AS TotalSales,
COUNT(DISTINCT CustomerKey) AS UniqueCustomers,
MAX(OrderDate) AS LastOrderDate,
DATEDIFF(MONTH, MIN(OrderDate), MAX(OrderDate)) AS LifeSpan
FROM Base_Query
GROUP BY
ProductKey,
ProductID,
ProductName,
CategoryName,
PackageCount,
Packaging,
Discontinued,
CurrentPrice
)
-- Final Query
SELECT
ProductKey,
ProductID,
ProductName,
CategoryName,
PackageCount,
Packaging,
CASE WHEN Discontinued = 1 THEN 'Discontinued'
     ELSE 'Active'
     END AS ProductStatus,
TotalOrders,
TotalQuantitySold,
CurrentPrice,
AvgSellingPrice,
TotalSales,
UniqueCustomers,
CASE WHEN TotalSales > 5000 THEN 'Top Seller'
     WHEN TotalSales BETWEEN 3000 AND 5000 THEN 'Mid Range'
     ELSE 'Low Seller'
     END AS ProductSegment,
LastOrderDate,
LifeSpan,
DATEDIFF(MONTH, LastOrderDate, GETDATE()) AS Recency,
-- Average Order Revenue
ROUND(TotalSales / NULLIF(TotalOrders, 0), 2) AS AverageOrderRevenue,
-- Average Units Per Order
ROUND(CAST(TotalQuantitySold AS FLOAT)/ NULLIF(TotalOrders,0),2) AS AverageUnitsPerOrder,
-- Average Monthly Revenue
ROUND(TotalSales / NULLIF(LifeSpan, 0),2) AS AverageMonthlyRevenue,
-- Average Price Percentage Realized
CONCAT(ROUND(AvgSellingPrice /NULLIF(CurrentPrice,0) * 100,2), '%') AS AvgPricePercentageRealized
FROM Product_Details
