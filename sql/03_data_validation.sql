
-- ==========================================
-- DATA VALIDATION
-- Retail Sales Analytics Project
-- ==========================================

USE RetailSalesProject;
GO

-- ==========================================
-- CHECK FOR REMAINING NULL VALUES
-- ==========================================

SELECT *
FROM retail_sales_clean
WHERE quantity IS NULL
   OR unitprice IS NULL
   OR totalamount IS NULL;
GO

-- ==========================================
-- VALIDATE CALCULATED SALES LOGIC
-- ==========================================

SELECT *
FROM retail_sales_clean

WHERE totalamount <> quantity * unitprice
   OR quantity <= 0
   OR unitprice <= 0
   OR totalamount <= 0;
GO

-- ==========================================
-- VERIFY DUPLICATES REMOVED
-- ==========================================

SELECT
    transactionid,
    COUNT(*) AS duplicate_count

FROM retail_sales_clean

GROUP BY transactionid

HAVING COUNT(*) > 1;
GO

-- ==========================================
-- VERIFY REGION STANDARDIZATION
-- ==========================================

SELECT DISTINCT region
FROM retail_sales_clean;
GO

-- ==========================================
-- VERIFY OUTLIER REMOVAL
-- ==========================================

SELECT *
FROM retail_sales_clean
WHERE unitprice > 10000;
GO

-- ==========================================
-- VERIFY CUSTOMER ID CLEANING
-- ==========================================

SELECT *
FROM retail_sales_clean
WHERE customerid IS NULL
   OR customerid = '';
GO


-- Verify standardized placeholder values

SELECT
    customerid,
    COUNT(*) AS record_count
FROM retail_sales_clean
GROUP BY customerid
HAVING customerid = 'unknown';
GO

-- ==========================================
-- VERIFY DATE VALIDITY
-- ==========================================

SELECT *
FROM retail_sales_clean
WHERE TRY_CONVERT(DATE, date) IS NULL;
GO

-- ==========================================
-- VERIFY DATASET RECORD COUNTS
-- ==========================================

SELECT
    COUNT(*) AS clean_record_count
FROM retail_sales_clean;
GO