-- Explore all product categories
SELECT DISTINCT
ProductName,
categoryName
FROM gold.dim_products

-- Explore discontinued products
SELECT DISTINCT
categoryName,
ProductName
FROM gold.dim_products
WHERE Discontinued = 1
ORDER BY 1,2

--Explore dimension customers
SELECT DISTINCT
Country
FROM gold.dim_customers

-- Explore dimension employees
SELECT DISTINCT
EmployeeName,
Country
FROM gold.dim_employees

-- Explore dimension shippers
SELECT DISTINCT
ShipperName
FROM gold.dim_shippers
