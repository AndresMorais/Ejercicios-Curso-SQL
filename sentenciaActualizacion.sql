/****** Sentencias de Actualizacion  ******/

---INSERT INTO
create table personEjemplo(
FirstName varchar (50),
LastName varchar(50),
);

insert into personEjemplo
select FirstName,LastName from [AdventureWorks2017].[Person].[Person];


select * from personEjemplo;


--UPDATE INNER JOIN 

select * from  [Person].[Person] --Suffix
select *from [HumanResources].[Employee] --Sales Representative

alter table personEjemplo add Suffix varchar (50)


update personEjemplo set Suffix=e.NationalIDNumber
from  [Person].[Person] p
inner join [HumanResources].[Employee] e
on e.BusinessEntityID=p.BusinessEntityID
where e.JobTitle='Sales Representative'

--DELETE INNER JOIN

delete e
from personEjemplo e
inner join Person.Person p 
on e.FirstName=p.FirstName
where 1=1
and e.FirstName='Mark'
and e.LastName='Lee'

-- SELECT INTO (para copias la estructura de una tabla)
select *into emailBackup
from [Person].[EmailAddress]
where 1=0

---SELECT INTO (para copiar estructura y datos. No copia PK ni indices

select * into person.personCopia
from Person.Person

---SELECT INTO (para copiar table en otra DB)
--los dos puntos permiten accceder a otra base de datos
select * into [AdventureBack]..personAddress
from Person.Address

--SELECT INTO (para copiar tabla con campo IDENTITY)
select identity (int,1,1) as ID,* into [AdventureBack]..personPhoneNew
from Person.PersonPhone;

select top 100 * from [AdventureBack]..personPhoneNew;

--CLONEDATABASE
dbcc clonedatabase ([AdventureBack],[AdventureCopia])






