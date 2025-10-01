/* Crear la base de datos llamada tienda_libros.
-- Crear las siguientes tablas:
Autor (id_autor (int), nombre (varchar), apellido (varchar), nacionalidad (varchar))
Editorial (id_editorial (int), nombre_editorial (varchar), pais_origen (varchar))
Libro (id_libro (int), titulo (varchar), fecha_publicacion (date), precio (decimal), id_autor (int), id_editorial (int))
Cliente (id_cliente (int), nombre_cliente (varchar), apellido_cliente (varchar), correo (varchar), telefono (varchar))
Venta (id_venta (int), id_cliente (int), id_libro (int), fecha_venta (datetime, guardar la fecha actual))
-- Relaciones:
La tabla Libros debe tener una clave foránea hacia Autores (id_autor).
La tabla Libros debe tener una clave foránea hacia Editoriales (id_editorial).
La tabla Ventas debe estar relacionada con Clientes (id_cliente) y con Libros (id_libro).
-- Insertar 5 registros en cada tabla con datos ficticios.
*/

CREATE DATABASE tienda_libros;

USE tienda_libros;

CREATE TABLE Autor (
	id_autor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50),
    nacionalidad VARCHAR(50)
);

CREATE TABLE Editorial (
	id_editorial INT PRIMARY KEY AUTO_INCREMENT,
    nombre_editorial VARCHAR(50) NOT NULL,
    pais_origen VARCHAR(50)
);

CREATE TABLE Libro (
	id_libro INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(50) NOT NULL,
    fecha_publicacion DATE,
    precio decimal(6,2) default 500,
    id_autor INT,
    id_editorial INT,
    FOREIGN KEY (id_autor) REFERENCES Autor (id_autor),
    FOREIGN KEY (id_editorial) REFERENCES Editorial (id_editorial)
);

CREATE TABLE Cliente (
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre_cliente VARCHAR(50) NOT NULL,
    apellido_cliente VARCHAR(50),
    correo VARCHAR(50) NOT NULL,
    telefono VARCHAR(50) NOT NULL
);

CREATE TABLE Venta (
	id_venta INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    id_libro INT,
    fecha_venta DATETIME DEFAULT (now()),
    FOREIGN KEY (id_cliente) REFERENCES Cliente (id_cliente),
    FOREIGN KEY (id_libro) REFERENCES Libro (id_libro)
);

INSERT INTO Autor (nombre, apellido, nacionalidad)
VALUES ("Charizard", "Martinez", "Española" ),
	   ("Antonio", "Pérez", "Chilena" ),
       ("Pepe", "Martinez", "Argentina" ),
       ("Lupa", "Gómez", "Brasileña" ),
       ("Alexby", "López", "Boliviana" );
       
INSERT INTO Editorial (nombre_editorial, pais_origen)
VALUES ("Manzana", "Cuba"),
	   ("Pera", "Sarten"),
       ("Uva", "Pañuelo"),
       ("Salmón", "Laca"),
       ("Plátano", "Tenedor");
       
INSERT INTO Libro (titulo, precio, id_autor, id_editorial,fecha_publicacion)
VALUES ("Amor", 13.90, 1, 1, "2024-11-09"),
	   ("Hola", 15, 2, 1, "2024-10-09"),
	   ("Saludos", 41, 3, 2, "2024-08-09"),
       ("Hasta luego", 78.35, 4, null, "2024-02-09"),
       ("Lava", 55, 5, 3, "2024-07-09");
       
INSERT INTO Cliente (nombre_cliente, apellido_cliente, correo, telefono)
VALUES ("Antonio", "Lopez", "antonio@gmail", 123),
		("Alejandro", "Martinez", "martinez@gmail", 156),
        ("Paco", "Sánchez", "sanchez@gmail", 175),
        ("Pepito", "Rabadán", "rabadan@gmail", 878),
        ("Pepal", "Chumillas", "chumillas@gmail", 656);

INSERT INTO Venta (id_cliente, id_libro)
VALUES (1, 2),
	   (2, 3),
	   (2, 4),
       (5, 1),
       (4, 5);
	


