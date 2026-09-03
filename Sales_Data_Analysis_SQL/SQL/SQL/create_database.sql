CREATE DATABASE sales_analysis_db;
USE sales_analysis_db;
SHOW DATABASES;
SELECT DATABASE();
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    age INT,
    city VARCHAR(50),
    state VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(15)
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2),
    cost_price DECIMAL(10,2)
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE,
    total_amount DECIMAL(10,2),
    order_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATE,
    payment_method VARCHAR(20),
    payment_status VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

SHOW TABLES;

DESCRIBE Customers;