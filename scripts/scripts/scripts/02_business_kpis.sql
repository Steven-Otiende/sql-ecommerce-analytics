/*
===============================================================================
02_BUSINESS_KPIS.SQL
E-Commerce Customer Analytics & Business Intelligence
Database: PostgreSQL

Purpose:
    Calculate core business KPIs and identify sales and product performance
    patterns.

Key outputs:
    - Total fulfilled orders
    - Identified customers
    - Revenue
    - Monthly revenue
    - Monthly order trends
    - Top products by revenue
===============================================================================
*/


-- ============================================================================
-- 1. CORE BUSINESS KPIs
-- ============================================================================

SELECT
    COUNT(DISTINCT invoiceno) AS total_orders,

    COUNT(DISTINCT customerid) AS total_customers,

    ROUND(
        SUM(quantity * unitprice),
        2
    ) AS total_revenue

FROM clean_online_retail

WHERE invoiceno NOT LIKE 'C%';


-- ============================================================================
-- 2. MONTHLY SALES PERFORMANCE
-- ============================================================================

SELECT
    DATE_TRUNC('month', invoicedate)::DATE AS sales_month,

    COUNT(DISTINCT invoiceno) AS total_orders,

    COUNT(DISTINCT customerid) AS active_customers,

    ROUND(
        SUM(quantity * unitprice),
        2
    ) AS monthly_revenue

FROM clean_online_retail

WHERE invoiceno NOT LIKE 'C%'

GROUP BY DATE_TRUNC('month', invoicedate)

ORDER BY sales_month;


-- ============================================================================
-- 3. MONTHLY REVENUE RANKING
-- ============================================================================
-- Identifies the strongest revenue-generating months.

WITH monthly_sales AS (

    SELECT
        DATE_TRUNC('month', invoicedate)::DATE AS sales_month,

        COUNT(DISTINCT invoiceno) AS total_orders,

        ROUND(
            SUM(quantity * unitprice),
            2
        ) AS monthly_revenue

    FROM clean_online_retail

    WHERE invoiceno NOT LIKE 'C%'

    GROUP BY DATE_TRUNC('month', invoicedate)
)

SELECT
    sales_month,
    total_orders,
    monthly_revenue,

    RANK() OVER (
        ORDER BY monthly_revenue DESC
    ) AS revenue_rank

FROM monthly_sales

ORDER BY revenue_rank;


-- ============================================================================
-- 4. TOP PRODUCTS BY REVENUE
-- ============================================================================
-- DOTCOM POSTAGE is retained here because this analysis evaluates
-- transaction-level revenue contribution.
--
-- Service/postage items are excluded later from product-pair analysis.

SELECT
    stockcode,

    description,

    ROUND(
        SUM(quantity * unitprice),
        2
    ) AS product_revenue,

    SUM(quantity) AS units_sold,

    COUNT(DISTINCT invoiceno) AS orders

FROM clean_online_retail

WHERE invoiceno NOT LIKE 'C%'
  AND description IS NOT NULL

GROUP BY
    stockcode,
    description

ORDER BY product_revenue DESC

LIMIT 10;


-- ============================================================================
-- 5. REVENUE BY COUNTRY
-- ============================================================================

SELECT
    country,

    COUNT(DISTINCT invoiceno) AS total_orders,

    COUNT(DISTINCT customerid) AS customers,

    ROUND(
        SUM(quantity * unitprice),
        2
    ) AS revenue

FROM clean_online_retail

WHERE invoiceno NOT LIKE 'C%'

GROUP BY country

ORDER BY revenue DESC;


-- ============================================================================
-- END OF SCRIPT
-- ============================================================================
