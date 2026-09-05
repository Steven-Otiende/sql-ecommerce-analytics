/*
===============================================================================
05_MARKET_BASKET_ANALYSIS.SQL
E-Commerce Customer Analytics & Business Intelligence
Database: PostgreSQL

Purpose:
    Identify product pairs that frequently occur within the same order.

Method:
    1. Remove cancelled orders.
    2. Remove non-merchandise/service stock codes.
    3. Deduplicate invoice-product combinations.
    4. Exclude unusually large baskets.
    5. Focus on products appearing in at least 20 qualifying orders.
    6. Generate unique product pairs using a self-join.
    7. Rank pairs by order co-occurrence.

Important:
    This is product-pair/co-occurrence analysis.

    It is NOT full association-rule mining because support,
    confidence and lift are not calculated.

Performance:
    Temporary table + index creation: approximately 12 seconds.
    Final optimized basket query: approximately 17 seconds.
===============================================================================
*/


-- ============================================================================
-- 1. CREATE FILTERED ANALYTICAL BASKET TABLE
-- ============================================================================

DROP TABLE IF EXISTS temp_valid_items;

CREATE TEMP TABLE temp_valid_items AS

SELECT DISTINCT

    invoiceno,
    stockcode,
    description

FROM clean_online_retail

WHERE invoiceno NOT LIKE 'C%'

  /*
  Exclude service, postage, fees and other non-merchandise stock codes.
  */
  AND stockcode NOT IN (
      'POST',
      'DOT',
      'M',
      'D',
      'BANK CHARGES',
      'AMAZONFEE',
      'CRUK'
  )

  AND description IS NOT NULL;


-- ============================================================================
-- 2. INDEX TEMPORARY TABLE
-- ============================================================================
-- Supports the invoice/product join used later in the analysis.

CREATE INDEX idx_temp_inv_stock

ON temp_valid_items (
    invoiceno,
    stockcode
);


-- ============================================================================
-- 3. IDENTIFY VALID BASKETS
-- ============================================================================
-- Very large baskets are excluded as an analytical rule.
--
-- This reduces computational complexity and prevents unusually large
-- invoices from dominating pair-generation.

WITH item_counts AS (

    SELECT

        invoiceno

    FROM temp_valid_items

    GROUP BY invoiceno

    HAVING COUNT(*) <= 30

)

SELECT COUNT(*) AS qualifying_orders

FROM item_counts;


-- ============================================================================
-- 4. IDENTIFY FREQUENT PRODUCTS
-- ============================================================================
-- Products must occur in at least 20 qualifying orders.
--
-- This threshold reduces sparse/noisy product pairs and improves
-- computational efficiency.

WITH item_counts AS (

    SELECT

        invoiceno

    FROM temp_valid_items

    GROUP BY invoiceno

    HAVING COUNT(*) <= 30

),

frequent_products AS (

    SELECT

        stockcode

    FROM temp_valid_items

    WHERE invoiceno IN (
        SELECT invoiceno
        FROM item_counts
    )

    GROUP BY stockcode

    HAVING COUNT(DISTINCT invoiceno) >= 20

)

SELECT

    COUNT(*) AS frequent_products

FROM frequent_products;


-- ============================================================================
-- 5. PRODUCT-PAIR CO-OCCURRENCE ANALYSIS
-- ============================================================================

WITH item_counts AS (

    SELECT

        invoiceno

    FROM temp_valid_items

    GROUP BY invoiceno

    HAVING COUNT(*) <= 30

),

frequent_products AS (

    SELECT

        stockcode

    FROM temp_valid_items

    WHERE invoiceno IN (
        SELECT invoiceno
        FROM item_counts
    )

    GROUP BY stockcode

    HAVING COUNT(DISTINCT invoiceno) >= 20

),

filtered_basket AS (

    SELECT

        invoiceno,
        stockcode

    FROM temp_valid_items

    WHERE invoiceno IN (
        SELECT invoiceno
        FROM item_counts
    )

      AND stockcode IN (
        SELECT stockcode
        FROM frequent_products
      )

),

pair_counts AS (

    SELECT

        a.stockcode AS code_a,

        b.stockcode AS code_b,

        COUNT(*) AS times_bought_together

    FROM filtered_basket a

    INNER JOIN filtered_basket b

        ON a.invoiceno = b.invoiceno

       /*
       Lexicographical ordering ensures that:
           A + B
       and
           B + A
       are treated as the same pair.
       */
       AND a.stockcode < b.stockcode

    GROUP BY

        a.stockcode,
        b.stockcode

    ORDER BY times_bought_together DESC

    LIMIT 10

),

-- ============================================================================
-- 6. RESOLVE PRODUCT NAMES
-- ============================================================================

product_names AS (

    SELECT DISTINCT ON (stockcode)

        stockcode,
        description

    FROM temp_valid_items

    ORDER BY
        stockcode

)

-- ============================================================================
-- 7. FINAL TOP 10 PRODUCT PAIRS
-- ============================================================================

SELECT

    p1.description AS product_a,

    p2.description AS product_b,

    pc.times_bought_together

FROM pair_counts pc

INNER JOIN product_names p1
    ON pc.code_a = p1.stockcode

INNER JOIN product_names p2
    ON pc.code_b = p2.stockcode

ORDER BY times_bought_together DESC;


-- ============================================================================
-- EXPECTED TOP RESULT
-- ============================================================================
--
-- JUMBO BAG PINK POLKADOT
-- +
-- JUMBO BAG RED RETROSPOT
--
-- Co-occurrence: 330 qualifying orders
--
-- Other strong relationships include:
-- - Regency Teacup variants
-- - Bakelike Alarm Clock variants
-- - Jumbo Bag variants
-- - Wooden picture frames
-- - Regency Cake Stand + Regency Teacup
--
-- ============================================================================
-- BUSINESS APPLICATIONS
-- ============================================================================
--
-- Results can support:
--
-- 1. Product bundling
-- 2. Cross-selling
-- 3. Cart recommendations
-- 4. Multi-buy promotions
-- 5. "Complete the set" recommendations
-- 6. Store merchandising
-- 7. Inventory/picking optimization
--
-- ============================================================================
-- END OF SCRIPT
-- ============================================================================
