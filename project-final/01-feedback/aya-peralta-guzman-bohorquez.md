# Retroalimentación · Fase 0 (Definición)

**Proyecto:** PixelZone Gaming
**Estudiantes:** José Miguel Aya Peralta y Juan José Guzmán Bohórquez
**Revisión:** jueves 29 de octubre de 2026 · Docente Jesús Ariel González Bonilla

La empresa está bien elegida y el problema es claro: decidir en qué productos y canales concentrar compras y promociones. Los puntos siguientes son para ajustar antes de la Fase 1 (jueves 5 de noviembre).

## 1. Ubicación del README

La ficha quedó en `13-week/README.md` del fork de José Miguel. La guía pide `15-week/proyecto-aula/README.md`. Muévanla a esa ruta. Juan José no tiene nada del proyecto en su fork: indiquen en la ficha cuál es el repositorio del proyecto (uno solo, el de uno de los dos).

## 2. Ajustes a la ficha

1. **Año de la pregunta.** «Durante un año» no basta: digan cuál (por ejemplo, enero a diciembre de 2025).
2. **Margen en porcentaje.** El margen bruto en pesos favorece siempre a la categoría que más vende. Agreguen el margen bruto % = margen bruto / ventas × 100, que permite comparar categorías y canales de distinto tamaño.
3. **KPI de apoyo.** Ventas totales y unidades vendidas miden volumen y no explican el margen. Encajan mejor indicadores como el costo promedio por unidad, el margen por canal o el peso de los gastos sobre las ventas.
4. **Fuente y mínimos.** Decidan si usarán Excel o CSV y verifiquen los mínimos de la guía para empresa ficticia: al menos 1.000 filas, 3 dimensiones y 12 meses.

## 3. Llegar a la utilidad neta

El margen bruto solo descuenta el costo de los productos. Una tienda gasta además en arriendo, nómina, servicios, publicidad, comisiones de la plataforma en línea, envíos y devoluciones, y paga impuestos. Una categoría con buen margen bruto puede dejar poca ganancia cuando se le cargan esos gastos, y en eso suele diferir la tienda física del canal en línea.

Se espera que el proyecto demuestre la **utilidad neta**, la que queda después de todo gasto, siguiendo la estructura del estado de resultados:

```
  Ventas netas            (ventas − devoluciones − descuentos)
− Costo de ventas
= Utilidad bruta          → margen bruto %
− Gastos operacionales    (arriendo, nómina, servicios, publicidad,
                           comisiones de plataforma, envíos)
= Utilidad operacional    → margen operacional %
± Otros ingresos y gastos (financieros: intereses, comisiones bancarias)
= Utilidad antes de impuestos
− Impuesto de renta       (tarifa como parámetro, p. ej. 35 %)
= Utilidad neta           → margen neto %
```

Para eso hacen falta dos decisiones en la Fase 1:

- **Gastos directos y compartidos.** Algunos gastos son de un solo canal (la comisión de la plataforma y los envíos son del canal en línea; el arriendo del local es de la tienda física). Otros son compartidos (la nómina administrativa, el contador). Los directos se asignan al canal que los causa.
- **Regla de reparto.** Los gastos compartidos se reparten entre canales y categorías con una regla escrita y justificada, por ejemplo en proporción a las ventas del mes. Sin esa regla, la utilidad neta por categoría no se puede calcular.

Con esto, la pregunta de negocio puede quedar así: «¿Qué categorías de productos y qué canal de venta dejan mayor utilidad neta en 2025, después del costo de ventas, los gastos de operación y los impuestos?». El KPI principal pasaría a ser el **margen neto %** = utilidad neta / ventas netas × 100, con el margen bruto % y el margen operacional % como KPI de apoyo.

## 4. Formato de datos propuesto (solo la forma)

Propuesta de estructura para el modelo estrella. No trae datos: sirve de guía para generar el dataset y escribir el diccionario de datos de la Fase 1. Pueden ajustarla.

```
                Dim_Calendario
                 |          |
Dim_Producto -- Fact_Venta  Fact_Gasto -- Dim_Concepto_Gasto
                 |          |
Dim_Cliente ----+-- Dim_Canal
```

