-- Total sales per month and the running total sales over time.
WITH SalesDetails AS (
SELECT
DATETRUNC(MONTH,OrderDate) AS OrderDate,
ROUND(SUM(Sales), 2) AS TotalSales
FROM gold.fact_orders
GROUP BY DATETRUNC(MONTH,OrderDate)

)
SELECT
OrderDate,
TotalSales,
SUM(TotalSales) OVER (ORDER BY TotalSales) AS RunningTotalSales
FROM SalesDetails

-- Total Orders and the running total orders 
WITH OrderDetails AS (
SELECT
DATEPART(YEAR,OrderDate) AS OrderYear,
COUNT(DISTINCT OrderID) AS TotalOrders
FROM gold.fact_orders
GROUP BY 
DATEPART(YEAR,OrderDate)
)
SELECT
OrderYear,
TotalOrders,
SUM(TotalOrders) OVER (ORDER BY OrderYear ASC) RunningTotalOrders
FROM OrderDetails

-- Moving Average Price over time
WITH AvgPriceDetails AS (
SELECT
DATETRUNC(MONTH,OrderDate) AS OrderMonth,
ROUND(AVG(SellingPrice),2) AS AvgPrice
FROM gold.fact_orders
GROUP BY DATETRUNC(MONTH,OrderDate) 

)
SELECT
OrderMonth,
AvgPrice,
ROUND(AVG(AvgPrice) OVER ( ORDER BY OrderMonth),2) AS MovingAvgPrice
FROM AvgPriceDetails
