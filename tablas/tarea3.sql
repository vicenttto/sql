-- Crear la base de datos llamada plataforma_series.
CREATE DATABASE IF NOT EXISTS plataforma_series;

USE plataforma_series;

-- Crear las siguientes tablas con las restricciones indicadas:
-- Serie: Debe incluir los campos id_serie (int), titulo_serie (varchar), anio_estreno (int), id_genero y calificación (int).
-- El campo calificacion debe ser un valor entre 1 y 10, y el anio de estreno debe estar entre 1950 y el anio actual. Además, el campo titulo_serie no debe de estar vacío.
CREATE TABLE IF NOT EXISTS Serie (
	id_serie INT PRIMARY KEY AUTO_INCREMENT,
    titulo_serie VARCHAR(30) NOT NULL,
	anio_estreno INT CHECK (anio_estreno >= 1950 AND anio_estreno <= 2024),
    id_genero INT,
    calificacion INT CHECK (calificacion >= 1 AND calificacion <= 10),
    FOREIGN KEY (id_genero) REFERENCES Genero (id_genero)
);

-- Episodio: Debe contener los campos id_episodio (int), titulo_episodio (varchar), temporada (int), duracion (int), id_serie y fecha_emision (date). 
-- Los campos duracion y temporada deben ser mayores que 0. Establecer una relación con la tabla Serie utilizando el campo id_serie como clave foránea. Además, el campo titulo_episodio no debe de estar vacío.
CREATE TABLE IF NOT EXISTS Episodio (
	id_episodio INT PRIMARY KEY AUTO_INCREMENT,
    titulo_episodio VARCHAR(30) NOT NULL,
	temporada INT CHECK (temporada > 0),
    duracion INT CHECK (duracion > 0),
    id_serie INT,
    fecha_emision DATE,
    FOREIGN KEY (id_serie) REFERENCES Serie (id_serie)
);

-- Genero: Debe tener los campos id_genero (int), nombre_genero e id_serie. 
-- El campo nombre_genero solo debe permitir valores como "Drama", "Comedia", "Ciencia Ficción", "Acción", “Terror” y “Fantasía”. Establecer una relación con la tabla Serie mediante id_serie.
CREATE TABLE IF NOT EXISTS Genero (
	id_genero INT PRIMARY KEY AUTO_INCREMENT,
    nombre_genero ENUM ("Drama", "Comedia", "Ciencia Ficción", "Acción", "Terror", "Fantasía")
    );

-- Actor: Debe incluir los campos id_actor (int), nombre_actor (varchar), nacionalidad (varchar), fecha_nacimiento (date) e id_serie. La fecha de nacimiento debe estar entre 1900 y el anio actual. 
-- El campo nacionalidad debe permitir solo ciertos valores como "Estados Unidos", "Reino Unido", "España". Además, el campo nombre_actor no puede estar vacío. Establecer una relación con la tabla Serie mediante id_serie.
CREATE TABLE IF NOT EXISTS Actor (
	id_actor INT PRIMARY KEY AUTO_INCREMENT,
    nombre_actor VARCHAR(30) NOT NULL,
	nacionalidad ENUM ("Estados Unidos", "Reino Unido", "España"),
    fecha_nacimiento DATE CHECK (fecha_nacimiento >= "1990-01-01" AND fecha_nacimiento <= "2024-01-01"),
    id_serie INT,
    FOREIGN KEY (id_serie) REFERENCES Serie (id_serie)
    );
    
-- Usuario: Debe contener los campos id_usuario (int), nombre_usuario (varchar), correo (varchar), fecha_registro (datetime) y suscripcion. 
-- El correo debe ser único y no puede ser nulo.
-- La fecha de registro no puede ser una fecha futura y por defecto se va a guardar la fecha actual. 
-- El campo suscripcion debe permitir valores como "Activo", "Inactivo", o "Pendiente".
CREATE TABLE IF NOT EXISTS Usuario (
	id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre_usuario VARCHAR(30),
	correo VARCHAR(30) NOT NULL UNIQUE,
    fecha_registro DATETIME DEFAULT NOW(),
    suscripcion ENUM ("Activo", "Inactivo", "Pendiente")
    );
    
-- Insertar 5 registros en cada tabla utilizando datos ficticios, respetando las restricciones de cada campo. 
-- Asegúrate de que las relaciones entre tablas sean correctas (por ejemplo, cada episodio debe estar asociado a una serie, y cada serie debe tener un género).
INSERT INTO Serie (titulo_serie, anio_estreno, id_genero, calificacion)
VALUES ("La vida", 1990, 1, 8),
	   ("La muerte", 2020, 2, 4),
       ("La estrella", 2000, 3, 7),
	   ("La pantalla", 2010, 4, 9),
       ("La ilusión", 1980, 5, 3);
       
INSERT INTO Episodio (titulo_episodio, temporada, duracion, id_serie, fecha_emision)
VALUES ("Vidita", 3, 100, 1, "2010-12-11"),
	   ("Estrellita", 5, 80, 2, "2013-02-10"),
       ("Muertis", 10, 70, 3, "2012-10-23"),
       ("Loquero", 94, 45, 4, "2019-01-23"),
       ("Pantallita", 54, 30, 5, "2011-03-18");
	  

