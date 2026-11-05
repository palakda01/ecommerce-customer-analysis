USE retail_analysis;

CREATE OR REPLACE VIEW v_monthly_sales AS
SELECT order_month,
       ROUND(SUM(total_price), 2)  AS revenue,
       COUNT(DISTINCT invoice_no)  AS orders,
       COUNT(DISTINCT customer_id) AS customers,
       ROUND(SUM(total_price) / COUNT(DISTINCT invoice_no), 2) AS avg_order_value
FROM retail_sales
GROUP BY order_month;


CREATE OR REPLACE VIEW v_country_sales AS
SELECT country,
       ROUND(SUM(total_price), 2)  AS revenue,
       COUNT(DISTINCT invoice_no)  AS orders,
       COUNT(DISTINCT customer_id) AS customers
FROM retail_sales
GROUP BY country;

CREATE OR REPLACE VIEW v_product_sales AS
SELECT stock_code,
       MAX(description)            AS product,
       SUM(quantity)               AS units_sold,
       ROUND(SUM(total_price), 2)  AS revenue,
       COUNT(DISTINCT invoice_no)  AS orders
FROM retail_sales
GROUP BY stock_code;

CREATE OR REPLACE VIEW v_customer_summary AS
SELECT customer_id,
       MAX(country)                AS country,
       COUNT(DISTINCT invoice_no)  AS orders,
       ROUND(SUM(total_price), 2)  AS total_spent,
       MIN(order_date)             AS first_order,
       MAX(order_date)             AS last_order,
       ROUND(SUM(total_price) / COUNT(DISTINCT invoice_no), 2) AS avg_order_value
FROM retail_sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id;