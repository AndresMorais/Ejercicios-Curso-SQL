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

