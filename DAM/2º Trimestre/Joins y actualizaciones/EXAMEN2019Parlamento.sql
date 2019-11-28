--Un Parlamento es un órgano colegiado que se encarga fundamentalmente de elaborar y aprobar leyes y normas.
--Las miembros del parlamento son las diputadas, que son elegidas por las ciudadanas. Representan a una circunscripción electoral. 
--Cada uno de los periodos(legislaturas) en que son miembros del Parlamento se denomina mandato.
--La misión principal del Parlamento es elaborar leyes. Un proyecto de ley es presentada por una diputada y se pasa a una de las comisiones 
--temáticas para ser revisada. Una vez la comisión aprueba seguir adelante con el trámite, los grupos parlamentarios presentan enmiendas, 
--que deben ser votadas por las diputadas para aceptarlas o rechazarlas. Finalmente, se vota la ley y se aprueba o se rechaza.


--Consulta 1 (2 points) Queremos saber cuál es el voto más habitual de cada diputada, afirmativo, negativo o abstención. 
--	Cuenta tanto los votos a leyes como a enmiendas.

SELECT * FROM Diputadas
SELECT * FROM VotacionLey
SELECT * FROM VotacionEnmienda

--CONTAR VOTOS LEYES
GO
CREATE VIEW [ContarVotosLeyes] AS
SELECT D.ID, COUNT(VL.Voto) AS VotoLey, VL.Voto
FROM Diputadas as D
	INNER JOIN VotacionLey AS VL  ON D.ID = VL.IDDiputada
GROUP BY D.ID, VL.Voto
ORDER BY ID
GO

--CONTAR VOTOS ENMIENDA
GO
CREATE VIEW [ContarVotosEnmiendas] AS
SELECT D.ID, COUNT(VE.Voto) AS VotoEnmienda, VE.Voto
FROM Diputadas AS D
	INNER JOIN VotacionEnmienda AS VE  ON D.ID = VE.IDDiputada
GROUP BY D.ID, VE.Voto
GO



--Consulta 2 (2 points) Queremos una función inline a la que pasemos el ID de una diputada y nos devuelva una lista de todas las 
--	diputadas que hayan coincidido con ella en alguna comisión siendo las dos miembros de grupos diferentes.
--	Los datos que nos interesan son ID, nombre, apellidos, legislatura en que coincidieron y nombre de la comisión.






--Consulta 3 (3 points)Los grupos parlamentarios castigan a las diputadas que votan diferente de lo que indica el grupo.
--	Queremos una función inline a la que se pase el ID de un grupo y nos devuelva nombre y apellidos de las diputadas que se han 
--	saltado las órdenes de voto y han votado diferente de lo que indicaba el grupo, así como el número de veces que lo han hecho.
--	Para saber cuál era la orden del grupo, miraremos qué han votado la mayoría de sus componentes.





--Consulta 5 (3 points) Queremos saber el aumento o disminución de diputadas que han experimentado los grupos parlamentarios entre la tercera y
--	la cuarta legislatura.Un grupo se considera continuación de otro si está formado por exactamente los mismos partidos.
--	Ten en cuenta que pueden haberse producido sustituciones a lo largo de la legislatura por lo que para contar el número de 
--	diputadas de cada grupo debes tomar como referencia una fecha arbitraria a mediados de legislatura.