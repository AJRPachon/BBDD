USE Northwind
GO
--1. Nombre de la compañía y dirección completa (dirección, cuidad, país)
-- de todos los clientes que no sean de los Estados Unidos.
SELECT CompanyName, [Address], City, Country
FROM Customers
WHERE country != 'USA';
GO

--2. La consulta anterior ordenada por país y ciudad. 
SELECT CompanyName, [Address], City, Country
FROM Customers
WHERE Country != 'USA'
ORDER BY Country, City;
GO

--3. Nombre, Apellidos, Ciudad y Edad de todos los empleados, ordenados por antigüedad en la empresa.
SELECT	LastName, FirstName, City, (year (CURRENT_TIMESTAMP - BirthDate) - 1900) AS Edad
FROM Employees
ORDER BY HireDate;
GO

--4. Nombre y precio de cada producto, ordenado de mayor a menor precio.
SELECT ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice;
GO

--5. Nombre de la compañía y dirección completa de cada proveedor de algún país de América del Norte.
SELECT CompanyName, [Address], City, Country
FROM Suppliers
WHERE Country = 'Mexico' OR Country = 'Canada' OR Country = 'USA';
GO

--6. Nombre del producto, número de unidades en stock y valor total del stock,
--	de los productos que NO sean de la categoría 4.
SELECT ProductName, UnitsInStock, UnitsOnOrder, (UnitsInStock - UnitsOnOrder) AS Valor_total_del_stock
FROM Products;
GO

--7. Clientes (Nombre de la Compañía, dirección completa, persona de contacto) que no residan en un país de
--  América del Norte y que la persona de contacto no sea el propietario de la compañía 
SELECT CompanyName, [Address], City, Country, ContactName
FROM Customers
WHERE Country != 'USA' AND Country != 'Canada' AND Country != 'Mexico' AND ContactTitle NOT LIKE 'Owner%';
GO

--8. ID del cliente y número de pedidos realizados por cada cliente, ordenado de mayor a menor número de pedidos.
SELECT CustomerID, COUNT(OrderID) AS NumeroDePedidos
FROM Orders
GROUP BY CustomerID
ORDER BY NumeroDePedidos DESC
GO

--9. Número de pedidos enviados a cada ciudad, incluyendo el nombre de la ciudad. 
SELECT COUNT(OrderID) AS NumeroPedidosEnviados, ShipCity
FROM Orders
GROUP BY ShipCity;
GO

--10. Número de productos de cada categoría.
SELECT CategoryID, COUNT(ProductName) AS NumeroProductos
FROM Products
GROUP BY CategoryID;
GO