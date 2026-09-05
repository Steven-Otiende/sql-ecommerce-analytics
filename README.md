# 🛒 E-Commerce Customer Analytics & Business Intelligence

### PostgreSQL SQL Analytics Portfolio Project

**Steven Ochieng Otiende**
**Data Analyst | Business Intelligence Analyst | Statistics & Performance Analytics Specialist**

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=flat\&logo=postgresql\&logoColor=white)](https://www.postgresql.org/)
[![SQL](https://img.shields.io/badge/SQL-Analytics-blue?style=flat)](#)
[![RFM](https://img.shields.io/badge/RFM-Customer%20Segmentation-orange?style=flat)](#)
[![Cohort Analysis](https://img.shields.io/badge/Cohort-Retention-green?style=flat)](#)
[![Market Basket](https://img.shields.io/badge/Market%20Basket-Analysis-purple?style=flat)](#)

---

## 📌 Project Overview

This project demonstrates an end-to-end **customer and transactional analytics workflow using PostgreSQL**.

Using the **UCI Online Retail dataset**, the project transforms more than **541,000 transaction records** into actionable business intelligence covering:

* Sales performance
* Customer segmentation
* Customer retention
* Product purchasing behavior
* Cross-selling opportunities
* SQL query optimization

The objective was not simply to query data, but to demonstrate how **SQL can be used to solve practical business problems and support data-driven decision-making**.

---

## 📊 Key Results

| Business Metric                 |            Result |
| ------------------------------- | ----------------: |
| Transaction records analyzed    |       **541,909** |
| Fulfilled orders                |        **22,064** |
| Identified customers            |         **4,339** |
| Calculated transaction revenue  |       **£10.64M** |
| Peak revenue month              | **November 2011** |
| Peak monthly revenue            |        **£1.51M** |
| RFM Champions                   |           **955** |
| Champions' share of RFM revenue |         **64.5%** |
| December 2010 M12 retention     |         **26.6%** |
| Top product pair                |    **330 orders** |

---

## 🔍 Business Questions

The analysis was designed to answer five core business questions:

### 1. Sales Performance

**How is revenue and order activity changing over time?**

### 2. Customer Value

**Which customers are the most valuable and engaged?**

### 3. Customer Retention

**How well are customers retained after their first purchase?**

### 4. Product Affinity

**Which products are frequently purchased together?**

### 5. SQL Performance

**How can complex analytical queries be optimized for better performance?**

---

# 📈 Key Analysis

## 1. Sales Performance Analysis

Core business KPIs were calculated using PostgreSQL, including:

* Total fulfilled orders
* Identified customers
* Transaction revenue
* Monthly revenue
* Monthly order activity
* Product-level performance

### Key Finding

**November 2011** was the strongest revenue month, generating approximately **£1.51 million**.

This suggests strong seasonal demand and provides opportunities for improved inventory, marketing, staffing, and fulfillment planning.

**SQL:** [`02_business_kpis.sql`](scripts/02_business_kpis.sql)

---

## 2. 👥 RFM Customer Segmentation

Customers were segmented using **Recency, Frequency, and Monetary (RFM)** analysis.

PostgreSQL window functions, including `NTILE()`, were used to score customers and assign business-oriented segments.

| Segment                  | Customers | Avg. Recency | Avg. Orders | Historical Revenue |
| ------------------------ | --------: | -----------: | ----------: | -----------------: |
| Champions                |       955 |    11.4 days |        11.1 |             £5.75M |
| Loyal Customers          |       993 |    33.1 days |         3.8 |             £1.59M |
| At-Risk / Need Attention |       655 |   146.7 days |         3.4 |              £897K |
| Potential Loyalist       |       910 |    73.2 days |         1.2 |              £338K |
| Lost / Dormant           |       684 |   275.0 days |         1.1 |              £287K |
| Recent New Customers     |       142 |    17.7 days |         1.0 |               £51K |

### Key Finding

**Champions represent approximately 22% of RFM-segmented customers but generate 64.5% of RFM-segmented historical revenue.**

This indicates substantial concentration of customer value among highly engaged customers.

### Business Opportunity

* Protect high-value customers through retention strategies.
* Reactivate At-Risk customers.
* Convert Potential Loyalists into repeat customers.
* Encourage Recent New Customers toward a second purchase.

### Visualization

![RFM Customer Segment Chart](assets/rfm_customer_segment_chart.png)

**SQL:** [`03_rfm_segmentation.sql`](scripts/03_rfm_segmentation.sql)

---

## 3. 📅 Cohort Retention Analysis

Customers were grouped according to their **first purchase month** and tracked across subsequent months.

### Key Finding

The **December 2010 cohort** contained **885 customers**.

After 12 months:

**235 customers remained active.**

### M12 Retention: **26.6%**

This analysis provides a clearer view of customer lifecycle performance than aggregate customer counts alone.

### Business Opportunity

Cohort analysis can support:

* Customer onboarding improvements
* Repeat-purchase campaigns
* Lifecycle marketing
* Retention benchmarking
* Identification of weak retention periods

### Visualization

![Cohort Retention Chart](assets/cohort_retention_chart.png)

**SQL:** [`04_cohort_retention.sql`](scripts/04_cohort_retention.sql)

> **Note:** Retention measures active customers rather than revenue retention.

---

## 4. 🛍️ Market Basket / Product-Pair Analysis

Product co-occurrence analysis was used to identify products frequently purchased within the same qualifying order.

The workflow included:

* Removing cancelled transactions
* Excluding postage/service items
* Deduplicating invoice-product combinations
* Filtering unusually large baskets
* Identifying frequently occurring products
* Performing product self-joins
* Ranking product pairs by order frequency

### Top Product Pair

**JUMBO BAG PINK POLKADOT + JUMBO BAG RED RETROSPOT**

**330 qualifying orders**

### Business Opportunity

These relationships can support:

* Product bundles
* Cross-selling
* "Complete the set" recommendations
* Checkout recommendations
* Multi-buy promotions
* Merchandising optimization

### Visualization

![Market Basket Product Pairs](assets/market_basket_chart.png)

**SQL:** [`05_market_basket_analysis.sql`](scripts/05_market_basket_analysis.sql)

> **Analytical note:** This analysis measures product co-occurrence rather than full association-rule mining. Support, confidence, and lift were not calculated.

---

# ⚡ SQL Performance Optimization

The market basket analysis required an expensive **self-join across transactional data**.

Instead of joining the full dataset directly, the analysis was optimized by reducing the data before the expensive operation.

### Optimization techniques

* Data filtering before joins
* Deduplication
* Temporary analytical tables
* Composite indexing
* Candidate product filtering
* Basket-size filtering

### Measured Performance

| Operation                        | Approx. Time |
| -------------------------------- | -----------: |
| Temporary table + index creation |  **~12 sec** |
| Optimized basket query           |  **~17 sec** |

This demonstrates practical PostgreSQL optimization techniques for analytical workloads.

---

# 💡 Business Insights

The combined analysis produced several actionable findings.

### 1. Customer value is concentrated

A relatively small group of highly engaged customers generates a disproportionately large share of historical revenue.

**Action:** Prioritize Champions and Loyal Customers with retention and loyalty initiatives.

### 2. There is a significant reactivation opportunity

**655 customers** were classified as At-Risk / Need Attention.

**Action:** Develop targeted reactivation campaigns based on previous purchase behavior.

### 3. Retention declines over the customer lifecycle

The December 2010 cohort retained **26.6% of customers at M12**.

**Action:** Strengthen post-purchase engagement and second-purchase conversion.

### 4. Product relationships create cross-selling opportunities

The strongest product pair appeared together in **330 qualifying orders**.

**Action:** Use product affinity to inform bundles and recommendations.

### 5. Seasonality should influence planning

November 2011 recorded approximately **£1.51M** in revenue.

**Action:** Use historical seasonality to inform inventory, marketing, staffing, and fulfillment planning.

---

# 🧠 Analytical Workflow

```text
Raw Transaction Data
        ↓
PostgreSQL Staging
        ↓
Data Cleaning & Validation
        ↓
Business KPI Analysis
        ↓
RFM Customer Segmentation
        ↓
Cohort Retention Analysis
        ↓
Product-Pair Analysis
        ↓
SQL Performance Optimization
        ↓
Business Insights
        ↓
Recommendations
```

---

# 🛠️ Technical Skills Demonstrated

### SQL & PostgreSQL

* Common Table Expressions (CTEs)
* Window Functions
* `NTILE()`
* `RANK()`
* Conditional Aggregation
* `CASE`
* `COUNT(DISTINCT ...)`
* Date & Time Functions
* Self-Joins
* Temporary Tables
* Composite Indexes
* Query Optimization

### Data Preparation

* Data staging
* Encoding handling
* Data type conversion
* Missing-value handling
* Transaction filtering
* Data validation
* Feature engineering

### Analytical Methods

* Business KPI Analysis
* RFM Segmentation
* Cohort Analysis
* Customer Retention Analysis
* Product Affinity Analysis
* Market Basket Analysis

---

# 📂 Project Structure

```text
sql-ecommerce-analytics/
│
├── README.md
├── CASE_STUDY.md
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

# 📑 Project Documentation

### 📘 Full Case Study

For the complete analytical methodology, technical challenges, business interpretation, recommendations, limitations, and future enhancements:

👉 **[Read the Full PostgreSQL Analytics Case Study](CASE_STUDY.md)**

### 💻 SQL Scripts

| Script                                                                   | Purpose                                 |
| ------------------------------------------------------------------------ | --------------------------------------- |
| [`01_data_cleaning.sql`](scripts/01_data_cleaning.sql)                   | Data staging, cleaning & transformation |
| [`02_business_kpis.sql`](scripts/02_business_kpis.sql)                   | Sales & business KPI analysis           |
| [`03_rfm_segmentation.sql`](scripts/03_rfm_segmentation.sql)             | Customer RFM segmentation               |
| [`04_cohort_retention.sql`](scripts/04_cohort_retention.sql)             | Cohort & retention analysis             |
| [`05_market_basket_analysis.sql`](scripts/05_market_basket_analysis.sql) | Product-pair analysis & optimization    |

---

# 📚 Dataset

The project uses the **UCI Online Retail Dataset**.

**Source:** UCI Machine Learning Repository

**Citation:**

Chen, D. (2015). *Online Retail* [Dataset]. UCI Machine Learning Repository.

**DOI:** `10.24432/C5BW33`

The raw dataset is **not included in this repository**. See [`dataset/README.md`](dataset/README.md) for dataset information and reproduction guidance.

---

# ⚠️ Analytical Limitations

* The dataset covers December 2010 – December 2011.
* Customer-level analysis is limited to records with available `CustomerID`.
* Missing Customer IDs should not automatically be interpreted as guest customers.
* RFM Monetary values represent historical transaction value, not predicted Customer Lifetime Value.
* Cohort retention measures active customers rather than revenue retention.
* M12 retention is only observable for cohorts with sufficient follow-up time.
* Product-pair analysis measures co-occurrence rather than complete association-rule mining.
* Support, confidence, and lift were not calculated.
* Postage/service items are excluded from product-pair analysis but relevant transaction revenue is retained in sales analysis.

---

# 🚀 Future Enhancements

Potential extensions include:

* Customer Lifetime Value modeling
* Customer churn prediction
* Revenue forecasting
* Product demand forecasting
* Association rules using support, confidence & lift
* Product recommendation systems
* Customer clustering
* Interactive Power BI dashboard
* Automated analytical pipeline

---

# 👨‍💻 About the Author

**Steven Ochieng Otiende**

**Data Analyst | Business Intelligence Analyst | Statistics & Performance Analytics Specialist**

**Core Tools:** PostgreSQL | SQL | Python | Power BI | Excel | R | STATA | SPSS

I specialize in transforming data into **actionable insights, performance intelligence, and business recommendations** through statistical analysis, SQL, data visualization, and business intelligence.

---

## ⭐ Portfolio Focus

> **Turning transactional data into reliable analysis, business intelligence, and actionable business decisions using SQL.**
