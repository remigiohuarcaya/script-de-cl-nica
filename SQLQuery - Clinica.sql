-------------------------------------------------------
-- BASE DE DATOS : SysClinca
-- Fecha  : 12-12-2022
-- Autor  : Remigio Huarcaya Almeyda
-- www.rhsoftperu.com
-------------------------------------------------------
Use Master  -- BD principal del Servidor
go
-- Configurar el servidor
Exec master.dbo.sp_configure 'show advanced options',1
reconfigure with override
go

Exec master.dbo.sp_configure 'xp_cmdshell',1
reconfigure with override
go
-- Crea una carpeta
xp_cmdshell 'MD D:\Clinica'
go
-- Lista contenido de una carpeta
xp_cmdshell 'Dir D:\Clinica'
go
if exists (select name from master..sysdatabases where name='SysClinica')   	
	Drop Database SysClinica	
go
Create database SysClinica
on Primary
(name = 'SysClinica_data',  -- Nombre lógico
filename = 'D:\Clinica\SysClinica_data.mdf', --Nombre físico
size = 20 MB, --Tamaño inicial
maxsize = 50 MB,  -- Máximo Tamaño (tope)
filegrowth = 10%) -- Factor de crecimiento
log on
(name = 'SysClinica_log',  -- Nombre lógico
filename = 'D:\Clinica\SysClinica_log.ldf', --Nombre físico
size = 20 MB, --Tamaño inicial
filegrowth = 2MB) -- Factor de crecimiento
go

Use SysClinica
go
if exists (select * from sysobjects where type='U' and name='Distrito')
	drop table Distrito
go
create table Distrito
(id_dis int not null Primary key identity(1,1),
nom_dis varchar(25) not null)
go

insert into Distrito values ('Lince'),('Ate'),('Los Olivos'),('Pueblo Libre'),('Rimac'),('Surquillo'),('SJL'),('Pueblo Libre'),('Independencia'),('SJM'),
('Pachacamac'),('Lurin'),('VMT'),('San Borja'),('la Victoria'),('La Molina')
go

---------------------------------------------------
-- C O N S U L T O R I O
-- www.rhsoftperu.com
---------------------------------------------------
create table Especialidad
(id_esp int not null Primary key identity(1,1),
nom_esp varchar(25) not null)
go
insert into Especialidad values ('Pediatría'),('Geriatría'),('Dermatología'),('Ginecología'),('Medicina Interna'),('Traumatología'),('Medicina General'),('Nutrición'),('Enfermeria')
go

create table Consultorio
(id_con int not null Primary key identity(1,1),
nro_con int not null,
id_esp int references Especialidad)
go
insert Consultorio values (200,1),(201,1),(203,2),(204,3),(301,3)
go

