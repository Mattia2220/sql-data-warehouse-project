CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	PRINT '>> Load table: silver.crm_cust_info';
	TRUNCATE TABLE silver.crm_cust_info;

	INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_gender,
	cst_maritial_status,
	cst_create_date
	)

	SELECT
	cst_id,
	cst_key,
	TRIM(cst_firstname) AS cst_firstname,
	TRIM(cst_lastname) AS cst_lastname,
	CASE 
		WHEN UPPER(TRIM(cst_gender)) = 'M' THEN 'Male'
		WHEN UPPER(TRIM(cst_gender)) = 'F' THEN 'Female'
		ELSE 'n/a'
	END cst_gender,	
	CASE
		WHEN UPPER(TRIM(cst_maritial_status)) = 'M' THEN 'Married'
		WHEN UPPER(TRIM(cst_maritial_status)) = 'S' THEN 'Single'
		ELSE 'n/a'
	END cst_maritial_status,
	cst_create_date
	FROM(
	SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS ROWN
	FROM bronze.crm_cust_info
	) t
	WHERE ROWN = 1 AND cst_id IS NOT NULL

	PRINT '>> Load table: silver.crm_prd_info';
	TRUNCATE TABLE silver.crm_prd_info;

	INSERT INTO silver.crm_prd_info (
	prd_id,
	prd_name,
	cat_id,
	prd_key,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
	)

	SELECT
	prd_id,
	prd_name,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
	ISNULL(prd_cost, 0) AS prd_cost,
	CASE UPPER(TRIM(prd_line))
		WHEN  'R' THEN 'Road'
		WHEN  'M' THEN 'Mountain'
		WHEN  'S' THEN 'Other Sales'
		WHEN  'T' THEN 'Touring'
		ELSE 'n/a'
	END prd_line,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
	FROM bronze.crm_prd_info

	PRINT '>> Load table: silver.crm_sales_details';
	TRUNCATE TABLE silver.crm_sales_details;

	INSERT INTO silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_price,
	sls_quantity
	)

	SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE
		WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_order_dt AS NVARCHAR) AS DATE)
	END sls_order_dt,
	CASE
		WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_ship_dt AS NVARCHAR) AS DATE)
	END sls_ship_dt,
	CASE
		WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 
		THEN NULL
		ELSE CAST(CAST(sls_due_dt AS NVARCHAR) AS DATE)
	END sls_due_dt,
	CASE
		WHEN sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
		THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END sls_sales,
	CASE
		WHEN sls_price IS NULL OR sls_price <= 0
		THEN sls_sales / NULLIF(sls_quantity, 0)
		ELSE sls_price
	END sls_price,
	sls_quantity
	FROM bronze.crm_sales_details


	PRINT '>> Load table: silver.erp_cust_az12';
	TRUNCATE TABLE silver.erp_cust_az12;

	INSERT INTO silver.erp_cust_az12(
	cid,
	bdate,
	gen)

	SELECT
	CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
	END cid,
	CASE 
		WHEN bdate > GETDATE() THEN NULL
		ELSE bdate
	END AS bdate,
	CASE
		WHEN UPPER(gen) IN ('MALE','M') THEN 'Male'
		WHEN UPPER(gen) IN ('FEMALE','F') THEN 'Female'
		ELSE 'n/a'
	END AS gen
	FROM bronze.erp_cust_az12


	PRINT '>> Load table: silver.erp_loc_a101';
	TRUNCATE TABLE silver.erp_loc_a101;

	INSERT INTO silver.erp_loc_a101(
	cid,
	country)

	SELECT DISTINCT
	REPLACE(cid, '-', '') AS cid,
	CASE
		WHEN UPPER(TRIM(country)) = 'DE' THEN 'Germany'
		WHEN UPPER(TRIM(country)) IN ('USA', 'US') THEN 'United States'
		WHEN UPPER(TRIM(country)) = '' THEN NULL
		ELSE TRIM(country)
	END country
	FROM bronze.erp_loc_a101

	PRINT '>> Load table: silver.erp_px_cat_g1v2';
	TRUNCATE TABLE silver.erp_px_cat_g1v2;

	INSERT INTO silver.erp_px_cat_g1v2(
	id,
	cat,
	subcat,
	maintenance
	)

	SELECT
	id,
	cat,
	subcat,
	maintenance
	FROM bronze.erp_px_cat_g1v2
END
