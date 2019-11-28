USE Northwind

--1. Número de clientes de cada país. 

SELECT * FROM Customers

SELECT Country, COUNT(CustomerID) AS [Numero de clientes]
FROM Customers
GROUP BY Country

--2. Número de clientes diferentes que compran cada producto. Incluye el nombre 
--del producto 

SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products

SELECT P.ProductName, COUNT(C.CustomerID) AS [Numero de clientes]
FROM Customers AS C

	INNER JOIN Orders AS O   ON C.CustomerID = O.CustomerID
	INNER JOIN [Order Details] AS OD   ON  O.OrderID = OD.OrderID
	INNER JOIN Products AS P   ON  OD.ProductID = P.ProductID 

GROUP BY P.ProductName
ORDER BY P.ProductName

--3. Número de países diferentes en los que se vende cada producto. Incluye el 
--nombre del producto 

SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders

SELECT  COUNT(DISTINCT O.ShipCountry) AS [Numero de paises], P.ProductName
FROM Orders AS O

	INNER JOIN [Order Details] AS OD   ON O.OrderID = OD.OrderID
	INNER JOIN Products AS P   ON OD.ProductID = P.ProductID

GROUP BY P.ProductName

--4. Empleados (nombre y apellido) que han vendido alguna vez 
--“Gudbrandsdalsost”, “Lakkalikööri”, “Tourtière” o “Boston Crab Meat”. 

SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products
ORDER BY ProductName

SELECT E.LastName, E.FirstName
FROM Employees AS E

	INNER JOIN Orders AS O   ON E.EmployeeID = O.EmployeeID
	INNER JOIN [Order Details] AS OD   ON  O.OrderID = OD.OrderID
	INNER JOIN Products AS P   ON  OD.ProductID = P.ProductID 

WHERE ProductName IN ('Gudbrandsdalsost' , 'Lakkalikööri' , 'Tourtière' , 'Boston Crab Meat')
GROUP BY E.LastName, E.FirstName

--5. Empleados que no han vendido nunca “Northwoods Cranberry Sauce” o 
--“Carnarvon Tigers”. 

SELECT * FROM Employees

SELECT E.LastName, E.FirstName
FROM Employees AS E

	INNER JOIN Orders AS O   ON E.EmployeeID = O.EmployeeID
	INNER JOIN [Order Details] AS OD   ON  O.OrderID = OD.OrderID
	INNER JOIN Products AS P   ON  OD.ProductID = P.ProductID 

WHERE ProductName IN ('Northwoods Cranberry Sauce' , 'Carnarvon Tigers')
GROUP BY E.LastName, E.FirstName

-- No entiendo
select distinct E.EmployeeID,E.FirstName,E.LastName from Employees as E

where E.EmployeeID not in 

(select distinct O.EmployeeID from Orders as O 

inner join [Order Details] as OD on O.OrderID=OD.OrderID

inner join Products as P on OD.ProductID=P.ProductID

where P.ProductName in ('Northwoods Cranberry Sauce','Carnarvon Tigers'))


--6. Número de unidades de cada categoría de producto que ha vendido cada 
--empleado. Incluye el nombre y apellidos del empleado y el nombre de la 
--categoría. 

SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products
SELECT * FROM Categories

SELECT E.FirstName, E.LastName, C.CategoryName, COUNT(C.CategoryName) AS [Numero de unidades]
FROM Employees AS E

	INNER JOIN Orders AS O  ON E.EmployeeID = O.EmployeeID
	INNER JOIN [Order Details] AS OD  ON O.OrderID = OD.OrderID
	INNER JOIN Products AS P   ON OD.ProductID  = P.ProductID
	INNER JOIN Categories AS C  ON P.CategoryID = C.CategoryID

GROUP BY C.CategoryName, E.FirstName, E.LastName
ORDER BY E.FirstName


--7. Total de ventas (US$) de cada categoría en el año 97. Incluye el nombre de la 
--categoría. 

SELECT * FROM Categories
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders


SELECT C.CategoryName, YEAR(O.ShippedDate) AS Ventas1997, SUM((OD.Quantity * OD.UnitPrice)* (1-OD.Discount)) AS [Total de ventas]
FROM Categories AS C

	INNER JOIN Products AS P  ON P.CategoryID = C.CategoryID
	INNER JOIN [Order Details] AS OD   ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID

WHERE YEAR(O.ShippedDate) = 1997
GROUP BY C.CategoryName, YEAR(O.ShippedDate)


--8. Productos que han comprado más de un cliente del mismo país, indicando el 
--nombre del producto, el país y el número de clientes distintos de ese país que 
--lo han comprado. 

SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders
SELECT * FROM Customers

SELECT P.ProductName, C.Country, COUNT(DISTINCT C.CustomerID) AS [Numero de clientes]
FROM Products AS P

	INNER JOIN [Order Details] AS OD   ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID
	INNER JOIN Customers AS C  ON O.CustomerID = C.CustomerID

GROUP BY P.ProductName, C.Country
HAVING COUNT(DISTINCT C.CustomerID) > 1
	

--9. Total de ventas (US$) en cada país cada año. 

