/*
===============================================================
Report Employees
=================================================================
his report consolidates employee and sales data into a single dataset for reporting and performance analysis. 
It consits of key employee metrics such as total sales per employee, total orders processed, 
average order revenue, and Unique customer count managed by each employee, enabling stakeholders to evaluate individual and team performance.

This report supports sales performance analysis, employee benchmarking, workload distribution, and the identification of 
top-performing sales representatives, helping managers make informed decisions on coaching, resource allocation, and performance improvement.
==================================================================
*/
CREATE VIEW gold.report_employees AS
WITH Base_Query AS (
-- Base Query: 
SELECT
o.OrderID,
o.OrderDate,
o.CustomerKey,
o.ProductKey,
o.Quantity,
o.SellingPrice,
e.EmployeeKey,
e.EmployeeID,
e.EmployeeName,
e.JobTitle,
e.ManagerID,
e.Country
FROM gold.fact_orders o
LEFT JOIN gold.dim_employees e
ON e.EmployeeKey = o.EmployeeKey
WHERE e.EmployeeKey IS NOT NULL
)
, Employee_Details AS (
SELECT
EmployeeKey,
EmployeeID,
EmployeeName,
JobTitle,
ManagerID,
Country,
COUNT(DISTINCT OrderID) AS TotalOrders,
SUM(Quantity) AS TotalQuantitySold,
ROUND(SUM(Quantity * SellingPrice), 2) AS TotalSales,
COUNT(DISTINCT CustomerKey) AS UniqueCustomers,
DATEDIFF(MONTH, MIN(OrderDate), MAX(OrderDate)) AS LifeSpan,
MAX(OrderDate) AS LastOrderDate
FROM Base_Query
GROUP BY
EmployeeKey,
EmployeeID,
EmployeeName,
JobTitle,
ManagerID,
Country
)
SELECT
EmployeeKey,
EmployeeID,
EmployeeName,
JobTitle,
ManagerID,
Country,
CASE WHEN TotalSales >= 150000 THEN 'Top Performer'
     WHEN TotalSales BETWEEN 100000 AND 150000 THEN 'Mid Range'
     ELSE 'Low Performer'
     END AS EmployeeCategory,
TotalOrders,
TotalQuantitySold,
TotalSales,
UniqueCustomers,
LifeSpan,
LastOrderDate,
-- recency (months since last sale)
DATEDIFF(MONTH, LastOrderDate, GETDATE()) AS Recency,
-- average order revenue (AOR)
ROUND(TotalSales / NULLIF(TotalOrders, 0),2) AS AverageOrderRevenue,
-- average units per order
ROUND(CAST(TotalQuantitySold AS FLOAT) / NULLIF(TotalOrders, 0), 2) AS AverageUnitsPerOrder,
-- average monthly revenue
ROUND(TotalSales / NULLIF(LifeSpan, 0), 2) AS AverageMonthlyRevenue,
-- Sales Contribution %
ROUND((TotalSales / SUM(TotalSales) OVER ()) * 100, 2) AS SalesContributionPct
FROM Employee_Details
