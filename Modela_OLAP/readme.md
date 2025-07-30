# 🧠 ¿Qué es OLAP?

OLAP significa Procesamiento Analítico en Línea , o en español: Procesamiento Analítico en Línea .

OLAP se utiliza para analizar grandes cantidades de datos de manera rápida y desde diferentes perspectivas.

 🔍 Mientras que SQL "normal" (OLTP) se usa para transacciones (insertar, borrar, actualizar), OLAP se usa para análisis . Piensa en reportes , estadísticas , resúmenes , etc.

---

# 📦 Imagina una caja de Rubik (cubos OLAP)

 Un cubo OLAP es como una caja de Rubik, pero en lugar de colores tiene datos . Cada cara o dimensión del cubo representa una forma distinta de ver los datos .

> Por ejemplo, supón que tienes una empresa que vende productos y quieres analizar tus ventas:

## Dimensiones (lados del cubo) :

- 🗓️ Tiempo (año, trimestre, mes)

- 🏬 Tienda (sede, ciudad)

- 📦 Producto (categoría, marca)

## Medida (número que analiza) :

- 💰 Ventas (total de dinero)

---

# 🛠️ Operaciones comunes en OLAP:

Puedes ver el script SQL completo de creación de tablas y relaciones en el archivo.

Ubicado en la carpeta:

📂 Carpeta: `Modelo_OLAP`

📜 [`test_schema_00.sql`](https://github.com/DrMachDev/SQL/blob/main/Modela_OLAP/test_schema_00.sql)
📜 [`test_schema_01.sql`](https://github.com/DrMachDev/SQL/blob/main/Modela_OLAP/test_schema_01.sql)

Modelado y carga de datos.

<details>
<summary>Ver código SQL (haz clic para desplegar)</summary>
    
```
-- Crear esquema
DROP SCHEMA IF EXISTS Operaciones_OLAP;
CREATE SCHEMA Operaciones_OLAP;
USE Operaciones_OLAP;

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
```
</details>

## Slicing (rebanar):

Ver solo un mes específico.
> Ejemplo: Ventas por producto y tienda en 2023.

<details>
<summary>Ver código SQL (haz clic para desplegar)</summary>
    
```
SELECT f.product_id, f.store_id, SUM(f.sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
WHERE d.year = 2023
GROUP BY f.product_id, f.store_id
ORDER BY total_sales DESC;
``` 
</details> 

> Ejemplo: Filtrar por un subconjunto (Año 2024).

<details>
<summary>Ver código SQL (haz clic para desplegar)</summary>
    
```
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
``` 
</details> 

## Dicing :

Filtrar más de una dimensión.
> Ejemplo: Ventas por tienda y mes para Laptops en 2023 .

<details>
<summary>Ver código SQL (haz clic para desplegar)</summary>
    
```
SELECT f.store_id, d.month, SUM(f.sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
WHERE d.year = 2023 AND f.product_id = 1
GROUP BY f.store_id, d.month
ORDER BY f.store_id, d.month;
```
</details>

> Ejemplo: Filtrado por múltiples dimensiones (Año 2024 y producto_id = 1).

<details>
<summary>Ver código SQL (haz clic para desplegar)</summary>
    
```
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
```
</details>

## Roll Up :

Subir el nivel de detalle.
> Ejemplo: Ventas por año y mes con subtotal.

<details>
<summary>Ver código SQL (haz clic para desplegar)</summary>
    
```
SELECT d.year, d.month, SUM(f.sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month WITH ROLLUP;
```
</details>

> Ejemplo: Agregación jerárquica de Año y Mes.

<details>
<summary>Ver código SQL (haz clic para desplegar)</summary>
    
```
SELECT 
    year, 
    month, 
    SUM(sales_amount) AS total_sales
FROM fact_sales
JOIN dim_date ON fact_sales.date_id = dim_date.date_id
GROUP BY year, month WITH ROLLUP;
```
</details>

## Drill Down:

Bajar el nivel de detalle.
> Ejemplo: Total ventas por año y mes.

<details>
 
<summary>Ver código SQL (haz clic para desplegar)</summary>
    
```
SELECT d.year, d.month, SUM(f.sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month
ORDER BY d.year, d.month;

```
</details>
