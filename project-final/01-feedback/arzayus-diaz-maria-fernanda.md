# Retroalimentación · Fase 0 (Definición)

**Proyecto:** Hotel Brisas de la Tatacoa S.A.S.
**Estudiante:** María Fernanda Arzayus Díaz
**Revisión:** jueves 29 de octubre de 2026 · Docente Jesús Ariel González Bonilla

La ficha está completa y bien planteada: la empresa, el problema y los tres KPI tienen sentido para un hotel. Los puntos siguientes son para ajustar antes de la Fase 1 (jueves 5 de noviembre).

## 1. Ajustes a la ficha

1. **Volumen y periodo del dataset.** La guía exige, para una empresa ficticia, al menos 1.000 filas, 3 dimensiones y 12 meses de datos. La ficha debe decir cuántas filas tendrá el dataset y qué periodo cubre (por ejemplo, enero a diciembre de 2025).
2. **Noches disponibles.** Ese dato no sale de las reservas. Hace falta una tabla de capacidad: habitaciones por tipo multiplicadas por los días del periodo.
3. **Pregunta de negocio.** «¿Cómo varían…?» es descriptiva. Conviene fijar el periodo y orientarla a una decisión. Ejemplo: «¿En qué temporadas y por qué canales debe el hotel lanzar promociones para subir la ocupación del segundo semestre de 2025?».

## 2. Recomendaciones adicionales

### 2.1 Capacidad instalada no es lo mismo que capacidad disponible

- **Capacidad instalada:** todas las habitaciones que tiene el hotel, todos los días.
- **Capacidad disponible:** la instalada menos las habitaciones que no se pueden vender ese día: mantenimiento, bloqueo por un evento, uso interno u otra novedad del hotel.

La tasa de ocupación se calcula sobre la capacidad **disponible**. Si se calcula sobre la instalada, el hotel parece más vacío de lo que está en los meses de mantenimiento. Se sugiere mostrar los dos indicadores en el tablero:

- Ocupación real = noches ocupadas / noches disponibles × 100
- Noches perdidas por novedad = noches instaladas − noches disponibles

### 2.2 El KPI debe leerse por temporada

La ocupación de un hotel turístico cambia mucho entre temporadas. El dataset debe traer datos de **temporada baja, media y alta**, y el calendario debe tener una columna que marque la temporada de cada día (por ejemplo: alta en diciembre-enero, Semana Santa y vacaciones de mitad de año; media en puentes festivos; baja el resto). Así el KPI se puede comparar entre temporadas y no solo entre meses.

### 2.3 Un dataset sintético más rico

Además de las reservas, se sugiere que el dataset aborde otros casos reales de la empresa:

- **Clientes frecuentes:** clientes que vuelven varias veces en el año (identificados con un código, nunca con datos personales).
- **Clientes que cancelan:** con el motivo, la anticipación de la cancelación y el canal por donde reservaron.
- **Reprocesos administrativos:** lo que genera una cancelación o un cambio: reembolsos, reasignación de habitación, modificación de fechas, reclamos. Cada reproceso tiene un tiempo y un costo para el hotel.

Con eso se pueden agregar KPI de apoyo como el porcentaje de clientes recurrentes, la tasa de cancelación por canal y los reprocesos por cada 100 reservas.

### 2.4 Identificar desde ya las columnas

Conviene definir desde ahora qué columnas necesita, para que el dataset que genere en la Fase 1 sirva para responder la pregunta de negocio.

## 3. Formato propuesto (solo la forma)

Esta es una propuesta de estructura para el modelo estrella. No trae datos: sirve de guía para generar el dataset y escribir el diccionario de datos de la Fase 1. Puede ajustarla.

```
                 Dim_Calendario
                       |
Dim_Cliente ---- Fact_Reserva ---- Dim_Canal
                       |
                 Dim_Habitacion ---- Fact_Disponibilidad_Diaria ---- Dim_Calendario
                       |
                 Fact_Reproceso ---- Dim_Tipo_Reproceso
```

### Fact_Reserva (grano: una fila por reserva)

