
USE Northwind
GO

--1. N�mero de clientes de cada pa�s. 

	SELECT * FROM Customers	
	
	SELECT Country, COUNT(CustomerID) AS [Numero de clientes] FROM Customers	
	GROUP BY Country


--2. N�mero de clientes diferentes que compran cada producto. Incluye el nombre 
--del producto 

	SELECT * FROM Customers
	SELECT * FROM Orders
	SELECT * FROM [Order Details]
	SELECT * FROM Products

	SELECT P.ProductName, COUNT(DISTINCT C.CustomerID) AS [Numero de clientes diferentes] FROM Customers AS C
		INNER JOIN Orders AS O  ON C.CustomerID = O.CustomerID
		INNER JOIN [Order Details] AS OD  ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P  ON OD.ProductID = P.ProductID
	GROUP BY P.ProductID, P.ProductName
	ORDER BY P.ProductName


--3. N�mero de pa�ses diferentes en los que se vende cada producto. Incluye el 
--nombre del producto 
	
	SELECT * FROM Products
	SELECT * FROM [Order Details]
	SELECT * FROM Orders
	
	SELECT P.ProductName, COUNT(DISTINCT O.ShipCountry) AS [Numero de paises] FROM Products AS P
		INNER JOIN [Order Details] AS OD  ON P.ProductID = OD.ProductID
		INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID
	GROUP BY P.ProductName
	ORDER BY P.ProductName
		 
--4. Empleados (nombre y apellido) que han vendido alguna vez 
--�Gudbrandsdalsost�, �Lakkalik��ri�, �Tourti�re� o �Boston Crab Meat�. 

	SELECT * FROM Employees
	SELECT * FROM Orders
	SELECT * FROM [Order Details]
	SELECT * FROM Products

	SELECT DISTINCT E.FirstName, E.LastName FROM Employees AS E
		INNER JOIN Orders AS O  ON E.EmployeeID = O.EmployeeID
		INNER JOIN [Order Details] AS OD  ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P  ON OD.ProductID = P.ProductID
	WHERE P.ProductName IN ('Gudbrandsdalsost', 'Lakkalik��ri', 'Tourti�re', 'Boston Crab Meat')

--5. Empleados que no han vendido nunca �Northwoods Cranberry Sauce� o 
--�Carnarvon Tigers�. 

	SELECT * FROM Employees
	SELECT * FROM Orders
	SELECT * FROM [Order Details]
	SELECT * FROM Products

	SELECT FirstName, LastName FROM Employees

	EXCEPT

	SELECT DISTINCT E.FirstName, E.LastName FROM Employees AS E
		INNER JOIN Orders AS O  ON E.EmployeeID = O.EmployeeID
		INNER JOIN [Order Details] AS OD  ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P  ON OD.ProductID = P.ProductID
	WHERE P.ProductName IN ( 'Northwoods Cranberry Sauce','Carnarvon Tigers' )


--6. N�mero de unidades de cada categor�a de producto que ha vendido cada 
--empleado. Incluye el nombre y apellidos del empleado y el nombre de la 
--categor�a. 

	SELECT * FROM Categories
	SELECT * FROM Products
	SELECT * FROM [Order Details]
	SELECT * FROM Orders
	SELECT * FROM Employees

	SELECT DISTINCT E.FirstName, E.LastName, C.CategoryName, SUM(OD.Quantity) AS [Numero unidades] FROM Categories AS C
		INNER JOIN Products AS P  ON C.CategoryID = P.CategoryID
		INNER JOIN [Order Details] AS OD  ON P.ProductID = OD.ProductID
		INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID
		INNER JOIN Employees AS E  ON O.EmployeeID = E.EmployeeID
	GROUP BY E.FirstName, E.LastName, C.CategoryName
	ORDER BY E.FirstName, E.LastName, c.CategoryName
	

