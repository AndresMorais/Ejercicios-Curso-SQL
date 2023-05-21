/*----------------------------------
------------------------------------
SECCION CUATRO DEL CURSO : BUSQUEDAS
------------------------------------
------------------------------------*/

--BUSQUEDAS

select * from person.person P
inner join person.EmailAddress E on  P.BusinessEntityID=E.BusinessEntityID --19.972

select * from Person.Person P
left join person.EmailAddress E on P.BusinessEntityID=E.BusinessEntityID --19.772
where ISNULL(P.Title,' ')=' '

---- ISNULL DENTRO DE LA CLAUSULA WHERE

declare @nombre char (30)=null
set @nombre='Roberto'

select * from person.Person 
where Person.MiddleName=
	(case 
		when isnull(@nombre,'')<>'' then 'valor por defecto'
		else MiddleName
	end)
order by 5 desc


----- CROSS JOIN

USE [AdventureWorks2017]
GO

CREATE TABLE Sales.SpecialOfferReseller(
	[SpecialOfferID] int not null,
	[Description] nvarchar (255) not null,
	[DiscountPct] smallmoney not null, 
)
GO
CREATE TABLE Sales.SpecialOfferCustomer(
	[SpecialOfferID] int not null, 
	[Description] nvarchar (255) not null,
	[DiscountPct] smallmoney not null
)

INSERT INTO sales.SpecialOfferReseller
	select  SpecialOfferID,[Description],DiscountPct
	from sales.SpecialOffer where Category='Reseller'

GO
INSERT INTO Sales.SpecialOfferCustomer
	select  SpecialOfferID,[Description],DiscountPct
	from sales.SpecialOffer where Category='Customer'


-- Obtner el total de descuentos para para las categorias Customer y Reseller

--select * from [Sales].[SpecialOffer]
--Select * from Sales.SpecialOfferCustomer
--select * from Sales.SpecialOfferReseller

select 
C.[Description]
,R.[Description]
,C.[DiscountPct]
,R.[DiscountPct]
,C.[DiscountPct] + R.[DiscountPct] AS DiscountPctTOTAL
from Sales.SpecialOfferCustomer C
cross join Sales.SpecialOfferReseller R 


/*----------------------------------------
------------------------------------------
SECCION QUINTA DEL CURSO: FULL TEXT SEARCH
------------------------------------------
-----------------------------------------*/

--CONTAINS 

-- cuando la búsqueda es sobre una frase, se usa comillas dobre entre comillas simples
select * from [Person].[Address] A 
where contains (A.AddressLine1,'"First Avenue"') 

--CONTAINS /AND/AND NOT/OR

select * from [Person].[Address] A
where contains (A.AddressLine1, 'Avenue AND Port')

select * from [Person].[Address] A
where contains (A.AddressLine1,'Avenue AND Port AND NOT 54')

select * from [Person].[Address] A
where contains (A.AddressLine1,'Avenue OR Port')


-- el parentesis dentro de las comillas permite la ejecución del operador AND 
select * from [Person].[Address] A
where contains (A.AddressLine1,'(36 AND Avenue) OR Port') 

--CONTAINS NEAR

select * from Person.Address
where contains (AddressLine1,'"5415 San" NEAR Dr.')


--CONTAINS NEAR (búsqueda de mas de una palabra)

select * from Person.Address
where contains (AddressLine1,'NEAR((21,centrale),6)')-- trae todos los registros que tengan hasta 6 palabras entre '21' y 'Centrale'

select * from Person.Address --order by len( AddressLine1) desc
where contains (AddressLine1,'NEAR((Hilton, Factory,25),5)') --busca hasta 5 palabras entre 'Hilton' y 'Factory' y luego hasta 5 palabras entre 'Factory' y '25'



--FORMSOF INFLECTIONAL
--si el valor uscado es sustativo, considera el singilar, plural y genero. Si es verbo, trae toda las formas verbales.

select * from Person.Address
where contains (AddressLine1,'FORMSOF(INFLECTIONAL,"Streets")')

--ejemplo con verbo
--update Person.Address set AddressLine1='6387 Scenic Avenue hacemos' where AddressID=8

select * from  Person.Address
where contains (AddressLine1,'FORMSOF(INFLECTIONAL,"hagamos")', LANGUAGE 3082) --3082 corresponde al  LocalID del español 


--OBTENER TODOS LOS TIEMPOS VERBALES DE UN VERBO

select display_term 
from SYS.dm_fts_parser('FORMSOF(INFLECTIONAL,"TRABAJO")',3082,0,0)

--FREETEXT. trae todos los registros que contiene alguna de las palabras del predicado 

select * from Person.Address
where freetext (AddressLine1,'"street Avenue"') 


--POPULATION DE UNA TABLA. Actualiza los catalogos para la aplicacion de fulltext search

ALTER FULLTEXT INDEX ON Person.Address START FULL POPULATION
ALTER FULLTEXT INDEX ON Person.Address START UPDATE POPULATION --Actualización incremental 
