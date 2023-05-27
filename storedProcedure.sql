/*----------------------------------------
------------------------------------------
SECCION COMPLEMENTARIA : STORED PROCEDURE

------------------------------------------
----------------------------------------*/


USE AdventureWorks2017;
--insert into personEjemplo select FirstName,LastName,Suffix from [AdventureWorks2017].[Person].[Person];
--select FirstName,LastName from personEjemplo;
--select * from sys.procedures; --lista los SP almacenados en la DB


--SP ELIMINADO DE REGISTROS

create procedure sp_eliminar_registos as
delete from personEjemplo;

execute sp_eliminar_registos;


--SP DECLARAÍON DE VARIALES -PARAMETROS
alter procedure  sp_eliminar_registos(
	@primerNobre varchar (50)
)
as
delete from personEjemplo
where FirstName=@primerNobre;

execute  sp_eliminar_registos 'Ken';

--SP ACTUALIZAR REGISTROS

DROP PROCEDURE sp_actualizacion_regsitro

create procedure sp_actualizacion_regsitro(
	@primerNombre varchar(50),
	@apellido varchar (50)
)
as
update personEjemplo set LastName=@apellido
where FirstName=@primerNombre;

execute sp_actualizacion_regsitro 'Terri','Apellido de Ejemplo';

--SP INSERTAR REGISTROS

create procedure sp_insertar_registor(
	@primerNombre varchar (50),
	@apellido varchar(50)
)
as
insert into personEjemplo (FirstName,LastName) values (@primerNombre, @apellido);


execute sp_insertar_registor 'AAAAAA','BBBBBB';

---select * from  personEjemplo where FirstName='AAAAAA';


/*----------------------------------------
------------------------------------------
 STORED PROCEDURE DINAMICO
------------------------------------------
----------------------------------------*/

--select * from Production.Product


/* SE MODIFICA EL SP PORQUE LA FUNCION SP_EXECUTESQL NO PERMITE COMO PARAMATRO DATO DE TIPO VARCHAR 

create procedure sp_sel_producto(          
	@order char (1)
)
as
declare @script varchar(8000)
declare @orderBy varchar (500)

set @script='select ProductID,Name,ListPrice from Production.Product'
set @orderBy= (case when @order='I' then 'ProductID'
					when @order='N' then 'order by Name'
					when @order='P' then 'order by ListPrice'
			 end)

set @script= @script + @orderBy;

execute sp_sel_producto 'P'; --ejecto el sp y genera una cadena de caracteres. */


--modificacion del tipo de dato de las variables 

alter procedure sp_sel_producto(          
	@order char (1)
)
as
declare @script nvarchar(max)
declare @orderBy nvarchar (500)

set @script='select ProductID,Name,ListPrice from Production.Product'
set @orderBy= (case when @order='I' then ' order by ProductID'
					when @order='N' then ' order by Name'
					when @order='P' then ' order by ListPrice'
			 end)

set @script= @script + @orderBy


exec SP_EXECUTESQL @script; -- ejeccute como sentencia sql el string almacenado en la variable @script

exec sp_sel_producto 'I'; 


--- STORED PROCEDURE DINAMICO CON PARAMETRO DE OUTPUT


create procedure sp_sel_producto_output(          
	@order char (1),
	@out varchar(max) output
)
as
declare @script nvarchar(max)
declare @orderBy nvarchar (500)

set @script='select ProductID,Name,ListPrice from Production.Product'
set @orderBy= (case when @order='I' then ' order by ProductID'
					when @order='N' then ' order by Name'
					when @order='P' then ' order by ListPrice'
			 end)

set @out= @script + @orderBy;

declare @salida nvarchar(max) -- es nvarchar porque es el tipo de dato requerido por SP_EXECUTESQL
execute sp_sel_producto_output 'N',@salida OUTPUT 
--print @salida
execute SP_EXECUTESQL @salida