### Fact_Venta (grano: una fila por línea de factura)

| Columna | Tipo | Descripción |
|---|---|---|
| id_factura | Texto | Número de la factura |
| linea | Entero | Número de la línea dentro de la factura |
| fecha | Fecha | Día de la venta (se relaciona con Dim_Calendario) |
| id_producto | Texto | Producto vendido |
| id_canal | Texto | Tienda física o en línea |
| id_cliente | Texto | Código del cliente (sin datos personales) |
| cantidad | Entero | Unidades vendidas |
| precio_unitario | Decimal | Precio de venta por unidad |
| descuento | Decimal | Valor del descuento aplicado |
| costo_unitario | Decimal | Costo de compra por unidad |
| devuelta | Booleano | Si la línea fue devuelta |

### Fact_Gasto (grano: una fila por concepto, mes y canal)

| Columna | Tipo | Descripción |
|---|---|---|
| mes | Fecha | Primer día del mes (se relaciona con Dim_Calendario) |
| id_concepto | Texto | Concepto del gasto |
| id_canal | Texto | Canal al que se asigna; «Compartido» si se reparte |
| valor | Decimal | Valor del gasto en el mes |

### Dim_Calendario

| Columna | Tipo | Descripción |
|---|---|---|
| fecha | Fecha | Un día por fila, sin huecos |
| anio, trimestre, mes, nombre_mes | Entero / Texto | Jerarquía para el drill-down |
| dia_semana | Texto | Lunes a domingo |
| temporada | Texto | Normal, Lanzamientos, Black Friday, Navidad |

### Dim_Producto

| Columna | Tipo | Descripción |
|---|---|---|
| id_producto | Texto | Código del producto |
| producto | Texto | Nombre |
| tipo | Texto | Videojuego o Accesorio |
| categoria | Texto | Acción, Deportes, Controles, Audífonos, Cargadores… |
| plataforma | Texto | PlayStation, Xbox, Nintendo, PC, Multiplataforma |
| costo_referencia | Decimal | Costo de compra de referencia |

### Dim_Canal

| Columna | Tipo | Descripción |
|---|---|---|
| id_canal | Texto | Código |
| canal | Texto | Tienda física, En línea, Compartido |
| comision_pct | Decimal | Comisión de la plataforma (solo en línea) |

### Dim_Cliente

| Columna | Tipo | Descripción |
|---|---|---|
| id_cliente | Texto | Código del cliente |
| ciudad | Texto | Ciudad |
| tipo_cliente | Texto | Nuevo, Recurrente, Gamer frecuente |

### Dim_Concepto_Gasto

| Columna | Tipo | Descripción |
|---|---|---|
| id_concepto | Texto | Código |
| concepto | Texto | Arriendo, Nómina, Servicios, Publicidad, Comisión plataforma, Envíos, Intereses, Impuesto de renta… |
| nivel_estado_resultados | Texto | Operacional, No operacional, Impuesto |
| comportamiento | Texto | Fijo o Variable |
| directo_o_compartido | Texto | Directo o Compartido |

### Medidas DAX esperadas (solo los nombres y la idea)

| Medida | Idea |
|---|---|
| Ventas netas | cantidad × precio − descuentos − devoluciones |
| Costo de ventas | cantidad × costo_unitario de lo no devuelto |
| Utilidad bruta y Margen bruto % | ventas netas − costo de ventas |
| Gastos operacionales | suma de Fact_Gasto con nivel Operacional, más la parte repartida |
| Utilidad operacional y Margen operacional % | utilidad bruta − gastos operacionales |
| Utilidad neta y Margen neto % | utilidad operacional ± no operacionales − impuesto |

## 5. Para la Fase 1 (jueves 5 de noviembre)

- Mover el README a `15-week/proyecto-aula/` y actualizar la ficha con el año, la pregunta ajustada y los KPI.
- Escribir la regla de reparto de los gastos compartidos.
- Generar el dataset con esta estructura (o la que ajusten): al menos 1.000 líneas de venta en 12 meses y los gastos de los 12 meses.
- Cargarlo en Power Query, documentar los pasos aplicados y escribir el diccionario de datos.
