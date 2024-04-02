--Query 1: Get the names of customers who have made more than 5 orders along with the names of the products they’ve ordered, sorted by the customer’s name.

SELECT c.name AS customer_name, p.name AS product_name
FROM Customers c
JOIN Orders o 
ON c.customer_id = o.customer_id
JOIN Products p 
ON o.product_id = p.product_id
WHERE c.customer_id IN (
  SELECT customer_id 
  FROM Orders
  GROUP BY customer_id
  HAVING COUNT(order_id) > 5
)
ORDER BY c.name;

 

--Query 2: Get the names of customers and products along with the order date for orders made after ‘2024-02-15’, sorted by order date

SELECT c.name AS customer_name,p.name AS product_name, order_date
FROM Orders o
Join public.customers c
ON o.customer_id=c.customer_id
Join public.products p
ON o.product_id=p.product_id
WHERE order_date > '2024-02-15'
Order by order_date;


--Query 3: Products Never Ordered

SELECT p.product_id, p.name
FROM public.Products p
LEFT JOIN Orders o 
ON p.product_id = o.product_id
WHERE o.order_id IS NULL;


 
--Query 4: Get the total revenue generated from each product

SELECT 
    p.name AS product_name,
    SUM(p.unit_price) AS total_revenue
FROM 
    Orders o
JOIN 
    Products p 
ON o.product_id = p.product_id
GROUP BY 
    product_name;


--Query 5: Total Sales Per Product

Select p.product_id, p.name, Sum(unit_price) AS Total_Sales
From public.orders o
Join public.products p
ON o.product_id=p.product_id
Group by p.product_id, p.name
Order By p.product_id, p.name ASC;

 
--Query 6: Get the total number of orders per location (CTE)

WITH location_orders AS (
  SELECT location_id, COUNT(order_id) as total_orders
  FROM Orders
  GROUP BY location_id
)
SELECT Location.name, location_orders.total_orders
FROM Location
JOIN location_orders 
ON Location.location_id = location_orders.location_id;


--Query 7: Total Revenue Per Location

SELECT l.name, SUM(p.unit_price) AS Total_Revenue
FROM public.orders o
Join public.location l
ON o.location_id=l.location_id
JOIN public.products p
ON o.product_id=p.product_id
GROUP BY l.name;


--Query 8: Create a view that shows the total sales per customer

Create View customer_sales AS
SELECT 
    c.name AS customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(p.unit_price) AS total_sales
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    products p ON o.product_id = p.product_id
GROUP BY 
    c.name
ORDER BY
    c.name;


 

--Query 9: Average Order Value

SELECT AVG(unit_price) as avg_order_value
FROM Orders o
JOIN Products p 
ON o.product_id = p.product_id;


--Query 10: Create a view to get the details of all orders, including the customer name, product name, unit price, location name, and order date.

Create View order_details AS 
SELECT 
    o.order_id,
    c.name AS customer_name,
    p.name AS product_name,
    p.unit_price,
    l.name AS location_name,
    o.order_date
FROM 
    Orders o
JOIN 
    Customers c ON o.customer_id = c.customer_id
JOIN 
    Products p ON o.product_id = p.product_id
JOIN 
    Location l ON o.location_id = l.location_id;



