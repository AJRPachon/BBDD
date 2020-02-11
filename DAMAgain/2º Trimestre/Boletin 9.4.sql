
--BASE DE DATOS BICHOS

USE Bichos
GO

--1.Número de mascotas que han sufrido cada enfermedad. 

	SELECT * FROM BI_Mascotas
	SELECT * FROM BI_Mascotas_Enfermedades
	SELECT * FROM BI_Enfermedades

	SELECT DISTINCT M.Codigo, COUNT(ME.IDEnfermedad) AS [Numero de mascotas] FROM BI_Mascotas AS M
		INNER JOIN BI_Mascotas_Enfermedades AS ME ON M.Codigo = ME.Mascota
		INNER JOIN BI_Enfermedades AS E  ON ME.IDEnfermedad = E.ID
	GROUP BY M.Codigo



--2.Número de mascotas que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna mascota.

	SELECT * FROM BI_Mascotas
	SELECT * FROM BI_Mascotas_Enfermedades
	SELECT * FROM BI_Enfermedades

	SELECT DISTINCT M.Codigo, E.Nombre, COUNT(ME.IDEnfermedad) AS [Numero de mascotas] FROM BI_Mascotas AS M
		INNER JOIN BI_Mascotas_Enfermedades AS ME ON M.Codigo = ME.Mascota
		RIGHT JOIN BI_Enfermedades AS E  ON ME.IDEnfermedad = E.ID
	GROUP BY M.Codigo, E.Nombre 


--3.Número de mascotas de cada cliente. Incluye nombre completo y dirección del cliente.

	SELECT * FROM BI_Mascotas
	SELECT * FROM BI_Clientes

	SELECT C.Nombre, COUNT(M.Codigo) AS [Numero de mascotas], C.Direccion FROM BI_Clientes AS C
		INNER JOIN BI_Mascotas AS M  ON C.Codigo = M.CodigoPropietario
	GROUP BY C.Nombre, C.Direccion


--4.Número de mascotas de cada especie de cada cliente. Incluye nombre completo y dirección del cliente.

	SELECT * FROM BI_Mascotas
	SELECT * FROM BI_Clientes

	SELECT C.Codigo, C.Nombre, C.Direccion, M.Especie, COUNT(M.Especie) AS [Numero de mascotas] FROM BI_Mascotas AS M
		INNER JOIN BI_Clientes AS C  ON M.CodigoPropietario = C.Codigo
	GROUP BY C.Codigo, C.Nombre, C.Direccion, M.Especie
	ORDER BY C.Codigo


--5.Número de mascotas de cada especie que han sufrido cada enfermedad.

	SELECT * FROM BI_Enfermedades
	SELECT * FROM BI_Mascotas_Enfermedades
	SELECT * FROM BI_Mascotas

	SELECT M.Especie, E.Nombre, COUNT(M.Codigo) AS [Numero de mascotas] FROM BI_Enfermedades AS E
		INNER JOIN BI_Mascotas_Enfermedades AS ME ON E.ID = ME.IDEnfermedad
		INNER JOIN BI_Mascotas AS M ON  ME.Mascota = M.Codigo
	GROUP BY M.Especie, E.Nombre
	ORDER BY M.Especie, E.Nombre


--6.Número de mascotas de cada especie que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna mascota de alguna especie.

	SELECT * FROM BI_Enfermedades
	SELECT * FROM BI_Mascotas_Enfermedades
	SELECT * FROM BI_Mascotas

	SELECT M.Especie, E.Nombre, COUNT(M.Codigo) AS [Numero de mascotas] FROM BI_Enfermedades AS E
		LEFT JOIN BI_Mascotas_Enfermedades AS ME ON E.ID = ME.IDEnfermedad
		LEFT JOIN BI_Mascotas AS M ON  ME.Mascota = M.Codigo
	GROUP BY M.Especie, E.Nombre
	ORDER BY M.Especie, E.Nombre

	--Preguntar a Leo

