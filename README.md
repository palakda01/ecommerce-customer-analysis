\# E-commerce Customer and Sales Analysis



\## Goal

Analyze an online retailer's sales data to understand revenue trends, top products and countries, and identify valuable and at-risk customers.



\## Business Questions

1\. How do monthly sales and orders trend?

2\. Which products and countries generate the most revenue?

3\. Who are the top customers?

4\. What share of customers are repeat buyers?

5\. Which customers are at risk of leaving?

6\. What actions should the business take?



\## Tools

Python, PostgreSQL, Power BI



step	rows\_remaining

0	Raw data	541909

1	Removed duplicates	536641

2	Removed cancelled orders	527390

3	Removed quantity/price <= 0	524878

4	Removed non-product codes	522504

5	Final cleaned data	522504



\## Dataset

UCI Online Retail dataset (transactions from a UK-based online retailer, December 2010 to December 2011). The raw file is not included in this repository. Download it from the UCI Machine Learning Repository and place it in `data/raw/`.



Note: the data ends around 9 December 2011, so December 2011 is a partial month. The goal of this project is to demonstrate an end-to-end analytics workflow, and findings reflect that period rather than current market behaviour.



\## Data Cleaning Summary



Raw data:541909 rows and 8 columns. Cleaned data: XXXX rows.



| Issue found | How it was handled | Rows affected |

|---|---|---|

| Duplicate rows | Removed exact duplicates | 5268 |

| Cancelled orders (invoice starts with "C") | Separated into their own file and removed from sales data |  9251 |

| Quantity or unit price of 0 or less | Removed (stock adjustments, free or damaged items) | 2512 |

| Non-product stock codes (POST, DOT, M, BANK CHARGES, etc.) | Removed, since they are fees and adjustments, not products | XXXX |

| Missing CustomerID (about 25% of rows) | Kept for sales analysis, excluded later from customer-level (RFM) analysis | 131354 |

| Missing descriptions | Removed along with zero-price rows | XXXX |

| Inconsistent column names and data types | Renamed to snake\_case and fixed types | n/a |

| Large quantities (outliers) | Kept, as they appear to be genuine wholesale orders | n/a |



\### Feature engineering

\- `total\_price` = quantity x unit\_price

\- Date features: order\_date, year, month, order\_month, day\_name, hour



\## Project Structure

\- `notebooks/` - Python notebooks (data cleaning, analysis)

\- `sql/` - SQL queries

\- `dashboard/` - Power BI file

\- `reports/` - report and presentation

