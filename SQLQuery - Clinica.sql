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

---------------------------------------------------
-- PERSONAL 
-- www.rhsoftperu.com
---------------------------------------------------
create table Cargo
(id_cargo int not null primary key identity (1,1),
nom_cargo varchar(30) not null)
go
insert Cargo values ('Médico'),('Enfermera'),('Asistente contable'),('Contador'),('Asistente'),('Programador'),('Analista de Sistemas'),('Jefe de Seguridad'),('Digitador'),('Operador'),
('Jefe de logística'),('Kardista'),('Almacenero'),('Mecánico'), ('Cajero'),('Asistente médico')
go

create table Empleado
(id_emp int not null primary key identity (1,1),
nom_emp varchar(25) not null,
ape_emp varchar(25) not null,
id_cargo int references Cargo,
dni_emp char(8) not null UNIQUE,
cel_med char(9) not null,
foto_emp image,
est_emp char(1) not null)
go
insert Empleado values ('Remigio','Huarcaya Almeyda',1,'12345678','895632145',null,'A')
insert Empleado values ('Christian','Chumpitaz',1,'72345678','995632145',null,'A')
insert Empleado values ('Luis','Estrada',2,'82345672','995646145',null,'A')
insert Empleado values ('Juan','Perez Garcia',3,'02345673','945646141',null,'A')
insert Empleado values ('Moises','Almeida Ormeño',1,'00345677','945646143',null,'A')
insert Empleado values ('Luisa','Herrera Cosme',2,'09345670','945646149',null,'A')
insert Empleado values ('María','Moras Luna',2,'08345679','945646445',null,'A')
insert Empleado values ('Alberto','Gorriti Luna',15,'68345670','925646145',null,'A')
go

create table Medico
(id_med int not null Primary key identity(1,1),
id_emp int references Empleado,
id_esp int references Especialidad,
nro_col char(8) not null UNIQUE,
est_med char(1) not null check (est_med='A' or est_med='X'));
go

insert Medico values (1,2,'56389','A')
insert Medico values (2,1,'356389','A')
insert Medico values (3,1,'116389','A')
insert Medico values (4,2,'416389','A')
insert Medico values (5,3,'316389','A')
go

-- Disponibilidad horaria de los médicos
-- O Ocupado
-- D Disponible

create table Horario_medico
(id_horario int not null primary key identity (1,1),
id_med int references Medico,
fec_horario date,
hora char(5) not null,
est_horario char(1) not null check(est_horario='D' or est_horario='O' ), 
)
go
insert into Horario_medico values (1,'01/12/2022','08:00','O')
insert into Horario_medico values (1,'01/12/2022','08:30','D')
insert into Horario_medico values (1,'01/12/2022','09:00','D')
insert into Horario_medico values (1,'01/12/2022','09:30','O')
insert into Horario_medico values (2,'01/12/2022','08:00','O')
insert into Horario_medico values (2,'01/12/2022','08:30','D')
insert into Horario_medico values (2,'01/12/2022','09:00','D')
insert into Horario_medico values (2,'01/12/2022','09:30','O')
insert into Horario_medico values (3,'01/12/2022','08:00','O')
insert into Horario_medico values (3,'01/12/2022','08:30','D')
insert into Horario_medico values (3,'01/12/2022','09:00','D')
insert into Horario_medico values (3,'01/12/2022','09:30','O')
go

create table Roles
(id_rol int not null primary key identity (1,1),
nom_rol varchar(20) not null)
go
insert Roles values ('Digitador'),('Operador'),('Supervisor'),('Administrador'),('Personal'),('Público')
go