SELECT * FROM [Order Details]
SELECT * FROM Orders

SELECT YEAR(O.OrderDate) AS [Año], SUM((OD.UnitPrice * OD.Quantity) * (1-OD.Discount)) AS [Total de ventas], O.ShipCountry
FROM [Order Details] AS OD

	INNER JOIN Orders AS O   ON OD.OrderID = O.OrderID

GROUP BY YEAR(O.OrderDate), O.ShipCountry
ORDER BY YEAR(O.OrderDate)


--10. Producto superventas de cada año, indicando año, nombre del producto, 
--categoría y cifra total de ventas. 

SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders
SELECT * FROM Categories

  --Primero sumar todos los productos vendidos por pais
GO
CREATE VIEW [SumaProductos] AS
SELECT OD.ProductID, SUM(OD.Quantity) AS [UnidadesVendidas], YEAR(O.OrderDate) AS [Año]
FROM [Order Details] AS OD

	INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID

GROUP BY OD.ProductID, YEAR(O.OrderDate)
GO

  --Coger el máximo
GO
CREATE VIEW [MasVendido] AS
SELECT MAX(UnidadesVendidas) AS [Unidades mas vendidas], Año
FROM [SumaProductos] 
GROUP BY Año
GO

--Nombre del producto y categoria

SELECT P.ProductName, C.CategoryName, MV.[Unidades mas vendidas] 
FROM Products AS P

	INNER JOIN [Order Details] AS OD  ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS O  ON  OD.OrderID = O.OrderID
	INNER JOIN [MasVendido] AS MV  ON YEAR(O.OrderDate) = MV.Año
	INNER JOIN Categories AS C  ON C.CategoryID = P.CategoryID

GROUP BY C.CategoryName, P.ProductName, MV.[Unidades mas vendidas]
HAVING SUM(OD.Quantity) = MV.[Unidades mas vendidas]


--11. Cifra de ventas de cada producto en el año 97 y su aumento o disminución 
--respecto al año anterior en US $ y en %. 

SELECT * FROM Products
SELECT * FROM [Order Details]	
SELECT * FROM Orders

GO
CREATE VIEW [Cifra de ventas 1997] AS
SELECT OD.ProductID, P.ProductName, SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS [Cantidad de producto]
FROM Products AS P
	
	INNER JOIN [Order Details] AS OD   ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID

GROUP BY OD.ProductID, P.ProductName, YEAR(O.OrderDate)
HAVING YEAR(O.OrderDate) = 1997
ORDER BY OD.ProductID
GO


SELECT P.ProductID, P.ProductName, SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS [Cantidad producto 96], ([Cantidad de producto]-SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount))) AS [Aumento/Disminución], ((V97.[Cantidad de producto]/SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) -1) * 100) AS Porcentaje
FROM Orders AS O

	INNER JOIN [Order Details] AS OD  ON O.OrderID = OD.OrderID
	INNER JOIN Products AS P  ON OD.ProductID = P.ProductID
	INNER JOIN [Cifra de ventas 1997] AS V97  ON P.ProductID = V97.ProductID

WHERE YEAR(O.OrderDate) = 1996
GROUP BY P.ProductID, P.ProductName, [Cantidad de producto]
ORDER BY P.ProductID


--12. Mejor cliente (el que más nos compra) de cada país. 

SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM [Order Details]

-- Sumar los productos de cada pais por vendedor
GO
CREATE VIEW  [Total Vendido por cliente] AS
SELECT C.CustomerID, SUM(OD.Quantity) AS [Producto], C.Country
FROM Customers AS C

	INNER JOIN Orders AS O  ON C.CustomerID = O.CustomerID
	INNER JOIN [Order Details] AS OD  ON O.OrderID = OD.OrderID

GROUP BY C.CustomerID, O.ShipCountry, C.Country
GO

--Coger el que más ha vendido en cada pais
GO
CREATE VIEW [Maximo Vendedor] AS
SELECT MAX([TVPC].[Producto]) AS [ProductoTOP], TVPC.Country
FROM [Total Vendido por cliente] AS TVPC
GROUP BY TVPC.Country
GO

--Añadir la ID del Customer y relacionar en el WHERE/HAVING con las consultas anteriores
SELECT O.CustomerID, C.Country
FROM Orders AS O 

	INNER JOIN Customers AS C  ON O.CustomerID = C.CustomerID 
	INNER JOIN [Order Details] AS OD  ON O.OrderID = OD.OrderID
	INNER JOIN [Maximo Vendedor] AS MV  ON  C.Country = MV.Country

GROUP BY O.CustomerID, MV.ProductoTOP, C.Country
HAVING SUM(OD.Quantity) = MV.[ProductoTOP]  --relaciona SUM(OD.QUANTITY) Con el producto más vendido de la segunda vista.
ORDER BY C.Country


--13. Número de productos diferentes que nos compra cada cliente. Incluye el 
--nombre y apellidos del cliente y su dirección completa. 

SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM [Order Details]

