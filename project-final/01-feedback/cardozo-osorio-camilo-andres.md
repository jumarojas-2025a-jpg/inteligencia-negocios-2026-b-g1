# Retroalimentación · Fase 0 (Definición)

**Proyecto:** Droguerías San Pedro (Neiva)
**Estudiante:** Camilo Andrés Cardozo Osorio
**Revisión:** jueves 29 de octubre de 2026 · Docente Jesús Ariel González Bonilla

El tema es bueno y tiene un problema de negocio real: los quiebres de stock en unas sedes mientras otra acumula inventario de baja rotación. Los puntos siguientes son para ajustar antes de la Fase 1 (jueves 5 de noviembre).

## 1. Qué va en GitHub y qué va en Moodle

El FO-IV-159 está publicado en GitHub (`13-week/proyecto.xlsx`). Cada sitio tiene su propósito:

- **GitHub** es para los avances: los cambios se suben en archivos Markdown (.md) y en los elementos de avance de cada fase (datos de trabajo, capturas, el .pbix cuando corresponda).
- **Moodle** es para los documentos oficiales ya armados (FO-IV-159 y ZIP de anexos), en la fecha establecida.

La hoja ESTUDIANTE del formato tiene su nombre. Aunque la identificación está vacía, retire el archivo del repositorio.

## 2. Ajustes

1. **Ficha de la Fase 0.** Falta. Debe hacerla en `15-week/proyecto-aula/README.md` con la tabla de la sección 4 de la guía. Lea completa la guía publicada en Moodle para desarrollar el proyecto de acuerdo con las instrucciones establecidas: ahí están la ruta, las fases, los mínimos de datos y la rúbrica.
2. **Cifras sin fuente.** El resumen dice «caídas de hasta un 8 % en la rentabilidad neta anual según datos sectoriales». Cite la fuente o quite la cifra. El resumen también anuncia resultados («tasas de desabastecimiento superiores al 10 %») que todavía no puede tener: el resumen se escribe al final, con los hallazgos reales del tablero.
3. **Empresa real o ficticia.** No lo aclara, y es muy importante. Explíquelo en un archivo Markdown aparte (por ejemplo `15-week/proyecto-aula/empresa.md`) para no mezclarlo con el formato. Si la droguería es real, necesita autorización escrita y los datos deben ir anonimizados; si es ficticia, debe cumplir los mínimos de la guía (al menos 1.000 filas, 3 dimensiones y 12 meses).
4. **Coherencia de los datos del estudiante.** El formato dice semestre VIII en una hoja y VII en la otra, y «2 estudiantes» con un solo nombre. Use el semestre que usted cursa realmente, el mismo en todas las hojas, y declare si trabaja solo o en pareja (si es en pareja, con el nombre del compañero).
5. **Periodo.** 2024-2026 deja 2026 incompleto. Defina un periodo de meses completos y dígalo en la ficha.

## 3. El centro del proyecto: los datos de inventario

El quiebre de stock no se puede medir solo con ventas. Una venta registrada muestra lo que sí se vendió; el quiebre es lo que no se pudo vender porque no había existencias. Por eso el formato de datos debe girar alrededor del inventario:

- existencias por sede y producto, diarias o semanales;
- entradas (compras y traslados entre sedes) y salidas;
- demanda no atendida: el cliente pidió el producto y no había (en una droguería se registra como «faltante» o «pedido no despachado»).

## 4. Trabajar con archivos planos de apoyo

Se sugiere trabajar con archivos planos de apoyo para analizar con mayor rigor el contexto del proyecto antes de llenar el formato. Puede usar Excel, pero los archivos Markdown son más flexibles y se revisan mejor en GitHub. Por ejemplo, en `15-week/proyecto-aula/`:

| Archivo | Contenido |
|---|---|
| `README.md` | Ficha de la Fase 0 |
| `empresa.md` | Real o ficticia, sedes, qué vende, autorización |
| `kpi.md` | Cada KPI: definición, fórmula, datos que necesita y medida DAX prevista |
| `diccionario-datos.md` | Tablas y columnas (Fase 1) |
| `fuentes.md` | Fuentes citadas en formato APA |

