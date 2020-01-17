USE Northwind
GO

--1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.

	SELECT * FROM Customers

	SELECT Country, COUNT(CustomerID) AS [Numero de clientes por pais] FROM Customers
	GROUP BY Country
	ORDER BY Country

--2. ID de producto y número de unidades vendidas de cada producto. 

	SELECT * FROM [Order Details]

	SELECT ProductID, COUNT(Quantity) AS [Numero unidades vendidas] FROM [Order Details]
	GROUP BY ProductID


--3. ID del cliente y número de pedidos que nos ha hecho.

	SELECT * FROM Orders

	SELECT CustomerID, COUNT(CustomerID) AS [Numero de pedidos realizados]  FROM Orders
	WHERE CustomerID != 'NULL'
	GROUP BY CustomerID
	

--4. ID del cliente, año y número de pedidos que nos ha hecho cada año.

	SELECT * FROM Orders
	
	SELECT CustomerID, YEAR(OrderDate) AS Año, COUNT(YEAR(OrderDate)) AS [Numero de pedidos cada año] FROM Orders 
	WHERE CustomerID != 'NULL'
	GROUP BY CustomerID, YEAR(OrderDate)
	ORDER BY CustomerID, YEAR(OrderDate)


--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. Si hay varios precios unitarios para el mismo producto tomaremos el mayor.

	SELECT * FROM [Order Details]

	SELECT ProductID, UnitPrice, SUM(UnitPrice*Quantity) AS [Total facturado] FROM [Order Details]
	GROUP BY ProductID, UnitPrice

--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.


--7. Número de pedidos registrados mes a mes de cada año.


--8. Año y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en días para cada año.


--9. ID del distribuidor y número de pedidos enviados a través de ese distribuidor.


--10. ID de cada proveedor y número de productos distintos que nos suministra.