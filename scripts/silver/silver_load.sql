USE DataWarehouse
-- load into silver after cleaning

INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
		)
SELECT 
	cst_id,
	cst_key,
	TRIM(cst_firstname) as cst_firstname,
	TRIM(cst_lastname) as cst_lastname,
	CASE WHEN TRIM(UPPER(cst_marital_status)) = 'M' THEN 'Married'
		 WHEN TRIM(UPPER(cst_marital_status)) = 'S' THEN 'Single' 
		 ELSE 'NA'
	END as cst_martital_status,
	CASE WHEN TRIM(UPPER(cst_gndr)) = 'M' THEN 'Male'
		 WHEN TRIM(UPPER(cst_gndr)) = 'F' THEN 'Female'
	ELSE 'NA'
	END as cst_gndr,
	cst_create_date
FROM (
SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as ncount
FROM bronze.crm_cust_info
)t where ncount = 1 AND cst_id IS NOT NULL; 