create table Usuario
(id_usu int not null primary key identity (1,1),
id_emp int references Empleado,
nom_usu varchar(25) not null,
con_usu varchar(50) not null,
id_rol int references roles,
fec_cre date not null,
est_usu char(1))
go
insert into Usuario values (1, 'admin', 'MQAyADMANAA1ADYANwA4ADkA', 4 , '10/09/2019', 'A')
insert into Usuario values (2, 'super', 'MQAyADMANAA1ADYANwA4ADkA', 3 , '11/05/2019', 'A')
insert into Usuario values (3, 'lestrada', 'MQAyADMANAA1ADYANwA4ADkA', 1 , '12/09/2019', 'A')
insert into Usuario values (4, 'jperez', 'MQAyADMANAA1ADYANwA4ADkA', 1 , '12/09/2019', 'A')
go

-------------------------------------------
-- S E R V I C I O S
-- www.rhsoftperu.com
-------------------------------------------
create table Tipo_servicio
(id_tiposer int not null primary key identity (1,1),
des_tiposer varchar(30) not null)
go

insert into Tipo_servicio values ('Análisis clínico')
insert into Tipo_servicio values ('Consulta médica')
insert into Tipo_servicio values ('Internamiento')
insert into Tipo_servicio values ('Ambulancia')
insert into Tipo_servicio values ('Enfermería')
insert into Tipo_servicio values ('Odontología')
insert into Tipo_servicio values ('Imágenes')
go

create table Servicio
(id_serv int not null primary key identity (1,1),
des_serv varchar(45) not null,
id_tiposer int references tipo_servicio,
cos_ser smallmoney not null,
est_ser char(1) not null)
go
insert Servicio values ('Hemograma completo',1,50,'A')
insert Servicio values ('PSA',1,20,'A')
insert Servicio values ('Examen general de Orina',1,20,'A')
insert Servicio values ('Trigliceridos',1,20,'A')
insert Servicio values ('Servicio de Alojamiento',3,450,'A')
insert Servicio values ('Pediatría',2,150,'A')
insert Servicio values ('Medicina general',2,130,'A')
insert Servicio values ('Servicio de ambulancia',4,180,'A')
insert Servicio values ('Alojamiento',3,150,'A')
insert Servicio values ('Tópico',4,100,'A')
insert Servicio values ('Reumatología',2,150,'A')
insert Servicio values ('Curación dental',6,100,'A')
insert Servicio values ('Extracción dental',6,50,'A')

go

create table Tipo_seguro
(id_tipseg int not null primary key identity (1,1),
des_tipseg varchar(35) not null)
go
insert Tipo_seguro values ('Seguro pacífico'),('Seguro Positiva'),('Rimac')
insert Tipo_seguro values ('Seguro MAPFRE')
go

-------------------------------------------
-- P A C I E N T E
-- www.rhsoftperu.com
-------------------------------------------
create table Paciente
(id_pac int not null primary key identity (1,1),
nom_pac varchar(25) not null,
ape_pac varchar(25) not null,
sexo char(1) not null,
dni_pac char(8) not null UNIQUE,
id_dis int references distrito,
id_tipseg int references tipo_seguro,
foto image,
fec_nac date not null,
est_pac char(1) not null)
go
insert Paciente values ('Angel','Barreda','M','78965423',1,1,null,'10/04/1990','A')
insert Paciente values ('Thatiana','Arrese','F','48965423',1,2,null,'10/07/2000','A')
insert Paciente values ('Roberto','Luna','M','68965423',2,2,null,'10/12/1980','A')
insert Paciente values ('María','Troncos León','12965423',2,3,null,'10/12/1980','A')
insert Paciente values ('Martin','León Pachas','M','02965423',2,4,null,'10/12/1995','A')
insert Paciente values ('Mario','Corona Li','M','32965423',3,1,null,'01/01/1990','A')
go

create table Historia
(id_historia int not null primary key identity (1,1),
id_pac int references Paciente,
fec_ing date not null default getdate(),
hipertension char(1) not null check (hipertension='S' or hipertension='N'),
diabetes char(1) not null check (diabetes='S' or diabetes='N'),
alergia char(1) not null check (alergia='S' or alergia='N'),
vacunas int not null check (vacunas>=0) ,
sida char(1) not null check (sida='S' or sida='N'),
tipo_sangre char(2),
interveciones_quirurgicas char(1),
observaciones varchar(500),
est_his char(1)
)
go

