# E-Commerce Customer Analytics & Business Intelligence — PostgreSQL

### Advanced SQL Data Analytics & Business Intelligence Portfolio Project

**PostgreSQL | SQL | Customer Analytics | RFM Segmentation | Cohort Analysis | Market Basket Analysis**

---

## 📌 Project Overview

This project demonstrates an end-to-end **SQL analytics workflow using PostgreSQL** on the UCI Online Retail dataset containing **541,909 transaction records** covering December 2010 to December 2011.

The analysis transforms raw transactional data into actionable business insights across:

* Sales and revenue performance
* Customer purchasing behavior
* RFM customer segmentation
* Cohort-based customer retention
* Product-pair purchasing patterns
* SQL query optimization and performance improvement

The project was designed to demonstrate not only **SQL and PostgreSQL proficiency**, but also the ability to translate business questions into analytical solutions and actionable recommendations.

---

## 📊 Key Business Results

| KPI / Finding                             |                    Result |
| ----------------------------------------- | ------------------------: |
| Raw transaction records                   |               **541,909** |
| Fulfilled orders                          |                **22,064** |
| Identified customers                      |                 **4,339** |
| Calculated transaction revenue            |        **£10,644,560.42** |
| Peak revenue month                        |         **November 2011** |
| Peak monthly revenue                      |         **£1,509,496.33** |
| RFM Champions                             |         **955 customers** |
| Champions' share of RFM-segmented revenue |                 **64.5%** |
| At-Risk / Need Attention customers        |                   **655** |
| December 2010 M12 customer retention      |                 **26.6%** |
| Top product-pair co-occurrence            | **330 qualifying orders** |

> **Key insight:** A relatively small group of high-value customers generated a disproportionately large share of historical customer revenue, highlighting the importance of customer retention and targeted loyalty strategies.

---

## 🎯 Business Questions

The project addresses five major business questions:

1. **How is the business performing in terms of orders and revenue?**
2. **Which products generate the most revenue?**
3. **Who are the most valuable, loyal, and at-risk customers?**
4. **How well are customers retained after their first purchase?**
5. **Which products are frequently purchased together?**

---

## 🔄 Analytics Workflow

```text
Raw UCI Dataset
      ↓
PostgreSQL Raw Staging
      ↓
Data Cleaning & Type Conversion
      ↓
Data Validation & Indexing
      ↓
Business KPI Analysis
      ↓
Customer RFM Segmentation
      ↓
Cohort Retention Analysis
      ↓
Product-Pair / Market Basket Analysis
      ↓
Business Insights & Recommendations
```

---

## 🛠️ Technical Skills Demonstrated

### SQL & PostgreSQL

* Common Table Expressions (CTEs)
* Window functions
* `NTILE()` customer scoring
* Aggregations
* Conditional aggregation
* `CASE` expressions
* Date/time transformations
* Self-joins
* Temporary tables
* Views
* Data type conversion
* NULL handling
* Composite indexing
* Query performance optimization

### Data Analytics

* KPI development
* Revenue analysis
* Customer segmentation
* RFM analysis
* Cohort analysis
* Retention analysis
* Product affinity analysis
* Data quality validation
* Business interpretation
* Actionable recommendations

---

# 📈 Key Analyses

## 1. Sales Performance & Business KPIs

The analysis identified:

* **22,064 fulfilled orders**
* **4,339 customers with identified Customer IDs**
* **£10.64M in calculated transaction revenue**
* **November 2011** as the strongest revenue month
* Peak monthly revenue of **£1.51M**

Monthly sales analysis also revealed substantial growth in order activity toward the end of 2011.

**Business implication:** The late-year sales acceleration suggests opportunities for seasonal inventory planning, campaign optimization, and operational capacity planning.

**SQL:** [`02_business_kpis.sql`](scripts/02_business_kpis.sql)

---

## 2. Customer RFM Segmentation

Customers were segmented using three dimensions:

* **Recency** — number of days since the customer's most recent purchase
* **Frequency** — number of fulfilled orders
* **Monetary** — historical customer spend

Customers were scored into quintiles using PostgreSQL's `NTILE(5)` window function.

### Customer Segments

