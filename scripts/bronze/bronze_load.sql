
/*
====================================================================================
Script: Load Bronze Layer Tables from CSV Files

Description:
    Executes the `load_csv` procedure to truncate and load data into `bronze` tables 
    from CSV files. Covers both CRM and ERP datasets from local file paths.

Assumptions:
    - All files are comma-delimited and have a header row (FIRSTROW = 2).
    - Tables already exist in the [bronze] schema.
    - The stored procedure 'load_csv' is already created and available in the database.

Note:
    Ensure SQL Server has access to the file paths specified (use UNC paths if needed).
====================================================================================
*/

USE DataWarehouse;
GO

-- LOAD CRM Customer Info
EXEC load_csv 
    @Schema = 'bronze',
    @Table = 'crm_cust_info',
    @Path = 'C:\Users\modx\Desktop\SQL-DataWarehouse\datasets\source_crm\cust_info.csv';
GO

-- LOAD CRM Product Info
EXEC load_csv 
    @Schema = 'bronze',
    @Table = 'crm_prd_info',
    @Path = 'C:\Users\modx\Desktop\SQL-DataWarehouse\datasets\source_crm\prd_info.csv';
GO

-- LOAD CRM Sales Details
EXEC load_csv 
    @Schema = 'bronze',
    @Table = 'crm_sales_details',
    @Path = 'C:\Users\modx\Desktop\SQL-DataWarehouse\datasets\source_crm\sales_details.csv';
GO

-- LOAD ERP Cust AZ12
EXEC load_csv 
    @Schema = 'bronze',
    @Table = 'erp_cust_az12',
    @Path = 'C:\Users\modx\Desktop\SQL-DataWarehouse\datasets\source_erp\CUST_AZ12.csv';
GO

-- LOAD ERP Loc A101
EXEC load_csv 
    @Schema = 'bronze',
    @Table = 'erp_loc_a101',
    @Path = 'C:\Users\modx\Desktop\SQL-DataWarehouse\datasets\source_erp\LOC_A101.csv';
GO

-- LOAD ERP Px Cat G1V2
EXEC load_csv 
    @Schema = 'bronze',
    @Table = 'erp_px_cat_g1v2',
    @Path = 'C:\Users\modx\Desktop\SQL-DataWarehouse\datasets\source_erp\PX_CAT_G1V2.csv';
GO