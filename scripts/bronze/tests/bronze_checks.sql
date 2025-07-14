USE DataWarehouse;

-- ========================================
-- Data Quality Checks for bronze.crm_cust_info
-- Purpose:
--   1. Check for NULLs and Duplicates in primary key (cst_id)
--   2. Identify unwanted leading/trailing spaces in key text fields
--   3. Review data consistency for categorical fields
-- Expectations:
--   • All queries should return zero rows if data is clean.
--   • Final DISTINCT queries should show consistent and standardized values.
-- ========================================

-- 1. NULL and Duplicate Check on cst_id
-- Expectation: No output (each cst_id should appear exactly once and not be NULL)
SELECT
    cst_id
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) <> 1 OR cst_id IS NULL;

-- 2. Whitespace Checks on Key Text Fields
-- Expectation: No output (values should not have leading/trailing spaces)

-- First name
SELECT cst_firstname
FROM bronze.crm_cust_info 
WHERE TRIM(cst_firstname) <> cst_firstname;

-- Last name
SELECT cst_lastname
FROM bronze.crm_cust_info 
WHERE TRIM(cst_lastname) <> cst_lastname;

-- Marital status
SELECT cst_marital_status
FROM bronze.crm_cust_info 
WHERE TRIM(cst_marital_status) <> cst_marital_status;

-- Customer key
SELECT cst_key
FROM bronze.crm_cust_info 
WHERE TRIM(cst_key) <> cst_key;

-- Gender
SELECT cst_gndr
FROM bronze.crm_cust_info 
WHERE TRIM(cst_gndr) <> cst_gndr;

-- 3. Data Consistency Checks for Categorical Fields
-- Expectation: Output should show standardized, limited set of values

-- Marital status values
SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info;

-- Gender values
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;
