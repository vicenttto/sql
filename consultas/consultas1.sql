-- Ejercicio 1: Mostrar los nombres de los equipos junto con la suma de los goles y asistencias totales de sus jugadores. Incluye equipos sin jugadores.
SELECT e.nombre AS EQUIPO, SUM(j.goles + j.asistencias) AS TOTALES
FROM equipo e
LEFT JOIN jugador j ON e.id_equipo = j.id_equipo
GROUP BY EQUIPO;
-- Ejercicio 2: Lista todos los estadios y, si se han jugado partidos en ellos, muestra el promedio de goles por partido en cada estadio.
SELECT e.nombre AS ESTADIO, p.id_partido AS PARTIDO, AVG(p.goles_local + p.goles_visitante) AS MEDIA_GOLES
FROM estadio e
JOIN partido p ON p.id_estadio=e.id_estadio
GROUP BY ESTADIO;
-- Ejercicio 3: Mostrar los estadios ordenados alfabéticamente por su nombre.
SELECT nombre AS ESTADIO 
FROM estadio
ORDER BY ESTADIO ASC;
-- Ejercicio 4: Listar los entrenadores junto con el total de goles marcados por los equipos que entrenan. Incluye entrenadores sin equipo.
SELECT e.nombre AS ENTRENADOR, eq.nombre AS EQUIPO, SUM(j.goles) AS GOLES_TOTALES, eq.nombre as equipo
FROM entrenador e
LEFT JOIN equipo eq ON e.id_equipo=eq.id_equipo
JOIN jugador j ON j.id_equipo= eq.id_equipo
GROUP BY ENTRENADOR;

-- Ejercicio 5: Muestra los jugadores que no participan en la Champions League.
SELECT j.nombre AS JUGADOR, l.nombre AS LIGA
FROM jugador j
JOIN equipo e ON j.id_equipo=e.id_equipo
JOIN participacion p ON p.id_equipo=e.id_equipo
JOIN liga l ON l.id_liga=p.id_liga
WHERE l.nombre != "Champions League";
-- Ejercicio 6: Mostrar los nombres de los equipos locales y visitantes para cada partido.
SELECT p.id_partido AS PARTIDO,e1.nombre AS EQUIPO_LOCAL,e2.nombre AS EQUIPO_VISITANTE, e.nombre as estadio
FROM partido p
join estadio e on e.id_estadio=p.id_estadio
JOIN equipo e1 ON e1.id_equipo = p.equipo_local
JOIN equipo e2 ON e2.id_equipo = p.equipo_visitante;

