/*
===============================================================================
Gold Layer: Presentation Views (Star Schema)
===============================================================================
Description:
    This script creates the final analytical layer (Gold) of the Data Warehouse.
    The Gold Layer presents data in a Star Schema format, consisting of:
    - Dimension Tables (dim_customer, dim_products): Descriptive attributes.
    - Fact Table (fact_sales): Quantitative metrics and foreign keys.

Key Features:
    - Surrogate Key Generation: Uses ROW_NUMBER() for unique identification.
    - Data Integration: Joins CRM and ERP data from the Silver Layer.
    - Business Logic: Implements master data rules (e.g., CRM as master for gender).
    - Data Filtering: Excludes historical product records (prd_end_dt IS NULL).

Source Layer:
    - Silver Layer (Cleanse Data)
===============================================================================
*/

CREATE VIEW gold.dim_customer AS
SELECT 
  ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
  ci.cst_id AS customer_id,
  ci.cst_key AS customer_number,
  ci.cst_firstname AS first_name,
  ci.cst_maritial_status AS maritial_status,
  ci.cst_create_date AS create_date,
  ca.bdate AS birthdate,
  la.country AS country,
  CASE
  	WHEN ci.cst_gender != 'n/a' THEN ci.cst_gender -- Crm is the Master for the gender
  	ELSE COALESCE(ca.gen, 'n/a')
  END AS gender
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON ci.cst_key = la.cid

CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_name AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS product_cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL --Filter Historical data out


CREATE VIEW gold.fact_sales AS
SELECT
  sd.sls_ord_num AS order_number,
  pr.product_key,
  cu.customer_key,
  sd.sls_order_dt AS order_date,
  sd.sls_ship_dt AS shipping_date,
  sd.sls_due_dt AS due_date,
  sd.sls_sales AS sales_amount,
  sd.sls_quantity AS quantity,
  sd.sls_price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customer cu
ON sd.sls_cust_id = cu.customer_id