## 5. Los KPI y cómo los va a lograr

Vaya revisando los KPI y, para cada uno, qué datos necesita. Una propuesta para empezar:

| KPI | Fórmula | Datos que necesita |
|---|---|---|
| Tasa de quiebre de stock (principal) | días-producto con existencia 0 / días-producto observados × 100 | Existencias diarias por sede y producto |
| Venta perdida estimada | unidades no atendidas × precio de venta | Registro de faltantes o demanda no atendida |
| Margen bruto % | (ventas − costo de ventas) / ventas × 100 | Ventas con precio y costo por producto |
| Días de inventario | existencia promedio / venta promedio diaria | Existencias y ventas diarias |
| Rotación | costo de ventas / inventario promedio | Costo de ventas y existencias valorizadas |

Con estos KPI se responde la pregunta: dónde hay quiebre (sedes periféricas), dónde hay sobrestock (sede Centro) y cuánto margen se pierde por la venta perdida.

## 6. Formato de datos propuesto (solo la forma)

```
                 Dim_Calendario
                   |        |
Dim_Producto -- Fact_Inventario_Diario -- Dim_Sede
     |                                       |
     +---------- Fact_Venta -----------------+
     |                                       |
     +---------- Fact_Faltante --------------+
```

### Fact_Inventario_Diario (grano: una fila por sede, producto y día)

| Columna | Tipo | Descripción |
|---|---|---|
| fecha | Fecha | Día (se relaciona con Dim_Calendario) |
| id_sede | Texto | Sede |
| id_producto | Texto | Producto |
| existencia_inicial | Entero | Unidades al abrir |
| entradas | Entero | Compras y traslados recibidos |
| salidas | Entero | Ventas y traslados enviados |
| existencia_final | Entero | Unidades al cerrar |
| stock_minimo | Entero | Punto de reorden de la sede |
| en_quiebre | Entero | 1 si existencia_final = 0, 0 si no |

### Fact_Venta (grano: una fila por línea de factura)

| Columna | Tipo | Descripción |
|---|---|---|
| id_factura | Texto | Número de la factura |
| fecha | Fecha | Día de la venta |
| id_sede | Texto | Sede |
| id_producto | Texto | Producto |
| cantidad | Entero | Unidades vendidas |
| precio_unitario | Decimal | Precio de venta |
| costo_unitario | Decimal | Costo de compra |

### Fact_Faltante (grano: una fila por solicitud no atendida)

| Columna | Tipo | Descripción |
|---|---|---|
| fecha | Fecha | Día de la solicitud |
| id_sede | Texto | Sede |
| id_producto | Texto | Producto solicitado |
| cantidad_solicitada | Entero | Unidades que no se pudieron despachar |

### Dim_Producto

| Columna | Tipo | Descripción |
|---|---|---|
| id_producto | Texto | Código |
| producto | Texto | Nombre genérico (sin marca si la empresa es real) |
| categoria | Texto | Antibióticos, Cardiovasculares, Analgésicos, Dermatológicos… |
| requiere_formula | Booleano | Si exige fórmula médica |
| costo_referencia | Decimal | Costo de compra de referencia |

### Dim_Sede

| Columna | Tipo | Descripción |
|---|---|---|
| id_sede | Texto | Código |
| sede | Texto | Centro, Prado Alto, Las Granjas |
| comuna | Texto | Comuna de Neiva |
| tipo_sede | Texto | Central o Periférica |

### Dim_Calendario

| Columna | Tipo | Descripción |
|---|---|---|
| fecha | Fecha | Un día por fila, sin huecos |
| anio, trimestre, mes, nombre_mes | Entero / Texto | Jerarquía para el drill-down |
| dia_semana | Texto | Lunes a domingo |
| es_festivo | Booleano | Festivo en Colombia |

## 7. Para la Fase 1 (jueves 5 de noviembre)

- Retirar `13-week/proyecto.xlsx` del repositorio.
- Crear `15-week/proyecto-aula/README.md` con la ficha, y `empresa.md` y `kpi.md`.
- Generar u obtener los datos con esta estructura (o la que ajuste), cargarlos en Power Query, documentar los pasos aplicados y escribir el diccionario de datos.