-- Ejercicio 7: Muestra los estadios con capacidad mayor a 50,000.
SELECT e.nombre AS ESTADIO, e.capacidad AS CAPACIDAD
FROM estadio e
WHERE e.capacidad > 50.000;
-- Ejercicio 8: Mostrar los partidos jugados los días 1, 15 o 30 de cualquier mes.
SELECT p.id_partido AS PARTIDO, p.fecha AS FECHA
FROM partido p
WHERE DAY(p.fecha) = 1 OR DAY(p.fecha) = 15 OR DAY(p.fecha) = 30;
-- Ejercicio 9: Mostrar los jugadores que han marcado más de 10 goles, junto con el nombre de su equipo. Incluye jugadores sin equipo.
SELECT j.nombre AS JUGADOR, j.goles AS GOLES, e.nombre AS EQUIPO
FROM jugador j
LEFT JOIN equipo e ON e.id_equipo=j.id_equipo
WHERE j.goles > 10;
-- Ejercicio 10: Mostrar los nombres de todos los jugadores junto con los nombres de sus equipos. Incluye a los jugadores que no tienen equipo.
SELECT j.nombre AS JUGADOR, e.nombre AS EQUIPO
FROM jugador j
LEFT JOIN equipo e ON e.id_equipo=j.id_equipo;
-- Ejercicio 11: Muestra un listado con los capitanes de cada equipo.
SELECT j.nombre AS JUGADOR, e.nombre AS EQUIPO, j.id_capitan AS CAPITAN
FROM jugador j
JOIN equipo e ON e.id_equipo=j.id_equipo
WHERE j.id_capitan IS NOT NULL;
-- Ejercicio 12: Contar cuántos partidos se jugaron en cada mes.
SELECT COUNT(id_partido), MONTH(fecha) AS MES
FROM partido
GROUP BY MONTH(fecha)
ORDER BY fecha;
-- Ejercicio 13: Muestra los entrenadores y, si tienen equipo, muestra cuántos partidos han jugado sus equipos como equipo local.
SELECT e.nombre AS ENTRENADOR, eq.nombre AS EQUIPO,COUNT(p.equipo_local) AS LOCALe
FROM entrenador e
LEFT JOIN equipo eq ON eq.id_equipo=e.id_equipo
LEFT JOIN partido p ON e.id_equipo= p.equipo_local
GROUP BY p.equipo_local;
-- Ejercicio 14: Muestra el nombre de todos los equipos y, si tienen entrenadores asignados, muestra el nombre del entrenador.
SELECT e.nombre AS EQUIPOS, en.nombre AS ENTRENADOR
FROM equipo e
LEFT JOIN entrenador en ON en.id_equipo=e.id_equipo;
-- Ejercicio 15: Muestra al mejor jugador de la temporada, aquel jugador cuya suma de goles y asistencias es superior a la del resto.
SELECT nombre AS JUGADOR, (goles + asistencias) AS TOTAL
from jugador
order by total desc
LIMIT 1;
-- Ejercicio 16: Lista los estadios que contienen la palabra 'Arena' en su nombre.
SELECT nombre AS ESTADIO
from estadio
where nombre LIKE "%Arena%";
-- Ejercicio 17: Mostrar el entrenador con el equipo más antiguo.
SELECT en.nombre AS ENTRENADOR,eq.fundacion AS FECHA_FUNDACION
from entrenador en
JOin equipo eq ON eq.id_equipo=en.id_equipo
order by fecha_fundacion asc
limit 1;
-- Ejercicio 18: Mostrar los jugadores que juegan en las posiciones 'Delantero', 'Centrocampista' o 'Defensa'.
SELECT  nombre AS JUGADOR, posicion AS POSICION
from jugador
WHERE posicion = "Delantero" OR posicion = "centrocampista" OR posicion = "defensa"
Order by posicion;
-- Ejercicio 19: Muestra todos los equipos junto con el total de goles marcados por sus jugadores. Incluye equipos que no tienen jugadores.
SELECT eq.nombre AS EQUIPO,  SUM(j.goles) AS GOLES_TOTALES
from equipo eq
LEFT JOIN jugador j ON eq.id_equipo=j.id_equipo
group by eq.nombre;
-- Ejercicio 20: Contar el número total de partidos registrados.
SELECT COUNT(id_partido) AS PARTIDOS
from partido;
-- Ejercicio 21: Mostrar los estadios con una capacidad entre 30,000 y 80,000.
SELECT nombre AS ESTADIO, capacidad 
from estadio
WHERE capacidad BETWEEN 30000 AND 80000
order by capacidad DESC;
-- Ejercicio 22: Lista todos los estadios y, si se han jugado partidos en ellos, muestra el número total de goles marcados en cada uno de esos estadios.
select e.nombre as estadios, SUM(p.goles_local + p.goles_visitante) AS GOLES_Totales
from estadio e
 LEFT join partido p ON p.id_estadio=e.id_estadio
 group by e.nombre;
