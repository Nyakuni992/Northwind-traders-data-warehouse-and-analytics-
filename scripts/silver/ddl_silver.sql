/*
==================================================================================
DDL Script: Create Silver Tables
==================================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  By running this script, you are re-definnning the DDL structure of 'bronze' Tables.
==================================================================================
*/

-- Create Tables

IF OBJECT_ID ('silver.categories', 'U') IS NOT NULL
  DROP TABLE silver.categories;
GO

CREATE TABLE silver.categories (
categoryID INT,
categoryName VARCHAR(50),
description VARCHAR(100),
nwtCreateDate DATETIME2 DEFAULT GETDATE()

);

GO 

IF OBJECT_ID ('silver.customers', 'U') IS NOT NULL
  DROP TABLE silver.customers;
GO

CREATE TABLE silver.customers (
customerID VARCHAR(50),
companyName VARCHAR(50),
contactName VARCHAR(50),
contactTitle VARCHAR(50),
city VARCHAR(50),
country VARCHAR(50),
nwtCreateDate DATETIME2 DEFAULT GETDATE()

);

GO

IF OBJECT_ID ('silver.employees', 'U') IS NOT NULL
  DROP TABLE silver.employees;
GO

CREATE TABLE silver.employees (
employeeID INT,
employeeName VARCHAR(50),
title VARCHAR(50),
city VARCHAR(50),
country VARCHAR(50),
reportsTo INT,
nwtCreateDate DATETIME2 DEFAULT GETDATE()

);

GO

IF OBJECT_ID ('silver.order_details', 'U') IS NOT NULL
  DROP TABLE silver.order_details;
GO

CREATE TABLE silver.order_details (
orderID INT,
productID INT,
unitPrice FLOAT,
quantity INT,
discount FLOAT,
nwtCreateDate DATETIME2 DEFAULT GETDATE()

);

GO

IF OBJECT_ID ('silver.orders', 'U') IS NOT NULL
  DROP TABLE silver.orders;
GO

CREATE TABLE silver.orders (
orderID INT,
customerID VARCHAR(50),
employeeID INT,
orderDate DATE,
requiredDate DATE,
shippedDate DATE,
shipperID INT,
freight FLOAT,
nwtCreateDate DATETIME2 DEFAULT GETDATE()

);

GO

IF OBJECT_ID ('silver.products', 'U') IS NOT NULL
  DROP TABLE silver.products;
GO

CREATE TABLE silver.products (
productID INT,
productName VARCHAR(50),
quantityPerUnit VARCHAR(50),
productCount INT,
packaging NVARCHAR(50),
unitPrice FLOAT,
discontinued INT,
categoryID INT,
nwtCreateDate DATETIME2 DEFAULT GETDATE()

);

GO

IF OBJECT_ID ('silver.shippers', 'U') IS NOT NULL
  DROP TABLE silver.shippers;
GO

CREATE TABLE silver.shippers (
shipperID INT,
companyName VARCHAR(50),
nwtCreateDate DATETIME2 DEFAULT GETDATE()

);



