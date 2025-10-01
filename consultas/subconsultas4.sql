-- 1. Listar el nombre, los goles y el nombre del equipo de aquellos jugadores que han marcado más goles que el promedio de goles de su propio equipo.

-- 2. Mostrar el nombre y el número de victorias de cada equipo, así como el nombre de la liga en la que participa,
-- cuyo número de victorias es superior al promedio de victorias de todos los equipos de su respectiva liga.
select e.nombre as equipo, e.victorias, l.nombre
from equipo e
join participacion p on p.id_equipo = e.id_equipo
join liga l on l.id_liga = p.id_liga
where e.victorias > (
	select avg(e1.victorias)
    from equipo e1
    join participacion p1 on p1.id_equipo=e1.id_equipo
    where p1.id_liga=p.id_liga
);
-- 3. Listar los partidos en los que la diferencia de goles entre ambos equipos fue mayor que el promedio de diferencias de todos los partidos.
-- Utiliza la función ABS() para hallar el valor absoluto de la diferencia de goles.
select p.id_partido, ABS(p.goles_local - p.goles_visitante) as diferencia_goles
from partido p 
where ABS(p.goles_local - p.goles_visitante) > (
	select avg(ABS(goles_local - goles_visitante))
    from partido
);
-- 4. Mostrar los nombres de los jugadores que han marcado más goles que el máximo goleador de cualquier otro equipo.

-- 5. Listar los equipos que han marcado más goles que la suma de goles de todos los equipos rivales.

-- 6. Mostrar los partidos donde el equipo local ha marcado más goles que el promedio de goles de los equipos visitantes en todos los partidos.

-- 7. Listar los jugadores cuyo número de asistencias es mayor que el número máximo de asistencias de cualquier centrocampista.

-- 8. Mostrar los equipos que han ganado más partidos como visitantes que el promedio de victorias como local de todos los equipos.
select e.nombre as equipo, count(p.id_partido) as victorias_visitantes
from equipo e
join partido p on e.id_equipo = p.equipo_local
where p.goles_visitante > p.goles_local
group by e.nombre
having victorias_visitantes > (
	select avg(victorias_local)
    from (
			select count(p.id_partido) as victorias_local
            from partido p
            where p.goles_local > p.goles_visitante
            group by p.equipo_local
    ) temp
)order by victorias_visitantes desc ;

-- 9. Listar los jugadores que han marcado goles en más partidos (como local o visitante) que el promedio de partidos con goles de todos los jugadores (jugando como local o visitante).
