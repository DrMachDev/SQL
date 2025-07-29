-- Crear esquema
DROP SCHEMA IF EXISTS test_schema;
CREATE SCHEMA test_schema;
USE test_schema;

-- DIMENSIÓN: FECHA
DROP TABLE IF EXISTS dim_date;
CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE NOT NULL,
    year INT NOT NULL,
    quarter INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    day_of_week INT NOT NULL,
    is_holiday BOOLEAN NOT NULL
) ENGINE = InnoDB;

-- DIMENSIÓN: PRODUCTO
DROP TABLE IF EXISTS dim_product;
CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    subcategory VARCHAR(100),
    brand VARCHAR(100),
    price DECIMAL(10, 2)
) ENGINE = InnoDB;

-- DIMENSIÓN: TIENDA
DROP TABLE IF EXISTS dim_store;
CREATE TABLE dim_store (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    region VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
) ENGINE = InnoDB;

-- TABLA DE HECHOS: VENTAS
DROP TABLE IF EXISTS fact_sales;
CREATE TABLE fact_sales (
    sales_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    date_id INT,
    product_id INT,
    store_id INT,
    sales_amount DECIMAL(10, 2),
    quantity_sold INT,

    CONSTRAINT fk_sales_date FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    CONSTRAINT fk_sales_product FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    CONSTRAINT fk_sales_store FOREIGN KEY (store_id) REFERENCES dim_store(store_id)
) ENGINE = InnoDB;

-- ===========================
-- 🚀 CARGA DE DATOS
-- ===========================

-- Fecha
INSERT INTO dim_date VALUES
(1, '2023-01-01', 2023, 1, 1, 1, 7, TRUE),
(2, '2023-01-02', 2023, 1, 1, 2, 1, FALSE),
(3, '2023-02-01', 2023, 1, 2, 1, 3, FALSE),
(4, '2023-02-15', 2023, 1, 2, 15, 3, FALSE),
(5, '2023-03-01', 2023, 1, 3, 1, 3, FALSE),
(6, '2023-03-31', 2023, 1, 3, 31, 5, FALSE),
(7, '2023-04-01', 2023, 2, 4, 1, 6, FALSE),
(8, '2023-04-30', 2023, 2, 4, 30, 7, TRUE);

-- Producto
INSERT INTO dim_product VALUES
(1, 'Laptop', 'Electronics', 'Computers', 'BrandA', 999.99),
(2, 'Smartphone', 'Electronics', 'Mobile Phones', 'BrandB', 699.99),
(3, 'Tablet', 'Electronics', 'Tablets', 'BrandC', 399.99),
(4, 'Smartwatch', 'Electronics', 'Wearables', 'BrandD', 199.99),
(5, 'Headphones', 'Electronics', 'Audio', 'BrandE', 149.99);

-- Tienda
INSERT INTO dim_store VALUES
(1, 'Store A', 'North', 'New York', 'NY', 'USA'),
(2, 'Store B', 'West', 'San Francisco', 'CA', 'USA'),
(3, 'Store C', 'South', 'Miami', 'FL', 'USA'),
(4, 'Store D', 'East', 'Boston', 'MA', 'USA'),
(5, 'Store E', 'Central', 'Chicago', 'IL', 'USA');

-- Ventas
INSERT INTO fact_sales (date_id, product_id, store_id, sales_amount, quantity_sold) VALUES
(1, 1, 1, 999.99, 1),
(2, 2, 2, 1399.98, 2),
(3, 3, 3, 399.99, 1),
(4, 4, 4, 199.99, 1),
(5, 5, 5, 299.98, 2),
(6, 1, 2, 999.99, 1),
(7, 2, 3, 699.99, 1),
(8, 3, 4, 799.98, 2),
(5, 1, 5, 999.99, 1);

select*from	dim_date;
select*from	dim_product;
select*from	dim_store;
select*from	fact_sales;

-- ===========================
-- 📊 CONSULTAS OLAP
-- ===========================

-- Drill Down: Total ventas por año
SELECT d.year, SUM(f.sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year;

-- Drill Down: Total ventas por año y mes
SELECT d.year, d.month, SUM(f.sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month
ORDER BY d.year, d.month;

-- Slicing: Ventas por producto y tienda en 2023
SELECT f.product_id, f.store_id, SUM(f.sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
WHERE d.year = 2023
GROUP BY f.product_id, f.store_id
ORDER BY total_sales DESC;

-- Dicing: Ventas por tienda y mes para Laptops en 2023
SELECT f.store_id, d.month, SUM(f.sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
WHERE d.year = 2023 AND f.product_id = 1
GROUP BY f.store_id, d.month
ORDER BY f.store_id, d.month;

-- Roll Up: Ventas por año y mes con subtotal
SELECT d.year, d.month, SUM(f.sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month WITH ROLLUP;