| Columna | Tipo | Descripción |
|---|---|---|
| id_reserva | Texto | Código único de la reserva |
| fecha_reserva | Fecha | Día en que se hizo la reserva |
| fecha_llegada | Fecha | Día de entrada (se relaciona con Dim_Calendario) |
| fecha_salida | Fecha | Día de salida |
| noches | Entero | Noches reservadas |
| id_habitacion | Texto | Habitación asignada |
| id_cliente | Texto | Código del cliente (sin datos personales) |
| id_canal | Texto | Canal de la reserva |
| huespedes | Entero | Número de personas |
| tarifa_noche | Decimal | Valor cobrado por noche |
| valor_total | Decimal | noches × tarifa_noche |
| estado | Texto | Confirmada, Cancelada, No show |
| fecha_cancelacion | Fecha | Vacía si no se canceló |
| motivo_cancelacion | Texto | Vacío si no se canceló |

### Fact_Disponibilidad_Diaria (grano: una fila por habitación y día)

| Columna | Tipo | Descripción |
|---|---|---|
| fecha | Fecha | Día |
| id_habitacion | Texto | Habitación |
| estado_dia | Texto | Disponible, Ocupada, Mantenimiento, Bloqueo por evento, Uso interno |
| vendible | Entero | 1 si la habitación se podía vender ese día, 0 si no |
| ocupada | Entero | 1 si estuvo ocupada, 0 si no |

### Fact_Reproceso (grano: una fila por gestión administrativa)

| Columna | Tipo | Descripción |
|---|---|---|
| id_reproceso | Texto | Código de la gestión |
| id_reserva | Texto | Reserva que lo originó |
| fecha | Fecha | Día de la gestión |
| id_tipo_reproceso | Texto | Tipo de gestión |
| minutos | Entero | Tiempo que tomó al personal |
| costo | Decimal | Costo para el hotel (reembolso, comisión, horas de trabajo) |

### Dim_Calendario

| Columna | Tipo | Descripción |
|---|---|---|
| fecha | Fecha | Un día por fila, sin huecos |
| anio, mes, nombre_mes, trimestre | Entero / Texto | Jerarquía para el drill-down |
| dia_semana | Texto | Lunes a domingo |
| es_festivo | Booleano | Festivo en Colombia |
| temporada | Texto | Baja, Media, Alta |

### Dim_Habitacion

| Columna | Tipo | Descripción |
|---|---|---|
| id_habitacion | Texto | Código de la habitación |
| tipo | Texto | Sencilla, Doble, Familiar, Suite… |
| capacidad_personas | Entero | Máximo de huéspedes |
| tarifa_base | Decimal | Tarifa de referencia por noche |

### Dim_Cliente

| Columna | Tipo | Descripción |
|---|---|---|
| id_cliente | Texto | Código del cliente |
| ciudad_origen | Texto | Ciudad desde donde viaja |
| tipo_cliente | Texto | Turista, Corporativo, Grupo |
| fecha_primera_visita | Fecha | Para calcular la recurrencia |

### Dim_Canal

| Columna | Tipo | Descripción |
|---|---|---|
| id_canal | Texto | Código del canal |
| canal | Texto | Directo, Booking, WhatsApp, Agencia… |
| comision_pct | Decimal | Comisión que cobra el canal |

### Dim_Tipo_Reproceso

| Columna | Tipo | Descripción |
|---|---|---|
| id_tipo_reproceso | Texto | Código |
| tipo_reproceso | Texto | Reembolso, Reasignación, Cambio de fechas, Reclamo |
| area_responsable | Texto | Recepción, Contabilidad, Reservas |

## 4. Para la Fase 1 (jueves 5 de noviembre)

- Actualizar la ficha con el volumen, el periodo y la pregunta ajustada.
- Generar el dataset sintético con esta estructura (o la que usted ajuste), con al menos 1.000 reservas en 12 meses y con diferencias claras entre temporadas.
- Cargarlo en Power Query, documentar los pasos aplicados y escribir el diccionario de datos.
