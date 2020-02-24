
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

--Primero: nº de trenes que pasa por cada estación, tipo de trenes y agrupar por dias 
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
--Calcula el tiempo necesario para recorrer una línea completa, contando con el tiempo estimado de cada itinerario y considerando
-- que cada parada en una estación dura 30 s.

SELECT * FROM LM_Lineas
SELECT * FROM LM_Itinerarios
SELECT * FROM LM_Estaciones

SELECT Linea,DATEADD(SECOND, SUM((DATEPART(MINUTE,tiempoEstimado) * 60) + DATEPART(SECOND ,TiempoEstimado) +30), CONVERT(TIME , '0:0')) AS [Segundos] FROM LM_Itinerarios
GROUP BY Linea

--Con DATEADD, el tercer parametro tiene que ser la fecha a la cual quiero añadir la suma de las otras 2, por lo que empiezo desde 0:0
--Primero cojo los minutos y luego los segundos restantes, a los que le sumo esos 30 segundos que se lleva el tren parado en una estación



--Ejercicio 5 
--Indica el número total de pasajeros que entran (a pie) cada día por cada estación y los que salen del metro en la misma. 

SELECT * FROM LM_Pasajeros
SELECT * FROM LM_Tarjetas
SELECT * FROM LM_Viajes
SELECT * FROM LM_Estaciones

--Primero: nº total de pasajeros en cada estacion y agrupar por dias 
--Segundo: pasajeros que salen por la misma estacion que entra en el mismo dia

GO
CREATE VIEW EstacionEntrada AS
SELECT V.IDEstacionEntrada AS [ID Estacion Entrada], CONVERT(DATE, V.MomentoEntrada) AS [Momento entrada] , COUNT(T.IDPasajero) AS [Numero de personas] FROM LM_Tarjetas AS T
INNER JOIN LM_Viajes AS V  ON T.ID = V.IDTarjeta
GROUP BY V.IDEstacionEntrada, CONVERT(DATE, V.MomentoEntrada)
GO

CREATE VIEW EstacionSalida AS
SELECT V.IDEstacionSalida AS [ID Estacion salida], CONVERT(DATE, V.MomentoSalida) AS [Momento salida] , COUNT(T.IDPasajero) AS [Numero de personas] FROM LM_Tarjetas AS T
INNER JOIN LM_Viajes AS V  ON T.ID = V.IDTarjeta
GROUP BY V.IDEstacionSalida, CONVERT(DATE, V.MomentoSalida)
GO

SELECT EE.[ID Estacion Entrada] AS [ID Estacion], EE.[Momento entrada] AS [Momento], EE.[Numero de personas] AS [NumPerEntran], ES.[Numero de personas] AS [NumPerSalen] FROM EstacionEntrada AS EE
INNER JOIN EstacionSalida AS ES  ON EE.[ID Estacion Entrada] = ES.[ID Estacion salida] AND EE.[Momento entrada] = ES.[Momento salida]



--Ejercicio 6 
--Calcula la media de kilómetros al día que hace cada tren. Considera únicamente los días que ha estado en servicio 

SELECT * FROM LM_Itinerarios
SELECT * FROM LM_Lineas
SELECT * FROM LM_Recorridos

--Primero: recorrido total de cada tren al dia
--Segundo: media que realiza al dia y dias que ha estado en servicio

GO
CREATE VIEW DistanciaTotal AS 
SELECT R.Tren, COUNT(I.Distancia) AS [Recorrido total], CONVERT(DATE, R.Momento) AS Dia FROM LM_Itinerarios AS I 
INNER JOIN LM_Lineas AS L  ON I.Linea = L.ID
INNER JOIN LM_Recorridos AS R  ON L.ID = R.Linea
GROUP BY R.Tren, CONVERT(DATE, R.Momento)
GO

SELECT DT.Tren, AVG(DT.[Recorrido total]) AS Media FROM DistanciaTotal AS DT
GROUP BY DT.Tren


--Ejercicio 7 
--Calcula cuál ha sido el intervalo de tiempo en que más personas registradas han estado en el metro al mismo tiempo. Considera intervalos de una hora (de 12:00 a 12:59, de 13:00 a 13:59, etc). Si hay varios momentos con el número máximo de personas, muestra el más reciente.




--Ejercicio 8 
--Calcula el dinero gastado por cada usuario en el mes de febrero de 2017. El precio de un viaje es el de la zona más cara que incluya. Incluye a los que no han viajado.

SELECT * FROM LM_Viajes
SELECT * FROM LM_Tarjetas
SELECT * FROM LM_Pasajeros


SELECT P.ID, P.Nombre, P.Apellidos, SUM(V.Importe_Viaje) AS [Total gastado] FROM LM_Viajes AS V
INNER JOIN LM_Tarjetas AS T  ON V.IDTarjeta = T.ID
LEFT JOIN LM_Pasajeros AS P  ON T.IDPasajero = P.ID
WHERE YEAR(V.MomentoEntrada) = 2017 AND MONTH(V.MomentoEntrada) = 2
GROUP BY P.ID, P.Nombre, P.Apellidos

--CON FUNCION INLINE
GO
BEGIN TRANSACTION
GO
CREATE FUNCTION MomentoViaje (@Anio AS SmallInt, @Mes AS SmallInt) RETURNS TABLE AS
RETURN
(SELECT P.ID, P.Nombre, P.Apellidos, SUM(V.Importe_Viaje) AS [Total gastado] FROM LM_Viajes AS V
INNER JOIN LM_Tarjetas AS T  ON V.IDTarjeta = T.ID
LEFT JOIN LM_Pasajeros AS P  ON T.IDPasajero = P.ID
WHERE YEAR(V.MomentoEntrada) = @Anio AND MONTH(V.MomentoEntrada) = @Mes
GROUP BY P.ID, P.Nombre, P.Apellidos)
GO

declare @Anio SmallInt set @Anio = 2017
declare @Mes SmallInt set @Mes = 2

SELECT * FROM [MomentoViaje](@Anio,@Mes)

ROLLBACK

--Ejercicio 9 
--Calcula el tiempo medio diario que cada pasajero pasa en el sistema de metro y el número de veces que accede al mismo.





