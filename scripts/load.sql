EXECUTE bronze.load_bronze;

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	BEGIN TRY
		PRINT '========================================';
		PRINT 'Load Bronze layer';
		PRINT '========================================';

		PRINT '----------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '----------------------------------------';

		DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME;
		SET @batch_start_time = GETDATE();
		TRUNCATE TABLE [bronze].[crm_cust_info]; 
		BULK INSERT [bronze].[crm_cust_info] 
		FROM 'C:\Users\matti\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);

		TRUNCATE TABLE [bronze].[crm_prd_info]; 
		BULK INSERT [bronze].[crm_prd_info] 
		FROM 'C:\Users\matti\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);

		TRUNCATE TABLE [bronze].[crm_sales_details]; 
		BULK INSERT [bronze].[crm_sales_details] 
		FROM 'C:\Users\matti\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);

		PRINT '----------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '----------------------------------------';

		TRUNCATE TABLE [bronze].[erp_cust_az12];
		BULK INSERT [bronze].[erp_cust_az12] 
		FROM 'C:\Users\matti\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);

		TRUNCATE TABLE [bronze].[erp_loc_a101];
		BULK INSERT [bronze].[erp_loc_a101] 
		FROM 'C:\Users\matti\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);

		TRUNCATE TABLE [bronze].[erp_px_cat_g1v2];
		BULK INSERT [bronze].[erp_px_cat_g1v2] 
		FROM 'C:\Users\matti\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
		SET @batch_end_time = GETDATE();
		PRINT '----------------------------------------';
		PRINT 'Loading duration: '+CAST(DATEDIFF(SECOND,@batch_end_time, @batch_start_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------------------';
	END TRY
	BEGIN CATCH
		PRINT 'Error occured during loading bronze layer';
		PRINT 'Errore message'+ ERROR_MESSAGE();
	END CATCH
END
