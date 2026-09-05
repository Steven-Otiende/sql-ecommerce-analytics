/*
===============================================================================
01_DATA_CLEANING.SQL
E-Commerce Customer Analytics & Business Intelligence
Database: PostgreSQL

Purpose:
    1. Create a raw staging table for the UCI Online Retail dataset.
    2. Import raw CSV data safely as text.
    3. Transform raw fields into analytical data types.
    4. Create indexes for downstream analysis.
    5. Perform basic data validation.

Dataset:
    UCI Online Retail Dataset
    541,909 transaction records
===============================================================================
*/


-- ============================================================================
-- 1. RAW STAGING TABLE
-- ============================================================================
-- Raw fields are initially stored as TEXT to prevent import failures caused
-- by inconsistent formatting and special characters such as the £ symbol.

DROP TABLE IF EXISTS raw_online_retail;

CREATE TABLE raw_online_retail (
    invoiceno   TEXT,
    stockcode   TEXT,
    description TEXT,
    quantity    TEXT,
    invoicedate TEXT,
    unitprice   TEXT,
    customerid  TEXT,
    country     TEXT
);


-- ============================================================================
-- 2. IMPORT RAW CSV
-- ============================================================================
-- Execute the following command from a PostgreSQL environment with access
-- to the CSV file.
--
-- The dataset contains the £ currency symbol, so Windows-1252 encoding
-- is used during import.
--
-- Example:
--
-- COPY raw_online_retail
-- FROM 'C:/path/to/Online Retail.csv'
-- WITH (
--     FORMAT CSV,
--     HEADER TRUE,
--     DELIMITER ',',
--     QUOTE '"',
--     ENCODING 'WIN1252'
-- );


-- ============================================================================
-- 3. CREATE CLEAN ANALYTICAL TABLE
-- ============================================================================

DROP TABLE IF EXISTS clean_online_retail;

CREATE TABLE clean_online_retail AS
SELECT
    TRIM(invoiceno) AS invoiceno,
    TRIM(stockcode) AS stockcode,
    NULLIF(TRIM(description), '') AS description,

    NULLIF(TRIM(quantity), '')::INT AS quantity,

    TO_TIMESTAMP(
        TRIM(invoicedate),
        'DD-MM-YY HH24:MI'
    ) AS invoicedate,

    NULLIF(TRIM(unitprice), '')::NUMERIC(10,2) AS unitprice,

    NULLIF(TRIM(customerid), '')::NUMERIC::INT AS customerid,

    TRIM(country) AS country

FROM raw_online_retail;


-- ============================================================================
-- 4. CREATE INDEXES
-- ============================================================================
-- These indexes support the downstream KPI, customer and basket analyses.

CREATE INDEX IF NOT EXISTS idx_clean_invoiceno
    ON clean_online_retail(invoiceno);

CREATE INDEX IF NOT EXISTS idx_clean_stockcode
    ON clean_online_retail(stockcode);

CREATE INDEX IF NOT EXISTS idx_clean_customerid
    ON clean_online_retail(customerid);


-- ============================================================================
-- 5. BASIC DATA VALIDATION
-- ============================================================================

-- Record count
SELECT COUNT(*) AS total_rows
FROM clean_online_retail;


-- Inspect sample records
SELECT *
FROM clean_online_retail
LIMIT 10;


-- Check missing customer identifiers
SELECT
    COUNT(*) AS total_rows,
    COUNT(customerid) AS rows_with_customer_id,
    COUNT(*) - COUNT(customerid) AS rows_missing_customer_id
FROM clean_online_retail;


-- Check date range
SELECT
    MIN(invoicedate) AS earliest_transaction,
    MAX(invoicedate) AS latest_transaction
FROM clean_online_retail;


-- Check for negative quantities
SELECT COUNT(*) AS negative_quantity_rows
FROM clean_online_retail
WHERE quantity < 0;


-- Check for zero or negative prices
SELECT COUNT(*) AS non_positive_price_rows
FROM clean_online_retail
WHERE unitprice <= 0;


-- ============================================================================
-- END OF SCRIPT
-- ============================================================================




