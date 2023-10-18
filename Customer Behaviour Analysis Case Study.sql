CREATE DATABASE dannys_diner;

USE dannys_diner;

CREATE TABLE Sales (
	Customer_id VARCHAR(1),
	Order_date DATE,
	product_id INT
);

INSERT INTO Sales (Customer_id, Order_date, product_id)
VALUES ( 'A', '2021-01-01', 1),
       ( 'A', '2021-01-01', 2),
	   ( 'A', '2021-01-07', 3),
	   ( 'A', '2021-01-10', 3),
	   ( 'A', '2021-01-11', 3),
	   ( 'A', '2021-01-11', 3),
	   ( 'B', '2021-01-01', 2),
	   ( 'B', '2021-01-02', 2),
	   ( 'B', '2021-01-04', 1),
	   ( 'B', '2021-01-11', 1),
	   ( 'B', '2021-01-16', 3),
	   ( 'B', '2021-02-01', 3),
	   ( 'C', '2021-01-01', 3),
	   ( 'C', '2021-01-01', 3),
	   ( 'C', '2021-01-07', 3);

CREATE TABLE menu (
	Product_id INT, 
	Product_name VARCHAR(5),
	Price INT
);

INSERT INTO menu (Product_id, Product_name, Price)
VALUES (1, 'sushi', 10),
       (2, 'curry', 15),
	   (3, 'ramen', 12);

CREATE TABLE members (
	customer_id VARCHAR(1),
	join_date DATE
);

INSERT INTO members (customer_id, join_date)
VALUES ('A', '2021-01-07'),
       ('A', '2021-01-09');

-- The total amount each customer spent at the restaurant
SELECT Sa.Customer_id, SUM(mu.Price) AS total_price
FROM dannys_diner.dbo.Sales Sa
JOIN dannys_diner.dbo.menu mu
	ON Sa.product_id = mu.Product_id
GROUP BY Sa.Customer_id
ORDER BY Customer_id;

-- The number of days each customer has visited the restaurant
SELECT DISTINCT  Customer_id,  COUNT(DISTINCT Order_date) AS Number_of_days
FROM dannys_diner.dbo.Sales 
GROUP BY Customer_id
ORDER BY Customer_id

-- The first item from the menu purchased by each customer
WITH customer_first_purchase AS (
SELECT Sa.Customer_id, MIN(Order_date) AS first_purchase_date
FROM dannys_diner.dbo.Sales Sa
GROUP BY Sa.Customer_id
)
SELECT cfp.Customer_id, cfp.first_purchase_date, mu.Product_name
FROM customer_first_purchase cfp
JOIN Sales Sa
	ON cfp.Customer_id = Sa.Customer_id
AND cfp.first_purchase_date = Sa.Order_date
JOIN menu mu
	ON mu.Product_id = Sa.product_id

--The most purchased item on the menu and the number of times it was purchased by each customer
SELECT TOP 1 mu.product_name, COUNT(*) AS no_times_purchased
FROM dannys_diner.dbo.Sales Sa
JOIN menu mu
	ON Sa.product_id = mu.Product_id
GROUP BY mu.Product_name
ORDER BY no_times_purchased DESC;

SELECT TOP 3 mu.product_name, COUNT(*) AS no_times_purchased
FROM dannys_diner.dbo.Sales Sa
JOIN menu mu
	ON Sa.product_id = mu.Product_id
GROUP BY mu.Product_name
ORDER BY no_times_purchased DESC;

-- The item that is the most popular for each customer
WITH customer_popularity AS (
	SELECT Sa.Customer_id, mu.product_name, COUNT(*) AS purchase_count,
	DENSE_RANK() OVER (PARTITION BY Sa.Customer_id ORDER BY COUNT(*) DESC) AS rank
	FROM dannys_diner.dbo.Sales Sa
	JOIN menu mu
		ON Sa.product_id = mu.Product_id
	GROUP BY Sa.Customer_id, mu.Product_name
)
SELECT cp.Customer_id, cp.Product_name, cp.purchase_count
FROM customer_popularity CP
WHERE rank = 1;

