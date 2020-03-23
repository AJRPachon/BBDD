--Las fuerzas de seguridad est�n intentando localizar y detener a un peligroso terrorista neonazi que prepara un atentado contra un centro social que ofrece comida
--y alojamiento a personas con pocos recursos.

--Para ello se ha instalado un sistema de videovigilancia y reconocimiento autom�tico de im�genes en el metro. El terrorista ha sido detectado por este sistema en varias ocasiones. 

--La Polic�a nos env�a una tabla en la que figura el momento en el que fue detectado el terrorista por alguna de las c�maras y el grado de fiabilidad de esa detecci�n.

--El grado de fiabilidad es un n�mero real entre 0.5 y 1, y representa la probabilidad estimada de que la detecci�n sea correcta.

--Para ser buena, una detecci�n tiene que tener un valor superior a 0.85. Si est� entre 0.85 y 0.70 se considera media, y si es inferior a 0.7 es una detecci�n mala.

--Se ha a�adido un ID a la tabla para facilitar el trabajo y para cumplir la primera restricci�n inherente al modelo relacional, que para eso somos gente seria y profesional.

--Nos piden que identifiquemos qui�nes eran los usuarios del metro que estaban dentro del sistema en esos momentos que nos dan y generemos una tabla en la que almacenaremos los IDs
--, nombre, apellidos, n�mero de identificaciones positivas, n�mero de identificaciones positivas buenas y valor medio de la fiabilidad de las identificaciones.


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

	LEFT JOIN ( --Para a�adir los usuarios que no tiene identificaciones buenas ( como es el caso de ID 30 que si posee identificaciones positivas pero no buenas )
	
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






