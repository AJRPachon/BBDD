
USE Northwind
GO

--1.-Inserta un nuevo cliente.

SELECT * FROM Customers
WHERE CustomerID = 'AJRP'

BEGIN TRANSACTION
INSERT INTO Customers (CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax)
VALUES ('AJRP', 'Rutulus S.L.', 'Antonio J. Ramirez', 'Owner', 'C/Pueblos blancos', 'Sevilla', 'ALJF', 41920, 'Spain', 685841595, '82.54.26.57' )

ROLLBACK


--2.- Véndele (hoy) tres unidades de "Pavlova”, diez de "Inlagd Sill” y 25 de "Filo Mix”. El distribuidor será Speedy Express y 
--	el vendedor Laura Callahan.

SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM Employees
WHERE LastName = 'Callahan' AND FirstName = 'Laura'

SELECT * FROM [Order Details]
SELECT * FROM Products
WHERE ProductName = 'Inlagd Sill'

INSERT INTO 
SELECT * FROM Customers AS C 
INNER JOIN Orders AS O  ON C.CustomerID = O.CustomerID

--3.- Ante la bajada de ventas producida por la crisis, hemos de adaptar nuestros precios según las siguientes reglas:
--	Los productos de la categoría de bebidas (Beverages) que cuesten más de $10 reducen su precio en un dólar.
--	Los productos de la categoría Lácteos que cuesten más de $5 reducen su precio en un 10%.
--	Los productos de los que se hayan vendido menos de 200 unidades en el último año, reducen su precio en un 5%




--4.- Inserta un nuevo vendedor llamado Michael Trump. Asígnale los territorios de Louisville, Phoenix, Santa Cruz y Atlanta.




--5.- Haz que las ventas del año 97 de Robert King que haya hecho a clientes de los estados de California y Texas se le asignen al nuevo empleado.




--6.- Inserta un nuevo producto con los siguientes datos:
--	ProductID: 90
--	ProductName: Nesquick Power Max
--	SupplierID: 12
--	CategoryID: 3
--	QuantityPerUnit: 10 x 300g
--	UnitPrice: 2,40
--	UnitsInStock: 38
--	UnitsOnOrder: 0
--	ReorderLevel: 0
--	Discontinued: 0

SELECT * FROM Products

BEGIN TRANSACTION 

SET IDENTITY_INSERT dbo.Products ON --Para activar que se puedan meter ID de manera manual

INSERT INTO Products (ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
VALUES (90, 'Nesquick Power Max', 12, 3, '10 x 300g', '2,40', 38, 0, 0, 0)

SELECT * FROM Products
WHERE ProductID = 90

ROLLBACK


--7.- Inserta un nuevo producto con los siguientes datos:
--	ProductID: 91
--	ProductName: Mecca Cola
--	SupplierID: 1
--	CategoryID: 1
--	QuantityPerUnit: 6 x 75 cl
--	UnitPrice: 7,35
--	UnitsInStock: 14
--	UnitsOnOrder: 0
--	ReorderLevel: 0
--	Discontinued: 0

BEGIN TRANSACTION

SELECT * FROM Products

INSERT INTO Products (ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
VALUES ( 91, 'Mecca Cola', 1, 1, '6 x 75 cl', '7,35', 14, 0, 0, 0 )

ROLLBACK


--8.- Todos los que han comprado "Outback Lager" han comprado cinco años después la misma cantidad de Mecca Cola al mismo vendedor




--9.- El pasado 20 de enero, Margaret Peacock consiguió vender una caja de Nesquick Power Max a todos los clientes que le habían 
--	comprado algo anteriormente. Los datos de envío (dirección, transportista, etc) son los mismos de alguna de sus ventas anteriores a ese cliente).

