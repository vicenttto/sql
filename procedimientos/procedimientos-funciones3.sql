-- JUEGUICOS

-- Ejercicio 1. Crea un procedimiento que reciba el nombre de una plataforma y muestre todos los títulos de los juegos disponibles en ella.
delimiter //
create procedure juegos_disponibles (in p_plataforma varchar(50))
begin
	select j.titulo as titulo
    from juego j
    join juego_plataforma jp on j.id_juego = jp.id_juego
    join plataforma p on p.id_plataforma = jp.id_plataforma
    where p.nombre_plataforma = p_plataforma;

end //
delimiter ;
-- Ejercicio 2. Crea un procedimiento que reciba el nombre de un usuario y muestre los títulos de los juegos que ha comprado.
delimiter //
create procedure nombre_usuario(in p_nombre VARCHAR(50))
begin
	select j.titulo as juegos
    from juego j
    join compra c on c.id_juego = j.id_juego
    join usuario u on u.id_usuario=c.id_usuario
    where u.nombre_usuario=p_nombre;
    
end //

delimiter ;
-- Ejercicio 3. Crea un procedimiento que reciba id de un juego y muestre todas las reseñas que ha recibido.
delimiter //
create procedure mostrar_reseñas (in p_id_juego varchar(10))
begin
	select r.comentario as resenia
    from resena r
    join juego j on j.id_juego=r.id_juego
    where j.id_juego=p_id_juego;
end //
delimiter ;
-- Ejercicio 4. Crea un procedimiento que reciba una puntuación y muestre los juegos con puntuación mayor o igual a la indicada.
delimiter //
create procedure puntuacion (in p_id_juego int(11))
begin
	select titulo, puntuacion
    from juego
    where puntuacion >= p_id_juego;
end //
delimiter ;
-- Ejercicio 5. Crea una función que devuelva una calificación en texto a partir de la puntuación de un juego: 
-- ≥9 → "Obra Maestra",
-- ≥7 → "Muy Bueno",
-- ≥5 → "Regular",
-- <5 → "Malo".
-- Muestra los juegos junto a su calificación.
delimiter //
create function calificacion_juegos(p_id_juego varchar(10))
returns text
begin
	declare v_resultado text;
	declare v_puntuacion int;

		select j.puntuacion as puntuacion
		into v_puntuacion
        from juego j
        where j.id_juego=p_id_juego;
			
			case 
				when v_puntuacion >= 90  then set v_resultado = "Obra Maestra";
				when v_puntuacion >= 70 then set v_resultado ="Muy bueno";
				when v_puntuacion >= 50 then set v_resultado ="Regular";
				else set v_resultado ="Malo";
			end case;
			return v_resultado;
end //

delimiter ;
    -- esto es para que muestre todo

	select titulo, puntuacion, calificacion_juegos(id_juego)
    from juego ;
    
    select titulo, puntuacion, calificacion_juegos("J0001")
    from juego 
    where id_juego="j0001";
    
-- Ejercicio 6. Crea una función que calcule el precio promedio de los juegos de un desarrollador dado. Muestra el nombre del desarrollador y el precio promedio.

-- Ejercicio 7. Crea una función que calcule el precio promedio de los juegos de un género dado a partir de su nombre. Muestra los géneros y su precio promedio.

-- FURBOH

-- Ejercicio 8. Crea un procedimiento que reciba el nombre de un equipo y muestre el nombre, posición y goles de sus jugadores.

-- Ejercicio 9. Crea un procedimiento que muestre los jugadores que han marcado más de un número de goles dado como parámetro.

-- Ejercicio 10. Crea una función que devuelva el porcentaje de partidos ganados por un equipo (por ID). Muestra el nombre y el porcentaje de victorias del 'Real Madrid'.
delimiter //
create function partidos_ganados(p_id_equipo int(11))
returns decimal(5,2)
begin
declare v_victorias decimal(5,2);
declare v_num_victorias int default 0;
declare v_partidos_totales int default 0;
	select count(id_partido) 
    into v_num_victorias
    from partido 
    where (p_id_equipo = equipo_local and goles_local > goles_visitante) 
    or (p_id_equipo = equipo_visitante and goles_local < goles_visitante);
    
    select count(id_partido)
    into v_partidos_totales
    from partido
    where p_id_equipo = equipo_local or p_id_equipo = equipo_visitante;
    
    if v_partidos_totales = 0 then set v_victorias = 0;
    end if;

	set v_victorias=v_num_victorias / v_partidos_totales * 100;
    
    return v_victorias;
