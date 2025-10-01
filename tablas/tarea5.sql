-- Crear la base de datos llamada liga_futbol.
CREATE DATABASE IF NOT EXISTS liga_futbol;
USE liga_futbol;

/*Equipo:
Debe incluir los campos id_equipo (INT), nombre_equipo (VARCHAR), ciudad (VARCHAR), fundacion (INT), posicion (INT), puntos (INT) y diferencia_goles (INT).
El campo nombre_equipo debe ser único y no puede estar vacío.
El campo fundacion debe ser un valor entre 1850 y el año actual.
La posicion debe ser un valor único, debe de ser obligatorio, mayor a 0 y menor o igual que 20.
El campo puntos debe ser mayor o igual a 0.
*/

CREATE TABLE IF NOT EXISTS equipo (
id_equipo INT PRIMARY KEY AUTO_INCREMENT,
nombre_equipo VARCHAR(30) NOT NULL UNIQUE,
ciudad VARCHAR(20),
fundacion INT CHECK (fundacion BETWEEN 1850 AND 2024),
posicion INT NOT NULL UNIQUE CHECK (posicion > 0 AND posicion <= 20),
puntos INT CHECK (puntos >= 0),
diferencia_goles INT
);

/*Jugador:
Debe contener los campos id_jugador (INT), nombre_jugador (VARCHAR), nacionalidad (VARCHAR), posicion (ENUM) con valores ‘Portero’, ‘Defensa’, ‘Centrocampista’ y ‘Delantero’, 
fecha_nacimiento (DATE), salario (DECIMAL) e id_equipo (INT).
La fecha_nacimiento no puede estar vacía.
El campo posicion debe ser obligatorio y nombre_jugador no puede estar vacío.
El campo salario debe de almacenar dos números decimales y está comprendido entre 100000 y 1000000.
Establecer una relación con la tabla Equipo mediante id_equipo.
*/
CREATE TABLE IF NOT EXISTS jugador (
id_jugador INT PRIMARY KEY AUTO_INCREMENT,
nombre_jugador VARCHAR(30) NOT NULL,
nacionalidad VARCHAR(30),
posicion ENUM  ("Portero","Defensa","Centrocampista","Delantero") NOT NULL,
fecha_nacimiento DATE NOT NULL,
salario DECIMAL (9,2) CHECK (salario BETWEEN 100000 AND 1000000),
id_equipo INT,
FOREIGN KEY (id_equipo) REFERENCES equipo (id_equipo)
);
/*
Entrenador:
Debe incluir los campos: id_entrenador (INT), nombre_entrenador (VARCHAR), nacionalidad (VARCHAR), fecha_contrato (DATE), salario (DECIMAL) e id_equipo.
El campo nombre_entrenador debe de ser único y no puede estar vacío.
El campo fecha_contrato es obligatorio y debe de ser posterior al año 2017.
El campo salario debe de ser mayor o igual a 30000 y menor a 100000. Se deben incluir dos decimales.
Establecer una relación con la tabla Equipo mediante id_equipo.
 */
 CREATE TABLE IF NOT EXISTS entrenador (
id_entrenador INT PRIMARY KEY AUTO_INCREMENT,
nombre_entrenador VARCHAR(30) NOT NULL UNIQUE,
nacionalidad VARCHAR(30),
fecha_contrato DATE NOT NULL CHECK (fecha_contrato > "2017-12-31"),
salario DECIMAL (8,2) CHECK (salario >= 30000 AND salario < 100000),
id_equipo INT,
FOREIGN KEY (id_equipo) REFERENCES equipo (id_equipo)
);
/*
Estadio:
Debe incluir los campos id_estadio (INT), nombre_estadio (VARCHAR), capacidad (INT), ciudad (VARCHAR) e id_equipo.
El campo capacidad debe ser mayor a 5000.
El nombre_estadio debe ser único y no puede estar vacío.
Establecer una relación con la tabla Equipo mediante id_equipo.
*/
 CREATE TABLE IF NOT EXISTS estadio (
id_estadio INT PRIMARY KEY AUTO_INCREMENT,
nombre_estadio VARCHAR(30) NOT NULL UNIQUE,
capacidad INT CHECK (capacidad > 5000),
ciudad VARCHAR(20),
id_equipo INT,
FOREIGN KEY (id_equipo) REFERENCES equipo (id_equipo)
);
/*
Partido:
Debe contener los campos id_partido (INT), fecha_partido (DATETIME), id_estadio, id_equipoLocal, id_equipoVisitante y resultado (VARCHAR).
El campo resultado debe estar en el formato ‘X - Y’, donde X e Y son los goles marcados por cada equipo.
Establecer relaciones con la tabla Estadio con id_estadio y con la tabla Equipo a través de id_equipoLocal y id_equipoVisitante.
*/
CREATE TABLE IF NOT EXISTS partido (
id_partido INT PRIMARY KEY AUTO_INCREMENT,
fecha_partido DATETIME,
id_estadio INT,
id_equipoLocal INT,
id_equipoVisitante INT,
resultado VARCHAR(10),
FOREIGN KEY (id_estadio) REFERENCES estadio (id_estadio),
FOREIGN KEY (id_equipoLocal) REFERENCES equipo (id_equipo),
FOREIGN KEY (id_equipoVisitante) REFERENCES equipo (id_equipo)
);
/*
Aficionado:
Debe incluir los campos id_aficionado (INT), nombre_aficionado (VARCHAR), equipo_favorito, fecha_nacimiento (DATE) y genero (ENUM) con valores ‘Masculino’ y ‘Femenino’.
La fecha_nacimiento debe ser posterior a 1920.
El campo nombre_aficionado no puede estar vacío.
Establecer una relación con la tabla Equipo para el campo equipo_favorito.
*/
CREATE TABLE IF NOT EXISTS aficionado (
id_aficionado INT PRIMARY KEY AUTO_INCREMENT,
nombre_aficionado VARCHAR(30) NOT NULL,
equipo_favorito INT,
fecha_nacimiento DATE CHECK (fecha_nacimiento > "1920-12-31"),
genero ENUM ("Masculino", "Femenino"),
FOREIGN KEY (equipo_favorito) REFERENCES equipo (id_equipo)
);
-- Insertar 5 registros en cada tabla
INSERT INTO equipo (nombre_equipo, ciudad, fundacion, posicion, puntos, diferencia_goles)
VALUES ("Murcia", "Murcia", 1900, 15, 30,4),
	   ("Barca", "Barcelona", 2000, 17, 80,7),
	   ("Madrid", "Madrid", 2017, 2, 99,4),
	   ("Valencia", "Valencia", 2011, 19, 1,3),
	   ("Alcantarilla", "Murcia", 1852, 20, 77,2);

