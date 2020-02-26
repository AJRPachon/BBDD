--A los efectos de las consultas, se considera "monitor” a cualquier miembro que haya impartido algún curso en la escuela.
--Consultas y actualizaciones

USE LeoSailing
GO

--Ejercicio 1
--Queremos saber nombre, apellidos y edad de cada miembro y el número de regatas que ha disputado en barcos de cada clase.

SELECT * FROM EV_Miembros
SELECT * FROM EV_Miembros_Barcos_Regatas
SELECT * FROM EV_Regatas
SELECT * FROM EV_Barcos


SELECT M.nombre, M.apellidos, DATEDIFF(YEAR, M.f_nacimiento, CURRENT_TIMESTAMP  ) AS [Edad], COUNT(R.f_inicio) AS [Regatas realizadas], B.nombre_clase FROM EV_Miembros AS M
INNER JOIN EV_Miembros_Barcos_Regatas AS MBR  ON M.licencia_federativa = MBR.licencia_miembro
INNER JOIN EV_Regatas AS R  ON MBR.f_inicio_regata = R.f_inicio
INNER JOIN EV_Barcos AS B ON MBR.n_vela = B.n_vela
GROUP BY M.nombre, M.apellidos, M.f_nacimiento, B.nombre_clase



--Ejercicio 2
--Miembros que tengan más de 250 horas de cursos y que nunca hayan disputado una regata compartiendo barco con Esteban Dido.

SELECT * FROM EV_Cursos
SELECT * FROM EV_Miembros_Cursos
SELECT * FROM EV_Miembros
SELECT * FROM EV_Miembros_Barcos_Regatas


SELECT M.licencia_federativa, M.nombre, M.apellidos, SUM(C.duracion) AS [Horas totales] FROM EV_Cursos AS C
INNER JOIN EV_Miembros_Cursos AS MC  ON C.codigo_curso = MC.codigo_curso
INNER JOIN EV_Miembros AS M  ON MC.licencia_federativa = M.licencia_federativa
WHERE M.licencia_federativa NOT IN (

	SELECT DISTINCT MBR2.licencia_miembro FROM EV_Miembros AS M
	INNER JOIN EV_Miembros_Barcos_Regatas AS MBR  ON M.licencia_federativa = MBR.licencia_miembro
	INNER JOIN EV_Miembros_Barcos_Regatas AS MBR2  ON MBR.n_vela = MBR2.n_vela AND MBR.f_inicio_regata = MBR2.f_inicio_regata
	INNER JOIN EV_Miembros AS M2 ON MBR2.licencia_miembro = M2.licencia_federativa
	WHERE M.nombre = 'Esteban' AND M.apellidos = 'Dido' AND (M2.nombre <> 'Esteban' OR M2.apellidos <> 'Dido')

	)

GROUP BY M.licencia_federativa, M.nombre, M.apellidos
HAVING SUM(C.duracion) > 250

--	Miembros, MBR, MBR Reflexiva para saber qué persona ha ido en el mismo barco (nº vela)
--	Where de la consulta principal, where licencia federativa NOT INT (Consulta reflexiva Where Esteban Dido)
--  (M2.nombre <> 'Esteban' OR M2.apellidos <> 'Dido') Porque esteban no comparte barco consigo mismo
--	INNER JOIN EV_Miembros AS M2 ON MBR2.licencia_miembro = M2.licencia_federativa




--Ejercicio 3
--Crea una vista VTrabajoMonitores que contenga número de licencia, nombre y apellidos de cada monitor, número de cursos y número total de horas que ha
-- impartido, así como el número total de alumnos que han participado en sus cursos. A la hora de contar los asistentes, se contaran participaciones,
-- no personas. 
-- Es decir, si un mismo miembro ha asistido a tres cursos distintos, se contará como tres, no como uno. Deben incluirse los monitores a cuyos 
-- cursos no haya asistido nadie, para echarles una buena bronca.

SELECT * FROM EV_Monitores
SELECT * FROM EV_Miembros
SELECT * FROM EV_Miembros_Cursos
SELECT * FROM EV_Cursos

GO
CREATE VIEW VTrabajoMonitores AS
SELECT MI.licencia_federativa, MI.nombre, MI.apellidos, SC.[Nº Cursos], SC.[Nº horas], SC.[Nº Personas] FROM(

	SELECT MO.licencia_federativa, COUNT(DISTINCT C.codigo_curso) AS [Nº Cursos], COUNT(MI.licencia_federativa) AS [Nº Personas], NH.[Nº horas] FROM EV_Miembros AS MI
	INNER JOIN EV_Miembros_Cursos AS MC	ON MI.licencia_federativa = MC.licencia_federativa
	INNER JOIN EV_Cursos AS C ON MC.codigo_curso = C.codigo_curso
	RIGHT JOIN EV_Monitores AS MO ON C.licencia = MO.licencia_federativa
	INNER JOIN (

		SELECT MO.licencia_federativa, SUM(C.duracion) AS [Nº horas] FROM EV_Monitores AS MO --Primero obtengo 
		LEFT JOIN EV_Cursos AS C  ON MO.licencia_federativa = C.licencia
		GROUP BY MO.licencia_federativa
	
		) AS NH  ON MO.licencia_federativa = NH.licencia_federativa
		GROUP BY MO.licencia_federativa, NH.[Nº horas]

	) AS SC

