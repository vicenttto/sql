-- Ejercicio 1. Crea un procedimiento que recorra todos los juegos de la tabla juego y muestre sus títulos.
delimiter //
create procedure titulo_juegos()
begin
declare v_titulo varchar(100);
declare fin_cursor boolean default false;

declare c_titulo cursor for
	select titulo from juego;

declare continue handler for not found set fin_cursor= true;

open c_titulo;
bucle : loop
		fetch c_titulo into v_titulo;
		if fin_cursor = true
		then leave bucle;
		end if;
        
        select v_titulo as resultado;
end loop bucle;
close c_titulo;
end //

delimiter ;
-- Ejercicio 2. Crea un procedimiento que recorra la tabla usuario y muestre solo los nombres de los usuarios que han realizado alguna compra.
delimiter //
create procedure tabla_usuario()
begin
declare v_nombre varchar(100);
declare fin_cursor boolean default false;

declare c_user cursor for
	select u.nombre_usuario from usuario u
    join compra c on c.id_usuario = u.id_usuario;

declare continue handler for not found set fin_cursor= true;

open c_user;
	bucle : loop
		fetch c_user into v_nombre;
		if fin_cursor = true
		then leave bucle;
		end if;
        
        select v_nombre as resultado;
	end loop bucle;
close c_user;
end //

delimiter ;
-- Ejercicio 3. Crea un procedimiento que recorra todos los desarrolladores y muestre su nombre junto con el número de juegos que han desarrollado.

-- Ejercicio 4. Crea un procedimiento que recorra todos los juegos y muestre aquellos cuyo precio sea mayor de 50 euros.
delimiter //
create procedure juegos_mayor50()
begin 
	declare v_titulo varchar(100);
	declare v_precio decimal(10, 2);
    declare fin_cursor boolean default false;

	declare c_juegos cursor for
    select titulo, precio
    from juego
    where precio > 50;

	declare continue handler for not found set fin_cursor= true;
    
	open c_juegos;
		bucle : loop
			fetch c_juegos into v_titulo, v_precio;
			if fin_cursor = true
			then leave bucle;
			end if;
            
            select v_titulo as resultado, v_precio as precio;
		end loop bucle;
	close c_juegos;

end //

delimiter ;
-- Ejercicio 5. Crea un procedimiento que recorra los juegos y muestre aquellos disponibles en más de dos plataformas.

/* Ejercicio 6. Crea un procedimiento que recorra todas las plataformas, y para cada una:

Calcule los ingresos totales generados por las compras de juegos en esa plataforma.

- Si los ingresos superan los 1000€, inserte un mensaje en una tabla llamada resumen_ingresos indicando:
Plataforma X: Éxito de ventas

- Si no, inserte:
Plataforma X: Ventas bajas
La tabla resumen_ingresos debe tener un id y un mensaje
 */
create table resumen_ingresos (
id_ingreso int auto_increment primary key,
mensaje text
);


delimiter //
create procedure ingresos ()
begin
	declare v_ingresos decimal (6,2);
	declare v_nombre_plat varchar(50);
    declare fin_cursor boolean default false;
    
    declare cursor_ingresos cursor for 
		select nombre_plataforma from plataforma;
	
    declare continue handler for not found set fin_cursor= true;

		open cursor_ingresos;
			bucle: loop
			fetch cursor_ingresos into v_nombre_plat;
			if fin_cursor then
				leave bucle;
			end if;
            
            select ifnull(sum(j.precio),0) into v_ingresos
            from juego j
            join juego_plataforma jp on jp.id_juego=j.id_juego
            join plataforma p on p.id_plataforma = jp.id_plataforma
            where v_nombre_plat=p.nombre_plataforma;
            
            if v_ingresos > 1000 then
            insert into resumen_ingresos (mensaje)
				values (concat("Plataforma ", v_nombre_plat, ": Exito de ventas"));
            else  insert into resumen_ingresos (mensaje)
				values (concat("Plataforma ", v_nombre_plat, ": Ventas bajas"));
			end if;
            end loop bucle;
        close cursor_ingresos;
end //

delimiter ;