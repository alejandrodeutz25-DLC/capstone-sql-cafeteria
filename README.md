# Análisis de ventas - Cafetería de especialidad

## Problema de negocio
Una cafetería de especialidad quiere entender su operación para tomar mejores
decisiones: saber quiénes son sus mejores clientes, cómo evolucionan las ventas
mes a mes, qué productos casi no se venden y qué producto lidera cada categoría
de la carta.

## Base de datos
- Base: capstone_project (PostgreSQL)
- 3 tablas: clientes, productos, pedidos
- Datos: 30 clientes, 36 productos, 100 pedidos (enero a octubre 2027)

## Limpieza de datos
- 2 productos sin precio (Menú ejecutivo y Smoothie verde): se tomaron como 0
  con COALESCE, por lo que la facturación real es algo mayor a la reportada.
- 3 pedidos sin fecha: se incluyen en los totales, pero se excluyen del reporte
  mensual para no adulterar la comparación entre meses.
- 8 pedidos de consumidor final (sin cliente): quedan fuera del ranking de
  clientes, pero sí cuentan en las ventas por mes.

## Hallazgos principales

### Top 5 clientes por gasto
Victoria Giménez lidera con $116.000, casi el doble del segundo cliente.
Conviene cuidar a este grupo porque concentra buena parte de la facturación.

### Ventas por mes
Agosto ($114.600) y octubre ($106.800) fueron los meses más fuertes, y febrero
el más flojo ($29.200). Los datos por sí solos no explican la causa de los
picos, que probablemente responda a factores externos (clima, estacionalidad,
poder de compra). Acción sugerida: reforzar promociones en los meses flojos y
ajustar stock y personal según la demanda de cada mes.

### Productos menos vendidos
Los 3 productos con menos ventas fueron Chemex, Rogel y Sifón japonés, con 0
unidades. Dos de tres son métodos de filtrado: productos caros y de preparación
lenta. Habría que decidir si mantenerlos, promocionarlos o sacarlos de la carta.

### Ranking por categoría
Cada categoría tiene un líder claro: Latte grande domina el café caliente
(14 unidades) e Iced latte lidera las bebidas frías. El resto de cada categoría
queda bastante parejo detrás. Sirve para saber en qué producto apoyarse dentro
de cada rubro.

## Cómo ejecutar el proyecto
1. Ejecutar estructura.sql: crea las tablas clientes, productos y pedidos, y
   carga los datos dentro de una transacción (BEGIN ... COMMIT).
2. Ejecutar analisis.sql: reproduce las 4 consultas de análisis, cada una
   comentada.
Requisitos: PostgreSQL y pgAdmin.
