--Ejercicio 1 - Indica el n�mero de estaciones por las que pasa cada l�nea

SELECT * FROM LM_Estaciones
SELECT * FROM LM_Itinerarios
SELECT * FROM LM_Lineas

SELECT Linea ,COUNT(NumOrden) AS [Numero de estaciones]
FROM LM_Itinerarios
GROUP BY Linea


--Ejercicio 2 - Indica el n�mero de trenes diferentes que han circulado en cada l�nea

SELECT * FROM LM_Trenes
SELECT * FROM LM_Recorridos

SELECT COUNT(DISTINCT T.ID) AS [Numero de trenes], R.Linea
FROM LM_Trenes AS T
	
	INNER JOIN LM_Recorridos AS R  ON T.ID = R.Tren

GROUP BY R.Linea

--Ejercicio 3 - Indica el n�mero medio de trenes de cada clase que pasan al d�a por cada estaci�n. 

SELECT * FROM LM_Trenes
SELECT * FROM LM_Recorridos
SELECT * FROM LM_Estaciones

SELECT E.Denominacion,T.Tipo,TrenesPorEstacion.ID, AVG(TrenesPorEstacion.[Numero Trenes]) AS [Media] 
FROM LM_Estaciones AS E
	
	INNER JOIN LM_Recorridos AS R ON E.ID=R.estacion
	INNER JOIN LM_Trenes AS T ON R.Tren=T.ID
	INNER JOIN (
		SELECT E.ID,DAY(R.Momento) AS [D�a],COUNT(E.ID) AS [Numero Trenes] 
		FROM LM_Estaciones AS E

			INNER JOIN LM_Recorridos AS R ON E.ID=R.estacion
			INNER JOIN LM_Lineas AS L ON R.Linea=L.ID

		GROUP BY E.ID,DAY(R.Momento) 
	) AS TrenesPorEstacion ON E.ID=TrenesPorEstacion.ID
		
GROUP BY E.Denominacion,T.Tipo,TrenesPorEstacion.ID
ORDER BY T.Tipo	

--Ejercicio 4 - Calcula el tiempo necesario para recorrer una l�nea completa, contando con el tiempo estimado de cada itinerario y considerando que cada parada en una estaci�n dura 30 s.

--con datepart obtengo el tiempo en minutos o en segundos
--con dateadd le a�ade segundos a lo que sea (unidad de tiempo, lo que quieres a�adir, a lo que se lo vas a a�adir)

SELECT Linea, DATEADD (SECOND , SUM((((DATEPART(MINUTE,TiempoEstimado)*60)+(DATEPART(SECOND,TiempoEstimado))))+30) , CONVERT(time,'0:0') ) AS [En segundos] 
FROM LM_Itinerarios
GROUP BY Linea	--El tiempo de cada itinerario


--Ejercicio 5 - Indica el n�mero total de pasajeros que entran (a pie) cada d�a por cada estaci�n y los que salen del metro en la misma. 

/*La siguente vista sirve para calcular el numero de pasajeros que han entrado en el metro cada dia*/
GO
CREATE VIEW PersonasQueEntranAlDia AS
SELECT V.IDEstacionEntrada, YEAR(V.MomentoEntrada) AS [A�o], MONTH(V.MomentoEntrada) AS [Mes], DAY(V.MomentoEntrada) AS [D�a], COUNT(T.IDPasajero) AS [Cantidad de Personas Que Entran]
FROM LM_Viajes AS V
	
	INNER JOIN LM_Tarjetas AS T ON V.IDTarjeta=T.ID

GROUP BY V.IDEstacionEntrada, YEAR(V.MomentoEntrada), MONTH(V.MomentoEntrada), DAY(V.MomentoEntrada)
GO

/*La siguente vista sirve para calcular el numero de pasajeros que han salido del metro cada dia*/
GO
CREATE VIEW PersonasQueSalenAlDia AS
SELECT V.IDEstacionSalida, YEAR(V.MomentoSalida) AS [A�o], MONTH(V.MomentoSalida) AS [Mes], DAY(V.MomentoSalida) AS [D�a], COUNT(T.IDPasajero) AS [Cantidad de Personas que Salen] 
FROM LM_Viajes AS V

	INNER JOIN LM_Tarjetas AS T ON V.IDTarjeta=T.ID

GROUP BY V.IDEstacionSalida, YEAR(V.MomentoSalida), MONTH(V.MomentoSalida), DAY(V.MomentoSalida)
GO

