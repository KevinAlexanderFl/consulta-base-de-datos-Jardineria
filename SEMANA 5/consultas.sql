# Listar información básica de las oficinas
SELECT codigo_oficina, ciudad, pais, telefono 
FROM oficina;

# Obtener los empleados por oficina
SELECT codigo_oficina, nombre, apellido1,apellido2, puesto 
FROM empleado 
GROUP BY codigo_oficina, nombre, apellido1,apellido2, puesto;

# Calcular el promedio de salario (límite de crédito) de los clientes por región
SELECT region, AVG(limite_credito) AS promedio_limite_credito 
FROM cliente 
GROUP BY region;

# Listar clientes con sus representantes de ventas
SELECT nombre_cliente, CONCAT(nombre, ' ', apellido_contacto) AS representante_ventas 
FROM cliente 
JOIN empleado e ON codigo_empleado_rep_ventas = codigo_empleado;

# Obtener productos disponibles y en stock
SELECT codigo_producto, nombre, cantidad_en_stock 
FROM producto 
WHERE cantidad_en_stock > 0;

# Productos con precios por debajo del promedio
SELECT codigo_producto, nombre, precio_venta 
FROM producto 
WHERE precio_venta < (SELECT AVG(precio_venta) FROM producto);

# Pedidos pendientes por cliente
SELECT p.codigo_pedido, p.estado, c.nombre_cliente 
FROM pedido p
JOIN cliente c ON p.codigo_cliente = c.codigo_cliente 
WHERE p.estado != 'Entregado';

# Total de productos por categoría (gama)
SELECT gama, COUNT(*) AS total_producto
FROM producto 
GROUP BY gama;

# Ingresos totales generados por cliente
SELECT codigo_cliente, SUM(total) AS ingresos_totales 
FROM pago
GROUP BY codigo_cliente;

# Pedidos realizados en un rango de fechas
SELECT codigo_pedido, fecha_pedido 
FROM pedido 
WHERE fecha_pedido BETWEEN '2006-01-17' AND '2008-07-28';

# Detalles de un pedido específico
SELECT codigo_pedido, codigo_producto, cantidad, (cantidad * precio_unidad) AS total_linea 
FROM detalle_pedido 
WHERE codigo_pedido = '16';

# Productos más vendidos
SELECT codigo_producto, SUM(cantidad) AS total_vendido 
FROM detalle_pedido 
GROUP BY codigo_producto 
ORDER BY total_vendido DESC;

# Pedidos con un valor total superior al promedio
SELECT codigo_pedido, SUM(cantidad * precio_unidad) AS valor_total 
FROM  detalle_pedido
GROUP BY codigo_pedido 
HAVING valor_total > (SELECT AVG(cantidad * precio_unidad) FROM detalle_pedido);

# Clientes sin representante de ventas asignado
SELECT nombre_cliente 
FROM cliente
WHERE codigo_empleado_rep_ventas IS NULL;

# Número total de empleados por oficina
SELECT codigo_oficina, COUNT(*) AS total_empleado
FROM empleado
GROUP BY codigo_oficina;

# Pagos realizados en una forma específica
SELECT * 
FROM pago 
WHERE forma_pago = 'PayPal';

# Ingresos mensuales
SELECT MONTH(fecha_pago) AS mes, SUM(total) AS ingresos_totales 
FROM pago
GROUP BY mes;

# Clientes con múltiples pedidos
SELECT nombre_cliente
FROM pedido
JOIN cliente ON pedido.codigo_cliente = cliente.codigo_cliente 
GROUP BY nombre_cliente 
HAVING COUNT(*) > 1;


# Pedidos con productos agotados
SELECT p.codigo_pedido, d.codigo_producto 
FROM pedido p
JOIN detalle_pedido d ON p.codigo_pedido = d.codigo_pedido 
JOIN producto prod ON d.codigo_producto = prod.codigo_producto 
WHERE prod.cantidad_en_stock = 0;

# Promedio, máximo y mínimo del límite de crédito de los clientes por país
SELECT pais, AVG(limite_credito) AS promedio_credito, 
       MAX(limite_credito) AS maximo_credito, 
       MIN(limite_credito) AS minimo_credito 
FROM cliente 
GROUP BY pais;


# Historial de transacciones de un cliente
SELECT codigo_cliente,fecha_pago, total, forma_pago 
FROM pago
WHERE codigo_cliente = '1';

# Empleados sin jefe directo asignado
SELECT nombre, apellido1,apellido2 
FROM empleado
WHERE codigo_jefe IS NULL;

# Productos cuyo precio supera el promedio de su categoría (gama)
SELECT codigo_producto, nombre, precio_venta,gama
FROM producto p1 
WHERE precio_venta > (SELECT AVG(precio_venta) 
                      FROM producto p2 
                      WHERE p1.gama = p2.gama);

# Promedio de días de entrega por estado
SELECT estado, AVG(DATEDIFF(fecha_entrega, fecha_pedido)) AS promedio_dias 
FROM pedido 
GROUP BY estado;

# Clientes por país con más de un pedido
SELECT c.pais,c.codigo_cliente,COUNT(p.codigo_pedido) AS numero_pedidos
FROM cliente c
JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
GROUP BY  c.pais, c.codigo_cliente
HAVING COUNT(p.codigo_pedido) > 1
ORDER BY c.pais, numero_pedidos DESC;