-- Ejercicio 23: Listar los estadios y la cantidad de partidos jugados en cada uno.
select e.nombre AS estadio, COUNT(p.id_partido) AS partidos
from estadio e
join partido p ON e.id_estadio=p.id_estadio
group by e.nombre;
-- Ejercicio 24: Muestra los nombres de los entrenadores, incluso aquellos que no tienen un equipo asignado. Incluye el nombre del equipo si existe.
select en.nombre as entrenador, eq.nombre as equipo
from entrenador en
left join equipo eq ON en.id_equipo=eq.id_equipo;
-- Ejercicio 25: Muestra los jugadores mayores de 30 años.
select nombre AS jugador, edad
from jugador
where edad > 30
order by edad desc;
-- Ejercicio 26: Mostrar los partidos jugados en estadios de ciudades que comienzan con la letra 'B'.
select  p.id_partido AS partido, e.nombre as estadio
from partido p
join estadio e ON p.id_estadio=e.id_estadio
where e.nombre like "B%";
-- Ejercicio 27: Mostrar los estadios que están en las ciudades 'París', 'Londres', o 'Múnich'.
select nombre as estadio, ciudad
from estadio
where ciudad = "parís" or ciudad ="londres" or ciudad = "múnich";
-- Ejercicio 28: Mostrar el máximo de goles marcados en un solo partido jugado un día específico.
select max(goles_local + goles_visitante), fecha
from partido
where date(fecha) = "2023-10-01";
-- Ejercicio 29: Calcular el promedio de edad de los jugadores.
select avg(edad) as media_edad
from jugador;
-- Ejercicio 30: Contar cuántos equipos fueron fundados antes del año 2000.
select count(id_equipo) as num_equipos
from equipo
where fundacion < "2000-01-01";
-- Ejercicio 31: Mostrar los partidos jugados después de '2023-01-01'.
select id_partido AS partido, fecha
from partido
where fecha > "2023-01-01"
order by fecha;
-- Ejercicio 32: Muestra los equipos y el promedio de edad de sus jugadores. Incluye jugadores sin equipos y ordena los resultados por promedio de edad de mayor a menor.
select e. nombre as equipo, avg(j.edad) as media_edad
from equipo e 
left join jugador j ON j.id_equipo=e.id_equipo
group by e.nombre
order by media_edad desc;
-- Ejercicio 33: Mostrar el número del mes en que se jugaron todos los partidos registrados.
select month(fecha) as mes , count(id_partido) as partido
from partido
group by mes
order by mes ;
-- Ejercicio 34: Listar los jugadores cuya edad esté entre 20 y 30 años.
select nombre as jugador, edad
from jugador
where edad between 20 and 30
order by edad desc;
-- Ejercicio 35: Mostrar los equipos cuyos nombres terminan con 'CF'.
select nombre as equipo
from equipo
where nombre like "%CF";
-- Ejercicio 36: Muestra los nombres de los jugadores y el nombre de su equipo.
select j.nombre as jugador, e.nombre as equipo
from jugador j
join equipo e ON e.id_equipo=j.id_equipo;
-- Ejercicio 37: Mostrar todos los partidos jugados en fechas entre '2023-01-01' y '2023-12-31'.
select id_partido as partido, fecha
from partido
where fecha between "2023-01-01" and '2023-12-31'
order by fecha;
-- Ejercicio 38: Mostrar los nombres únicos de los estadios donde se han jugado partidos.
select distinct e.nombre as estadio, p.id_partido as partido
from estadio e
join partido p ON p.id_estadio=e.id_estadio
group by estadio;
-- Ejercicio 39: Muestra los 5 jugadores sin equipo más jóvenes del torneo, junto con el nombre de su equipo.
select j.nombre as jugador, e.nombre as equipo, j.edad as edad
from jugador j
left join equipo e ON e.id_equipo=j.id_equipo
where e.nombre is null
order by edad
limit 5;
-- Ejercicio 40: Mostrar los estadios y su capacidad usando un alias como "Capacidad Total".
select nombre, capacidad as "Capacidad total"
from estadio
order by capacidad desc;
-- Ejercicio 41: Mostrar los equipos que están en las ciudades 'Madrid', 'Barcelona' o 'Sevilla'.
select nombre as equipo, ciudad
from equipo
where ciudad = "Madrid" or ciudad = "Barcelona" or ciudad = "sevilla";
-- Ejercicio 42: Calcular el total de goles marcados por cada equipo en todos los partidos jugados.
select SUM(j.goles) as goles, e.nombre as equipo
from jugador j
 LEFT join equipo e ON j.id_equipo= e.id_equipo
group by equipo;
-- Ejercicio 43: Mostrar los estadios y la cantidad de partidos jugados en cada uno.
Select e.nombre as estadio, count(p.id_partido) as partidos
from estadio e
 left join partido p ON e.id_estadio= p.id_estadio
