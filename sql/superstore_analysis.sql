CREATE DATABASE superstore_analysis;
USE superstore_analysis;

CREATE TABLE superstore (
    row_id INT,
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(20),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(30),
    country VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(20),
    product_id VARCHAR(30),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(12,4),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(12,4)
);
-- TRUNCATE TABLE superstore;

-- LOAD DATA LOCAL INFILE 'D:/Data_Analytics/Retail/superstore.csv'
-- INTO TABLE superstore
-- FIELDS TERMINATED BY ',' 
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 ROWS
-- (row_id, order_id, @order_date, @ship_date, ship_mode, customer_id, customer_name, segment, country, city, state, postal_code, region, product_id, category, sub_category, product_name, sales, quantity, discount, profit) 
-- SET 
--     order_date = STR_TO_DATE(@order_date, '%m/%d/%Y'),
--     ship_date = STR_TO_DATE(@ship_date, '%m/%d/%Y');

-- SET GLOBAL local_infile = 1; 

DESCRIBE superstore;

SELECT COUNT(*) AS total_rows, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit
FROM superstore;

ALTER TABLE superstore
    MODIFY order_date VARCHAR(15),
    MODIFY ship_date VARCHAR(15);

Select * from superstore;

UPDATE superstore
SET order_date = STR_TO_DATE(order_date, '%m/%d/%Y')
WHERE order_date NOT LIKE '%-%';

UPDATE superstore
SET ship_date = STR_TO_DATE(ship_date, '%m/%d/%Y')
WHERE ship_date NOT LIKE '%-%';

ALTER TABLE superstore
    MODIFY order_date DATE,
    MODIFY ship_date DATE;

    
SELECT COUNT(*) AS total_rows,
       MIN(order_date) AS earliest,
       MAX(order_date) AS latest,
       ROUND(SUM(sales),2) AS total_sales,
       ROUND(SUM(profit),2) AS total_profit
FROM superstore;


-- ===========================================================
-- MySQL Q1: Discount Tier Segmentation
-- ===========================================================
SELECT
    CASE
        WHEN Discount = 0 THEN '0% — No Discount'
        WHEN Discount <= 0.10 THEN '1–10%'
        WHEN Discount <= 0.20 THEN '11–20%'
        WHEN Discount <= 0.30 THEN '21–30%'
        ELSE '31%+'
    END AS discount_tier,

    COUNT(*) AS orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin_pct

FROM superstore
GROUP BY discount_tier
ORDER BY
    CASE discount_tier
        WHEN '0% — No Discount' THEN 1
        WHEN '1–10%' THEN 2
        WHEN '11–20%' THEN 3
        WHEN '21–30%' THEN 4
        ELSE 5
    END;    
    
-- ===========================================================
-- 2. MySQL Q2: Regional Sub-Category Ranking (bottom 3 and top performers per region)
-- ============================================================

WITH regional_performance AS (
    SELECT
        Region,
        Sub_Category,
        ROUND(SUM(Sales), 2) AS total_sales,
        ROUND(SUM(Profit), 2) AS total_profit,
        ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct,
        ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin_pct,
        DENSE_RANK() OVER (PARTITION BY Region ORDER BY SUM(Profit) ASC)  AS rank_worst,
        DENSE_RANK() OVER (PARTITION BY Region ORDER BY SUM(Profit) DESC) AS rank_best
    FROM superstore
    GROUP BY Region, Sub_Category
)
SELECT Region,
       CASE WHEN rank_worst <= 3 THEN 'Bottom 3' ELSE 'Top 3' END AS performance_group,
       LEAST(rank_worst, rank_best) AS rank_in_group,
       Sub_Category, total_sales, total_profit, avg_discount_pct, profit_margin_pct
FROM regional_performance
WHERE rank_worst <= 3 OR rank_best <= 3
ORDER BY Region, performance_group DESC, rank_in_group; 

