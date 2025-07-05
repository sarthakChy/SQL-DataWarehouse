/*
    Description:
        This script sets up the foundational database environment for a Data Warehouse system. 
        It performs the following operations:
            1. Drops the existing 'DataWarehouse' database if it exists.
            2. Creates a fresh 'DataWarehouse' database.
            3. Adds three schemas: 'bronze', 'silver', and 'gold' for data layering.
               - bronze: raw/staging data
               - silver: cleaned/transformed data
               - gold: curated, business-ready data
    Usage:
        Run this script in SQL Server Management Studio (SSMS) or any SQL interface connected to the server.

    WARNING : 
        Running this script will delete your entire database "DataWarehouse" and you will.
        All the data in the database will be permanently deleted.
        Ensure you have proper backups.
*/

USE master;
GO

-- Drop and recreate database 'DataWarehouse' if already exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create Database 'DataWarehouse'
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create schemas for data layers
GO
CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

CREATE SCHEMA bronze;
