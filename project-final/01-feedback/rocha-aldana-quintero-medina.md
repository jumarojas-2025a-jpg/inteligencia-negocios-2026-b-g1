# Retroalimentación · Fase 0 (Definición)

**Proyecto:** Moto Riders, concesionario de motos (Neiva)
**Estudiantes:** Jonathan Andrés Rocha Aldana y Julián Andrés Quintero Medina
**Revisión:** jueves 29 de octubre de 2026 · Docente Jesús Ariel González Bonilla
**Avance revisado:** fork `jarra3`, carpeta `13-week/02-optional-activity/` (commit «concesionario de motos»)

El problema es de negocio real: referencias de baja rotación que llenan el almacenamiento y la duda de si cada modelo cumple la meta mínima para ser rentable. Ya tienen un dataset con 1.150 ventas de 12 meses y una versión limpia. Los puntos siguientes son para ajustar antes de la Fase 1 (jueves 5 de noviembre).

## 1. Seguir las instrucciones

- **Ruta y formato.** La ficha quedó en un PDF de 6 páginas (24 MB) dentro de `13-week/02-optional-activity/`, que es la carpeta de las actividades opcionales. La guía pide la ficha en `15-week/proyecto-aula/README.md`, en Markdown, con la tabla de la sección 4. Muevan ahí el proyecto.
- **El PDF es un folleto, no una ficha.** Trae textos de plantilla («+123 456 7890», «contacto@motoriders.com», «Te esperamos en nuestra concesionaria») que no aportan al proyecto. La ficha debe tener integrantes, empresa y tipo (real o ficticia), problema, pregunta, KPI con fórmula, fuentes y autorización.
- **Integrantes.** Declaren los dos nombres en la ficha. El fork de Julián no tiene nada del proyecto: indiquen cuál es el repositorio del proyecto (uno solo).

## 2. Congruencia del planteamiento

1. **Una sola pregunta, concreta y medible.** La actual mezcla dos preguntas («cuál referencia se debe aumentar» y «cuáles no cumplen el tope»). Ejemplo: «¿Qué referencias y qué sedes de Moto Riders no alcanzaron la meta mínima de unidades vendidas por trimestre en 2025?».
2. **Los KPI no son preguntas.** En «Preguntas KPI» escribieron preguntas. Cada KPI necesita nombre y fórmula. Por ejemplo:

   | KPI | Fórmula |
   |---|---|
   | Cumplimiento de meta % (principal) | unidades vendidas / meta mínima de unidades × 100 |
   | Rotación de inventario | unidades vendidas / inventario promedio |
   | Tasa de recompra % | clientes con más de una compra / clientes totales × 100 |
   | Participación por referencia % | ventas de la referencia / ventas totales × 100 |

3. **El problema exige datos que todavía no tienen.** Hablan de baja rotación, sobrepedidos y meta mínima de rentabilidad, pero el dataset solo trae ventas. Para responder hace falta:
   - **inventario** por sede y referencia (existencias y pedidos) para medir la rotación y el sobrepedido;
   - **la meta mínima** por referencia, escrita y justificada;
   - **el costo** de cada moto, si quieren hablar de rentabilidad.

## 3. Revisión de los datos

| Hallazgo | Detalle |
|---|---|
| Fechas en el futuro | Los datos van del 1 de enero al 31 de diciembre de **2026**, pero hoy es 29 de octubre de 2026: noviembre y diciembre aún no han ocurrido. Usen 2025. |
| Datos personales | La columna `NOMBRE` trae nombres de clientes, y el repositorio es público. Reemplácenla por un código de cliente. |
| El archivo limpio no cuadra con el sucio | El archivo con errores tiene 21 filas duplicadas; el limpio tiene el mismo número de filas (1.150), pero distinto conteo por referencia y por sede (por ejemplo, YZ150 pasa de 431 a 436 ventas). Si se quitaron duplicados, deberían quedar menos filas y nunca más ventas de una referencia. Revisen y documenten cada paso de la limpieza con su antes y después. |
| Pocas variables | Cuatro referencias, cuatro sedes y un precio fijo por referencia. Agreguen cantidad, descuento, canal o forma de pago (contado o financiado), que el folleto menciona como servicio. |
| Sedes | El folleto da una sola dirección y los datos tienen cuatro sedes (Centro, Norte, Sur, Oriente). Aclárenlo en la ficha. |

## 4. Formato de datos propuesto (solo la forma)

```
                 Dim_Calendario
                   |        |
Dim_Referencia -- Fact_Venta  Fact_Inventario_Mensual -- Dim_Referencia
                   |        |
               Dim_Sede ----+
                   |
              Dim_Cliente (código)
```

| Tabla | Grano | Columnas |
|---|---|---|
| Fact_Venta | una fila por moto vendida | id_venta, fecha, id_sede, id_referencia, id_cliente, precio_venta, descuento, forma_pago |
| Fact_Inventario_Mensual | sede, referencia y mes | mes, id_sede, id_referencia, existencia_inicial, unidades_pedidas, existencia_final |
| Dim_Referencia | una fila por referencia | id_referencia, referencia, marca, cilindraje, tipo (trabajo, enduro, deportiva), costo, precio_lista, meta_minima_trimestral |
| Dim_Sede | una fila por sede | id_sede, sede, zona de Neiva |
| Dim_Cliente | una fila por cliente | id_cliente (sin nombre), ciudad, tipo_cliente |
| Dim_Calendario | un día por fila | fecha, anio, trimestre, mes, nombre_mes |

## 5. Para la Fase 1 (jueves 5 de noviembre)

- Crear `15-week/proyecto-aula/README.md` con la ficha completa y retirar el folleto de la carpeta de actividades opcionales.
- Ajustar la pregunta y escribir los KPI con fórmula y la meta mínima por referencia.
- Regenerar los datos para 2025, sin nombres de clientes y con inventario; cargarlos en Power Query, documentar cada paso aplicado y escribir el diccionario de datos.
