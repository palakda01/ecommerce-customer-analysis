USE retail_analysis;

-- Q1: Monthly revenue with month-over-month growth
WITH monthly AS (
    SELECT order_month,
           ROUND(SUM(total_price), 2) AS revenue
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

-- Q2: Cumulative revenue by month
WITH monthly AS (
    SELECT order_month, SUM(total_price) AS revenue
    FROM retail_sales
    GROUP BY order_month
)
SELECT order_month,
       ROUND(revenue, 2) AS revenue,
       ROUND(SUM(revenue) OVER (ORDER BY order_month), 2) AS cumulative_revenue
FROM monthly
ORDER BY order_month;

-- Q3: Top 3 products by revenue in each month
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

-- Q4: Average gap between consecutive orders for repeat customers
WITH orders AS (
    SELECT customer_id, invoice_no, MIN(order_date) AS order_date
    FROM retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id, invoice_no
),
gaps AS (
    SELECT customer_id,
           DATEDIFF(order_date,
                    LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date, invoice_no)) AS days_since_prev
    FROM orders
)
SELECT COUNT(*)                        AS gaps_measured,
       ROUND(AVG(days_since_prev), 1)  AS avg_days_between_orders,
       MAX(days_since_prev)            AS longest_gap
FROM gaps
WHERE days_since_prev IS NOT NULL;

-- Q5: Customers split into 4 spending groups
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
       COUNT(*)                         AS customers,
       ROUND(MIN(total_spent), 2)       AS min_spend,
       ROUND(MAX(total_spent), 2)       AS max_spend,
       ROUND(SUM(total_spent), 2)       AS revenue,
       ROUND(100 * SUM(total_spent) / (SELECT SUM(total_spent) FROM customer_spend), 2) AS pct_of_revenue
FROM tiles
GROUP BY spend_quartile
ORDER BY spend_quartile;