SELECT C.ContactName, C.[Address], C.CustomerID, COUNT(DISTINCT OD.ProductID) AS [Productos diferentes]
FROM Customers AS C

	INNER JOIN Orders AS O  ON C.CustomerID = O.CustomerID
	INNER JOIN [Order Details] AS OD  ON O.OrderID = OD.OrderID

GROUP BY C.CustomerID, C.ContactName, C.[Address]
ORDER BY C.CustomerID

--14. Clientes que nos compran más de cinco productos diferentes. 

SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM [Order Details]

SELECT C.ContactName, C.[Address], C.CustomerID, COUNT(DISTINCT OD.ProductID) AS [Productos diferentes]
FROM Customers AS C

	INNER JOIN Orders AS O  ON C.CustomerID = O.CustomerID
	INNER JOIN [Order Details] AS OD  ON O.OrderID = OD.OrderID

GROUP BY C.CustomerID, C.ContactName, C.[Address]
HAVING COUNT(DISTINCT OD.ProductID) > 5
ORDER BY C.CustomerID

--15. Vendedores (nombre y apellidos) que han vendido una mayor cantidad que la 
--media en US $ en el año 97. 

SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]

--GO
--CREATE VIEW [Ventas totales] AS
--SELECT E.EmployeeID, SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS [Total Ventas]
--FROM Employees AS E

--	INNER JOIN Orders AS O  ON E.EmployeeID = O.EmployeeID
--	INNER JOIN [Order Details] AS OD  ON O.OrderID = OD.OrderID

--WHERE YEAR(O.OrderDate) = 1997
--GROUP BY E.EmployeeID
--GO

--GO
--CREATE VIEW [Media ventas totales] AS 
--SELECT AVG(VT.[Total Ventas]) AS [Media Ventas] 
--FROM [Ventas totales] AS VT
--GO

--SELECT E.EmployeeID, E.FirstName, E.LastName, SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS [Mayor Cantidad]
--FROM Employees AS E

--	INNER JOIN Orders AS O  ON E.EmployeeID = O.EmployeeID
--	INNER JOIN [Order Details] AS OD  ON O.OrderID = OD.OrderID

--WHERE YEAR(O.OrderDate) = 1997
--GROUP BY E.FirstName, E.LastName, E.EmployeeID
--HAVING (SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount))) > ([Media ventas totales].[Media Ventas])


SELECT E.EmployeeID, E.FirstName, E.LastName, SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS [Mayor Cantidad]
FROM Employees AS E

	INNER JOIN Orders AS O  ON E.EmployeeID = O.EmployeeID
	INNER JOIN [Order Details] AS OD  ON O.OrderID = OD.OrderID

WHERE YEAR(O.OrderDate) = 1997
GROUP BY E.EmployeeID, E.FirstName, E.LastName
HAVING (SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount))) >
	(SELECT AVG([Total Ventas]) AS [Media Ventas]
	FROM
		(SELECT E.EmployeeID, SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS [Total Ventas]
		FROM Employees AS E

			INNER JOIN Orders AS O  ON E.EmployeeID = O.EmployeeID
			INNER JOIN [Order Details] AS OD  ON O.OrderID = OD.OrderID

		WHERE YEAR(O.OrderDate) = 1997
		GROUP BY E.EmployeeID) AS [Ventas totales]) 

ORDER BY E.EmployeeID

--16. Empleados que hayan aumentado su cifra de ventas más de un 10% entre dos 
--años consecutivos, indicando el año en que se produjo el aumento.

SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]


--Ventas de cada empleado por año
GO
CREATE VIEW [Ventas Empleado Año] AS
    SELECT E.EmployeeID, YEAR(O.OrderDate) AS Año, SUM(OD.UnitPrice * OD.Quantity * (1-OD.Discount)) AS [Ventas]
    FROM Employees AS E
    INNER JOIN Orders AS O ON O.EmployeeID = E.EmployeeID
    INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
    GROUP BY E.EmployeeID, YEAR(O.OrderDate)
GO

SELECT VEA1.EmployeeID, VEA1.Año,  VEA2.Ventas AS [Ventas del año anterior], VEA1.Ventas [Ventas del año], (VEA1.Ventas - VEA2.Ventas) AS [Diferencia de ventas], 
		(100 * (VEA1.Ventas - VEA2.Ventas) / VEA1.Ventas) AS [Aumento/Disminucion(%)]
FROM [Ventas Empleado Año] AS VEA1

	INNER JOIN (-- Ventas de cada empleado en cada año
		SELECT E.EmployeeID, YEAR(O.OrderDate) AS Año, SUM(OD.UnitPrice * OD.Quantity * (1-OD.Discount)) AS [Ventas]
		FROM Employees AS E
		INNER JOIN Orders AS O ON O.EmployeeID = E.EmployeeID
		INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
		GROUP BY E.EmployeeID, YEAR(O.OrderDate)
	) AS VEA2

ON VEA1.EmployeeID = VEA2.EmployeeID AND VEA1.Año-1 = VEA2.Año --En la condicion del on se relaciona cada empleado con las ventas del año anterior
WHERE (100 * (VEA1.Ventas - VEA2.Ventas) / VEA1.Ventas) > 10  -- Se filtran los que tengan un aumento de más del 10%
ORDER BY EmployeeID
