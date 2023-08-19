/*----------------------------------------
------------------------------------------
SECCION OCHO: PIVOT - UNPIVOT
------------------------------------------
----------------------------------------*/
USE AdventureWorks2017
GO

/*
SELECT * FROM Sales.SalesOrderHeader --SalesOrderID, OrderDate
SELECT * FROM Sales.SalesOrderDetail --SalesOrderID,ProductID
SELECT * FROM Production.Product --ProductID , ProductSubcategoryID
SELECT * FROM Production.ProductSubcategory --ProductSubcategoryID,ProductCategoryID
SELECT * FROM Production.ProductCategory --ProductCategoryID,Name
*/

---PIVOT

WITH ventasPorCategoria AS(
	SELECT 
		DISTINCT DATEPART(YEAR, SOH.OrderDate) AS anio
		,PC.[Name] AS categoria
		,P.ProductID
	FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Sales.SalesOrderDetail AS SOD ON SOH.SalesOrderID=SOD.SalesOrderID
	INNER JOIN Production.Product AS P on SOD.ProductID=P.ProductID
	INNER JOIN Production.ProductSubcategory AS PSC ON P.ProductSubcategoryID=PSC.ProductSubcategoryID
	INNER JOIN Production.ProductCategory AS PC ON PSC.ProductCategoryID=PC.ProductCategoryID 
)
SELECT * FROM ventasPorCategoria
PIVOT (COUNT(ProductID) FOR anio IN ([2014],[2013],[2011])) AS pivotTable
ORDER BY categoria;


---UNPIVOT

WITH ventasPorCategoria AS(
	SELECT 
		DISTINCT DATEPART(YEAR, SOH.OrderDate) AS anio
		,PC.[Name] AS categoria
		,P.ProductID
	FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Sales.SalesOrderDetail AS SOD ON SOH.SalesOrderID=SOD.SalesOrderID
	INNER JOIN Production.Product AS P on SOD.ProductID=P.ProductID
	INNER JOIN Production.ProductSubcategory AS PSC ON P.ProductSubcategoryID=PSC.ProductSubcategoryID
	INNER JOIN Production.ProductCategory AS PC ON PSC.ProductCategoryID=PC.ProductCategoryID 
)
SELECT * FROM ventasPorCategoria
PIVOT (COUNT(ProductID) FOR anio IN ([2014],[2013],[2011])) AS pivotTable
UNPIVOT (ProductID  FOR anio IN ([2014],[2013],[2011])) AS unPivotTable;
