
--Nos piden que identifiquemos quiénes eran los usuarios del metro que estaban dentro del sistema en esos momentos que nos dan y generemos una tabla en la que almacenaremos los IDs
--, nombre, apellidos, número de identificaciones positivas, número de identificaciones positivas buenas y valor medio de la fiabilidad de las identificaciones.


SELECT * FROM Detecciones


CREATE TABLE #IdentificacionesFiables (

	ID INT,
	Nombre VARCHAR (25),
	Apellidos VARCHAR (30),
	IdentificacionesPositivas INT,
	IdentificacionesBuenas INT,
	AVG_Fiabilidad INT,

)

INSERT #IdentificacionesFiables
	
	SELECT P.ID, P.Nombre, P.Apellidos, IdePM.[Identificaciones Positivas], ISNULL(IPB.[Identificaciones Positivas Buenas], 0) AS IdentificacionesBuenas, IdePM.[Fiabilidad Media] FROM LM_Pasajeros AS P
	INNER JOIN (

		--Contamos todas las identificaciones y hacemos la media de fiabilidad de ellas, agrupando por ID del pasajero
		--Las identificaciones positivas nos referimos a las que sean mayor de 0.7
		SELECT T.IDPasajero, COUNT(DISTINCT D.Fiabilidad) AS [Identificaciones Positivas], AVG(DISTINCT D.Fiabilidad) AS [Fiabilidad Media] FROM LM_Viajes AS V
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






