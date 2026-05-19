-- ==========================================
-- DATA CLEANING
-- Retail Sales Analytics Project
-- ==========================================

USE RetailSalesProject;
GO

-- ==========================================
-- CREATE CLEAN TABLE
-- ==========================================

IF OBJECT_ID('retail_sales_clean', 'U') IS NOT NULL
    DROP TABLE retail_sales_clean;
GO

SELECT *
INTO retail_sales_clean
FROM retail_sales_raw;
GO

-- NOTE:
-- Date inconsistencies were standardized during
-- the import/preprocessing stage.

-- SQL validation checks below were used to verify:
-- 1. successful conversion
-- 2. remaining invalid records
-- 3. detected date patterns

-- ==========================================
-- DATE VALIDATION
-- Detect invalid dates
-- ==========================================

SELECT *
FROM retail_sales_clean
WHERE TRY_CONVERT(DATE, date) IS NULL;
GO


-- ==========================================
-- DATE FORMAT PROFILING
-- Identify mixed date formats
-- ==========================================

SELECT
    date,

    CASE
        WHEN date LIKE '[0-9][0-9]/%'
            THEN 'MM/DD/YYYY'

        WHEN date LIKE '[0-9][0-9][0-9][0-9]-%'
            THEN 'YYYY-MM-DD'

        ELSE 'Unknown'

    END AS format_type

FROM retail_sales_clean;
GO

-- ==========================================
-- HANDLE MISSING CUSTOMER IDs
-- ==========================================

UPDATE retail_sales_clean
SET customerid = 'unknown'
WHERE customerid IS NULL
   OR customerid = '';
GO

-- Verify update

SELECT *
FROM retail_sales_clean
WHERE customerid = 'unknown';
GO

-- NOTE:
-- Missing customer IDs were standardized to 'unknown'
--to improve readability and simplify analysis queries.

-- ==========================================
-- REGION STANDARDIZATION
-- ==========================================

UPDATE retail_sales_clean
SET region =
CASE
    WHEN region LIKE 'E%' THEN 'EAST'
    WHEN region LIKE 'N%' THEN 'NORTH'
    WHEN region LIKE 'S%' THEN 'SOUTH'
    WHEN region LIKE 'W%' THEN 'WEST'
    ELSE region
END;
GO

-- Verify standardization

SELECT DISTINCT region
FROM retail_sales_clean;
GO

-- ==========================================
-- NUMERIC DATATYPE REFINEMENT
-- ==========================================

-- NOTE:
-- Initial schema design used:
-- quantity      → INT
-- unitprice     → FLOAT
-- totalamount   → VARCHAR(50)
--
-- Because the source dataset contained text-formatted
-- monetary values and datatype inconsistencies,
-- totalamount was cleaned and converted into
-- DECIMAL(10,2) during the transformation stage to improve precision and align with
-- financial data best practices.

UPDATE retail_sales_clean
SET totalamount =
    TRY_CONVERT
    (
        DECIMAL(10,2),
        REPLACE(totalamount,'$','')
    );
GO

ALTER TABLE retail_sales_clean
ALTER COLUMN totalamount DECIMAL(10,2);
GO

-- ==========================================
-- NUMERIC DATA VALIDATION & CORRECTION LOGIC
-- ==========================================

SELECT
    quantity AS oldqty,

    totalamount AS oldamount,

    unitprice,

    CASE
        WHEN quantity IS NULL
          OR quantity <= 0
          OR quantity <> ABS(totalamount / unitprice)

        THEN ABS(totalamount / unitprice)

        ELSE quantity

    END AS corrected_quantity,


    CASE
        WHEN totalamount <> ABS(quantity * unitprice)
          OR totalamount <= 0
          OR totalamount IS NULL

        THEN ABS(quantity * unitprice)

        ELSE totalamount

    END AS corrected_totalamount

FROM retail_sales_clean

WHERE quantity IS NULL
   OR unitprice IS NULL
   OR totalamount IS NULL
   OR totalamount <> quantity * unitprice
   OR quantity <= 0
   OR unitprice <= 0
   OR totalamount <= 0

ORDER BY quantity,
         unitprice,
         totalamount;
GO

-- ==========================================
-- OUTLIER DETECTION
-- ==========================================

-- Method 1: Z-Score Detection

SELECT *
FROM
(
    SELECT
        product,
        unitprice,

        (unitprice - AVG(unitprice) OVER())
        / STDEV(unitprice) OVER() AS z_score

    FROM retail_sales_clean
)t

WHERE z_score > 3
   OR z_score < -3;
GO


-- Method 2: Threshold Relative to Average

SELECT
    product,
    unitprice
FROM retail_sales_clean

WHERE unitprice >
(
    SELECT AVG(unitprice) * 5
    FROM retail_sales_clean
);
GO


-- Method 3: Standard Deviation Threshold

SELECT *
FROM retail_sales_clean

WHERE unitprice >
(
    SELECT
        AVG(unitprice)
        + 3 * STDEV(unitprice)

    FROM retail_sales_clean
);
GO

-- ==========================================
-- OUTLIER MANAGEMENT
-- Move extreme values into audit table
-- ==========================================

IF OBJECT_ID('retail_sales_outliers','U') IS NOT NULL
    DROP TABLE retail_sales_outliers;
GO

SELECT *
INTO retail_sales_outliers
FROM retail_sales_clean
WHERE unitprice > 10000;
GO

-- Remove extreme outliers from clean table

DELETE
FROM retail_sales_clean
WHERE unitprice > 10000;
GO

-- ==========================================
-- DUPLICATE DETECTION
-- ==========================================

SELECT
    transactionid,
    COUNT(*) AS duplicate_count
FROM retail_sales_clean
GROUP BY transactionid
HAVING COUNT(*) > 1
    OR transactionid IS NULL;
GO


-- ==========================================
-- DUPLICATE REMOVAL
-- Retain latest transaction record
-- ==========================================

WITH duplicate AS
(
    SELECT
        *,

        ROW_NUMBER() OVER
        (
            PARTITION BY transactionid
            ORDER BY date DESC
        ) AS duplicate_flag

    FROM retail_sales_clean
)

DELETE
FROM duplicate
WHERE duplicate_flag > 1;
GO