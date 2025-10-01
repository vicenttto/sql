-- @author Vicente Aparicio Hernández

-- Crear la base de datos llamada plataforma_videojuegos.
CREATE DATABASE IF NOT EXISTS plataforma_videojuegos;
USE plataforma_videojuegos;

/*Crear las siguientes tablas con las restricciones indicadas:
Juego:
Debe incluir los campos id_juego (INT), titulo (VARCHAR), genero (VARCHAR), precio (DECIMAL), clasificacion_edad (INT) y disponibilidad (ENUM) con valores posibles ‘Disponible’, ‘No Disponible’, ‘Próximamente’.
El campo precio no puede ser menor a 0 ni nulo.
El campo clasificacion_edad debe ser un valor entre 3 y 18.
El campo titulo no puede estar vacío y debe ser único.
La disponibilidad tendrá como valor predeterminado 'Disponible'. */
CREATE TABLE IF NOT EXISTS juego (
id_juego INT PRIMARY KEY AUTO_INCREMENT,
titulo VARCHAR(30) NOT NULL UNIQUE,
genero VARCHAR(15),
precio DECIMAL(5,2) NOT NULL CHECK (precio >= 0),
clasificacion_edad INT CHECK (clasificacion_edad BETWEEN 3 AND 18),
disponibilidad ENUM ("No Disponible", "Próximamente", "Disponible") DEFAULT "Disponible"
);
/*Usuario:
Debe contener los campos id_usuario (INT), nombre_usuario (VARCHAR), email (VARCHAR), fecha_registro (DATETIME), pais (ENUM) con valores posibles ‘Estados Unidos’, ‘Reino Unido’, ‘Japón’, ‘España’, y ‘Brasil’, id_juego.
El campo email debe ser único y no puede ser nulo.
La fecha_registro debe tener como valor predeterminado la fecha actual.
El campo nombre_usuario no puede estar vacío y debe ser único.
Establecer una relación con la tabla Juego a través de la clave foránea id_juego.
*/
CREATE TABLE IF NOT EXISTS usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre_usuario VARCHAR(30) NOT NULL UNIQUE,
    email VARCHAR(20) NOT NULL UNIQUE,
    fecha_registro DATETIME DEFAULT NOW(),
    pais ENUM('Estados Unidos', 'Reino Unido', 'Japón', 'España', 'Brasil'),
    id_juego INT,
    FOREIGN KEY (id_juego) REFERENCES juego (id_juego)
);

/*Partida
Debe incluir los campos id_partida (INT), fecha_partida (DATETIME), id_juego (INT), id_ganador (INT), y duracion_minutos (INT).
La fecha_partida debe tener como valor predeterminado la fecha actual.
El campo duracion_minutos debe ser mayor a 0 y tener como valor predeterminado 30.
Establecer una relación con la tabla Juego mediante el campo id_juego y con la tabla Usuario mediante id_ganador, que representa al usuario que ganó la partida.
*/
CREATE TABLE IF NOT EXISTS partida (
    id_partida INT PRIMARY KEY AUTO_INCREMENT,
    fecha_partida DATETIME DEFAULT NOW(),
    id_juego INT,
    id_ganador INT,
    duracion_minutos INT DEFAULT 30 CHECK (duracion_minutos > 0),
    FOREIGN KEY (id_juego) REFERENCES juego (id_juego),
    FOREIGN KEY (id_ganador) REFERENCES usuario (id_usuario)
);
/*Logro:
Debe contener los campos id_logro (INT), nombre_logro (VARCHAR), descripcion (TEXT), dificultad (ENUM) con valores ‘Fácil’, ‘Medio’, y ‘Difícil’, puntos (INT), id_juego e id_usuario.
El campo nombre_logro debe ser único y no puede ser vacío.
El campo descripcion no puede estar vacío.
El campo puntos debe ser un valor mayor a 0 y menor a 100, y tener como valor predeterminado 10. Tampoco puede estar vacío.
La dificultad tendrá como valor predeterminado ‘Medio’.
Establecer una relación con la tablas Juego y Usuario a través de las claves secundarias id_juego e id_usuario respectivamente.
*/
CREATE TABLE IF NOT EXISTS logro (
    id_logro INT PRIMARY KEY AUTO_INCREMENT,
    nombre_logro VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT NOT NULL,
    dificultad ENUM ("Fácil", "Medio", "Díficil") DEFAULT "Medio",
    puntos INT DEFAULT 10 NOT NULL CHECK (puntos BETWEEN 0 AND 100),
    id_juego INT,
    id_usuario INT,
    FOREIGN KEY (id_juego) REFERENCES juego (id_juego),
    FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
);
/*Comentario:
Debe contener los campos id_comentario (INT), id_usuario (INT), id_juego (INT), texto_comentario (TEXT) y fecha_comentario (DATETIME).
El campo texto_comentario no puede estar vacío.
La fecha_comentario solo debe permitir la fecha actual como valor predeterminado.
Establecer una relación entre id_usuario de la tabla Usuario y id_juego de la tabla Juego.
*/
CREATE TABLE IF NOT EXISTS comentario (
    id_comentario INT PRIMARY KEY AUTO_INCREMENT,
    texto_comentario TEXT NOT NULL,
    id_juego INT,
    id_usuario INT,
    fecha_comentario DATETIME DEFAULT NOW(),
    FOREIGN KEY (id_juego) REFERENCES juego (id_juego),
    FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
);
-- Insertar 5 registros en cada tabla
INSERT INTO juego (titulo, genero, precio, clasificacion_edad, disponibilidad)
VALUES ("La vida", "Acción", 80, 10, DEFAULT),
	   ("La muerte", "Terror", 120, 18, "No disponible"),
	   ("La casa", "Puzzle", 30, 3, "Próximamente"),
	   ("La lava", "Metroidvania", 5, 7, "No disponible"),
	   ("La lupa", "Roguelike", 73, 12, DEFAULT);
       
