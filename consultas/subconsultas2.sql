-- 1. Encuentra los nombres de los usuarios que han comprado más juegos que el usuario con menos compras.
select u.nombre_usuario
from usuario u
join compra c on c.id_usuario= u.id_usuario
group by u.id_usuario
having count(c.id_compra)  >  (
		select min(num_compras)
	from (
		select count(id_compra) as num_compras
        from compra 
        group by id_usuario ) temp
)  ; 

-- 2. Lista los nombres de los juegos cuya puntuación es mayor que el promedio de puntuaciones de todos los juegos en su género principal.
select titulo
from juego j
where puntuacion > (
	select avg(puntuacion)
    from juego j1
    where j1.id_genero1 = j.id_genero1
);

-- 3. Encuentra los nombres de los desarrolladores cuyo número de juegos es mayor que el promedio de juegos por desarrollador.
select d.nombre
from desarrollador d
join juego_desarrollador jd on jd.id_desarrollador=d.id_desarrollador
group by d.nombre
having count(jd.id_juego) > (
	select avg(totalJue)
    from (
		select count(id_juego) as totalJue
		from juego_desarrollador
		group by id_desarrollador
		) temp
) ;



-- 4. Lista los títulos de los juegos cuyo precio es mayor que el precio promedio de todos los juegos en su plataforma.
select distinct j.titulo
from juego j
join juego_plataforma jp ON j.id_juego = jp.id_juego
where j.precio > (
	select avg(j1.precio)
    from juego j1
    join juego_plataforma jp1 on jp1.id_juego = j1.id_juego
    where jp1.id_plataforma = jp.id_plataforma
);
-- 5. Encuentra los nombres de los continentes que tienen desarrolladores con más empleados que el promedio mundial.
select  distinct continente
from  desarrollador
where numero_trabajadores > (
	select avg(numero_trabajadores)
    from desarrollador
);
-- 6. Obtén los nombres de los usuarios que tienen amigos que han comprado juegos no disponibles en la wishlist del usuario principal.
select distinct u1.nombre_usuario as usuario
from usuario u1
join amistad a on u1.id_usuario=a.id_amigo1 -- usuario principal
where exists(
	select c.id_compra
    from compra c
    where c.id_usuario = a.id_amigo2 -- mi amigo 
    and c.id_juego not in (
		select w.id_juego
        from wishlist w
        where w.id_usuario=a.id_amigo1
    ) 
);

-- 7. Encuentra los nombres de los géneros cuyos juegos tienen una puntuación promedio mayor que el promedio de todos los juegos.
select g.nombre_genero
from genero g
join juego j on j.id_genero1=g.id_genero OR g.id_genero = j.id_genero2
group by g.id_genero
having avg(j.puntuacion)  > (
	select avg(j.puntuacion)
    from juego j
);