INSERT INTO jugador (nombre_jugador, nacionalidad, posicion, fecha_nacimiento, salario, id_equipo)
VALUES ("Antonio", "Murciano", "Delantero", "1995-11-03", 120000, 1),
	   ("Luis", "Argentino", "Defensa", "2000-01-03", 125000, 2),
	   ("Pepe", "Colombiano", "Portero", "1998-11-03", 120340, 3),
	   ("Jorge", "Peruano", "Centrocampista", "1970-11-03", 160600, 4),
	   ("iamdaki", "Inglés", "Delantero", "1980-11-03", 190050, 5);
       
INSERT INTO entrenador (nombre_entrenador, nacionalidad, fecha_contrato, salario, id_equipo)
VALUES ("Antonio", "Argentino", "2018-11-03", 50000, 1),
	   ("Marcos", "Español", "2019-11-03", 56000, 2),
	   ("Loko", "Argelino", "2020-11-03", 72000, 3),
	   ("Pope", "Frances", "2022-11-03", 60000, 4),
	   ("Pepe", "Brasileño", "2023-11-03", 80000, 5);
       
INSERT INTO estadio (nombre_estadio, capacidad, ciudad, id_equipo)
VALUES ("Loa", 5500, "Murcia", 1),
	   ("La vida", 8000, "Las Torres", 2),
	   ("Paco", 6821, "Nonduermas", 3),
	   ("Pepe", 8546, "La ñora", 4),
	   ("OLee", 7548, "Librilla", 5);

INSERT INTO partido (fecha_partido, id_estadio, id_equipoLocal, id_equipoVisitante, resultado)
VALUES ("2020-11-13 09:30:12", 1, 1,2,"2 - 0"),
	   ("2022-11-13 10:30:12", 2, 2,3,"3 - 0"),
	   ("2023-11-13 08:30:12", 3, 3,4,"2 - 4"),
	   ("2019-11-13 19:30:12", 4, 4,5,"1 - 0"),
	   ("2015-11-13 11:30:12", 5, 5,1,"2 - 3");

INSERT INTO aficionado (nombre_aficionado, equipo_favorito, fecha_nacimiento, genero)
VALUES ("Antonio", 1, "1950-10-03", "Masculino"),
	   ("Pepe", 2, "1960-10-03", "Femenino"),
	   ("Soje", 3, "1970-10-03", "Femenino"),
	   ("CUlebra", 4, "1980-10-03", "Masculino"),
	   ("Lilo", 5, "2020-10-03", "Masculino");