/*La siguente consulta sirve para calcular el numero total de pasajeros del metro cada dia*/
SELECT PE.IDEstacionEntrada, PS.D�a, PE.[Cantidad de Personas Que Entran], PS.[Cantidad de Personas que Salen]
FROM PersonasQueEntranAlDia AS PE 

	INNER JOIN PersonasQueSalenAlDia AS PS ON PE.IDEstacionEntrada = PS.IDEstacionSalida AND PE.D�a = PS.D�a AND PE.Mes = PS.Mes AND PE.A�o = PS.A�o

ORDER BY PE.IDEstacionEntrada, PS.D�a


--Ejercicio 6 - Calcula la media de kil�metros al d�a que hace cada tren. Considera �nicamente los d�as que ha estado en servicio 

SELECT ID, A�o, Mes, D�a, AVG([KM/Dia]) [Media de kil�metros] 
FROM 
	(
		SELECT T.ID, YEAR( R.Momento) AS [A�o], MONTH( R.Momento) AS [Mes], DAY( R.Momento) AS [D�a], SUM(I.Distancia) AS [KM/Dia]
		FROM LM_Trenes AS T
			
			INNER JOIN LM_Recorridos AS R ON T.ID=R.Tren
			INNER JOIN LM_Itinerarios AS I ON R.Linea=I.Linea

		WHERE R.Momento > T.FechaEntraServicio
		GROUP BY T.ID, YEAR(R.Momento), MONTH(R.Momento), DAY(R.Momento)
	) AS RecorridoPorDia
GROUP BY ID,A�o,Mes,D�a


--Ejercicio 7 - Calcula cu�l ha sido el intervalo de tiempo en que m�s personas registradas han estado en el metro al mismo tiempo.
-- Considera intervalos de una hora (de 12:00 a 12:59, de 13:00 a 13:59, etc). Si hay varios momentos con el n�mero m�ximo de personas, muestra el m�s reciente.

SELECT E.ID, CAST(V.MomentoEntrada AS TIME) AS [Hora], COUNT(T.IDPasajero) [Cantiada de personas] 
FROM LM_Estaciones AS E

	INNER JOIN LM_Viajes AS V ON E.ID=V.IDEstacionEntrada
	INNER JOIN LM_Tarjetas AS T ON V.IDTarjeta=T.ID

GROUP BY E.ID, CAST(V.MomentoEntrada AS TIME)


--Ejercicio 8 - Calcula el dinero gastado por cada usuario en el mes de febrero de 2017. El precio de un viaje es el de la zona m�s cara que incluya. Incluye a los que no han viajado.

SELECT T.IDPasajero, SUM(V.Importe_Viaje) AS [Precio maximo]
FROM LM_Viajes AS V

	right join LM_Tarjetas AS T ON V.IDTarjeta=T.ID

WHERE MONTH(V.MomentoEntrada)=2 AND YEAR(V.MomentoEntrada)=2017
GROUP BY T.IDPasajero,V.Importe_Viaje


--Ejercicio 9 - Calcula el tiempo medio diario que cada pasajero pasa en el sistema de metro y el n�mero de veces que accede al mismo.

--el tiempo medio y las veces accedidas en un dia
SELECT TiempoMetroNumeroEntrada.IDPasajero,	DATEADD(MINUTE, AVG(TiempoMetroNumeroEntrada.[Tiempo en Metro]), CONVERT(time,'0:0')) AS [Tiempo Medio Diario],
	SUM(TiempoMetroNumeroEntrada.[Numero de Veces Entrados]) AS [Veces Accedido]
FROM
	(--el tiempo total en el metro y las veces que ha accedido en un dia
		SELECT T.IDPasajero, YEAR(V.MomentoEntrada) AS [A�o], MONTH(V.MomentoEntrada) AS [Mes], DAY(V.MomentoEntrada) AS [D�a],
				SUM(DATEDIFF(MINUTE, MomentoEntrada, MomentoSalida)) AS [Tiempo en Metro], COUNT(*) AS [Numero de Veces Entrados] 
		FROM LM_Viajes AS V
		
			INNER JOIN LM_Tarjetas AS T ON V.IDTarjeta = T.ID
		
		GROUP BY IDPasajero, YEAR(MomentoEntrada), MONTH(MomentoEntrada), DAY(MomentoEntrada)
	) AS TiempoMetroNumeroEntrada
GROUP BY TiempoMetroNumeroEntrada.IDPasajero,TiempoMetroNumeroEntrada.D�a,TiempoMetroNumeroEntrada.[Numero de Veces Entrados]
ORDER BY TiempoMetroNumeroEntrada.IDPasajero
