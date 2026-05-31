/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS 
SELECT
ROW_NUMBER() OVER (ORDER BY ProductID) AS ProductKey,
    p.productID            AS ProductID,
    p.productName          AS ProductName,
     p.quantityPerUnit      AS QuantityPerUnitDescription,
    p.categoryID           AS CategoryID,
    c.categoryName         AS CategoryName,
    c.description          AS CategoryDescription,
    p.productCount         AS PackageCount,
    p.packaging            AS Packaging,
    p.unitPrice            AS UnitPrice,
    p.discontinued         AS Discontinued   
FROM silver.products p
LEFT JOIN silver.categories c
ON p.categoryID = c.categoryID

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
ROW_NUMBER() OVER (ORDER BY customerID) AS CustomerKey,
    customerID     AS CustomerID,
    companyName    AS CompanyName,
    contactName    AS PrimaryContactName,
    contactTitle   AS ContactTitle,
    city           AS City,
    country        AS Country
FROM silver.customers

-- =============================================================================
-- Create Dimension: gold.dim_employees
-- =============================================================================
IF OBJECT_ID('gold.dim_employees', 'V') IS NOT NULL
    DROP VIEW gold.dim_employees;
GO

CREATE VIEW gold.dim_employees AS 
SELECT
ROW_NUMBER() OVER (ORDER BY employeeID) AS EmployeeKey,
    employeeID   AS EmployeeID,
    employeeName AS EmployeeName,
    title        AS JobTitle,
    reportsTo    AS ManagerID,
    city         AS City,
    country      AS Country
FROM silver.employees

-- =============================================================================
-- Create Dimension: gold.dim_shippers
-- =============================================================================
IF OBJECT_ID('gold.dim_shippers', 'V') IS NOT NULL
    DROP VIEW gold.dim_shippers;
GO

CREATE VIEW gold.dim_shippers AS 
SELECT
    ROW_NUMBER() OVER (ORDER BY shipperID) AS ShipperKey,
    shipperID   AS ShipperID,
    companyName AS ShipperName
FROM silver.shippers

-- =============================================================================
-- Create Fact: gold.fact_orders
-- =============================================================================
IF OBJECT_ID('gold.fact_orders', 'V') IS NOT NULL
    DROP VIEW gold.fact_orders;
GO

CREATE VIEW gold.fact_orders AS 
SELECT
    o.orderID        AS OrderID,
    c.CustomerKey,
    p.ProductKey,
    e.EmployeeKey,
    S.ShipperKey,
    o.orderDate      AS OrderDate,
    o.requiredDate   AS RequiredDate,
    o.shippedDate    AS ShippedDate,
    od.quantity      AS Quantity,
    od.unitPrice     AS UnitPrice,
    od.discount      AS DiscountRate,
    o.freight        AS FreightCost
FROM silver.orders o
LEFT JOIN silver.order_details od
ON o.orderID = od.orderID
LEFT JOIN gold.dim_customers c
ON o.customerID = c.CustomerID
LEFT JOIN gold.dim_products p
ON od.productID = p.productID
LEFT JOIN gold.dim_employees e
ON o.employeeID = e.EmployeeID
LEFT JOIN gold.dim_shippers s
ON o.shipperID = s.shipperID
