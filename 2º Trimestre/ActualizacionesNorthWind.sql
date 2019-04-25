USE Northwind


--1- Inserta un nuevo cliente.
BEGIN TRANSACTION 
INSERT INTO Customers(CustomerID, CompanyName, ContactName, ContactTitle, [Address], City, Region, PostalCode, Country, Phone, Fax)
VALUES ('ACEIT', 'Aceitunas Manolo', 'Aceituna Guacha', 'Aceituna�s Administrator', 'C/Olivo n4', 'OlivarDeQuintos', 'OLV', 'OL1 VA5',
		 'Spain', '656656565', '92.23.13.54')

SELECT * FROM Customers
WHERE CustomerID = 'ACEIT'

ROLLBACK


--2- V�ndele (hoy) tres unidades de "Pavlova�, diez de "Inlagd Sill� y 25 de "Filo Mix�. El distribuidor ser� Speedy Express y 
-- el vendedor Laura Callahan.

SELECT * FROM Products
WHERE ProductName IN ('Pavlova','Inlagd Sill','Filo Mix')

SELECT * FROM Shippers
WHERE CompanyName = 'Speedy Express'

SELECT EmployeeID FROM Employees
WHERE FirstName = 'Laura' AND LastName = 'Callahan'

--A�adir fecha de hoy
BEGIN TRANSACTION
DECLARE @ORDERID INT  --EJECUTAR DESDE AQU� HASTA EL FINAL DE LOS PRODUCTOS A�ADIDOS.

INSERT INTO Orders ([CustomerID], [EmployeeID], [OrderDate], [RequiredDate], [ShippedDate], [ShipVia], [Freight], [ShipName], [ShipAddress],
			[ShipCity], [ShipRegion], [ShipPostalCode], [ShipCountry])
SELECT DISTINCT 'ACEIT', EmployeeID, CURRENT_TIMESTAMP, '2019-04-05 00:00:00.000', NULL, ShipperID, NULL, 'Aceitunas Manolo', 'C/Olivo n4', 
				'OlivarDeQuintos', 'OLV', 'OL1 VA5', 'Spain'  
				
FROM Employees
	CROSS JOIN Shippers
WHERE FirstName = 'Laura' AND LastName = 'Callahan' AND CompanyName = 'Speedy Express'

SET @ORDERID = @@IDENTITY  --Devuelve el �ltimo ID Identity generado.


--Insertar productos en OrderDetail  //  Coger el ID de Orders 

INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)

SELECT @ORDERID, P.ProductID, P.UnitPrice, 3, 0
FROM Products AS P
WHERE P.ProductName = 'Pavlova'


INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)

SELECT @ORDERID, P.ProductID, P.UnitPrice, 10, 0
FROM Products AS P
WHERE P.ProductName = 'Inlagd Sill'


INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)

SELECT @ORDERID, P.ProductID, P.UnitPrice, 25, 0
FROM Products AS P
WHERE P.ProductName = 'Filo Mix'

--EJECUTAR HASTA AQU�
--COMMIT

SELECT * FROM [Order Details]
GO

rollback

--3- Ante la bajada de ventas producida por la crisis, hemos de adaptar nuestros precios seg�n las siguientes reglas:
--	Los productos de la categor�a de bebidas (Beverages) que cuesten m�s de $10 reducen su precio en un d�lar.
--	Los productos de la categor�a L�cteos que cuesten m�s de $5 reducen su precio en un 10%.
--	Los productos de los que se hayan vendido menos de 200 unidades en el �ltimo a�o, reducen su precio en un 5%

--Productos Beverages cuestan m�s $10 reducen su precio $1
SELECT ProductName, UnitPrice FROM Products
WHERE CategoryID = 1 AND UnitPrice > 10

SELECT * FROM Products
BEGIN TRANSACTION
UPDATE Products
SET
	UnitPrice = UnitPrice -1
FROM Products AS P 
	INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
WHERE P.UnitPrice > 10 AND C.CategoryName = 'Beverages'
--COMMIT
--ROLLBACK


--Productos lacteos $5 reducen su precio 10%
SELECT ProductName, UnitPrice FROM Products
WHERE CategoryID = 4 AND UnitPrice > 5

BEGIN TRANSACTION 
UPDATE Products
SET
	UnitPrice = UnitPrice * 0.90
FROM Products AS P
	INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
WHERE C.CategoryName = 'Dairy Products' AND P.UnitPrice > 5
--COMMIT
--ROLLBACK


--Productos menos 200 unidades en el �ltimo a�o reducen precio 5%
GO
ALTER VIEW [Menos 200 unidades] AS
SELECT OD.OrderID, SUM(OD.Quantity) AS Cantidad, YEAR(O.OrderDate) AS [�ltimo a�o]
FROM [Order Details] AS OD
	INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID
