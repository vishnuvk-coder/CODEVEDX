INSERT INTO Customers
(customer_name, gender, age, city, state, email, phone)
VALUES
('Vishnu','Male',22,'Badlapur','Maharashtra','vishnu@gmail.com','9876543210'),
('Pradnya','female',22,'Badlapur','Maharashtra','pradnya@gmail.com','9876543211'),
('Harsh','Male',22,'Ambernath','Maharashtra','harsh@gmail.com','9876543212');
SELECT * FROM Customers;
INSERT INTO Products
(product_name, category, price, cost_price)
VALUES
('Laptop','Electronics',65000,55000),
('Mouse','Electronics',800,500),
('Keyboard','Electronics',1500,1000),
('Monitor','Electronics',12000,10000),
('Headphones','Electronics',2500,1800);
SELECT * FROM Products;
INSERT INTO Orders
(customer_id, order_date, total_amount, order_status)
VALUES
(1,'2026-08-01',65800,'Completed'),
(2,'2026-08-02',800,'Completed'),
(3,'2026-08-03',1500,'Pending'),
(1,'2026-08-04',12000,'Completed'),
(2,'2026-08-05',2500,'Pending');
SELECT * FROM Orders;
INSERT INTO Order_Items
(order_id, product_id, quantity, unit_price)
VALUES
(1,1,1,65000),
(1,2,1,800),
(2,2,1,800),
(3,3,1,1500),
(4,4,1,12000),
(5,5,1,2500);
SELECT * FROM Order_Items;
INSERT INTO Payments
(order_id, payment_date, payment_method, payment_status)
VALUES
(1,'2026-08-01','UPI','Paid'),
(2,'2026-08-02','Cash','Paid'),
(3,'2026-08-03','Credit Card','Pending'),
(4,'2026-08-04','Debit Card','Paid'),
(5,'2026-08-05','UPI','Pending');
SELECT * FROM Payments;