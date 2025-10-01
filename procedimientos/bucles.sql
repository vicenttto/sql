-- Crea un procedimiento que tome un parámetro entero n y utilice un bucle WHILE para calcular el
-- factorial de n e imprimir el resultado
delimiter //
create procedure factorial(in p_num int)
begin
	declare v_contador int default p_num;
    declare v_resultado int default p_num;
    
    while v_contador > 1 do
		set v_resultado = v_resultado * (v_contador -1);
		set v_contador = v_contador -1;
	end while;
    select v_resultado;
end //
delimiter ;

-- 2. Crea un procedimiento que utilice un bucle REPEAT para imprimir los números pares del 1 al 20.
delimiter //
create procedure num_pares()
begin
	declare v_num int default 0;
	repeat 
		select v_num;
		set v_num = v_num + 2;
        until v_num > 20
	end repeat;

end //
delimiter ;

-- Crea un procedimiento que tome como parámetro de entrada un número entero. Este procedimiento imprimirá la tabla de multiplicar de ese número hasta el décimo múltiplo
-- utilizando un bucle LOOP
delimiter //
create procedure tabla_multi(in p_num int)
begin
	declare v_contador int default 1;
    declare v_resultado int default 0;
		bucle: loop
		set v_resultado = p_num*v_contador;
		select concat(p_num, " x ", v_contador," = ", v_resultado);
		set v_contador = v_contador + 1;
        
        if v_contador > 10 then
			leave bucle;
			end if;
    end loop bucle;

end //

delimiter ;
-- escribe numeros impares 
delimiter //
create procedure num_impare()
begin
	declare v_num int default 1;
	repeat 
		select v_num;
		set v_num = v_num + 2;
        until v_num > 21
	end repeat;

end //
delimiter ;


