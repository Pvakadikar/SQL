create database E_commerce;

USE E_commerce;

CREATE TABLE customers (
    customer_id INT NOT NULL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    email VARCHAR(50),
    shipping_address VARCHAR(80)
);


create table products (
 product_id INT NOT NULL PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    description VARCHAR(80),
    price DECIMAL NOT NULL,
    stock_quantity INT
);

create table orders (
 order_id INT NOT NULL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

create table orders_details (
 order_detail_id INT NOT NULL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    qty INT NOT NULL,
    order_price DECIMAL NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),  
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

 
-- Update total_amount in Orders table
UPDATE Orders
SET total_amount = (
  SELECT SUM(qty * order_price)
  FROM Orders_Details
  WHERE Orders_Details.order_id = Orders.order_id
);

-- Questions
-- 1. Retrieve the order ID, customer IDs and customer names and total amounts for orders that have a total amount greater than $1000.

SELECT orders.order_id, customers.customer_id, customers.customer_name, orders.total_amount
FROM orders
INNER JOIN customers
ON orders.customer_id = customers.customer_id
WHERE orders.total_amount > 1000;

-- 2. Retrieve the total quantity of each product sold.
SELECT p.product_name, sum(od.qty) AS total_quantity_sold
FROM orders_details od
JOIN products p ON p.product_id = od.product_id
GROUP BY p.product_id;

--  3. Retrieve the order details (order ID, product name, quantity) for orders with a quantity greater than the average quantity of all orders.

Select Order_ID, p.Product_Name, Qty
From Orders_Details as o
Inner Join Products as p
On o.product_id=p.product_id
Where Qty> (Select Avg(Qty) From Orders_Details);

-- 4. Retrieve the order IDs and the number of unique products included in each order.

SELECT Order_ID, COUNT(DISTINCT Product_ID) AS Unique_Products
FROM Orders_Details
GROUP BY Order_ID;

-- 5. Retrieve the total number of products sold for each month in the year 2023. Display the month along with the total number of products.

SELECT EXTRACT(MONTH FROM Order_Date) AS Month, 
SUM(Qty) AS Total_Products_Sold 
FROM Orders 
JOIN Orders_Details 
ON Orders.Order_ID = Orders_Details.Order_ID 
WHERE EXTRACT(YEAR FROM Order_Date) = 2023 
GROUP BY EXTRACT(MONTH FROM Order_Date) ORDER BY Month;

-- 6. Retrieve the total number of products sold for each month in the year 2023 where the total number of products sold were greater than 2. Display the month along with the total number of products.

SELECT EXTRACT(MONTH FROM Order_Date) AS Month,
SUM(Qty) AS Total_Products_Sold
FROM Orders JOIN Orders_Details ON Orders.Order_ID = Orders_Details.Order_ID
WHERE EXTRACT(YEAR FROM Order_Date) = 2023
GROUP BY EXTRACT(MONTH FROM Order_Date)
HAVING SUM(Qty) > 2;

--  7. Retrieve the order IDs and the order amount based on the following criteria:
-- a. If the total_amount > 1000 then ‘High Value’
-- b. If it is less than or equal to 1000 then ‘Low Value’
-- c. Output should be — order IDs, order amount and Value

SELECT order_id, total_amount, 
 CASE 
  WHEN total_amount > 1000 
  THEN 'High Value' 
  ELSE 'Low Value' 
 END AS Value 
FROM Orders;

--  8. Retrieve the order IDs and the order amount based on the following criteria:
-- a. If the total_amount > 1000 then ‘High Value’
-- b. If it is less than 1000 then ‘Low Value’
-- c. If it is equal to 1000 then ‘Medium Value’
-- Also, please only print the ‘High Value’ products. Output should be — order IDs, order amount and Value

SELECT order_id, total_amount, order_value
FROM (
SELECT order_id,
total_amount,
CASE
 WHEN total_amount > 1000 THEN 'High Value'
 WHEN total_amount = 1000 THEN 'Medium Value'
 ELSE 'Low Value'
END AS order_value
FROM Orders) as sub
WHERE order_value = 'High Value';