/*	   
Modificar la estructura de una tabla:
Añade un nuevo campo a la tabla Jugador llamado numero_camisa (INT), que debe ser único y estar entre 1 y 99.
Modifica el nombre del campo ciudad en la tabla Estadio para que se llame ubicacion.
*/
ALTER TABLE jugador
ADD numero_camisa INT UNIQUE CHECK (numero_camisa BETWEEN 1 AND 99);

ALTER TABLE estadio
CHANGE ciudad ubicacion VARCHAR(20);


/*
Modificar el valor de un dato:
Actualiza la capacidad de un estadio cuyo id_estadio sea 2, aumentando su capacidad en un 20%.
Cambia el equipo favorito de un aficionado cuyo id_aficionado sea 4 a otro equipo diferente.
*/
UPDATE estadio
SET capacidad = capacidad * 1.2
WHERE id_estadio = 2;

UPDATE aficionado
SET equipo_favorito = 2
WHERE id_aficionado = 4;
/*
Borrar un registro:
Elimina de la tabla Jugador todos los jugadores cuyo equipo haya descendido de categoría (simulado que han quedado últimos en la liga).
Borra de la tabla Partido todos los partidos celebrados en julio de 2024 (asegúrate de haber creado primero algún partido con esa fecha).
*/
DELETE FROM jugador
WHERE id_equipo = (SELECT id_equipo FROM equipo WHERE posicion = 5);

DELETE FROM partido
WHERE fecha_partido BETWEEN "2024-07-01" AND "2024-07-31";
/*
Agregar registros y modificar relaciones:
Añade un nuevo aficionado en la tabla Aficionado y asígnale un equipo favorito de la tabla Equipo.
Agrega cinco nuevos partidos a la tabla Partido, asignándoles distintos equipos locales y visitantes.
*/
INSERT INTO aficionado (nombre_aficionado, equipo_favorito, fecha_nacimiento, genero)
VALUES ("Pepico", 2, "1982-08-23", "Masculino");

INSERT INTO partido (fecha_partido, id_estadio, id_equipoLocal, id_equipoVisitante, resultado)
VALUES ("2022-11-13 09:30:12", 1, 2,2,"2 - 0"),
	   ("2022-10-13 10:30:12", 2, 3,1,"3 - 0"),
	   ("2023-08-13 08:30:12", 3, 4,2,"2 - 4"),
	   ("2019-06-13 19:30:12", 4, 1,3,"1 - 0"),
	   ("2015-02-13 11:30:12", 5, 2,4,"2 - 3");
/*
Operaciones avanzadas:
Agrega a la tabla Jugador los siguientes campos con las siguientes respectivas restricciones:
partidos_jugados (INT), goles (INT), asistencias (INT), tarjetas_amarillas (INT) y tarjetas_rojas (INT).
El campo partidos_jugados debe ser mayor o igual a 0.
El campo goles y asistencias deben ser mayores o iguales a 0.
El campo tarjetas_amarillas debe estar entre 0 y 15.
El campo tarjetas_rojas debe estar entre 0 y 5.
*/

ALTER TABLE jugador
ADD  partidos_jugados INT CHECK (partidos_jugados >= 0),
ADD  goles INT CHECK (goles >= 0),
ADD  asistencia INT CHECK (asistencia >= 0),
ADD  tarjetas_amarillas INT CHECK (tarjetas_amarillas BETWEEN 0 AND 15),
ADD  tarjetas_rojas INT CHECK (tarjetas_rojas BETWEEN 0 AND 5);

/*
Aumenta el salario de todos los jugadores que hayan anotado más de X goles, siendo X el número a tu elección, en un 25%.
Aumenta el salario de todos los jugadores que hayan dado  más de X goles, siendo X el número a tu elección, en un 10%.
Aumenta el salario de todos los jugadores que hayan anotado más de X goles y hayan dado más de Y asistencias, siendo X e Y un número a tu elección, en un 50%.
*/

UPDATE jugador
SET salario = salario * 1.25
WHERE goles > 2;

UPDATE jugador
SET salario = salario * 1.1
WHERE goles > 2;

UPDATE jugador
SET salario = salario * 1.5
WHERE goles > 2 AND asistencia < 3;
/*
Borrar una tabla:
Elimina por completo la tabla Aficionado de la base de datos.	
*/
DROP TABLE IF EXISTS aficionado;


	