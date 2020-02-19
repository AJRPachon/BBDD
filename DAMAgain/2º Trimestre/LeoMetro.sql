
USE LeoMetro
GO


--Ejercicio 1 
--Indica el número de estaciones por las que pasa cada línea

SELECT * FROM LM_Lineas
SELECT * FROM LM_Itinerarios
SELECT * FROM LM_Estaciones

SELECT L.ID ,COUNT(E.ID) AS [Numero de estaciones] FROM LM_Lineas AS L 
INNER JOIN LM_Itinerarios AS I  ON L.ID = I.Linea
INNER JOIN LM_Estaciones AS E  ON I.estacionIni = E.ID
GROUP BY L.ID


--Ejercicio 2 
--Indica el número de trenes diferentes que han circulado en cada línea

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
-- Una vez lo tengo, contar esos trenes, creo una vista para que sea más fácil visualizar

SELECT COUNT(NT.[Trenes ID]) AS [Cantidad de trenes], NT.[Lineas ID] FROM LM_Trenes AS T
INNER JOIN NumeroTrenes AS NT  ON T.ID = NT.[Trenes ID]
GROUP BY NT.[Lineas ID]


--Ejercicio 3 
--Indica el número medio de trenes de cada clase que pasan al día por cada estación. 

SELECT * FROM LM_Estaciones
SELECT * FROM LM_Recorridos
SELECT * FROM LM_Trenes

GO
CREATE VIEW [Numero de trenes totales] AS --Para coger el numero de trenes totales que pasan por cada estación
SELECT COUNT(T.ID) AS [Numero de trenes], E.ID AS [Estaciones ID] FROM LM_Estaciones AS E 
INNER JOIN LM_Recorridos AS R  ON E.ID = R.estacion
INNER JOIN LM_Trenes AS T  ON R.Tren = T.ID
GROUP BY E.ID
GO

SELECT  NTT.[Estaciones ID], NTT.[Numero de trenes] FROM LM_Estaciones AS E 
INNER JOIN [Numero de trenes totales] AS NTT ON E.ID = NTT.[Estaciones ID]



--Ejercicio 4 
--Calcula el tiempo necesario para recorrer una línea completa, contando con el tiempo estimado de cada itinerario y considerando que cada parada en una estación dura 30 s.




--Ejercicio 5 
--Indica el número total de pasajeros que entran (a pie) cada día por cada estación y los que salen del metro en la misma. 




--Ejercicio 6 
--Calcula la media de kilómetros al día que hace cada tren. Considera únicamente los días que ha estado en servicio 




--Ejercicio 7 
--Calcula cuál ha sido el intervalo de tiempo en que más personas registradas han estado en el metro al mismo tiempo. Considera intervalos de una hora (de 12:00 a 12:59, de 13:00 a 13:59, etc). Si hay varios momentos con el número máximo de personas, muestra el más reciente.




--Ejercicio 8 
--Calcula el dinero gastado por cada usuario en el mes de febrero de 2017. El precio de un viaje es el de la zona más cara que incluya. Incluye a los que no han viajado.




--Ejercicio 9 
--Calcula el tiempo medio diario que cada pasajero pasa en el sistema de metro y el número de veces que accede al mismo.