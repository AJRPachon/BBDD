
--BASE DE DATOS BICHOS

USE Bichos
GO

--1.N�mero de mascotas que han sufrido cada enfermedad. 

	SELECT * FROM BI_Mascotas
	SELECT * FROM BI_Mascotas_Enfermedades
	SELECT * FROM BI_Enfermedades

	SELECT DISTINCT M.Codigo, COUNT(ME.IDEnfermedad) AS [Numero de mascotas] FROM BI_Mascotas AS M
		INNER JOIN BI_Mascotas_Enfermedades AS ME ON M.Codigo = ME.Mascota
		INNER JOIN BI_Enfermedades AS E  ON ME.IDEnfermedad = E.ID
	GROUP BY M.Codigo



--2.N�mero de mascotas que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna mascota.

	SELECT * FROM BI_Mascotas
	SELECT * FROM BI_Mascotas_Enfermedades
	SELECT * FROM BI_Enfermedades

	SELECT DISTINCT M.Codigo, E.Nombre, COUNT(ME.IDEnfermedad) AS [Numero de mascotas] FROM BI_Mascotas AS M
		INNER JOIN BI_Mascotas_Enfermedades AS ME ON M.Codigo = ME.Mascota
		RIGHT JOIN BI_Enfermedades AS E  ON ME.IDEnfermedad = E.ID
	GROUP BY M.Codigo, E.Nombre 


--3.N�mero de mascotas de cada cliente. Incluye nombre completo y direcci�n del cliente.

	SELECT * FROM BI_Mascotas
	SELECT * FROM BI_Clientes

	SELECT C.Nombre, COUNT(M.Codigo) AS [Numero de mascotas], C.Direccion FROM BI_Clientes AS C
		INNER JOIN BI_Mascotas AS M  ON C.Codigo = M.CodigoPropietario
	GROUP BY C.Nombre, C.Direccion


--4.N�mero de mascotas de cada especie de cada cliente. Incluye nombre completo y direcci�n del cliente.

	SELECT * FROM BI_Mascotas
	SELECT * FROM BI_Clientes

	SELECT C.Codigo, C.Nombre, C.Direccion, M.Especie, COUNT(M.Especie) AS [Numero de mascotas] FROM BI_Mascotas AS M
		INNER JOIN BI_Clientes AS C  ON M.CodigoPropietario = C.Codigo
	GROUP BY C.Codigo, C.Nombre, C.Direccion, M.Especie
	ORDER BY C.Codigo


--5.N�mero de mascotas de cada especie que han sufrido cada enfermedad.

	SELECT * FROM BI_Enfermedades
	SELECT * FROM BI_Mascotas_Enfermedades
	SELECT * FROM BI_Mascotas

	SELECT M.Especie, E.Nombre, COUNT(M.Codigo) AS [Numero de mascotas] FROM BI_Enfermedades AS E
		INNER JOIN BI_Mascotas_Enfermedades AS ME ON E.ID = ME.IDEnfermedad
		INNER JOIN BI_Mascotas AS M ON  ME.Mascota = M.Codigo
	GROUP BY M.Especie, E.Nombre
	ORDER BY M.Especie, E.Nombre


--6.N�mero de mascotas de cada especie que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna mascota de alguna especie.

	SELECT * FROM BI_Enfermedades
	SELECT * FROM BI_Mascotas_Enfermedades
	SELECT * FROM BI_Mascotas

	SELECT M.Especie, E.Nombre, COUNT(M.Codigo) AS [Numero de mascotas] FROM BI_Enfermedades AS E
		LEFT JOIN BI_Mascotas_Enfermedades AS ME ON E.ID = ME.IDEnfermedad
		LEFT JOIN BI_Mascotas AS M ON  ME.Mascota = M.Codigo
	GROUP BY M.Especie, E.Nombre
	ORDER BY M.Especie, E.Nombre

	--Preguntar a Leo

--7.Queremos saber cu�l es la enfermedad m�s com�n en cada especie. Incluye cuantos casos se han producido.

	SELECT * FROM BI_Enfermedades
	SELECT * FROM BI_Mascotas_Enfermedades
	SELECT * FROM BI_Mascotas

	
		

--8.Duraci�n media, en d�as, de cada enfermedad, desde que se detecta hasta que se cura. Incluye solo los casos en que el animal se haya curado. Se entiende que una mascota se ha curado si tiene fecha de curaci�n y est� viva o su fecha de fallecimiento es posterior a la fecha de curaci�n.



--9.N�mero de veces que ha acudido a consulta cada cliente con alguna de sus mascotas. Incluye nombre y apellidos del cliente.



--10.N�mero de visitas a las que ha acudido cada mascota, fecha de su primera y de su �ltima visita



--11.Incremento (o disminuci�n) de peso que ha experimentado cada mascota entre cada dos consultas sucesivas. Incluye nombre de la mascota, especie, fecha de las dos consultas sucesivas e incremento o disminuci�n de peso.









