--En la base de datos NorthWind. Para comprobar si una tabla existe puedes utilizar la función OBJECT_ID

USE Northwind

--Ejercicios

--1. Deseamos incluir un producto en la tabla Products llamado "Cruzcampo lata” pero no estamos seguros si se ha insertado o no.
--El precio son 4,40, el proveedor es el 16, la categoría 1 y la cantidad por unidad es "Pack 6 latas” "Discontinued” toma el valor 0 y 
--el resto de columnas se dejarán a NULL.
--Escribe un script que compruebe si existe un producto con ese nombre. En caso afirmativo, actualizará el precio y en caso negativo insertarlo. 


SELECT * FROM Products
WHERE ProductName = 'Cruzcampo lata'

BEGIN TRANSACTION
IF EXISTS (SELECT * FROM Products	WHERE ProductName = 'Cruzcampo lata')
	BEGIN 
		UPDATE Products
		SET UnitPrice = 4.40
		WHERE ProductName = 'Cruzcampo lata'
	END

ELSE
	BEGIN
		PRINT 'El producto no existe, se procede a su creación'
		INSERT INTO Products ( ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
		VALUES ('Cruzcampo lata', 16, 1, 'Pack 6 latas', 4.40, NULL, NULL, NULL, 0)
	END

--ROLLBACK
--COMMIT




--2. Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada producto el ID, el Nombre, el Precio unitario, el número
-- total de unidades vendidas y el total de dinero facturado con ese producto. Si no existe, créala 

BEGIN TRANSACTION 
IF OBJECT_ID ('dbo.ProductSales') IS NOT NULL  --Para comprobar si existe la tabla.
	BEGIN
		PRINT 'Esta tabla existe'
	END

ELSE
	BEGIN
	PRINT 'La tabla no existe, se procede a su creación'
	CREATE TABLE ProductSales
		(ProductID INT NOT NULL,
		 ProductName VarChar(40) NOT NULL,
		 UnitPrice INT NOT NULL,
		 TotalUnitsSold INT NOT NULL,
		 TotalMoney INT NOT NULL
		)
	END
	
SELECT * FROM ProductSales
--ROLLBACK
--COMMIT




--3. Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada Transportista el ID, el Nombre de la compañía, el 
--número total de envíos que ha efectuado y el número de países diferentes a los que ha llevado cosas. Si no existe, créala 

BEGIN TRANSACTION 
IF OBJECT_ID ('dbo.ShipShip') IS NOT NULL  --Para comprobar si existe la tabla.
	BEGIN
		PRINT 'Esta tabla existe'
	END

ELSE
	BEGIN
	PRINT 'La tabla no existe, se procede a su creación'
	CREATE TABLE ShipShip
		(TransportistID INT NOT NULL,
		 TransportistName VarChar(50) NOT NULL,
		 CompanyName VarChar(40) NOT NULL,
		 TotalShips INT NOT NULL,
		 CountriesNum INT NOT NULL,
		)
	END
	
SELECT * FROM ShipShip

--ROLLBACK
--COMMIT




--4. Comprueba si existe una tabla llamada EmployeeSales. Esta tabla ha de tener de cada empleado su ID, el Nombre completo, el número de
-- ventas totales que ha realizado, el número de clientes diferentes a los que ha vendido y el total de dinero facturado. Si no existe, créala

BEGIN TRANSACTION 
IF OBJECT_ID ('dbo.EmployeeSales') IS NOT NULL  --Para comprobar si existe la tabla.
	BEGIN
		PRINT 'Esta tabla existe'
	END

ELSE
	BEGIN
	PRINT 'La tabla no existe, se procede a su creación'
	CREATE TABLE EmployeeSales
		(EmployeeID INT NOT NULL,
		 EmployeeName VarChar(50) NOT NULL,
		 TotalSells INT NOT NULL,
		 NumDifCustomers INT NOT NULL,
		 TotalMoney INT NOT NULL,
		)
	END

SELECT * FROM EmployeeSales

--ROLLBACK
--COMMIT





--5. Entre los años 96 y 97 hay productos que han aumentado sus ventas y otros que las han disminuido. Queremos cambiar el precio unitario según
-- la siguiente tabla: 

--Incremento de ventas      Incremento de precio
--Negativo                         -10%
--Entre 0 y 10%                   No varía
--Entre 10% y 50%                   +5%
--Mayor del 50%            10% con un máximo de 2,25

SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders

--Coger total de ventas de cada año  --FLOOR Para coger decimales de un resultado. Según opr el múltiplo de 10 que se * o / dará más decimales o menos 

SELECT DISTINCT YEAR(O.OrderDate) AS Año, FLOOR(SUM(OD.Quantity  * (OD.UnitPrice*(1-OD.Discount))) * 100) /100 AS [Ventas del 96]  FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY OrderDate
HAVING YEAR(OrderDate) = 1996


SELECT DISTINCT YEAR(O.OrderDate) AS Año, FLOOR(SUM(OD.Quantity  * (OD.UnitPrice*(1-OD.Discount))) * 100) /100 AS [Ventas del 97]  FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY OrderDate
HAVING YEAR(OrderDate) = 1997