INSERT INTO usuario (nombre_usuario, email, pais, id_juego)
VALUES ("Antonio", "antonio@gmail", "España", 1),
       ("loko", "lele@gmail", "Reino Unido", 4),
       ("lele", "ee@gmail", "Brasil", 2),
       ("lulu", "aa@gmail", "Japón", 3),
       ("peoep", "pepe@gmail", "España", 5);
	   
       
INSERT INTO partida (id_juego, id_ganador, duracion_minutos)
VALUES (2, 3, 100),
	   (1, 2, 30),
	   (5, 1, 60),
	   (4, 5, 90),
	   (3, 4, DEFAULT);
	
INSERT INTO logro (nombre_logro, descripcion, dificultad, puntos, id_juego, id_usuario)
VALUES ("liada", "Elimina a tu compañero", DEFAULT, 100, 1,2),
	   ("God", "Elimina a todo el mundo", DEFAULT, 33, 1,2),
	   ("muy bueno", "Derriba 1 bicho", "Medio", 70, 2,3),
	   ("excelente", "Derriba 2", "Fácil", 21, 4,5),
	   ("malillo en verdad", "Mata 10 pikachus", "Difícil", 89, 5,4);
       
INSERT INTO comentario (texto_comentario, id_juego, id_usuario)
VALUES ("yes", 2, 4),
	   ("awesome", 1, 3),
	   ("bullshit", 5, 4),
	   ("awful", 3, 2),
	   ("not for me", 4, 1);
 
 /*Añade un nuevo campo a la tabla Juego llamado ventas (INT) que refleje el número de copias vendidas.
Modifica el nombre del campo clasificacion_edad en la tabla Juego para que se llame pegi.
Cambia el tipo de dato del campo puntos en la tabla Logro para permitir decimales.
 */
 ALTER TABLE juego
 ADD ventas INT DEFAULT 0;
 
 ALTER TABLE juego
 CHANGE clasificacion_edad pegi INT CHECK (pegi BETWEEN 3 AND 18);
 
 ALTER TABLE logro
 CHANGE puntos puntos DECIMAL (5,2) DEFAULT 10 NOT NULL CHECK (puntos BETWEEN 0 AND 100);
 
/*Actualiza el precio de un juego específico, aplicando un descuento del 15% si su disponibilidad es ‘Próximamente’ (asegúrate de haber guardado algún juego cuya disponibilidad sea ‘Próximamente’).
Cambia el país del usuario cuyo id_usuario sea 4 a "Reino Unido".
Actualiza la dificultad del logro cuyo id_logro sea 3 a ‘Difícil’.
*/
UPDATE juego
SET precio = precio * 0.85
WHERE disponibilidad = "Próximamente";

UPDATE usuario
SET pais = "Reino Unido"
WHERE id_usuario = 4;

UPDATE logro
SET dificultad = "Díficil"
WHERE id_logro = 3;

/*Elimina de la tabla Logro todos los los logros cuya dificultad sea 'Fácil' o tengan menos de 50 puntos.
Borra de la tabla Partida todas las partidas cuya duración sea inferior a 20 minutos.
*/
DELETE FROM logro
WHERE dificultad = "Fácil" OR puntos < 50;

DELETE FROM partida
WHERE duracion_minutos < 20;
/*
Añade un nuevo logro en la tabla Logro con nivel de dificultad ‘Difícil’.
Inserta un nuevo juego en la tabla Juego con una disponibilidad ‘Próximamente’ y precio de 20.*/

INSERT INTO logro (nombre_logro, descripcion, dificultad, puntos, id_juego, id_usuario) 
VALUES ('brilla como luz', 'Logro dificl', 'Difícil', 80, 1, 4);

INSERT INTO juego (titulo, genero, precio, pegi, disponibilidad, ventas)
VALUES ("Olee", "Super locura", 60, 17, DEFAULT, 500.000);

/*Inserta cinco nuevas partidas multijugador en la tabla Partida, asignándolas a distintos juegos y con ganadores distintos.
Cambia la disponibilidad de todos los juegos cuyo género sea "Aventura" a ‘No Disponible’.
Agregar el campo id_amigo a la tabla Usuario y establecer una relación reflexiva (relación dentro de la misma tabla) con Usuario a través del campo id_amigo, estableciendo así, una relación de amistad entre los usuarios de la plataforma.
Inserta otros 5 usuarios nuevos que sean amigos de los usuarios que ya existen.
*/
INSERT INTO Partida (id_juego, id_ganador, duracion_minutos) 
VALUES (1, 2, 40),
	   (2, 3, 50),
       (3, 4, 30),
       (4, 5, 45),
       (5, 1, 60);
       
UPDATE juego
SET disponibilidad = "No Disponible"
WHERE genero = "Aventura";

ALTER TABLE usuario
ADD id_amigo INT,
ADD FOREIGN KEY (id_amigo) REFERENCES usuario (id_usuario);

INSERT INTO usuario (nombre_usuario, email, pais, id_juego, id_amigo)
VALUES ("lokito potence", "qqqqqqqq@gmail.com", "España", 1, 1),
	   ("antoñito lele", "www@gmail.com", "Reino Unido", 2, 2),
       ("lokito garcia", "ee@gmail.com", "Estados Unidos", 3, 3),
       ("lokito papa", "aaaaaaaaaa@gmail.com", "Brasil", 4, 4),
       ("lokito poep", "eeeeee@gmail.com", "España", 5, 5);
       
-- Elimina por completo la tabla Comentario de la base de datos.
DROP TABLE IF EXISTS comentario;