
USE Northwind

--1.Nombre de los proveedores y número de productos que nos vende cada uno

--SELECT * FROM Suppliers
--SELECT * FROM Products

SELECT ContactName, COUNT(P.SupplierID) AS NumProductos
FROM Suppliers AS S
INNER JOIN Products AS P
ON P.SupplierID = S.SupplierID
GROUP BY ContactName;


--2.Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont,
--Columbia, Los Angeles, Redmond o Atlanta.

SELECT * FROM Employees
SELECT * FROM EmployeeTerritories
SELECT * FROM Territories


SELECT E.LastName, E.FirstName, E.HomePhone, T.TerritoryDescription
FROM Employees  AS E

INNER JOIN EmployeeTerritories AS ET
ON ET.EmployeeID = E.EmployeeID

INNER JOIN Territories AS T
ON T.TerritoryID = ET.TerritoryID

WHERE T.TerritoryDescription IN ('New York', 'Seatle', 'Vermont', 'Columbia','Los Angeles', 'Redmond', 'Atlanta')


--3.Número de productos de cada categoría y nombre de la categoría.

--SELECT * FROM Categories
--SELECT * FROM Products

SELECT COUNT(P.CategoryID) AS NumProducts, C.CategoryName
FROM Products AS P
INNER JOIN Categories AS C
ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryName


--4.Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.

--SELECT * FROM Products
--SELECT * FROM [Order Details]
--SELECT * FROM [Orders]
--SELECT * FROM Customers

SELECT C.CompanyName
FROM Products AS P

INNER JOIN [Order Details] AS OD
ON P.ProductID = OD.ProductID

INNER JOIN [Orders] AS O
ON OD.OrderID = O.OrderID

INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID

WHERE P.ProductName IN ('Queso Cabrales', 'Tofu')
GROUP BY C.CompanyName 



--5.Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Meter Franken.

--SELECT * FROM Employees
--SELECT * FROM Orders

SELECT DISTINCT E.EmployeeID, E.LastName, E.FirstName, E.HomePhone
FROM Employees AS E

INNER JOIN Orders AS O
ON O.EmployeeID = E.EmployeeID	

WHERE ShipName IN ('Bon app''', 'Meter Franken')
GROUP BY E.EmployeeID, E.LastName, E.FirstName, E.HomePhone


--6.Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no han vendido nunca
--nada a ningún cliente de Francia. *

--SELECT * FROM Employees
--SELECT * FROM Orders
--SELECT * FROM Customers

SELECT E.EmployeeID, E.LastName, E.FirstName, DAY(E.BirthDate) AS 'Dia cumpleaños', MONTH(E.BirthDate) AS 'Mes cumpleaños'
FROM Employees AS E

INNER JOIN Orders AS O
ON O.EmployeeID = E.EmployeeID

INNER JOIN Customers AS C
ON C.CustomerID = O.CustomerID

WHERE C.Country != 'Francia' 
GROUP BY E.EmployeeID, E.LastName, E.FirstName, E.BirthDate
ORDER BY E.EmployeeID


--7.Total de ventas en US$ de productos de cada categoría (nombre de la categoría).

--SELECT * FROM [Order Details]
--SELECT * FROM Products
--SELECT * FROM Categories

SELECT C.CategoryName, SUM(OD.UnitPrice * OD.Quantity) AS TotalVentas
FROM Categories AS C

INNER JOIN Products AS P
ON P.CategoryID = C.CategoryID

INNER JOIN [Order Details] AS OD
ON OD.ProductID = P.ProductID

GROUP BY C.CategoryName 


--8.Total de ventas en US$ de cada empleado cada año (nombre, apellidos, dirección).

SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products

SELECT E.LastName, E.FirstName, E.Address, SUM(OD.UnitPrice * Quantity) AS Ventas, YEAR(O.OrderDate) AS Año
FROM Employees AS E

INNER JOIN Orders AS O
ON O.EmployeeID = E.EmployeeID

INNER JOIN [Order Details] AS OD
ON OD.OrderID = O.OrderID

INNER JOIN Products AS P
ON P.ProductID = OD.ProductID

GROUP BY E.LastName, E.FirstName, E.Address, YEAR(O.OrderDate)
ORDER BY YEAR(O.OrderDate)


--9.Ventas de cada producto en el año 97. Nombre del producto y unidades.

SELECT * FROM Orders
SELECT * FROM [Order Details] 
SELECT *FROM Products

