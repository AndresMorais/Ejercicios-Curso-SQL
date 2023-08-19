/*-----------------
-------------------
        CURSOREES
------------------
------------------*/

---CURSOR PARA INSERTAR REGISTROS EN UNA NUEVA TABLA 

/*
SELECT * FROM HumanResources.Employee;

UPDATE HumanResources.Employee SET CurrentFlag=1;

CREATE TABLE HumanResources.EmployeeList(
	NationalIDNumber VARCHAR (10),
	JobTitle VARCHAR (100));

*/


USE AdventureWorks2017
GO

--declaro las variables donde se almacena cada interaccion
DECLARE @var_NationalIDNumber VARCHAR (10), @var_JobTitle VARCHAR (100);

--declaro el cursor 
--DECLARE miCursor CURSOR FAST_FORWARD FOR  --FAST_FORWARD tiene la propiedad  de sólo lectura. Se quita esta propiedad para poder hacer ejecutar el UPDATE posterior 
DECLARE miCursor CURSOR FOR
	SELECT 
		NationalIDNumber 
		,JobTitle
	FROM  HumanResources.Employee
	WHERE Gender='M';

--leo el primer registro  y almaceno los campos en las variables
OPEN miCursor
FETCH NEXT FROM miCursor
INTO @var_NationalIDNumber , @var_JobTitle

WHILE @@FETCH_STATUS=0   -- @@FETCH_STATUS es una variable de sistema, Mientras sea =0 significa que no llegó al final de la tabla
	BEGIN
		INSERT INTO HumanResources.EmployeeList VALUES (@var_NationalIDNumber , @var_JobTitle)
		UPDATE HumanResources.Employee SET CurrentFlag=0
		WHERE CURRENT OF miCursor

		FETCH NEXT FROM miCursor --pasamos al siguiente registro
		INTO @var_NationalIDNumber , @var_JobTitle
	END 
CLOSE miCursor
DEALLOCATE miCursor -- elimina de la memoria el cursor.

--SELECT * FROM HumanResources.EmployeeList











