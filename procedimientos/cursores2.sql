-- Ejercicio 1.
-- Crea un procedimiento que recorra todos los usuarios que han realizado compras
-- y muestre un mensaje personalizado como: "Gracias, [nombre_usuario], por tu compra."
delimiter //
create procedure agradezco()
begin
	declare v_usuario varchar(50);
    declare fin_cursor boolean default false;
    
    declare cursor_usuario cursor for
		select u.nombre_usuario 
        from usuario u
        join compra c on c.id_usuario=u.id_usuario;
        
        
	declare continue handler for not found set fin_cursor= true;

    open cursor_usuario;
		bucle: LOOP
			fetch cursor_usuario into v_usuario;
				if fin_cursor then
					leave bucle;
				end if;
                
                select concat("Gracias, ", v_usuario," por tu compra") as resultado;
        end loop bucle;
    close cursor_usuario;
    
end //
delimiter ;
-- Ejercicio 2.
-- Crea un procedimiento que recorra todos los juegos lanzados antes de 2016
-- y reduzca su precio en un 20%.
delimiter //
create procedure juegos_2016()
begin
	declare v_juegos varchar(100);
    declare fin_cursor boolean default false;
    
    declare cursor_juego cursor for
		select titulo 
        from juego
		where year(fecha_lanzamiento) < 2016;
        
	declare continue handler for not found set fin_cursor= true;

    open cursor_juego;
		bucle: LOOP
			fetch cursor_juego into v_juegos;
				if fin_cursor then
					leave bucle;
				end if;
                
                update juego
                set precio = precio * 0.8
                where v_juegos = titulo;
                
                
        end loop bucle;
				select * from juego
                where year(fecha_lanzamiento) < 2016;
    close cursor_juego;
end //
delimiter ;
-- Ejercicio 3.
-- Crea un procedimiento que recorra todos los desarrolladores y para cada uno
-- muestre el primer juego que desarrolló (ordenado por fecha).
delimiter //
create procedure primero_desarrollador()
begin
	declare v_desarrollador varchar(100);
    declare fin_cursor boolean default false;
    
    declare cursor_desarrollador cursor for
		select d.nombre 
        from desarrollador d;
        
	declare continue handler for not found set fin_cursor= true;

    open cursor_desarrollador;
		bucle: LOOP
			fetch cursor_desarrollador into v_desarrollador;
				if fin_cursor then
					leave bucle;
				end if;
                
                select d.nombre, j.titulo, j.fecha_lanzamiento
				from desarrollador d
				join juego_desarrollador jd on d.id_desarrollador = jd.id_desarrollador
				join juego j on jd.id_juego=j.id_juego
				where d.nombre = v_desarrollador
                order by year(j.fecha_lanzamiento) asc
                limit 1;
                
        end loop bucle;
				
    close cursor_desarrollador;
end //
delimiter ;
-- Ejercicio 4.
-- Crea un procedimiento que recorra todos los usuarios con juegos en su wishlist
-- y muestre cuántos juegos tienen en ella.
delimiter //
create procedure juegos_wish()
begin
	declare v_usuarios varchar(50);
    declare fin_cursor boolean default false;
    
    declare cursor_usuario cursor for
		select u.nombre_usuario 
        from usuario u
        join wishlist w on w.id_usuario=u.id_usuario;
        
	declare continue handler for not found set fin_cursor= true;

    open cursor_usuario;
		bucle: LOOP
			fetch cursor_usuario into v_usuarios;
				if fin_cursor then
					leave bucle;
				end if;
                
                select u.nombre_usuario,count(w.id_juego) 
                from usuario u
				join wishlist w on w.id_usuario=u.id_usuario
                where u.nombre_usuario=v_usuarios;				
                
        end loop bucle;
				
    close cursor_usuario;
end //
delimiter ;
-- Ejercicio 5.
-- Crea un procedimiento que recorra todos los juegos y verifique si alguno
-- supera el precio máximo permitido (65€). Si lo supera, lanza un error con SIGNAL.
delimiter //
create procedure limite_precio()
begin
	declare v_juegos varchar(100);
	declare v_precio decimal(5,2);
	declare v_error text;
    declare fin_cursor boolean default false;
    
    declare cursor_juegos cursor for
		select titulo, precio
        from juego;
        
	declare continue handler for not found set fin_cursor= true;

    open cursor_juegos;
		bucle: LOOP
			fetch cursor_juegos into v_juegos, v_precio;
				if fin_cursor then
					leave bucle;
				end if;
                
               if v_precio < 65 then
						select v_juegos;
					else
						set v_error = concat("Error, el titulo " , v_juegos , "supera el limite de precio");
						signal sqlstate "45000"
							set message_text = v_error;
                end if;
        end loop bucle;
				
    close cursor_juegos;
end //
delimiter ;
