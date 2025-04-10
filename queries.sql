-- Query 1: Calculate Total Sales Amount Per Month
-- Uses DATE_TRUNC to group by month and SUM to aggregate sales
SELECT
    DATE_TRUNC('month', o.order_date)::DATE AS sales_month, -- Truncate to month start, cast to DATE
    SUM(oi.quantity * oi.price_per_unit) AS total_monthly_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status NOT IN ('Cancelled', 'Pending') -- Consider only completed/shipped orders for sales
GROUP BY sales_month
ORDER BY sales_month;


-- Query 2: Find Top 3 Best-Selling Products (by Quantity Sold)
-- Uses JOIN, SUM, GROUP BY, ORDER BY, LIMIT
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status NOT IN ('Cancelled', 'Pending') -- Count sales from valid orders
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 3;


-- Query 3: Rank Products Within Each Category Based on Total Sales Amount
-- Uses Window Function RANK() partitioned by category
WITH ProductSales AS (
    SELECT
        p.product_id,
        p.product_name,
        c.category_id,
        c.category_name,
        SUM(oi.quantity * oi.price_per_unit) AS total_sales_amount
    FROM products p
    JOIN categories c ON p.category_id = c.category_id
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status NOT IN ('Cancelled', 'Pending')
    GROUP BY p.product_id, p.product_name, c.category_id, c.category_name
)
SELECT
    category_name,
    product_name,
    total_sales_amount,
    RANK() OVER (PARTITION BY category_id ORDER BY total_sales_amount DESC) AS sales_rank_within_category
FROM ProductSales
ORDER BY category_name, sales_rank_within_category;


-- Query 4: Calculate Total Spending Per Customer (Simple Customer Value Metric)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    SUM(oi.quantity * oi.price_per_unit) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status NOT IN ('Cancelled', 'Pending') -- Only count completed/shipped orders
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY total_spent DESC;

-- Query 5: Simple Cohort Analysis - Customers Registered in a Month and Their Subsequent Spending
-- Find customers who registered in Jan 2025 and their total spending since registration
WITH MonthlyCohort AS (
    SELECT customer_id
    FROM customers
    WHERE DATE_TRUNC('month', registration_date)::DATE = '2025-01-01' -- Example: January 2025 cohort
)
SELECT
    mc.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.price_per_unit) AS total_spending_since_registration
FROM MonthlyCohort mc
JOIN customers c ON mc.customer_id = c.customer_id
LEFT JOIN orders o ON mc.customer_id = o.customer_id AND o.status NOT IN ('Cancelled', 'Pending')
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY mc.customer_id, c.first_name, c.last_name
ORDER BY total_spending_since_registration DESC; -- Note: This is simplified; real cohort analysis often tracks spending month-over-month post-acquisition.
