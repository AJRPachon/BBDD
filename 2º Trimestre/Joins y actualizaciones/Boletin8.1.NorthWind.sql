
USE Northwind
GO


--1. Nombre del pa�s y n�mero de clientes de cada pa�s, ordenados alfab�ticamente por el nombre del pa�s.
SELECT * FROM Customers

SELECT Country,	COUNT(CustomerID) As 'Clientes por pais'
FROM Customers
GROUP BY Country
ORDER BY Country;
GO


--2. ID de producto y n�mero de unidades vendidas de cada producto. 
SELECT * FROM [Order Details]

SELECT ProductID, SUM(Quantity) AS 'Numero de unidades'
FROM [Order Details] 
GROUP BY ProductID
ORDER BY ProductID;
GO


--3. ID del cliente y n�mero de pedidos que nos ha hecho.
SELECT * FROM Orders

SELECT COUNT(OrderID) AS NumPedidos, CustomerID
FROM Orders
GROUP BY CustomerID;
GO


--4. ID del cliente, a�o y n�mero de pedidos que nos ha hecho cada a�o.
SELECT * FROM Orders

SELECT CustomerID, COUNT(OrderID) AS NumPedidos, YEAR(OrderDate) AS Fecha
FROM Orders
GROUP BY CustomerID, YEAR(OrderDate)
GO


--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. Si hay varios 
--precios unitarios para el mismo producto tomaremos el mayor.
SELECT* FROM Products

SELECT ProductID, MAX(UnitPrice) AS 'Precio m�ximo', SUM(UnitPrice * Quantity) AS 'Total facturado'
FROM [Order Details]
GROUP BY SUM(UnitPrice * Quantity)
GO
--MIRAR--

--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.
SELECT * FROM Products

SELECT	SupplierID, SUM(UnitsOnOrder * UnitPrice) AS ImporteTotal
FROM Products
GROUP BY SupplierID


--7. N�mero de pedidos registrados mes a mes de cada a�o.
SELECT * FROM Orders

SELECT COUNT(OrderID) AS [Cantidad de pedido], MONTH(OrderDate) AS Mes, YEAR(OrderDate) AS A�o	
FROM Orders
GROUP BY MONTH(OrderDate), YEAR(OrderDate)
ORDER BY YEAR(OrderDate), MONTH(OrderDate)
GO


--8. A�o y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos 
--enviado (ShippedDate), en d�as para cada a�o.
SELECT * FROM Orders

SELECT AVG (DATEDIFF(DAY, OrderDate, ShippedDate)) AS Media, YEAR(OrderDate) AS A�o
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY A�o;
GO


--9. ID del distribuidor y n�mero de pedidos enviados a trav�s de ese distribuidor.
SELECT * FROM Orders

SELECT ShipVia, COUNT(*) AS 'Numero de pedidos'
FROM Orders
GROUP BY ShipVia
GO

--10. ID de cada proveedor y n�mero de productos distintos que nos suministra.
SELECT * FROM Products

SELECT	SupplierID AS Proveedor, COUNT(DISTINCT ProductID) AS ProductosDistintos
FROM Products
GROUP BY SupplierID;



