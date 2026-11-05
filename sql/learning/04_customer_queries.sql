USE retail_analysis;

WITH customer_orders AS (
    SELECT customer_id,
           COUNT(DISTINCT invoice_no)  AS orders,
           ROUND(SUM(total_price), 2)  AS total_spent,
           MIN(order_date)             AS first_order,
           MAX(order_date)             AS last_order
    FROM retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT *
FROM customer_orders
ORDER BY total_spent DESC
LIMIT 10;

-- Q1: One-time vs repeat customers
WITH customer_orders AS (
    SELECT customer_id,
           COUNT(DISTINCT invoice_no) AS orders,
           SUM(total_price)           AS total_spent
    FROM retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT CASE WHEN orders = 1 THEN 'One-time' ELSE 'Repeat' END AS customer_type,
       COUNT(*)                                               AS customers,
       ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM customer_orders), 2) AS pct_of_customers,
       ROUND(SUM(total_spent), 2)                             AS revenue,
       ROUND(AVG(total_spent), 2)                             AS avg_spend
FROM customer_orders
GROUP BY customer_type;

-- Q2: Customers grouped by number of orders
WITH customer_orders AS (
    SELECT customer_id,
           COUNT(DISTINCT invoice_no) AS orders,
           SUM(total_price)           AS total_spent
    FROM retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT CASE WHEN orders = 1              THEN '1 order'
            WHEN orders BETWEEN 2 AND 3  THEN '2-3 orders'
            WHEN orders BETWEEN 4 AND 9  THEN '4-9 orders'
            ELSE '10+ orders' END        AS frequency_group,
       COUNT(*)                          AS customers,
       ROUND(SUM(total_spent), 2)        AS revenue
FROM customer_orders
GROUP BY frequency_group
ORDER BY MIN(orders);

-- Q3: Days since each customer's last order (top 15 by spend)
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
       DATEDIFF((SELECT MAX(order_date) FROM retail_sales), last_order) AS days_since_last_order
FROM customer_orders
ORDER BY total_spent DESC
LIMIT 15;

-- Q4: Above-average spenders with no order in the last 90 days of the data
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

-- Q5: Share of identified-customer revenue from the top 10 customers
WITH customer_orders AS (
    SELECT customer_id, SUM(total_price) AS total_spent
    FROM retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT ROUND(SUM(total_spent), 2) AS top10_revenue,
       ROUND(100 * SUM(total_spent) / (SELECT SUM(total_spent) FROM customer_orders), 2) AS pct_of_customer_revenue
FROM (
    SELECT total_spent
    FROM customer_orders
    ORDER BY total_spent DESC
    LIMIT 10
) AS top10;

