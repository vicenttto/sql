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
