

USE Parlamento
GO

--Consulta 1 (2 points)
-- Queremos saber cu�l es el voto m�s habitual de cada diputada, afirmativo, negativo o abstenci�n. Cuenta tanto los votos a leyes como a enmiendas.

SELECT * FROM Diputadas
SELECT * FROM VotacionEnmienda
SELECT * FROM VotacionLey

BEGIN TRANSACTION

--VOTACION DE CADA DIPUTADA ENMIENDA
GO
CREATE VIEW [VEnmienda] AS
SELECT IDDiputada, Voto, COUNT(IDEnmienda) AS [N� Votos Enmienda] FROM VotacionEnmienda
GROUP BY IDDiputada, Voto
GO

--VOTACION DE CADA DIPUTADA LEY
GO
CREATE VIEW [VLey] AS
SELECT IDDiputada, Voto, COUNT(IDLey) AS [N� Votos Ley] FROM VotacionLey
GROUP BY IDDiputada, Voto
GO

--SUMAR LOS VOTOS DE LEYES Y ENMIENDAS
GO
CREATE VIEW [Votos L+E] AS
SELECT ISNULL(VE.IDDiputada, VL.IDDiputada) as [IDDiputada], ISNULL(VE.Voto,VL.Voto) AS [Voto] , ISNULL(VE.[N� Votos Enmienda],0) + ISNULL(VL.[N� Votos Ley],0) AS [Total Votos L+E] FROM VEnmienda AS VE
FULL JOIN VLey AS VL ON VL.IDDiputada = VE.IDDiputada AND VE.Voto = VL.Voto

GO

--RELACIONAR EL VOTO M�S HABITUAL CON TOTAL VOTOS L+E  
SELECT * FROM Diputadas 

SELECT D.ID, D.Nombre, D.Apellidos, VLE.Voto, MVLE.[Votaci�n habitual] FROM Diputadas AS D
INNER JOIN [Votos L+E] AS VLE  ON D.ID = VLE.IDDiputada
INNER JOIN(

	--COGER DE CADA DIPUTADA, EL VOTO M�S HABITUAL 
	SELECT VLE.IDDiputada, MAX(VLE.[Total Votos L+E]) AS [Votaci�n habitual] FROM  [Votos L+E] AS VLE  
	GROUP BY VLE.IDDiputada

	) AS MVLE ON D.ID = MVLE.IDDiputada AND VLE.[Total Votos L+E] = MVLE.[Votaci�n habitual]

ORDER BY D.ID



--Consulta 2 (2 points)
-- Queremos una funci�n inline a la que pasemos el ID de una diputada y nos devuelva una lista de todas las diputadas que hayan coincidido con ella en alguna comisi�n siendo 
-- las dos miembros de grupos diferentes. Los datos que nos interesan son ID, nombre, apellidos, legislatura en que coincidieron y nombre de la comisi�n.





--Consulta 3 (3 points)
-- Los grupos parlamentarios castigan a las diputadas que votan diferente de lo que indica el grupo. Queremos una funci�n inline a la que se pase el ID de un grupo
-- y nos devuelva nombre y apellidos de las diputadas que se han saltado las �rdenes de voto y han votado diferente de lo que indicaba el grupo, as� como el n�mero de veces que lo han hecho.
-- Para saber cu�l era la orden del grupo, miraremos qu� han votado la mayor�a de sus componentes.





--Consulta 4 (3 points)
-- Queremos saber el aumento o disminuci�n de diputadas que han experimentado los grupos parlamentarios entre la tercera y la cuarta legislatura. 
-- Un grupo se considera continuaci�n de otro si est� formado por exactamente los mismos partidos.
-- Ten en cuenta que pueden haberse producido sustituciones a lo largo de la legislatura por lo que para contar el n�mero de diputadas de cada grupo debes tomar como
-- referencia una fecha arbitraria a mediados de legislatura.


