
USE Northwind
GO

--1. Número de clientes de cada país. 

	SELECT * FROM Customers	
	
	SELECT Country, COUNT(CustomerID) AS [Numero de clientes] FROM Customers	
	GROUP BY Country


--2. Número de clientes diferentes que compran cada producto. Incluye el nombre 
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


--3. Número de países diferentes en los que se vende cada producto. Incluye el 
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
--“Gudbrandsdalsost”, “Lakkalikööri”, “Tourtière” o “Boston Crab Meat”. 

	SELECT * FROM Employees
	SELECT * FROM Orders
	SELECT * FROM [Order Details]
	SELECT * FROM Products

	SELECT DISTINCT E.FirstName, E.LastName FROM Employees AS E
		INNER JOIN Orders AS O  ON E.EmployeeID = O.EmployeeID
		INNER JOIN [Order Details] AS OD  ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P  ON OD.ProductID = P.ProductID
	WHERE P.ProductName IN ('Gudbrandsdalsost', 'Lakkalikööri', 'Tourtière', 'Boston Crab Meat')

--5. Empleados que no han vendido nunca “Northwoods Cranberry Sauce” o 
--“Carnarvon Tigers”. 


--6. Número de unidades de cada categoría de producto que ha vendido cada 
--empleado. Incluye el nombre y apellidos del empleado y el nombre de la 
--categoría. 


--7. Total de ventas (US$) de cada categoría en el año 97. Incluye el nombre de la 
--categoría. 


--8. Productos que han comprado más de un cliente del mismo país, indicando el 
--nombre del producto, el país y el número de clientes distintos de ese país que 
--lo han comprado. 


--9. Total de ventas (US$) en cada país cada año. 


--10. Producto superventas de cada año, indicando año, nombre del producto, 
--categoría y cifra total de ventas. 


--11. Cifra de ventas de cada producto en el año 97 y su aumento o disminución 
--respecto al año anterior en US $ y en %. 


--12. Mejor cliente (el que más nos compra) de cada país. 


--13. Número de productos diferentes que nos compra cada cliente. Incluye el 
--nombre y apellidos del cliente y su dirección completa. 


--14. Clientes que nos compran más de cinco productos diferentes. 


--15. Vendedores (nombre y apellidos) que han vendido una mayor cantidad que la 
--media en US $ en el año 97. 


--16. Empleados que hayan aumentado su cifra de ventas más de un 10% entre dos 
--años consecutivos, indicando el año en que se produjo el aumento. 