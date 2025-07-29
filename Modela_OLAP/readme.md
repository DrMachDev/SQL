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

## Rebanar (rebanar):

Ver solo un mes específico.
> Ejemplo: Ver ventas de enero de 2024 .

## Dados (cortar en cubos pequeños):

Filtrar más de una dimensión.
> Ejemplo: Ventas de laptops en Lima en 2023 .

## Enrollar (agrupar hacia arriba):

Subir el nivel de detalle.
> Ejemplo: De ventas por mes → a ventas por trimestre → a ventas por año .

## Profundizar:

Bajar el nivel de detalle.
> Ejemplo: De ventas por año → a trimestre → a mes → a día.

## Pivote (rotar el cubo):

Cambie cómo se presentan los datos.
> Ejemplo: En vez de ver productos por meses, ver meses por productos.