SELECT P.ProductName, YEAR(O.OrderDate) AS Año, SUM(OD.UnitPrice * OD.Quantity) AS Ventas, SUM(OD.Quantity) AS Unidades
FROM Products AS P

INNER JOIN [Order Details] AS OD
ON OD.ProductID = P.ProductID

INNER JOIN Orders AS O
ON O.OrderID = OD.OrderID

WHERE YEAR(O.OrderDate) = 1997
GROUP BY P.ProductName, YEAR(O.OrderDate)


--10.Cuál es el producto del que hemos vendido más unidades en cada país. *
USE Northwind
SELECT * FROM Orders
SELECT * FROM [Order Details] 
SELECT * FROM Products
SELECT * FROM Customers
	-- Agregar a todo lo anterior el nombre del producto
SELECT ProductName, SUM(OD.Quantity) AS CantidadMaxima, O.ShipCountry
FROM Products AS P 
		
	    INNER JOIN [Order Details] AS OD	ON P.ProductID = OD.ProductID

		INNER JOIN Orders AS O	ON O.OrderID = OD.OrderID
		
		INNER JOIN Customers AS C	ON C.CustomerID = O.CustomerID

		INNER JOIN --Coger el mayor de cada pais
		(SELECT MAX(MasUniProPais) AS Superventas, ShipCountry

		FROM		(--Cantidad total de cada producto por pais
					SELECT ProductID, O.ShipCountry, SUM(OD.Quantity) AS [MasUniProPais]
					FROM  [Order Details] AS OD
			
					INNER JOIN Orders AS O 	ON O.OrderID = OD.OrderID
			
					GROUP BY ProductID,  O.ShipCountry

				) AS MasUnidadesVendidasPais 
				GROUP BY ShipCountry

		)AS MayorPorPais ON O.ShipCountry = MayorPorPais.ShipCountry

GROUP BY ProductName, O.ShipCountry, Superventas
HAVING SUM(OD.Quantity) = Superventas
ORDER BY O.ShipCountry

--EL MISMO EJERCICIO PERO CON VISTAS
--10.Cuál es el producto del que hemos vendido más unidades en cada país. *

SELECT * FROM Orders
SELECT * FROM [Order Details] 
SELECT * FROM Products
SELECT * FROM Customers
	
--Cantidad total de cada producto por pais
GO
CREATE VIEW [MasUnidadesProPais] AS
	SELECT ProductID, O.ShipCountry, SUM(OD.Quantity) AS [MasUniProPais]
	FROM  [Order Details] AS OD
			
	INNER JOIN Orders AS O 	ON O.OrderID = OD.OrderID

	GROUP BY ProductID,  O.ShipCountry
GO

--Coger el mayor de cada pais
GO
CREATE VIEW [MayorPorPais] AS
SELECT MAX(MasUniProPais) AS Superventas, ShipCountry
FROM [MasUnidadesProPais]
GROUP BY ShipCountry
GO


-- Agregar a todo lo anterior el nombre del producto

GO
CREATE VIEW [MasVendido] AS 
SELECT ProductName, SUM(OD.Quantity) AS CantidadMaxima, O.ShipCountry
FROM Products AS P 
		
	    INNER JOIN [Order Details] AS OD	ON P.ProductID = OD.ProductID
		INNER JOIN Orders AS O	ON O.OrderID = OD.OrderID
		INNER JOIN Customers AS C	ON C.CustomerID = O.CustomerID
		INNER JOIN [MayorPorPais] AS MPP   ON O.ShipCountry = MPP.ShipCountry

GROUP BY ProductName, O.ShipCountry, Superventas
HAVING SUM(OD.Quantity) = Superventas
ORDER BY O.ShipCountry
GO



--11.Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.

SELECT * FROM Employees

SELECT	E.FirstName, E.LastName
FROM Employees AS E
INNER JOIN Employees AS Boss  ON E.ReportsTo = Boss.EmployeeID
WHERE Boss.FirstName = 'Andrew' AND Boss.LastName = 'Fuller'


--12.Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.
--https://diego.com.es/principales-tipos-de-joins-en-sql
SELECT * FROM Employees

SELECT	E.FirstName, E.LastName, E.EmployeeID, COUNT(Sub.ReportsTo) AS Subordinado
FROM Employees AS E
LEFT JOIN Employees AS Sub  ON Sub.ReportsTo = E.EmployeeID
GROUP BY E.FirstName, E.LastName, E.EmployeeID
