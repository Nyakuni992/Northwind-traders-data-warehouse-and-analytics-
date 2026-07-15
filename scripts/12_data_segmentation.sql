-- High, Medium, and Low Spending customers, total number of customers and the total sales of each segment
WITH CustomerSegments AS (
SELECT
    CustomerKey,
    CompanyName,
    TotalSales,
    CASE WHEN TotalSales > 20000 THEN 'High Value'
        WHEN TotalSales  BETWEEN 5000 AND 20000 THEN 'Medium Value'
        ELSE 'Low Value'
        END AS SalesRange
FROM(
    SELECT
        o.CustomerKey,
        c.CompanyName,
        ROUND(SUM(Sales), 2) AS TotalSales
    FROM gold.fact_orders o
    LEFT JOIN gold.dim_customers c
    ON o.CustomerKey = c.CustomerKey
    GROUP BY
        o.CustomerKey,
        c.CompanyName
    )t
)
SELECT
    SalesRange,
    COUNT(DISTINCT CustomerKey) AS TotalCustomers,
    SUM(TotalSales) AS OverallSales
FROM CustomerSegments
GROUP BY SalesRange
ORDER BY SUM(TotalSales) DESC

-- Segment categories by quantity of products sold and the discount rate given for each category
WITH CategoryDetails AS (
SELECT
p.CategoryName,
SUM(o.Quantity) AS TotalQuantitySold,
ROUND(SUM(Sales), 2) AS ActualSales,
ROUND(SUM(o.Quantity * p.UnitPrice), 2) AS GrossSales,
CASE WHEN SUM(o.Quantity) > 5000 THEN 'Top Seller'
     WHEN SUM(o.Quantity) BETWEEN 3000 AND 5000 THEN 'Medium Seller'
     ELSE 'Low Seller'
     END AS CategorySegment
FROM gold.fact_orders o
LEFT JOIN gold.dim_products p
ON o.ProductKey = p.ProductKey
GROUP BY CategoryName
)
SELECT
CategoryName,
TotalQuantitySold,
ActualSales,
ROUND((1 - ActualSales/NULLIF(GrossSales, 0)) * 100, 2) AS EffectiveDiscount,
CategorySegment
FROM CategoryDetails

-- Segment regions by total sales
WITH CustomerSegments AS (
SELECT    
Country,
ROUND(SUM(Sales), 2) AS TotalSales,
CASE WHEN Country IN ('Canada', 'USA') THEN 'North America'
     WHEN Country IN ('Argentina','Brazil', 'Mexico', 'Venezuala') THEN 'South America'
     ELSE 'Europe'
     END AS Region
FROM gold.fact_orders o
LEFT JOIN gold.dim_customers c
ON o.CustomerKey = c.CustomerKey
GROUP BY Country
)
SELECT
Region,
SUM(TotalSales) RegionalSales
FROM CustomerSegments
GROUP BY Region
ORDER BY SUM(TotalSales) DESC

--Segment products by selling price versus the current price, including the total sales of each segment.
WITH ProductSegments AS (
SELECT
p.ProductName,
o.SellingPrice,
p.UnitPrice AS CurrentPrice,
o.Quantity,
CASE WHEN SellingPrice > p.UnitPrice 
     THEN 'Above CurrentPrice'
     WHEN SellingPrice < p.UnitPrice
     THEN 'Below CurrentPrice'
     ELSE 'Equal to CurrentPrice'
     END AS PriceRange
FROM gold.fact_orders o
LEFT JOIN gold.dim_products p
ON o.ProductKey = p.ProductKey

)
SELECT
ProductName,
PriceRange,
COUNT(*) AS TotalProducts,
ROUND(SUM(SellingPrice * Quantity), 2) AS TotalSales
FROM ProductSegments
GROUP BY ProductName, PriceRange
