CREATE DATABASE IF NOT EXISTS customer_analysis;
USE customer_analysis;

DROP TABLE IF EXISTS customers;

CREATE TABLE customer_shopping_behavior_cleaned (
    customer_id INT,
    age INT,
    gender VARCHAR(20),
    item_purchased VARCHAR(100),
    category VARCHAR(50),
    purchase_amount DECIMAL(10,2),
    location VARCHAR(100),
    size VARCHAR(10),
    color VARCHAR(30),
    season VARCHAR(20),
    review_rating DECIMAL(3,1),
    subscription_status VARCHAR(10),
    shipping_type VARCHAR(50),
    discount_applied VARCHAR(10),
    previous_purchases INT,
    payment_method VARCHAR(50),
    frequency_of_purchases VARCHAR(50),
    customer_value DECIMAL(12,2),
    is_repeat INT,
    has_discount INT,
    age_group VARCHAR(20)
);

LOAD DATA INFILE 'C:/Users/SHIVA/OneDrive/Documents/Customer_Shopping_Analysis/data/cleaned_customer_data.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- USE customer_analysis;
-- select * from customer_analysis.customer_shopping_behavior_cleaned;

SELECT COUNT(*) FROM customer_shopping_behavior_cleaned;
SELECT * FROM customer_shopping_behavior_cleaned LIMIT 10;

-- Business Overview
SELECT 
    COUNT(*) AS total_customers,
    SUM(purchase_amount) AS total_revenue,
    AVG(purchase_amount) AS avg_order_value
FROM customer_shopping_behavior_cleaned;

-- Customer Segmentation
SELECT 
    is_repeat,
    COUNT(*) AS customers,
    AVG(purchase_amount) AS avg_spend
FROM customer_shopping_behavior_cleaned
GROUP BY is_repeat;

-- Top Customers
SELECT 
    customer_id,
    SUM(purchase_amount) AS total_spent
FROM customer_shopping_behavior_cleaned
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- Category Performance
SELECT 
    category,
    SUM(purchase_amount) AS revenue
FROM customer_analysis.customer_shopping_behavior_cleaned
GROUP BY category
ORDER BY revenue DESC;

-- Discount Impact
SELECT 
    has_discount,
    COUNT(*) AS total_orders,
    AVG(purchase_amount) AS avg_value
FROM customer_analysis.customer_shopping_behavior_cleaned
GROUP BY has_discount;

-- Location Analsys
SELECT 
    location,
    SUM(purchase_amount) AS revenue
FROM customer_analysis.customer_shopping_behavior_cleaned
GROUP BY location
ORDER BY revenue DESC;

-- Rating Impact
SELECT 
    review_rating,
    AVG(purchase_amount) AS avg_spending
FROM customer_analysis.customer_shopping_behavior_cleaned
GROUP BY review_rating
ORDER BY review_rating DESC;

-- Subscription Impact
SELECT 
    subscription_status,
    COUNT(*) AS customers,
    AVG(purchase_amount) AS avg_spending
FROM customer_analysis.customer_shopping_behavior_cleaned
GROUP BY subscription_status;

-- Customer Value Segmentation
SELECT 
    CASE 
        WHEN customer_value > 3000 THEN 'High Value'
        WHEN customer_value BETWEEN 1500 AND 3000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS segment,
    COUNT(*) AS customers
FROM customer_analysis.customer_shopping_behavior_cleaned
GROUP BY segment;

-- Window Function
SELECT 
    customer_id,
    purchase_amount,
    RANK() OVER (ORDER BY purchase_amount DESC) AS rank_position
FROM customer_analysis.customer_shopping_behavior_cleaned;