-------------------------------------------
-- TIPO DE DOCUMENTO
-- www.rhsoftperu.com
-------------------------------------------
create table Tip_doc
(id_tipdoc int not null primary key identity (1,1),
des_tipdoc varchar(25) not null,
des_abr char(5) not null,
nro_tipdoc char(7) not null)
go
insert Tip_doc values ('Factura de Venta','FAC','0000005')
insert Tip_doc values ('Boleta de Venta','BOL','0000003')
insert Tip_doc values ('Recibo Honorario','RHE','0000001')
insert Tip_doc values ('Nota de Abono','N/A','0000001')
insert Tip_doc values ('Nota de Crédito','N/C','0000001')
insert Tip_doc values ('Guía de Ingreso','N/C','0000001')
insert Tip_doc values ('Guía de Salida','N/C','0000001')
insert Tip_doc values ('Guía de Remisión','N/C','0000001')
go

---------------------------------------------------
-- M E D I C A M E N T O
-- www.rhsoftperu.com
---------------------------------------------------
create table Laboratorio
(id_lab int primary key identity(1,1),
nom_lab varchar(25) not null,
contacto_lab varchar(35) not null,
tel_lab varchar(9) not null)
go
insert into Laboratorio values ('Hersil','Juan Lupin Arce','987654321')
insert into Laboratorio values ('Abbot','José Lucio Alva','987654321')
go
Create table Unidad
(id_uni int primary key identity(1,1),
nom_uni varchar(15)not null)
go

insert Unidad values ('Caja'),('Bolsa'),('Rollo')
go

Create table Modo_uso
(id_modo int primary key identity(1,1),
nom_modo varchar(25)not null)
go
insert Modo_uso values ('Vía oral'),('Vía Intravenoso')
insert Modo_uso values ('Vía Intramuscular')
go

Create table Presentacion
(id_pres int primary key identity(1,1),
nom_pres varchar(15)not null)
go

insert Presentacion values ('Capsula'),('Jarabe'),('Pastilla')
go

create table Medicamentos
(id_med int primary key identity(1,1),
nom_med varchar(45)not null,
id_lab int references laboratorio,
id_uni int references Unidad,
id_modo int references Modo_uso,
id_pres int references Presentacion,
pre_costo decimal (7,2) not null,
pre_sug decimal (7,2) not null, -- Precio sugerido
stock_med int not null, -- Stock actual
stock_max int not null, -- Stock máximo
stock_seg int not null, -- Stock seguridad
foto_med image not null,
est_med char(1)not null)
go

---------------------------------------
-- C I T A S 
-- Triaje - Examenes clínicos - Receta
-- www.rhsoftperu.com
---------------------------------------
create table Citas
(id_cita int not null primary key identity(1,1),
id_pac int references paciente,
id_horario int references horario_medico,
id_con int references consultorio, 
est_cita char(1) not null check(est_cita='A' or est_cita='C' or est_cita='P'))
go

insert citas values (1,1,1,'A')
insert citas values (1,2,2,'A')
insert citas values (2,3,3,'C')
insert citas values (3,4,4,'P')
insert citas values (3,5,5,'P')
go

create table Triaje
(id_tri int not null primary key identity(1,1),
id_cita int references Citas,
temperatura decimal(4,2),
presion int,
frecuencia_cardiaca int,
frecuencia_respiratoria int,
saturacion int,
peso int,
talla decimal(4,2),
observacion varchar(300)
)
go
insert into triaje values (1,36.5,130,78,62,98,70,1.75, null)
insert into triaje values (2,38,120,88,62,98,70,1.65, null)
go

