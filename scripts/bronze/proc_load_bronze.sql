/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
--Loading Data Into The Bronze Layer

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
  BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
     
      BEGIN TRY
         SET @batch_start_time = GETDATE();
         PRINT'=========================================';
         PRINT'Loading Bronze Layer';
         PRINT'=========================================';

         SET @start_time = GETDATE();
         PRINT'>> Truncating table: bronze.categories'
         TRUNCATE TABLE bronze.categories;

         PRINT'>> Inserting Data Into: bronze.categories'
         BULK INSERT bronze.categories
         FROM 'C:\dataset\Northwind Traders\categories.csv'
         WITH(
             FIRSTROW = 2,
             FIELDTERMINATOR = ',',
             TABLOCK
         );

         SET @end_time = GETDATE();
         PRINT'>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
         PRINT'-----------------------------------------'


         SET @start_time = GETDATE();
         PRINT'>> Truncating table: bronze.customers'
         TRUNCATE TABLE bronze.customers;

         PRINT'>> Inserting Data Into: bronze.customers'
         BULK INSERT bronze.customers
         FROM 'C:\dataset\Northwind Traders\customers.csv'
         WITH(
             FIRSTROW = 2,
             FIELDTERMINATOR = ',',
             TABLOCK
         );

         SET @end_time = GETDATE();
         PRINT'>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
         PRINT'-----------------------------------------'


         SET @start_time = GETDATE();
         PRINT'>> Truncating table: bronze.employees'
         TRUNCATE TABLE bronze.employees;

         PRINT'>> Inserting Data Into: bronze.employees'
         BULK INSERT bronze.employees
         FROM 'C:\dataset\Northwind Traders\employees.csv'
         WITH(
             FIRSTROW = 2,
             FIELDTERMINATOR = ',',
             TABLOCK
         );

         SET @end_time = GETDATE();
         PRINT'>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
         PRINT'-----------------------------------------'


         SET @start_time = GETDATE();
         PRINT'>> Truncating table: bronze.order_details'
         TRUNCATE TABLE bronze.order_details;

         PRINT'>> Inserting Data Into: bronze.order_details'
         BULK INSERT bronze.order_details
         FROM 'C:\dataset\Northwind Traders\order_details.csv'
         WITH(
             FIRSTROW = 2,
             FIELDTERMINATOR = ',',
             TABLOCK
         );

         SET @end_time = GETDATE();
         PRINT'>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
         PRINT'-----------------------------------------'


         SET @start_time = GETDATE();
         PRINT'>> Truncating table: bronze.orders'
         TRUNCATE TABLE bronze.orders;

         PRINT'>> Inserting Data Into: bronze.orders'
         BULK INSERT bronze.orders
         FROM 'C:\dataset\Northwind Traders\orders.csv'
         WITH(
             FIRSTROW = 2,
             FIELDTERMINATOR = ',',
             TABLOCK
         );

         SET @end_time = GETDATE();
         PRINT'>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
         PRINT'-----------------------------------------'


         SET @start_time = GETDATE();
         PRINT'>> Truncating table: bronze.products'
         TRUNCATE TABLE bronze.products;

         PRINT'>> Inserting Data Into: bronze.products'
         BULK INSERT bronze.products
         FROM 'C:\dataset\Northwind Traders\products.csv'
         WITH(
             FIRSTROW = 2,
             FIELDTERMINATOR = ',',
             TABLOCK
         );

         SET @end_time = GETDATE();
         PRINT'>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
         PRINT'-----------------------------------------'


         SET @start_time = GETDATE();
         PRINT'>> Truncating table: bronze.shippers'
         TRUNCATE TABLE bronze.shippers;

         PRINT'>> Inserting Data Into: bronze.shippers'
         BULK INSERT bronze.shippers
         FROM 'C:\dataset\Northwind Traders\shippers.csv'
         WITH(
             FIRSTROW = 2,
             FIELDTERMINATOR = ',',
             TABLOCK
         );

         SET @end_time = GETDATE();
         PRINT'>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
         PRINT'-----------------------------------------'

         SET @batch_end_time = GETDATE();
         PRINT'============================================'
         PRINT'Loading Bronze Layer is Completed';
         PRINT'Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
         PRINT'============================================'

     END TRY
     BEGIN CATCH
         PRINT'============================================='
         PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER'
         PRINT'Error Message' + ERROR_MESSAGE();
         PRINT'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
         PRINT'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
         PRINT'==============================================='
     END CATCH
    END

