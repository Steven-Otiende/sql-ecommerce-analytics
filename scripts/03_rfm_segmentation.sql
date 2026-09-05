/*
===============================================================================
03_RFM_SEGMENTATION.SQL
E-Commerce Customer Analytics & Business Intelligence
Database: PostgreSQL

Purpose:
    Segment identified customers using RFM analysis.

RFM:
    R = Recency    -> Days since customer's most recent purchase
    F = Frequency  -> Number of fulfilled orders
    M = Monetary   -> Historical customer spend

Method:
    - Calculate customer-level RFM metrics.
    - Score customers into quintiles using NTILE(5).
    - Assign business-oriented customer segments.

Important:
    Monetary represents historical customer spend, not modeled
    Customer Lifetime Value (CLV).
===============================================================================
*/


-- ============================================================================
-- 1. CREATE RFM SEGMENTATION VIEW
-- ============================================================================

CREATE OR REPLACE VIEW v_customer_rfm_segments AS

WITH max_date AS (

    SELECT
        MAX(invoicedate)::DATE AS ref_date

    FROM clean_online_retail

),

customer_rfm AS (

    SELECT

        customerid,

        -- Recency:
        -- Number of days since the customer's most recent purchase.
        (m.ref_date - MAX(invoicedate)::DATE)
            AS recency_days,

        -- Frequency:
        -- Number of distinct fulfilled orders.
        COUNT(DISTINCT invoiceno)
            AS frequency,

        -- Monetary:
        -- Historical customer revenue.
        ROUND(
            SUM(quantity * unitprice),
            2
        ) AS monetary

    FROM clean_online_retail

    CROSS JOIN max_date m

    WHERE customerid IS NOT NULL
      AND invoiceno NOT LIKE 'C%'

    GROUP BY
        customerid,
        m.ref_date

),

rfm_scores AS (

    SELECT

        customerid,
        recency_days,
        frequency,
        monetary,

        /*
        Lower recency is better.
        Therefore recency is ordered DESC so that more recent customers
        receive higher scores.
        */
        NTILE(5) OVER (
            ORDER BY recency_days DESC
        ) AS r_score,

        /*
        Higher frequency is better.
        */
        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS f_score,

        /*
        Higher monetary value is better.
        */
        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS m_score

    FROM customer_rfm

)

SELECT

    customerid,
    recency_days,
    frequency,
    monetary,

    r_score,
    f_score,
    m_score,

    CASE

        WHEN r_score >= 4
         AND f_score >= 4
         AND m_score >= 4
            THEN 'Champions'

        WHEN r_score >= 3
         AND f_score >= 3
            THEN 'Loyal Customers'

        WHEN r_score >= 4
         AND f_score = 1
            THEN 'Recent New Customers'

        WHEN r_score <= 2
         AND f_score >= 3
            THEN 'At-Risk / Need Attention'

        WHEN r_score = 1
         AND f_score <= 2
            THEN 'Lost / Dormant'

        ELSE 'Potential Loyalist'

    END AS customer_segment

FROM rfm_scores;


-- ============================================================================
-- 2. CUSTOMER SEGMENT SUMMARY
-- ============================================================================

SELECT

    customer_segment,

    COUNT(customerid) AS total_customers,

    ROUND(
        AVG(recency_days),
        1
    ) AS avg_days_since_last_order,

    ROUND(
        AVG(frequency),
        1
    ) AS avg_orders_per_customer,

    ROUND(
        SUM(monetary),
        2
    ) AS segment_total_revenue,

    ROUND(
        AVG(monetary),
        2
    ) AS avg_revenue_per_customer

FROM v_customer_rfm_segments

GROUP BY customer_segment

ORDER BY segment_total_revenue DESC;


-- ============================================================================
-- 3. RFM SEGMENT CUSTOMER SHARE
-- ============================================================================

WITH segment_summary AS (

    SELECT

        customer_segment,

        COUNT(customerid) AS customers

    FROM v_customer_rfm_segments

    GROUP BY customer_segment

)

SELECT

    customer_segment,

    customers,

    ROUND(
        100.0 * customers
        / SUM(customers) OVER (),
        1
    ) AS customer_share_pct

FROM segment_summary

ORDER BY customers DESC;


-- ============================================================================
-- 4. RFM SEGMENT REVENUE SHARE
-- ============================================================================

WITH segment_summary AS (

    SELECT

        customer_segment,

        ROUND(
            SUM(monetary),
            2
        ) AS segment_revenue

    FROM v_customer_rfm_segments

    GROUP BY customer_segment

)

SELECT

    customer_segment,

    segment_revenue,

    ROUND(
        100.0 * segment_revenue
        / SUM(segment_revenue) OVER (),
        1
    ) AS revenue_share_pct

FROM segment_summary

ORDER BY segment_revenue DESC;


-- ============================================================================
-- 5. TOP CUSTOMERS BY HISTORICAL SPEND
-- ============================================================================

SELECT

    customerid,

    frequency AS total_orders,

    recency_days,

    monetary AS historical_spend,

    customer_segment

FROM v_customer_rfm_segments

ORDER BY monetary DESC

LIMIT 20;


-- ============================================================================
-- END OF SCRIPT
-- ============================================================================
