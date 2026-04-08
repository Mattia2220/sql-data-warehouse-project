INSERT INTO silver.erp_cust_az12(
cid,
bdate,
gen)

SELECT
SUBSTRING(cid, 4, LEN(cid)) AS cid,
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
