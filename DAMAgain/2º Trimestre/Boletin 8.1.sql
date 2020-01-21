USE Northwind
GO

--1. Nombre del pa�s y n�mero de clientes de cada pa�s, ordenados alfab�ticamente por el nombre del pa�s.

	SELECT * FROM Customers

	SELECT Country, COUNT(CustomerID) AS [Numero de clientes por pais] FROM Customers
	GROUP BY Country
	ORDER BY Country

--2. ID de producto y n�mero de unidades vendidas de cada producto. 

	SELECT * FROM [Order Details]

	SELECT ProductID, COUNT(Quantity) AS [Numero unidades vendidas] FROM [Order Details]
	GROUP BY ProductID


--3. ID del cliente y n�mero de pedidos que nos ha hecho.

	SELECT * FROM Orders

	SELECT CustomerID, COUNT(CustomerID) AS [Numero de pedidos realizados]  FROM Orders
	WHERE CustomerID != 'NULL'
	GROUP BY CustomerID
	

--4. ID del cliente, a�o y n�mero de pedidos que nos ha hecho cada a�o.

	SELECT * FROM Orders
	
	SELECT CustomerID, YEAR(OrderDate) AS A�o, COUNT(YEAR(OrderDate)) AS [Numero de pedidos cada a�o] FROM Orders 
	WHERE CustomerID != 'NULL'
	GROUP BY CustomerID, YEAR(OrderDate)
	ORDER BY CustomerID, YEAR(OrderDate)


--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. Si hay varios precios unitarios para el mismo producto tomaremos el mayor.

	SELECT * FROM [Order Details]

	SELECT ProductID, UnitPrice, SUM(UnitPrice*Quantity) AS [Total facturado] FROM [Order Details]
	GROUP BY ProductID, UnitPrice
	ORDER BY [Total facturado] DESC


--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.

	SELECT * FROM Products
	
	SELECT SupplierID, SUM(UnitPrice*UnitsInStock) AS [Importe total del stock] FROM Products
	GROUP BY SupplierID


--7. N�mero de pedidos registrados mes a mes de cada a�o.

	SELECT * FROM Orders

	SELECT COUNT(CustomerID) AS [Numero de pedidos] ,MONTH(OrderDate) AS Mes FROM Orders
	GROUP BY MONTH(OrderDate), YEAR(OrderDate)
	HAVING YEAR(OrderDate) = '1996'

	SELECT COUNT(CustomerID) AS [Numero de pedidos] ,MONTH(OrderDate) AS Mes FROM Orders
	GROUP BY MONTH(OrderDate), YEAR(OrderDate)
	HAVING YEAR(OrderDate) = '1997'

	SELECT COUNT(CustomerID) AS [Numero de pedidos] ,MONTH(OrderDate) AS Mes FROM Orders
	GROUP BY MONTH(OrderDate), YEAR(OrderDate)
	HAVING YEAR(OrderDate) = '1998'


--8. A�o y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en d�as para cada a�o.

	SELECT * FROM Orders

	SELECT YEAR(OrderDate) AS A�o ,AVG(DATEDIFF(DAY,OrderDate, ShippedDate)) AS [D�as medio transcurridos] FROM Orders
	GROUP BY YEAR(OrderDate)
	ORDER BY YEAR(OrderDate) ASC
	

--9. ID del distribuidor y n�mero de pedidos enviados a trav�s de ese distribuidor.

	SELECT * FROM Suppliers

	SELECT * FROM Suppliers



--10. ID de cada proveedor y n�mero de productos distintos que nos suministra.