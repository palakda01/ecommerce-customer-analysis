# E-commerce Customer and Sales Analysis

Analysis of an online retailer's transactions (UK, Dec 2010 to Dec 2011) to understand sales trends and identify valuable and at-risk customers.

**Tools:** Python (pandas, matplotlib, seaborn), MySQL, Power BI

## Project Flow
Raw data -> Python cleaning -> MySQL -> SQL analysis -> RFM segmentation -> Power BI dashboard

## Folder Structure
- `notebooks/` - cleaning, loading to MySQL, RFM segmentation
- `sql/` - table definition, analysis queries and views
- `reports/` - charts, report and presentation
- `dashboard/` - Power BI file

## Dataset
UCI Online Retail dataset. The raw file is not included; download it from the UCI Machine Learning Repository and place it in `data/raw/`. The data ends around 9 December 2011, so December 2011 is a partial month.

## Data Cleaning
541,909 raw rows reduced to 522,504 after removing duplicates (5,268), cancelled orders (9,251), zero or negative quantity/price rows (2,512) and non-product codes such as postage and bank charges (2,374). Rows without a customer ID (131,354) were kept for sales analysis and excluded from customer analysis.

## Key Findings
- Revenue of about £10.25M from 19,773 orders and 4,334 identified customers.
- Revenue peaks in November 2011 (£1.45M) after rising from September.
- 65% of customers are repeat buyers and generate about 93% of customer revenue.
- The top 25% of customers generate 79% of customer revenue.

## Customer Segments (RFM)
| Segment | % of customers | % of revenue |
|---|---|---|
| Champions | 18% | 61% |
| Loyal Customers | 19% | 16% |
| At Risk | 9% | 7% |
| Lost | 31% | 8% |
| Others | 23% | 8% |

Champions drive most revenue, so retention matters most. At Risk customers spend like Loyal customers but have been inactive for about 136 days, making them the best win-back target.

## Limitations
- Only 12 months of data, so "Lost" means inactive within this window.
- About 15% of revenue has no customer ID and cannot be segmented.

## Dashboard and Report
Coming soon.