| Segment                  | Customers | Avg. Recency | Avg. Orders | Historical Revenue |
| ------------------------ | --------: | -----------: | ----------: | -----------------: |
| Champions                |       955 |    11.4 days |        11.1 |         £5,746,639 |
| Loyal Customers          |       993 |    33.1 days |         3.8 |         £1,592,044 |
| At-Risk / Need Attention |       655 |   146.7 days |         3.4 |           £896,952 |
| Potential Loyalist       |       910 |    73.2 days |         1.2 |           £338,496 |
| Lost / Dormant           |       684 |   275.0 days |         1.1 |           £286,597 |
| Recent New Customers     |       142 |    17.7 days |         1.0 |            £50,681 |

**Key insight:** Champions represent approximately **22% of RFM-segmented customers** but account for **64.5% of RFM-segmented historical revenue**.

**Business implication:** High-value customer retention should be a major priority. At-Risk and Lost/Dormant customers can be targeted through structured reactivation campaigns, while Potential Loyalists can be encouraged toward repeat purchasing.

**SQL:** [`03_rfm_segmentation.sql`](scripts/03_rfm_segmentation.sql)

**Visualization:**

![RFM Customer Segment Chart](assets/rfm_customer_segment_chart.png)

---

## 3. Cohort Retention Analysis

Customers were grouped according to the month of their first purchase and tracked across subsequent months.

The December 2010 cohort contained **885 customers**, of whom **235 remained active in month 12**, representing **26.6% customer retention**.

> **Important:** This analysis measures active customer retention, not revenue retention.

Later cohorts do not have observable M12 retention where the required 12-month observation window extends beyond the end of the dataset in December 2011.

**Business implication:** Cohort analysis helps identify differences in customer retention over time and provides a foundation for improving customer onboarding, repeat-purchase campaigns, and customer lifecycle strategies.

**SQL:** [`04_cohort_retention.sql`](scripts/04_cohort_retention.sql)

**Visualization:**

![Cohort Retention Chart](assets/cohort_retention_chart.png)

---

## 4. Product-Pair / Market Basket Analysis

Product co-occurrence analysis was used to identify products frequently purchased within the same qualifying orders.

The analysis:

1. Excluded cancelled transactions.
2. Removed service and postage-related stock codes.
3. Deduplicated invoice-product combinations.
4. Limited unusually large baskets.
5. Identified frequently occurring products.
6. Used a self-join to identify product pairs purchased together.
7. Ranked product pairs by qualifying order count.

### Top Product Pair

**JUMBO BAG PINK POLKADOT + JUMBO BAG RED RETROSPOT**

**330 qualifying orders**

Other strong product relationships included:

* Regency Teacup variants
* Bakelike Alarm Clock variants
* Jumbo Bag variants
* Wooden picture frames
* Regency Cake Stand + Regency Teacup

**Key insight:** Customers frequently purchase complementary products as well as multiple variants within the same product family.

**Business implication:** These relationships can support:

* Cross-selling
* Product bundling
* "Complete the set" recommendations
* Multi-buy promotions
* Checkout upselling
* Store merchandising optimization

> **Analytical note:** This analysis measures product **co-occurrence**. It is not a complete association-rule mining implementation because support, confidence, and lift were not calculated.

**SQL:** [`05_market_basket_analysis.sql`](scripts/05_market_basket_analysis.sql)

**Visualization:**

![Market Basket Product Pairs](assets/market_basket_chart.png)

---

# ⚡ SQL Performance Optimization

One of the project's practical challenges was optimizing the product-pair analysis.

A direct transaction-level self-join was computationally expensive because of the large number of transaction records.

The optimized approach involved:

1. Removing cancelled orders.
2. Excluding non-merchandise/service stock codes.
3. Deduplicating invoice-product combinations.
4. Creating a temporary analytical table.
5. Adding a composite index on:

```sql
(invoiceno, stockcode)
```

6. Filtering unusually large baskets.
7. Restricting product candidates to products appearing in at least 20 qualifying orders.
8. Performing the self-join only after these reductions.

### Measured Performance

| Optimization Step                | Approximate Time |
| -------------------------------- | ---------------: |
| Temporary table + index creation |  **~12 seconds** |
| Optimized basket query           |  **~17 seconds** |

This demonstrates practical PostgreSQL performance optimization by reducing the volume of data involved in expensive analytical operations.

---

# 🧹 Data Quality & Engineering

The original dataset presented an encoding issue during PostgreSQL import because some fields contained the **£ currency symbol**.

The initial typed import failed with a UTF-8 encoding error.

The problem was resolved by:

* Loading the raw CSV into a text-based staging table.
* Using Windows-1252-compatible encoding during import.
* Performing explicit type conversion during the cleaning stage.
* Converting quantities, prices, customer IDs, and timestamps into appropriate analytical data types.
* Creating indexes on frequently queried fields.
* Performing basic validation checks after transformation.

