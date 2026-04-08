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
