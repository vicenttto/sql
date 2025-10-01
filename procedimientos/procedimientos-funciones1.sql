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
drop function if exists hipotenusa;
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

-- if-then: condiciones
delimiter //

create procedure ejemplo_falso()
begin

if 10 > 5 then
	select "verdadero";
else 
	select "es menos que 5";
    
end if;
end //
delimiter ;

-- case

delimiter //
create procedure ejemplo_case(in p_num int)
begin
	declare resultado text;
    case
		when  p_num > 5 then set resultado ="mayor de 5"; -- select y set es lo mismo
		when  p_num < 5 then set resultado ="menor de 5";
        else set resultado="igual que 5";

end case;
	select resultado;
end //

delimiter ;

-- Crea una función que devuelva el mayor de tres números pasados como parámetros.
delimiter //
create procedure mayor_tres(in p_num1 int, in p_num2 int, in p_num3 int, out p_mayor text)
begin
	if p_num1 >= p_num2 and p_num1 >= p_num3 then
		set p_mayor =  concat("El numero " ,p_num1, " es mayor");
	elseif p_num2 >= p_num1 and p_num2 >= p_num3 then
		set p_mayor = p_num2;
	else
		set p_mayor = p_num3;
	END IF;

end //
delimiter ;

-- 2. Crea un procedimiento que diga si una palabra, pasada como parámetro, es palíndroma.
delimiter //
create procedure palindromo(in p_palabra text)
begin
	if p_palabra = reverse(p_palabra) then
		select concat("La palabra ", p_palabra, " es palindromo");
	else
		select concat("La palabra ", p_palabra, " no es palindromo");
	end if;

end //
delimiter ;
-- Crea una función que indique el resultado de un partido concreto para un equipo dado.
-- Muestra el ID del partido, el nombre del equipo y el resultado del partido para ese equipo (Victoria, Derrota o Empate).

delimiter //
create function resultado_partido(p_id_partido int, p_id_equipo int)
returns varchar(10)
begin
	declare v_resultado varchar(10);
	
    select 
		case	
			when (equipo_local = p_id_equipo and goles_local > goles_visitante)  
            or (equipo_visitante = p_id_equipo and goles_visitante > goles_local) then "victoria"
            
            when (equipo_local = p_id_equipo and goles_local < goles_visitante)  
            or (equipo_visitante = p_id_equipo and goles_visitante < goles_local) then "derrota"
            
            else "empate"
            
        end 
        into v_resultado
        from partido 
        where id_partido = p_id_partido;
        return ifnull(v_resultado, "sin datos");
end //


delimiter ;


select p.id_partido, e.nombre as equipo, resultado_partido(1,1)
from partido p
join equipo e on p.equipo_local = e.id_equipo
where p.id_partido = 1 and e.id_equipo = 1;
