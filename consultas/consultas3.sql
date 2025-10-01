-- **12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año.
SELECT p.codigo_pedido AS PEDIDO, p.fecha_entrega AS FECHA
FROM pedido p
WHERE MONTH(p.fecha_entrega) = 01;
-- **13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. Ordene el resultado de mayor a menor.
SELECT pa.total AS PAGO, pa.fecha_pago AS FECHA, pa.forma_pago AS FORMA_PAGO
FROM pago pa
WHERE YEAR(pa.fecha_pago) = 2008 AND pa.forma_pago = "Paypal"
ORDER BY pa.total DESC;

-- **15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio.
 SELECT DISTINCT pr.nombre AS NOMBRE_PRODUCTO, pr.cantidad_en_stock, pr. precio_venta
 FROM producto pr
 WHERE pr.gama = "Ornamentales" AND pr.cantidad_en_stock > 100
 ORDER BY pr. precio_venta DESC;

-- 4. Devuelve el nombre del cliente, el nombre y primer apellido de su representante de ventas y el número de teléfono de la oficina del representante de ventas, de aquellos clientes que no hayan realizado ningún pago.
SELECT DISTINCT c.nombre_cliente AS CLIENTE, e.nombre AS EMPLEADO, e.apellido1 AS APELLIDO, o.telefono AS TELEFONO
FROM cliente c
JOIN empleado e ON e.codigo_empleado=c.codigo_empleado_rep_ventas
JOIN oficina o ON o.codigo_oficina= e.codigo_oficina
LEFT JOIN pago p ON c.codigo_cliente=p.codigo_cliente
WHERE p.codigo_cliente IS NULL;
-- 5. Devuelve el listado de clientes donde aparezca el nombre del cliente, el nombre y primer apellido de su representante de ventas y la ciudad donde está su oficina.
SELECT DISTINCT c.nombre_cliente AS CLIENTE, e.nombre AS EMPLEADO, e.apellido1 AS APELLIDO, o.ciudad AS CIUDAD
FROM cliente c
JOIN empleado e ON e.codigo_empleado=c.codigo_empleado_rep_ventas
JOIN oficina o ON o.codigo_oficina= e.codigo_oficina;
-- 6. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representantes de ventas de ningún cliente.
SELECT e.nombre AS EMPLEADO, e.apellido1 AS APELLIDO, e.apellido2 AS APELLIDO, e.puesto AS PUESTO, o.telefono AS TELEFONO
FROM empleado e
JOIN oficina o ON o.codigo_oficina= e.codigo_oficina
LEFT JOIN cliente c ON c.codigo_empleado_rep_ventas= e.codigo_empleado
WHERE c.codigo_empleado_rep_ventas IS NULL;

-- 7. Devuelve un listado indicando todas las ciudades donde hay oficinas y el número de empleados que tiene.
SELECT o.ciudad AS CIUDAD, COUNT(e.codigo_empleado) AS NUM_EMPLEADOS, o.codigo_oficina AS COD_OFICINA
FROM oficina o
JOIN empleado e ON e.codigo_oficina=o.codigo_oficina
GROUP BY o.codigo_oficina;
-- 1. ¿Cuántos empleados hay en la compañía?
SELECT COUNT(*) AS NUM_EMP
FROM empleado;
-- 2. ¿Cuántos clientes tiene cada país?
SELECT COUNT(*) AS NUM_EMPLEADOS, pais
FROM cliente
GROUP BY pais;
-- 3. ¿Cuál fue el pago medio en 2009?
SELECT AVG(total) AS PAGO_MEDIA
FROM pago
WHERE YEAR(fecha_pago) = 2009;
-- 1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.
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
-- Muestra el nombre y la edad de todos los jugadores cuyo nombre empiece por "V"
SELECT nombre, edad
FROM jugador
WHERE nombre LIKE "V%";

-- Muestra el numero de goles (locales y visitantes) de los partidos jugados en septiembre
SELECT goles_local, goles_visitante, fecha
FROM partido
WHERE fecha  BETWEEN "2023-09-01" AND "2023-09-30";

-- Menos chapucera con expresiones regulares
SELECT goles_local, goles_visitante, fecha
FROM partido
WHERE fecha LIKE "2023-09-%"; -- "%-09-%" cualquier dia o año de septiembre

-- Seria god con funciones de SQL
SELECT goles_local, goles_visitante, fecha
FROM partido
WHERE MONTH(fecha) = 9 AND YEAR(fecha) = 2023;

-- Muestra el nombre y la posicion de todos los jugadores que sean delanteros y tengan mas de 25 años
-- ordenalos primero por edad (desc) y luego por orden alfabetico en funcion del nombre
SELECT nombre, posicion, edad
FROM jugador
WHERE posicion = "Delantero" AND edad > 25
ORDER BY edad DESC, nombre;


-- GROUP BY: Agrupa los resultados de las funciones de agregado a través de un campo
-- Muestra el numero de goles locales que ha marcado cada equipo local
SELECT equipo_local, SUM(goles_local) AS GOLES_LOCALES_TOTAL
FROM partido
GROUP BY equipo_local;

-- Muestra la diferencia de goles de cada partido
SELECT equipo_local, SUM(goles_local- goles_visitante)
FROM partido
GROUP BY equipo_local;

-- -- Muestra los equipos locales que han marcado más de 5 goles locales en total
-- WHERE ANTES DE GROUP BY Y HAVING DESPUES
SELECT equipo_local, SUM(goles_local) AS GOLES_LOCALES_TOTAL
FROM partido
GROUP BY equipo_local
HAVING  SUM(goles_local) > 5;

-- Muestra los equipos locales cuyas diferencias de goles locales sea negativa
SELECT equipo_local, SUM(goles_local - goles_visitante) AS DIFERENCIA_GOLES
FROM partido
GROUP BY equipo_local
HAVING  DIFERENCIA_GOLES < 0;