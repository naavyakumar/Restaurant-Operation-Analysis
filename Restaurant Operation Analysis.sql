CREATE DATABASE restaurant_db;
USE restaurant_db;
SELECT * FROM order_details;
/* =====================================================
   OBJECTIVE 1: Explore menu_items table
===================================================== */

-- 1. View all menu items
SELECT * 
FROM menu_items;

-- 2. Count total number of items
SELECT COUNT(*) AS total_items 
FROM menu_items;

-- 3. Least expensive item
SELECT * 
FROM menu_items
ORDER BY price ASC
LIMIT 1;

-- 4. Most expensive item
SELECT * 
FROM menu_items
ORDER BY price DESC
LIMIT 1;

-- 5. Number of Italian dishes
SELECT COUNT(*) AS italian_dishes
FROM menu_items
WHERE category = 'Italian';

-- 6. Least expensive Italian dish
SELECT * 
FROM menu_items
WHERE category = 'Italian'
ORDER BY price ASC
LIMIT 1;

-- 7. Most expensive Italian dish
SELECT * 
FROM menu_items
WHERE category = 'Italian'
ORDER BY price DESC
LIMIT 1;

-- 8. Number of dishes in each category
SELECT category, COUNT(menu_item_id) AS num_dishes
FROM menu_items
GROUP BY category;

-- 9. Average price per category
SELECT category, AVG(price) AS avg_price
FROM menu_items
GROUP BY category;


/* =====================================================
   OBJECTIVE 2: Explore order_details table
===================================================== */

-- 1. View order details
SELECT * 
FROM order_details;

-- 2. Date range of orders
SELECT 
    MIN(order_date) AS start_date,
    MAX(order_date) AS end_date
FROM order_details;

-- 3. Total number of unique orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM order_details;

-- 4. Total number of items ordered
SELECT COUNT(*) AS total_items_ordered
FROM order_details;

-- 5. Orders with most number of items
SELECT 
    order_id, 
    COUNT(item_id) AS num_items
FROM order_details
GROUP BY order_id
ORDER BY num_items DESC;

-- 6. Number of orders having more than 12 items
SELECT COUNT(*) AS num_orders
FROM (
    SELECT order_id, COUNT(item_id) AS num_items
    FROM order_details
    GROUP BY order_id
    HAVING COUNT(item_id) > 12
) AS subquery;


/* =====================================================
   OBJECTIVE 3: Business Insights & Analysis
===================================================== */

-- 1. Total revenue
SELECT 
    SUM(m.price) AS total_revenue
FROM order_details o
JOIN menu_items m 
ON o.item_id = m.menu_item_id;

-- 2. Revenue per category
SELECT 
    m.category,
    SUM(m.price) AS revenue
FROM order_details o
JOIN menu_items m 
ON o.item_id = m.menu_item_id
GROUP BY m.category
ORDER BY revenue DESC;

-- 3. Top 5 most ordered items
SELECT 
    m.item_name,
    COUNT(o.item_id) AS times_ordered
FROM order_details o
JOIN menu_items m 
ON o.item_id = m.menu_item_id
GROUP BY m.item_name
ORDER BY times_ordered DESC
LIMIT 5;

-- 4. Least ordered items
SELECT 
    m.item_name,
    COUNT(o.item_id) AS times_ordered
FROM order_details o
JOIN menu_items m 
ON o.item_id = m.menu_item_id
GROUP BY m.item_name
ORDER BY times_ordered ASC
LIMIT 5;

-- 5. Top 5 highest revenue generating items
SELECT 
    m.item_name,
    SUM(m.price) AS revenue
FROM order_details o
JOIN menu_items m 
ON o.item_id = m.menu_item_id
GROUP BY m.item_name
ORDER BY revenue DESC
LIMIT 5;

-- 6. Daily revenue trend
SELECT 
    o.order_date,
    SUM(m.price) AS daily_revenue
FROM order_details o
JOIN menu_items m 
ON o.item_id = m.menu_item_id
GROUP BY o.order_date
ORDER BY o.order_date;

-- 7. Average order value
SELECT 
    AVG(order_total) AS avg_order_value
FROM (
    SELECT 
        o.order_id,
        SUM(m.price) AS order_total
    FROM order_details o
    JOIN menu_items m 
    ON o.item_id = m.menu_item_id
    GROUP BY o.order_id
) AS sub;

-- 8. Top 5 highest spending orders
SELECT 
    o.order_id,
    SUM(m.price) AS total_spent
FROM order_details o
JOIN menu_items m 
ON o.item_id = m.menu_item_id
GROUP BY o.order_id
ORDER BY total_spent DESC
LIMIT 5;

-- 9. Category-wise popularity
SELECT 
    m.category,
    COUNT(o.item_id) AS total_items_sold
FROM order_details o
JOIN menu_items m 
ON o.item_id = m.menu_item_id
GROUP BY m.category
ORDER BY total_items_sold DESC;

-- 10. Month-wise revenue
SELECT 
    MONTH(o.order_date) AS month,
    SUM(m.price) AS revenue
FROM order_details o
JOIN menu_items m 
ON o.item_id = m.menu_item_id
GROUP BY MONTH(o.order_date)
ORDER BY month;