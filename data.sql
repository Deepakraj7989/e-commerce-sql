-- Insert Categories
INSERT INTO categories (category_name) VALUES
('Electronics'),
('Books'),
('Clothing');

-- Insert Customers (adjust dates as needed for analysis)
-- Assume current date is around 2025-04-10
INSERT INTO customers (first_name, last_name, email, registration_date, city, country) VALUES
('Alice', 'Smith', 'alice.s@email.com', '2024-11-15 10:00:00+05:30', 'Mumbai', 'India'),
('Bob', 'Jones', 'bob.j@email.com', '2025-01-20 14:30:00+05:30', 'Delhi', 'India'),
('Charlie', 'Brown', 'charlie.b@email.com', '2025-03-01 09:15:00+05:30', 'Chennai', 'India');

-- Insert Products
INSERT INTO products (product_name, description, price, category_id, stock_quantity) VALUES
('Laptop Pro 15', 'High-performance laptop', 120000.00, 1, 50),
('Quantum Computing Explained', 'A book on QC basics', 1500.50, 2, 100),
('Wireless Mouse', 'Ergonomic wireless mouse', 2500.00, 1, 200),
('Classic T-Shirt', 'Cotton T-Shirt, Black, M size', 800.00, 3, 150),
('Advanced SQL Concepts', 'Deep dive into SQL', 2200.00, 2, 75);

-- Insert Orders (Ensure dates make sense relative to customer registration)
-- Order 1: Alice, Feb 2025
INSERT INTO orders (customer_id, order_date, status, shipping_address) VALUES
(1, '2025-02-10 11:00:00+05:30', 'Delivered', '123 Tech Park, Mumbai'); -- Order ID will be 1

-- Order 2: Bob, Mar 2025
INSERT INTO orders (customer_id, order_date, status, shipping_address) VALUES
(2, '2025-03-05 16:45:00+05:30', 'Shipped', '456 Cyber Hub, Delhi'); -- Order ID will be 2

-- Order 3: Alice, Mar 2025
INSERT INTO orders (customer_id, order_date, status, shipping_address) VALUES
(1, '2025-03-20 09:30:00+05:30', 'Processing', '123 Tech Park, Mumbai'); -- Order ID will be 3

-- Insert Order Items (Match product prices at the time of order)
-- Items for Order 1 (Laptop + Book)
INSERT INTO order_items (order_id, product_id, quantity, price_per_unit) VALUES
(1, 1, 1, 120000.00), -- Laptop
(1, 2, 1, 1500.50);   -- QC Book

-- Items for Order 2 (Mouse + T-Shirt)
INSERT INTO order_items (order_id, product_id, quantity, price_per_unit) VALUES
(2, 3, 1, 2500.00),  -- Mouse
(2, 4, 2, 800.00);   -- 2 T-shirts

-- Items for Order 3 (SQL Book + Mouse)
INSERT INTO order_items (order_id, product_id, quantity, price_per_unit) VALUES
(3, 5, 1, 2200.00), -- SQL Book
(3, 3, 1, 2500.00);  -- Mouse

-- Optional: Update order total amounts (Alternatively, calculate on the fly or use triggers)
UPDATE orders SET total_amount = (SELECT SUM(quantity * price_per_unit) FROM order_items WHERE order_id = 1) WHERE order_id = 1;
UPDATE orders SET total_amount = (SELECT SUM(quantity * price_per_unit) FROM order_items WHERE order_id = 2) WHERE order_id = 2;
UPDATE orders SET total_amount = (SELECT SUM(quantity * price_per_unit) FROM order_items WHERE order_id = 3) WHERE order_id = 3;



