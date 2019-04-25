--USE CasinOnLine2

--Cada apuesta tiene una serie de números (entre 1 y 24 números) asociados en la tabla COL_NumerosApuestas. La apuesta es ganadora si 
--alguno de esos números coincide con el número ganador de la jugada y perdedora en caso contrario.
--Si la apuesta es ganadora, el jugador recibe lo apostado (Importe) multiplicado por el valor de la columna Premio de 
--la tabla COL_TiposApuestas que corresponda con el tipo de la apuesta. Si la apuesta es perdedora, el jugador pierde lo que haya
--apostado (Importe)


SELECT * FROM COL_Apuestas
SELECT * FROM COL_Jugadores
SELECT * FROM COL_Mesas
SELECT * FROM COL_NumerosApuesta
SELECT * FROM COL_TiposApuesta
SELECT * FROM COL_Jugadas

--Ejercicio 1 
--Escribe una consulta que nos devuelva el número de veces que se ha apostado a cada número con apuestas de los tipos 10, 13 o 15.
--Ordena el resultado de mayor a menos popularidad.

SELECT * FROM COL_Apuestas
SELECT * FROM COL_NumerosApuesta

SELECT NA.Numero, COUNT(NA.IDJugada) AS [Numero veces apostado]
FROM COL_NumerosApuesta AS NA
		INNER JOIN COL_Apuestas AS A  ON NA.IDJugada = A.IDJugada AND NA.IDJugador = A.IDJugador AND NA.IDMesa = A.IDMesa
WHERE A.Tipo IN ('15','13','10')
GROUP BY NA.Numero
ORDER BY [Numero veces apostado] DESC



--Ejercicio 2 
--El casino quiere fomentar la participación y decide regalar saldo extra a los jugadores que hayan apostado más de tres veces en el último mes. 
--Se considera el mes de febrero.
--La cantidad que se les regalará será un 5% del total que hayan apostado en ese mes

SELECT * FROM COL_Jugadas
SELECT * FROM COL_Apuestas
SELECT * FROM COL_NumerosApuesta
SELECT * FROM COL_Jugadores

--Jugadores apostado +3 veces en Febrero
BEGIN TRANSACTION 
GO
CREATE VIEW [Más3Febrero] AS
SELECT JU.ID
FROM COL_Jugadores AS JU
	INNER JOIN COL_Apuestas AS A  ON JU.ID = A.IDJugador
	INNER JOIN COL_Jugadas AS JA  ON A.IDJugada = JA.IDJugada AND A.IDMesa = JA.IDMesa
	INNER JOIN COL_NumerosApuesta AS NA  ON JU.ID = NA.IDJugador
WHERE JA.MomentoJuega >= '2018-01-02' AND JA.MomentoJuega <= '2018-28-02'
GROUP BY JU.ID
HAVING COUNT(NA.IDJugador) > 3
GO
ROLLBACK


--Calcular total apostado de cada jugador en Febrero
BEGIN TRANSACTION
GO
CREATE VIEW [TotalApostado] AS
SELECT A.IDJugador, SUM(A.Importe) AS Dinerito, SUM((A.Importe*5)/100) AS Descuento
FROM COL_Apuestas AS A
	INNER JOIN COL_Jugadas AS JA  ON A.IDJugada = JA.IDJugada AND A.IDMesa = JA.IDMesa 
WHERE JA.MomentoJuega >= '2018-01-02' AND JA.MomentoJuega <= '2018-28-02'
GROUP BY A.IDJugador
GO
ROLLBACK


--Unir total apostado con los jugadores que han apostado más de 3 veces
BEGIN TRANSACTION
GO
CREATE VIEW [Total+Descuento] AS
SELECT JU.ID, TA.Dinerito, TA.Descuento
FROM COL_Jugadores AS JU
	INNER JOIN [Más3Febrero] AS M3F  ON JU.ID = M3F.ID
	INNER JOIN [TotalApostado] AS TA  ON JU.ID = TA.IDJugador
GROUP BY JU.ID, TA.Dinerito, TA.Descuento
GO


--Añadir el descuento al saldo de cada jugador (En saldo inicial el ID 1 Seria 1000 pero como ya hemos hecho el ejercicio sale como saldo+descuento en saldo inicial)
SELECT JU.ID, JU.Saldo AS [Saldo inicial], TD.Descuento, SUM(JU.Saldo + TD.Descuento) AS [Saldo incrementado]
FROM COL_Jugadores AS JU
	INNER JOIN [Total+Descuento] AS TD  ON JU.ID = TD.ID
