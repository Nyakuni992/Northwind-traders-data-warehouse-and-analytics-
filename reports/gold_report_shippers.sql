/*
===============================================================
Report Shippers
===============================================================
This report provides key shipping metrics such as the total number of orders shipped, average delivery time, 
total freight cost, and shipping performance by carrier.

It supports operational analysis by helping stakeholders evaluate shipper efficiency, compare delivery performance, 
monitor shipping costs, and identify opportunities to improve order fulfillment and customer satisfaction.
===============================================================
*/

CREATE VIEW  gold.report_shippers AS
WITH Base_Query AS (
SELECT
o.OrderID,
SUM(Quantity) AS TotalUnitShipped,
MAX(o.FreightCost) AS FreightCost,
o.OrderDate,
o.ShippedDate,
DATEDIFF(DAY,OrderDate,ShippedDate) AS ShippingTime,
o.ShipperKey,
s.ShipperID,
s.ShipperName
FROM gold.fact_orders o
LEFT JOIN gold.dim_shippers s
ON o.ShipperKey = s.ShipperKey
WHERE o.ShipperKey IS NOT NULL 
GROUP BY
OrderID,
o.OrderDate,
o.ShippedDate,
o.ShipperKey,
s.ShipperID,
s.ShipperName

)

SELECT
ShipperKey,
ShipperID,
ShipperName,
COUNT(DISTINCT OrderID) AS TotalOrders,
SUM(TotalUnitShipped) AS TotalshippedUnits,
SUM(FreightCost) AS TotalFreightCost,
MAX(ShippedDate) AS LastShippedDate,
DATEDIFF(MONTH, MIN(OrderDate), MAX(ShippedDate)) AS LifeSpan,
-- Recency
DATEDIFF(MONTH, MAX(ShippedDate), GETDATE()) AS Recency,

-- average shipping time (days between shipping and order date)
AVG(ShippingTime) AS AvgShippingTime,

-- average freight cost per order
ROUND(SUM(FreightCost) / 
NULLIF(COUNT(DISTINCT OrderID), 0),2) AS AvgFreightCostPerOrder,

-- Average Freight Cost Per Unit
ROUND(SUM(FreightCost) / 
NULLIF(SUM(TotalUnitShipped), 0),2) AS AvgFreightCostPerUnit
FROM Base_Query
GROUP BY
ShipperKey,
ShipperID,
ShipperName
