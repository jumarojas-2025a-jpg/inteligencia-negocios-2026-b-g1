# Corte 2 - Mini-ETL y primeras medidas

**Autor:** Juan Manuel Rojas Mora
**Usuario GitHub:** jumarojas-2025a-jpg

## Dataset
`ventas_sucias.csv`: dataset sintético de ventas de materiales eléctricos
(Cable, Breaker, Tubo EMT) en ciudades del Huila. Lo creé con errores a
propósito: duplicados, espacios sobrantes, mayúsculas mezcladas y valores vacíos.

## Conexión y pasos aplicados en Power Query
Conecté Power BI Desktop al CSV con **Obtener datos → Texto/CSV** y
transformé los datos en Power Query. Pasos aplicados (ver `pasos_aplicados.png`
y el código en `pasos_powerquery.m`):

1. **Tipos de datos**: Fecha como fecha, Cantidad como entero y Precio como decimal fijo, para poder calcular y filtrar sin errores.
2. **Quitar duplicados por ID**: eliminó la fila repetida del ID 3 (de 10 a 9 filas).
3. **Recortar espacios en Ciudad**: quitó espacios sobrantes (por ejemplo " La Plata").
4. **Unificar mayúsculas en Ciudad**: "neiva", "NEIVA" y "Neiva" pasaron a ser una sola categoría.
5. **Reemplazar nulos por 0** en Cantidad y Precio, para que no sesguen los cálculos.
6. **Columna personalizada Ingreso** = Cantidad x Precio.
7. **Columna condicional Tamaño Venta**: Alta (>= 50.000), Media (>= 20.000) o Baja.

## Medidas DAX (`medidas.dax`)
- `Total Ingresos = SUM(Ventas[Ingreso])`
- `Promedio Ingreso = AVERAGE(Ventas[Ingreso])`
- `Ingreso por Unidad = DIVIDE([Total Ingresos], SUM(Ventas[Cantidad]), 0)`

## Contexto de filtro
En una matriz (Ciudad en filas, tres medidas en valores) agregué una
segmentación por Producto. Sin filtro, el Total Ingresos es 410.000; al
seleccionar "Cable" baja a 95.000, el Ingreso por Unidad pasa a 2.500 y el
Promedio a 31.666,67. Esto ocurre porque cada medida se recalcula con el
filtro activo (contexto de filtro). Ver `sin_filtro.png` y `con_filtro.png`.

## ETL steps & measures
I connected Power BI to a messy CSV file with sales data using Power Query.
First, I changed the data types so dates and numbers were recognized correctly.
Then I removed duplicate rows by ID and trimmed and capitalized the city names to standardize them.
I also replaced null values with zero and created two new columns: Ingreso (quantity times price) and a conditional column called Tamaño Venta, which classifies each sale as Alta, Media or Baja.
After loading the data into the model, I created three DAX measures: Total Ingresos with SUM, Promedio Ingreso with AVERAGE, and Ingreso por Unidad with DIVIDE.
When I filter by product with a slicer, the measures recalculate, which shows how filter context works.