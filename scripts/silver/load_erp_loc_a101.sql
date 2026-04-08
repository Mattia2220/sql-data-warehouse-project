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
