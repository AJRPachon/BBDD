

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

	SELECT E.EmployeeID, E.FirstName, E.LastName, E.HomePhone FROM Employees AS E
		INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
		INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
	WHERE C.CompanyName IN ('Bon app''','Meter Franken')


--Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no han vendido nunca nada a ningún cliente de Francia. *


--Total de ventas en US$ de productos de cada categoría (nombre de la categoría).


--Total de ventas en US$ de cada empleado cada año (nombre, apellidos, dirección).


--Ventas de cada producto en el año 97. Nombre del producto y unidades.


--Cuál es el producto del que hemos vendido más unidades en cada país. *


--Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.


--Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.
