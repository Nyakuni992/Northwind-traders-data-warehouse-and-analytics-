/*
=======================================================================
Report Customers
=======================================================================
This report is a business-ready analytical view that consolidates customer and sales data into a single dataset for 
reporting and analysis. It provides key customer metrics such as total orders, total sales, average order value, 
recency in orders and customer location, enabling stakeholders to evaluate customer performance and purchasing behavior.

This report supports customer segmentation, revenue analysis, and the identification of high-value customers, 
providing reliable insights for sales and business decision-making.
=======================================================================
*/
CREATE VIEW gold.report_customers AS
WITH Base_Query AS (
-- Base Query: Retrieves core columns from the tables
SELECT
OrderID,
ProductKey,
OrderDate,
RequiredDate,
ShippedDate,
Quantity,
SellingPrice,
c.CustomerKey,
CustomerID,
CompanyName,
PrimaryContactName,
Country
FROM gold.fact_orders o
LEFT JOIN gold.dim_customers c
ON o.CustomerKey = c.CustomerKey
)
-- Customer query
, Customer_Details AS (
SELECT
CustomerKey,
CustomerID,
CompanyName,
Country,
COUNT(DISTINCT OrderID) AS TotalOrders,
SUM(Quantity) AS TotalQuantity,
SUM(Quantity * SellingPrice) AS TotalSales,
COUNT(ProductKey) AS TotalProducts,
MAX(OrderDate) AS LastOrder,
DATEDIFF(MONTH, MIN(OrderDate), MAX(OrderDate)) AS LifeSpan
FROM Base_Query
GROUP BY
CustomerKey,
CustomerID,
CompanyName,
Country
)
-- Final query
SELECT
CustomerKey,
CustomerID,
CompanyName,
Country,
-- Spending Categories
CASE WHEN LifeSpan >= 12 AND TotalSales > 20000 THEN 'High Spender'
     WHEN LifeSpan >= 12 AND TotalSales  BETWEEN 5000 AND 20000 THEN 'Moderate Spender'
     WHEN LifeSpan >= 12 AND TotalSales <= 5000 THEN 'Low Spender'
     ELSE 'New Spender '
     END AS CustomerCategory,
LastOrder,
TotalOrders,
TotalQuantity,
TotalSales,
LifeSpan,
-- Recency in months
DATEDIFF(MONTH, LastOrder, GETDATE()) AS Recency,
-- Average order value
CASE WHEN TotalOrders = 0 THEN 0 
     ELSE ROUND((TotalSales / TotalOrders), 2) 
     END AS AverageOrderValue,
-- Average monthly spending
CASE WHEN LifeSpan = 0 THEN TotalSales 
     ELSE ROUND((TotalSales / Lifespan), 2) 
     END AS AverageMonthlySpending
FROM Customer_Details