--7. Total de ventas (US$) de cada categor�a en el a�o 97. Incluye el nombre de la 
--categor�a. 

	SELECT * FROM [Order Details]
	SELECT * FROM Products
	SELECT * FROM Categories
	
	SELECT ROUND(SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)), 2) AS [Total ventas], C.CategoryName FROM [Order Details] AS OD
		
		INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID
		INNER JOIN Products AS P  ON OD.ProductID = P.ProductID
		INNER JOIN Categories AS C  ON P.CategoryID = C.CategoryID
	
	WHERE YEAR(O.OrderDate) = '1997'
	GROUP BY C.CategoryName
	ORDER BY C.CategoryName



--8. Productos que han comprado m�s de un cliente del mismo pa�s, indicando el 
--nombre del producto, el pa�s y el n�mero de clientes distintos de ese pa�s que 
--lo han comprado. 

	SELECT * FROM Products
	SELECT * FROM [Order Details]
	SELECT * FROM Orders
	SELECT * FROM Customers

	SELECT DISTINCT P.ProductName, C.Country, COUNT(O.CustomerID) AS [Numero de clientes] FROM Products AS P

		INNER JOIN [Order Details] AS OD  ON P.ProductID = OD.ProductID
		INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID
		INNER JOIN Customers AS C  ON O.CustomerID = C.CustomerID
	
	GROUP BY P.ProductName, C.Country
	HAVING COUNT(O.CustomerID) > 1
	ORDER BY P.ProductName, C.Country
	

--9. Total de ventas (US$) en cada pa�s cada a�o. 

	SELECT * FROM Orders
	SELECT * FROM [Order Details]

	SELECT O.ShipCountry, YEAR(O.ShippedDate) AS A�o, ROUND(SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)), 2) AS [Total de ventas] FROM [Order Details] AS OD
		INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID
	GROUP BY O.ShipCountry, YEAR(O.ShippedDate)
	ORDER BY O.ShipCountry, YEAR(O.ShippedDate)


--10. Producto superventas de cada a�o, indicando a�o, nombre del producto, 
--categor�a y cifra total de ventas. 

	SELECT * FROM Products
	SELECT * FROM Categories

	SELECT * FROM [Order Details]
	SELECT * FROM Orders

	SELECT P.ProductName, C.CategoryName, COUNT(OD.ProductID) AS [Numero productos], ProductoSuperVentas.A�o FROM Products AS P
		INNER JOIN Categories AS C  ON P.CategoryID = C.CategoryID
		INNER JOIN [Order Details] AS OD  ON P.ProductID = OD.ProductID
		INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID
		INNER JOIN
		(
			SELECT SumProductoXAnio.A�o, MAX(SumProductoXAnio.[Numero productos]) AS [SuperVentas] 
			FROM (
					SELECT OD.ProductID , YEAR(O.OrderDate) AS [A�o] ,COUNT(OD.ProductID) AS [Numero productos] FROM [Order Details] AS OD
						INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID
					GROUP BY OD.ProductID, YEAR(O.OrderDate)
		
				) AS SumProductoXAnio

			GROUP BY SumProductoXAnio.A�o 
		 
		) AS ProductoSuperVentas ON YEAR(O.OrderDate) = ProductoSuperVentas.A�o

	GROUP BY ProductoSuperVentas.A�o, SuperVentas, P.ProductName, C.CategoryName
	HAVING COUNT(OD.ProductID) = SuperVentas



