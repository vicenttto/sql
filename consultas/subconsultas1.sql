-- 1. Muestra los títulos de los juegos cuyo precio es mayor que el promedio de precios de todos los juegos.
SELECT titulo
FROM juego
where precio > (
	SELECT AVG(precio)
    FROM juego
);
-- 2. Muestra el nombre y país de origen de los desarrolladores que tienen más juegos desarrollados que el desarrollador con menos juegos.
select d.nombre, d.pais_origen
from desarrollador d
where (
	select count(jd.id_juego)
    from juego_desarrollador jd
    where jd.id_desarrollador= d.id_desarrollador
) > (
	select min(total_juegos)
    from (
		select count(id_juego) as total_juegos
        from juego_desarrollador
        group by id_desarrollador
        ) temp

);
-- 3. Obtén el título de los juegos que están disponibles en más plataformas que el promedio de plataformas por juego.
select j.titulo
from juego j
where (
	select count(id_plataforma) as num_plat
    from juego_plataforma jp
    where jp.id_juego = j.id_juego
) > (
	select avg(num_plat_por_juego)
    from (
		select count(id_plataforma) as num_plat_por_juego
        from juego_plataforma
        group by id_juego
    ) temp
);
-- 4. Muestra los nombres de los usuarios que tienen al menos un amigo registrado en el mismo país.
-- 5. Lista los nombres de los géneros que no tienen ningún juego asociado.
select nombre_genero
from  genero g
where  not exists (
	select 1
    from juego
    where id_genero1 = g.id_genero or id_genero2 = g.id_genero
);
-- 6. Obtén los nombres de los juegos que tienen una puntuación mayor que el promedio de puntuaciones de
-- los juegos de su mismo género principal.
select j.titulo, j.puntuacion,g.nombre_genero
from juego j
join genero g on j.id_genero1 = g.id_genero
where j.puntuacion > (
	select avg(puntuacion)
    from juego j
    join genero g1 on g1.id_genero = j.id_genero1
    WHERE g1.id_genero = g.id_genero
)order by g.nombre_genero, j.puntuacion desc;
-- 7. Muestra el nombre de los desarrolladores cuyo país de origen tiene más desarrolladores registrados que Japón.
-- 8. Encuentra los títulos de los juegos que han sido comprados por todos los usuarios registrados.
-- 9. Obtén los nombres de las plataformas que tienen juegos desarrollados por algún desarrollador europeo.
-- 10. Muestra el título y la puntuación de los juegos cuya puntuación es superior a la puntuación 
-- promedio de todos los juegos desarrollados por el mismo desarrollador.
select j.titulo, j.puntuacion 
from juego j
join juego_desarrollador jd on jd.id_juego = j.id_juego
join desarrollador d on jd.id_desarrollador = d.id_desarrollador
where puntuacion > (
	select avg(puntuacion)
    from juego j
    join juego_desarrollador jd on jd.id_juego = j.id_juego
    join desarrollador d1 on jd.id_desarrollador = d1.id_desarrollador
    where d1.id_desarrollador = d.id_desarrollador
    ) ;
-- 11. Lista los nombres de los usuarios que han comprado al menos un juego desarrollado por un estudio con menos de 10 empleados.
-- 12. Encuentra los nombres de las plataformas que no tienen ningún juego con una puntuación menor que 50.
-- 13. Muestra los nombres de los desarrolladores que han creado juegos tanto para consolas como para PC.
-- 14. Obtén los nombres de los usuarios cuya wishlist tiene al menos un juego con una puntuación mayor que la máxima puntuación de un juego comprado por ellos.
select u.nombre_usuario
from usuario u
join wishlist w on w.id_usuario = u.id_usuario
join juego j on j.id_juego = w.id_juego
where j.puntuacion > any (
    select max(j.puntuacion)
    from juego j
    join compra c on c.id_juego = j.id_juego
    where w.id_usuario = c.id_usuario
);
-- 15. Lista los títulos de los juegos cuya puntuación es mayor que la puntuación de todos los juegos comprados por un usuario específico (por ejemplo, con id_usuario = 'U001').
-- 16. Muestra los nombres de los géneros que tienen al menos un juego cuya puntuación sea igual a la máxima puntuación de cualquier juego.
select  distinct g.nombre_genero
from juego j
join genero g on j.id_genero1 = g.id_genero or j.id_genero2 = g.id_genero
where j.puntuacion =  (
	select max(j.puntuacion)
    from juego j
);

