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
--INNER JOIN EV_Miembros_Barcos_Regatas AS MBR  ON M.licencia_federativa = MBR.licencia_miembro ??
GROUP BY M.licencia_federativa, M.nombre, M.apellidos
HAVING SUM(C.duracion) > 250

EXCEPT

SELECT M.licencia_federativa, M.nombre, M.apellidos, SUM(C.duracion) AS [Horas totales] FROM EV_Cursos AS C
INNER JOIN EV_Miembros_Cursos AS MC  ON C.codigo_curso = MC.codigo_curso
INNER JOIN EV_Miembros AS M  ON MC.licencia_federativa = M.licencia_federativa
--INNER JOIN EV_Miembros_Barcos_Regatas AS MBR  ON M.licencia_federativa = MBR.licencia_miembro
WHERE M.licencia_federativa = 200
GROUP BY M.licencia_federativa, M.nombre, M.apellidos

--PREGUNTAR A LEO



--Ejercicio 3
--Crea una vista VTrabajoMonitores que contenga número de licencia, nombre y apellidos de cada monitor, número de cursos y número total de horas que ha impartido,
-- así como el número total de alumnos que han participado en sus cursos. A la hora de contar los asistentes, se contaran participaciones, no personas. 
-- Es decir, si un mismo miembro ha asistido a tres cursos distintos, se contará como tres, no como uno. Deben incluirse los monitores a cuyos cursos no haya asistido nadie, 
-- para echarles una buena bronca.

SELECT * FROM EV_Monitores
SELECT * FROM EV_Miembros
SELECT * FROM EV_Miembros_Cursos
SELECT * FROM EV_Cursos

SELECT M.licencia_federativa, COUNT(MI.licencia_federativa) AS [Numero alumnos], MI.nombre, MI.apellidos, COUNT(C.codigo_curso) AS [Numero cursos impartidos], C.denominacion, SUM(C.duracion) AS [Total horas impartidas] FROM EV_Monitores AS M
INNER JOIN EV_Miembros AS MI  ON M.licencia_federativa = MI.licencia_federativa
INNER JOIN EV_Miembros_Cursos AS MC  ON MI.licencia_federativa = MC.licencia_federativa
INNER JOIN EV_Cursos AS C  ON MC.codigo_curso = C.codigo_curso
GROUP BY M.licencia_federativa, MI.nombre, MI.apellidos, C.denominacion

--Ver

--Ejercicio 4
-- Número de horas de cursos acumuladas por cada miembro que no haya disputado una regata en la clase 470 en los dos últimos años (2013 y 2014). 
-- Se contarán únicamente las regatas que se hayan disputado en un campo de regatas situado en longitud Oeste (W). 
-- Se sabe que la longitud es W porque el número es negativo.

SELECT * FROM EV_Monitores
SELECT * FROM EV_Regatas
SELECT * FROM EV_Campo_Regatas


--Ejercicio 5
-- El comité de competiciones está preocupado por el bajo rendimiento de los regatistas en las clases Tornado y 49er, así que decide organizar
-- unos cursos para repasar las técnicas más importantes. Los cursos se titulan "Perfeccionamiento Tornado” y "Perfeccionamiento 49er”, 
-- ambos de 120 horas de duración. Comezarán los días 21 de marzo y 10 de abril, respectivamente. 
-- El primero será impartido por Salud Itos y el segundo por Fernando Minguero.
-- Escribe un INSERT-SELECT para matricular en estos cursos a todos los miembros que hayan participado en regatas en alguna de estas clases 
-- desde el 1 de Abril de 2014, cuidando de que los propios monitores no pueden ser también alumnos.