GROUP BY OD.OrderID, O.OrderDate
HAVING SUM(OD.Quantity) < 200 AND YEAR(O.OrderDate) = 1998
GO

--UPDATE con la consulta anterior en el WHERE
GO
BEGIN TRANSACTION
UPDATE [Order Details]
SET
	UnitPrice = OD.UnitPrice - (OD.UnitPrice * 0.05)
FROM [Order Details] AS OD
	INNER JOIN Products AS P  ON OD.ProductID = P.ProductID
	INNER JOIN Orders AS O  ON OD.OrderID = O.OrderID
	INNER JOIN [Menos 200 unidades] AS M200U  ON O.OrderID = M200U.OrderID
WHERE M200U.Cantidad < 200 AND M200U.[�ltimo a�o] = 1998

--ROLLBACK
--COMMIT



--4- Inserta un nuevo vendedor llamado Michael Trump. As�gnale los territorios de Louisville, Phoenix, Santa Cruz y Atlanta.

BEGIN TRANSACTION
DECLARE @EmployeeID INT --Declaro el EmployeID para coger la �ltima ID generada
--SET IDENTITY_INSERT Employees ON solo se pone si queremos modificar manualmente el Identity
INSERT INTO Employees ( LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, 
						HomePhone, Extension, Photo, Notes, ReportsTo, PhotoPath ) --Quitamos employeeID ya que se genera solo (Identity)

VALUES ( 'Trump', 'Michael', 'Sales Representative', 'Mr.', NULL, '2019-04-08 00:00:00.000', '11 Sinclair Road', 'London', 
		'NULL', 'W14 0NS', 'UK', '(71)654-8765', '1111', NULL, 'He is a really nice guy', '2', NULL )

SET @EmployeeID = @@IDENTITY

--Insertamos en ET el ID del empleado y el territorio, poniendo en el WHERE los territorios que nos pide
INSERT INTO EmployeeTerritories (EmployeeID, TerritoryID)
SELECT @EmployeeID, T.TerritoryID
FROM Territories AS T
	INNER JOIN EmployeeTerritories AS ET  ON T.TerritoryID = ET.TerritoryID
	INNER JOIN Employees AS E  ON ET.EmployeeID = E.EmployeeID
WHERE TerritoryDescription IN ( 'Louisville', 'Phoenix', 'Santa Cruz', 'Atlanta' )

--EJECUTAR HASTA AQU� (Ya que tenemos declarado un @EmployeeID)
--COMMIT
--ROLLBACK
SELECT * FROM EmployeeTerritories
WHERE EmployeeID = '10'




--5- Haz que las ventas del a�o 97 de Robert King que haya hecho a clientes de los estados de California y Texas se le asignen al nuevo empleado.

--SELECT * FROM Employees
--WHERE LastName = 'King'

--SELECT DISTINCT YEAR(OrderDate) AS [A�o] FROM Orders
--GROUP BY OrderDate
--HAVING YEAR(OrderDate) = 1997

--SELECT * FROM Customers
--WHERE Region = 'CA'

--SELECT * FROM Orders
--WHERE EmployeeID = 10

--(SELECT TOP 1 EmployeeID FROM Employees ORDER BY EmployeeID DESC)  Se coge el �ltimo EmployeeID

BEGIN TRANSACTION
UPDATE Orders
SET
	EmployeeID = (SELECT TOP 1 EmployeeID FROM Employees ORDER BY EmployeeID DESC)
FROM Orders AS O
	INNER JOIN Employees AS E  ON O.EmployeeID = E.EmployeeID
WHERE E.FirstName = 'Robert' AND E.LastName = 'King' AND YEAR(OrderDate) = 1997 


--ROLLBACK
--COMMIT







--6- Inserta un nuevo producto con los siguientes datos:
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




--7- Inserta un nuevo producto con los siguientes datos:
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





--8- Todos los que han comprado "Outback Lager" han comprado cinco a�os despu�s la misma cantidad de Mecca Cola al mismo vendedor.



--9- El pasado 20 de enero, Margaret Peacock consigui� vender una caja de Nesquick Power Max a todos los clientes que le hab�an comprado 
--  algo anteriormente. Los datos de env�o (direcci�n, transportista, etc) son los mismos de alguna de sus ventas anteriores a ese cliente).





--CONSULTAS
--Vista que nos devuelva los nombres de todos los clientes que nos han comprado alg�n  producto de la categor�a "Dairy Products�, 
--as� como las fechas de la primera y la �ltima compra. 
--Adem�s de todo lo anterior, queremos saber tambi�n el nombre del distribuidor con el que hicimos el env�o. Si hay varios 
--pedidos para el mismo cliente, tomar el distribuidor con el que hicimos el primero de ellos.
--Vista que nos devuelva nombre, ID y n�mero de unidades vendidas de cada producto en el a�o 1997. 
--Modifica la vista anterior para incluir tambi�n los productos de los que no hayamos vendido nada, especificando "0� en las unidades
 