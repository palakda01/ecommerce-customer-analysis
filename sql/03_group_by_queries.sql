USE retail_analysis;

SELECT country,
       ROUND(SUM(total_price), 2) AS revenue
FROM retail_sales
GROUP BY country
ORDER BY revenue DESC;

-- Q1: Revenue, orders and customers by country
SELECT country,
       ROUND(SUM(total_price), 2)   AS revenue,
       COUNT(DISTINCT invoice_no)   AS orders,
       COUNT(DISTINCT customer_id)  AS customers
FROM retail_sales
GROUP BY country
ORDER BY revenue DESC;

-- Q2: Each country's percentage of total revenue (top 10)
SELECT country,
       ROUND(SUM(total_price), 2) AS revenue,
       ROUND(100 * SUM(total_price) / (SELECT SUM(total_price) FROM retail_sales), 2) AS pct_of_total
FROM retail_sales
GROUP BY country
ORDER BY revenue DESC
LIMIT 10;

-- Q3: Monthly revenue, orders and customers
SELECT order_month,
       ROUND(SUM(total_price), 2)  AS revenue,
       COUNT(DISTINCT invoice_no)  AS orders,
       COUNT(DISTINCT customer_id) AS customers
FROM retail_sales
GROUP BY order_month
ORDER BY order_month;

-- Q4: Top 10 products by revenue
SELECT stock_code,
       MAX(description)             AS product,
       SUM(quantity)                AS units_sold,
       ROUND(SUM(total_price), 2)   AS revenue
FROM retail_sales
GROUP BY stock_code
ORDER BY revenue DESC
LIMIT 10;

-- Q5: Orders and revenue by day of week
SELECT day_name,
       COUNT(DISTINCT invoice_no) AS orders,
       ROUND(SUM(total_price), 2) AS revenue
FROM retail_sales
GROUP BY day_name
ORDER BY FIELD(day_name, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');

-- Q6: Orders and revenue by hour of day
SELECT hour,
       COUNT(DISTINCT invoice_no) AS orders,
       ROUND(SUM(total_price), 2) AS revenue
FROM retail_sales
GROUP BY hour
ORDER BY hour;

-- Q7: Top 10 customers by total spend (excluding unknown customers)
SELECT customer_id,
       COUNT(DISTINCT invoice_no) AS orders,
       ROUND(SUM(total_price), 2) AS total_spent
FROM retail_sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- Q8: Average order value by country, only for countries with at least 50 orders
SELECT country,
       COUNT(DISTINCT invoice_no) AS orders,
       ROUND(SUM(total_price) / COUNT(DISTINCT invoice_no), 2) AS avg_order_value
FROM retail_sales
GROUP BY country
HAVING COUNT(DISTINCT invoice_no) >= 50
ORDER BY avg_order_value DESC;

