/*
===============================================================================
04_COHORT_RETENTION.SQL
E-Commerce Customer Analytics & Business Intelligence
Database: PostgreSQL

Purpose:
    Measure customer retention by grouping customers according to their
    first purchase month and tracking subsequent monthly activity.

Retention metric:
    Number of customers who remain active in a given month after joining.

Important:
    This measures customer activity retention, not revenue retention.

    M12 is only observable for cohorts whose 12-month observation window
    falls within the dataset period.
===============================================================================
*/


-- ============================================================================
-- 1. BUILD CUSTOMER COHORTS
-- ============================================================================

WITH customer_cohorts AS (

    SELECT

        customerid,

        DATE_TRUNC(
            'month',
            MIN(invoicedate)
        ) AS cohort_month

    FROM clean_online_retail

    WHERE customerid IS NOT NULL
      AND invoiceno NOT LIKE 'C%'

    GROUP BY customerid

),

-- ============================================================================
-- 2. IDENTIFY MONTHLY CUSTOMER ACTIVITY
-- ============================================================================

customer_activities AS (

    SELECT DISTINCT

        r.customerid,

        c.cohort_month,

        DATE_TRUNC(
            'month',
            r.invoicedate
        ) AS activity_month,

        /*
        Calculate months elapsed since first purchase.
        */
        (
            EXTRACT(
                YEAR
                FROM DATE_TRUNC('month', r.invoicedate)
            )
            -
            EXTRACT(
                YEAR
                FROM c.cohort_month
            )
        ) * 12

        +

        (
            EXTRACT(
                MONTH
                FROM DATE_TRUNC('month', r.invoicedate)
            )
            -
            EXTRACT(
                MONTH
                FROM c.cohort_month
            )
        ) AS month_number

    FROM clean_online_retail r

    INNER JOIN customer_cohorts c
        ON r.customerid = c.customerid

    WHERE r.invoiceno NOT LIKE 'C%'

)

-- ============================================================================
-- 3. COHORT RETENTION TABLE
-- ============================================================================

SELECT

    cohort_month::DATE,

    COUNT(
        DISTINCT CASE
            WHEN month_number = 0
            THEN customerid
        END
    ) AS cohort_size,

    COUNT(
        DISTINCT CASE
            WHEN month_number = 1
            THEN customerid
        END
    ) AS m1_active,

    COUNT(
        DISTINCT CASE
            WHEN month_number = 2
            THEN customerid
        END
    ) AS m2_active,

    COUNT(
        DISTINCT CASE
            WHEN month_number = 3
            THEN customerid
        END
    ) AS m3_active,

    COUNT(
        DISTINCT CASE
            WHEN month_number = 6
            THEN customerid
        END
    ) AS m6_active,

    COUNT(
        DISTINCT CASE
            WHEN month_number = 12
            THEN customerid
        END
    ) AS m12_active

FROM customer_activities

GROUP BY cohort_month

ORDER BY cohort_month;


-- ============================================================================
-- 4. COHORT RETENTION PERCENTAGES
-- ============================================================================

WITH customer_cohorts AS (

    SELECT

        customerid,

        DATE_TRUNC(
            'month',
            MIN(invoicedate)
        ) AS cohort_month

    FROM clean_online_retail

    WHERE customerid IS NOT NULL
      AND invoiceno NOT LIKE 'C%'

    GROUP BY customerid

),

customer_activities AS (

    SELECT DISTINCT

        r.customerid,

        c.cohort_month,

        (
            EXTRACT(
                YEAR
                FROM DATE_TRUNC('month', r.invoicedate)
            )
            -
            EXTRACT(
                YEAR
                FROM c.cohort_month
            )
        ) * 12

        +

        (
            EXTRACT(
                MONTH
                FROM DATE_TRUNC('month', r.invoicedate)
            )
            -
            EXTRACT(
                MONTH
                FROM c.cohort_month
            )
        ) AS month_number

    FROM clean_online_retail r

    JOIN customer_cohorts c
        ON r.customerid = c.customerid

    WHERE r.invoiceno NOT LIKE 'C%'

),

cohort_summary AS (

    SELECT

        cohort_month::DATE AS cohort_month,

        COUNT(
            DISTINCT CASE
                WHEN month_number = 0
                THEN customerid
            END
        ) AS cohort_size,

        COUNT(
            DISTINCT CASE
                WHEN month_number = 1
                THEN customerid
            END
        ) AS m1_active,

        COUNT(
            DISTINCT CASE
                WHEN month_number = 3
                THEN customerid
            END
        ) AS m3_active,

        COUNT(
            DISTINCT CASE
                WHEN month_number = 6
                THEN customerid
            END
        ) AS m6_active,

        COUNT(
            DISTINCT CASE
                WHEN month_number = 12
                THEN customerid
            END
        ) AS m12_active

    FROM customer_activities

    GROUP BY cohort_month

)

SELECT

    cohort_month,

    cohort_size,

    m1_active,

    ROUND(
        100.0 * m1_active / NULLIF(cohort_size, 0),
        1
    ) AS m1_retention_pct,

    m3_active,

    ROUND(
        100.0 * m3_active / NULLIF(cohort_size, 0),
        1
    ) AS m3_retention_pct,

    m6_active,

    ROUND(
        100.0 * m6_active / NULLIF(cohort_size, 0),
        1
    ) AS m6_retention_pct,

    m12_active,

    CASE
        WHEN m12_active > 0 THEN
            ROUND(
                100.0 * m12_active
                / NULLIF(cohort_size, 0),
                1
            )
        ELSE NULL
    END AS m12_retention_pct

FROM cohort_summary

ORDER BY cohort_month;


-- ============================================================================
-- END OF SCRIPT
-- ============================================================================
