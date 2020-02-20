
USE LeoMetro
GO


--Ejercicio 1 
--Indica el n�mero de estaciones por las que pasa cada l�nea

SELECT * FROM LM_Lineas
SELECT * FROM LM_Itinerarios
SELECT * FROM LM_Estaciones

SELECT L.ID ,COUNT(E.ID) AS [Numero de estaciones] FROM LM_Lineas AS L 
INNER JOIN LM_Itinerarios AS I  ON L.ID = I.Linea
INNER JOIN LM_Estaciones AS E  ON I.estacionIni = E.ID
GROUP BY L.ID


--Ejercicio 2 
--Indica el n�mero de trenes diferentes que han circulado en cada l�nea

SELECT * FROM LM_Lineas
SELECT * FROM LM_Recorridos
SELECT * FROM LM_Trenes

GO
CREATE VIEW NumeroTrenes AS
SELECT T.ID AS [Trenes ID], L.ID AS [Lineas ID] FROM LM_Lineas AS L
INNER JOIN LM_Recorridos AS R  ON L.ID = R.Linea
INNER JOIN LM_Trenes AS T  ON R.Tren = T.ID
GROUP BY L.ID, T.ID
GO --Primero tengo que ver los trenes que pasan por cada linea
-- Una vez lo tengo, contar esos trenes, creo una vista para que sea m�s f�cil visualizar

SELECT COUNT(NT.[Trenes ID]) AS [Cantidad de trenes], NT.[Lineas ID] FROM LM_Trenes AS T
INNER JOIN NumeroTrenes AS NT  ON T.ID = NT.[Trenes ID]
GROUP BY NT.[Lineas ID]


--Ejercicio 3 
--Indica el n�mero medio de trenes de cada clase que pasan al d�a por cada estaci�n. 

--Primero: n� de trenes que pasa por cada estaci�n, tipo de trenes y agrupar por dias 
--Segundo: Media de los trenes que pasan por cada estacion, cada dia

SELECT * FROM LM_Trenes
SELECT * FROM LM_Recorridos
SELECT * FROM LM_Estaciones

SELECT E.ID AS [ID Estacion],E.Denominacion, NumTrenesEstacion.Tipo, AVG(NumTrenesEstacion.[Numero de trenes]) AS [Media trenes por tipo] FROM LM_Estaciones AS E
INNER JOIN(

	SELECT E.ID, T.Tipo, CONVERT(DATE,R.Momento) AS [Dias] ,COUNT(T.ID) AS [Numero de trenes] FROM LM_Trenes AS T
	INNER JOIN LM_Recorridos AS R  ON T.ID = R.Tren
	INNER JOIN LM_Estaciones AS E  ON R.estacion = E.ID
	GROUP BY E.ID, T.Tipo, CONVERT(DATE,R.Momento) 

) AS NumTrenesEstacion  ON E.ID = NumTrenesEstacion.ID
GROUP BY NumTrenesEstacion.Tipo, NumTrenesEstacion.ID, E.ID, E.Denominacion



--Ejercicio 4 
--Calcula el tiempo necesario para recorrer una l�nea completa, contando con el tiempo estimado de cada itinerario y considerando
-- que cada parada en una estaci�n dura 30 s.

SELECT * FROM LM_Lineas
SELECT * FROM LM_Itinerarios
SELECT * FROM LM_Estaciones

SELECT Linea,DATEADD(SECOND, SUM((DATEPART(MINUTE,tiempoEstimado) * 60) + DATEPART(SECOND ,TiempoEstimado))+30, CONVERT(TIME , '0:0')) AS [Segundos] FROM LM_Itinerarios
GROUP BY Linea
--Con DATEADD, el tercer parametro tiene que ser la fecha a la cual quiero a�adir la suma de las otras 2, por lo que empiezo desde 0:0
--Primero cojo los minutos y luego los segundos restantes, a los que le sumo esos 30 segundos que se lleva el tren parado en una estaci�n



--Ejercicio 5 
--Indica el n�mero total de pasajeros que entran (a pie) cada d�a por cada estaci�n y los que salen del metro en la misma. 

SELECT * FROM LM_Pasajeros
SELECT * FROM LM_Tarjetas
SELECT * FROM LM_Viajes
SELECT * FROM LM_Estaciones

--Primero: n� total de pasajeros en cada estacion y agrupar por dias 
--Segundo: pasajeros que salen por la misma estacion que entra en el mismo dia

GO
CREATE VIEW TotalPersonas AS
SELECT E.ID AS [ID Estaciones], CONVERT(DATE, V.MomentoEntrada) AS [Momento entrada] , COUNT(P.ID) AS [Numero de personas] FROM LM_Pasajeros AS P
INNER JOIN LM_Tarjetas AS T  ON P.ID = T.IDPasajero
INNER JOIN LM_Viajes AS V  ON T.ID = V.IDTarjeta
INNER JOIN LM_Estaciones AS E  ON V.IDEstacionSalida = E.ID
GROUP BY E.ID, CONVERT(DATE, V.MomentoEntrada)
GO


SELECT DISTINCT TP.[ID Estaciones], TP.[Momento entrada], TP.[Numero de personas] FROM LM_Estaciones AS E
INNER JOIN TotalPersonas AS TP  ON E.ID = TP.[ID Estaciones]
INNER JOIN LM_Viajes AS V  ON E.ID = V.IDEstacionEntrada
WHERE V.IDEstacionEntrada = V.IDEstacionSalida

--Preguntar a LEO


--Ejercicio 6 
--Calcula la media de kil�metros al d�a que hace cada tren. Considera �nicamente los d�as que ha estado en servicio 




--Ejercicio 7 
--Calcula cu�l ha sido el intervalo de tiempo en que m�s personas registradas han estado en el metro al mismo tiempo. Considera intervalos de una hora (de 12:00 a 12:59, de 13:00 a 13:59, etc). Si hay varios momentos con el n�mero m�ximo de personas, muestra el m�s reciente.




--Ejercicio 8 
--Calcula el dinero gastado por cada usuario en el mes de febrero de 2017. El precio de un viaje es el de la zona m�s cara que incluya. Incluye a los que no han viajado.




--Ejercicio 9 
--Calcula el tiempo medio diario que cada pasajero pasa en el sistema de metro y el n�mero de veces que accede al mismo.