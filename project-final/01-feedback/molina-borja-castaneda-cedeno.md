# Retroalimentación · Fase 0 (Definición)

**Proyecto:** EcoHogar del Huila
**Estudiantes:** Larissa Alexandra Molina Borja y Yury Lorena Castañeda Cedeño
**Revisión:** jueves 29 de octubre de 2026 · Docente Jesús Ariel González Bonilla
**Avance revisado:** fork `lamolina-2023a-lgtm`, `15-week/proyecto-aula/README.md` (commit «Fase 0 - EcoHogar del Huila»)

La ficha está en la ruta correcta, declara las dos integrantes y ya tiene una estructura de modelo (FactVentas, DimCliente, DimSede, DimProducto) y una cifra de control. Los puntos siguientes son para ajustar antes de la Fase 1 (jueves 5 de noviembre).

## 1. Ajustes a la ficha

1. **Problema más concreto.** «Dificultades para analizar y comparar de manera centralizada» es genérico. Digan qué decisión toma mal hoy la empresa: por ejemplo, a qué sede enviar el inventario, a qué tipo de cliente dirigir las promociones o si el canal de domicilios es rentable.
2. **Pregunta orientada a una decisión y con periodo.** «¿Qué unidades y tipos de cliente generan mayores ingresos?» describe, pero no lleva a una decisión y no dice el periodo. Ejemplo: «¿Qué unidad comercial y qué tipo de cliente dejan mayor margen bruto en 2025, y dónde conviene concentrar las promociones del primer semestre de 2026?».
3. **KPI principal.** Ventas Totales es un KPI descriptivo. Con la pregunta ajustada, el principal puede ser el **margen bruto %** = (ventas − costo de ventas) / ventas × 100, y las ventas totales y la participación por tipo de cliente quedan como apoyo.
4. **Sede y canal no son lo mismo.** «Canal Domicilios» aparece como una tercera sede. Separen sede (Centro, Norte) y canal (mostrador, domicilio), porque un domicilio también sale de una sede.

## 2. Datos: volumen, periodo y fuente

- **Mínimos de la guía.** Para una empresa ficticia se exigen al menos 1.000 filas, 3 dimensiones y 12 meses. La cifra de control de ventas totales es $5.360.000 COP: en una tienda de electrodomésticos eso equivale a muy pocas ventas (unas cuantas neveras o lavadoras). Declaren cuántas filas tiene FactVentas y qué periodo cubre, y amplíen el dataset hasta cumplir los mínimos.
- **Fuente de los datos.** Dicen que los datos fueron «creados y trabajados en Power BI». La Fase 1 es de ETL: necesitan un archivo de origen (CSV o Excel) que se cargue y se limpie en Power Query, con al menos tres problemas de calidad corregidos y documentados. Datos escritos a mano dentro de Power BI no dejan nada que transformar.
- **Costo para el margen.** El margen bruto necesita el costo de cada producto; agreguen esa columna en DimProducto o en FactVentas.
- **El .pbix no está en el repositorio.** La ficha nombra `Proyecto_BI_EcoHogar.pbix`, pero no se subió. Súbanlo a la carpeta del proyecto cuando avancen en la Fase 1.

## 3. Formato de datos propuesto (solo la forma)

```
                Dim_Calendario
                      |
Dim_Cliente ---- Fact_Venta ---- Dim_Producto
                      |
               Dim_Sede   Dim_Canal
```

| Tabla | Grano | Columnas |
|---|---|---|
| Fact_Venta | una fila por línea de factura | id_factura, fecha, id_sede, id_canal, id_cliente, id_producto, cantidad, precio_unitario, descuento, costo_unitario |
| Dim_Producto | una fila por producto | id_producto, producto, categoria (neveras, lavadoras, televisores, pequeños electrodomésticos), marca, costo_referencia |
| Dim_Cliente | una fila por cliente | id_cliente (sin datos personales), tipo_cliente (Empresarial, Particular), ciudad |
| Dim_Sede | una fila por sede | id_sede, sede |
| Dim_Canal | una fila por canal | id_canal, canal (Mostrador, Domicilio), costo_envio |
| Dim_Calendario | un día por fila | fecha, anio, trimestre, mes, nombre_mes, temporada (Prima, Black Friday, Navidad) |

## 4. Para la Fase 1 (jueves 5 de noviembre)

- Actualizar la ficha con el problema, la pregunta y el KPI ajustados, y con el volumen y el periodo de los datos.
- Generar un archivo de origen con al menos 1.000 ventas en 12 meses, con costo y con sede y canal separados.
- Cargarlo en Power Query, documentar cada paso aplicado con su antes y después y escribir el diccionario de datos.
