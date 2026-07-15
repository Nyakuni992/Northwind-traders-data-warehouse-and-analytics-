--The total sales
SELECT
ROUND(SUM(Sales), 2) AS TotalSales
FROM gold.fact_orders

--Total items sold
SELECT
SUM(Quantity) AS TotalitemsSold
FROM gold.fact_orders

-- The average current price
SELECT 
ROUND(AVG(UnitPrice), 2) AvgCurrentPrice
FROM gold.dim_products

--The average selling price
SELECT
ROUND(AVG(SellingPrice), 2) AS AvgSellingPrice
FROM gold.fact_orders

--Total number of orders
SELECT 
COUNT(DISTINCT OrderID) AS TotalNrOrders
FROM gold.fact_orders

--Total number of products 
SELECT
COUNT(ProductKey) AS TotalProducts
FROM gold.dim_products

--Total number of customers
SELECT
COUNT(*) AS TotalCustomers
FROM gold.dim_customers

--Customers who placed orders
SELECT 
COUNT(DISTINCT CustomerKey) AS CustomersWithOrders
FROM gold.fact_orders

-----------------------
-- General Report

SELECT
    'TotalSales' AS MeasureName, ROUND(SUM(Sales), 2) AS MeasureValue
FROM gold.fact_orders
UNION ALL
SELECT
    'TotalItemsSold' AS MeasureName, SUM(Quantity) AS MeasureValue
FROM gold.fact_orders
UNION ALL
SELECT 
    'AvgCurrentPrice' AS MeasureName, ROUND(AVG(UnitPrice ), 2) AS MeasureValue
FROM gold.dim_products
UNION ALL
SELECT 
    'AvgSellingPrice' AS MeasureName, ROUND(AVG(SellingPrice), 2) AS MeasureValue
FROM gold.fact_orders
UNION ALL
SELECT 
    'TotalNrOrders' AS MeasureName, COUNT(DISTINCT OrderID) AS MeasureValue
FROM gold.fact_orders
UNION ALL 
SELECT
    'TotalProducts' AS MeasureName, COUNT(ProductKey) AS MeasureValue
FROM gold.dim_products
UNION ALL
SELECT
    'TotalCustomers' AS MeasureName, COUNT(*) AS MeasureValue
FROM gold.dim_customers
UNION ALL
SELECT 
'CustomersWithOrders' AS MeasureName, COUNT(DISTINCT CustomerKey) AS MeasureValue
FROM gold.fact_orders
