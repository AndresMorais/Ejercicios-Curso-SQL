
/*update personEjemplo set Suffix=e.NationalIDNumber
from  [Person].[Person] p
inner join [HumanResources].[Employee] e
on e.BusinessEntityID=p.BusinessEntityID
where e.JobTitle='Sales Representative' */

WITH employee AS(
	SELECT 
	e.BusinessEntityID
	,e.NationalIDNumber
	FROM HumanResources.Employee e
	WHERE e.JobTitle='Sales Representative' 
)

UPDATE Person.Person SET Suffix=e.NationalIDNumber
FROM Person.Person P
INNER JOIN employee e
ON p.BusinessEntityID=e.BusinessEntityID

/*----------------------------------------
------------------------------------------
SECCION NUEVE: NOLOCK
------------------------------------------
----------------------------------------*/
BEGIN TRAN
	UPDATE Sales.SalesOrderHeader SET [Status]=4
	SELECT *
	FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Sales.SalesOrderDetail AS SOD ON SOH.SalesOrderID=SOD.SalesOrderID
	INNER JOIN Production.Product AS P on SOD.ProductID=P.ProductID
	INNER JOIN Production.ProductSubcategory AS PSC ON P.ProductSubcategoryID=PSC.ProductSubcategoryID
	CROSS JOIN Production.ProductCategory AS PC 
ROLLBACK TRAN --ROLLBACK deshace los cambios 


SELECT *
FROM Sales.SalesOrderHeader (NOLOCK) --NOLOCK PERMITE LEER UNA TABLA MIENTRAS SE ESTÁ ACTUALIZANDO. RIESGO: REALIZA UNA LECTARA SUCIA. 


/*----------------------------------------
------------------------------------------
SECCION NUEVE: WAITFOR
------------------------------------------
----------------------------------------*/


--WAITFOR=Permite introducion una 'espera' hasta que se valide una condición

BEGIN TRAN

	UPDATE Person.Person SET Suffix=e.NationalIDNumber
	FROM Person.Person P
	INNER JOIN HumanResources.employee e
	ON p.BusinessEntityID=e.BusinessEntityID
	WHERE e.JobTitle='Sales Representative' 

WAITFOR DELAY '00:00:07'
ROLLBACK TRAN 

SELECT * FROM HumanResources.employee (NOLOCK) --permite conusltar la tabla mientras se ejecuta la funcion WAITFOR


/*----------------------------------------
------------------------------------------
SECCION NUEVE: RAISERROR
------------------------------------------
----------------------------------------*/

--RAISERROR  permite controlar la salida que genera un error

/*
SELECT * FROM Sales.SalesPerson
SELECT * FROM Sales.SalesTerritory 
*/

BEGIN TRY 
SET NOCOUNT ON --- No aparece la leyenda de filas afectadas 
 INSERT INTO sales.SalesPerson
 VALUES (270,20,100,200,0,250000,20000,NEWID(),GETDATE())
END TRY -- TRY= función para intentar hacer un insert 

BEGIN CATCH
	RAISERROR ('Se fuerza el error dado que el segundo parametro de VALUE (20) no es un valir permitido porque el campo TerritoryID es una Foreing Key de la tabla Sales.SalesTerritory',16,1)
	--16 es la severidad del error
	--1 es informativo y refiere al modulo
END CATCH
	

/*-----------------------------------------------
-------------------------------------------------
SECCION NUEVE: ERROR PERSONALIZADO (sp_addmessage)
--------------------------------------------------
--------------------------------------------------*/

--Erros personalizados que son agregados a la tabla de errores del motor SQL
--ID ERROR > 50000
--SEVERITY 1 a 25

sp_addmessage 50001,16,'Error con la Foreing Key' --inserta el error en la tabla 

--sp_dropmessage 50001  --Elimina el error insertado en la tabla 


BEGIN TRY 
	SET NOCOUNT ON 
	INSERT INTO sales.SalesPerson
	VALUES (270,20,100,200,0,250000,20000,NEWID(),GETDATE())
END TRY

BEGIN CATCH
	RAISERROR (50001,-1,4)
	-- (-1) hace se tomo el valor de severity  definido en sp_addmessage. Se puede modificar
END CATCH

--Se puede validar el tipo de error con la funcion de sistama @@error. En siguiente ejemplo se toma el error 547, que es que devuelve por defecto al hacer el insert

BEGIN TRY 
	SET NOCOUNT ON 
	INSERT INTO sales.SalesPerson
	VALUES (270,20,100,200,0,250000,20000,NEWID(),GETDATE())
END TRY 

BEGIN CATCH
	IF @@ERROR=547
		RAISERROR (50001,-1,4)
	ELSE RAISERROR ('Error Generico',16,4)
END CATCH

--AGREGAR UN PARAMETRO AL ERROR

sp_addmessage 50001,16,'Error con la Foreing Key.Error en la tabla %s' --%s es donde va a colocar el parametro  

BEGIN TRY 
	SET NOCOUNT ON 
	INSERT INTO sales.SalesPerson
	VALUES (270,20,100,200,0,250000,20000,NEWID(),GETDATE())
END TRY 

BEGIN CATCH
	IF @@ERROR=547
		RAISERROR (50001,-1,4,'sales.SalesPerson') --lo que está entre '' es el parametro que inserta en %s
	ELSE RAISERROR ('Error Generico',16,4)
END CATCH