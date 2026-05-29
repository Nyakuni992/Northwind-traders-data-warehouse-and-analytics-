/*
=======================================================================================
DDL Script: Create Bronze Tables
=======================================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  By running this script, you are re-definning the DDL structure of 'bronze' Tables.
=======================================================================================
*/

Use Northwind_Traders;
-- Create Tables

IF OBJECT_ID ('bronze.categories', 'U') IS NOT NULL
  DROP TABLE bronze.categories;
GO

CREATE TABLE bronze.categories (
categoryID INT,
categoryName VARCHAR(50),
description VARCHAR(100)

);

GO 

IF OBJECT_ID ('bronze.customers', 'U') IS NOT NULL
  DROP TABLE bronze.customers;
GO

CREATE TABLE bronze.customers (
customerID VARCHAR(50),
companyName VARCHAR(50),
contactName VARCHAR(50),
contactTitle VARCHAR(50),
city VARCHAR(50),
country VARCHAR(50)

);

GO

IF OBJECT_ID ('bronze.employees', 'U') IS NOT NULL
  DROP TABLE bronze.employees;
GO

CREATE TABLE bronze.employees (
employeeID INT,
employeeName VARCHAR(50),
title VARCHAR(50),
city VARCHAR(50),
country VARCHAR(50),
reportsTo INT

);

GO

IF OBJECT_ID ('bronze.order_details', 'U') IS NOT NULL
  DROP TABLE bronze.order_details;
GO

CREATE TABLE bronze.order_details (
orderID INT,
productID INT,
unitPrice FLOAT,
quantity INT,
discount FLOAT

);

GO

IF OBJECT_ID ('bronze.orders', 'U') IS NOT NULL
  DROP TABLE bronze.orders;
GO

CREATE TABLE bronze.orders (
orderID INT,
customerID VARCHAR(50),
employeeID INT,
orderDate DATE,
requiredDate DATE,
shippedDate DATE,
shipperID INT,
freight FLOAT

);

GO

IF OBJECT_ID ('bronze.products', 'U') IS NOT NULL
  DROP TABLE bronze.products;
GO

CREATE TABLE bronze.products (
productID INT,
productName VARCHAR(50),
quantityPerUnit VARCHAR(50),
unitPrice FLOAT,
discontinued INT,
categoryID INT

);

GO

IF OBJECT_ID ('bronze.shippers', 'U') IS NOT NULL
  DROP TABLE bronze.shippers;
GO

CREATE TABLE bronze.shippers (
shipperID INT,
companyName VARCHAR(50)

);



