# Cómo se generaron los datos de DomiPan Huila S.A.S.

DomiPan Huila S.A.S. es una empresa **ficticia**. Sus datos son sintéticos: no vienen de ninguna panadería real ni contienen datos personales. Se generaron con un script de Python que sigue reglas de negocio pensadas para que los datos se comporten como los de una panadería real de Neiva.

## 1. Herramientas y archivos

- **Herramienta:** Python 3 con la librería `openpyxl`. El script se escribió con apoyo de una herramienta de IA (Claude, de Anthropic).
- **Script:** [`datos/generar_datos.py`](../datos/generar_datos.py). Usa una semilla fija (`20251001`), así que cada vez que se ejecuta produce exactamente los mismos datos.

| Archivo | Qué contiene | Filas |
|---|---|---|
| `datos/ventas_domipan.csv` | Tabla de hechos: ventas, una fila por producto dentro de un pedido | 114.764 (con duplicados) |
| `datos/maestros_domipan.xlsx`, hoja Productos | Catálogo de productos con precio y costo base | 32 |
| `datos/maestros_domipan.xlsx`, hoja Clientes | Clientes por código, sin datos personales | 651 |
| `datos/maestros_domipan.xlsx`, hoja Sedes | Las tres sedes de Neiva | 3 |
| `datos/maestros_domipan.xlsx`, hoja Canales | Canales de venta con su comisión | 3 |
| `datos/maestros_domipan.xlsx`, hoja Festivos | Festivos de Colombia en el periodo | 18 |

## 2. Periodo y mínimos de la guía

Periodo: **1 de octubre de 2025 al 30 de septiembre de 2026** (12 meses completos, 365 días).

| Mínimo de la guía (empresa ficticia) | DomiPan |
|---|---|
| Tabla de hechos con 1.000 filas o más | 114.144 filas limpias |
| Tres dimensiones o más, más un calendario | Producto, Cliente, Sede y Canal, más el calendario que se crea en Power BI |
| 12 meses de historia o más | 12 meses completos |
| Dos problemas de calidad a propósito o más | Cuatro (sección 4) |

## 3. Reglas para que los datos parezcan reales

### Volumen por sede y canal

Cada día, cada sede recibe un número de pedidos por canal. Este es el promedio de partida, antes de aplicar las temporadas:

| Sede | Presencial | Domicilio WhatsApp | App móvil |
|---|---|---|---|
| DomiPan Centro (con planta de producción) | 45 | 6 | 4 |
| DomiPan Norte (zona residencial) | 35 | 10 | 7 |
| DomiPan Oriente (la más pequeña) | 25 | 5 | 3 |

A cada día se le suma una variación al azar de ±15 % para que no todos los días sean iguales.

### Día de la semana, festivos y quincenas

- En mostrador, el sábado es el día más fuerte. Los domicilios crecen el fin de semana (sábado +30 %, domingo +40 %).
- Un festivo se comporta como un domingo.
- El Centro vive de las oficinas: los domingos y festivos su venta en mostrador cae casi a la mitad.
- Los días de pago de quincena (1, 15, 16, 30 y 31) la venta sube 8 %.

### Temporadas y fechas especiales

| Mes o fecha | Efecto | Por qué |
|---|---|---|
| Diciembre | +35 % en ventas; buñuelos ×4 y torta envinada ×5 | Navidad |
| 16 al 23 de diciembre | +15 % adicional | Novenas de aguinaldo |
| 24 y 31 de diciembre | +25 % y tortas enteras ×3 | Celebraciones familiares |
| 25 de diciembre y 1 de enero | 40 % de un día normal, de 7 a. m. a 1 p. m. | Se abre medio día |
| Enero | −15 % | «Cuesta de enero» |
| 2 al 12 de enero, sede Centro | −25 % adicional | Oficinas del centro en vacaciones |
| 8 al 10 de mayo | +10 %; tortas enteras ×5 y repostería ×1,8 | Día de la Madre |
| 19 de junio al 1 de julio | +18 %; típicos del Huila ×2,5 | Festival del Bambuco y San Pedro en Neiva |
| 17 al 19 de septiembre | +8 %; repostería ×2 | Amor y Amistad |

