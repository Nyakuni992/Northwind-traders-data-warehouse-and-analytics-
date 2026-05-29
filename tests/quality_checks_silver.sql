/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date and time ranges.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after loading data into the Silver Layer.
    - Review and resolve any inconsistencies found during the checks.
===============================================================================
*/
--================================================
-- Checking Categories
--================================================

-- Check for nulls and duplicates in primary key
-- Expectation is Non
SELECT  
categoryID,
COUNT(*) as totalCount
FROM bronze.categories
GROUP BY categoryID
HAVING COUNT(*) > 1 OR categoryID IS NULL
-- Check for unwanted spaces
SELECT
categoryName,
description
FROM bronze.categories
WHERE categoryName != UPPER(TRIM(categoryName)) OR description != UPPER(TRIM(description))

--==============================================
-- Checking Customers
--==============================================
-- Check for nulls & duplicates in primary key
-- Expectation is Non
SELECT
customerID,
COUNT(*) as totalCount
FROM bronze.customers
GROUP BY customerID
HAVING COUNT(*) > 1 OR customerID IS NULL
-- Check for unwanted spaces
SELECT
companyName,
contactTitle, 
city,
country
FROM bronze.customers
WHERE 
companyName != UPPER(TRIM(companyName)) OR 
contactTitle != UPPER(TRIM(contactTitle)) OR
city != UPPER(TRIM(city)) OR
country != UPPER(TRIM(country))
-- Check for data uniformty
SELECT DISTINCT
country 
FROM bronze.customers

--==================================================
-- Checking Employees
--==================================================

--Check for duplicates and nulls in primary key
-- Expectation is Non
SELECT
employeeID,
COUNT(*) as totalCount
FROM bronze.employees
GROUP BY employeeID
HAVING COUNT(*) > 1 OR employeeID IS NULL
-- Check for unwanted spaces
SELECT
employeeName,
title,
city,  
country
FROM bronze.employees
WHERE 
employeeName != UPPER(TRIM(employeeName)) OR
title != UPPER(TRIM(title)) OR
city != UPPER(TRIM(city)) OR
country != UPPER(TRIM(country))

--==================================================
--Checking Orders
--==================================================
    
-- Check for nulls & duplicates in primary key
-- Expectation is Non
SELECT
orderID,
COUNT(*)
FROM bronze.orders
GROUP BY orderID
HAVING COUNT(*) > 1 OR orderID IS NULL
-- Check for nulls in foreign keys
SELECT
orderID,
employeeID,
shipperID 
FROM bronze.orders
WHERE orderID IS NULL OR employeeID IS NULL OR shipperID IS NULL 
-- Check for Orpharned foreign keys
SELECT
o.customerID,
o.employeeID,
o.shipperID 
FROM bronze.orders o
LEFT JOIN bronze.customers c
ON C.customerID = O.customerID
LEFT JOIN bronze.employees e
ON e.employeeID = o.employeeID
LEFT JOIN bronze.shippers s
ON s.shipperID = o.shipperID
WHERE c.customerID IS NULL OR
e.employeeID IS NULL OR
s.shipperID IS NULL 
-- Check for invalid dates 
SELECT
orderDate,
requiredDate,
shippedDate
FROM bronze.orders
WHERE 
LEN(orderDate) != 10 OR 
LEN(shippedDate) != 10 OR 
LEN(requiredDate) != 10
-- Check for invalid required date and shipped date
SELECT
orderDate,
requiredDate,
shippedDate
FROM bronze.orders
WHERE 
requiredDate < orderDate OR 
shippedDate < orderDate 
-- Check for negative costs
SELECT
freight
FROM bronze.orders
WHERE freight < 0

--=================================================
-- Order details
--=================================================
    
-- Check nulls in foreign key
-- Expectation is Non
SELECT
orderID,
productID
FROM bronze.order_details
WHERE orderID IS NULL OR productID IS NULL
-- Check for orpharned foreign keys
SELECT
od.orderID,
od.productID
FROM bronze.order_details od
LEFT JOIN bronze.orders o
ON od.orderID = o.orderID
LEFT JOIN bronze.products p
ON od.productID = p.productID
WHERE o.orderID IS NULL OR p.productID IS NULL
-- Check for negative  price, quantity and discount
SELECT
unitPrice,
quantity,
discount
FROM bronze.order_details
WHERE
unitPrice < 0 OR
quantity< 0 OR
discount < 0

--===================================================
-- Checking Products
--===================================================
    
