USE Colegas
GO

SET DATEFORMAT 'YMD'
GO

BEGIN TRANSACTION PEOPLE
GO
SELECT * FROM People

INSERT INTO People (ID, Nombre, Apellidos, FechaNac)
VALUES 
	(1, 'Eduardo', 'Mingo', '1990-07-14') ,
	(2, 'Margarita', 'Padera', '1992-11-11'),
	(4, 'Eloisa', 'Lamandra', '2000-03-02'),
	(5, 'Jordi', 'Videndo', '1989-05-28'),
	(6, 'Alfonso', 'Sito', '1978-10-10');
GO


BEGIN TRANSACTION CARROS
SELECT * FROM Carros

INSERT INTO Carros (ID, Marca, Modelo, Anho, Color, IDPropietario)
VALUES
	(1, 'Seat', 'Ibiza', '2014', 'Blanco', NULL),
	(2, 'Ford', 'Focus', '2016', 'Rojo', 1),
	(3, 'Toyota', 'Prius', '2017', 'Blanco', 4),
	(5, 'Renault', 'Megane', '2004', 'Azul', 2),
	(8, 'Mitsubishi', 'Colt', '2011', 'Rojo', 6);
 GO


 BEGIN TRANSACTION LIBROS
 SELECT * FROM Libros

 ALTER TABLE Libros
 ALTER COLUMN Titulo VARCHAR(50)

 INSERT INTO Libros (ID, Titulo, Autors)
 VALUES
	(2, 'El corazón de las Tinieblas', 'Joseph Conrad'),
	(4, 'Cien años de soledad', 'Gabriel García Márquez'),
	(8, 'Harry Potter y la cámara de los secretos', 'J.K. Rowling'),
	(16, 'Evangelio del Flying Spaguetti Monster', 'Bobby Henderson');
GO

--4. Eduardo Mingo ha leído Cien años de Soledad el año pasado. Margarita ha leído El corazón de las tinieblas en 2014.
-- Eloisa ha leído Cien años de soledad en 2015 y Harry Potter en 2017. Jordi y Alfonso han leído El Evangelio del FSM en 2010.

BEGIN TRANSACTION Lecturas
SELECT * FROM Lecturas

INSERT INTO Lecturas (IDLibro, IDLector, AnhoLectura)
VALUES
	('4','1','2018'),
	('2','2','2014'),
	('4','4','2015'),
	('8','4','2017'),
	('16','5','2010'),
	('16','6','2010');
GO

--5. Margarita le ha vendido su coche a Alfonso.

BEGIN TRANSACTION CARROS
SELECT * FROM Carros

UPDATE Carros
SET IDPropietario = '6'
WHERE ID = '2';
ROLLBACK

--6. Queremos saber los nombres y apellidos de todos los que tienen 30 años o más

SELECT * FROM People

SELECT Nombre, Apellidos
FROM People
WHERE (DATEDIFF (YEAR, FechaNac, getdate())) > 30; --(YEAR(CURRENT_TIMESTAMP - CAST(FechaNac AS SMALLDATETIME)) -1900 AS Edad
GO

--7. Marca, año y modelo de todos los coches que no sean blancos ni verdes

SELECT * FROM Carros

SELECT Marca, Modelo, Anho, Color
FROM carros
WHERE Color != 'Blanco' AND Color != 'Verde'; --NOT IN ('Blanco','Verde')
GO

--8. El nuevo gobierno regional ha prohibido todas las religiones, excepto la oficial. 
--Por ello, los pastafarianos se ven obligados a ocultarse. Inserta un nuevo libro titulado "Vidas santas" cuyo autor es el Abate Bringas. 
--Actualiza la tabla lecturas para cambiar las lecturas del Evangelio del FSM por este nuevo libro

SELECT * FROM Libros

INSERT INTO libros(ID, Titulo, Autors)
VALUES
('32','Vidas santas','Abate Bringas');
GO

SELECT * FROM Lecturas

UPDATE Lecturas
SET IDLibro = '32'
WHERE IDLibro = '16';
GO

--9. Eloísa también ha leído El corazón de las tinieblas y le ha gustado mucho.

SELECT * FROM Lecturas

INSERT INTO lecturas(IDLibro, IDLector, AnhoLectura)
VALUES
	('32','4',NULL);
GO

--10. Jordi se ha comprado el Seat Ibiza

SELECT * FROM Carros

UPDATE carros
SET IDPropietario = '5'
WHERE ID = 1;
GO


--11. Haz una consulta que nos devuelva los ids de los colegas que han leído alguno de los libros con ID par.

SELECT * FROM Lecturas

SELECT IDLector
FROM lecturas
WHERE (IDLector % 2) = 0;
GO