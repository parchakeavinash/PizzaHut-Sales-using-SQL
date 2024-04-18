-- Retrieve the total number of orders placed.
select count(*) as total_orders
from orders;
select count(order_id) as total_orders
from orders;

-- Calculate the total revenue generated from pizza sales. == '817860'

select  round(sum(od.quantity * ps.price)) as total_revenue
from order_details od
inner join pizzas ps
on od.pizza_id = ps.pizza_id;

-- "Q1 3"-- Identify the highest-priced pizza.
select pizza_types.name, pizza_types.category,pizzas.price
from pizzas
inner join pizza_types
on pizzas.pizza_type_id =pizza_types.pizza_type_id
order by price desc
limit 1;

-- Identify the most common pizza size ordered.
select * from pizzas;

-- select size, count(*)  as total_orders
-- from pizzas
-- group by size
-- order by total_orders desc;

select pizzas.size,count(order_details.order_details_id)as ordered_count from
pizzas 
inner join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size;

-- List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS total_quantity
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY name
ORDER BY total_quantity DESC
LIMIT 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS total_quantity
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY category
ORDER BY total_quantity DESC;

-- Determine the distribution of orders by hour of the day.
SELECT Extract(Hour from order_time) as hour_of_day, count(*) as total_orders
FROM orders
group by hour_of_day
order by hour_of_day;
-- 2-method
select hour(order_time) as hour, count(*) as order_count
from orders
group by hour
order by hour;

-- Join relevant tables to find the category-wise distribution of pizzas.
select category,count(name)  from pizza_types
group by category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(average_pizzas_ordered)) AS avg_pizza_orders
FROM
    (SELECT 
        orders.order_date,
            SUM(order_details.quantity) AS average_pizzas_ordered
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS daily_orders;


SELECT 
    ROUND(AVG(pizzas.price * order_details.quantity)) AS avg_price
FROM
    pizzas
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id; 
-- average price pizzas ordered per day
-- 138 * 17 = 2346 average profit per day

-- Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name as pizza_type , round(sum(order_details.quantity * pizzas.price)) as revenue
from pizzas
join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_type
order by revenue desc
limit 3;


-- Calculate the percentage contribution of each pizza type to total revenue.

select pizza_types.category,
round	(sum(order_details.quantity * pizzas.price)/ (select  round(sum(order_details.quantity * pizzas.price),2)
 as total_sales
from order_details 
join pizzas 
on order_details.pizza_id = pizzas.pizza_id) * 100,2) as revenue
from pizzas
join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by revenue desc;


-- Analyze the cumulative revenue generated over time.
select order_date,
sum(revenue) over(order by order_date) as cum_revenue
from
(select orders.order_date, 
sum(order_details.quantity * pizzas.price) as revenue
from 
pizzas
join order_details
on pizzas.pizza_id = order_details.pizza_id
join orders
on order_details.order_id = orders.order_id
group by orders.order_date) as sales;