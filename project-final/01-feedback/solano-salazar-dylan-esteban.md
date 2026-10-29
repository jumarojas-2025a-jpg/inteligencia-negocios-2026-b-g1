# Retroalimentación · Fase 0 (Definición)

**Proyecto:** TecnoSmart S.A.S.
**Estudiante:** Dylan Esteban Solano Salazar (y los integrantes que declare el equipo)
**Revisión:** jueves 29 de octubre de 2026 · Docente Jesús Ariel González Bonilla

El problema tiene sustancia: productos que se agotan mientras otros se quedan almacenados, y resultados financieros que se revisan tarde. Los puntos siguientes son para ajustar antes de la Fase 1 (jueves 5 de noviembre).

## 1. Seguir las instrucciones

- **El Excel oficial no va en GitHub.** En GitHub van los avances, en archivos Markdown (.md). El FO-IV-159 se entrega en Moodle, armado, en la fecha establecida.
- **Falta la ficha de la Fase 0** en `15-week/proyecto-aula/README.md`, con la tabla de la sección 4 de la guía. El Excel quedó en `15-week/`, no en esa carpeta. Retírelo del repositorio.
- **No dicen quiénes son.** El formato dice «Tres» integrantes, pero la hoja ESTUDIANTE está vacía, y la guía permite máximo dos. Declaren los integrantes en la ficha.
- **Datos del programa incoherentes.** El formato dice facultad «Ingeniería de Sistemas», programa «Ingeniería Industrial» y «Cuarto semestre». Verifiquen y escriban el programa y el semestre que de verdad cursa cada integrante.

## 2. El formato es un formato

**Nota crítica:** el FO-IV-159 es eso, un formato. No se permite ninguna manipulación de su estructura: solo se llena el contenido de las celdas. Agregaron las filas «KPI principal» y «KPI de apoyo», que no existen en el formato. Los KPI van en la ficha del README.

Además, el formato conserva los textos de ejemplo en el resumen, los objetivos, la metodología, los resultados y la bibliografía, y la fecha de cierre dice «DD/11/2026». Esos textos se reemplazan con el contenido del proyecto; la sección 5 de la guía explica qué escribir en cada campo.

## 3. Congruencia del planteamiento

1. **Nombre del KPI.** Lo llaman «margen de rentabilidad», pero la fórmula (ventas netas − costo de lo vendido) / ventas netas es el **margen bruto %**. Nómbrenlo así, o lleguen a la utilidad neta descontando también los gastos de operación (arriendo, nómina, servicios, comisiones del canal en línea, envíos) y los impuestos.
2. **Problema y pregunta.** El problema habla de productos agotados y de inventario quieto, pero la pregunta solo trata del margen. O la pregunta incluye el inventario (quiebre o sobrestock), o el problema se enfoca en el margen. Ejemplo que integra ambos: «¿Qué productos y sedes de TecnoSmart combinan bajo margen bruto y baja rotación de inventario en 2025, y cuánto pesan en las ventas totales?».
3. **Fuentes y mínimos.** No declaran las fuentes de datos ni cómo cumplen los mínimos de la guía para empresa ficticia (al menos 1.000 filas, 3 dimensiones y 12 meses). El título dice solo «2026», que va incompleto: definan un periodo de 12 meses completos.
4. **Diferenciarse del caso de clase.** TecnoSmart se parece mucho a TecnoAndina, el caso que usamos en clase (tecnología, sedes, portátiles). Diferéncienlo con productos, sedes, canal o problema propios, para que no sea el mismo caso con otro nombre.

## 4. Estructura de datos esperada (solo la forma)

Conviene revisar ya la estructura de los datos. Como el problema mezcla margen e inventario, el modelo necesita ventas e inventario:

```
                 Dim_Calendario
                   |        |
Dim_Producto -- Fact_Venta  Fact_Inventario_Mensual -- Dim_Producto
                   |        |
               Dim_Sede ----+
                   |
               Dim_Canal
```

### Fact_Venta (grano: una fila por línea de factura)

| Columna | Tipo | Descripción |
|---|---|---|
| id_factura | Texto | Número de la factura |
| fecha | Fecha | Día de la venta |
| id_sede | Texto | Sede que vende (o «En línea») |
| id_canal | Texto | Tienda física, En línea, Ventas corporativas |
| id_producto | Texto | Producto |
| cantidad | Entero | Unidades vendidas |
| precio_unitario | Decimal | Precio de venta |
| descuento | Decimal | Valor del descuento |
| costo_unitario | Decimal | Costo de compra |

### Fact_Inventario_Mensual (grano: una fila por sede, producto y mes)

| Columna | Tipo | Descripción |
|---|---|---|
| mes | Fecha | Primer día del mes |
| id_sede | Texto | Sede |
| id_producto | Texto | Producto |
| existencia_inicial | Entero | Unidades al iniciar el mes |
| compras | Entero | Unidades que entraron |
| existencia_final | Entero | Unidades al cerrar el mes |
| dias_sin_stock | Entero | Días del mes con existencia 0 |

### Dim_Producto

| Columna | Tipo | Descripción |
|---|---|---|
| id_producto | Texto | Código |
| producto | Texto | Nombre |
| categoria | Texto | Computadores, Celulares, Tabletas, Accesorios, Equipos empresariales |
| marca | Texto | Marca |
| costo_referencia | Decimal | Costo de compra de referencia |

### Dim_Sede, Dim_Canal y Dim_Calendario

| Tabla | Columnas |
|---|---|
| Dim_Sede | id_sede, sede, ciudad, tipo_sede |
| Dim_Canal | id_canal, canal, comision_pct |
| Dim_Calendario | fecha, anio, trimestre, mes, nombre_mes, dia_semana, es_festivo, temporada |

### KPI y datos que necesitan

| KPI | Fórmula | Datos |
|---|---|---|
| Margen bruto % (principal) | (ventas netas − costo de ventas) / ventas netas × 100 | Fact_Venta |
| Participación en ventas | ventas del producto o sede / ventas totales × 100 | Fact_Venta |
| Rotación de inventario | costo de ventas / inventario promedio valorizado | Fact_Venta + Fact_Inventario_Mensual |
| Días sin stock | suma de dias_sin_stock | Fact_Inventario_Mensual |

## 5. Nota final

Tengan cuidado con tres cosas:

1. **Las instrucciones.** Lean completa la guía publicada en Moodle antes de entregar cada fase.
2. **La congruencia.** El problema, la pregunta, los KPI y los datos deben hablar de lo mismo.
3. **El uso de IA.** Usar IA es válido, pero con supervisión: revisen, ajusten y entiendan todo lo que entregan. En la sustentación cada integrante responde por el proyecto completo.

## 6. Para la Fase 1 (jueves 5 de noviembre)

- Retirar el Excel del repositorio y crear `15-week/proyecto-aula/README.md` con la ficha (integrantes, empresa, problema, pregunta, KPI, fuentes y periodo).
- Generar el dataset con la estructura propuesta (o la que ajusten), cargarlo en Power Query, documentar los pasos aplicados y escribir el diccionario de datos.