group by estadio;
-- Ejercicio 44: Mostrar el día del mes en que se jugaron los partidos en el estadio 'Santiago Bernabéu'.
select e.nombre as estadio, day(p.fecha) as dia
from estadio e
join  partido p ON e.id_estadio=p.id_estadio
where e.nombre = "santiago bernabéu";
-- Ejercicio 45: Mostrar los nombres de los jugadores con su edad usando un alias como "Jugador" y "Edad".
select nombre as jugador, edad as edad
from jugador;
-- Ejercicio 46: Mostrar los partidos jugados el día 15 de cualquier mes.
select id_partido as partido, fecha 
from partido
where day(fecha) = 15;
-- Ejercicio 47: Mostrar la edad mínima de los jugadores registrados.
select edad as edad_minima, nombre as jugador
from jugador
order by edad
limit 1;
-- Ejercicio 48: Mostrar la capacidad total de todos los estadios.
select nombre as estadio, capacidad
from estadio;
-- Ejercicio 49: Mostrar los nombres de todos los jugadores junto con los nombres de sus equipos.
select j.nombre as jugador, e.nombre as equipo
from jugador j
left join equipo e ON j.id_equipo=e.id_equipo;
-- Ejercicio 50: Mostrar los nombres únicos de los estadios donde se han jugado partidos.
select e.nombre as estadio, p.id_partido as partido
from estadio e
join partido p ON e.id_estadio=p.id_estadio
group by partido;
-- Ejercicio 51: Mostrar los partidos jugados los días 1, 15 o 30 de cualquier mes.
select id_partido as partido, fecha
from partido
where day(fecha) = 1 or day(fecha) = 15 or day(fecha) = 30 ;
-- Ejercicio 52: Mostrar los jugadores cuyos nombres empiezan con la letra 'A'.
select nombre as jugador
from jugador
where nombre like "A%";
-- Ejercicio 53: Mostrar las posiciones únicas de los jugadores.
select  nombre as jugador, posicion
from jugador
order by posicion;
-- Ejercicio 54: Mostrar todas las ciudades únicas donde hay equipos registrados.
select  ciudad, nombre as equipo
from equipo;
-- Ejercicio 55: Mostrar la cantidad de jugadores en cada posición.
select count(nombre) as num_jug, posicion 
from jugador
group by posicion;
-- Ejercicio 56: Listar los partidos jugados en el año 2023.
select id_partido as partido, fecha
from partido
where year(fecha) = 2023
order by fecha;
-- Ejercicio 57: Mostrar los nombres de los estadios ordenados alfabéticamente.
select nombre as estadio
from estadio
order by estadio;
-- Ejercicio 58: Contar cuántos partidos se jugaron en diciembre de cualquier año.
select count(id_partido) as partidos, fecha
from partido
where month(fecha) = 12;
-- Ejercicio 59: Mostrar los nombres de los equipos y el año de fundación.
select nombre as equipo, fundacion as año
from equipo
order by año;
-- Ejercicio 60: Mostrar los estadios donde se jugaron partidos en los meses de enero, febrero o marzo.
select e.nombre as estadio, p.id_partido as partido, p.fecha as fecha
from estadio e
join  partido p ON p.id_estadio=e.id_estadio
-- where month(p.fecha) = 10 or month(p.fecha) = 02 or month(p.fecha) = 03;
where month(p.fecha) IN (1,2,3);
-- Ejercicio 61: Contar cuántos partidos se jugaron en el día 1 de enero de cualquier año.
select id_partido as partido, fecha
from partido
where day(fecha) = 01 and month(fecha) = 01;

-- Ejercicio 62: Mostrar el promedio de goles locales en partidos jugados en 2023.
select avg(goles_local) as promedio_goles_locales, fecha
from partido
where year(fecha) = 2023;
-- Ejercicio 63: Mostrar el estadio con la mayor capacidad.
select nombre as estadio, max(capacidad) as maxima_capa
from estadio;
-- Ejercicio 64: Listar los jugadores que pertenecen a equipos de la ciudad de 'Madrid'.
select j.nombre as jugadores, e.ciudad as ciudad
from jugador j
join equipo e on j.id_equipo=e.id_equipo
where ciudad = "madrid";
-- Ejercicio 65: Mostrar los partidos jugados en enero de 2023.
select id_partido as partidos, fecha
from partido
where year(fecha) = 2023;
-- Ejercicio 66: Mostrar los entrenadores junto con el nombre del equipo que entrenan.
select e.nombre as entrenador, eq.nombre as equipo
from entrenador e
left join equipo eq on eq.id_equipo=e.id_equipo;
-- Ejercicio 67: Mostrar los nombres de los estadios y la cantidad de partidos jugados en ellos.
select e.nombre as estadios, count(p.id_partido) as partidos
from estadio e
left join partido p on e.id_estadio=p.id_estadio
group by estadios;
-- Ejercicio 68: Mostrar los entrenadores y cuántos partidos jugaron sus equipos como locales.
select e.nombre as entrenador ,count(p.id_partido) as partidos, eq.nombre as equipo_local
from entrenador e
join equipo eq ON e.id_equipo=eq.id_equipo
join partido p ON eq.id_equipo= p.equipo_local
group by entrenador;

-- Ejercicio 69: Mostrar los partidos jugados después de '2023-01-01'.
select id_partido as partidos, fecha
from partido
where fecha > "2023-01-01";
-- Ejercicio 70: Mostrar todos los equipos y cuántos partidos jugaron.
select e.nombre as equipos, count(p.id_partido) as partidos
from equipo e
join partido p on e.id_equipo= p.equipo_local or e.id_equipo= p.equipo_visitante
group by equipos;
-- Ejercicio 71: MOstrar los nombres de los jugadores y los capitanes de su equipo
select j1.nombre as jugador, j2.nombre as capitan
from jugador j1
join jugador j2 on j2.id_capitan=j1.id_jugador;

-- EJercicio 53: Mostrar los nombres de los equipos que tienen mas de 10 jugadores registrados
select eq.nombre as equipo, count(j.id_jugador) as jugadores_regis
from equipo eq
join jugador j on j.id_equipo=eq.id_equipo
group by equipo
having jugadores_regis > 10;
