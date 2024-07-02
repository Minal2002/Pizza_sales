
Create database pizzahut;
Use pizzahut;
Create table orders(order_id Int not null, order_date date not null,
order_time time not null, primary key (order_id));

Create table orders_details(order_details_id Int not null, order_id Int not null,
pizza_id text not null, quantity int not null, primary key (order_details_id));
Drop table orders_details;

-- Retrieve the total number of orders placed --
Select count(order_id) FROM orders;

-- Calculate the total revenue generated from pizza sales--
SELECT round(sum(orders_details.quantity * pizzas.price),2) AS total_sales 
FROM orders_details 
JOIN pizzas ON pizzas.pizza_id = orders_details.pizza_id;

-- Identify the highest-priced pizza.--
select * from pizzas;

Select pizza_types.name, pizzas.price from pizza_types join pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id order by pizzas.price DESC LIMIT 5;

-- Identify the most common pizza size ordered --
Select count(size), size from pizzas group by Size;

Select pizzas.size, count( orders_details.order_details_id) as order_count
from pizzas join orders_details on pizzas.pizza_id = orders_details.pizza_id
group by pizzas.size order by order_count desc;

-- List the top 5 most ordered pizza types along with their quantities--

select pizza_types.name,
sum(orders_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details
on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by quantity desc limit 5 ;

-- Join the necessary tables to find the total quantity of each pizza category ordered--
select pizza_types.category,
sum(orders_details.quantity) as quantity from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details
on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by quantity desc;

-- Determine the distribution of orders by hour of the day.--
Select Hour(order_time) AS hour, count(order_id) AS order_count
From orders Group by hour (order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.--
Select category, count (name) from pizza_types group by category;                       

-- Group the orders by date and calculate the average number of pizzas ordered per day--
Select round(avg (quantity),0) from
(Select orders.order_date, sum(order_details.quantity) as quantity from
orders join order_details
on orders.order_id=order_details.order_id
group by orders.order_date) AS Order_quantity

-- Determine the top 3 most ordered pizza types based on revenue--
Select pizza_types.name,
sum(order_details.quantity* pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by revenue desc limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue.--
Select pizza_types.category,
sum (order_details.quantity*pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by revenue desc;