/*
-- Ejercicio 2: Base de datos para un Centro Pokémon

Parte 1:

Crear una base de datos para gestionar la información de un Centro Pokémon, incluyendo entrenadores, Pokémon, tipos de Pokémon, movimientos y batallas.
Instrucciones:
1. Crear la base de datos llamada centro_pokemon.

2. Crear las siguientes tablas con las restricciones indicadas:

Entrenador: (id_entrenador (int), nombre_entrenador (varchar), nivel_entrenador (int) y teléfono (int)). El campo nivel_entrenador debe ser un valor entre 1 y 100. El número de teléfono debe ser único para cada entrenador. El nombre del entrenador no puede repetirse en la base de datos.
Tipo: (id_tipo (int) y nombre_tipo). El campo nombre_tipo debe permitir los valores "Fuego", "Agua", "Eléctrico" y "Planta".
Pokémon: (id_pokemon (int), nombre_pokemon (varchar), nivel (int), id_entrenador e id_tipo). El nivel del Pokémon debe ser un valor entre 1 y 100. Establecer una relación entre Pokémon y Entrenadores utilizando el campo id_entrenador como clave foránea. El nombre del Ppokémon no puede repetirse en la base de datos. Además, cada Pokémon debe estar asociado a un tipo utilizando id_tipo como clave foránea.
Movimiento: (id_movimiento (int), nombre_movimiento (varchar), potencia (int), precision (int), efecto (text), categoria e id_tipo). El campo potencia debe ser un valor numérico mayor o igual a 0 y el campo precision debe ser un valor entre 10 y 100. El campo categoria debe permitir los valores “Especial” y “Físico”. Establecer una relación entre Movimiento y Tipo utilizando id_tipo como clave foránea.
Batalla: (id_batalla (int), id_pokemon1, id_pokemon2, fecha_batalla (datetime) y ganador. El campo fecha_batalla no puede ser nulo y debe de registrar la fecha y hora actual por defecto. Además, el campo ganador debe permitir los valores “1”, “X” y “2”. Establecer relaciones entre la tabla Batalla y la tabla Pokémon para los campos id_pokemon1 e id_pokemon2.

3. Insertar 5 registros en cada tabla utilizando datos ficticios, respetando las restricciones de cada campo. Asegúrate de que las relaciones entre tablas sean correctas (por ejemplo, cada batalla debe involucrar a dos Pokémon de la tabla Pokémon).
Parte 2: Modificaciones en la estructura y datos de la base de datos

1. Modificar la estructura de una tabla:
Añade un nuevo campo a la tabla Entrenador para almacenar la cantidad de medallas que ha ganado el entrenador.
Modifica el nombre del campo telefono en la tabla Entrenadores para que se llame contacto_telefono.
Cambia el tipo de dato del campo potencia de la tabla Movimientos para que permita decimales.
2 .Borrar una tabla:
Elimina por completo la tabla Movimiento de la base de datos.
3. Modificar el valor de un dato:
Actualiza el nivel de un Pokémon cuyo id_pokemon sea 4, incrementándolo en 5 niveles.
Cambia el tipo de un Pokémon de la base de datos para que sea de tipo "Eléctrico".
Cambia el número de teléfono de un entrenador de la base de datos.

4. Agregar registros y modificar relaciones:
Añade un nuevo Pokémon a la tabla Pokémon con los datos de un tipo dual (por ejemplo, "Planta" y "Agua").
Añade cinco nuevos registros en la tabla Batalla, asegurándote de que las fechas de las batallas sean de entre 2020 y 2023.

5. Borrar un registro:
Elimina de la tabla Pokémon todos los registros donde el Pokémon tenga un nivel superior a X.
Elimina todas las batallas realizadas antes de la fecha actual.
*/

CREATE DATABASE IF NOT EXISTS centro_pokemon;

USE centro_pokemon;

-- Crear las 5 tablas
CREATE TABLE IF NOT EXISTS Entrenador (
	id_entrenador INT PRIMARY KEY AUTO_INCREMENT, 
    nombre_entrenador VARCHAR(30) NOT NULL UNIQUE,
    nivel_entrenador INT CHECK (nivel_entrenador >= 1 AND nivel_entrenador <= 100), -- (nivel_entrenador between 1 AND 100)
    telefono INT UNIQUE
);

CREATE TABLE IF NOT EXISTS Tipo (
	id_tipo INT PRIMARY KEY AUTO_INCREMENT,
    nombre_tipo ENUM ("Fuego", "Agua", "Eléctrico", "Planta", "Volador")
);

CREATE TABLE IF NOT EXISTS Pokemon (
	id_pokemon INT PRIMARY KEY AUTO_INCREMENT, 
    nombre_pokemon VARCHAR(30) NOT NULL UNIQUE,
    nivel INT CHECK (nivel >= 1 AND nivel <= 100),
    id_entrenador INT,
    id_tipo INT,
    FOREIGN KEY (id_entrenador) REFERENCES Entrenador (id_entrenador),
    FOREIGN KEY (id_tipo) REFERENCES Tipo (id_tipo)
);

CREATE TABLE IF NOT EXISTS Movimiento (
	id_movimiento INT PRIMARY KEY AUTO_INCREMENT, 
    nombre_movimiento VARCHAR(30) NOT NULL UNIQUE,
    potencia INT CHECK (potencia >= 0),
    precision_movimiento INT CHECK (precision_movimiento >=10 AND precision_movimiento <=100),
    efecto TEXT,
    categoria ENUM ("Especial", "Físico"),
    id_tipo INT,
    FOREIGN KEY (id_tipo) REFERENCES Tipo (id_tipo)
);

