-- CONSULTAS MULTITABLA (COMPOSICIÓN INTERNA)

-- 1. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.
SELECT DISTINCT c. nombre_cliente AS CLIENTE, e.nombre AS EMPLEADO
FROM cliente c 
JOIN pago p ON c. codigo_cliente = p. codigo_cliente
JOIN empleado e ON e.codigo_empleado = c. codigo_empleado_rep_ventas;
-- 2. Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas.
SELECT DISTINCT c. nombre_cliente AS CLIENTE, e. nombre AS EMPLEADO
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE p.codigo_cliente IS NULL;
-- 3. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.

-- 4. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.

-- 5. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.
SELECT DISTINCT o.linea_direccion1 AS OFICINA, c.ciudad AS CIUDAD
FROM oficina o
JOIN empleado e ON e.codigo_oficina = o.codigo_oficina
JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c. ciudad = "Fuenlabrada";
-- 6. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
SELECT DISTINCT c. nombre_cliente AS CLIENTE, e.nombre AS REPRE, o.ciudad AS CIUDAD
FROM cliente c
JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas
JOIN oficina o ON o.codigo_oficina = e.codigo_oficina
ORDER BY c. nombre_cliente;
-- 6.2 MEJORADA Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
SELECT DISTINCT c. nombre_cliente AS CLIENTE, e.nombre AS REPRE, o.ciudad AS CIUDAD, c.limite_credito AS CREDITO
FROM cliente c
JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas
JOIN oficina o ON o.codigo_oficina = e.codigo_oficina
WHERE O.ciudad="paris" AND c.limite_credito > 5000;
-- 7. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes. LE GUSTA MUCHO A FRAN
SELECT e1.nombre AS E1, e1.codigo_jefe AS E1, e2.nombre AS E2, e2.codigo_jefe AS E
FROM empleado e1
JOIN empleado e2 ON e2.codigo_jefe = e1.codigo_empleado;
-- 8. Devuelve un listado que muestre el nombre de cada empleado, el nombre de su jefe y el nombre del jefe de su jefe.
SELECT e1.nombre AS JEFAZO,e2.nombre AS JEFE, e3.nombre AS EMPLEADO
FROM empleado e1
JOIN empleado e2 ON e2.codigo_jefe = e1.codigo_empleado
JOIN empleado e3 ON e2.codigo_empleado=e3.codigo_jefe;
-- 9. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
SELECT  c. nombre_cliente AS CLIENTE, p.estado AS ESTADO, p.codigo_pedido AS PEDIDO
FROM cliente c
JOIN pedido p ON p.codigo_cliente=c.codigo_cliente
WHERE p.fecha_entrega > p.fecha_esperada AND estado="entregado";
-- 10. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.
SELECT DISTINCT pr.gama AS GAMA , c.nombre_cliente AS CLIENTE
FROM cliente c
JOIN pedido p ON p.codigo_cliente=c.codigo_cliente
JOIN detalle_pedido d ON p.codigo_pedido= d.codigo_pedido
JOIN producto pr ON pr.codigo_producto= d.codigo_producto;

-- CONSULTAS MULTITABLA (COMPOSICIÓN EXTERNA)

-- 1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido
SELECT DISTINCT c.*
FROM cliente c
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;
-- 2. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado ningún pedido.
SELECT DISTINCT c.nombre_cliente, pa.codigo_cliente, p.codigo_cliente
FROM cliente c
LEFT JOIN pedido p ON p.codigo_cliente = c.codigo_cliente
LEFT JOIN pago pa ON pa.codigo_cliente = c.codigo_cliente
WHERE p.codigo_cliente IS NULL AND pa.codigo_cliente IS NULL;
-- 3. Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.
SELECT e.nombre AS EMPLEADO
FROM empleado e
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE e.codigo_oficina IS NULL;
-- 4. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.
SELECT e.nombre AS EMPLEADO, c.codigo_empleado_rep_ventas, c.nombre_cliente
FROM empleado e 
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_empleado_rep_ventas IS NULL;
-- 5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado junto con los datos de la oficina donde trabajan.
SELECT DISTINCT e. nombre AS EMPLEADO, c.codigo_empleado_rep_ventas, e.codigo_oficina, o.region
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_empleado_rep_ventas IS NULL;
-- 6. Devuelve un listado que muestre los empleados que no tienen una oficina asociada o los que no tienen un cliente asociado.
SELECT e.nombre AS EMPLEADO, o.codigo_oficina AS OFICINA
FROM empleado e 
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
LEFT join cliente c ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE e.codigo_oficina IS NULL OR c.codigo_empleado_rep_ventas IS NULL;
-- 7. Devuelve un listado de los productos que nunca han aparecido en un pedido.
SELECT p.nombre AS PRODUCTO, dp.codigo_pedido AS PEDIDO
FROM producto p
LEFT JOIN detalle_pedido dp ON p.codigo_producto = dp.codigo_producto
WHERE dp.codigo_pedido IS NULL;
-- 9. Devuelve las oficinas donde no trabajan ninguno de los empleados 
-- que hayan sido los representantes de ventas de 
-- algún cliente que haya realizado la compra de algún producto de la gama Frutales.
SELECT o.codigo_oficina 
FROM oficina o 
LEFT JOIN empleado e ON o.codigo_oficina = e.codigo_oficina
JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
JOIN pedido p ON c.codigo_empleado_rep_ventas = p.codigo_cliente
JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido
JOIN producto pr ON pr.codigo_producto = dp.codigo_producto
JOIN gama_producto gm ON pr.gama = gm.gama
WHERE e.codigo_oficina IS NULL;
-- 10. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.
SELECT DISTINCT c.nombre_cliente AS MOROSOS, pe.codigo_cliente AS PEDIDO, pa.codigo_cliente AS PAGO
FROM cliente c 
JOIN pedido pe ON pe.codigo_cliente = c.codigo_cliente
LEFT JOIN pago pa ON pa.codigo_cliente = c.codigo_cliente
WHERE pa.codigo_cliente IS NULL;

-- CONSULTAS VARIADAS

-- 1. Devuelve el listado de clientes indicando el nombre del cliente y cuántos pedidos ha realizado.
SELECT c.nombre_cliente AS CLIENTE, COUNT(p.codigo_cliente) AS NUM_PEDIDOS
FROM cliente c
JOIN pedido p ON p.codigo_cliente = c.codigo_cliente
GROUP BY c.nombre_cliente
ORDER BY NUM_PEDIDOS;
-- 2. Devuelve un listado con los nombres de los clientes y el total pagado por cada uno de ellos.
SELECT c.nombre_cliente AS CLIENTE, SUM(p.total) AS TOTAL_PAGADO
FROM cliente c
JOIN pago p ON p.codigo_cliente=c.codigo_cliente
GROUP BY c.nombre_cliente
ORDER BY TOTAL_PAGADO DESC;
-- 3. Devuelve el nombre de los clientes que hayan hecho pedidos en 2008 ordenados alfabéticamente.
SELECT DISTINCT c.nombre_cliente AS CLIENTE, YEAR(p.fecha_pedido) AS FECHA
FROM cliente c
JOIN pedido p ON c.codigo_cliente= p.codigo_cliente
WHERE YEAR(p.fecha_pedido) = 2008
ORDER BY c.nombre_cliente;