GROUP BY JU.ID, JU.Saldo, TD.Descuento


--Hacer un update con el valor del saldo incrementado a la tabla jugadores
SELECT*FROM COL_Jugadores

BEGIN TRANSACTION
UPDATE COL_Jugadores
SET Saldo += TotalSaldo.Descuento
FROM (
	SELECT JU.ID, JU.Saldo AS [Saldo inicial], TD.Descuento, SUM(JU.Saldo + TD.Descuento) AS [Saldo incrementado]
	FROM COL_Jugadores AS JU
			INNER JOIN [Total+Descuento] AS TD  ON JU.ID = TD.ID
	GROUP BY JU.ID, JU.Saldo, TD.Descuento
) AS TotalSaldo
COMMIT
--ROLLBACK


--Ejercicio 3 
--El día 2 de febrero se celebró el día de la marmota. Para conmemorarlo, el casino ha decidido volver a repetir todas las 
--jugadas que se hicieron ese día, pero poniéndoles fecha de mañana (con la misma hora) y permitiendo que los jugadores apuesten. 
--El número ganador de cada jugada se pondrá a NULL y el NoVaMas a 0.
--Crea esas nuevas filas con una instrucción INSERT-SELECT





--Ejercicio 4 
--Crea una vista que nos muestre, para cada jugador, nombre, apellidos, Nick, número de apuestas realizadas, total de dinero apostado 
--y total de dinero ganado/perdido.

SELECT * FROM COL_Jugadores		
SELECT * FROM COL_Apuestas
SELECT * FROM COL_NumerosApuesta
SELECT * FROM COL_TiposApuesta
SELECT * FROM COL_Jugadas

--TOTAL DINERO APOSTADO
SELECT IDJugador, SUM(Importe) AS [Total Apostado]
FROM COL_Apuestas
GROUP BY IDJugador

--NUMERO DE APUESTAS REALIZADAS
SELECT IDJugador, COUNT(IDJugada) AS [Apuestas realizadas]
FROM COL_NumerosApuesta
GROUP BY IDJugador

--TOTAL DINERO GANADO/PERDIDO, APUESTAS REALIZADAS, TOTAL APOSTADO
GO
CREATE VIEW [TotalTodo] AS
SELECT A.IDJugador, SUM(A.Importe) AS [Total Apostado], COUNT(NA.IDJugada) AS [Apuestas realizadas]
FROM COL_Jugadas AS J
	INNER JOIN COL_Apuestas AS A  ON J.IDJugada = A.IDJugada AND J.IDMesa = A.IDMesa
	INNER JOIN COL_Jugadores AS JU  ON A.IDJugador = JU.ID
	INNER JOIN COL_NumerosApuesta AS NA  ON A.IDJugada = NA.IDJugada AND A.IDJugador = NA.IDJugador AND A.IDMesa = NA.IDMesa
GROUP BY A.IDJugador
GO


SELECT
FROM [TotalTodo] AS TT


--Ejercicio 5 
--Nos comunican que la policía ha detenido a nuestro cliente Ombligo Pato por delitos de estafa, falsedad, administración desleal y
-- mal gusto para comprar bañadores. 
--Dado que nuestro casino está en Gibraltar, siguiendo la tradición de estas tierras, queremos borrar todo rastro de su paso por nuestro casino.
--Borra todas las apuestas que haya realizado, pero no busques su ID a mano en la tabla COL_Clientes. 
--Utiliza su Nick (bankiaman) para identificarlo en la instrucción DELETE.




--Ejercicio 6 
--Crea una función a la que pasemos como parámetros una fecha de inicio y otra de fin y nos devuelva el números de jugadas,
--el total de dinero apostado y las ganancias (del casino) de cada una de las mesas en ese periodo.




--Ejercicio 7 
--El casino sospecha que algunos croupiers favorecen a ciertos jugadores. Para ello buscamos si algunos jugadores han sido especialmente 
--afortunados cuando han jugado en una mesa determinada.
--Haz una consulta que nos devuelva los nombres e IDs de los jugadores que han ganado un 30% más en una mesa en particular
--que en la media de las otras.