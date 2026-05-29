/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    import the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

--Loading data into the silver layer

CREATE OR ALTER PROCEDURE silver.load_silver AS 
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
         SET @batch_start_time = GETDATE();
         PRINT'=========================================';
         PRINT'Loading Silver Layer';
         PRINT'=========================================';

         PRINT '------------------------------------------------';
		 PRINT 'Loading Categories';
		 PRINT '------------------------------------------------';
         SET @start_time = GETDATE();
         PRINT'>> Truncating table: silver.categories'
         TRUNCATE TABLE silver.categories;
         PRINT'>> Inserting Data Into: silver.categories'
         
         INSERT INTO silver.categories (
            categoryID ,
            categoryName,
            description

            )
            SELECT
                categoryID,
                categoryName,
                description
            FROM bronze.categories;
       SET @end_time = GETDATE()
       PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
       PRINT '------------------------------------------------';


       PRINT '------------------------------------------------';
	   PRINT 'Loading Customers';
	   PRINT '------------------------------------------------';

       SET @start_time = GETDATE();
         PRINT'>> Truncating table: silver.customers'
         TRUNCATE TABLE silver.customers;
         PRINT'>> Inserting Data Into: silver.customers'
         
         INSERT INTO silver.customers (
            customerID,
            companyName,
            contactName,
            contactTitle,
            city,
            country

            )
            SELECT
                customerID,
                companyName,
                contactName,
                contactTitle,
                city,
                country
            FROM bronze.customers;
       SET @end_time = GETDATE()
       PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
       PRINT '------------------------------------------------';

       PRINT '------------------------------------------------';
	   PRINT 'Loading Employees'
	   PRINT '------------------------------------------------';

       SET @start_time = GETDATE();
         PRINT'>> Truncating table: silver.employees'
         TRUNCATE TABLE silver.employees;
         PRINT'>> Inserting Data Into: silver.employees'
         
         INSERT INTO silver.employees (
            employeeID,
            employeeName,
            title,
            city,
            country,
            reportsTo

            )
            SELECT
                employeeID,
                employeeName,
                title,
                city,
                country,
                reportsTo
            FROM bronze.employees;
            SET @end_time = GETDATE()
       PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
       PRINT '------------------------------------------------';

       PRINT '------------------------------------------------';
	   PRINT 'Loading Order_details'
	   PRINT '------------------------------------------------';

       SET @start_time = GETDATE();
       PRINT'>> Truncating table: silver.order_details'
       TRUNCATE TABLE silver.order_details;
       PRINT'>> Inserting Data Into: silver.order_details'
       INSERT INTO silver.order_details (
            orderID,
            productID,
            unitPrice,
            quantity,
            discount

            )
            SELECT
                orderID,
                productID,
                unitPrice,
                quantity,
                discount
            FROM bronze.order_details;
            SET @end_time = GETDATE()
       PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
       PRINT '------------------------------------------------';

       PRINT '------------------------------------------------';
	   PRINT 'Loading Orders'
	   PRINT '------------------------------------------------';

       SET @start_time = GETDATE();
       PRINT'>> Truncating table: silver.orders'
       TRUNCATE TABLE silver.orders;
       PRINT'>> Inserting Data Into: silver.orders'
       INSERT INTO silver.orders (
            orderID,
            customerID,
            employeeID,
            orderDate,
            requiredDate,
            shippedDate,
            shipperID,
            freight

            )
            SELECT
                orderID,
                customerID,
                employeeID,
                orderDate,
                requiredDate,
                shippedDate,
                shipperID,
                freight
            FROM bronze.orders;
            SET @end_time = GETDATE()
       PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
       PRINT '------------------------------------------------'

       PRINT '------------------------------------------------';
	   PRINT 'Loading Products'
	   PRINT '------------------------------------------------';
       SET @start_time = GETDATE();
       PRINT'>> Truncating table: silver.products'
       TRUNCATE TABLE silver.products;
       PRINT'>> Inserting Data Into: silver.products'
       INSERT INTO silver.products (
            productID,
            productName,
            quantityPerUnit,
            productCount,
            packaging,
            unitPrice,
            discontinued,
            categoryID

            )
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
            FROM bronze.products;
       SET @end_time = GETDATE()
       PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
       PRINT '------------------------------------------------';

       PRINT '------------------------------------------------';
	   PRINT 'Loading Shippers'
	   PRINT '------------------------------------------------';

       SET @start_time = GETDATE();
       PRINT'>> Truncating table: silver.shippers'
       TRUNCATE TABLE silver.shippers;
       PRINT'>> Inserting Data Into: silver.shippers'
       INSERT INTO silver.shippers (
            shipperID,
            companyName

            )
            SELECT
                shipperID,
                companyName
            FROM bronze.shippers;
            SET @end_time = GETDATE()
       PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
       PRINT '------------------------------------------------';

       SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END