--11. Cifra de ventas de cada producto en el a�o 97 y su aumento o disminuci�n 
--respecto al a�o anterior en US $ y en %. 

	SELECT * FROM Products
	SELECT * FROM [Order Details]
	SELECT * FROM Orders

	SELECT P.ProductID, P.ProductName, ROUND(SUM(OD.UnitPrice*OD.Quantity * (1-OD.Discount)),2) AS [Total de ventas], ROUND(AnioAnterior.[Total de ventas anio anterior],2) AS [Ventas anio anterior], ROUND(SUM((OD.UnitPrice*OD.Quantity * (1-OD.Discount))) - AnioAnterior.[Total de ventas anio anterior], 2) AS Diferencia, ROUND(((SUM(OD.UnitPrice*OD.Quantity * (1-OD.Discount)) -  AnioAnterior.[Total de ventas anio anterior])/ AnioAnterior.[Total de ventas anio anterior])*100, 2) AS [Tanto por ciento] FROM Products AS P
		INNER JOIN [Order Details] AS OD  ON P.ProductID = OD.ProductID
		INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID
		INNER JOIN(

			SELECT P.ProductID, P.ProductName, SUM(OD.UnitPrice*OD.Quantity * (1-OD.Discount)) AS [Total de ventas anio anterior] FROM Products AS P
				INNER JOIN [Order Details] AS OD  ON P.ProductID = OD.ProductID
				INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID
			GROUP BY P.ProductName, YEAR(O.OrderDate), P.ProductID
			HAVING YEAR(O.OrderDate) = '1996'
		
		) AS AnioAnterior ON P.ProductID = AnioAnterior.ProductID

	GROUP BY P.ProductName, YEAR(O.OrderDate), P.ProductID, AnioAnterior.[Total de ventas anio anterior]
	HAVING YEAR(O.OrderDate) = '1997'
	ORDER BY P.ProductID


--12. Mejor cliente (el que m�s nos compra) de cada pa�s. 

	SELECT * FROM Customers
	SELECT * FROM Orders
	
	SELECT C.CustomerID, C.Country, COUNT(O.CustomerID) [TheBest] FROM Customers AS C	
		INNER JOIN Orders AS O  ON C.CustomerID = O.CustomerID
		INNER JOIN(
		
			SELECT MaximoComprador.Country, MAX(MaximoComprador.[Veces que compra]) AS [Maximo comprador] 
			FROM(

				SELECT C.CustomerID, COUNT(O.CustomerID) AS [Veces que compra], C.Country FROM Customers AS C
					INNER JOIN Orders AS O  ON C.CustomerID = O.CustomerID
				GROUP BY C.CustomerID, C.Country

			)AS MaximoComprador

			GROUP BY MaximoComprador.Country 

	)AS MejorCliente ON C.Country = MejorCliente.Country

	GROUP BY C.CustomerID, C.Country, MejorCliente.[Maximo comprador]
	HAVING COUNT(O.CustomerID) = MejorCliente.[Maximo comprador]


--13. N�mero de productos diferentes que nos compra cada cliente. Incluye el 
--nombre y apellidos del cliente y su direcci�n completa. 

	SELECT * FROM Customers
	SELECT * FROM Orders
	SELECT * FROM [Order Details]

	SELECT O.CustomerID, C.ContactName, COUNT(DISTINCT OD.ProductID) [Productos diferentes],  C.[Address] FROM [Order Details] AS OD
		INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID
		INNER JOIN Customers AS C  ON O.CustomerID = C.CustomerID
	GROUP BY O.CustomerID, C.ContactName, C.[Address]


--14. Clientes que nos compran m�s de cinco productos diferentes. 

	SELECT O.CustomerID, C.ContactName, COUNT(DISTINCT OD.ProductID) [Productos diferentes] FROM [Order Details] AS OD
		INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID
		INNER JOIN Customers AS C  ON O.CustomerID = C.CustomerID
	GROUP BY O.CustomerID, C.ContactName
	HAVING COUNT(DISTINCT OD.ProductID) > 5
	

--15. Vendedores (nombre y apellidos) que han vendido una mayor cantidad que la 
--media en US $ en el a�o 97. 

	SELECT * FROM Employees
	SELECT * FROM Orders
	SELECT * FROM [Order Details]

	SELECT AVG(Media.Cantidad) AS [Media] 
	FROM(

		SELECT E.EmployeeID, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)) AS [Cantidad] FROM [Order Details] AS OD
			INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID
			INNER JOIN Employees AS E  ON O.EmployeeID = E.EmployeeID
		GROUP BY E.EmployeeID, YEAR(O.OrderDate)
		HAVING YEAR(O.OrderDate) = '1997'

		)AS Media
	GROUP BY Media.EmployeeID



--16. Empleados que hayan aumentado su cifra de ventas m�s de un 10% entre dos 
--a�os consecutivos, indicando el a�o en que se produjo el aumento. 