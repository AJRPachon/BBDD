

--Las fuerzas de seguridad están intentando localizar y detener a un peligroso terrorista neonazi que prepara un atentado contra un centro social que ofrece comida
--y alojamiento a personas con pocos recursos.

--Para ello se ha instalado un sistema de videovigilancia y reconocimiento automático de imágenes en el metro. El terrorista ha sido detectado por este sistema en varias ocasiones. 

--La Policía nos envía una tabla en la que figura el momento en el que fue detectado el terrorista por alguna de las cámaras y el grado de fiabilidad de esa detección.

--El grado de fiabilidad es un número real entre 0.5 y 1, y representa la probabilidad estimada de que la detección sea correcta.

--Para ser buena, una detección tiene que tener un valor superior a 0.85. Si está entre 0.85 y 0.70 se considera media, y si es inferior a 0.7 es una detección mala.

--Se ha añadido un ID a la tabla para facilitar el trabajo y para cumplir la primera restricción inherente al modelo relacional, que para eso somos gente seria y profesional.

--Nos piden que identifiquemos quiénes eran los usuarios del metro que estaban dentro del sistema en esos momentos que nos dan y generemos una tabla en la que almacenaremos los IDs
--, nombre, apellidos, número de identificaciones positivas, número de identificaciones positivas buenas y valor medio de la fiabilidad de las identificaciones.


USE LeoMetro
GO
-- Datos de detecciones del terrorista en el sistema de metro
-- Esta tabla nos la env�a la Polic�a
CREATE TABLE Detecciones (
	ID Int Not NULL Identity,
	Momento SmallDateTime Not NULL,
	Fiabilidad float Not NULL Constraint CKO1 Check (Fiabilidad Between 0 AND 1),
	Constraint PKDetecciones Primary Key (ID)
)
GO
-- Datos
INSERT INTO Detecciones (Momento,Fiabilidad)
    VALUES (SmallDateTimeFromParts(2017,2,24,17,03),0.84), (SmallDateTimeFromParts(2017,2,24,19,20),0.77),
	(SmallDateTimeFromParts(2017,2,24,20,16),0.92), (SmallDateTimeFromParts(2017,2,24,23,41),0.64),
	(SmallDateTimeFromParts(2017,2,25,7,4),0.61), (SmallDateTimeFromParts(2017,2,25,8,2),0.58),
	(SmallDateTimeFromParts(2017,2,25,13,35),0.88), (SmallDateTimeFromParts(2017,2,25,13,58),0.72),
	(SmallDateTimeFromParts(2017,2,25,18,56),0.96), (SmallDateTimeFromParts(2017,2,25,19,3),0.68),
	(SmallDateTimeFromParts(2017,2,25,22,16),0.86), (SmallDateTimeFromParts(2017,2,25,22,24),0.71),
	(SmallDateTimeFromParts(2017,2,26,0,14),0.62), (SmallDateTimeFromParts(2017,2,26,0,21),0.87),
	(SmallDateTimeFromParts(2017,2,26,10,47),0.78), (SmallDateTimeFromParts(2017,2,26,14,3),0.54)
GO

-- Esta es la tabla que debe rellenarse con los datos calculados
CREATE TABLE Sospechosos (
	ID Int Not NULL,
	Nombre VarChar (20) Not NULL,
	Apellidos VarChar(30) Not NULL,
	IdentificacionesPositivas TinyInt Not NULL,
	IdentificacionesBuenas TinyInt Not NULL,
	FiabilidadMedia Float,
	Constraint CKBuenasMenor Check(IdentificacionesBuenas<=IdentificacionesPositivas),
	Constraint CKFiabilidadO1 Check (FiabilidadMedia Between 0 AND 1)
)