end //

delimiter ;

select nombre as equipo, partidos_ganados(3)
from equipo
where id_equipo = 1;

select nombre as equipo, partidos_ganados(id_equipo) as winrate
from equipo
order by winrate asc;


-- Ejercicio 11. Crea una función que devuelva “Frágil” si tiene más de 3 lesiones, “Normal” si tiene entre 1 y 3, y “Sano” si no tiene lesiones.
--  Muestra el nombre y la condición física del jugador llamado 'Luka Modric'.
delimiter $$
create function lesiones(p_id_jugador int (11))
returns text
begin
declare v_resultado text;
declare v_num_lesiones int;
	select count(id_jugador) into v_num_lesiones
    from lesion
    where id_jugador = p_id_jugador;
    
		if v_num_lesiones = 0 
        then
			set v_resultado = "sano";
		elseif v_num_lesiones > 1 and v_num_lesiones < 3 
		then
			set v_resultado = "normal";
		else 
			set v_resultado = "fragil";
		end if;
        
        return v_resultado;
        
 END $$
 
delimiter ;

select nombre, lesiones(1)
from jugador
where id_jugador = 1;

-- Ejercicio 12. Crea un procedimiento que reciba un nombre de equipo y muestre los jugadores lesionados actuales de ese equipo.
delimiter $$
create procedure jugadores_lesionados(in p_nombre_equipo varchar(100))
begin 
	select distinct j.nombre
    from equipo e 
    join jugador j on j.id_equipo = e.id_equipo
    join lesion l on l.id_jugador = j.id_jugador
    where l.fecha_fin is null and p_nombre_equipo = e.nombre;
end $$ 

delimiter ;
-- Ejercicio 13. Crea un procedimiento que reciba dos equipos y devuelva cuál tiene más jugadores en plantilla.
delimiter $$
create procedure mas_jugadores(in p1_nombre_equipo varchar(100), p2_nombre_equipo varchar(100))
begin 

	declare v_primerEquipo varchar(100);
	declare v_segundoEquipo varchar(100);
    
	select count(j.id_jugador) as total_jugadores
    into v_primerEquipo
    from jugador j
    join equipo e on e.id_equipo = j.id_equipo
    where p1_nombre_equipo = e.nombre;
    
    select count(j.id_jugador) as total_jugadores
    into v_segundoEquipo
    from jugador j
    join equipo e on e.id_equipo = j.id_equipo
    where p2_nombre_equipo = e.nombre;
    
    if v_primerEquipo > v_segundoEquipo 
    then 
		select concat("EL equipo ", p1_nombre_equipo, " tiene mas jugadores que el equipo ", p2_nombre_equipo);
    elseif  v_primerEquipo < v_segundoEquipo 
    then
		select concat("EL equipo ", p2_nombre_equipo, " tiene mas jugadores que el equipo ", p1_nombre_equipo);
	else
				select "Tiene el mismo numero";
	end if;


    

end $$

delimiter ;
-- Ejercicio 14. Crea una función que recide el id de un equipo según su promedio de goles por jugador 
-- (≥ 7: “Ofensivo”, ≥ 5: “Equilibrado”, < 5: “Defensivo”). Muestra el promedio de goles y el estilo de juego del 'FC Barcelona'.
delimiter $$
create function promedio_goles(p_id_equipo int (11))
returns text
begin
	declare v_resultado text;
    declare v_mediaGoles decimal (5,2);
    declare v_total_goles int;
    
    select sum(goles) as total_goles 
    into v_total_goles
    from jugador
    where id_equipo = p_id_equipo;

	select v_total_goles / count(id_jugador)
    into v_mediaGoles
    from jugador
    where p_id_equipo=id_equipo;
    
    if v_mediaGoles < 5
    then
		set v_resultado = "defensivo";
	elseif v_mediaGoles >= 5
    then
		set v_resultado = "equilibrado";
	elseif v_mediaGoles >= 7
    then
		set v_resultado = "equilibrado";
	end if;

		return v_resultado;

