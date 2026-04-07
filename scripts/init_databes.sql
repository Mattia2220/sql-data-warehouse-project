/*
  ==============================================================================
  Script Name: Initialize_DataWarehouse.sql
  Description: This script resets and initializes the 'DataWarehouse' database.
               It implements the Medallion Architecture by creating three distinct 
               schemas for data processing:
               - Bronze: Raw data ingestion
               - Silver: Cleaned and transformed data
               - Gold:   Business-ready aggregated data
  ==============================================================================
  WARNING: DESTRUCTIVE SCRIPT
  ----------------------------------------------------------------------------------
  This script will PERMANENTLY DELETE the 'DataWarehouse' database and all its 
  contained data if it already exists. Proceed with caution.
  
  Description: 
  This script initializes the Data Warehouse environment using the 
  Medallion Architecture (Bronze, Silver, and Gold schemas).
  ==================================================================================
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
  ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE DataWarehouse;
END
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO
--Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
