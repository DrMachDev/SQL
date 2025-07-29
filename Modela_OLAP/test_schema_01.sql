USE test_schema;

-- Insertar datos en la tabla de dimensiones de fechas
INSERT INTO dim_date (date_id, full_date, year, quarter, month, day, day_of_week, is_holiday)
VALUES
    (9, '2024-01-01', 2024, 1, 1, 1, 1, FALSE),
    (10, '2024-01-02', 2024, 1, 1, 2, 2, FALSE);  -- Nota: día de la semana corregido a 2 para 02/01/2024
SELECT*FROM dim_date;
-- Insertar datos en la tabla de hechos de ventas
INSERT INTO fact_sales (date_id, product_id, store_id, sales_amount, quantity_sold)
VALUES
    (9, 1, 1, 999.99, 1),     -- Venta de una Laptop en Store A el 2024-01-01
    (10, 2, 2, 1399.98, 2);   -- Venta de dos Smartphones en Store B el 2024-01-02


-- DRILL DOWN: Análisis jerárquico desde año hasta mes
-- 1. Ventas por Año
SELECT year, SUM(sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY year
ORDER BY year;

-- 2. Ventas por Año y Mes
SELECT year, month, SUM(sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY year, month
ORDER BY year, month DESC;


-- Funciones adicionales de agregación sobre dim_date
SELECT
    month, 
    COUNT(*) AS total_days,
    SUM(is_holiday) AS num_holidays,
    AVG(is_holiday) AS avg_holidays,
    MAX(is_holiday) AS max_holiday,
    MIN(is_holiday) AS min_holiday
FROM dim_date
GROUP BY month;

-- Ordenar tiendas por región
SELECT *
FROM dim_store
ORDER BY region;


-- SLICING: Filtrar por un subconjunto (Año 2024)
SELECT 
    fact_sales.product_id, 
    product_name, 
    store_id, 
    SUM(sales_amount) AS total_sales
FROM fact_sales
JOIN dim_date ON fact_sales.date_id = dim_date.date_id
JOIN dim_product ON fact_sales.product_id = dim_product.product_id
WHERE year = 2024
GROUP BY fact_sales.product_id, product_name, store_id
ORDER BY total_sales DESC;


-- DICING: Filtrado por múltiples dimensiones (Año 2024 y producto_id = 1)
SELECT 
    fact_sales.store_id, 
    store_name, 
    month, 
    SUM(sales_amount) AS total_sales
FROM fact_sales
JOIN dim_date ON fact_sales.date_id = dim_date.date_id
JOIN dim_store ON fact_sales.store_id = dim_store.store_id
WHERE year = 2024 AND fact_sales.product_id = 1
GROUP BY fact_sales.store_id, store_name, month
ORDER BY store_id, month;


-- ROLL UP: Agregación jerárquica de Año y Mes
SELECT 
    year, 
    month, 
    SUM(sales_amount) AS total_sales
FROM fact_sales
JOIN dim_date ON fact_sales.date_id = dim_date.date_id
GROUP BY year, month WITH ROLLUP;