--PUBS

USE pubs
GO

--1.   T�tulo y tipo de todos los libros en los que alguno de los autores vive en California (CA).

	SELECT * FROM titles
	SELECT * FROM titleauthor
	SELECT * FROM authors

	SELECT DISTINCT T.title, T.type FROM titles AS T
	INNER JOIN titleauthor AS TA  ON T.title_id = TA.title_id
	INNER JOIN authors AS A  ON TA.au_id = A.au_id
	WHERE A.state = 'CA'


--2.   T�tulo y tipo de todos los libros en los que ninguno de los autores vive en California (CA).

	SELECT DISTINCT T.title, T.type FROM titles AS T

	EXCEPT

	SELECT DISTINCT T.title, T.type FROM titles AS T
	INNER JOIN titleauthor AS TA  ON T.title_id = TA.title_id
	INNER JOIN authors AS A  ON TA.au_id = A.au_id
	WHERE A.state = 'CA'


--3.   N�mero de libros en los que ha participado cada autor, incluidos los que no han publicado nada.

	SELECT * FROM authors
	SELECT * FROM titleauthor

	SELECT A.au_fname, A.au_lname, COUNT(TA.title_id) AS [Numero de libros] FROM authors AS A
	LEFT JOIN  titleauthor AS TA  ON A.au_id = TA.au_id
	GROUP BY A.au_fname, A.au_lname


--4.   N�mero de libros que ha publicado cada editorial, incluidas las que no han publicado ninguno.

	SELECT * FROM titles
	SELECT * FROM publishers

	SELECT P.pub_name, COUNT(T.title_id) AS [Numero de libros] FROM titles AS T
	RIGHT JOIN publishers AS P  ON T.pub_id = P.pub_id
	GROUP BY P.pub_name


--5.   N�mero de empleados de cada editorial.

	SELECT * FROM publishers
	SELECT * FROM employee

	SELECT P.pub_name, COUNT(E.emp_id) AS [Numero de empleados] FROM publishers AS P 
	INNER JOIN employee AS E  ON P.pub_id = E.pub_id
	GROUP BY P.pub_name


--6.   Calcular la relaci�n entre n�mero de ejemplares publicados y n�mero de empleados de cada editorial, incluyendo el nombre de la misma.

GO
	CREATE VIEW NumEmple AS
	SELECT P.pub_name, COUNT(E.emp_id) AS [Numero de empleados] FROM employee AS E
	INNER JOIN publishers AS P  ON E.pub_id = P.pub_id
	GROUP BY P.pub_name
GO
	CREATE VIEW EjemPubli AS
	SELECT P.pub_name, COUNT(T.title_id) AS [Numero de ejemplares] FROM publishers AS P
	INNER JOIN titles AS T  ON P.pub_id = T.pub_id
	GROUP BY P.pub_name
GO

	

--7.   Nombre, Apellidos y ciudad de todos los autores que han trabajado para la editorial "Binnet & Hardley� o "Five Lakes Publishing�



--8.   Empleados que hayan trabajado en alguna editorial que haya publicado alg�n libro en el que alguno de los autores fuera Marjorie Green o Michael O'Leary.



--9.   N�mero de ejemplares vendidos de cada libro, especificando el t�tulo y el tipo.



--10.  N�mero de ejemplares de todos sus libros que ha vendido cada autor.



--11.  N�mero de empleados de cada categor�a (jobs).



--12.  N�mero de empleados de cada categor�a (jobs) que tiene cada editorial, incluyendo aquellas categor�as en las que no haya ning�n empleado.



--13.  Autores que han escrito libros de dos o m�s tipos diferentes



--14.  Empleados que no trabajan actualmente en editoriales que han publicado libros cuya columna notes contenga la palabra "and�




