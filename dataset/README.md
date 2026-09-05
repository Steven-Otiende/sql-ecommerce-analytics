# Dataset Documentation

## UCI Online Retail Dataset

This project uses the **Online Retail Dataset** containing transactional records from a UK-based online retailer.

### Dataset Overview

* **Source:** UCI Machine Learning Repository
* **Records:** 541,909 transaction records
* **Period:** December 2010 – December 2011
* **Geography:** Primarily the United Kingdom, with transactions from other countries
* **Unit of analysis:** Individual transaction line items

### Key Fields

| Field         | Description                           |
| ------------- | ------------------------------------- |
| `InvoiceNo`   | Unique invoice/transaction identifier |
| `StockCode`   | Product identifier                    |
| `Description` | Product description                   |
| `Quantity`    | Number of units purchased             |
| `InvoiceDate` | Date and time of transaction          |
| `UnitPrice`   | Unit price                            |
| `CustomerID`  | Customer identifier                   |
| `Country`     | Customer country                      |

### Data Preparation

The raw dataset was imported into PostgreSQL through a staging table before transformation into an analytical table.

The data-cleaning process included:

* Standardising text fields
* Converting quantities to integer values
* Converting prices to numeric values
* Converting transaction dates to PostgreSQL timestamps
* Handling missing customer identifiers
* Identifying cancelled transactions
* Validating quantities and prices
* Creating indexes for analytical queries

### Analytical Use

The dataset supports the following analyses in this project:

1. Business KPI and sales performance analysis
2. RFM customer segmentation
3. Cohort-based customer retention analysis
4. Product-pair / market basket co-occurrence analysis

## Dataset Source

Chen, D. (2015). *Online Retail* [Dataset]. UCI Machine Learning Repository.

**DOI:** https://doi.org/10.24432/C5BW33

The dataset is publicly available through the UCI Machine Learning Repository. Users should obtain the original dataset from the repository and comply with the applicable dataset terms of use.

The raw dataset is not included in this repository. The SQL scripts in this project assume that the dataset has been imported into PostgreSQL and transformed according to the data-cleaning workflow documented in `scripts/01_data_cleaning.sql`.
