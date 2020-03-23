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

SELECT * FROM Detecciones


CREATE TABLE #IdentificacionesFiables (

	ID INT,
	Nombre VARCHAR (25),
	Apellidos VARCHAR (30),
	IdentificacionesPositivas INT,
	IdentificacionesBuenas INT,
	AVG_Fiabilidad FLOAT, --Lo había puesto como INT primeramente, pero como da números decimales, lo he cambiado a FLOAT

)

INSERT #IdentificacionesFiables
	
	SELECT P.ID, P.Nombre, P.Apellidos, IdePM.[Identificaciones Positivas], ISNULL(IPB.[Identificaciones Positivas Buenas], 0) AS IdentificacionesBuenas, IdePM.[Fiabilidad Media] FROM LM_Pasajeros AS P
	INNER JOIN (

		--Contamos todas las identificaciones y hacemos la media de fiabilidad de ellas, agrupando por ID del pasajero
		--Las identificaciones positivas nos referimos a las que sean mayor de 0.7
		--Uso ROUND para que no salgan tantos número decimales
		SELECT T.IDPasajero, COUNT(DISTINCT D.Fiabilidad) AS [Identificaciones Positivas], ROUND(AVG(DISTINCT D.Fiabilidad),4) AS [Fiabilidad Media] FROM LM_Viajes AS V
		INNER JOIN LM_Tarjetas AS T  ON V.IDTarjeta = T.ID
		INNER JOIN Detecciones AS D  ON D.Momento BETWEEN V.MomentoEntrada AND V.MomentoSalida
		GROUP BY T.IDPasajero

	) AS IdePM ON P.ID = IdePM.IDPasajero

	LEFT JOIN ( --Para añadir los usuarios que no tiene identificaciones buenas ( como es el caso de ID 30 que si posee identificaciones positivas pero no buenas )
	
		--Contamos las identificaciones que la fiabilidad sea mayor que 0.85
		SELECT T.IDPasajero, COUNT(DISTINCT D.Fiabilidad) AS [Identificaciones Positivas Buenas] FROM LM_Viajes AS V
		INNER JOIN LM_Tarjetas AS T  ON V.IDTarjeta = T.ID
		INNER JOIN Detecciones AS D  ON D.Momento BETWEEN V.MomentoEntrada AND V.MomentoSalida
		WHERE Fiabilidad > 0.85
		GROUP BY T.IDPasajero
	
	) AS IPB ON IdePM.IDPasajero = IPB.IDPasajero

INSERT Sospechosos
SELECT * FROM #IdentificacionesFiables

SELECT * FROM Sospechosos

-- Para pasar el archivo a XML he encontrado esta sintaxis.

SELECT * FROM Sospechosos FOR XML AUTO, ELEMENTS, XMLDATA




