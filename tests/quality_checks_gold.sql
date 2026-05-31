/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
This script runs quality checks to verify the integrity, consistency, and accuracy of the Gold Layer. It ensures:
         Surrogate keys in dimension tables remain unique.
         Proper referential integrity between fact and dimension tables.
         Correct relationships within the data model to support reliable analytics.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_products'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
ProductKey,
COUNT(*) AS DuplicateCount
FROM gold.dim_products
GROUP BY ProductKey
HAVING COUNT(*) > 1

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
CustomerKey,
COUNT(*) AS DuplicateCount
FROM gold.dim_customers
GROUP BY CustomerKey
HAVING COUNT(*) > 1

-- ====================================================================
-- Checking 'gold.dim_employees'
-- ====================================================================
-- Check for Uniqueness of Employee Key in gold.dim_customers
-- Expectation: No results 
SELECT 
EmployeeKey,
COUNT(*) AS DuplicateCount
FROM gold.dim_employees
GROUP BY EmployeeKey
HAVING COUNT(*) > 1

-- ====================================================================
-- Checking 'gold.dim_shippers'
-- ====================================================================
-- Check for Uniqueness of Shipper Key in gold.dim_customers
-- Expectation: No results 
SELECT 
ShipperKey,
COUNT(*) AS DuplicateCount
FROM gold.dim_shippers
GROUP BY ShipperKey
HAVING COUNT(*) > 1

-- ====================================================================
-- Checking 'gold.fact_orders'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
-- Expectation: No results 

SELECT
    *
FROM gold.fact_orders o
LEFT JOIN gold.dim_customers c
ON o.CustomerKey = c.CustomerKey
LEFT JOIN gold.dim_products p
ON o.ProductKey = p.ProductKey
LEFT JOIN gold.dim_employees e
ON o.EmployeeKey = e.EmployeeKey
LEFT JOIN gold.dim_shippers s
ON o.ShipperKey = s.ShipperKey
WHERE c.CustomerKey IS NULL OR
      p.ProductKey  IS NULL OR
      e.EmployeeKey IS NULL OR
      s.ShipperKey  IS NULL

