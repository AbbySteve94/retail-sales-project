-- ==========================================
-- DATABASE SETUP
-- Retail Sales Analytics Project
-- ==========================================

-- Create Database

CREATE DATABASE RetailSalesProject;
GO

USE RetailSalesProject;
GO
-- ==========================================
-- DROP TABLE IF IT ALREADY EXISTS
-- ==========================================

IF OBJECT_ID ('retail_sales_raw', 'u') is not null
	DROP TABLE retail_sales_raw

-- ==========================================
-- CREATE SOURCE TABLE
-- ==========================================

CREATE TABLE retail_sales_raw
(
    transactionid VARCHAR(50),
    date DATE,
    customerid VARCHAR(50),
    product VARCHAR(100),
    category VARCHAR(100),
    quantity INT,
    unitprice FLOAT,
    totalamount VARCHAR(50),
    paymentmethod VARCHAR(50),
    region VARCHAR(50)
);
GO

-- ==========================================
-- CREATE PRODUCT REFERENCE TABLE
-- ==========================================

IF OBJECT_ID('product_list','U') IS NOT NULL
    DROP TABLE product_list;
GO

CREATE TABLE product_list
(
    all_products VARCHAR(100)
);
GO

-- ==========================================
-- POPULATE PRODUCT REFERENCE TABLE
-- ==========================================

INSERT INTO product_list
VALUES
('backpack'),
('coffee maker'),
('desk chair'),
('headphones'),
('laptop'),
('notebook'),
('sneakers'),
('t-shirt'),
('blender'),
('charger'),
('fridge');
GO