USE Northwind
GO

--10. Producto superventas de cada año, indicando año, nombre del producto,
--categoría y cifra total de ventas.
SELECT P.ProductID,P.ProductName,P.CategoryID,Definitivo.Año,Definitivo.[Venta maxima] 
FROM Orders AS O

INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
INNER JOIN Products AS P ON OD.ProductID=P.ProductID
INNER JOIN 
		(
			SELECT MaxProducto.Año,MAX(MaxProducto.[Cifra de ventas]) AS [Venta maxima]
			FROM 
				(SELECT OD.ProductID,YEAR(O.OrderDate) AS [Año],SUM(OD.Quantity) [Cifra de ventas] 
					FROM Orders AS O

					INNER JOIN [Order Details] AS OD 
					ON O.OrderID=OD.OrderID

					GROUP BY OD.ProductID,YEAR(O.OrderDate)
				) AS MaxProducto 

			GROUP BY MaxProducto.Año

		) AS Definitivo 
		ON YEAR(O.OrderDate)=Definitivo.Año 

GROUP BY  P.ProductID,P.ProductName,P.CategoryID,Definitivo.Año,Definitivo.[Venta maxima]

HAVING SUM(OD.Quantity)=Definitivo.[Venta maxima]