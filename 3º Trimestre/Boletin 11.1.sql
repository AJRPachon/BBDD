--En la base de datos NorthWind. Para comprobar si una tabla existe puedes utilizar la funci�n OBJECT_ID

USE Northwind

--Ejercicios

--1. Deseamos incluir un producto en la tabla Products llamado "Cruzcampo lata� pero no estamos seguros si se ha insertado o no.
--El precio son 4,40, el proveedor es el 16, la categor�a 1 y la cantidad por unidad es "Pack 6 latas� "Discontinued� toma el valor 0 y 
--el resto de columnas se dejar�n a NULL.
--Escribe un script que compruebe si existe un producto con ese nombre. En caso afirmativo, actualizar� el precio y en caso negativo insertarlo. 


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
		PRINT 'El producto no existe, se procede a su creaci�n'
		INSERT INTO Products ( ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
		VALUES ('Cruzcampo lata', 16, 1, 'Pack 6 latas', 4.40, NULL, NULL, NULL, 0)
	END

--ROLLBACK
--COMMIT




--2. Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada producto el ID, el Nombre, el Precio unitario, el n�mero
-- total de unidades vendidas y el total de dinero facturado con ese producto. Si no existe, cr�ala 

BEGIN TRANSACTION 
IF OBJECT_ID ('dbo.ProductSales') IS NOT NULL  --Para comprobar si existe la tabla.
	BEGIN
		PRINT 'Esta tabla existe'
	END

ELSE
	BEGIN
	PRINT 'La tabla no existe, se procede a su creaci�n'
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




--3. Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada Transportista el ID, el Nombre de la compa��a, el 
--n�mero total de env�os que ha efectuado y el n�mero de pa�ses diferentes a los que ha llevado cosas. Si no existe, cr�ala 

BEGIN TRANSACTION 
IF OBJECT_ID ('dbo.ShipShip') IS NOT NULL  --Para comprobar si existe la tabla.
	BEGIN
		PRINT 'Esta tabla existe'
	END

ELSE
	BEGIN
	PRINT 'La tabla no existe, se procede a su creaci�n'
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




--4. Comprueba si existe una tabla llamada EmployeeSales. Esta tabla ha de tener de cada empleado su ID, el Nombre completo, el n�mero de
-- ventas totales que ha realizado, el n�mero de clientes diferentes a los que ha vendido y el total de dinero facturado. Si no existe, cr�ala

BEGIN TRANSACTION 
IF OBJECT_ID ('dbo.EmployeeSales') IS NOT NULL  --Para comprobar si existe la tabla.
	BEGIN
		PRINT 'Esta tabla existe'
	END

ELSE
	BEGIN
	PRINT 'La tabla no existe, se procede a su creaci�n'
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





--5. Entre los a�os 96 y 97 hay productos que han aumentado sus ventas y otros que las han disminuido. Queremos cambiar el precio unitario seg�n
-- la siguiente tabla: 

--Incremento de ventas      Incremento de precio
--Negativo                         -10%
--Entre 0 y 10%                   No var�a
--Entre 10% y 50%                   +5%
--Mayor del 50%            10% con un m�ximo de 2,25

SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders

--Coger total de ventas de cada a�o  --FLOOR Para coger decimales de un resultado. Seg�n opr el m�ltiplo de 10 que se * o / dar� m�s decimales o menos 

USE Northwind

GO
CREATE VIEW [Ventas totales 1996] AS 
SELECT OD.ProductID, FLOOR(SUM(OD.Quantity  * (OD.UnitPrice*(1-OD.Discount))) * 100) /100 AS [Ventas del 96], YEAR(O.OrderDate) AS A�o FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY OD.ProductID, YEAR(O.OrderDate)
HAVING YEAR(O.OrderDate) = 1996
GO

GO
CREATE VIEW [Ventas totales 1997] AS
SELECT OD.ProductID , FLOOR(SUM(OD.Quantity  * (OD.UnitPrice*(1-OD.Discount))) * 100) /100 AS [Ventas del 97], YEAR(O.OrderDate) AS A�o FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY OD.ProductID, YEAR(O.OrderDate)
HAVING YEAR(OrderDate) = 1997
GO
 
GO
CREATE VIEW [DifVentas] AS
SELECT VT97.ProductID AS IDProducto, FLOOR((((VT97.[Ventas del 97] / VT96.[Ventas del 96])-1)*100)*100)/100 AS Incremento FROM [Ventas totales 1996] AS VT96
	INNER JOIN [Ventas totales 1997] AS VT97 ON VT96.ProductID = VT97.ProductID
GO

BEGIN TRANSACTION
UPDATE Products 
	
SET UnitPrice = CASE

	WHEN DifVentas.Incremento < 0 THEN (UnitPrice - UnitPrice * 0.01)
	WHEN DifVentas.Incremento BETWEEN 0 AND 10 THEN UnitPrice
	WHEN DifVentas.Incremento BETWEEN 10 AND 50 THEN (UnitPrice + UnitPrice * 0.05)
	WHEN DifVentas.Incremento > 50 THEN 
		CASE WHEN UnitPrice * 0.1 > 2.25 THEN (UnitPrice + 2.25) 
			ELSE UnitPrice * 1.1
		END
END

FROM DifVentas

WHERE ProductID = DifVentas.IDProducto

--ROLLBACK
--COMMIT
SELECT * FROM Products