--7.Queremos saber cuál es la enfermedad más común en cada especie. Incluye cuantos casos se han producido.

	SELECT * FROM BI_Enfermedades
	SELECT * FROM BI_Mascotas_Enfermedades
	SELECT * FROM BI_Mascotas
	
	SELECT MEF.Especie, COUNT(E.ID) AS [Más común], E.Nombre FROM BI_Mascotas AS M
	INNER JOIN BI_Mascotas_Enfermedades AS ME  ON M.Codigo = ME.Mascota
	INNER JOIN BI_Enfermedades AS E  ON ME.IDEnfermedad = E.ID
	INNER JOIN(  

		SELECT [Enfermedades totales].Especie,MAX([Enfermedades totales].[Numero de enferfemades por especie]) AS [MAXEnfEspecie] FROM (

			SELECT M.Especie, E.Nombre, COUNT(E.ID) AS [Numero de enferfemades por especie] FROM BI_Mascotas AS M
			INNER JOIN BI_Mascotas_Enfermedades AS ME  ON M.Codigo = ME.Mascota
			INNER JOIN BI_Enfermedades AS E  ON ME.IDEnfermedad = E.ID
			GROUP BY M.Especie, E.Nombre

		) AS [Enfermedades totales]
		GROUP BY [Enfermedades totales].Especie

	) AS MEF ON MEF.Especie = M.Especie
	GROUP BY MEF.Especie, MEF.MAXEnfEspecie, E.Nombre
	HAVING COUNT(E.ID) = MEF.MAXEnfEspecie
	
	 

--8.Duración media, en días, de cada enfermedad, desde que se detecta hasta que se cura. Incluye solo los casos en que el animal 
--se haya curado. Se entiende que una mascota se ha curado si tiene fecha de curación y está viva o su fecha de fallecimiento
--Es posterior a la fecha de curación.

	SELECT * FROM BI_Enfermedades
	SELECT * FROM BI_Mascotas_Enfermedades
	SELECT * FROM BI_Mascotas
 
	
	SELECT DT.Nombre, AVG(DT.[Dias transcurridos])AS [Media dias transcurridos] 
	FROM (
			SELECT E.Nombre, DATEDIFF(DAY,ME.FechaInicio, ME.FechaCura) AS [Dias transcurridos] FROM BI_Mascotas_Enfermedades AS ME
			INNER JOIN BI_Enfermedades AS E ON ME.IDEnfermedad = E.ID

		) AS DT --Dias transcurridos
	INNER JOIN BI_Enfermedades AS E  ON DT.Nombre = E.Nombre
	INNER JOIN BI_Mascotas_Enfermedades AS ME  ON E.ID = ME.IDEnfermedad
	INNER JOIN BI_Mascotas AS M  ON ME.Mascota = M.Codigo

	WHERE ME.FechaCura IS NOT NULL AND M.FechaFallecimiento IS NULL OR ME.FechaCura < M.FechaFallecimiento
	GROUP BY DT.Nombre, M.FechaFallecimiento, ME.FechaCura
	


--9.Número de veces que ha acudido a consulta cada cliente con alguna de sus mascotas. Incluye nombre y apellidos del cliente.

	SELECT * FROM BI_Visitas
	SELECT * FROM BI_Mascotas
	SELECT * FROM BI_Clientes

	SELECT C.Nombre, COUNT(V.IDVisita) AS [Numero visitas] FROM BI_Clientes AS C
	INNER JOIN BI_Mascotas AS M  ON C.Codigo = M.CodigoPropietario
	INNER JOIN BI_Visitas AS V  ON M.Codigo = V.Mascota
	GROUP BY C.Nombre


--10.Número de visitas a las que ha acudido cada mascota, fecha de su primera y de su última visita

	SELECT * FROM BI_Visitas
	SELECT * FROM BI_Mascotas

	SELECT M.Alias, COUNT(V.IDVisita) AS [Numero visitas], MIN(V.Fecha) AS [Primera fecha], MAX(V.Fecha) AS [Ultima fecha] FROM BI_Mascotas AS M
	INNER JOIN BI_Visitas AS V  ON M.Codigo = V.Mascota
	GROUP BY M.Alias

--11.Incremento (o disminución) de peso que ha experimentado cada mascota entre cada dos consultas sucesivas. 
--Incluye nombre de la mascota, especie, fecha de las dos consultas sucesivas e incremento o disminución de peso.

	SELECT * FROM BI_Mascotas
	SELECT * FROM BI_Visitas

	SELECT DISTINCT M.Alias, M.Especie, (FechaIni.Peso - MAX(V.Peso)) AS [Diferencia de peso]
	FROM( 
		SELECT DISTINCT M.Codigo, M.Alias, V.Peso, MIN(V.Fecha) AS [PrimeraConsulta] FROM BI_Mascotas AS M
		INNER JOIN BI_Visitas AS V  ON M.Codigo = V.Mascota
		GROUP BY  M.Codigo, M.Alias, V.Peso
	) AS FechaIni

	INNER JOIN BI_Mascotas AS M  ON FechaIni.Codigo = M.Codigo
	INNER JOIN BI_Visitas AS V  ON M.Codigo = V.Mascota
	
	GROUP BY FechaIni.Peso, M.Alias, M.Especie
	HAVING (FechaIni.Peso - MAX(V.Peso)) != 0

	--Preguntar a leo lo de las fechas consecutivas







