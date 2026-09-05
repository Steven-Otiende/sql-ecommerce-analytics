# E-Commerce Customer Analytics & Business Intelligence — PostgreSQL

### Advanced SQL Data Analytics & Business Intelligence Portfolio Project

**PostgreSQL | SQL | Customer Analytics | RFM Segmentation | Cohort Analysis | Market Basket Analysis**

---

## 📌 Project Overview

This project demonstrates an end-to-end **SQL analytics workflow using PostgreSQL** on the UCI Online Retail dataset containing **541,909 transaction records** from December 2010 to December 2011.

The analysis transforms raw transactional data into actionable business insights covering:

* Sales and revenue performance
* Customer purchasing behavior
* RFM customer segmentation
* Cohort-based retention
* Product-pair purchasing patterns
* SQL query optimization and performance improvement

The project was designed to demonstrate not only SQL proficiency, but also the ability to translate **business questions into analytical solutions and recommendations**.

---

## 📊 Key Business Results

| KPI / Finding                             |                    Result |
| ----------------------------------------- | ------------------------: |
| Raw transactions                          |               **541,909** |
| Fulfilled orders                          |                **22,064** |
| Identified customers                      |                 **4,339** |
| Calculated transaction revenue            |        **£10,644,560.42** |
| Peak revenue month                        |         **November 2011** |
| Peak monthly revenue                      |         **£1,509,496.33** |
| RFM Champions                             |         **955 customers** |
| Champions' share of RFM-segmented revenue |                 **64.5%** |
| At-Risk customers                         |                   **655** |
| Dec. 2010 M12 customer retention          |                 **26.6%** |
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
Product-Pair Analysis
      ↓
Business Insights & Recommendations
```

---

## 🛠️ Technical Skills Demonstrated

### SQL & PostgreSQL

* CTEs
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
* Business interpretation

---

# 📈 Key Analyses

## 1. Sales Performance & Business KPIs

The analysis identified:

* **22,064 fulfilled orders**
* **4,339 customers with identified customer IDs**
* **£10.64M in calculated transaction revenue**
* **November 2011** as the strongest revenue month
* Peak monthly revenue of **£1.51M**

Monthly sales analysis also revealed a substantial increase in order activity toward the end of 2011.

**Business implication:** The late-year sales acceleration suggests opportunities for seasonal inventory planning, campaign optimization and capacity planning.

[View SQL → `02_business_kpis.sql`](scripts/02_business_kpis.sql)

---

## 2. Customer RFM Segmentation

Customers were segmented using:

* **Recency** — days since last purchase
* **Frequency** — number of fulfilled orders
* **Monetary** — historical customer spend

Customers were scored into quintiles using PostgreSQL's `NTILE(5)` window function.

### Customer segments

| Segment                  | Customers | Avg. Recency | Avg. Orders | Historical Revenue |
| ------------------------ | --------: | -----------: | ----------: | -----------------: |
| Champions                |       955 |    11.4 days |        11.1 |         £5,746,639 |
| Loyal Customers          |       993 |    33.1 days |         3.8 |         £1,592,044 |
| At-Risk / Need Attention |       655 |   146.7 days |         3.4 |           £896,952 |
| Potential Loyalist       |       910 |    73.2 days |         1.2 |           £338,496 |
| Lost / Dormant           |       684 |   275.0 days |         1.1 |           £286,597 |
| Recent New Customers     |       142 |    17.7 days |         1.0 |            £50,681 |

**Key insight:** Champions represent approximately **22% of RFM-segmented customers but account for 64.5% of RFM-segmented historical revenue.**

**Business implication:** High-value customer retention should be a major priority, while targeted reactivation campaigns can focus on the At-Risk and Lost/Dormant segments.

[View SQL → `03_rfm_segmentation.sql`](scripts/03_rfm_segmentation.sql)

---

## 3. Cohort Retention Analysis

Customers were grouped according to the month of their first purchase and tracked across subsequent months.

The December 2010 cohort contained **885 customers**, of whom **235 remained active in month 12**, representing **26.6% customer retention**.

> Later cohorts do not have observable M12 retention because the dataset ends in December 2011.

**Business implication:** Cohort analysis helps identify differences in customer retention over time and provides a foundation for improving onboarding, repeat-purchase campaigns and customer lifecycle strategies.

[View SQL → `04_cohort_retention.sql`](scripts/04_cohort_retention.sql)

---

## 4. Product-Pair / Market Basket Analysis

Product co-occurrence analysis identified products frequently purchased within the same qualifying orders.

### Top product pair

**JUMBO BAG PINK POLKADOT + JUMBO BAG RED RETROSPOT**

**330 qualifying orders**

Other strong associations included:

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

[View SQL → `05_market_basket_analysis.sql`](scripts/05_market_basket_analysis.sql)

---

# ⚡ SQL Performance Optimization

One of the project's practical challenges was optimizing the product-pair analysis.

A direct transaction-level self-join was computationally expensive because of the large number of transaction rows.

The solution involved:

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

### Measured performance

* Temporary table + index creation: **~12 seconds**
* Optimized basket query: **~17 seconds**

This demonstrates practical PostgreSQL performance optimization rather than relying solely on query syntax.

---

# 🧹 Data Quality & Engineering

The original dataset presented an encoding issue during PostgreSQL import because some fields contained the **£ currency symbol**.

The initial typed import failed with a UTF-8 encoding error.

The problem was resolved by:

* Loading the raw CSV into a text-based staging table.
* Using the appropriate Windows-1252-compatible encoding.
* Performing explicit type conversion during the cleaning stage.
* Converting quantities, prices, customer IDs and timestamps into analytical data types.

This reflects a realistic data analyst workflow where **data ingestion and quality problems must be solved before meaningful analysis can begin**.

[View SQL → `01_data_cleaning.sql`](scripts/01_data_cleaning.sql)

---

# 📁 Repository Structure

```text
sql-ecommerce-analytics/
│
├── README.md
├── CASE_STUDY.md
│
├── scripts/
│   ├── 01_data_cleaning.sql
│   ├── 02_business_kpis.sql
│   ├── 03_rfm_segmentation.sql
│   ├── 04_cohort_retention.sql
│   └── 05_market_basket_analysis.sql
│
├── assets/
│   ├── rfm_results.png
│   ├── cohort_results.png
│   └── market_basket_results.png
│
└── dataset/
    └── README.md
