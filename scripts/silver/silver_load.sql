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

-- LOAD Customer Sales Data (crm_sales_details)
INSERT INTO silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE
		WHEN sls_order_dt<=0 OR len(sls_order_dt)!=8 THEN NULL
		ELSE CAST(CAST(sls_order_dt as VARCHAR) as DATE)
	END as sls_order_dt,
	CASE
		WHEN sls_ship_dt<=0 OR len(sls_ship_dt)!=8 THEN NULL
		ELSE CAST(CAST(sls_ship_dt as VARCHAR) as DATE)
	END as sls_ship_dt,
	CASE
		WHEN sls_due_dt<=0 OR len(sls_due_dt)!=8 THEN NULL
		ELSE CAST(CAST(sls_due_dt as VARCHAR) as DATE)
	END as sls_due_dt,
	CASE
		WHEN sls_sales <=0 OR sls_sales IS NULL or sls_sales != sls_quantity * ABS(sls_price) 
			THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END as sls_sales,
	sls_quantity,
	CASE
		WHEN sls_price <=0 OR sls_price IS NULL
			THEN sls_sales/NULLIF(sls_quantity,0)
		ELSE sls_price
	END as sls_price
FROM bronze.crm_sales_details
GO

-- LOAD ERP CUST meta data bdate
INSERT INTO silver.erp_cust_az12(
	CID,
	BDATE,
	GEN
)
SELECT
	CASE
		WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID,4,LEN(CID))
		ELSE CID
	END as CID,
	CASE
		WHEN BDATE > GETDATE() THEN NULL
		ELSE BDATE
	END as BDATE,
	CASE 
		WHEN TRIM(UPPER(GEN)) IN ('F','FEMALE') THEN 'Female'
		WHEN TRIM(UPPER(GEN)) IN ('M','MALE') THEN 'Male'
		ELSE 'NA'
	END as GEN
FROM bronze.erp_cust_az12

-- LOAD ERP location meta dta 
INSERT INTO silver.erp_loc_a101(
	CID,
	CNTRY
)
SELECT 
	REPLACE(CID,'-','') as CID,
	CASE 
		WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
		WHEN TRIM(CNTRY) IN ('US','USA') THEN 'United States'
		WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'NA'
		ELSE TRIM(CNTRY)
	END as CNTRY
FROM bronze.erp_loc_a101