CREATE TABLE IF NOT EXISTS Batalla (
	id_batalla INT PRIMARY KEY AUTO_INCREMENT, 
    id_pokemon1 INT,
    id_pokemon2 INT,
    fecha_batalla DATETIME DEFAULT now() NOT NULL,
    ganador ENUM ("1", "X", "2"),
	FOREIGN KEY (id_pokemon1) REFERENCES Pokemon (id_pokemon),
	FOREIGN KEY (id_pokemon2) REFERENCES Pokemon (id_pokemon)
);

-- Insertar datos en las tablas
INSERT INTO Entrenador (nombre_entrenador, nivel_entrenador, telefono)
VALUES ("Paco", 50, 1234),
	   ("Antonio", 55, 8475),
	   ("Jorge", 21, 6598),
	   ("Miguel", 88, 2545),
	   ("Alex", 39, 3975);

INSERT INTO Tipo (nombre_tipo)
VALUES ("Fuego"),
	   ("Agua"),
	   ("Eléctrico"),
	   ("Planta"),
	   ("Fuego");

INSERT INTO Pokemon (nombre_pokemon, nivel, id_entrenador, id_tipo)
VALUES ("Hitmonlee", 25, 1, 1) ,
	   ("Lapras", 74, 2, 2) ,
       ("Pikachu", 99, 3, 4) ,
       ("Charmander", 01, 3, 5) ,
       ("Kabutops", 68, 4, 3) ;
       
INSERT INTO Movimiento (nombre_movimiento, potencia, precision_movimiento, efecto, categoria, id_tipo)
VALUES ("Chancletazo", 2003, 40, "Aturde al enemigo", "Físico", 3),
	   ("Martillazo", 8572, 55, "Confunde al enemigo", "Físico", 2),
	   ("Puñetazo", 4562, 80, "Destruye al enemigo", "Especial", 1),
	   ("Cuchillazo", 1002, 25, "Produce sangrado en el enemigo", "Físico", 4),
	   ("Manguerazo", 9452, 30, "Moja al enemigo", "Especial", 5);

INSERT INTO Batalla (id_pokemon1, id_pokemon2, ganador)
VALUES (1, 5, "X"),
	   (2, 4, "1"),
	   (3, 3, "1"),
	   (4, 2, "2"),
	   (5, 1, "2");
	   
-- Añade un nuevo campo a la tabla Entrenador para almacenar la cantidad de medallas que ha ganado el entrenador.
ALTER TABLE Entrenador
ADD medallas INT;

-- Modifica el nombre del campo telefono en la tabla Entrenadores para que se llame contacto_telefono.
ALTER TABLE Entrenador
CHANGE telefono contacto_telefono INT UNIQUE; -- le vuelvo a poner el campo INT y sus restricciones UNIQUE

-- Cambia el tipo de dato del campo potencia de la tabla Movimientos para que permita decimales.
ALTER TABLE Movimiento
CHANGE potencia potencia DECIMAL (5,2) ;

-- Elimina por completo la tabla Movimiento de la base de datos.
DROP TABLE Movimiento;

-- Actualiza el nivel de un Pokémon cuyo id_pokemon sea 4, incrementándolo en 5 niveles.
UPDATE Pokemon
SET nivel = nivel + 5
WHERE id_pokemon = 4;

-- Cambia el tipo de un Pokémon de la base de datos para que sea de tipo "Eléctrico".
UPDATE Pokemon
SET id_tipo = 3
WHERE nombre_pokemon = "Charmander";
-- puedo hacer set nombre_tipo = electrico? no porque en la tabla no tengo el dato de nombre_tipo

-- Cambia el número de teléfono de un entrenador de la base de datos.
UPDATE Entrenador
SET contacto_telefono = 1478
WHERE nombre_entrenador = "Paco";
-- puedo hacer where id_entrenador o nivel_entrenador, si vale ya que debe estar esos datos en la tabla entonces funciona

-- Modifica la tabla Pokémon para añadir otra clave foránea llamada id_tipoDual, que haga referencia a la tabla Tipo. 
ALTER TABLE Pokemon
ADD id_tipoDual INT,
ADD FOREIGN KEY (id_tipoDual) REFERENCES Tipo (id_tipo);
-- Ahora añade un nuevo Pokémon a la tabla Pokémon con los datos de un tipo dual (por ejemplo, "Planta" y "Agua").
INSERT INTO Pokemon (nombre_pokemon, nivel, id_entrenador, id_tipo, id_tipoDual)
VALUES ("Antoñico", 32, 2, 2,4);
-- Añade cinco nuevos registros en la tabla Batalla, asegurándote de que las fechas de las batallas sean de entre 2020 y 2023.
INSERT INTO Batalla (id_pokemon1, id_pokemon2, fecha_batalla, ganador)
VALUES (2, 4, "2022-08-09", "X"),
	   (1, 2, "2020-07-12", "1"),
       (5, 3, "2022-02-03", "2"),
       (3, 4, "2022-10-08", "1"),
       (4, 5, "2021-01-11", "1");
-- Elimina de la tabla Pokémon todos los registros donde el Pokémon tenga un nivel superior a X.
DELETE FROM Pokemon
WHERE nivel > 30;
-- Elimina todas las batallas realizadas antes de la fecha actual.
DELETE FROM Batalla
WHERE fecha_batalla < now();

