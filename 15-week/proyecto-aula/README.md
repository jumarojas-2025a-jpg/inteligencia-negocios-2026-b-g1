# Proyecto de aula · Inteligencia de Negocios 2026-B

## Tablero de inteligencia de negocios para DomiPan Huila S.A.S.

### Fase 0 · Definición del proyecto

| Campo | Su respuesta |
|---|---|
| Integrantes (máximo dos) | Juan Manuel Rojas Mora (trabajo individual) |
| Empresa y tipo (real o ficticia) | DomiPan Huila S.A.S. · ficticia |
| A qué se dedica | Empresa ficticia dedicada a la producción y comercialización de productos de panadería, cafetería y repostería en la ciudad de Neiva. Cuenta con tres sedes y ofrece ventas presenciales, domicilios mediante WhatsApp y pedidos desde una aplicación móvil. |
| Problema | Actualmente la empresa registra diariamente sus ventas, pero no dispone de una herramienta que permita analizar la información de manera integrada. La administración desconoce cuáles productos generan mayor rentabilidad, cuáles horarios concentran las ventas y qué canal de venta produce mayores ingresos. Esta situación dificulta la toma de decisiones estratégicas relacionadas con inventarios, promociones y crecimiento del negocio. |
| Pregunta de negocio | ¿Qué productos, canales de venta y franjas horarias generan la mayor rentabilidad para DomiPan Huila S.A.S. entre octubre de 2025 y septiembre de 2026? |
| Periodo de análisis | 1 de octubre de 2025 al 30 de septiembre de 2026 (12 meses completos) |
| KPI principal y fórmula | **Margen bruto (%)** = ((Ventas totales - Costo de ventas) / Ventas totales) × 100, donde costo de ventas = cantidad vendida × costo unitario. Mide la rentabilidad por producto, canal de venta, sede y franja horaria. |
| KPI de apoyo | **Ticket promedio** = Ventas totales / Número de pedidos<br>**Participación por canal (%)** = (Ventas del canal / Ventas totales) × 100<br>**Participación por franja horaria (%)** = (Ventas de la franja / Ventas totales) × 100. Franjas: desayuno (6:00-9:59), media mañana (10:00-11:59), almuerzo (12:00-14:59), onces (15:00-17:59) y noche (18:00-21:00) |
| Fuentes de datos y formato | Ventas diarias: CSV<br>Productos, clientes, sedes y canales de venta: Excel<br>Calendario: tabla creada en Power BI |
| Autorización (solo empresa real) | No aplica: la empresa es ficticia. |

### Fase 1 · Datos y ETL

**Grano de la tabla de hechos:** una fila es un producto dentro de un pedido (una línea de pedido). Si un pedido trae 3 pandebonos y 1 tinto, ocupa 2 filas.

| Mínimo de la guía | DomiPan |
|---|---|
| Tabla de hechos con 1.000 filas o más | 114.144 filas limpias (53.133 pedidos) |
| Tres dimensiones o más, más calendario | Producto, Cliente, Sede y Canal, más calendario |
| 12 meses de historia | 1 de octubre de 2025 al 30 de septiembre de 2026 |
| Dos problemas de calidad a propósito | Cuatro: duplicados, fechas en dos formatos, precios como texto y categorías mal escritas |

**Archivos de esta fase**

- [`datos/ventas_domipan.csv`](datos/ventas_domipan.csv): ventas (tabla de hechos), tal como salen del sistema, con sus problemas de calidad.
- [`datos/maestros_domipan.xlsx`](datos/maestros_domipan.xlsx): hojas Productos, Clientes, Sedes, Canales y Festivos.
- [`datos/generar_datos.py`](datos/generar_datos.py): script de Python que generó los datos.
- [`docs/generacion-datos.md`](docs/generacion-datos.md): cómo y con qué reglas se generaron, los problemas de calidad y las cifras de control.
- [`docs/diccionario-datos.md`](docs/diccionario-datos.md): diccionario de datos (tabla, columna, tipo, descripción y ejemplo).
