# Diccionario de datos · DomiPan Huila S.A.S.

Describe las tablas **después del ETL** en Power Query: nombres, tipos y valores ya limpios. Donde el archivo de origen trae un problema de calidad, se indica en la descripción.

## Grano de la tabla de hechos

> **Una fila de `Fact_Ventas` es un producto dentro de un pedido** (una línea de pedido).

Ejemplo: si un cliente compra 3 pandebonos y 1 tinto en el mismo pedido, ese pedido ocupa 2 filas. La pareja `id_pedido` + `linea` identifica cada fila sin repetirse.

Este grano permite responder la pregunta de negocio: se puede sumar por producto, por canal, por sede y por hora, y contar pedidos distintos para el ticket promedio.

## Modelo

```
                      Dim_Calendario
                            |
  Dim_Producto ---- Fact_Ventas ---- Dim_Canal
                     |        |
              Dim_Sede        Dim_Cliente
```

Todas las relaciones son de **uno a varios**: un producto, sede, canal, cliente o fecha aparece una sola vez en su dimensión y muchas veces en `Fact_Ventas`.

| Desde (varios) | Hacia (uno) | Columna |
|---|---|---|
| Fact_Ventas | Dim_Producto | id_producto |
| Fact_Ventas | Dim_Sede | id_sede |
| Fact_Ventas | Dim_Canal | id_canal |
| Fact_Ventas | Dim_Cliente | id_cliente |
| Fact_Ventas | Dim_Calendario | fecha |

## Fact_Ventas

Origen: `datos/ventas_domipan.csv`

| Columna | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| id_pedido | Texto | Código del pedido. Un pedido tiene una fila por cada producto distinto | P000003 |
| linea | Número entero | Posición del producto dentro del pedido (1, 2, 3…) | 2 |
| fecha | Fecha | Día de la venta. En el origen, las filas de la app vienen como `dd/mm/aaaa` y las demás como `aaaa-mm-dd` | 01/10/2025 |
| hora | Hora | Hora en que se hizo el pedido (hh:mm) | 06:17 |
| id_sede | Texto | Sede que vende o despacha | SED02 |
| id_canal | Texto | Canal de venta | CAN01 |
| id_cliente | Texto | Cliente; C0000 es el consumidor final no registrado | C0000 |
| id_producto | Texto | Producto vendido | PRD004 |
| cantidad | Número entero | Unidades vendidas | 1 |
| precio_unitario | Número entero (COP) | Precio cobrado por unidad ese día; en la app incluye el recargo de 10 %. En el origen, las filas de la app vienen como texto con signo y punto de miles (`$2.200`) | 600 |
| costo_unitario | Número entero (COP) | Costo de producir una unidad ese día | 230 |
| franja_horaria | Texto | **Columna nueva, creada en Power Query** a partir de la hora: Desayuno, Media mañana, Almuerzo, Onces o Noche | Desayuno |
| orden_franja | Número entero | **Columna nueva, creada en Power Query**: 1 a 5, para que las franjas salgan en orden en los gráficos | 1 |

Las ventas (cantidad × precio unitario) y el costo de ventas (cantidad × costo unitario) no se guardan como columnas: se calculan con medidas DAX en la Fase 2.

## Dim_Producto

Origen: `datos/maestros_domipan.xlsx`, hoja Productos

| Columna | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| id_producto | Texto | Código del producto (llave) | PRD001 |
| producto | Texto | Nombre del producto. En el origen, 5 nombres traen espacios de más, mayúsculas mezcladas o les falta la tilde | Pandebono |
| categoria | Texto | Panadería, Cafetería o Repostería. En el origen aparecen 10 formas de escribir estas 3 categorías | Panadería |
| subcategoria | Texto | Agrupación más fina, por ejemplo Pan de sal, Bebidas calientes o Tortas enteras | Pan de queso y almidón |
| unidad_venta | Texto | Unidad, Paquete, Vaso, Taza, Plato o Porción | Unidad |
| precio_base | Número entero (COP) | Precio de mostrador vigente en octubre de 2025 | 2000 |
| costo_base | Número entero (COP) | Costo unitario vigente en octubre de 2025 | 820 |
| es_tipico_huila | Texto | «Sí» si es un producto típico del Huila | No |

## Dim_Cliente

Origen: `datos/maestros_domipan.xlsx`, hoja Clientes. Sin datos personales: solo códigos y datos generales.

| Columna | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| id_cliente | Texto | Código del cliente (llave). C0000 = consumidor final | C0001 |
| tipo_cliente | Texto | Consumidor final, Persona o Empresa | Persona |
| comuna | Texto | Comuna de Neiva donde vive o trabaja; «No aplica» para C0000 | Comuna 6 |
| fecha_registro | Fecha | Día en que se registró; vacía para C0000 | 15/12/2024 |
| canal_registro | Texto | Tienda, WhatsApp o App; «No aplica» para C0000 | WhatsApp |

## Dim_Sede

Origen: `datos/maestros_domipan.xlsx`, hoja Sedes

| Columna | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| id_sede | Texto | Código de la sede (llave) | SED01 |
| sede | Texto | Nombre de la sede | DomiPan Centro |
| zona | Texto | Zona de Neiva | Centro |
| ciudad | Texto | Ciudad | Neiva |
| tipo_sede | Texto | Si además de vender produce | Punto de venta con planta de producción |
| hora_apertura | Hora | Hora en que abre | 06:00 |
| hora_cierre | Hora | Hora en que cierra | 20:00 |

## Dim_Canal

Origen: `datos/maestros_domipan.xlsx`, hoja Canales

| Columna | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| id_canal | Texto | Código del canal (llave) | CAN03 |
| canal | Texto | Presencial, Domicilio WhatsApp o App móvil | App móvil |
| tipo_canal | Texto | Mostrador o Domicilio | Domicilio |
| comision_pct | Número decimal (porcentaje) | Parte de la venta que se va en comisión o costo del canal | 0,20 (20 %) |
| recargo_precio_pct | Número decimal (porcentaje) | Recargo que el canal suma al precio de mostrador | 0,10 (10 %) |

## Festivos (tabla de apoyo)

Origen: `datos/maestros_domipan.xlsx`, hoja Festivos. Se usa para marcar los festivos en el calendario.

| Columna | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| fecha | Fecha | Día festivo en Colombia | 29/06/2026 |
| festivo | Texto | Nombre del festivo | San Pedro y San Pablo |

## Dim_Calendario (se crea en Power BI en la Fase 2)

Tabla con un día por fila, del 01/10/2025 al 30/09/2026.

| Columna | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| fecha | Fecha | Día (llave) | 06/10/2025 |
| anio | Número entero | Año | 2025 |
| mes_num | Número entero | Número del mes, para ordenar | 10 |
| mes | Texto | Nombre del mes | octubre |
| trimestre | Texto | Trimestre del año | T4 |
| dia_semana | Texto | Nombre del día | lunes |
| num_dia_semana | Número entero | 1 = lunes … 7 = domingo, para ordenar | 1 |
| es_fin_de_semana | Texto | Sí o No | No |
| es_festivo | Texto | Sí si la fecha está en la tabla Festivos | No |
