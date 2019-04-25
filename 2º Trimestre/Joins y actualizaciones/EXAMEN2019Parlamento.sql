--Un Parlamento es un �rgano colegiado que se encarga fundamentalmente de elaborar y aprobar leyes y normas.
--Las miembros del parlamento son las diputadas, que son elegidas por las ciudadanas. Representan a una circunscripci�n electoral. 
--Cada uno de los periodos(legislaturas) en que son miembros del Parlamento se denomina mandato.
--La misi�n principal del Parlamento es elaborar leyes. Un proyecto de ley es presentada por una diputada y se pasa a una de las comisiones 
--tem�ticas para ser revisada. Una vez la comisi�n aprueba seguir adelante con el tr�mite, los grupos parlamentarios presentan enmiendas, 
--que deben ser votadas por las diputadas para aceptarlas o rechazarlas. Finalmente, se vota la ley y se aprueba o se rechaza.


--Consulta 1 (2 points) Queremos saber cu�l es el voto m�s habitual de cada diputada, afirmativo, negativo o abstenci�n. 
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



--Consulta 2 (2 points) Queremos una funci�n inline a la que pasemos el ID de una diputada y nos devuelva una lista de todas las 
--	diputadas que hayan coincidido con ella en alguna comisi�n siendo las dos miembros de grupos diferentes.
--	Los datos que nos interesan son ID, nombre, apellidos, legislatura en que coincidieron y nombre de la comisi�n.






--Consulta 3 (3 points)Los grupos parlamentarios castigan a las diputadas que votan diferente de lo que indica el grupo.
--	Queremos una funci�n inline a la que se pase el ID de un grupo y nos devuelva nombre y apellidos de las diputadas que se han 
--	saltado las �rdenes de voto y han votado diferente de lo que indicaba el grupo, as� como el n�mero de veces que lo han hecho.
--	Para saber cu�l era la orden del grupo, miraremos qu� han votado la mayor�a de sus componentes.





--Consulta 5 (3 points) Queremos saber el aumento o disminuci�n de diputadas que han experimentado los grupos parlamentarios entre la tercera y
--	la cuarta legislatura.Un grupo se considera continuaci�n de otro si est� formado por exactamente los mismos partidos.
--	Ten en cuenta que pueden haberse producido sustituciones a lo largo de la legislatura por lo que para contar el n�mero de 
--	diputadas de cada grupo debes tomar como referencia una fecha arbitraria a mediados de legislatura.