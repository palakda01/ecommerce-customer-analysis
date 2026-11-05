USE retail_analysis;

-- 1
WITH country_rev AS (
    SELECT country, ROUND(SUM(total_price), 2) AS revenue
    FROM retail_sales GROUP BY country
),
ranked AS (
    SELECT country, revenue, RANK() OVER (ORDER BY revenue DESC) AS rnk FROM country_rev
)
SELECT * FROM ranked WHERE rnk <= 5;

-- 2
WITH monthly AS (
    SELECT order_month, SUM(total_price) AS revenue FROM retail_sales GROUP BY order_month
),
changes AS (
    SELECT order_month,
           revenue - LAG(revenue) OVER (ORDER BY order_month) AS change_in_revenue
    FROM monthly
)
SELECT order_month, ROUND(change_in_revenue, 2) AS change_in_revenue
FROM changes
ORDER BY change_in_revenue DESC
LIMIT 1;

-- 3
WITH uk_customers AS (
    SELECT customer_id, ROUND(SUM(total_price), 2) AS total_spent
    FROM retail_sales
    WHERE country = 'United Kingdom' AND customer_id IS NOT NULL
    GROUP BY customer_id
),
ranked AS (
    SELECT customer_id, total_spent,
           ROW_NUMBER() OVER (ORDER BY total_spent DESC) AS rn
    FROM uk_customers
)
SELECT * FROM ranked WHERE rn <= 3;