end $$
delimiter ;

select e.nombre,sum(j.goles) / count(j.id_jugador) ,promedio_goles(2)
from equipo e
join jugador j on e.id_equipo = j.id_equipo
where e.id_equipo = 2;

/* Ejercicio 1: Suma de Números Pares

Crear un procedimiento que calcule la suma de los primeros N números pares.

- El procedimiento debe aceptar un parámetro de entrada: p_numero (cantidad de números pares a sumar).
- Utilizar un bucle para generar y sumar los números pares.
- Mostrar la suma total al final del procedimiento. */

delimiter //

create procedure suma_pares(in p_numero int)
begin
	declare v_resultado int default 0;
    declare v_contador int default 0;
    declare v_par int default 0;
    bucle: loop
		set v_par= v_par + 2;
        set v_resultado = v_resultado + v_par;
		set v_contador = v_contador + 1;
        
        if v_contador = p_numero then
			leave bucle;
            end if;
	end loop bucle;
        select v_par;
end //
delimiter ;

delimiter //
create procedure suma_pares_modulo(in p_numero int)
begin
	declare v_resultado int default 0;
    declare v_contador int default 0;
    
    while v_contador <= p_numero do
		if mod(v_contador , 2) = 0 then
			set v_resultado = v_resultado + v_contador;
		end if;
        set v_contador = v_contador + 1;
	end while;
end //
delimiter ;
/* Ejercicio 2: Conteo de Números Divisibles

Crear un procedimiento que cuente cuántos números entre 1 y N son divisibles por un número dado.

- El procedimiento debe aceptar dos parámetros de entrada: p_numero (límite superior) y p_divisor (número por el cual deben ser divisibles).
- Utilizar un bucle para contar los números divisibles.
- Mostrar el total de números divisibles al final del procedimiento. */

delimiter //
create procedure num_div(in p_numero decimal, in p_divisor decimal)
begin
	declare v_resultado decimal default 0;
    declare v_contador decimal default 1;

    while v_contador <= p_numero do
		if v_contador % p_divisor = 0 then 
			set v_resultado = v_resultado + 1;
		end if;
	set v_contador = v_contador + 1;
	end while;
    select v_resultado;
end //

delimiter ;

/* Ejercicio 3: Impresión de Números del 1 al N

Crear un procedimiento que imprima todos los números del 1 al N en una sola cadena separada por comas.

- El procedimiento debe aceptar un parámetro de entrada: p_numero (número límite).
- Utilizar un bucle para concatenar los números en una cadena.
- Mostrar la cadena de números al final del procedimiento. */
delimiter //
create procedure imp_num(in p_numero int)
begin
	declare v_cadena varchar(100) default "";
	declare v_contador int default 1;
    
		while v_contador <= p_numero do
			set v_cadena = concat(v_cadena,v_contador, ", ");
			set v_contador = v_contador + 1;
		end while;
        set v_cadena = substring(v_cadena,1, char_length(v_cadena) - 2);
        select v_cadena;
end //

delimiter ;
/* Ejercicio 4: Contar Vocales en una Cadena

Crear un procedimiento que cuente el número de vocales en una cadena de texto.

- El procedimiento debe aceptar un parámetro de entrada: p_cadena (cadena de texto).
- Utilizar un bucle para iterar sobre los caracteres de la cadena.
- Mostrar el número total de vocales al final del procedimiento.*/

delimiter //

create procedure contar_vocales(in p_cadena varchar(100))
begin
	declare v_contador int default 1;
    declare v_resultado int default 0;
		bucle: loop
			set p_cadena = upper(p_cadena);
				if substring(p_cadena,v_contador,1) in ("A", "E", "I", "O", "U") then
				set v_resultado = v_resultado + 1;
                end if;
                
			set v_contador = v_contador + 1;
            if char_length(p_cadena) < v_contador then
            leave bucle;
            end if;
		end loop bucle;
		select v_resultado;
        
end //
delimiter ;