This reflects a realistic data analyst workflow where **data ingestion, transformation, and quality issues must be addressed before meaningful analysis can begin**.

**SQL:** [`01_data_cleaning.sql`](scripts/01_data_cleaning.sql)

---

# 📁 Repository Structure

```text
sql-ecommerce-analytics/
│
├── README.md
├── LICENSE
│
├── scripts/
│   ├── 01_data_cleaning.sql
│   ├── 02_business_kpis.sql
│   ├── 03_rfm_segmentation.sql
│   ├── 04_cohort_retention.sql
│   └── 05_market_basket_analysis.sql
│
├── assets/
│   ├── rfm_customer_segment_chart.png
│   ├── cohort_retention_chart.png
│   └── market_basket_chart.png
│
└── dataset/
    └── README.md
```

---

# 💡 Business Recommendations

Based on the analytical findings, the following actions could be considered:

### 1. Protect High-Value Customers

Develop loyalty initiatives, personalized offers, and priority customer experiences for the **Champions** segment.

### 2. Reactivate At-Risk Customers

Use targeted email promotions, product recommendations, and time-limited incentives to re-engage **At-Risk / Need Attention** customers.

### 3. Encourage Second Purchases

Target **Recent New Customers** and **Potential Loyalists** with follow-up campaigns designed to increase repeat-purchase rates.

### 4. Create Product Bundles

Frequently co-purchased products can be packaged into bundles to increase convenience and potentially raise average order value.

### 5. Use Product-Variant Recommendations

Strong relationships between product variants provide opportunities for **"Complete the Set"**, multi-buy, and related-product recommendations.

### 6. Plan for Seasonal Demand

The November revenue peak suggests the need for stronger inventory, marketing, staffing, and operational planning around high-demand periods.

---

# ⚠️ Analytical Limitations

* The dataset covers only **December 2010 through December 2011**.
* Customer analysis is limited to transactions with an available `CustomerID`.
* Missing customer identifiers should not automatically be interpreted as guest checkouts.
* RFM monetary values represent **historical customer spend**, not modeled Customer Lifetime Value (CLV).
* Cohort retention measures **active customer retention**, not revenue retention.
* M12 retention cannot be observed for cohorts whose 12-month observation window extends beyond December 2011.
* Product-pair analysis measures **co-occurrence**, not full association rules.
* Support, confidence, and lift were not calculated.
* `DOTCOM POSTAGE` is included in product revenue analysis but excluded from product-pair basket analysis because it represents a service/postage item rather than merchandise.
* Historical revenue should not be interpreted as current revenue or current customer value.

---

# 📚 Dataset

## UCI Online Retail Dataset

**Source:** UCI Machine Learning Repository — Online Retail Dataset

**Citation:**

Chen, D. (2015). *Online Retail* [Dataset]. UCI Machine Learning Repository.

**DOI:** `10.24432/C5BW33`

The dataset contains transactional records for a UK-based online retail business covering December 2010 through December 2011.

The raw dataset is **not included in this repository**. Users should obtain the original dataset from the UCI Machine Learning Repository and comply with the applicable dataset terms of use.

The SQL scripts in this project assume that the dataset has been imported into PostgreSQL and transformed according to the data-cleaning workflow documented in [`01_data_cleaning.sql`](scripts/01_data_cleaning.sql).

---

# 🚀 What This Project Demonstrates

This project demonstrates the ability to:

* ✓ Clean and structure raw transactional data in PostgreSQL
* ✓ Translate business questions into SQL analytical queries
* ✓ Build reusable analytical views
* ✓ Apply advanced SQL window functions
* ✓ Perform customer segmentation using RFM methodology
* ✓ Measure customer retention using cohort analysis
* ✓ Identify product purchasing patterns
* ✓ Optimize computationally expensive SQL operations
* ✓ Handle real-world data encoding and data-quality issues
* ✓ Interpret analytical results from a business perspective
* ✓ Translate data findings into actionable business recommendations

---

# 👨‍💻 Author

## Steven Ochieng Otiende

**Data Analyst | Business Intelligence Analyst | Statistics & Performance Analytics Specialist**

**Nairobi, Kenya**

**Core Tools:** PostgreSQL | SQL | Python | Power BI | Excel | R | STATA | SPSS

---

### ⭐ Portfolio Focus

> **Turning transactional data into reliable analysis, business intelligence, and actionable business decisions using SQL.**