INSERT INTO Genero (nombre_genero)
VALUES ("Drama"),
	   ("Comedia"),
       ("Ciencia Ficción"),
	   ("Acción"),
       ("Fantasía"),
       ("Terror");

INSERT INTO Actor (fecha_nacimiento, nombre_actor, nacionalidad, id_serie)
VALUES ("1990-11-23", "Antonio", "Estados Unidos", 1),
	   ("1995-03-24", "Mateo", "Reino Unido", 2),
       ("1998-02-20", "Miguel", "España", 3),
       ("2008-08-19", "Alvaro", "Reino Unido", 4),
       ("2006-02-11", "Vicente", "Estados Unidos", 5);
      
INSERT INTO Usuario (nombre_usuario, correo, suscripcion, fecha_registro)
VALUES ("Artista", "artista@gmail.com", "Activo", DEFAULT),
	   ("Paco", "paco@gmail.com", "Inactivo", "2020-08-18"),
       ("Loco", "loco@gmail.com", "Pendiente", DEFAULT),
       ("Ole", "ole@gmail.com", "Activo", "2018-07-11"),
       ("Rojo", "rojo@gmail.com", "Inactivo", "2011-02-25");

-- Añade un nuevo campo a la tabla Series para almacenar el número de temporadas 
ALTER TABLE Serie
ADD num_temp INT;

-- Modifica el nombre del campo correo en la tabla Usuarios para que se llame email_usuario.
ALTER TABLE Usuario
CHANGE correo email_usuario VARCHAR(30) NOT NULL UNIQUE;
-- Cambia el tipo de dato del campo duracion en la tabla Episodios para permitir decimales (por ejemplo, episodios de 45.5 minutos).;
ALTER TABLE Episodio
CHANGE duracion duracion DECIMAL(5,2);
-- Actualiza la calificación de la serie cuyo id_serie sea 2, aumentando su calificación a 9.
UPDATE Serie
SET califacion = 9
WHERE id_serie = 2;
-- Cambia el género de una serie cuyo id_serie sea 5 a "Comedia".
UPDATE Serie
SET id_genero = 2
WHERE id_serie = 5;
-- Actualiza el estado de suscripción del usuario cuyo id_usuario sea 3 a "Activo".
UPDATE Usuario
SET suscripcion = "Activo"
WHERE id_usuario = 3;
-- Elimina de la tabla Episodios todos los episodios cuya duración sea menor a 80 minutos.
DELETE FROM Episodio
WHERE duracion < 80;
-- Borra de la tabla Series todas las series que fueron estrenadas antes del año 2000.
DELETE FROM Serie
WHERE anio_estreno < 2000;
-- Añade un nuevo género en la tabla Géneros con el nombre "Animación" y asigna este nuevo género a una nueva serie que debes insertar.
ALTER TABLE Genero
CHANGE nombre_genero nombre_genero ENUM ("Drama", "Comedia", "Ciencia Ficción", "Acción", "Terror", "Fantasía", "Animación");

INSERT INTO Genero (nombre_genero)
VALUES ("Animación");

INSERT INTO Serie (titulo_serie, anio_estreno, id_genero, calificacion)
VALUES ("LUCEZILLA", 2000, 7, 10);




-- Inserta cinco nuevos episodios en la tabla Episodios, asignándolos a distintas series.

INSERT INTO Episodio (titulo_episodio, temporada, duracion, id_serie, fecha_emision)
VALUES ("LOPE", 4, 120, 5, "2001-12-11"),
	   ("LILI", 7, 33, 4, "2004-02-10"),
       ("XOXO", 6, 57, 3, "2002-10-23"),
       ("IEI", 20, 80, 2, "2017-01-23"),
       ("PWPW", 11, 92, 1, "2008-03-18");
-- Crea una nueva tabla llamada Comentario con los campos id_comentario (int), id_usuario, id_serie, texto_comentario (text), y fecha_comentario (datetime). El campo texto_comentario no puede esta vacío y el campo fecha_comentario solo debe permitir guardar la fecha actual. Inserta al menos diez comentarios realizados por usuarios sobre diferentes series.
CREATE TABLE IF NOT EXISTS comentario (
id_comentario INT PRIMARY KEY AUTO_INCREMENT,
id_usuario INT,
id_serie INT,
texto_comentario TEXT NOT NULL,
fecha_comentario DATETIME DEFAULT NOW(),
FOREIGN KEY (id_usuario) REFERENCES Usuario (id_usuario),
FOREIGN KEY (id_serie) REFERENCES Serie (id_serie)
);

INSERT INTO comentario (id_usuario, id_serie, texto_comentario, fecha_comentario)
VALUES (1,1, "Bonita", DEFAULT),
	   (2,2, "Locura", "2024-11-06 12:04:11"),
       (3,3, "God", DEFAULT),
       (4,5, "LOkete", DEFAULT),
       (5,4, "Increible", DEFAULT);
-- Cambia el estado de suscripción de todos los usuarios registrados antes de 2022 a "Inactivo".
UPDATE Usuario
SET suscripcion = "Inactivo"
WHERE fecha_registro < "2022-01-01";
-- Elimina por completo la tabla Actores de la base de datos.
DROP TABLE actor;
