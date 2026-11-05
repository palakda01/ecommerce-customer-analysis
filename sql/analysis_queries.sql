-- =====================================================
-- E-commerce Customer and Sales Analysis (MySQL)
-- Table: retail_sales (cleaned UCI Online Retail data, Dec 2010 - Dec 2011)
-- Note: December 2011 is a partial month (data ends around 9 Dec).
-- =====================================================

USE retail_analysis;

-- Q1: What are the headline business numbers?
-- Finding: about 10.25M revenue, 19,773 orders, 4,334 identified customers, average order value about 518.
SELECT ROUND(SUM(total_price), 2)  AS total_revenue,
       COUNT(DISTINCT invoice_no)  AS total_orders,
       COUNT(DISTINCT customer_id) AS total_customers,
       ROUND(SUM(total_price) / COUNT(DISTINCT invoice_no), 2) AS avg_order_value
FROM retail_sales;


-- Q2: How does revenue trend month by month?
-- Finding: revenue peaks in November 2011 (about 1.45M) after rising from September.
SELECT order_month,
       ROUND(SUM(total_price), 2)  AS revenue,
       COUNT(DISTINCT invoice_no)  AS orders,
       COUNT(DISTINCT customer_id) AS customers
FROM retail_sales
GROUP BY order_month
ORDER BY order_month;


-- Q3: How fast is revenue growing or shrinking month over month?
-- Finding: September +42% and November +32%; December 2011 looks low only because it is a partial month.
WITH monthly AS (
    SELECT order_month, ROUND(SUM(total_price), 2) AS revenue
    FROM retail_sales
    GROUP BY order_month
)
SELECT order_month,
       revenue,
       LAG(revenue) OVER (ORDER BY order_month) AS prev_month_revenue,
       ROUND(100 * (revenue - LAG(revenue) OVER (ORDER BY order_month))
                 / LAG(revenue) OVER (ORDER BY order_month), 2) AS mom_growth_pct
FROM monthly
ORDER BY order_month;


-- Q4: Which countries generate the most revenue, and what share of the total is that?
SELECT country,
       ROUND(SUM(total_price), 2) AS revenue,
       COUNT(DISTINCT invoice_no) AS orders,
       ROUND(100 * SUM(total_price) / (SELECT SUM(total_price) FROM retail_sales), 2) AS pct_of_total
FROM retail_sales
GROUP BY country
ORDER BY revenue DESC
LIMIT 10;


-- Q5: Which 10 products bring in the most revenue?
SELECT stock_code,
       MAX(description)           AS product,
       SUM(quantity)              AS units_sold,
       ROUND(SUM(total_price), 2) AS revenue
FROM retail_sales
GROUP BY stock_code
ORDER BY revenue DESC
LIMIT 10;


-- Q6: Who are the top 10 customers by total spend?
-- Rows without a customer ID are excluded.
SELECT customer_id,
       COUNT(DISTINCT invoice_no) AS orders,
       ROUND(SUM(total_price), 2) AS total_spent
FROM retail_sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;


-- Q7: How many customers are one-time vs repeat buyers, and how much do they spend?
-- Finding: 65% of customers are repeat buyers and generate about 93% of identified-customer revenue.
WITH customer_orders AS (
    SELECT customer_id,
           COUNT(DISTINCT invoice_no) AS orders,
           SUM(total_price)           AS total_spent
    FROM retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT CASE WHEN orders = 1 THEN 'One-time' ELSE 'Repeat' END AS customer_type,
       COUNT(*) AS customers,
       ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM customer_orders), 2) AS pct_of_customers,
       ROUND(SUM(total_spent), 2) AS revenue,
       ROUND(AVG(total_spent), 2) AS avg_spend
FROM customer_orders
GROUP BY customer_type;


-- Q8: How concentrated is revenue among customers?
-- Finding: the top 25% of customers generate about 79% of identified-customer revenue.
WITH customer_spend AS (
    SELECT customer_id, SUM(total_price) AS total_spent
    FROM retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),
tiles AS (
    SELECT customer_id, total_spent,
           NTILE(4) OVER (ORDER BY total_spent DESC) AS spend_quartile
    FROM customer_spend
)
SELECT spend_quartile,
       COUNT(*)                   AS customers,
       ROUND(MIN(total_spent), 2) AS min_spend,
       ROUND(MAX(total_spent), 2) AS max_spend,
       ROUND(SUM(total_spent), 2) AS revenue,
       ROUND(100 * SUM(total_spent) / (SELECT SUM(total_spent) FROM customer_spend), 2) AS pct_of_revenue
FROM tiles
GROUP BY spend_quartile
ORDER BY spend_quartile;


-- Q9: Which valuable customers have gone quiet (at risk of leaving)?
-- Above-average spenders with no order in the last 90 days of the data.
-- The reference date is the last date in the dataset, not today's date.
WITH customer_orders AS (
    SELECT customer_id,
           COUNT(DISTINCT invoice_no) AS orders,
           ROUND(SUM(total_price), 2) AS total_spent,
           MAX(order_date)            AS last_order
    FROM retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT customer_id, orders, total_spent, last_order,
       DATEDIFF((SELECT MAX(order_date) FROM retail_sales), last_order) AS days_inactive
FROM customer_orders
WHERE total_spent > (SELECT AVG(total_spent) FROM customer_orders)
  AND DATEDIFF((SELECT MAX(order_date) FROM retail_sales), last_order) > 90
ORDER BY total_spent DESC
LIMIT 20;


-- Q10: Which 3 products sell best in each month (seasonal patterns)?
WITH product_month AS (
    SELECT order_month,
           stock_code,
           MAX(description)           AS product,
           ROUND(SUM(total_price), 2) AS revenue
    FROM retail_sales
    GROUP BY order_month, stock_code
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY order_month ORDER BY revenue DESC) AS rnk
    FROM product_month
)
SELECT order_month, rnk, product, revenue
FROM ranked
WHERE rnk <= 3
ORDER BY order_month, rnk;