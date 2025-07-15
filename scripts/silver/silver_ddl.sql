/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'silver' Tables
===============================================================================
*/

USE DataWarehouse;
GO

-- CRM CUSTOMER INFO
IF OBJECT_ID('silver.crm_cust_info','U') IS NOT NULL
BEGIN
	DROP TABLE silver.crm_cust_info
END
GO

CREATE TABLE silver.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- CRM PRODUCT INFO
IF OBJECT_ID('silver.crm_prd_info','U') IS NOT NULL
BEGIN
	DROP TABLE silver.crm_prd_info
END
GO

CREATE TABLE silver.crm_prd_info(
	prd_id INT,
	cat_id NVARCHAR(50),
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- CRM SALES DETAILS
IF OBJECT_ID('silver.crm_sales_details','U') IS NOT NULL
BEGIN
	DROP TABLE silver.crm_sales_details
END
GO

CREATE TABLE silver.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- ERP CUST AZ12
IF OBJECT_ID('silver.erp_cust_az12','U') IS NOT NULL
BEGIN
	DROP TABLE silver.erp_cust_az12;
END
GO

CREATE TABLE silver.erp_cust_az12(
	CID NVARCHAR(50),
	BDATE DATE,
	GEN NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)
GO

-- ERP LOC A101
IF OBJECT_ID('silver.erp_loc_a101','U') IS NOT NULL
BEGIN
	DROP TABLE silver.erp_loc_a101;
END
GO

CREATE TABLE silver.erp_loc_a101(
	CID NVARCHAR(50),
	CNTRY NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)
GO

-- ERP PX CAT G1V2
IF OBJECT_ID('silver.erp_px_cat_g1v2','U') IS NOT NULL
BEGIN
	DROP TABLE silver.erp_px_cat_g1v2;
END
GO

CREATE TABLE silver.erp_px_cat_g1v2(
	ID NVARCHAR(50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)
GO