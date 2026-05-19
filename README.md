
# 🛒 Retail Sales Data Cleaning & Analytics Project

End-to-end SQL data cleaning, validation, business analysis, and advanced analytics project built using SQL Server and SSMS.

![SQL](https://img.shields.io/badge/SQL-Database-blue)
![SQL Server](https://img.shields.io/badge/SQL%20Server-SSMS-red)
![Data Cleaning](https://img.shields.io/badge/Data-Cleaning-success)
![Analytics](https://img.shields.io/badge/Business-Analytics-orange)
![GitHub](https://img.shields.io/badge/GitHub-Portfolio-black)

## Project Overview

This project demonstrates an end-to-end SQL data analytics workflow using a synthetic retail sales dataset containing intentional data quality issues.

The project covers:

- Database setup
- Data cleaning
- Data validation
- Business analysis
- Advanced analytics

The objective was to transform messy transactional retail data into a clean, analysis-ready dataset and generate business insights using SQL Server.

---

## Dataset Overview

Dataset contains retail transaction data including:

- TransactionID
- Date
- CustomerID
- Product
- Category
- Quantity
- UnitPrice
- TotalAmount
- PaymentMethod
- Region

The source dataset intentionally included:

- Missing values
- Mixed date formats
- Duplicate records
- Outliers
- Inconsistent categorical values
- Invalid numeric values

---

## Tech Stack

- SQL Server
- SQL Server Management Studio (SSMS)
- SQL
- GitHub

---

## Design Decisions & Lessons Learned

### Numeric Datatype Handling

The initial schema design used:

- `Quantity` → `INT`
- `UnitPrice` → `FLOAT`
- `TotalAmount` → `VARCHAR(50)`

Because the source dataset intentionally contained datatype inconsistencies and text-formatted monetary values, `TotalAmount` required cleaning and conversion.

During the transformation phase, `TotalAmount` was standardized to `DECIMAL(10,2)` to support accurate financial calculations and improve numeric consistency.

---

## Project Structure

```

Retail-Sales-Analytics-Project/

│

├── README.md

│

├── data/

│   ├── raw/

│   └── cleaned/

│

├── sql/

│   ├── 01_database_setup.sql

│   ├── 02_data_cleaning.sql

│   ├── 03_data_validation.sql

│   ├── 04_business_analysis.sql

│   └── 05_advanced_analytics.sql

│

├── documentation/

├── dashboards/

└── images/

```

## Project Workflow

Raw Dataset
↓  
Database Setup  
↓  
Data Cleaning  
↓  
Data Validation  
↓  
Business Analysis  
↓  
Advanced Analytics  
↓  
Cleaned Dataset + Portfolio Output

---

## Data Cleaning Highlights

Cleaning tasks performed:

- Standardized customer IDs
- Region normalization
- Duplicate detection and removal
- Date validation and format profiling
- Numeric datatype standardization
- Outlier detection and management
- Business-rule corrections for quantity and total amount

---

## Data Validation Checks

Validation included:

- Null checks
- Duplicate verification
- Region verification
- Date validity checks
- Business-rule validation
- Outlier verification

---

## Business Questions Answered

Examples:

- Which region contributes the highest percentage of revenue?
- Find top spending customers.
- Calculate customer lifetime value.
- Identify repeat customers.
- Find products never purchased.
- Find categories exceeding overall average sales.

---

## Advanced Analytics

Implemented advanced SQL techniques including:

- Window functions
- Running totals
- Ranking functions
- Month-over-month growth analysis
- Regional benchmarking
- Nested subqueries
- CTEs

---

## Key Insights

Key findings from the analysis include:

- Revenue contribution varied significantly across regions.
- Top customers generated a disproportionately high share of total revenue.
- Repeat customers represented an important revenue segment.
- Several products generated substantially higher revenue than others.
- Transaction performance differed considerably from regional averages.
- Month-over-month sales trends revealed changes in revenue performance over time.

## Skills Demonstrated

This project demonstrates practical experience with:

- Data Cleaning
- Data Validation
- SQL Query Optimization
- Window Functions
- Aggregations
- Subqueries
- Common Table Expressions (CTEs)
- Data Quality Management
- Business Analytics
- Analytical SQL

---

## Future Improvements

Potential future enhancements for this project:

- Power BI dashboard integration
- Interactive KPI reporting
- Query optimization benchmarking
- Data pipeline automation
- Additional business intelligence visualizations

---
## Repository

GitHub Repository:

[Retail Sales Analytics Project](https://github.com/AbbySteve94/retail-sales-project)
=======
# retail-sales-project
SQL Server retail sales data cleaning, validation, and analytics project.

