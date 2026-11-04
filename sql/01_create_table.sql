CREATE DATABASE retail_analysis;
USE retail_analysis;
USE retail_analysis;

CREATE TABLE retail_sales (
    invoice_no    VARCHAR(20),
    stock_code    VARCHAR(20),
    description   VARCHAR(255),
    quantity      INT,
    invoice_date  DATETIME,
    unit_price    DECIMAL(10,2),
    customer_id   INT NULL,
    country       VARCHAR(60),
    total_price   DECIMAL(12,2),
    order_date    DATE,
    year          INT,
    month         INT,
    order_month   VARCHAR(7),
    day_name      VARCHAR(10),
    hour          INT
);
SHOW TABLES;
SELECT * FROM retail_sales;