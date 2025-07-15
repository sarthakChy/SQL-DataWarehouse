USE DataWarehouse;
GO;
-- load into silver after cleaning

-- Customer Info
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
GO;

-- Product Info

INSERT INTO silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
	SUBSTRING(prd_key,7,LEN(prd_key)) as prd_key,
	prd_nm,
	ISNULL(prd_cost,0) as prd_cost,
	CASE TRIM(UPPER(prd_line))
		WHEN 'M' THEN 'Mountains'
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Other Sales'
		WHEN 'T' THEN 'Touring'
		ELSE 'NA'
	END as prd_line,
	CAST(prd_start_dt as DATE) as prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 as DATE) as prd_end_dt
FROM bronze.crm_prd_info;
GO