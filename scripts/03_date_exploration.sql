--Check how many order years are available
SELECT
MIN(OrderDate) AS FirstOrder,
MAX(OrderDate) AS LastOrder,
DATEDIFF(Year,MIN(OrderDate),MAX(OrderDate)) OrderRangeYears
FROM gold.fact_orders
--Find the number days between the required order date and the shipped date
SELECT
RequiredDate,
ShippedDate,
CASE WHEN RequiredDate > ShippedDate THEN DATEDIFF(DAY, ShippedDate,RequiredDate) 
     END AS OnTimeShipment,
CASE WHEN RequiredDate < ShippedDate THEN DATEDIFF(DAY, RequiredDate,ShippedDate) 
     END AS LateShipment
FROM gold.fact_orders