INNER JOIN EV_Miembros AS MI ON MI.licencia_federativa = SC.licencia_federativa
ORDER BY MI.licencia_federativa
GO



--Ejercicio 4
-- Número de horas de cursos acumuladas por cada miembro que no haya disputado una regata en la clase 470 en los dos últimos años (2013 y 2014). 
-- Se contarán únicamente las regatas que se hayan disputado en un campo de regatas situado en longitud Oeste (W). 
-- Se sabe que la longitud es W porque el número es negativo.

SELECT * FROM EV_Miembros
SELECT * FROM EV_Miembros_Cursos
SELECT * FROM EV_Cursos
SELECT * FROM EV_Miembros_Barcos_Regatas
SELECT * FROM EV_Regatas
SELECT * FROM EV_Campo_Regatas
SELECT * FROM EV_Barcos

SELECT DISTINCT MI.licencia_federativa, SUM(C.duracion) AS [Numero de horas] FROM EV_Miembros AS MI
INNER JOIN EV_Miembros_Cursos AS MC ON MI.licencia_federativa = MC.licencia_federativa
INNER JOIN EV_Cursos AS C ON MC.codigo_curso = C.codigo_curso
WHERE MI.licencia_federativa NOT IN
	(
	SELECT DISTINCT MI.licencia_federativa FROM EV_Miembros AS MI
	INNER JOIN EV_Miembros_Barcos_Regatas AS MBR ON MI.licencia_federativa = MBR.licencia_miembro
	INNER JOIN EV_Barcos AS B  ON MBR.n_vela = B.n_vela
	INNER JOIN EV_Regatas AS R ON MBR.f_inicio_regata = R.f_inicio
	INNER JOIN EV_Campo_Regatas AS CR ON R.nombre_campo = CR.nombre_campo
	WHERE B.nombre_clase = '470' AND CR.longitud_llegada < 0 AND YEAR(MBR.f_inicio_regata) IN (2013 ,2014)
	) 

GROUP BY MI.licencia_federativa



--Ejercicio 5
-- El comité de competiciones está preocupado por el bajo rendimiento de los regatistas en las clases Tornado y 49er, así que decide organizar
-- unos cursos para repasar las técnicas más importantes. Los cursos se titulan "Perfeccionamiento Tornado” y "Perfeccionamiento 49er”, 
-- ambos de 120 horas de duración. Comezarán los días 21 de marzo y 10 de abril, respectivamente. 
-- El primero será impartido por Salud Itos y el segundo por Fernando Minguero.
-- Escribe un INSERT-SELECT para matricular en estos cursos a todos los miembros que hayan participado en regatas en alguna de estas clases 
-- desde el 1 de Abril de 2014, cuidando de que los propios monitores no pueden ser también alumnos.

BEGIN TRANSACTION 
GO --FUNCIÓN PARA SABER EL NUMERO DE LICENCIA DE CUALQUIER MONITOR
CREATE FUNCTION SaberLicencia (@nombre AS varchar(20), @apellido AS varchar(30) ) RETURNS TABLE AS
RETURN
SELECT MO.licencia_federativa FROM EV_Miembros AS M
INNER JOIN EV_Monitores AS MO  ON M.licencia_federativa = MO.licencia_federativa
WHERE M.nombre = @nombre AND M.apellidos = @apellido

GO
ROLLBACK
--COMMIT

SELECT * FROM SaberLicencia ('Salud', 'Itos')
SELECT * FROM SaberLicencia ('Fernando','Minguero')


BEGIN TRANSACTION
SELECT * FROM EV_Cursos

INSERT INTO EV_Cursos --PARA INSERTAR LOS DOS NUEVOS CURSOS
VALUES  (13, 'Perfect Tornado', '2020-03-21', 120, (SELECT * FROM SaberLicencia ('Salud', 'Itos'))),
		(14, 'Perfect 49er', '2020-04-10', 120, (SELECT * FROM SaberLicencia ('Fernando','Minguero')))

ROLLBACK
--COMMIT

-- Escribe un INSERT-SELECT para matricular en estos cursos a todos los miembros que hayan participado en regatas en alguna de estas clases 
-- desde el 1 de Abril de 2014, cuidando de que los propios monitores no pueden ser también alumnos.
GO
CREATE VIEW LicenciaClases AS
SELECT DISTINCT M.licencia_federativa FROM EV_Miembros AS M
INNER JOIN EV_Miembros_Barcos_Regatas AS MBR  ON M.licencia_federativa = MBR.licencia_miembro
INNER JOIN EV_Barcos AS B  ON MBR.n_vela = B.n_vela
WHERE (B.nombre_clase = 'Tornado' OR B.nombre_clase = '49er') AND MBR.f_inicio_regata > '2014-04-01'
GO







