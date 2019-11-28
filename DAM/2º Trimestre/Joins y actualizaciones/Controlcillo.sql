--Ejercicio 1 (1,5 puntos)
--Crea una función a la que se le pase como parámetro de entrada una fecha (Date) y nos devuelva una tabla con el número de jugadas 
--realizadas en cada mesa en esa fecha, el total de dinero apostado y el número que más veces ha resultado premiado.
--La tabla del resultado tendrá cuatro columnas: ID de la mesa, número de jugadas, dinero apostado y número premiado más veces.

SELECT * FROM COL_NumerosApuesta
SELECT * FROM COL_Apuestas
SELECT * FROM COL_Jugadas


--TOTAL JUGADAS Y TOTAL APOSTADO
BEGIN TRANSACTION
GO
CREATE VIEW [TotalJA] AS
SELECT NA.IDMesa, COUNT(NA.IDJugada) AS [Total jugadas], SUM(A.Importe) AS [Total apostado], CAST(J.MomentoJuega AS DATE) AS Fecha
FROM COL_NumerosApuesta AS NA
	INNER JOIN COL_Apuestas AS A  ON NA.IDJugada = A.IDJugada AND NA.IDJugador = A.IDJugador AND NA.IDMesa = A.IDMesa
	INNER JOIN COL_Jugadas AS J ON NA.IDJugada = J.IDJugada AND NA.IDMesa = J.IDMesa
GROUP BY NA.IDMesa, J.MomentoJuega
GO


--VECES NUMEROS PREMIADOS DE CADA MESA
GO
CREATE VIEW [Numero apostado] AS
SELECT Numero, IDMesa, SUM(IDJugada) AS [Numero mas apostado]
FROM COL_Jugadas
GROUP BY IDMesa, Numero
GO
--MÁXIMO 
GO
CREATE VIEW [NumeroMasPremiado] AS
SELECT NUA.IDMesa, MAX(NUA.[Numero mas apostado]) AS [+Premiado]
FROM [Numero apostado] AS NUA
GROUP BY NUA.IDMesa
GO

--UNIR TODOS LOS DATOS (Me he equivocado, no he puesto -cual- es el numero más premiado)
SELECT TJA.IDMesa, SUM(TJA.[Total jugadas]) AS [Numero Jugadas], MAX(TJA.[Total apostado]) AS [Dinero Apostado], MAX(NMP.[+Premiado]) AS [Premiado a tope]
FROM TotalJA AS TJA
	INNER JOIN NumeroMasPremiado AS NMP  ON TJA.IDMesa = NMP.IDMesa
GROUP BY TJA.IDMesa

--CREAR FUNCION CON LA FECHA
GO
CREATE FUNCTION Fecha (@fecha AS DATE) 
RETURNS TABLE AS
RETURN 
(
SELECT TJA.IDMesa, TJA.[Total jugadas], TJA.[Total apostado], NMP.[+Premiado], TJA.Fecha
FROM TotalJA AS TJA
	INNER JOIN NumeroMasPremiado AS NMP  ON TJA.IDMesa = NMP.IDMesa
	WHERE TJA.Fecha = @fecha
GROUP BY TJA.IDMesa, TJA.[Total jugadas], TJA.[Total apostado], NMP.[+Premiado], TJA.Fecha
)
GO


--Ejercicio 2 (1,5 puntos)
--Crea una función que reciba como parámetros de entrada el ID de una jugada, ID de una mesa y el ID de un jugador y 
--nos devuelva una tabla con los nombres, apellidos y nicks de los jugadores que hayan apostado a alguno de los números a los 
--que ha apostado el jugador enviado como parámetro en esa misma jugada y mesa.
--La tabla del resultado tendrá cuatro columnas: ID del jugador, Nombre, apellidos y nick.

SELECT * FROM COL_Jugadores
SELECT * FROM COL_Apuestas
SELECT * FROM COL_NumerosApuesta

--ID MESA, ID JUGADA Y NUMERO A LOS QUE HAN APOSTADO LOS JUGADORES
SELECT A.IDJugada, NA.IDMesa, J.ID, NA.Numero, J.Nombre, J.Apellidos, J.Nick
FROM COL_Jugadores AS J
	INNER JOIN COL_Apuestas AS A  ON J.ID = A.IDJugador
	INNER JOIN COL_NumerosApuesta AS NA  ON A.IDJugada = NA.IDJugada AND A.IDJugador = NA.IDJugador AND A.IDMesa = NA.IDMesa
GROUP BY J.ID, J.Nombre, J.Apellidos, J.Nick, NA.Numero, NA.IDMesa, A.IDJugada
ORDER BY J.ID, A.IDJugada, NA.IDMesa

--CREAR LA FUNCION PARA QUE IDMESA AND IDJUGADA = IDMESA AND IDJUGADA DE LA FUNCIÓN PARA QUE NOS DEVUELVA LOS DATOS DE LOS JUGADORES QUE APOSTARON
-- A ALGUNOS DE LOS NUMEROS DEL JUGADOR INTRODUCIDO POR PARAMETROS.

CREATE FUNCTION 