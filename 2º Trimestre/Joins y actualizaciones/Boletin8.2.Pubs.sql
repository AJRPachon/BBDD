
USE pubs
GO

--1. Numero de libros que tratan de cada tema

SELECT * FROM titles

SELECT [type] AS TEMA, COUNT(title_id) AS NumLibros
FROM titles
GROUP BY [type];


--2. Número de autores diferentes en cada ciudad y estado

SELECT * FROM authors

SELECT	COUNT(au_id) as NumAutores, city, [state]
FROM authors
GROUP BY  city, [state]
ORDER BY city;

--3. Nombre, apellidos, nivel y antigüedad en la empresa de los empleados con un nivel entre 100 y 150.

SELECT * FROM employee

SELECT fname, lname, job_lvl, DATEDIFF(YEAR, hire_date, CURRENT_TIMESTAMP) AS Antiguedad
FROM employee


--4. Número de editoriales en cada país. Incluye el país.

SELECT * FROM publishers

SELECT country, COUNT(pub_name) AS NumEditoriales
FROM publishers
GROUP BY country;

--5. Número de unidades vendidas de cada libro en cada año (title_id, unidades y año).

SELECT * FROM sales

SELECT
FROM sales
--6. Número de autores que han escrito cada libro (title_id y numero de autores).


--7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor 
--   superior a $7.000, ordenado por tipo y título