### Horas y franjas

Cada pedido tiene una hora entre las 6:00 a. m. y el cierre de la sede (el Centro cierra a las 8 p. m.; Norte y Oriente, a las 9 p. m.). Las horas no se reparten igual en todos los canales:

- **Presencial:** picos de 7 a 8 a. m. (desayuno) y de 4 a 6 p. m. (onces).
- **WhatsApp:** pico en la mañana (pedidos de casa y de oficina) y otro en la tarde.
- **App móvil:** casi no se usa temprano; su pico va de 3 a 7 p. m.

Las franjas usadas en el análisis son: desayuno (6:00-9:59), media mañana (10:00-11:59), almuerzo (12:00-14:59), onces (15:00-17:59) y noche (18:00-21:00).

### Qué productos se venden

- Cada producto tiene un peso de venta distinto en cada franja. Por ejemplo, el tinto y el pan francés pesan mucho en el desayuno; la repostería, en las onces y la noche; las empanadas y los sándwiches, al almuerzo.
- Cada canal tiene sus preferencias. Por la app casi no se piden bebidas calientes (llegan frías) y se pide mucha repostería; por WhatsApp se pide más pan para la casa y tortas enteras.
- Los fines de semana la repostería sube 40 %, y el domingo el desayuno completo sube 50 %.
- Un pedido en mostrador lleva de 1 a 4 productos distintos; uno a domicilio, de 1 a 5.

### Cantidades

- Panes pequeños (pandebono, almojábana, pan de queso, etc.): de 1 a 6 unidades. Pan francés: de 1 a 10.
- Bebidas, porciones y comidas: de 1 a 3. Paquetes y tortas enteras: casi siempre 1.
- A domicilio el pan se pide en mayor cantidad (para toda la casa).
- Las empresas (oficinas que piden por WhatsApp en la mañana de lunes a viernes) multiplican la cantidad por 4 a 12, con un máximo de 60 unidades por producto.

### Precios y costos

- Cada producto tiene un **precio base** y un **costo base** de octubre de 2025 (hoja Productos).
- Desde el **1 de enero de 2026** los insumos (harina, mantequilla, lácteos) suben y el costo unitario aumenta 8 %.
- Desde el **1 de febrero de 2026** DomiPan sube sus precios 6 %, un mes después del alza de costos.
- En la **app** el precio tiene un recargo de 10 % sobre el precio de mostrador.
- Los precios se redondean a múltiplos de $50.
- Por eso la tabla de hechos guarda el **precio y el costo del día de la venta**, no los de la hoja Productos.

### Canales y comisión

| Canal | Comisión sobre la venta | Recargo en el precio |
|---|---|---|
| Presencial | 0 % | 0 % |
| Domicilio WhatsApp | 5 % (empaque y apoyo al domiciliario propio) | 0 % |
| App móvil | 20 % (comisión de la plataforma) | 10 % |

Para simplificar, el costo de vender por cada canal se expresa como un porcentaje de la venta. La comisión no entra en el margen bruto; sirve para calcular en la Fase 2 una medida de margen después de comisión.

### Clientes

- **C0000 = consumidor final:** quien compra en mostrador sin registrarse (85 % de los pedidos presenciales).
- **C0001 a C0650:** clientes registrados, solo con código, tipo, comuna de Neiva, fecha y canal de registro. No hay nombres, documentos, teléfonos ni direcciones.
- 400 clientes se registraron antes del periodo y 250 durante el periodo, sobre todo por la app. Un cliente solo aparece en pedidos posteriores a su fecha de registro.
- 29 de los clientes son empresas.
- Todos los domicilios tienen un cliente registrado; ninguno queda como C0000.

## 4. Problemas de calidad a propósito

| # | Problema | Dónde | Cuántos | Por qué pasa en la vida real | Cómo se corrige en Power Query |
|---|---|---|---|---|---|
| 1 | Pedidos duplicados | `ventas_domipan.csv` | 222 pedidos de domicilio repetidos, 620 filas de más | Al sincronizar, algunos pedidos de WhatsApp y de la app se registraron dos veces | Quitar duplicados con todas las columnas seleccionadas |
| 2 | Fechas en dos formatos | `ventas_domipan.csv`, columna `fecha` | 16.657 filas de la app en `dd/mm/aaaa` (ej. `01/10/2025`); las demás en `aaaa-mm-dd` (ej. `2025-10-01`) | La app exporta con otro formato que el sistema de caja | Cambiar el tipo a Fecha usando la configuración regional Español (Colombia) |
| 3 | Precio guardado como texto | `ventas_domipan.csv`, columna `precio_unitario` | Las mismas 16.657 filas de la app traen el precio con signo y punto de miles (ej. `$2.200`) | Mismo origen: la exportación de la app | Reemplazar `$` y `.` por nada y cambiar el tipo a número entero |
| 4 | Nombres y categorías escritos distinto | `maestros_domipan.xlsx`, hoja Productos | 5 nombres con espacios, mayúsculas o sin tilde, y 7 categorías mal escritas (10 formas distintas para solo 3 categorías) | El catálogo lo digitaron varias personas | Recortar espacios, poner mayúscula inicial y reemplazar valores |

Ejemplo del problema 1: el pedido `P000032` aparece dos veces, con sus tres líneas repetidas:

```
P000032,1,01/10/2025,08:39,SED01,CAN03,C0039,PRD004,4,$650,230
P000032,2,01/10/2025,08:39,SED01,CAN03,C0039,PRD002,1,$2.200,860
P000032,3,01/10/2025,08:39,SED01,CAN03,C0039,PRD015,2,$1.650,290
P000032,1,01/10/2025,08:39,SED01,CAN03,C0039,PRD004,4,$650,230
P000032,2,01/10/2025,08:39,SED01,CAN03,C0039,PRD002,1,$2.200,860
P000032,3,01/10/2025,08:39,SED01,CAN03,C0039,PRD015,2,$1.650,290
```

## 5. Cifras de control de los datos limpios

Estas cifras se calcularon con Python a partir del CSV ya limpio, sin usar Power BI. Sirven para comprobar que el ETL de Power Query y, en la Fase 2, las medidas DAX dan el mismo resultado.

| Cifra | Valor |
|---|---|
| Filas en el CSV original | 114.764 |
| Filas duplicadas que se eliminan | 620 |
| Filas limpias | 114.144 |
| Pedidos distintos | 53.133 |
| Días con ventas | 365 (del 01/10/2025 al 30/09/2026) |
| Ventas totales (cantidad × precio unitario) | $915.980.100 |
| Costo de ventas (cantidad × costo unitario) | $376.515.020 |
| Margen bruto | 58,89 % |
| Ticket promedio | $17.239 |

| Canal | Ventas | Pedidos | Filas |
|---|---|---|---|
| Presencial | $455.020.600 | 38.348 | 73.692 |
| Domicilio WhatsApp | $293.074.600 | 8.701 | 23.795 |
| App móvil | $167.884.900 | 6.084 | 16.657 |

| Sede | Ventas | Pedidos |
|---|---|---|
| DomiPan Centro | $313.419.100 | 19.723 |
| DomiPan Norte | $383.354.550 | 20.466 |
| DomiPan Oriente | $219.206.450 | 12.944 |

## 6. Cómo volver a generar los datos

```
pip install openpyxl
python generar_datos.py
```

Se ejecuta dentro de la carpeta `datos/`. Con la misma semilla se obtienen exactamente los mismos archivos y las mismas cifras de control.
