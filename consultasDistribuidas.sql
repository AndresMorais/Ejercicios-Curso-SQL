/*-----------------
-------------------
CONSULTAS DESTRIBUIDAS
------------------
------------------*/

--Activas consultas distribuidas

sp_configure 'show advanced option',1
RECONFIGURE

sp_configure 'Ad Hoc Distributed Queries',1
RECONFIGURE

--Conectar a un servidor remoto
SELECT * FROM OPENROWSET ('SQLNCLI' 
						,'Server= cadena_de_conexion; UID= nombre_usaurio;PWD= contraseña_usaurio' 
						,bombre_baseDatos.nombre_esquema.nombre_tabla)
/*
SQLNCLI= es el cliente que vamos a utilizar. Hay varios tipos, pero en caso de bses SQL debemos usar este
Server= es el IP del equipo o IP extarna
*/


--Leer archivo json

DECLARE @JSON varchar(MAX)
SELECT * FROM OPENROWSET (BULK 'C:\Users\Administrator\Desktop\Capacitacion\SQL\SQL_UDEMY\ejemplo.json',SINGLE_CLOB)IMPORT
--SINGLE_CLOB solo funciona con varchart 

---
DECLARE @JSON varchar (MAX)
SELECT 
	@JSON= BULKCOLUMN --para estructural los datos de salida se almacena en una variable
FROM OPENROWSET (BULK'C:\Users\Administrator\Desktop\Capacitacion\SQL\SQL_UDEMY\ejemplo.json', SINGLE_CLOB) IMPORT

SELECT * FROM OPENJSON (@JSON)
