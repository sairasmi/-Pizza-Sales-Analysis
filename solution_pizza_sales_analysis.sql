use  pizza_sales_analysis;
-- Sales Analysis
-- The total number of order place
SELECT COUNT(1) FROM orders;
-- The total revenue generated from pizza sale
SELECT 
    SUM(order_details.quantity * pizza.price) AS 'Total Revenue'
FROM
    order_details
        JOIN
    pizza ON order_details.pizza_id = pizza.pizza_id;
-- The highest priced pizza.
SELECT pizza_type.name, pizza.price
FROM
    pizza_type
        JOIN
    pizza
WHERE
    pizza_type.pizza_type_id = pizza.pizza_type_id
ORDER BY price DESC limit 1;
-- Product Performance
-- The most common pizza size ordered.
SELECT 
    pizza.size, SUM(order_details.quantity) AS total_quantity
FROM
    order_details
        JOIN
    pizza ON order_details.pizza_id = pizza.pizza_id
GROUP BY pizza.size limit 1;

-- The top 5 most ordered pizza types along their quantities
SELECT 
    pt.pizza_type_id AS pizza_type,
    pt.name,
    SUM(quantity) AS total_order_quantities
FROM
    order_details ord
        JOIN
    pizza pz ON ord.pizza_id = pz.pizza_id
        JOIN
    pizza_type pt ON pz.pizza_type_id = pt.pizza_type_id
GROUP BY pt.pizza_type_id
ORDER BY total_order_quantities DESC
LIMIT 5;

-- The quantity of each pizza categories ordered
select pt.category,sum(quantity) as total_order_quantity from order_details ord
join
pizza pz on ord.pizza_id=pz.pizza_id
join
pizza_type pt on pt.pizza_type_id=pz.pizza_type_id
group by pt.category;
-- Customer Behavior
-- The distribution of orders by hours of the day.
SELECT 
    HOUR(time) AS distribution_hour, COUNT(*) AS Total_order
FROM
    orders
GROUP BY distribution_hour
ORDER BY distribution_hour;
-- The category-wise distribution of pizzas.
SELECT pt.category, COUNT(p.pizza_id) AS total_pizzas
FROM pizza p
JOIN pizza_type pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_pizzas DESC;
-- The average number of pizzas ordered per day.
SELECT 
    AVG(total_quanity)
FROM
    (SELECT 
        DATE(ord.date), SUM(quantity) AS total_quanity
    FROM
        order_details od
    JOIN orders ord ON od.order_id = od.order_id
    GROUP BY DATE(ord.date)) t;
    
    -- Top 3 most ordered pizza type base on revenue.
    
   SELECT 
    pt.name AS pizza_type,
    SUM(od.quantity * p.price) AS total_revenue
FROM
    order_details od
        JOIN
    pizza p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_type pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;
-- The percentage contribution of each pizza type to revenue.

SELECT pt.name AS pizza_type, 
       SUM(od.quantity * p.price) AS total_revenue,
       (SUM(od.quantity * p.price) / (SELECT SUM(od2.quantity * p2.price) 
                                      FROM order_details od2 
                                      JOIN pizza p2 ON od2.pizza_id = p2.pizza_id)) * 100 AS percentage_contribution
FROM order_details od
JOIN pizza p ON od.pizza_id = p.pizza_id
JOIN pizza_type pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY percentage_contribution DESC;

-- The cumulative revenue generated over time
SELECT o.date, 
       SUM(od.quantity * p.price) AS daily_revenue,
       SUM(SUM(od.quantity * p.price)) OVER (ORDER BY o.date) AS cumulative_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizza p ON od.pizza_id = p.pizza_id
GROUP BY o.date
ORDER BY o.date;
-- The top 3 most ordered pizza type based on revenue for each pizza category.
SELECT category,name, Revenue
FROM (
    SELECT
        category,name,
        SUM(pizza.price * order_details.quantity) AS Revenue,
        RANK() OVER (PARTITION BY category,name ORDER BY SUM(pizza.price * order_details.quantity) DESC) AS RA
    FROM
        pizza
    JOIN
        order_details ON pizza.pizza_id = order_details.pizza_id
    JOIN
        pizza_type ON pizza_type.pizza_type_id = pizza.pizza_type_id
    GROUP BY category,name
) AS b
WHERE RA <= 3;



﻿