-- =================================================================
-- MySQL Q3: State-Level Profit Drain (net negative states + product breakdown by state)
-- =================================================================
SELECT
    State,
    COUNT(*) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin_pct,
    
    -- Count and proportion of loss-making transactions
    SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) AS loss_orders,
    ROUND(SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS loss_order_pct

FROM superstore
GROUP BY State
HAVING SUM(Profit) < 0
ORDER BY total_profit ASC;   

-- ================================================================
-- Q4: High-Volume, Loss-Making Customers
-- ==============================================================
SELECT 
    Customer_Name,
    Segment,
    COUNT(DISTINCT Order_ID) AS unique_orders,
    COUNT(*) AS total_line_items,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY 
    Customer_Name, 
    Segment
HAVING 
    SUM(Profit) < 0
ORDER BY 
    total_sales DESC
LIMIT 10;

-- ==================================================
-- Q5: Monthly Margin Divergence (LAG).
-- ==================================================
WITH monthly_metrics AS (
    SELECT
        DATE_FORMAT(Order_Date, '%Y-%m') AS order_year_month,
        ROUND(SUM(Sales), 2) AS monthly_sales,
        ROUND(SUM(Profit), 2) AS monthly_profit,
        ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct,
        ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin_pct
    FROM superstore
    GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
),
growth_calculations AS (
    SELECT
        order_year_month,
        monthly_sales,
        monthly_profit,
        avg_discount_pct,
        profit_margin_pct,
        -- Prior month metrics using LAG()
        LAG(monthly_sales, 1) OVER (ORDER BY order_year_month) AS prev_month_sales,
        LAG(monthly_profit, 1) OVER (ORDER BY order_year_month) AS prev_month_profit
    FROM monthly_metrics
)
SELECT
    order_year_month,
    monthly_sales,
    monthly_profit,
    avg_discount_pct,
    profit_margin_pct,
    ROUND(monthly_sales - prev_month_sales, 2) AS sales_change,
    ROUND(monthly_profit - prev_month_profit, 2) AS profit_change,
   CASE 
    WHEN prev_month_sales IS NULL THEN 'No Prior Month'
    WHEN (monthly_sales > prev_month_sales) AND (monthly_profit < prev_month_profit) 
        THEN 'Divergence: Sales Up, Profit Down'
    WHEN (monthly_sales < prev_month_sales) AND (monthly_profit > prev_month_profit)
        THEN 'Efficiency: Sales Down, Profit Up'
    ELSE 'Aligned'
END AS trajectory_status
FROM growth_calculations
ORDER BY order_year_month;

-- =======================================================
--  Q6: Fulfillment & Shipping Mode Efficiency.
-- =======================================================
-- A. Primary Query: Performance by Fulfillment Mode
SELECT
    Ship_Mode,
    COUNT(*) AS total_line_items,
    ROUND(AVG(DATEDIFF(Ship_Date, Order_Date)), 2) AS avg_shipping_days,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY Ship_Mode
ORDER BY total_profit DESC;

-- B. Secondary Drill-Down: Transit Days vs. Profit Margin
SELECT
    DATEDIFF(Ship_Date, Order_Date) AS shipping_days,
    COUNT(*) AS total_line_items,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY DATEDIFF(Ship_Date, Order_Date)
ORDER BY shipping_days asc;

-- ==========================================================
-- Q7: Year-over-Year (YoY) Seasonal Comparison
-- ==========================================================
SELECT
    MONTH(Order_Date) AS month_num,
    MONTHNAME(Order_Date) AS month_name,
    -- 2014 Metrics
    ROUND(SUM(CASE WHEN YEAR(Order_Date) = 2014 THEN Sales ELSE 0 END), 2) AS sales_2014,
    ROUND(SUM(CASE WHEN YEAR(Order_Date) = 2014 THEN Profit ELSE 0 END), 2) AS profit_2014,
    ROUND(AVG(CASE WHEN YEAR(Order_Date) = 2014 THEN Discount ELSE NULL END) * 100, 2) AS disc_pct_2014,
    -- 2015 Metrics
    ROUND(SUM(CASE WHEN YEAR(Order_Date) = 2015 THEN Sales ELSE 0 END), 2) AS sales_2015,
    ROUND(SUM(CASE WHEN YEAR(Order_Date) = 2015 THEN Profit ELSE 0 END), 2) AS profit_2015,
    ROUND(AVG(CASE WHEN YEAR(Order_Date) = 2015 THEN Discount ELSE NULL END) * 100, 2) AS disc_pct_2015,
    -- 2016 Metrics
    ROUND(SUM(CASE WHEN YEAR(Order_Date) = 2016 THEN Sales ELSE 0 END), 2) AS sales_2016,
    ROUND(SUM(CASE WHEN YEAR(Order_Date) = 2016 THEN Profit ELSE 0 END), 2) AS profit_2016,
    ROUND(AVG(CASE WHEN YEAR(Order_Date) = 2016 THEN Discount ELSE NULL END) * 100, 2) AS disc_pct_2016,
    -- 2017 Metrics
    ROUND(SUM(CASE WHEN YEAR(Order_Date) = 2017 THEN Sales ELSE 0 END), 2) AS sales_2017,
    ROUND(SUM(CASE WHEN YEAR(Order_Date) = 2017 THEN Profit ELSE 0 END), 2) AS profit_2017,
    ROUND(AVG(CASE WHEN YEAR(Order_Date) = 2017 THEN Discount ELSE NULL END) * 100, 2) AS disc_pct_2017
FROM superstore
GROUP BY MONTH(Order_Date), MONTHNAME(Order_Date)
ORDER BY month_num;
