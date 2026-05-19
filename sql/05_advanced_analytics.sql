-- ==========================================
-- ADVANCED ANALYTICS
-- Retail Sales Analytics Project
-- ==========================================

USE RetailSalesProject;
GO

-- ==========================================
-- PRODUCT REVENUE RANKING
-- ==========================================

SELECT
    *,

    RANK() OVER
    (
        ORDER BY total_prd_revenue DESC
    ) AS product_rank

FROM
(
    SELECT
        product,

        SUM(totalamount)
            AS total_prd_revenue

    FROM retail_sales_clean

    GROUP BY product
)t;
GO

-- ==========================================
-- TOP TRANSACTION BY REGION
-- ==========================================

SELECT *
FROM
(
    SELECT
        *,

        RANK() OVER
        (
            PARTITION BY region
            ORDER BY totalamount DESC
        ) AS transaction_rank

    FROM retail_sales_clean
)t

WHERE transaction_rank = 1;
GO

-- ==========================================
-- RUNNING TOTAL OF SALES
-- ==========================================

SELECT
    transactionid,

    date,

    totalamount,

    SUM(totalamount)
        OVER
        (
            ORDER BY date,
                     transactionid
        ) AS running_total

FROM retail_sales_clean;
GO

-- ==========================================
-- TRANSACTION VS REGIONAL AVERAGE
-- ==========================================
WITH regional_sales AS
(
SELECT
	transactionid,
	region,
	totalamount,
	AVG(totalamount) OVER (PARTITION BY region) AS regional_average,
	totalamount - AVG(totalamount) OVER (PARTITION BY region) AS avg_difference
FROM retail_sales_clean
)
SELECT
	*,
	CASE 
		WHEN avg_difference < 0 THEN 'below average'
	 	WHEN avg_difference > 0 THEN 'above average'
		ELSE 'equal_average'
	END AS avg_flag
FROM regional_sales;
GO


-- ==========================================
-- MONTH OVER MONTH REVENUE GROWTH
-- ==========================================

WITH monthly_revenue AS
(
    SELECT

        DATETRUNC(month, date) AS month,

        SUM(totalamount)
            AS current_month_sales

    FROM retail_sales_clean

    GROUP BY DATETRUNC(month, date)
),

previous_month_data AS
(
    SELECT

        month,

        current_month_sales,

        LAG(current_month_sales)
        OVER(ORDER BY month)
            AS previous_month_sales

    FROM monthly_revenue
)

SELECT
    *,

    ROUND
    (
        100.00 *
        (
            current_month_sales
            -
            previous_month_sales
        )
        /
        NULLIF(previous_month_sales,0),

        2

    ) AS MoM_growth

FROM previous_month_data

ORDER BY month;
GO


-- ==========================================
-- CUSTOMER SPENDING RANKING
-- ==========================================
WITH customer_spend AS
(
	SELECT
		customerid,
		SUM(totalamount) AS total_customer_spend
	FROM retail_sales_clean
	GROUP BY customerid
)
SELECT 
	*
FROM (SELECT
	customerid,
	total_customer_spend,
	DENSE_RANK() OVER(ORDER BY total_customer_spend DESC) AS customer_spending_rank
FROM customer_spend
	)t
WHERE customer_spending_rank <= 3;
GO