create table Receta
(id_cita int references Citas,
id_med int references Medicamentos,
can_med int check(can_med>0),
dosis_med varchar(100),
obser varchar (100)
)
go

create table Examenes
(id_cita int references Citas,
id_serv int references servicio,
nota_medica varchar(200) not null,
fec_examen date,
resultados varchar(500)
)
go
---------------------------------------------------
-- D O C U M E N T O S
-- Comprobantes - guias
-- www.rhsoftperu.com
---------------------------------------------------
create table Comprobante
(id_comp int not null primary key identity (1,1),
id_tipdoc int references tip_doc,
nro_comp char(7) not null,
fec_comp date not null,
id_emp int references empleado,
id_pac int references paciente,
tot_comp smallmoney not null,
est_comp char(1) not null check (est_comp in ('A','X')))
go

insert Comprobante values (1,'0000001','01/01/2022',8,1,650,'A')
insert Comprobante values (2,'0000001','01/03/2022',8,2,150,'A')
insert Comprobante values (1,'0000002','01/04/2022',8,3,250,'A')
insert Comprobante values (1,'0000003','01/05/2022',8,2,180,'A')
insert Comprobante values (2,'0000002','01/06/2022',8,3,200,'A')
insert Comprobante values (2,'0000003','01/06/2022',8,4,300,'A')
go

create table Detalle
(id_det int not null primary key identity (1,1),
id_comp int not null references comprobante,
id_serv int references Servicio,
cos_serv smallmoney not null)
go

insert Detalle values (1,1,150)
insert Detalle values (1,2,250)
insert Detalle values (1,3,150)

insert Detalle values (2,2,350)

insert Detalle values (3,1,250)
insert Detalle values (3,3,150)
insert Detalle values (3,4,150)
insert Detalle values (3,5,250)

insert Detalle values (4,1,250)
insert Detalle values (4,3,150)

insert Detalle values (5,3,150)

insert Detalle values (6,3,258)
insert Detalle values (6,6,150)
go

create table Proveedor 
(id_prov int not null primary key identity(1,1),
nom_prov varchar(25),
ruc_prov char(11) not null UNIQUE,
direc_prov varchar(20),
telf_prov varchar(11),
est_prov char(1) not null check(est_prov='A' or est_prov='X'))
go
insert into  proveedor values ('Pharma ABC','12345678912','Av.28 de Julio','987654123','A') 
insert into  proveedor values ('PMFARMA','12345678789','Av.Mexico ','987654456','A') 
go

create table Guia
(id_guia int not null primary key identity(1,1),
id_tipdoc int references tip_doc,
nro_guia char(7) not null,
fec_guia date not null default getdate(),
id_prov int references proveedor,
id_emp int references empleado,
est_guia char(1) check(est_guia='A' or est_guia='X')
)
go
create table Guia_detalle
(id_det int primary key identity(1,1),
id_guia int references guia,
id_med int references Medicamentos,
can_med int not null)
go

insert guia values(6,'0000001','01/10/2022',1,1,'A')
go

---------------------------------------------------
-- M E N Ú   D E L   S I S T E M A
-- www.rhsoftperu.com
---------------------------------------------------
create table Menu
(id_menu int not null primary key identity (1,1),
des_menu varchar(35) not null,
id_rol int references roles)
go

insert menu values ('Registro de Cita',1)
insert menu values ('Estadística de Citas',2)
insert menu values ('Historia de Paciente',2)
insert menu values ('Registro de médico',3)
insert menu values ('programación  de Medicos',3)
insert menu values ('Comprobante',2)
insert menu values ('Especialidad',4)
insert menu values ('Consultorio',4)
insert menu values ('Distrito',4)
insert menu values ('Empleado',4)
insert menu values ('Usuario',4)
insert menu values ('Nivel de acceso',4)
insert menu values ('Roles',4)
insert menu values ('Copia de Seguridad',4)
insert menu values ('Reindexado de BD',4)
go