-- The item purchased first by the customer after becoming a member
WITH first_purchase_after_membership AS (
SELECT Sa.Customer_id, MIN(Sa.Order_date) AS first_purchase_date
FROM Sales Sa
JOIN members mb
	ON Sa.Customer_id = mb.customer_id
WHERE Order_date >= join_date
GROUP BY Sa.Customer_id
)
SELECT fpam.Customer_id, mu.Product_name
FROM first_purchase_after_membership fpam
JOIN Sales Sa
	ON Sa.Customer_id = fpam.Customer_id
AND Sa.Order_date = fpam.first_purchase_date
JOIN menu mu
	ON mu.Product_id = Sa.product_id

-- The item purchased just before the customer became a member
WITH purchase_before_membership AS (
SELECT Sa.Customer_id, MAX(Sa.Order_date) AS last_purchase_date
FROM Sales Sa
JOIN members mb
	ON Sa.Customer_id = mb.customer_id
WHERE Sa.Order_date < mb.join_date
GROUP BY Sa.Customer_id
)
SELECT pbm.Customer_id, mu.Product_name
FROM purchase_before_membership pbm
JOIN Sales Sa
	ON pbm.Customer_id = Sa.Customer_id
AND pbm.last_purchase_date = Sa.Order_date
JOIN menu mu
	ON mu.Product_id = Sa.product_id

-- The total items and amount spent for each member before they became member
SELECT Sa.Customer_id, COUNT(*) AS total_items, SUM(Price) AS total_spent
FROM Sales Sa
JOIN menu mu
	ON Sa.product_id = mu.Product_id
JOIN members mb
	ON Sa.Customer_id = mb.customer_id
WHERE Sa.Order_date < mb.join_date
GROUP BY Sa.Customer_id

-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier, how many points would each customer have?
SELECT Sa.Customer_id, SUM(
	 CASE 
	    WHEN mu.Product_name = 'sushi' THEN mu.Price * 20
		ELSE mu.Price * 10
	 END ) AS total_Points
FROM Sales Sa
JOIN menu mu
	ON Sa.product_id = mu.Product_id
GROUP BY Sa.Customer_id

DELETE FROM members
WHERE join_date = '2021-01-09';

INSERT INTO members
VALUES ('B', '2021-01-09');

-- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SELECT Sa.Customer_id, SUM (
		CASE 
		   WHEN Sa.order_date BETWEEN mb.join_date AND DATEADD(day, 7, mb.join_date)
		   THEN mu.Price * 20
		   WHEN mu.product_name = 'sushi' THEN mu.price * 20
		   ELSE mu.price * 10
		END) AS total_points
FROM Sales Sa
JOIN menu mu
	ON Sa.product_id = mu.Product_id
LEFT JOIN members mb
	ON Sa.customer_id = mb.customer_id
WHERE Sa.Customer_id IN ('A', 'B') AND Sa.Order_date <= '2021-01-31'
GROUP BY Sa.Customer_id
 
-- Recreating the table output using the available data
SELECT Sa.Customer_id, Sa.Order_date, mu.Product_name, mu.Price, 
	CASE 
	   WHEN Sa.Order_date >= mb.join_date THEN 'Y'
	   ELSE 'N'
	END AS members
FROM Sales Sa
JOIN menu mu
	ON Sa.product_id = mu.Product_id
JOIN members mb
	ON Sa.Customer_id = mb.customer_id

-- Rank all things
WITH customers_data AS (
	SELECT Sa.Customer_id, Sa.Order_date, mu.Product_name, mu.Price, 
	  CASE 
		WHEN Sa.Order_date < mb.join_date THEN 'N'
		WHEN Sa.Order_date >= mb.join_date THEN 'Y'
		ELSE 'N'
	  END AS member
	FROM Sales Sa
	LEFT JOIN members mb
		ON Sa.Customer_id = mb.customer_id
	JOIN menu mu
		ON Sa.product_id = mu.Product_id
)
SELECT *, 
	CASE 
		WHEN member = 'N' THEN NULL
		ELSE RANK() OVER (PARTITION BY customer_id, member ORDER BY order_date)
	END AS ranking
	FROM customers_data
	ORDER BY Customer_id, Order_date