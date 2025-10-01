-- actividades clase 
-- actividad 1: Crea un procedimiento que sume uno a la variable que se le pasa como parámetro (en este caso la
-- variable es de entrada/salida ya que necesitamos su valor para incrementarlo y, además,
-- necesitamos usarlo después de la función para comprobarlo)
delimiter //
drop procedure if exists incrementa_uno;
create procedure incrementa_uno(inout p_num int)
begin
	set p_num = p_num + 1;
end //


-- actividad 2: Crea un procedimiento que muestre las tres primeras letras de una cadena, pasada como
-- parámetro, en mayúsculas.

drop procedure if exists tresLetras;
create procedure tresLetras(in p_cadena varchar(255))
begin
	select upper(substring(p_cadena,1,3));

end //

-- actividad 3: Crea un procedimiento que muestre dos cadenas pasadas como parámetros concatenados y en
-- mayúscula.
drop procedure if exists cadenas;
create procedure cadenas(in p_cadena varchar(255), in p_cadena2 varchar(255))
begin
	select upper(concat(p_cadena," ", p_cadena2));

end //

-- actividad 4: . Crea una función que devuelva el valor de la hipotenusa de un triángulo a partir de los valores de
-- sus lados.
create function hipotenusa(p_lado1 int, p_lado2 int )
returns double
begin
	declare v_hipotenusa double;
    
    set v_hipotenusa = sqrt(pow(p_lado1, 2) + pow(p_lado2,2));
    
    RETURN v_hipotenusa;

end//
-- actividad 5: Crea un procedimiento que reciba el nombre de un género y 
-- devuelva una lista de todos los juegos con ese género.
drop procedure if exists nombregenero;
create procedure nombregenero(in p_nombre_genero varchar(50))
begin
	select j.titulo, g.nombre_genero as nombre_genero
    from juego j
    join genero g on g.id_genero = j.id_genero1 or g.id_genero = j.id_genero2
    where g.nombre_genero = p_nombre_genero;
end//
delimiter ;
-- actividad 6: Crea una función que calcule el número de plataformas en las que está disponible un juego dado, a
-- partir de su ID. Luego, muestra los juegos que están disponibles en más de 3 plataformas.
delimiter //
DROP function if exists num_plat;
create function num_plat(p_id_juego varchar(10))
returns int
begin
	declare v_numero_plat int;
    select count(id_plataforma)
    into v_numero_plat
    from juego_plataforma
    where id_juego = p_id_juego;
    
    return v_numero_plat;
    

end//
delimiter ;

select titulo, num_plat(id_juego)
from juego
where num_plat(id_juego) > 3;

-- 7: Crea una función que calcule el total de juegos comprados por un usuario en un año dado. Muestra
-- el nombre del usuario, el año y el total de juegos comprados.
delimiter //
DROP function if exists total_juegos_anos;
create function total_juegos_anos(p_id_usuario varchar(10), p_anio int)
returns int
begin 
	declare v_total_juegos int;
    select count(id_compra)
    into v_total_juegos
    from compra
    where id_usuario = p_id_usuario and year(fecha_compra) = p_anio;
    
return v_total_juegos;
end//
delimiter ;

select u.nombre_usuario, year(c.fecha_compra) as anio_compra, total_juegos_anos(u.id_usuario, 2024) as num_juegos
from usuario u
join compra c on c.id_usuario=u.id_usuario;

-- actividad 8: Crea un procedimiento que reciba una palabra clave y muestre todos los juegos cuyo título
-- contengan esa palabra.
delimiter //
	drop procedure if exists palabra_clave;
    create procedure palabra_clave(in p_palabra_clave varchar(255))
    begin
		select titulo
        from juego
        where titulo like concat("%",p_palabra_clave,"%");
    end//

delimiter ;

-- Crea una función que calcule el precio de un juego concreto tras aplicar un descuento
-- dado. Muestra el nombre del juego, el precio original y el precio con descuento
delimiter //
drop function if exists funcion_precio;
create function funcion_precio(p_id_juego varchar(10), p_descuento int)
returns decimal(5,2)
begin
	declare v_precio_descuento decimal(5,2);
	select precio - (precio * p_descuento / 100)
    into v_precio_descuento
    from juego
    where id_juego = p_id_juego;
    
    return v_precio_descuento;
end //

delimiter ;

select titulo, precio as precio_original, funcion_precio("J0010",20)
from juego
where id_juego = "J0010";

-- Crea una función que calcule la antigüedad de un videojuego dado a partir de su fecha de
-- lanzamiento. Muestra los juegos que tienen menos de 5 años de antigüedad.
delimiter //
drop function if exists antiguo_juego;
create function antiguo_juego(p_id_juego varchar(10))
returns int
begin 
	declare v_antiguo int;
    select year(now()) - year(fecha_lanzamiento)
	into v_antiguo
    from juego
    where id_juego = p_id_juego;
    
    return v_antiguo;
end //