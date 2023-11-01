SELECT *
FROM [Pizza DB Project].dbo.pizza_sales;

SELECT SUM(total_price) AS Total_Revenue
FROM [Pizza DB Project].dbo.pizza_sales;

SELECT order_id, COUNT(DISTINCT order_id) AS number_of_orders
FROM [Pizza DB Project].dbo.pizza_sales
GROUP BY order_id;

SELECT COUNT(DISTINCT order_id) AS number_of_orders
FROM [Pizza DB Project].dbo.pizza_sales;

SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_order_value
FROM [Pizza DB Project].dbo.pizza_sales;

SELECT SUM(quantity) AS total_pizzas_sold
FROM [Pizza DB Project].dbo.pizza_sales;

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM [Pizza DB Project].dbo.pizza_sales;

SELECT CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS Avg_pizzas_Per_order
FROM [Pizza DB Project].dbo.pizza_sales;

SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) AS Avg_pizzas_Per_order
FROM [Pizza DB Project].dbo.pizza_sales;

-- Daily trend for Total orders 
SELECT DATENAME(DW, order_date) AS order_day, COUNT(DISTINCT order_id) AS Total_orders
FROM [Pizza DB Project].dbo.pizza_sales
GROUP BY DATENAME(DW, order_date)
ORDER BY order_day;

-- Hourly trend for total orders
SELECT DATEPART(HOUR, order_time) AS order_hours, COUNT(DISTINCT order_id) AS Total_orders
FROM [Pizza DB Project].dbo.pizza_sales
GROUP BY DATEPART(HOUR, order_time)
ORDER BY order_hours;

-- Percentage of sales by pizza Category
SELECT pizza_category, SUM(total_price) AS Total_sales , SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS PCT
FROM [Pizza DB Project].dbo.pizza_sales
GROUP BY pizza_category
Order by Total_sales DESC;

-- Percentage of sales by pizza Category ( for the month of January)
SELECT pizza_category, SUM(total_price) AS Total_sales , SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS PCT
FROM [Pizza DB Project].dbo.pizza_sales
WHERE MONTH(order_date) = 1
GROUP BY pizza_category
Order by Total_sales DESC;

-- Percentage of sales by pizza Category ( for the first quarter of the year)
SELECT pizza_category, SUM(total_price) AS Total_sales , SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS PCT
FROM [Pizza DB Project].dbo.pizza_sales
WHERE DATEPART(QUARTER, order_date) = 1
GROUP BY pizza_category
Order by Total_sales DESC;

-- Percentage of sales by pizza size
SELECT pizza_size, SUM(total_price) AS Total_sales, SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS Percentage_sales_size
FROM [Pizza DB Project].dbo.pizza_sales
GROUP BY pizza_size
ORDER BY Percentage_sales_size DESC;

SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_sales, CAST(SUM(total_price) * 100 / 
(SELECT SUM(total_price) FROM pizza_sales WHERE DATEPART(QUARTER, order_date) = 1) AS DECIMAL(10,2)) AS Percentage_sales_size
FROM [Pizza DB Project].dbo.pizza_sales
WHERE DATEPART(QUARTER, order_date) = 1
GROUP BY pizza_size
ORDER BY Percentage_sales_size DESC;

-- Percentage of sales by pizza size in the month of January
SELECT pizza_size, SUM(total_price) AS Total_sales, SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS Percentage_sales_size
FROM [Pizza DB Project].dbo.pizza_sales
WHERE MONTH(order_date) = 1
GROUP BY pizza_size
ORDER BY Percentage_sales_size DESC;

-- Percentage of sales by pizza size in the first quarter
SELECT pizza_size, SUM(total_price) AS Total_sales, SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS Percentage_sales_size
FROM [Pizza DB Project].dbo.pizza_sales
WHERE DATEPART(QUARTER, order_date) = 1
GROUP BY pizza_size
ORDER BY Percentage_sales_size DESC;

-- Total Pizzas sold by pizza category
SELECT pizza_category, SUM(quantity) AS total_pizzas_sold
FROM [Pizza DB Project].dbo.pizza_sales
GROUP BY pizza_category
ORDER BY total_pizzas_sold DESC;

-- Top 5 Best Sellers by Total Pizzas Sold
SELECT TOP 5 pizza_name, SUM(quantity) AS total_pizzas_sold
FROM [Pizza DB Project].dbo.pizza_sales
GROUP BY pizza_name
ORDER BY total_pizzas_sold DESC;

-- Bottom 5 worst Sellers by Total Pizzas Sold
SELECT TOP 5 pizza_name, SUM(quantity) AS total_pizzas_sold
FROM [Pizza DB Project].dbo.pizza_sales
GROUP BY pizza_name
ORDER BY total_pizzas_sold ASC;

SELECT TOP 5 pizza_name, SUM(quantity) AS total_pizzas_sold
FROM [Pizza DB Project].dbo.pizza_sales
WHERE MONTH(order_date) = 1
GROUP BY pizza_name
ORDER BY total_pizzas_sold ASC;