```

---

# 💡 Business Recommendations

Based on the analysis, the following actions could be considered:

### 1. Protect high-value customers

Develop loyalty initiatives and personalized offers for the **Champions** segment.

### 2. Reactivate at-risk customers

Use targeted email promotions, product recommendations and time-limited offers for **At-Risk / Need Attention** customers.

### 3. Encourage second purchases

Recent and Potential Loyalist customers can be targeted with follow-up offers designed to increase purchase frequency.

### 4. Create product bundles

Frequently co-purchased products can be packaged into bundles to increase average order value.

### 5. Use variant-based recommendations

Strong relationships between product variants provide opportunities for "Complete the Set" and multi-buy recommendations.

### 6. Plan for seasonal demand

The November revenue peak suggests the need for stronger inventory, marketing and operational planning around high-demand periods.

---

# ⚠️ Analytical Limitations

* The dataset covers only **December 2010–December 2011**.
* Customer analysis is limited to transactions with an available `CustomerID`.
* Missing customer identifiers should not automatically be interpreted as guest checkouts.
* RFM monetary values represent **historical customer spend**, not modeled Customer Lifetime Value.
* Cohort retention measures **active customer retention**, not revenue retention.
* M12 retention cannot be observed for cohorts whose 12-month observation window extends beyond December 2011.
* Product-pair analysis measures **co-occurrence**, not full association rules; support, confidence and lift were not calculated.
* `DOTCOM POSTAGE` is included in product revenue analysis but excluded from product-pair basket analysis because it represents a service/postage item rather than a merchandise product.

---

# 📚 Dataset

**Source:** UCI Machine Learning Repository — Online Retail Dataset

The dataset contains transactional records for a UK-based online retail business covering December 2010 through December 2011.

[UCI Machine Learning Repository](https://archive.ics.uci.edu/datasets?utm_source=chatgpt.com)

---

# 🚀 What This Project Demonstrates

This project demonstrates the ability to:

**✓ Clean and structure raw transactional data in PostgreSQL**

**✓ Translate business questions into SQL analytical queries**

**✓ Build reusable analytical views**

**✓ Apply advanced SQL window functions**

**✓ Perform customer segmentation using RFM methodology**

**✓ Measure customer retention using cohort analysis**

**✓ Identify product purchasing patterns**

**✓ Optimize computationally expensive SQL operations**

**✓ Interpret analytical results from a business perspective**

**✓ Translate data findings into actionable recommendations**

---

## 👨‍💻 Author

**Steven Ochieng Otiende**

Data Analyst | Business Intelligence Analyst | Statistics & Performance Analytics Specialist

**Nairobi, Kenya**

**Core tools:** PostgreSQL | SQL | Python | Power BI | Excel | R | STATA | SPSS

---

### ⭐ Portfolio Focus

> **Turning transactional data into reliable analysis, business intelligence and actionable decisions using SQL.**
