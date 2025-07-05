/*
====================================================================================
Procedure: load_csv

Description:
    Dynamically truncates and loads data from a CSV file into a specified table 
    using BULK INSERT. Supports passing schema name, table name, and file path 
    as parameters. Also prints execution time for performance tracking.

Parameters:
    @Schema NVARCHAR(50) - Name of the schema (e.g., 'bronze')
    @Table  NVARCHAR(50) - Name of the target table (e.g., 'crm_cust_info')
    @Path   NVARCHAR(MAX) - Full file path to the CSV file (e.g., 'C:\data\file.csv')

Behavior:
    1. Truncates the target table.
    2. Loads data from the CSV using BULK INSERT with comma delimiter.
    3. Skips header (assumes FIRSTROW = 2).
    4. Prints status and duration.

Usage Example:
    EXEC load_csv 
        @Schema = 'bronze', 
        @Table = 'crm_cust_info', 
        @Path = 'C:\data\customers.csv';
====================================================================================
*/

USE DataWarehouse;
GO

-- Load Csv Procedure

CREATE OR ALTER PROCEDURE load_csv
    @Schema NVARCHAR(50),
    @Table NVARCHAR(50),
    @Path NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Trunc NVARCHAR(MAX);
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @Start_Time DATETIME;
    DECLARE @End_Time DATETIME;

    SET @Start_Time = GETDATE();

    PRINT '>> TRUNCATING TABLE: ' + QUOTENAME(@Schema) + '.' + QUOTENAME(@Table);

    SET @Trunc = 'TRUNCATE TABLE ' + QUOTENAME(@Schema) + '.' + QUOTENAME(@Table);
    EXEC sp_executesql @Trunc;

    PRINT '>> INSERTING INTO TABLE: ' + QUOTENAME(@Schema) + '.' + QUOTENAME(@Table);

    SET @SQL = '
        BULK INSERT ' + QUOTENAME(@Schema) + '.' + QUOTENAME(@Table) + '
        FROM ''' + @Path + '''
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = '','',
            ROWTERMINATOR = ''\n'',
            TABLOCK
        );';

    EXEC sp_executesql @SQL;

    SET @End_Time = GETDATE();
    PRINT '>> LOAD COMPLETED in ' + CAST(DATEDIFF(SECOND, @Start_Time, @End_Time) AS NVARCHAR) + ' seconds.';
END;
GO
