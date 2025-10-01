-- 8. Lista los títulos de los juegos que tienen más reseñas que el promedio de reseñas de todos los juegos.
select j.titulo
from juego j
join resena r on j.id_juego=r.id_juego
group by j.id_juego
having count(r.id_resena) > (
	select avg(resenas)
    from (
		select count(id_resena) as resenas
        from resena
        group by id_juego
    ) temp
);


-- 9. Muestra los títulos de los juegos que han sido comprados por más usuarios que el promedio de compras por juego.
select  j.titulo 
from juego j
join compra c on c.id_juego=j.id_juego
group by j.id_juego
having count(c.id_compra) > (
	select avg(compras)
    from (
		select count(id_compra) as compras
        from compra
        group by id_juego
    ) temp
);
-- 10. Encuentra los nombres de los desarrolladores que han desarrollado juegos en más plataformas que el promedio.
select distinct d.nombre
from desarrollador d
join juego_desarrollador jd on d.id_desarrollador=jd.id_desarrollador
join juego_plataforma jp on jp.id_juego=jd.id_juego
group by jd.id_desarrollador
having count(jp.id_plataforma) > (
	select avg(plataformas)
    from (
		select count(jp.id_plataforma) as plataformas
        from juego_plataforma jp
        join juego_desarrollador jd on jd.id_juego=jp.id_juego
        group by jd.id_desarrollador
    ) temp
);



-- 11. Encuentra los nombres de los usuarios que tienen al menos un amigo que ha comprado más juegos que él.

-- 12. Muestra los nombres de los géneros cuyos juegos tienen un precio mayor que el precio promedio de todos los juegos en cualquier género.
select distinct g.nombre_genero
from genero g
join juego j on j.id_genero1 = g.id_genero  or j.id_genero2 = g.id_genero
where j.precio > (
	select avg(precio)
    from juego
);
-- 13. Lista los nombres de los usuarios que tienen en su wishlist un juego con una puntuación mayor que la de cualquier juego comprado por ellos.
select distinct u.nombre_usuario
from usuario u
join wishlist w on w.id_usuario=u.id_usuario
join juego j on j.id_juego=w.id_juego
where j.puntuacion in (
	select j1.puntuacion
    from juego j1
    join compra c1 on c1.id_juego=j1.id_juego
    where w.id_juego = c1.id_juego
);

-- 14. Muestra los nombres de los continentes con desarrolladores que han publicado juegos en menos plataformas que el promedio mundial de plataformas por desarrollador.
select distinct d.continente
from desarrollador d
join juego_desarrollador jd on d.id_desarrollador=jd.id_desarrollador
join juego_plataforma jp on jp.id_juego=jd.id_juego
group by jd.id_desarrollador
having count(jd.id_juego) < (
	select avg(num_plat)
    from (
		select count(jp.id_plataforma) as num_plat
        from juego_plataforma jp
        join juego_desarrollador jd on jd.id_juego= jp.id_juego
        group by jd.id_desarrollador
    ) temp

); 