select distinct g1.nombre_genero, g2.nombre_genero
from juego j 
join genero g1 on g1.id_genero = j.id_genero1
left join genero g2 on g2.id_genero = j.id_genero2
where j.puntuacion = (
	select max(puntuacion)
    from juego
);


-- 17. Obtén los nombres de los usuarios que tienen juegos en su wishlist con un precio superior al precio promedio de los juegos comprados por todos los usuarios.
select u.nombre_usuario
from usuario u
join  wishlist w on w.id_usuario = u.id_usuario
join juego j on j.id_juego = w.id_juego
where j.precio > (
	select avg(j.precio)
    from juego j
	join  compra c on c.id_juego = j.id_juego
    where c.id_usuario = u.id_usuario
);

-- 18. Muestra los títulos de los juegos que tienen más reseñas que el promedio de reseñas de los juegos disponibles en la misma plataforma.
-- 19. Encuentra los nombres de los usuarios que tienen amigos que han comprado más juegos que ellos.
select distinct u.nombre_usuario
from usuario u
join amistad a on a.id_amigo1= u.id_usuario
where  (
		select count(c.id_juego) JUEGO_MIO
        from compra c
        where c.id_usuario=u.id_usuario
) < (
		select count(c.id_juego) juego_amigo
        from compra c
        where a.id_amigo2=c.id_usuario
);


/*
*/
-- 20. Muestra los nombres de los desarrolladores cuyo total de juegos desarrollados tiene un precio acumulado mayor que el precio 
-- acumulado de los juegos de cualquier otro desarrollador.
select d.nombre as desarrollador
from desarrollador d
where (
	select sum(j.precio) as precio_juegos1
	from juego j
	join juego_desarrollador jd on jd.id_juego = j.id_juego
	where jd.id_desarrollador = d.id_desarrollador and j.precio is not null
) >  all(
	select sum(j1.precio) as precio_juegos2
	from juego j1
	join juego_desarrollador jd1 on jd1.id_juego = j1.id_juego
	where jd1.id_desarrollador != d.id_desarrollador and j1.precio is not null
    group by jd1.id_desarrollador
);
/*si comparo con uno solo no pongo group by, en este caso si que hago un group by ya que hay varios
*/
select sum(j.precio) as precio_juegos1
from juego j
join juego_desarrollador jd on jd.id_juego = j.id_juego
where jd.id_desarrollador = "d001";

select sum(j.precio) as precio_juegos2
from juego j
join juego_desarrollador jd on jd.id_juego = j.id_juego
where jd.id_desarrollador = "d002";

 
-- 21. Obtén los nombres de las plataformas cuyos juegos tienen un precio promedio superior al precio promedio de los juegos en todas las plataformas.
-- 22. Lista los nombres de los usuarios que han comprado juegos en más plataformas que cualquier otro usuario.
-- 23. Encuentra los títulos de los juegos que tienen una puntuación superior a la de cualquier juego desarrollado por un estudio específico (por ejemplo, id_desarrollador = 'D001').
-- 24. Muestra los títulos de los juegos que tienen al menos una reseña con una puntuación mayor 
-- que el promedio de puntuaciones de todas las reseñas de ese juego.
select j.titulo, r.puntuacion
from juego j
join resena r on j.id_juego = r.id_juego
where r.puntuacion > any(
	select avg(r.puntuacion)
    from resena r
    join juego j1 on j.id_juego = r.id_juego
    where j1.id_juego = j.id_juego
) order by r.puntuacion;
-- 25. Obtén los nombres de los continentes que tienen al menos un desarrollador cuyo número de trabajadores es mayor que el promedio de trabajadores en todo el mundo.
-- 26. Encuentra los nombres de los usuarios que tienen amigos que han comprado juegos que no están en la wishlist del usuario principal.
-- 27. Muestra los títulos de los juegos cuya puntuación menos su precio sea mayor que el promedio de esa misma operación para todos los juegos.
-- 28. Obtén los nombres de los usuarios que tienen amigos que tienen una wishlist cuyo total de juegos sea mayor que la suma de juegos en la wishlist de cualquier usuario que no sea su amigo.
-- 29. Lista los nombres de los géneros que tienen juegos con un precio menor que el precio promedio de los juegos en el género con los juegos más caros.
-- 30. Encuentra los nombres de los desarrolladores que tienen juegos en plataformas que no tienen juegos de ningún otro desarrollador.

-- Muestra el minimo y el maximo numero de juegos desarrollados por cada desarrollador
select min(num_juegos), max(num_juegos)
from (
	select count(id_juego) as num_juegos
    from juego_desarrollador
    group by id_desarrollador
) temp;