--Check for nulls and duplicates in primary keys
-- Expectation is Non
SELECT
productID,
COUNT(*)
FROM bronze.products
GROUP BY productID
HAVING COUNT(*) > 1 OR productID IS NULL
-- Check for unwanted spaces
SELECT
productName
FROM bronze.products
WHERE productName != UPPER(TRIM(productName)) 

-- Check for nulls and unwanted spaces in product quantity per unit
SELECT
quantityPerUnit
FROM bronze.products
WHERE quantityPerUnit IS NULL OR quantityPerUnit != UPPER(TRIM(quantityPerUnit))
-- Check for duplicate format variations
SELECT DISTINCT 
quantityPerUnit
FROM bronze.products
WHERE quantityPerUnit NOT LIKE '%[0-9]%[a-zA-Z]%'-- ensure that both numeric and alphabetical characters are used
-- Validate Pattern structure
SELECT DISTINCT 
quantityPerUnit
FROM bronze.products
WHERE quantityPerUnit LIKE '%ounce%'
   OR quantityPerUnit LIKE '%milliliter%'
   OR quantityPerUnit LIKE '%pkgs%'
   OR quantityPerUnit LIKE '%packages%'
   OR quantityPerUnit LIKE '%bottles%'
-- Data Structure Standardization 
SELECT
    productID,
    productName,
    CASE
        WHEN quantityPerUnit LIKE '%[0-9]% - %[0-9]%box%' THEN REPLACE(quantityPerUnit,'box','boxes')
        WHEN quantityPerUnit LIKE '%[0-9]% - %[0-9]%jar%' THEN REPLACE(quantityPerUnit,'jar','jars')
        WHEN quantityPerUnit LIKE '%[0-9]% - %[0-9]bottle%' THEN REPLACE(quantityPerUnit,'bottle','bottles')
        WHEN quantityPerUnit LIKE '%[0-9]% - %[0-9]%bag%' THEN REPLACE(quantityPerUnit,'bag','bags')
        WHEN quantityPerUnit LIKE '%[0-9]% - %[0-9]%pkg%' THEN REPLACE(quantityPerUnit,'pkg','pkgs')
        WHEN quantityPerUnit LIKE '%[0-9]% - %[0-9]%can%' THEN REPLACE(quantityPerUnit,'can','cans')
        WHEN quantityPerUnit LIKE '%[0-9]% - %[0-9]%tin%' THEN REPLACE(quantityPerUnit,'tin','tins')
        WHEN quantityPerUnit LIKE '%[0-9]% - %[0-9]%glass%' THEN REPLACE(quantityPerUnit,'glass','glasses')
        WHEN quantityPerUnit LIKE '%[0-9]% - %[0-9]%piece%' THEN REPLACE(quantityPerUnit,'piece','pieces')
        WHEN quantityPerUnit LIKE '%[0-9]% - %[0-9]%pie%' THEN REPLACE(quantityPerUnit,'pie','pies')
        WHEN quantityPerUnit LIKE '%[0-9]% - %[0-9]%round%' THEN REPLACE(quantityPerUnit,'round','rounds')
        WHEN quantityPerUnit LIKE '%[0-9]% - %[0-9]%bar%' THEN REPLACE(quantityPerUnit,'bar','bars')
        ELSE quantityPerUnit
        END AS quantityPerUnit,
    -- Extract First numeric value
    LEFT(quantityPerUnit, PATINDEX('%[^0-9]%', quantityPerUnit + ' ') - 1) AS productCount,
     CASE
        WHEN quantityPerUnit LIKE '%box%' THEN 'box'
        WHEN quantityPerUnit LIKE '%jar%' THEN 'jar'
        WHEN quantityPerUnit LIKE '%bottle%' THEN 'bottle'
        WHEN quantityPerUnit LIKE '%bag%' THEN 'bag'
        WHEN quantityPerUnit LIKE '%pkg%' THEN 'pkg'
        WHEN quantityPerUnit LIKE '%can%' THEN 'can'
        WHEN quantityPerUnit LIKE '%tin%' THEN 'tin'
        WHEN quantityPerUnit LIKE '%glass%' THEN 'glass'
        WHEN quantityPerUnit LIKE '%piece%' THEN 'piece'
        WHEN quantityPerUnit LIKE '%pie%' THEN 'pie'
        WHEN quantityPerUnit LIKE '%round%' THEN 'round'
        WHEN quantityPerUnit LIKE '%bar%' THEN 'bar'
        ELSE NULL
        END AS Packaging,
    unitPrice,
    discontinued,
    categoryID
FROM bronze.products

--=========================================================
-- Checking Shippers
--=========================================================
-- Check for unwanted spaces
SELECT
companyName
FROM bronze.shippers
WHERE companyName != UPPER(TRIM(companyName))

