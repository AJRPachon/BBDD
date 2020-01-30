
USE Northwind
GO

--Nombre de los proveedores y número de productos que nos vende cada uno

	SELECT * FROM Products
	SELECT * FROM Suppliers

	SELECT S.ContactName, SUM(P.UnitsOnOrder) AS [Numero de productos] FROM Suppliers AS S
		INNER JOIN Products AS P ON S.SupplierID = P.SupplierID
	GROUP BY P.SupplierID, S.ContactName
	ORDER BY S.ContactName


--Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.

	SELECT * FROM Employees
	SELECT * FROM EmployeeTerritories
	SELECT * FROM Territories

	SELECT DISTINCT E.FirstName, E.LastName, E.HomePhone, T.TerritoryDescription FROM Employees AS E
		INNER JOIN EmployeeTerritories AS ET ON E.EmployeeID = ET.EmployeeID
		INNER JOIN Territories AS T ON ET.TerritoryID = T.TerritoryID
	WHERE T.TerritoryDescription IN ('New York', 'Seattle', 'Vermont', 'Columbia', 'Los Angeles', 'Redmond', 'Atalanta' )


--Número de productos de cada categoría y nombre de la categoría.

	SELECT * FROM Products
	SELECT * FROM Categories

	SELECT C.CategoryName, COUNT(P.ProductID) [Numero de productos] FROM Products AS P
		INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
	GROUP BY C.CategoryID, C.CategoryName
	ORDER BY C.CategoryName


--Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.

	SELECT * FROM Customers
	SELECT * FROM Orders
	SELECT * FROM [Order Details]
	SELECT * FROM Products
	

	SELECT C.CompanyName FROM Customers AS C
		INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
		INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P ON OD.ProductID = P.ProductID
	WHERE P.ProductName IN ('Queso Cabrales','Tofu')


--Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Meter Franken.

	SELECT * FROM Employees
	SELECT * FROM Orders
	SELECT * FROM Customers

	SELECT DISTINCT E.EmployeeID, E.FirstName, E.LastName, E.HomePhone FROM Employees AS E
		INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
		INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
	WHERE C.CompanyName IN ('Bon app''','Meter Franken')
	ORDER BY E.EmployeeID

--Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no han vendido nunca nada a ningún cliente de Francia. *

	SELECT * FROM Employees
	SELECT * FROM Orders
	SELECT * FROM Customers

	--Para usar EXCEPT los dos SELECT tienen que tener la misma estructura.

	SELECT E.EmployeeID, E.FirstName, E.LastName, DATEPART(MONTH, E.BirthDate) AS [Mes cumpleaños], DATEPART(DAY, E.BirthDate) AS [Dia de cumpleaños]  FROM Employees AS E
	
	EXCEPT

	SELECT E.EmployeeID, E.FirstName, E.LastName, DATEPART(MONTH, E.BirthDate) AS [Mes cumpleaños], DATEPART(DAY, E.BirthDate) AS [Dia de cumpleaños] FROM Employees AS E
		INNER JOIN Orders AS O  ON E.EmployeeID = O.EmployeeID
		INNER JOIN Customers AS C  ON O.CustomerID = C.CustomerID
	WHERE C.Country = 'France'
	

--Total de ventas en US$ de productos de cada categoría (nombre de la categoría).

	SELECT * FROM Products
	SELECT * FROM Categories
	SELECT * FROM [Order Details]

	SELECT C.CategoryName, SUM((OD.UnitPrice*OD.Quantity)*(1-OD.Discount)) AS [Total de ventas] FROM Products AS P
		INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
		INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
	GROUP BY C.CategoryName


--Total de ventas en US$ de cada empleado cada año (nombre, apellidos, dirección).

	SELECT * FROM Employees
	SELECT * FROM Orders
	SELECT * FROM [Order Details] 

	SELECT E.FirstName, E.LastName, E.[Address], YEAR(O.OrderDate) AS Año, SUM((OD.UnitPrice*OD.Quantity)*(1-OD.Discount)) AS [Total de ventas]  
	FROM Employees AS E
		INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
		INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	GROUP BY E.FirstName, E.LastName, E.Address, YEAR(O.OrderDate)
	ORDER BY E.FirstName, E.LastName, YEAR(O.OrderDate)


--Ventas de cada producto en el año 97. Nombre del producto y unidades.

	SELECT * FROM Products
	SELECT * FROM [Order Details]
	SELECT * FROM Orders

	SELECT P.ProductID, P.ProductName, SUM(OD.Quantity) AS [Unidades vendidas] FROM Products AS P
		INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
		INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
	WHERE YEAR(O.OrderDate) = '1997'
	GROUP BY P.ProductID, P.ProductName, YEAR(O.OrderDate)
	ORDER BY P.ProductID


--Cuál es el producto del que hemos vendido más unidades en cada país. *

	SELECT ProductName, SUM(OD.Quantity) AS CantidadMaxima, O.ShipCountry FROM Products AS P 

			INNER JOIN [Order Details] AS OD	ON P.ProductID = OD.ProductID
			INNER JOIN Orders AS O	ON O.OrderID = OD.OrderID
			INNER JOIN Customers AS C	ON C.CustomerID = O.CustomerID
			INNER JOIN --Coger el mayor de cada pais

				(SELECT MAX(MasUniProPais) AS Superventas, ShipCountry

				FROM(--Cantidad total de cada producto por pais

						SELECT ProductID, O.ShipCountry, SUM(OD.Quantity) AS [MasUniProPais] FROM  [Order Details] AS OD
							INNER JOIN Orders AS O 	ON O.OrderID = OD.OrderID
						GROUP BY ProductID,  O.ShipCountry

					) AS MasUnidadesVendidasPais 

					GROUP BY ShipCountry

			)AS MayorPorPais ON O.ShipCountry = MayorPorPais.ShipCountry

	GROUP BY ProductName, O.ShipCountry, Superventas

	HAVING SUM(OD.Quantity) = Superventas

	ORDER BY O.ShipCountry



--Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.

	SELECT E.FirstName, E.LastName FROM Employees AS E
		INNER JOIN Employees AS Jefe ON E.ReportsTo = Jefe.EmployeeID
	WHERE Jefe.FirstName = 'Andrew' AND Jefe.LastName = 'Fuller'
		
--Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.

	SELECT * FROM Employees

	SELECT E.EmployeeID, E.FirstName, E.LastName, COUNT(E.EmployeeID) AS [Numero Subordinados] FROM Employees AS E
		INNER JOIN Employees AS Minion ON E.EmployeeID = Minion.ReportsTo
	GROUP BY E.EmployeeID, E.EmployeeID, E.FirstName, E.LastName



