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



--3.Número de mascotas de cada cliente. Incluye nombre completo y dirección del cliente.



--4.Número de mascotas de cada especie de cada cliente. Incluye nombre completo y dirección del cliente.



--5.Número de mascotas de cada especie que han sufrido cada enfermedad.



--6.Número de mascotas de cada especie que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna mascota de alguna especie.



--7.Queremos saber cuál es la enfermedad más común en cada especie. Incluye cuantos casos se han producido.



--8.Duración media, en días, de cada enfermedad, desde que se detecta hasta que se cura. Incluye solo los casos en que el animal se haya curado. Se entiende que una mascota se ha curado si tiene fecha de curación y está viva o su fecha de fallecimiento es posterior a la fecha de curación.



--9.Número de veces que ha acudido a consulta cada cliente con alguna de sus mascotas. Incluye nombre y apellidos del cliente.



--10.Número de visitas a las que ha acudido cada mascota, fecha de su primera y de su última visita



--11.Incremento (o disminución) de peso que ha experimentado cada mascota entre cada dos consultas sucesivas. Incluye nombre de la mascota, especie, fecha de las dos consultas sucesivas e incremento o disminución de peso.









