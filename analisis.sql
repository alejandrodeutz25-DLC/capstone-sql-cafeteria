-- consulta para detectar productos sin precios para evitar calcular mal los gastos.
SELECT nombre, precio
FROM productos
WHERE precio IS NULL;

-- consulta para detectar pedidos sin fecha para evitar sumarlos erroneamente en un conteo mensual.
SELECT pedido_id, cliente_id, producto_id, fecha_pedido
FROM pedidos
WHERE fecha_pedido IS NULL;
-- Los pedidos sin fecha decido dejarlos con los null: no me limita sumarlos al total, pero no los considero en el reporte mensual para no adulterar resultados.

-- reemplazo de nulos en los precios para evitar errores en la facturacion.
SELECT nombre, precio, COALESCE(precio, 0) AS precio_final
FROM productos;

-- Top 5 clientes que mas compran, para cuidarlos ya que suman a la facturacion de manera significativa.
SELECT clientes.nombre,
       SUM(pedidos.cantidad * COALESCE(productos.precio, 0)) AS gasto_total
FROM pedidos
JOIN clientes ON pedidos.cliente_id = clientes.cliente_id
JOIN productos ON pedidos.producto_id = productos.producto_id
GROUP BY clientes.nombre
ORDER BY gasto_total DESC
LIMIT 5;

-- Ventas mensuales: sirve para comparar que meses facturan mejor. Los 3 pedidos sin fecha quedan fuera por no saber a que mes corresponden.
SELECT DATE_TRUNC('month', pedidos.fecha_pedido) AS mes,
       SUM(pedidos.cantidad * COALESCE(productos.precio, 0)) AS ventas_totales
FROM pedidos
JOIN productos ON pedidos.producto_id = productos.producto_id
WHERE pedidos.fecha_pedido IS NOT NULL
GROUP BY mes
ORDER BY mes;

-- Productos menos vendidos: ayuda a decidir si promocionarlos o sacarlos de la carta.
SELECT productos.nombre, productos.categoria,
       COALESCE(SUM(pedidos.cantidad), 0) AS unidades_vendidas
FROM productos
LEFT JOIN pedidos ON productos.producto_id = pedidos.producto_id
GROUP BY productos.nombre, productos.categoria
ORDER BY unidades_vendidas ASC
LIMIT 3;

-- Ranking de productos dentro de cada categoria: sirve para saber cual lidera y cual queda ultimo, para decidir promociones o bajas de carta.
SELECT productos.categoria, productos.nombre,
       COALESCE(SUM(pedidos.cantidad), 0) AS unidades_vendidas,
       RANK() OVER (PARTITION BY productos.categoria
                    ORDER BY COALESCE(SUM(pedidos.cantidad), 0) DESC) AS ranking
FROM productos
LEFT JOIN pedidos ON productos.producto_id = pedidos.producto_id
GROUP BY productos.categoria, productos.nombre
ORDER BY productos.categoria, ranking;
