/*-----------------
-------------------
PAGINADO
------------------
------------------*/

DECLARE @pageNumber as int
		,@pageSize as int
		,@totalPages as int

SET @pageNumber=0
SET @pageSize=10
SET @totalPages= (SELECT COUNT(*) FROM Sales.SalesOrderHeader) / @pageSize

SELECT 
rowNumber
,@totalPages as total_pages
,CustomerID
,AccountNumber
FROM (SELECT *,
			ROW_NUMBER() OVER(ORDER BY SalesOrderID) AS rowNumber ---ROW_NUMBER genera un numero consecutivo para cada fila en base al order by 
	FROM Sales.SalesOrderHeader
	) AS Sales
WHERE rowNumber between @pageSize * @pageNumber +1
				and  @pageSize *(@pageNumber + 1)

/*-----------------
-------------------
INDICE
------------------
------------------*/


/*CREATE TABLE [Person].[Contact](
  [name] varchar(255) default NULL,
  [phone] varchar(100) default NULL,
  [email] varchar(255) default NULL,
 
) 
GO

INSERT INTO [Person].[Contact] ([name],[phone],[email])
VALUES
  ('Ronan Rich','1-191-471-5292','metus.vitae@protonmail.com'),
  ('Tarik Collins','(381) 458-0411','neque@google.couk'),
  ('Miranda Reynolds','(526) 714-4469','turpis.egestas@google.org'),
  ('Jamal Santiago','1-452-351-5447','duis.at@yahoo.nete'),
  ('Dahlia Blake','1-241-950-3140','purus.duis.elementum@protonmail.ca'),
   ('Ronan Rich','1-191-471-5292','metus.vitae@protonmail.com'),
  ('Tarik Collins','(381) 458-0411','neque@google.couk'),
  ('Miranda Reynolds','(526) 714-4469','turpis.egestas@google.org'),
  ('Jamal Santiago','1-452-351-5447','duis.at@yahoo.nete'),
  ('Dahlia Blake','1-241-950-3140','purus.duis.elementum@protonmail.ca'),
   ('Ronan Rich','1-191-471-5292','metus.vitae@protonmail.com'),
  ('Tarik Collins','(381) 458-0411','neque@google.couk'),
  ('Miranda Reynolds','(526) 714-4469','turpis.egestas@google.org'),
  ('Jamal Santiago','1-452-351-5447','duis.at@yahoo.nete'),
  ('Dahlia Blake','1-241-950-3140','purus.duis.elementum@protonmail.ca');

  INSERT INTO Person.[Contact] SELECT * FROM Person.[Contact]

  */

  DBCC FREEPROCCACHE WITH NO_INFOMSGS  --borra el cache, para ver el tiempo real que demora la cosulta
  DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS 

  SELECT * FROM Person.[Contact]  where email= 'duis.at@yahoo.nete'

  CREATE NONCLUSTERED INDEX IX_Contact_email
  ON Person.[Contact] (email)
