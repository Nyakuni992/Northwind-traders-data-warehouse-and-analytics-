-- Total customers by country
SELECT   
Country,
COUNT(*) TotalCustomers
FROM gold.dim_customers
GROUP BY Country

-- Total products by category
SELECT  
CategoryName,
COUNT(*) TotalProducts
FROM gold.dim_products
GROUP BY CategoryName
ORDER BY TotalProducts DESC

-- Freight costs by Country
WITH order_freight AS (
    SELECT
        OrderID,
        Country,
        MAX(FreightCost) AS Freight
    FROM gold.fact_orders o
    LEFT JOIN gold.dim_customers c
    ON o.CustomerKey = c.CustomerKey
    GROUP BY
        OrderID,
        Country
)
SELECT
    Country,
    SUM(Freight) AS TotalFreightCost
FROM order_freight
GROUP BY Country
ORDER BY TotalFreightCost DESC;

-- Freight Cost by Shipper
WITH order_freight AS (
    SELECT
        OrderID,
        ShipperID,
        ShipperName,
        MAX(FreightCost) AS Freight
    FROM gold.fact_orders o
    LEFT JOIN gold.dim_shippers s
    ON o.ShipperKey = s.ShipperKey
    GROUP BY
        OrderID,
        ShipperID,
        ShipperName
)
SELECT
    ShipperID,
    ShipperName,
    SUM(Freight) AS TotalShippingCost
FROM order_freight
GROUP BY ShipperID, ShipperName
ORDER BY TotalShippingCost DESC

-- Total Gross revenue by category
SELECT  
p.CategoryName,
ROUND(SUM (Quantity * o.UnitPrice), 2) TotalRevenue
FROM gold.fact_orders o
LEFT JOIN gold.dim_products p
ON o.ProductKey = p.ProductKey
GROUP BY p.CategoryName
ORDER BY TotalRevenue DESC

-- Total Net revenue by category
SELECT  
p.CategoryName,
ROUND(SUM (Sales), 2) TotalRevenue
FROM gold.fact_orders o
LEFT JOIN gold.dim_products p
ON o.ProductKey = p.ProductKey
GROUP BY p.CategoryName
ORDER BY TotalRevenue DESC

-- Total revenue by each customer 
SELECT  
c.CompanyName,
c.Country,
ROUND(SUM (Sales), 2) TotalRevenue
FROM gold.fact_orders o
LEFT JOIN gold.dim_customers c
ON o.CustomerKey = c.CustomerKey
GROUP BY c.CompanyName, c.Country
ORDER BY TotalRevenue DESC

-- Total revenue by country
SELECT  
c.Country,
ROUND(SUM(Sales), 2) TotalRevenue
FROM gold.fact_orders o
LEFT JOIN gold.dim_customers c
ON o.CustomerKey = c.CustomerKey
GROUP BY c.Country
ORDER BY TotalRevenue DESC
-- Distribution of sold items across countries
SELECT
c.Country,
SUM(Quantity) TotalItems
FROM gold.fact_orders o
LEFT JOIN gold.dim_customers c
ON c.CustomerKey = o.CustomerKey
GROUP BY c.Country
ORDER BY TotalItems DESC

