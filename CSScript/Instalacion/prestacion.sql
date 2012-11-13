if exists(select * from Prestacion where pre_id = 1) begin
update Prestacion set pre_id= 1,pre_nombre= 'Agregar arboles',pre_grupo= 'Arboles',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:42',modificado= '20030727 19:50:42',activo= 1 where pre_id = 1
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1,'Agregar arboles','Arboles','','','','','','20030727 19:50:42','20030727 19:50:42',1)
end
if exists(select * from Prestacion where pre_id = 2) begin
update Prestacion set pre_id= 2,pre_nombre= 'Borrar arboles',pre_grupo= 'Arboles',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:42',modificado= '20030727 19:50:42',activo= 1 where pre_id = 2
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2,'Borrar arboles','Arboles','','','','','','20030727 19:50:42','20030727 19:50:42',1)
end
if exists(select * from Prestacion where pre_id = 3) begin
update Prestacion set pre_id= 3,pre_nombre= 'Renombrar arboles',pre_grupo= 'Arboles',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:42',modificado= '20030727 19:50:42',activo= 1 where pre_id = 3
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (3,'Renombrar arboles','Arboles','','','','','','20030727 19:50:42','20030727 19:50:42',1)
end
if exists(select * from Prestacion where pre_id = 4) begin
update Prestacion set pre_id= 4,pre_nombre= 'Agrega ramas',pre_grupo= 'Arboles',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:42',modificado= '20030727 19:50:42',activo= 1 where pre_id = 4
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (4,'Agrega ramas','Arboles','','','','','','20030727 19:50:42','20030727 19:50:42',1)
end
if exists(select * from Prestacion where pre_id = 5) begin
update Prestacion set pre_id= 5,pre_nombre= 'Borrar ramas',pre_grupo= 'Arboles',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:42',modificado= '20030727 19:50:42',activo= 1 where pre_id = 5
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (5,'Borrar ramas','Arboles','','','','','','20030727 19:50:42','20030727 19:50:42',1)
end
if exists(select * from Prestacion where pre_id = 6) begin
update Prestacion set pre_id= 6,pre_nombre= 'Renombrar ramas',pre_grupo= 'Arboles',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 6
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6,'Renombrar ramas','Arboles','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 7) begin
update Prestacion set pre_id= 7,pre_nombre= 'Editar ramas',pre_grupo= 'Arboles',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 7
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (7,'Editar ramas','Arboles','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 8) begin
update Prestacion set pre_id= 8,pre_nombre= 'Conceder permisos',pre_grupo= 'Permisos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 8
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (8,'Conceder permisos','Permisos','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 9) begin
update Prestacion set pre_id= 9,pre_nombre= 'Quitar permisos',pre_grupo= 'Permisos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 9
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (9,'Quitar permisos','Permisos','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 10) begin
update Prestacion set pre_id= 10,pre_nombre= 'Listar usuarios por pantalla',pre_grupo= 'Usuarios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 10
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (10,'Listar usuarios por pantalla','Usuarios','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
GO
if exists(select * from Prestacion where pre_id = 11) begin
update Prestacion set pre_id= 11,pre_nombre= 'Agregar usuarios',pre_grupo= 'Usuarios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 11
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11,'Agregar usuarios','Usuarios','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 12) begin
update Prestacion set pre_id= 12,pre_nombre= 'Modificar usuarios',pre_grupo= 'Usuarios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 12
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (12,'Modificar usuarios','Usuarios','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 13) begin
update Prestacion set pre_id= 13,pre_nombre= 'Eliminar usuarios',pre_grupo= 'Usuarios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 13
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (13,'Eliminar usuarios','Usuarios','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 14) begin
update Prestacion set pre_id= 14,pre_nombre= 'Listar roles por pantalla',pre_grupo= 'Roles',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 14
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (14,'Listar roles por pantalla','Roles','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 15) begin
update Prestacion set pre_id= 15,pre_nombre= 'Agregar roles',pre_grupo= 'Roles',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 15
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15,'Agregar roles','Roles','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 16) begin
update Prestacion set pre_id= 16,pre_nombre= 'Modificar roles',pre_grupo= 'Roles',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 16
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (16,'Modificar roles','Roles','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 17) begin
update Prestacion set pre_id= 17,pre_nombre= 'Eliminar roles',pre_grupo= 'Roles',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 17
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17,'Eliminar roles','Roles','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 18) begin
update Prestacion set pre_id= 18,pre_nombre= 'Listar permisos',pre_grupo= 'Permisos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 18
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18,'Listar permisos','Permisos','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 19) begin
update Prestacion set pre_id= 19,pre_nombre= 'Editar Sysmodulo',pre_grupo= 'Sysmodulo',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 19
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (19,'Editar Sysmodulo','Sysmodulo','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 20) begin
update Prestacion set pre_id= 20,pre_nombre= 'Borrar Sysmodulo',pre_grupo= 'Sysmodulo',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 20
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (20,'Borrar Sysmodulo','Sysmodulo','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
GO
if exists(select * from Prestacion where pre_id = 21) begin
update Prestacion set pre_id= 21,pre_nombre= 'Listar Sysmodulo',pre_grupo= 'Sysmodulo',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 21
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (21,'Listar Sysmodulo','Sysmodulo','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 22) begin
update Prestacion set pre_id= 22,pre_nombre= 'Agregar Tabla',pre_grupo= 'Tabla',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 22
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22,'Agregar Tabla','Tabla','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 23) begin
update Prestacion set pre_id= 23,pre_nombre= 'Editar Tabla',pre_grupo= 'Tabla',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 23
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (23,'Editar Tabla','Tabla','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 24) begin
update Prestacion set pre_id= 24,pre_nombre= 'Borrar Tabla',pre_grupo= 'Tabla',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 24
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (24,'Borrar Tabla','Tabla','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 25) begin
update Prestacion set pre_id= 25,pre_nombre= 'Listar Tabla',pre_grupo= 'Tabla',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 25
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (25,'Listar Tabla','Tabla','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 26) begin
update Prestacion set pre_id= 26,pre_nombre= 'Agregar Sysmodulo',pre_grupo= 'Sysmodulo',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:43',modificado= '20030727 19:50:43',activo= 1 where pre_id = 26
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (26,'Agregar Sysmodulo','Sysmodulo','','','','','','20030727 19:50:43','20030727 19:50:43',1)
end
if exists(select * from Prestacion where pre_id = 27) begin
update Prestacion set pre_id= 27,pre_nombre= 'Editar SysModuloTCP',pre_grupo= 'Sysmodulo',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040103 17:06:26',modificado= '20040103 17:06:26',activo= 1 where pre_id = 27
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (27,'Editar SysModuloTCP','Sysmodulo','','','','','','20040103 17:06:26','20040103 17:06:26',1)
end
if exists(select * from Prestacion where pre_id = 28) begin
update Prestacion set pre_id= 28,pre_nombre= 'Borrar SysModuloTCP',pre_grupo= 'Sysmodulo',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040103 17:06:26',modificado= '20040103 17:06:26',activo= 1 where pre_id = 28
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (28,'Borrar SysModuloTCP','Sysmodulo','','','','','','20040103 17:06:26','20040103 17:06:26',1)
end
if exists(select * from Prestacion where pre_id = 29) begin
update Prestacion set pre_id= 29,pre_nombre= 'Listar SysModuloTCP',pre_grupo= 'Sysmodulo',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040103 17:06:26',modificado= '20040103 17:06:26',activo= 1 where pre_id = 29
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (29,'Listar SysModuloTCP','Sysmodulo','','','','','','20040103 17:06:26','20040103 17:06:26',1)
end
if exists(select * from Prestacion where pre_id = 30) begin
update Prestacion set pre_id= 30,pre_nombre= 'Agregar SysModuloTCP',pre_grupo= 'Sysmodulo',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040103 17:34:52',modificado= '20040103 17:34:52',activo= 1 where pre_id = 30
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (30,'Agregar SysModuloTCP','Sysmodulo','','','','','','20040103 17:34:52','20040103 17:34:52',1)
end
GO
if exists(select * from Prestacion where pre_id = 1016) begin
update Prestacion set pre_id= 1016,pre_nombre= 'Agregar Depositos Logicos',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:45',modificado= '20030727 19:50:45',activo= 1 where pre_id = 1016
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1016,'Agregar Depositos Logicos','General','','','','','','20030727 19:50:45','20030727 19:50:45',1)
end
if exists(select * from Prestacion where pre_id = 1017) begin
update Prestacion set pre_id= 1017,pre_nombre= 'Editar Depositos Logicos',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:45',modificado= '20030727 19:50:45',activo= 1 where pre_id = 1017
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1017,'Editar Depositos Logicos','General','','','','','','20030727 19:50:45','20030727 19:50:45',1)
end
if exists(select * from Prestacion where pre_id = 1018) begin
update Prestacion set pre_id= 1018,pre_nombre= 'Borrar Depositos Logicos',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:45',modificado= '20030727 19:50:45',activo= 1 where pre_id = 1018
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1018,'Borrar Depositos Logicos','General','','','','','','20030727 19:50:45','20030727 19:50:45',1)
end
if exists(select * from Prestacion where pre_id = 1019) begin
update Prestacion set pre_id= 1019,pre_nombre= 'Listar Depositos Logicos',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:45',modificado= '20030727 19:50:45',activo= 1 where pre_id = 1019
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1019,'Listar Depositos Logicos','General','','','','','','20030727 19:50:45','20030727 19:50:45',1)
end
if exists(select * from Prestacion where pre_id = 1020) begin
update Prestacion set pre_id= 1020,pre_nombre= 'Agregar Unidades',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1020
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1020,'Agregar Unidades','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1021) begin
update Prestacion set pre_id= 1021,pre_nombre= 'Editar Unidades',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1021
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1021,'Editar Unidades','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1022) begin
update Prestacion set pre_id= 1022,pre_nombre= 'Borrar Unidades',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1022
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1022,'Borrar Unidades','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1023) begin
update Prestacion set pre_id= 1023,pre_nombre= 'Listar Unidades',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1023
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1023,'Listar Unidades','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1024) begin
update Prestacion set pre_id= 1024,pre_nombre= 'Agregar Sucursal Cliente',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1024
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1024,'Agregar Sucursal Cliente','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1025) begin
update Prestacion set pre_id= 1025,pre_nombre= 'Editar Sucursal Cliente',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1025
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1025,'Editar Sucursal Cliente','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
GO
if exists(select * from Prestacion where pre_id = 1026) begin
update Prestacion set pre_id= 1026,pre_nombre= 'Borrar Sucursal Cliente',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1026
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1026,'Borrar Sucursal Cliente','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1027) begin
update Prestacion set pre_id= 1027,pre_nombre= 'Listar Sucursal Cliente',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1027
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1027,'Listar Sucursal Cliente','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1028) begin
update Prestacion set pre_id= 1028,pre_nombre= 'Agregar Monedas',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1028
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1028,'Agregar Monedas','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1029) begin
update Prestacion set pre_id= 1029,pre_nombre= 'Editar Monedas',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1029
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1029,'Editar Monedas','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1030) begin
update Prestacion set pre_id= 1030,pre_nombre= 'Borrar Monedas',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1030
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1030,'Borrar Monedas','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1031) begin
update Prestacion set pre_id= 1031,pre_nombre= 'Listar Monedas',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1031
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1031,'Listar Monedas','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1032) begin
update Prestacion set pre_id= 1032,pre_nombre= 'Agregar Bancos',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1032
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1032,'Agregar Bancos','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1033) begin
update Prestacion set pre_id= 1033,pre_nombre= 'Editar Bancos',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1033
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1033,'Editar Bancos','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1034) begin
update Prestacion set pre_id= 1034,pre_nombre= 'Borrar Bancos',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1034
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1034,'Borrar Bancos','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1035) begin
update Prestacion set pre_id= 1035,pre_nombre= 'Listar Bancos',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1035
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1035,'Listar Bancos','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
GO
if exists(select * from Prestacion where pre_id = 1036) begin
update Prestacion set pre_id= 1036,pre_nombre= 'Agregar Vendedores',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1036
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1036,'Agregar Vendedores','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1037) begin
update Prestacion set pre_id= 1037,pre_nombre= 'Editar Vendedores',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1037
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1037,'Editar Vendedores','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1038) begin
update Prestacion set pre_id= 1038,pre_nombre= 'Borrar Vendedores',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1038
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1038,'Borrar Vendedores','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1039) begin
update Prestacion set pre_id= 1039,pre_nombre= 'Listar Vendedores',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1039
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1039,'Listar Vendedores','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1040) begin
update Prestacion set pre_id= 1040,pre_nombre= 'Agregar Tarjeta de Credito',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1040
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1040,'Agregar Tarjeta de Credito','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1041) begin
update Prestacion set pre_id= 1041,pre_nombre= 'Editar Tarjeta de Credito',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1041
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1041,'Editar Tarjeta de Credito','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1042) begin
update Prestacion set pre_id= 1042,pre_nombre= 'Borrar Tarjeta de Credito',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:46',modificado= '20030727 19:50:46',activo= 1 where pre_id = 1042
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1042,'Borrar Tarjeta de Credito','General','','','','','','20030727 19:50:46','20030727 19:50:46',1)
end
if exists(select * from Prestacion where pre_id = 1043) begin
update Prestacion set pre_id= 1043,pre_nombre= 'Listar Tarjeta de Credito',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1043
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1043,'Listar Tarjeta de Credito','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1044) begin
update Prestacion set pre_id= 1044,pre_nombre= 'Agregar Cuenta',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1044
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1044,'Agregar Cuenta','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1045) begin
update Prestacion set pre_id= 1045,pre_nombre= 'Editar Cuenta',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1045
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1045,'Editar Cuenta','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
GO
if exists(select * from Prestacion where pre_id = 1046) begin
update Prestacion set pre_id= 1046,pre_nombre= 'Borrar Cuenta',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1046
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1046,'Borrar Cuenta','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1047) begin
update Prestacion set pre_id= 1047,pre_nombre= 'Listar Cuenta',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1047
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1047,'Listar Cuenta','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1048) begin
update Prestacion set pre_id= 1048,pre_nombre= 'Agregar Leyenda',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1048
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1048,'Agregar Leyenda','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1049) begin
update Prestacion set pre_id= 1049,pre_nombre= 'Editar Leyenda',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1049
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1049,'Editar Leyenda','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1050) begin
update Prestacion set pre_id= 1050,pre_nombre= 'Borrar Leyenda',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1050
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1050,'Borrar Leyenda','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1051) begin
update Prestacion set pre_id= 1051,pre_nombre= 'Listar Leyenda',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1051
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1051,'Listar Leyenda','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1052) begin
update Prestacion set pre_id= 1052,pre_nombre= 'Agregar Centro de Costo',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1052
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1052,'Agregar Centro de Costo','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1053) begin
update Prestacion set pre_id= 1053,pre_nombre= 'Editar Centro de Costo',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1053
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1053,'Editar Centro de Costo','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1054) begin
update Prestacion set pre_id= 1054,pre_nombre= 'Borrar Centro de Costo',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1054
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1054,'Borrar Centro de Costo','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1055) begin
update Prestacion set pre_id= 1055,pre_nombre= 'Listar Centro de Costo',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1055
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1055,'Listar Centro de Costo','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
GO
if exists(select * from Prestacion where pre_id = 1056) begin
update Prestacion set pre_id= 1056,pre_nombre= 'Agregar Cobrador',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1056
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1056,'Agregar Cobrador','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1057) begin
update Prestacion set pre_id= 1057,pre_nombre= 'Editar Cobrador',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1057
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1057,'Editar Cobrador','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1058) begin
update Prestacion set pre_id= 1058,pre_nombre= 'Borrar Cobrador',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1058
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1058,'Borrar Cobrador','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1059) begin
update Prestacion set pre_id= 1059,pre_nombre= 'Listar Cobrador',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1059
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1059,'Listar Cobrador','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1060) begin
update Prestacion set pre_id= 1060,pre_nombre= 'Agregar ReglaLiquidacion',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1060
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1060,'Agregar ReglaLiquidacion','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1061) begin
update Prestacion set pre_id= 1061,pre_nombre= 'Editar ReglaLiquidacion',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1061
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1061,'Editar ReglaLiquidacion','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1062) begin
update Prestacion set pre_id= 1062,pre_nombre= 'Borrar ReglaLiquidacion',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:47',modificado= '20030727 19:50:47',activo= 1 where pre_id = 1062
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1062,'Borrar ReglaLiquidacion','General','','','','','','20030727 19:50:47','20030727 19:50:47',1)
end
if exists(select * from Prestacion where pre_id = 1063) begin
update Prestacion set pre_id= 1063,pre_nombre= 'Listar ReglaLiquidacion',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1063
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1063,'Listar ReglaLiquidacion','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1064) begin
update Prestacion set pre_id= 1064,pre_nombre= 'Agregar Clearing',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1064
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1064,'Agregar Clearing','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1065) begin
update Prestacion set pre_id= 1065,pre_nombre= 'Editar Clearing',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1065
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1065,'Editar Clearing','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
GO
if exists(select * from Prestacion where pre_id = 1066) begin
update Prestacion set pre_id= 1066,pre_nombre= 'Borrar Clearing',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1066
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1066,'Borrar Clearing','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1067) begin
update Prestacion set pre_id= 1067,pre_nombre= 'Listar Clearing',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1067
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1067,'Listar Clearing','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1068) begin
update Prestacion set pre_id= 1068,pre_nombre= 'Agregar Cliente',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1068
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1068,'Agregar Cliente','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1069) begin
update Prestacion set pre_id= 1069,pre_nombre= 'Editar Cliente',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1069
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1069,'Editar Cliente','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1070) begin
update Prestacion set pre_id= 1070,pre_nombre= 'Borrar Cliente',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1070
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1070,'Borrar Cliente','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1071) begin
update Prestacion set pre_id= 1071,pre_nombre= 'Listar Cliente',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1071
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1071,'Listar Cliente','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1072) begin
update Prestacion set pre_id= 1072,pre_nombre= 'Agregar Proveedor',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1072
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1072,'Agregar Proveedor','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1073) begin
update Prestacion set pre_id= 1073,pre_nombre= 'Editar Proveedor',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1073
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1073,'Editar Proveedor','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1074) begin
update Prestacion set pre_id= 1074,pre_nombre= 'Borrar Proveedor',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1074
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1074,'Borrar Proveedor','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1075) begin
update Prestacion set pre_id= 1075,pre_nombre= 'Listar Proveedor',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1075
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1075,'Listar Proveedor','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
GO
if exists(select * from Prestacion where pre_id = 1076) begin
update Prestacion set pre_id= 1076,pre_nombre= 'Agregar Producto',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1076
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1076,'Agregar Producto','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1077) begin
update Prestacion set pre_id= 1077,pre_nombre= 'Editar Producto',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1077
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1077,'Editar Producto','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1078) begin
update Prestacion set pre_id= 1078,pre_nombre= 'Borrar Producto',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1078
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1078,'Borrar Producto','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1079) begin
update Prestacion set pre_id= 1079,pre_nombre= 'Listar Producto',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1079
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1079,'Listar Producto','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1080) begin
update Prestacion set pre_id= 1080,pre_nombre= 'Agregar Rubro',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1080
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1080,'Agregar Rubro','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1081) begin
update Prestacion set pre_id= 1081,pre_nombre= 'Editar Rubro',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1081
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1081,'Editar Rubro','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1082) begin
update Prestacion set pre_id= 1082,pre_nombre= 'Borrar Rubro',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1082
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1082,'Borrar Rubro','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1083) begin
update Prestacion set pre_id= 1083,pre_nombre= 'Listar Rubro',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1083
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1083,'Listar Rubro','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1084) begin
update Prestacion set pre_id= 1084,pre_nombre= 'Agregar Escala',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1084
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1084,'Agregar Escala','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1085) begin
update Prestacion set pre_id= 1085,pre_nombre= 'Editar Escala',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1085
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1085,'Editar Escala','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
GO
if exists(select * from Prestacion where pre_id = 1086) begin
update Prestacion set pre_id= 1086,pre_nombre= 'Borrar Escala',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1086
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1086,'Borrar Escala','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1087) begin
update Prestacion set pre_id= 1087,pre_nombre= 'Listar Escala',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1087
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1087,'Listar Escala','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1088) begin
update Prestacion set pre_id= 1088,pre_nombre= 'Agregar Transporte',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1088
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1088,'Agregar Transporte','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1089) begin
update Prestacion set pre_id= 1089,pre_nombre= 'Editar Transporte',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1089
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1089,'Editar Transporte','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1090) begin
update Prestacion set pre_id= 1090,pre_nombre= 'Borrar Transporte',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:48',modificado= '20030727 19:50:48',activo= 1 where pre_id = 1090
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1090,'Borrar Transporte','General','','','','','','20030727 19:50:48','20030727 19:50:48',1)
end
if exists(select * from Prestacion where pre_id = 1091) begin
update Prestacion set pre_id= 1091,pre_nombre= 'Listar Transporte',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:49',modificado= '20030727 19:50:49',activo= 1 where pre_id = 1091
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1091,'Listar Transporte','General','','','','','','20030727 19:50:49','20030727 19:50:49',1)
end
if exists(select * from Prestacion where pre_id = 1096) begin
update Prestacion set pre_id= 1096,pre_nombre= 'Agregar Listas de Precio',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:49',modificado= '20030727 19:50:49',activo= 1 where pre_id = 1096
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1096,'Agregar Listas de Precio','General','','','','','','20030727 19:50:49','20030727 19:50:49',1)
end
if exists(select * from Prestacion where pre_id = 1097) begin
update Prestacion set pre_id= 1097,pre_nombre= 'Editar Listas de Precio',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:49',modificado= '20030727 19:50:49',activo= 1 where pre_id = 1097
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1097,'Editar Listas de Precio','General','','','','','','20030727 19:50:49','20030727 19:50:49',1)
end
if exists(select * from Prestacion where pre_id = 1098) begin
update Prestacion set pre_id= 1098,pre_nombre= 'Borrar Listas de Precio',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:49',modificado= '20030727 19:50:49',activo= 1 where pre_id = 1098
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1098,'Borrar Listas de Precio','General','','','','','','20030727 19:50:49','20030727 19:50:49',1)
end
if exists(select * from Prestacion where pre_id = 1099) begin
update Prestacion set pre_id= 1099,pre_nombre= 'Listar Listas de Precio',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:49',modificado= '20030727 19:50:49',activo= 1 where pre_id = 1099
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1099,'Listar Listas de Precio','General','','','','','','20030727 19:50:49','20030727 19:50:49',1)
end
GO
if exists(select * from Prestacion where pre_id = 1100) begin
update Prestacion set pre_id= 1100,pre_nombre= 'Agregar Documentos',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040617 18:36:51',modificado= '20040617 18:36:51',activo= 1 where pre_id = 1100
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1100,'Agregar Documentos','General','','','','','','20040617 18:36:51','20040617 18:36:51',1)
end
if exists(select * from Prestacion where pre_id = 1101) begin
update Prestacion set pre_id= 1101,pre_nombre= 'Editar Documentos',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040617 18:36:51',modificado= '20040617 18:36:51',activo= 1 where pre_id = 1101
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1101,'Editar Documentos','General','','','','','','20040617 18:36:51','20040617 18:36:51',1)
end
if exists(select * from Prestacion where pre_id = 1102) begin
update Prestacion set pre_id= 1102,pre_nombre= 'Borrar Documentos',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040617 18:36:51',modificado= '20040617 18:36:51',activo= 1 where pre_id = 1102
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1102,'Borrar Documentos','General','','','','','','20040617 18:36:51','20040617 18:36:51',1)
end
if exists(select * from Prestacion where pre_id = 1103) begin
update Prestacion set pre_id= 1103,pre_nombre= 'Listar Documentos',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040617 18:36:51',modificado= '20040617 18:36:51',activo= 1 where pre_id = 1103
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1103,'Listar Documentos','General','','','','','','20040617 18:36:51','20040617 18:36:51',1)
end
if exists(select * from Prestacion where pre_id = 1104) begin
update Prestacion set pre_id= 1104,pre_nombre= 'Agregar Pais',pre_grupo= 'País',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:49',modificado= '20030727 19:50:49',activo= 1 where pre_id = 1104
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1104,'Agregar Pais','País','','','','','','20030727 19:50:49','20030727 19:50:49',1)
end
if exists(select * from Prestacion where pre_id = 1105) begin
update Prestacion set pre_id= 1105,pre_nombre= 'Editar Pais',pre_grupo= 'País',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:49',modificado= '20030727 19:50:49',activo= 1 where pre_id = 1105
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1105,'Editar Pais','País','','','','','','20030727 19:50:49','20030727 19:50:49',1)
end
if exists(select * from Prestacion where pre_id = 1106) begin
update Prestacion set pre_id= 1106,pre_nombre= 'Borrar Pais',pre_grupo= 'País',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:49',modificado= '20030727 19:50:49',activo= 1 where pre_id = 1106
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1106,'Borrar Pais','País','','','','','','20030727 19:50:49','20030727 19:50:49',1)
end
if exists(select * from Prestacion where pre_id = 1107) begin
update Prestacion set pre_id= 1107,pre_nombre= 'Listar Pais',pre_grupo= 'País',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:49',modificado= '20030727 19:50:49',activo= 1 where pre_id = 1107
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1107,'Listar Pais','País','','','','','','20030727 19:50:49','20030727 19:50:49',1)
end
if exists(select * from Prestacion where pre_id = 1108) begin
update Prestacion set pre_id= 1108,pre_nombre= 'Agregar Ciudad',pre_grupo= 'Ciudad',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:49',modificado= '20030727 19:50:49',activo= 1 where pre_id = 1108
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1108,'Agregar Ciudad','Ciudad','','','','','','20030727 19:50:49','20030727 19:50:49',1)
end
if exists(select * from Prestacion where pre_id = 1109) begin
update Prestacion set pre_id= 1109,pre_nombre= 'Editar Ciudad',pre_grupo= 'Ciudad',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:49',modificado= '20030727 19:50:49',activo= 1 where pre_id = 1109
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1109,'Editar Ciudad','Ciudad','','','','','','20030727 19:50:49','20030727 19:50:49',1)
end
GO
if exists(select * from Prestacion where pre_id = 1110) begin
update Prestacion set pre_id= 1110,pre_nombre= 'Borrar Ciudad',pre_grupo= 'Ciudad',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:49',modificado= '20030727 19:50:49',activo= 1 where pre_id = 1110
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1110,'Borrar Ciudad','Ciudad','','','','','','20030727 19:50:49','20030727 19:50:49',1)
end
if exists(select * from Prestacion where pre_id = 1111) begin
update Prestacion set pre_id= 1111,pre_nombre= 'Listar Ciudad',pre_grupo= 'Ciudad',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:49',modificado= '20030727 19:50:49',activo= 1 where pre_id = 1111
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1111,'Listar Ciudad','Ciudad','','','','','','20030727 19:50:49','20030727 19:50:49',1)
end
if exists(select * from Prestacion where pre_id = 1112) begin
update Prestacion set pre_id= 1112,pre_nombre= 'Agregar Provincias',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:44',modificado= '20030727 19:50:44',activo= 1 where pre_id = 1112
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1112,'Agregar Provincias','General','','','','','','20030727 19:50:44','20030727 19:50:44',1)
end
if exists(select * from Prestacion where pre_id = 1113) begin
update Prestacion set pre_id= 1113,pre_nombre= 'Editar Provincias',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:44',modificado= '20030727 19:50:44',activo= 1 where pre_id = 1113
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1113,'Editar Provincias','General','','','','','','20030727 19:50:44','20030727 19:50:44',1)
end
if exists(select * from Prestacion where pre_id = 1114) begin
update Prestacion set pre_id= 1114,pre_nombre= 'Borrar Provincias',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:44',modificado= '20030727 19:50:44',activo= 1 where pre_id = 1114
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1114,'Borrar Provincias','General','','','','','','20030727 19:50:44','20030727 19:50:44',1)
end
if exists(select * from Prestacion where pre_id = 1115) begin
update Prestacion set pre_id= 1115,pre_nombre= 'Listar Provincias',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:44',modificado= '20030727 19:50:44',activo= 1 where pre_id = 1115
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1115,'Listar Provincias','General','','','','','','20030727 19:50:44','20030727 19:50:44',1)
end
if exists(select * from Prestacion where pre_id = 1116) begin
update Prestacion set pre_id= 1116,pre_nombre= 'Agregar Zonas',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:44',modificado= '20030727 19:50:44',activo= 1 where pre_id = 1116
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1116,'Agregar Zonas','General','','','','','','20030727 19:50:44','20030727 19:50:44',1)
end
if exists(select * from Prestacion where pre_id = 1117) begin
update Prestacion set pre_id= 1117,pre_nombre= 'Editar Zonas',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:44',modificado= '20030727 19:50:44',activo= 1 where pre_id = 1117
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1117,'Editar Zonas','General','','','','','','20030727 19:50:44','20030727 19:50:44',1)
end
if exists(select * from Prestacion where pre_id = 1118) begin
update Prestacion set pre_id= 1118,pre_nombre= 'Borrar Zonas',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:44',modificado= '20030727 19:50:44',activo= 1 where pre_id = 1118
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1118,'Borrar Zonas','General','','','','','','20030727 19:50:44','20030727 19:50:44',1)
end
if exists(select * from Prestacion where pre_id = 1119) begin
update Prestacion set pre_id= 1119,pre_nombre= 'Listar Zonas',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:44',modificado= '20030727 19:50:44',activo= 1 where pre_id = 1119
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1119,'Listar Zonas','General','','','','','','20030727 19:50:44','20030727 19:50:44',1)
end
GO
if exists(select * from Prestacion where pre_id = 1120) begin
update Prestacion set pre_id= 1120,pre_nombre= 'Agregar Tasas Impositivas',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:45',modificado= '20030727 19:50:45',activo= 1 where pre_id = 1120
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1120,'Agregar Tasas Impositivas','General','','','','','','20030727 19:50:45','20030727 19:50:45',1)
end
if exists(select * from Prestacion where pre_id = 1121) begin
update Prestacion set pre_id= 1121,pre_nombre= 'Editar Tasas Impositivas',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:45',modificado= '20030727 19:50:45',activo= 1 where pre_id = 1121
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1121,'Editar Tasas Impositivas','General','','','','','','20030727 19:50:45','20030727 19:50:45',1)
end
if exists(select * from Prestacion where pre_id = 1122) begin
update Prestacion set pre_id= 1122,pre_nombre= 'Borrar Tasas Impositivas',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:45',modificado= '20030727 19:50:45',activo= 1 where pre_id = 1122
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1122,'Borrar Tasas Impositivas','General','','','','','','20030727 19:50:45','20030727 19:50:45',1)
end
if exists(select * from Prestacion where pre_id = 1123) begin
update Prestacion set pre_id= 1123,pre_nombre= 'Listar Tasas Impositivas',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:45',modificado= '20030727 19:50:45',activo= 1 where pre_id = 1123
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1123,'Listar Tasas Impositivas','General','','','','','','20030727 19:50:45','20030727 19:50:45',1)
end
if exists(select * from Prestacion where pre_id = 1124) begin
update Prestacion set pre_id= 1124,pre_nombre= 'Agregar Depositos Fisicos',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:45',modificado= '20030727 19:50:45',activo= 1 where pre_id = 1124
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1124,'Agregar Depositos Fisicos','General','','','','','','20030727 19:50:45','20030727 19:50:45',1)
end
if exists(select * from Prestacion where pre_id = 1125) begin
update Prestacion set pre_id= 1125,pre_nombre= 'Editar Depositos Fisicos',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:45',modificado= '20030727 19:50:45',activo= 1 where pre_id = 1125
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1125,'Editar Depositos Fisicos','General','','','','','','20030727 19:50:45','20030727 19:50:45',1)
end
if exists(select * from Prestacion where pre_id = 1126) begin
update Prestacion set pre_id= 1126,pre_nombre= 'Borrar Depositos Fisicos',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:45',modificado= '20030727 19:50:45',activo= 1 where pre_id = 1126
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1126,'Borrar Depositos Fisicos','General','','','','','','20030727 19:50:45','20030727 19:50:45',1)
end
if exists(select * from Prestacion where pre_id = 1127) begin
update Prestacion set pre_id= 1127,pre_nombre= 'Listar Depositos Fisicos',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:45',modificado= '20030727 19:50:45',activo= 1 where pre_id = 1127
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1127,'Listar Depositos Fisicos','General','','','','','','20030727 19:50:45','20030727 19:50:45',1)
end
if exists(select * from Prestacion where pre_id = 1128) begin
update Prestacion set pre_id= 1128,pre_nombre= 'Agregar Chequera',pre_grupo= 'Chequera',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030906 20:09:56',modificado= '20030906 20:09:56',activo= 1 where pre_id = 1128
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1128,'Agregar Chequera','Chequera','','','','','','20030906 20:09:56','20030906 20:09:56',1)
end
if exists(select * from Prestacion where pre_id = 1129) begin
update Prestacion set pre_id= 1129,pre_nombre= 'Editar Chequera',pre_grupo= 'Chequera',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030906 20:09:56',modificado= '20030906 20:09:56',activo= 1 where pre_id = 1129
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1129,'Editar Chequera','Chequera','','','','','','20030906 20:09:56','20030906 20:09:56',1)
end
GO
if exists(select * from Prestacion where pre_id = 1130) begin
update Prestacion set pre_id= 1130,pre_nombre= 'Borrar Chequera',pre_grupo= 'Chequera',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030906 20:09:56',modificado= '20030906 20:09:56',activo= 1 where pre_id = 1130
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1130,'Borrar Chequera','Chequera','','','','','','20030906 20:09:56','20030906 20:09:56',1)
end
if exists(select * from Prestacion where pre_id = 1131) begin
update Prestacion set pre_id= 1131,pre_nombre= 'Listar Chequera',pre_grupo= 'Chequera',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030906 20:09:56',modificado= '20030906 20:09:56',activo= 1 where pre_id = 1131
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1131,'Listar Chequera','Chequera','','','','','','20030906 20:09:56','20030906 20:09:56',1)
end
if exists(select * from Prestacion where pre_id = 1132) begin
update Prestacion set pre_id= 1132,pre_nombre= 'Agregar Calidad',pre_grupo= 'Calidad',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:16:36',modificado= '20031127 13:16:36',activo= 1 where pre_id = 1132
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1132,'Agregar Calidad','Calidad','','','','','','20031127 13:16:36','20031127 13:16:36',1)
end
if exists(select * from Prestacion where pre_id = 1133) begin
update Prestacion set pre_id= 1133,pre_nombre= 'Editar Calidad',pre_grupo= 'Calidad',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:16:36',modificado= '20031127 13:16:36',activo= 1 where pre_id = 1133
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1133,'Editar Calidad','Calidad','','','','','','20031127 13:16:36','20031127 13:16:36',1)
end
if exists(select * from Prestacion where pre_id = 1134) begin
update Prestacion set pre_id= 1134,pre_nombre= 'Borrar Calidad',pre_grupo= 'Calidad',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:16:36',modificado= '20031127 13:16:36',activo= 1 where pre_id = 1134
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1134,'Borrar Calidad','Calidad','','','','','','20031127 13:16:36','20031127 13:16:36',1)
end
if exists(select * from Prestacion where pre_id = 1135) begin
update Prestacion set pre_id= 1135,pre_nombre= 'Listar Calidad',pre_grupo= 'Calidad',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:16:36',modificado= '20031127 13:16:36',activo= 1 where pre_id = 1135
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1135,'Listar Calidad','Calidad','','','','','','20031127 13:16:36','20031127 13:16:36',1)
end
if exists(select * from Prestacion where pre_id = 1136) begin
update Prestacion set pre_id= 1136,pre_nombre= 'Agregar Marca',pre_grupo= 'Marca',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:16:36',modificado= '20031127 13:16:36',activo= 1 where pre_id = 1136
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1136,'Agregar Marca','Marca','','','','','','20031127 13:16:36','20031127 13:16:36',1)
end
if exists(select * from Prestacion where pre_id = 1137) begin
update Prestacion set pre_id= 1137,pre_nombre= 'Editar Marca',pre_grupo= 'Marca',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:16:36',modificado= '20031127 13:16:36',activo= 1 where pre_id = 1137
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1137,'Editar Marca','Marca','','','','','','20031127 13:16:36','20031127 13:16:36',1)
end
if exists(select * from Prestacion where pre_id = 1138) begin
update Prestacion set pre_id= 1138,pre_nombre= 'Borrar Marca',pre_grupo= 'Marca',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:16:36',modificado= '20031127 13:16:36',activo= 1 where pre_id = 1138
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1138,'Borrar Marca','Marca','','','','','','20031127 13:16:36','20031127 13:16:36',1)
end
if exists(select * from Prestacion where pre_id = 1139) begin
update Prestacion set pre_id= 1139,pre_nombre= 'Listar Marca',pre_grupo= 'Marca',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:16:36',modificado= '20031127 13:16:36',activo= 1 where pre_id = 1139
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1139,'Listar Marca','Marca','','','','','','20031127 13:16:36','20031127 13:16:36',1)
end
GO
if exists(select * from Prestacion where pre_id = 1140) begin
update Prestacion set pre_id= 1140,pre_nombre= 'Agregar Camion',pre_grupo= 'Camion',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:16:36',modificado= '20031127 13:16:36',activo= 1 where pre_id = 1140
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1140,'Agregar Camion','Camion','','','','','','20031127 13:16:36','20031127 13:16:36',1)
end
if exists(select * from Prestacion where pre_id = 1141) begin
update Prestacion set pre_id= 1141,pre_nombre= 'Editar Camion',pre_grupo= 'Camion',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:16:36',modificado= '20031127 13:16:36',activo= 1 where pre_id = 1141
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1141,'Editar Camion','Camion','','','','','','20031127 13:16:36','20031127 13:16:36',1)
end
if exists(select * from Prestacion where pre_id = 1142) begin
update Prestacion set pre_id= 1142,pre_nombre= 'Borrar Camion',pre_grupo= 'Camion',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:16:36',modificado= '20031127 13:16:36',activo= 1 where pre_id = 1142
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1142,'Borrar Camion','Camion','','','','','','20031127 13:16:36','20031127 13:16:36',1)
end
if exists(select * from Prestacion where pre_id = 1143) begin
update Prestacion set pre_id= 1143,pre_nombre= 'Listar Camion',pre_grupo= 'Camion',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:16:36',modificado= '20031127 13:16:36',activo= 1 where pre_id = 1143
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1143,'Listar Camion','Camion','','','','','','20031127 13:16:36','20031127 13:16:36',1)
end
if exists(select * from Prestacion where pre_id = 1144) begin
update Prestacion set pre_id= 1144,pre_nombre= 'Agregar Chofer',pre_grupo= 'Chofer',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:16:36',modificado= '20031127 13:16:36',activo= 1 where pre_id = 1144
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1144,'Agregar Chofer','Chofer','','','','','','20031127 13:16:36','20031127 13:16:36',1)
end
if exists(select * from Prestacion where pre_id = 1145) begin
update Prestacion set pre_id= 1145,pre_nombre= 'Editar Chofer',pre_grupo= 'Chofer',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:16:36',modificado= '20031127 13:16:36',activo= 1 where pre_id = 1145
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1145,'Editar Chofer','Chofer','','','','','','20031127 13:16:36','20031127 13:16:36',1)
end
if exists(select * from Prestacion where pre_id = 1146) begin
update Prestacion set pre_id= 1146,pre_nombre= 'Borrar Chofer',pre_grupo= 'Chofer',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:16:36',modificado= '20031127 13:16:36',activo= 1 where pre_id = 1146
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1146,'Borrar Chofer','Chofer','','','','','','20031127 13:16:36','20031127 13:16:36',1)
end
if exists(select * from Prestacion where pre_id = 1147) begin
update Prestacion set pre_id= 1147,pre_nombre= 'Listar Chofer',pre_grupo= 'Chofer',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:16:36',modificado= '20031127 13:16:36',activo= 1 where pre_id = 1147
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1147,'Listar Chofer','Chofer','','','','','','20031127 13:16:36','20031127 13:16:36',1)
end
if exists(select * from Prestacion where pre_id = 1148) begin
update Prestacion set pre_id= 1148,pre_nombre= 'Agregar Condición Pago',pre_grupo= 'Condición Pago',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031202 23:07:04',modificado= '20031202 23:07:04',activo= 1 where pre_id = 1148
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1148,'Agregar Condición Pago','Condición Pago','','','','','','20031202 23:07:04','20031202 23:07:04',1)
end
if exists(select * from Prestacion where pre_id = 1149) begin
update Prestacion set pre_id= 1149,pre_nombre= 'Editar Condición Pago',pre_grupo= 'Condición Pago',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031202 23:07:04',modificado= '20031202 23:07:04',activo= 1 where pre_id = 1149
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1149,'Editar Condición Pago','Condición Pago','','','','','','20031202 23:07:04','20031202 23:07:04',1)
end
GO
if exists(select * from Prestacion where pre_id = 1150) begin
update Prestacion set pre_id= 1150,pre_nombre= 'Borrar Condición Pago',pre_grupo= 'Condición Pago',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031202 23:07:04',modificado= '20031202 23:07:04',activo= 1 where pre_id = 1150
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1150,'Borrar Condición Pago','Condición Pago','','','','','','20031202 23:07:04','20031202 23:07:04',1)
end
if exists(select * from Prestacion where pre_id = 1151) begin
update Prestacion set pre_id= 1151,pre_nombre= 'Listar Condición Pago',pre_grupo= 'Condición Pago',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031202 23:07:04',modificado= '20031202 23:07:04',activo= 1 where pre_id = 1151
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1151,'Listar Condición Pago','Condición Pago','','','','','','20031202 23:07:04','20031202 23:07:04',1)
end
if exists(select * from Prestacion where pre_id = 1152) begin
update Prestacion set pre_id= 1152,pre_nombre= 'Agregar Listas de Descuento',pre_grupo= 'Lista de Descuento',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031203 18:20:42',modificado= '20031203 18:20:42',activo= 1 where pre_id = 1152
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1152,'Agregar Listas de Descuento','Lista de Descuento','','','','','','20031203 18:20:42','20031203 18:20:42',1)
end
if exists(select * from Prestacion where pre_id = 1153) begin
update Prestacion set pre_id= 1153,pre_nombre= 'Editar Listas de Descuento',pre_grupo= 'Lista de Descuento',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031203 18:20:42',modificado= '20031203 18:20:42',activo= 1 where pre_id = 1153
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1153,'Editar Listas de Descuento','Lista de Descuento','','','','','','20031203 18:20:42','20031203 18:20:42',1)
end
if exists(select * from Prestacion where pre_id = 1154) begin
update Prestacion set pre_id= 1154,pre_nombre= 'Borrar Listas de Descuento',pre_grupo= 'Lista de Descuento',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031203 18:20:42',modificado= '20031203 18:20:42',activo= 1 where pre_id = 1154
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1154,'Borrar Listas de Descuento','Lista de Descuento','','','','','','20031203 18:20:42','20031203 18:20:42',1)
end
if exists(select * from Prestacion where pre_id = 1155) begin
update Prestacion set pre_id= 1155,pre_nombre= 'Listar Listas de Descuento',pre_grupo= 'Lista de Descuento',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031203 18:20:42',modificado= '20031203 18:20:42',activo= 1 where pre_id = 1155
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1155,'Listar Listas de Descuento','Lista de Descuento','','','','','','20031203 18:20:42','20031203 18:20:42',1)
end
if exists(select * from Prestacion where pre_id = 1156) begin
update Prestacion set pre_id= 1156,pre_nombre= 'Editar configuración general',pre_grupo= 'Configuración general',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031210 11:42:08',modificado= '20031210 11:42:08',activo= 1 where pre_id = 1156
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1156,'Editar configuración general','Configuración general','','','','','','20031210 11:42:08','20031210 11:42:08',1)
end
if exists(select * from Prestacion where pre_id = 1157) begin
update Prestacion set pre_id= 1157,pre_nombre= 'Agregar Sucursal',pre_grupo= 'Sucursal',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040103 12:15:13',modificado= '20040103 12:15:13',activo= 1 where pre_id = 1157
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1157,'Agregar Sucursal','Sucursal','','','','','','20040103 12:15:13','20040103 12:15:13',1)
end
if exists(select * from Prestacion where pre_id = 1158) begin
update Prestacion set pre_id= 1158,pre_nombre= 'Editar Sucursal',pre_grupo= 'Sucursal',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040103 12:15:13',modificado= '20040103 12:15:13',activo= 1 where pre_id = 1158
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1158,'Editar Sucursal','Sucursal','','','','','','20040103 12:15:13','20040103 12:15:13',1)
end
if exists(select * from Prestacion where pre_id = 1159) begin
update Prestacion set pre_id= 1159,pre_nombre= 'Borrar Sucursal',pre_grupo= 'Sucursal',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 22:21:21',modificado= '20040514 22:21:21',activo= 1 where pre_id = 1159
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1159,'Borrar Sucursal','Sucursal','','','','','','20040514 22:21:21','20040514 22:21:21',1)
end
GO
if exists(select * from Prestacion where pre_id = 1160) begin
update Prestacion set pre_id= 1160,pre_nombre= 'Listar Sucursal',pre_grupo= 'Sucursal',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040103 12:15:13',modificado= '20040103 12:15:13',activo= 1 where pre_id = 1160
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1160,'Listar Sucursal','Sucursal','','','','','','20040103 12:15:13','20040103 12:15:13',1)
end
if exists(select * from Prestacion where pre_id = 1161) begin
update Prestacion set pre_id= 1161,pre_nombre= 'Agregar RubroTabla',pre_grupo= 'RubroTabla',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040118 15:50:55',modificado= '20040118 15:50:55',activo= 1 where pre_id = 1161
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1161,'Agregar RubroTabla','RubroTabla','','','','','','20040118 15:50:55','20040118 15:50:55',1)
end
if exists(select * from Prestacion where pre_id = 1162) begin
update Prestacion set pre_id= 1162,pre_nombre= 'Editar RubroTabla',pre_grupo= 'RubroTabla',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040118 15:50:55',modificado= '20040118 15:50:55',activo= 1 where pre_id = 1162
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1162,'Editar RubroTabla','RubroTabla','','','','','','20040118 15:50:55','20040118 15:50:55',1)
end
if exists(select * from Prestacion where pre_id = 1163) begin
update Prestacion set pre_id= 1163,pre_nombre= 'Borrar RubroTabla',pre_grupo= 'RubroTabla',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040118 15:50:55',modificado= '20040118 15:50:55',activo= 1 where pre_id = 1163
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1163,'Borrar RubroTabla','RubroTabla','','','','','','20040118 15:50:55','20040118 15:50:55',1)
end
if exists(select * from Prestacion where pre_id = 1164) begin
update Prestacion set pre_id= 1164,pre_nombre= 'Listar RubroTabla',pre_grupo= 'RubroTabla',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040118 15:50:55',modificado= '20040118 15:50:55',activo= 1 where pre_id = 1164
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1164,'Listar RubroTabla','RubroTabla','','','','','','20040118 15:50:55','20040118 15:50:55',1)
end
if exists(select * from Prestacion where pre_id = 1165) begin
update Prestacion set pre_id= 1165,pre_nombre= 'Agregar Gasto',pre_grupo= 'Gasto',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040203 10:31:36',modificado= '20040203 10:31:36',activo= 1 where pre_id = 1165
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1165,'Agregar Gasto','Gasto','','','','','','20040203 10:31:36','20040203 10:31:36',1)
end
if exists(select * from Prestacion where pre_id = 1166) begin
update Prestacion set pre_id= 1166,pre_nombre= 'Editar Gasto',pre_grupo= 'Gasto',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040203 10:31:36',modificado= '20040203 10:31:36',activo= 1 where pre_id = 1166
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1166,'Editar Gasto','Gasto','','','','','','20040203 10:31:36','20040203 10:31:36',1)
end
if exists(select * from Prestacion where pre_id = 1167) begin
update Prestacion set pre_id= 1167,pre_nombre= 'Borrar Gasto',pre_grupo= 'Gasto',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040203 10:31:36',modificado= '20040203 10:31:36',activo= 1 where pre_id = 1167
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1167,'Borrar Gasto','Gasto','','','','','','20040203 10:31:36','20040203 10:31:36',1)
end
if exists(select * from Prestacion where pre_id = 1168) begin
update Prestacion set pre_id= 1168,pre_nombre= 'Listar Gasto',pre_grupo= 'Gasto',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040203 10:31:36',modificado= '20040203 10:31:36',activo= 1 where pre_id = 1168
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1168,'Listar Gasto','Gasto','','','','','','20040203 10:31:36','20040203 10:31:36',1)
end
if exists(select * from Prestacion where pre_id = 1169) begin
update Prestacion set pre_id= 1169,pre_nombre= 'Agregar Grupos Cuenta',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040216 14:17:28',modificado= '20040216 14:17:28',activo= 1 where pre_id = 1169
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1169,'Agregar Grupos Cuenta','General','','','','','','20040216 14:17:28','20040216 14:17:28',1)
end
GO
if exists(select * from Prestacion where pre_id = 1170) begin
update Prestacion set pre_id= 1170,pre_nombre= 'Editar Grupos Cuenta',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040216 14:17:28',modificado= '20040216 14:17:28',activo= 1 where pre_id = 1170
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1170,'Editar Grupos Cuenta','General','','','','','','20040216 14:17:28','20040216 14:17:28',1)
end
if exists(select * from Prestacion where pre_id = 1171) begin
update Prestacion set pre_id= 1171,pre_nombre= 'Borrar Grupos Cuenta',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040216 14:17:28',modificado= '20040216 14:17:28',activo= 1 where pre_id = 1171
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1171,'Borrar Grupos Cuenta','General','','','','','','20040216 14:17:28','20040216 14:17:28',1)
end
if exists(select * from Prestacion where pre_id = 1172) begin
update Prestacion set pre_id= 1172,pre_nombre= 'Listar Grupos Cuenta',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040216 14:17:28',modificado= '20040216 14:17:28',activo= 1 where pre_id = 1172
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1172,'Listar Grupos Cuenta','General','','','','','','20040216 14:17:28','20040216 14:17:28',1)
end
if exists(select * from Prestacion where pre_id = 1173) begin
update Prestacion set pre_id= 1173,pre_nombre= 'Editar configuración general de ventas',pre_grupo= 'Configuración general',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040304 18:11:40',modificado= '20040304 18:11:40',activo= 1 where pre_id = 1173
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1173,'Editar configuración general de ventas','Configuración general','','','','','','20040304 18:11:40','20040304 18:11:40',1)
end
if exists(select * from Prestacion where pre_id = 1174) begin
update Prestacion set pre_id= 1174,pre_nombre= 'Editar configuración general de tesoreria',pre_grupo= 'Configuración general',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040313 21:36:34',modificado= '20040313 21:36:34',activo= 1 where pre_id = 1174
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1174,'Editar configuración general de tesoreria','Configuración general','','','','','','20040313 21:36:34','20040313 21:36:34',1)
end
if exists(select * from Prestacion where pre_id = 1175) begin
update Prestacion set pre_id= 1175,pre_nombre= 'Editar configuración general de compras',pre_grupo= 'Configuración general',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040409 17:20:12',modificado= '20040409 17:20:12',activo= 1 where pre_id = 1175
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1175,'Editar configuración general de compras','Configuración general','','','','','','20040409 17:20:12','20040409 17:20:12',1)
end
if exists(select * from Prestacion where pre_id = 1176) begin
update Prestacion set pre_id= 1176,pre_nombre= 'Agregar Percepcion',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040427 20:45:09',modificado= '20040427 20:45:09',activo= 1 where pre_id = 1176
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1176,'Agregar Percepcion','General','','','','','','20040427 20:45:09','20040427 20:45:09',1)
end
if exists(select * from Prestacion where pre_id = 1178) begin
update Prestacion set pre_id= 1178,pre_nombre= 'Borrar Percepcion',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040427 20:45:09',modificado= '20040427 20:45:09',activo= 1 where pre_id = 1178
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1178,'Borrar Percepcion','General','','','','','','20040427 20:45:09','20040427 20:45:09',1)
end
if exists(select * from Prestacion where pre_id = 1179) begin
update Prestacion set pre_id= 1179,pre_nombre= 'Editar Percepcion',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040427 20:45:09',modificado= '20040427 20:45:09',activo= 1 where pre_id = 1179
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1179,'Editar Percepcion','General','','','','','','20040427 20:45:09','20040427 20:45:09',1)
end
if exists(select * from Prestacion where pre_id = 1180) begin
update Prestacion set pre_id= 1180,pre_nombre= 'Listar Percepcion',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040427 20:45:09',modificado= '20040427 20:45:09',activo= 1 where pre_id = 1180
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1180,'Listar Percepcion','General','','','','','','20040427 20:45:09','20040427 20:45:09',1)
end
GO
if exists(select * from Prestacion where pre_id = 1181) begin
update Prestacion set pre_id= 1181,pre_nombre= 'Agregar Percepcion Tipo',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040427 20:45:09',modificado= '20040427 20:45:09',activo= 1 where pre_id = 1181
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1181,'Agregar Percepcion Tipo','General','','','','','','20040427 20:45:09','20040427 20:45:09',1)
end
if exists(select * from Prestacion where pre_id = 1182) begin
update Prestacion set pre_id= 1182,pre_nombre= 'Borrar Percepcion Tipo',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040427 20:45:09',modificado= '20040427 20:45:09',activo= 1 where pre_id = 1182
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1182,'Borrar Percepcion Tipo','General','','','','','','20040427 20:45:09','20040427 20:45:09',1)
end
if exists(select * from Prestacion where pre_id = 1183) begin
update Prestacion set pre_id= 1183,pre_nombre= 'Editar Percepcion Tipo',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040427 20:45:09',modificado= '20040427 20:45:09',activo= 1 where pre_id = 1183
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1183,'Editar Percepcion Tipo','General','','','','','','20040427 20:45:09','20040427 20:45:09',1)
end
if exists(select * from Prestacion where pre_id = 1184) begin
update Prestacion set pre_id= 1184,pre_nombre= 'Listar Percepcion Tipo',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040427 20:45:09',modificado= '20040427 20:45:09',activo= 1 where pre_id = 1184
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1184,'Listar Percepcion Tipo','General','','','','','','20040427 20:45:09','20040427 20:45:09',1)
end
if exists(select * from Prestacion where pre_id = 1185) begin
update Prestacion set pre_id= 1185,pre_nombre= 'Agregar Retencion',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040427 20:45:09',modificado= '20040427 20:45:09',activo= 1 where pre_id = 1185
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1185,'Agregar Retencion','General','','','','','','20040427 20:45:09','20040427 20:45:09',1)
end
if exists(select * from Prestacion where pre_id = 1186) begin
update Prestacion set pre_id= 1186,pre_nombre= 'Borrar Retencion',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040427 20:45:09',modificado= '20040427 20:45:09',activo= 1 where pre_id = 1186
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1186,'Borrar Retencion','General','','','','','','20040427 20:45:09','20040427 20:45:09',1)
end
if exists(select * from Prestacion where pre_id = 1187) begin
update Prestacion set pre_id= 1187,pre_nombre= 'Editar Retencion',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040427 20:45:09',modificado= '20040427 20:45:09',activo= 1 where pre_id = 1187
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1187,'Editar Retencion','General','','','','','','20040427 20:45:09','20040427 20:45:09',1)
end
if exists(select * from Prestacion where pre_id = 1188) begin
update Prestacion set pre_id= 1188,pre_nombre= 'Listar Retencion',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040427 20:45:09',modificado= '20040427 20:45:09',activo= 1 where pre_id = 1188
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1188,'Listar Retencion','General','','','','','','20040427 20:45:09','20040427 20:45:09',1)
end
if exists(select * from Prestacion where pre_id = 1189) begin
update Prestacion set pre_id= 1189,pre_nombre= 'Agregar Retencion Tipo',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040427 20:45:09',modificado= '20040427 20:45:09',activo= 1 where pre_id = 1189
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1189,'Agregar Retencion Tipo','General','','','','','','20040427 20:45:09','20040427 20:45:09',1)
end
if exists(select * from Prestacion where pre_id = 1190) begin
update Prestacion set pre_id= 1190,pre_nombre= 'Borrar Retencion Tipo',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040427 20:45:09',modificado= '20040427 20:45:09',activo= 1 where pre_id = 1190
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1190,'Borrar Retencion Tipo','General','','','','','','20040427 20:45:09','20040427 20:45:09',1)
end
GO
if exists(select * from Prestacion where pre_id = 1191) begin
update Prestacion set pre_id= 1191,pre_nombre= 'Editar Retencion Tipo',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040427 20:45:09',modificado= '20040427 20:45:09',activo= 1 where pre_id = 1191
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1191,'Editar Retencion Tipo','General','','','','','','20040427 20:45:09','20040427 20:45:09',1)
end
if exists(select * from Prestacion where pre_id = 1192) begin
update Prestacion set pre_id= 1192,pre_nombre= 'Listar Retencion Tipo',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040427 20:45:09',modificado= '20040427 20:45:09',activo= 1 where pre_id = 1192
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1192,'Listar Retencion Tipo','General','','','','','','20040427 20:45:09','20040427 20:45:09',1)
end
if exists(select * from Prestacion where pre_id = 1193) begin
update Prestacion set pre_id= 1193,pre_nombre= 'Agregar Departamento',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 22:02:46',modificado= '20040514 22:02:46',activo= 1 where pre_id = 1193
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1193,'Agregar Departamento','General','','','','','','20040514 22:02:46','20040514 22:02:46',1)
end
if exists(select * from Prestacion where pre_id = 1194) begin
update Prestacion set pre_id= 1194,pre_nombre= 'Borrar Departamento',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 22:02:46',modificado= '20040514 22:02:46',activo= 1 where pre_id = 1194
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1194,'Borrar Departamento','General','','','','','','20040514 22:02:46','20040514 22:02:46',1)
end
if exists(select * from Prestacion where pre_id = 1195) begin
update Prestacion set pre_id= 1195,pre_nombre= 'Editar Departamento',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 22:30:16',modificado= '20040514 22:30:16',activo= 1 where pre_id = 1195
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1195,'Editar Departamento','General','','','','','','20040514 22:30:16','20040514 22:30:16',1)
end
if exists(select * from Prestacion where pre_id = 1196) begin
update Prestacion set pre_id= 1196,pre_nombre= 'Listar Departamento',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 22:02:46',modificado= '20040514 22:02:46',activo= 1 where pre_id = 1196
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1196,'Listar Departamento','General','','','','','','20040514 22:02:46','20040514 22:02:46',1)
end
if exists(select * from Prestacion where pre_id = 1197) begin
update Prestacion set pre_id= 1197,pre_nombre= 'Agregar Circuito Contable',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040530 12:53:02',modificado= '20040530 12:53:02',activo= 1 where pre_id = 1197
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1197,'Agregar Circuito Contable','General','','','','','','20040530 12:53:02','20040530 12:53:02',1)
end
if exists(select * from Prestacion where pre_id = 1198) begin
update Prestacion set pre_id= 1198,pre_nombre= 'Editar Circuito Contable',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040530 12:53:02',modificado= '20040530 12:53:02',activo= 1 where pre_id = 1198
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1198,'Editar Circuito Contable','General','','','','','','20040530 12:53:02','20040530 12:53:02',1)
end
if exists(select * from Prestacion where pre_id = 1199) begin
update Prestacion set pre_id= 1199,pre_nombre= 'Borrar Circuito Contable',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040530 12:53:02',modificado= '20040530 12:53:02',activo= 1 where pre_id = 1199
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1199,'Borrar Circuito Contable','General','','','','','','20040530 12:53:02','20040530 12:53:02',1)
end
if exists(select * from Prestacion where pre_id = 1200) begin
update Prestacion set pre_id= 1200,pre_nombre= 'Listar Circuito Contable',pre_grupo= 'General',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040530 12:53:02',modificado= '20040530 12:53:02',activo= 1 where pre_id = 1200
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1200,'Listar Circuito Contable','General','','','','','','20040530 12:53:02','20040530 12:53:02',1)
end
GO
if exists(select * from Prestacion where pre_id = 2000) begin
update Prestacion set pre_id= 2000,pre_nombre= 'Agregar Tareas',pre_grupo= 'Tareas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:50',modificado= '20030727 19:50:50',activo= 1 where pre_id = 2000
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2000,'Agregar Tareas','Tareas','','','','','','20030727 19:50:50','20030727 19:50:50',1)
end
if exists(select * from Prestacion where pre_id = 2001) begin
update Prestacion set pre_id= 2001,pre_nombre= 'Editar Tareas',pre_grupo= 'Tareas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:50',modificado= '20030727 19:50:50',activo= 1 where pre_id = 2001
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2001,'Editar Tareas','Tareas','','','','','','20030727 19:50:50','20030727 19:50:50',1)
end
if exists(select * from Prestacion where pre_id = 2002) begin
update Prestacion set pre_id= 2002,pre_nombre= 'Borrar Tareas',pre_grupo= 'Tareas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:50',modificado= '20030727 19:50:50',activo= 1 where pre_id = 2002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2002,'Borrar Tareas','Tareas','','','','','','20030727 19:50:50','20030727 19:50:50',1)
end
if exists(select * from Prestacion where pre_id = 2003) begin
update Prestacion set pre_id= 2003,pre_nombre= 'Listar Tareas',pre_grupo= 'Tareas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2003
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2003,'Listar Tareas','Tareas','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2004) begin
update Prestacion set pre_id= 2004,pre_nombre= 'Agregar Prioridades',pre_grupo= 'Prioridades',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2004
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2004,'Agregar Prioridades','Prioridades','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2005) begin
update Prestacion set pre_id= 2005,pre_nombre= 'Editar Prioridades',pre_grupo= 'Prioridades',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2005
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2005,'Editar Prioridades','Prioridades','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2006) begin
update Prestacion set pre_id= 2006,pre_nombre= 'Borrar Prioridades',pre_grupo= 'Prioridades',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2006
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2006,'Borrar Prioridades','Prioridades','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2007) begin
update Prestacion set pre_id= 2007,pre_nombre= 'Listar Prioridades',pre_grupo= 'Prioridades',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2007
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2007,'Listar Prioridades','Prioridades','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2008) begin
update Prestacion set pre_id= 2008,pre_nombre= 'Agregar Estados de tareas',pre_grupo= 'Estados de tareas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2008
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2008,'Agregar Estados de tareas','Estados de tareas','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2009) begin
update Prestacion set pre_id= 2009,pre_nombre= 'Editar Estados de tareas',pre_grupo= 'Estados de tareas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2009
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2009,'Editar Estados de tareas','Estados de tareas','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
GO
if exists(select * from Prestacion where pre_id = 2010) begin
update Prestacion set pre_id= 2010,pre_nombre= 'Borrar Estados de tareas',pre_grupo= 'Estados de tareas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2010
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2010,'Borrar Estados de tareas','Estados de tareas','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2011) begin
update Prestacion set pre_id= 2011,pre_nombre= 'Listar Estados de tareas',pre_grupo= 'Estados de tareas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2011
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2011,'Listar Estados de tareas','Estados de tareas','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2012) begin
update Prestacion set pre_id= 2012,pre_nombre= 'Agregar Contactos',pre_grupo= 'Contactos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2012
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2012,'Agregar Contactos','Contactos','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2013) begin
update Prestacion set pre_id= 2013,pre_nombre= 'Editar Contactos',pre_grupo= 'Contactos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2013
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2013,'Editar Contactos','Contactos','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2014) begin
update Prestacion set pre_id= 2014,pre_nombre= 'Borrar Contactos',pre_grupo= 'Contactos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2014
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2014,'Borrar Contactos','Contactos','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2015) begin
update Prestacion set pre_id= 2015,pre_nombre= 'Listar Contactos',pre_grupo= 'Contactos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2015
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2015,'Listar Contactos','Contactos','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2016) begin
update Prestacion set pre_id= 2016,pre_nombre= 'Agregar Proyectos',pre_grupo= 'Proyectos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2016
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2016,'Agregar Proyectos','Proyectos','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2017) begin
update Prestacion set pre_id= 2017,pre_nombre= 'Editar Proyectos',pre_grupo= 'Proyectos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2017
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2017,'Editar Proyectos','Proyectos','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2018) begin
update Prestacion set pre_id= 2018,pre_nombre= 'Borrar Proyectos',pre_grupo= 'Proyectos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2018
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2018,'Borrar Proyectos','Proyectos','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2019) begin
update Prestacion set pre_id= 2019,pre_nombre= 'Listar Proyectos',pre_grupo= 'Proyectos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2019
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2019,'Listar Proyectos','Proyectos','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
GO
if exists(select * from Prestacion where pre_id = 2020) begin
update Prestacion set pre_id= 2020,pre_nombre= 'Agregar Horas',pre_grupo= 'Horas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2020
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2020,'Agregar Horas','Horas','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2021) begin
update Prestacion set pre_id= 2021,pre_nombre= 'Editar Horas',pre_grupo= 'Horas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2021
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2021,'Editar Horas','Horas','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2022) begin
update Prestacion set pre_id= 2022,pre_nombre= 'Borrar Horas',pre_grupo= 'Horas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2022
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2022,'Borrar Horas','Horas','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 2023) begin
update Prestacion set pre_id= 2023,pre_nombre= 'Listar Horas',pre_grupo= 'Horas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 2023
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (2023,'Listar Horas','Horas','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 3000) begin
update Prestacion set pre_id= 3000,pre_nombre= 'Agregar Pedidos de Venta',pre_grupo= 'Pedidos de Venta',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 3000
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (3000,'Agregar Pedidos de Venta','Pedidos de Venta','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 3001) begin
update Prestacion set pre_id= 3001,pre_nombre= 'Editar Pedidos de Venta',pre_grupo= 'Pedidos de Venta',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 3001
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (3001,'Editar Pedidos de Venta','Pedidos de Venta','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 3002) begin
update Prestacion set pre_id= 3002,pre_nombre= 'Borrar Pedidos de Venta',pre_grupo= 'Pedidos de Venta',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:51',modificado= '20030727 19:50:51',activo= 1 where pre_id = 3002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (3002,'Borrar Pedidos de Venta','Pedidos de Venta','','','','','','20030727 19:50:51','20030727 19:50:51',1)
end
if exists(select * from Prestacion where pre_id = 3003) begin
update Prestacion set pre_id= 3003,pre_nombre= 'Listar Pedidos de Venta',pre_grupo= 'Pedidos de Venta',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:52',modificado= '20030727 19:50:52',activo= 1 where pre_id = 3003
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (3003,'Listar Pedidos de Venta','Pedidos de Venta','','','','','','20030727 19:50:52','20030727 19:50:52',1)
end
if exists(select * from Prestacion where pre_id = 3004) begin
update Prestacion set pre_id= 3004,pre_nombre= 'Des-anular Pedidos de Venta',pre_grupo= 'Pedidos de Venta',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040120 14:44:22',modificado= '20040120 14:44:22',activo= 1 where pre_id = 3004
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (3004,'Des-anular Pedidos de Venta','Pedidos de Venta','','','','','','20040120 14:44:22','20040120 14:44:22',1)
end
if exists(select * from Prestacion where pre_id = 3005) begin
update Prestacion set pre_id= 3005,pre_nombre= 'Anular Pedidos de Venta',pre_grupo= 'Pedidos de Venta',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040120 14:44:22',modificado= '20040120 14:44:22',activo= 1 where pre_id = 3005
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (3005,'Anular Pedidos de Venta','Pedidos de Venta','','','','','','20040120 14:44:22','20040120 14:44:22',1)
end
GO
if exists(select * from Prestacion where pre_id = 4000) begin
update Prestacion set pre_id= 4000,pre_nombre= 'Agregar Documentos',pre_grupo= 'Documentos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031025 15:00:32',modificado= '20031025 15:00:32',activo= 1 where pre_id = 4000
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (4000,'Agregar Documentos','Documentos','','','','','','20031025 15:00:32','20031025 15:00:32',1)
end
if exists(select * from Prestacion where pre_id = 4001) begin
update Prestacion set pre_id= 4001,pre_nombre= 'Editar Documentos',pre_grupo= 'Documentos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031025 15:00:32',modificado= '20031025 15:00:32',activo= 1 where pre_id = 4001
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (4001,'Editar Documentos','Documentos','','','','','','20031025 15:00:32','20031025 15:00:32',1)
end
if exists(select * from Prestacion where pre_id = 4002) begin
update Prestacion set pre_id= 4002,pre_nombre= 'Borrar Documentos',pre_grupo= 'Documentos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031025 15:00:32',modificado= '20031025 15:00:32',activo= 1 where pre_id = 4002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (4002,'Borrar Documentos','Documentos','','','','','','20031025 15:00:32','20031025 15:00:32',1)
end
if exists(select * from Prestacion where pre_id = 4003) begin
update Prestacion set pre_id= 4003,pre_nombre= 'Listar Documentos',pre_grupo= 'Documentos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031025 15:00:32',modificado= '20031025 15:00:32',activo= 1 where pre_id = 4003
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (4003,'Listar Documentos','Documentos','','','','','','20031025 15:00:32','20031025 15:00:32',1)
end
if exists(select * from Prestacion where pre_id = 4004) begin
update Prestacion set pre_id= 4004,pre_nombre= 'Agregar Fechas de Control de Acceso',pre_grupo= 'Documentos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031025 15:00:32',modificado= '20031025 15:00:32',activo= 1 where pre_id = 4004
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (4004,'Agregar Fechas de Control de Acceso','Documentos','','','','','','20031025 15:00:32','20031025 15:00:32',1)
end
if exists(select * from Prestacion where pre_id = 4005) begin
update Prestacion set pre_id= 4005,pre_nombre= 'Editar Fechas de Control de Acceso',pre_grupo= 'Documentos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031025 15:00:32',modificado= '20031025 15:00:32',activo= 1 where pre_id = 4005
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (4005,'Editar Fechas de Control de Acceso','Documentos','','','','','','20031025 15:00:32','20031025 15:00:32',1)
end
if exists(select * from Prestacion where pre_id = 4006) begin
update Prestacion set pre_id= 4006,pre_nombre= 'Borrar Fechas de Control de Acceso',pre_grupo= 'Documentos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031025 15:00:32',modificado= '20031025 15:00:32',activo= 1 where pre_id = 4006
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (4006,'Borrar Fechas de Control de Acceso','Documentos','','','','','','20031025 15:00:32','20031025 15:00:32',1)
end
if exists(select * from Prestacion where pre_id = 4007) begin
update Prestacion set pre_id= 4007,pre_nombre= 'Listar Fechas de Control de Acceso',pre_grupo= 'Documentos',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031025 15:00:32',modificado= '20031025 15:00:32',activo= 1 where pre_id = 4007
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (4007,'Listar Fechas de Control de Acceso','Documentos','','','','','','20031025 15:00:32','20031025 15:00:32',1)
end
if exists(select * from Prestacion where pre_id = 4008) begin
update Prestacion set pre_id= 4008,pre_nombre= 'Agregar Talonario',pre_grupo= 'Talonario',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031201 13:51:30',modificado= '20031201 13:51:30',activo= 1 where pre_id = 4008
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (4008,'Agregar Talonario','Talonario','','','','','','20031201 13:51:30','20031201 13:51:30',1)
end
if exists(select * from Prestacion where pre_id = 4009) begin
update Prestacion set pre_id= 4009,pre_nombre= 'Editar Talonario',pre_grupo= 'Talonario',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031201 13:51:30',modificado= '20031201 13:51:30',activo= 1 where pre_id = 4009
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (4009,'Editar Talonario','Talonario','','','','','','20031201 13:51:30','20031201 13:51:30',1)
end
GO
if exists(select * from Prestacion where pre_id = 4010) begin
update Prestacion set pre_id= 4010,pre_nombre= 'Borrar Talonario',pre_grupo= 'Talonario',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031201 13:51:30',modificado= '20031201 13:51:30',activo= 1 where pre_id = 4010
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (4010,'Borrar Talonario','Talonario','','','','','','20031201 13:51:30','20031201 13:51:30',1)
end
if exists(select * from Prestacion where pre_id = 4011) begin
update Prestacion set pre_id= 4011,pre_nombre= 'Listar Talonario',pre_grupo= 'Talonario',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031201 13:51:30',modificado= '20031201 13:51:30',activo= 1 where pre_id = 4011
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (4011,'Listar Talonario','Talonario','','','','','','20031201 13:51:30','20031201 13:51:30',1)
end
if exists(select * from Prestacion where pre_id = 5001) begin
update Prestacion set pre_id= 5001,pre_nombre= 'Agregar CDRom',pre_grupo= 'CDRom',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:52',modificado= '20030727 19:50:52',activo= 1 where pre_id = 5001
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (5001,'Agregar CDRom','CDRom','','','','','','20030727 19:50:52','20030727 19:50:52',1)
end
if exists(select * from Prestacion where pre_id = 5002) begin
update Prestacion set pre_id= 5002,pre_nombre= 'Editar CDRom',pre_grupo= 'CDRom',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:52',modificado= '20030727 19:50:52',activo= 1 where pre_id = 5002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (5002,'Editar CDRom','CDRom','','','','','','20030727 19:50:52','20030727 19:50:52',1)
end
if exists(select * from Prestacion where pre_id = 5003) begin
update Prestacion set pre_id= 5003,pre_nombre= 'Borrar CDRom',pre_grupo= 'CDRom',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:52',modificado= '20030727 19:50:52',activo= 1 where pre_id = 5003
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (5003,'Borrar CDRom','CDRom','','','','','','20030727 19:50:52','20030727 19:50:52',1)
end
if exists(select * from Prestacion where pre_id = 5004) begin
update Prestacion set pre_id= 5004,pre_nombre= 'Listar CDRom',pre_grupo= 'CDRom',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:52',modificado= '20030727 19:50:52',activo= 1 where pre_id = 5004
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (5004,'Listar CDRom','CDRom','','','','','','20030727 19:50:52','20030727 19:50:52',1)
end
if exists(select * from Prestacion where pre_id = 5005) begin
update Prestacion set pre_id= 5005,pre_nombre= 'Buscar CDRom',pre_grupo= 'CDRom',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:52',modificado= '20030727 19:50:52',activo= 1 where pre_id = 5005
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (5005,'Buscar CDRom','CDRom','','','','','','20030727 19:50:52','20030727 19:50:52',1)
end
if exists(select * from Prestacion where pre_id = 6001) begin
update Prestacion set pre_id= 6001,pre_nombre= 'Agregar AFIP Esquema',pre_grupo= 'AFIP Esquema',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:53',modificado= '20030727 19:50:53',activo= 1 where pre_id = 6001
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6001,'Agregar AFIP Esquema','AFIP Esquema','','','','','','20030727 19:50:53','20030727 19:50:53',1)
end
if exists(select * from Prestacion where pre_id = 6002) begin
update Prestacion set pre_id= 6002,pre_nombre= 'Editar AFIP Esquema',pre_grupo= 'AFIP Esquema',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:53',modificado= '20030727 19:50:53',activo= 1 where pre_id = 6002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6002,'Editar AFIP Esquema','AFIP Esquema','','','','','','20030727 19:50:53','20030727 19:50:53',1)
end
if exists(select * from Prestacion where pre_id = 6003) begin
update Prestacion set pre_id= 6003,pre_nombre= 'Borrar AFIP Esquema',pre_grupo= 'AFIP Esquema',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:53',modificado= '20030727 19:50:53',activo= 1 where pre_id = 6003
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6003,'Borrar AFIP Esquema','AFIP Esquema','','','','','','20030727 19:50:53','20030727 19:50:53',1)
end
GO
if exists(select * from Prestacion where pre_id = 6004) begin
update Prestacion set pre_id= 6004,pre_nombre= 'Listar AFIP Esquema',pre_grupo= 'AFIP Esquema',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:53',modificado= '20030727 19:50:53',activo= 1 where pre_id = 6004
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6004,'Listar AFIP Esquema','AFIP Esquema','','','','','','20030727 19:50:53','20030727 19:50:53',1)
end
if exists(select * from Prestacion where pre_id = 6005) begin
update Prestacion set pre_id= 6005,pre_nombre= 'Agregar AFIP Archivo',pre_grupo= 'AFIP Archivo',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:53',modificado= '20030727 19:50:53',activo= 1 where pre_id = 6005
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6005,'Agregar AFIP Archivo','AFIP Archivo','','','','','','20030727 19:50:53','20030727 19:50:53',1)
end
if exists(select * from Prestacion where pre_id = 6006) begin
update Prestacion set pre_id= 6006,pre_nombre= 'Editar AFIP Archivo',pre_grupo= 'AFIP Archivo',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:53',modificado= '20030727 19:50:53',activo= 1 where pre_id = 6006
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6006,'Editar AFIP Archivo','AFIP Archivo','','','','','','20030727 19:50:53','20030727 19:50:53',1)
end
if exists(select * from Prestacion where pre_id = 6007) begin
update Prestacion set pre_id= 6007,pre_nombre= 'Borrar AFIP Archivo',pre_grupo= 'AFIP Archivo',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:53',modificado= '20030727 19:50:53',activo= 1 where pre_id = 6007
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6007,'Borrar AFIP Archivo','AFIP Archivo','','','','','','20030727 19:50:53','20030727 19:50:53',1)
end
if exists(select * from Prestacion where pre_id = 6008) begin
update Prestacion set pre_id= 6008,pre_nombre= 'Listar AFIP Archivo',pre_grupo= 'AFIP Archivo',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:53',modificado= '20030727 19:50:53',activo= 1 where pre_id = 6008
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6008,'Listar AFIP Archivo','AFIP Archivo','','','','','','20030727 19:50:53','20030727 19:50:53',1)
end
if exists(select * from Prestacion where pre_id = 6009) begin
update Prestacion set pre_id= 6009,pre_nombre= 'Agregar AFIP Parametro',pre_grupo= 'AFIP Parametro',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:53',modificado= '20030727 19:50:53',activo= 1 where pre_id = 6009
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6009,'Agregar AFIP Parametro','AFIP Parametro','','','','','','20030727 19:50:53','20030727 19:50:53',1)
end
if exists(select * from Prestacion where pre_id = 6010) begin
update Prestacion set pre_id= 6010,pre_nombre= 'Editar AFIP Parametro',pre_grupo= 'AFIP Parametro',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:53',modificado= '20030727 19:50:53',activo= 1 where pre_id = 6010
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6010,'Editar AFIP Parametro','AFIP Parametro','','','','','','20030727 19:50:53','20030727 19:50:53',1)
end
if exists(select * from Prestacion where pre_id = 6011) begin
update Prestacion set pre_id= 6011,pre_nombre= 'Borrar AFIP Parametro',pre_grupo= 'AFIP Parametro',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:53',modificado= '20030727 19:50:53',activo= 1 where pre_id = 6011
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6011,'Borrar AFIP Parametro','AFIP Parametro','','','','','','20030727 19:50:53','20030727 19:50:53',1)
end
if exists(select * from Prestacion where pre_id = 6012) begin
update Prestacion set pre_id= 6012,pre_nombre= 'Listar AFIP Parametro',pre_grupo= 'AFIP Parametro',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:53',modificado= '20030727 19:50:53',activo= 1 where pre_id = 6012
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6012,'Listar AFIP Parametro','AFIP Parametro','','','','','','20030727 19:50:53','20030727 19:50:53',1)
end
if exists(select * from Prestacion where pre_id = 6013) begin
update Prestacion set pre_id= 6013,pre_nombre= 'Agregar AFIP Registro',pre_grupo= 'AFIP Registro',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:53',modificado= '20030727 19:50:53',activo= 1 where pre_id = 6013
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6013,'Agregar AFIP Registro','AFIP Registro','','','','','','20030727 19:50:53','20030727 19:50:53',1)
end
GO
if exists(select * from Prestacion where pre_id = 6014) begin
update Prestacion set pre_id= 6014,pre_nombre= 'Editar AFIP Registro',pre_grupo= 'AFIP Registro',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:53',modificado= '20030727 19:50:53',activo= 1 where pre_id = 6014
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6014,'Editar AFIP Registro','AFIP Registro','','','','','','20030727 19:50:53','20030727 19:50:53',1)
end
if exists(select * from Prestacion where pre_id = 6015) begin
update Prestacion set pre_id= 6015,pre_nombre= 'Borrar AFIP Registro',pre_grupo= 'AFIP Registro',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:53',modificado= '20030727 19:50:53',activo= 1 where pre_id = 6015
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6015,'Borrar AFIP Registro','AFIP Registro','','','','','','20030727 19:50:53','20030727 19:50:53',1)
end
if exists(select * from Prestacion where pre_id = 6016) begin
update Prestacion set pre_id= 6016,pre_nombre= 'Listar AFIP Registro',pre_grupo= 'AFIP Registro',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 19:50:53',modificado= '20030727 19:50:53',activo= 1 where pre_id = 6016
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6016,'Listar AFIP Registro','AFIP Registro','','','','','','20030727 19:50:53','20030727 19:50:53',1)
end
if exists(select * from Prestacion where pre_id = 6017) begin
update Prestacion set pre_id= 6017,pre_nombre= 'Procesar Informe AFIP',pre_grupo= 'AFIP Informe',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030727 20:22:36',modificado= '20030727 20:22:36',activo= 1 where pre_id = 6017
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (6017,'Procesar Informe AFIP','AFIP Informe','','','','','','20030727 20:22:36','20030727 20:22:36',1)
end
if exists(select * from Prestacion where pre_id = 7001) begin
update Prestacion set pre_id= 7001,pre_nombre= 'Agregar Informe',pre_grupo= 'Informe',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030810 16:03:33',modificado= '20030810 16:03:33',activo= 1 where pre_id = 7001
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (7001,'Agregar Informe','Informe','','','','','','20030810 16:03:33','20030810 16:03:33',1)
end
if exists(select * from Prestacion where pre_id = 7002) begin
update Prestacion set pre_id= 7002,pre_nombre= 'Editar Informe',pre_grupo= 'Informe',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030810 16:03:33',modificado= '20030810 16:03:33',activo= 1 where pre_id = 7002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (7002,'Editar Informe','Informe','','','','','','20030810 16:03:33','20030810 16:03:33',1)
end
if exists(select * from Prestacion where pre_id = 7003) begin
update Prestacion set pre_id= 7003,pre_nombre= 'Borrar Informe',pre_grupo= 'Informe',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030810 16:03:33',modificado= '20030810 16:03:33',activo= 1 where pre_id = 7003
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (7003,'Borrar Informe','Informe','','','','','','20030810 16:03:33','20030810 16:03:33',1)
end
if exists(select * from Prestacion where pre_id = 7004) begin
update Prestacion set pre_id= 7004,pre_nombre= 'Listar Informe',pre_grupo= 'Informe',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030810 16:03:33',modificado= '20030810 16:03:33',activo= 1 where pre_id = 7004
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (7004,'Listar Informe','Informe','','','','','','20030810 16:03:33','20030810 16:03:33',1)
end
if exists(select * from Prestacion where pre_id = 7005) begin
update Prestacion set pre_id= 7005,pre_nombre= 'Agregar Reporte',pre_grupo= 'Reporte',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031005 11:36:07',modificado= '20031005 11:36:07',activo= 1 where pre_id = 7005
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (7005,'Agregar Reporte','Reporte','','','','','','20031005 11:36:07','20031005 11:36:07',1)
end
if exists(select * from Prestacion where pre_id = 7006) begin
update Prestacion set pre_id= 7006,pre_nombre= 'Editar Reporte',pre_grupo= 'Reporte',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031005 11:36:07',modificado= '20031005 11:36:07',activo= 1 where pre_id = 7006
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (7006,'Editar Reporte','Reporte','','','','','','20031005 11:36:07','20031005 11:36:07',1)
end
GO
if exists(select * from Prestacion where pre_id = 7007) begin
update Prestacion set pre_id= 7007,pre_nombre= 'Borrar Reporte',pre_grupo= 'Reporte',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031005 11:36:07',modificado= '20031005 11:36:07',activo= 1 where pre_id = 7007
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (7007,'Borrar Reporte','Reporte','','','','','','20031005 11:36:07','20031005 11:36:07',1)
end
if exists(select * from Prestacion where pre_id = 7008) begin
update Prestacion set pre_id= 7008,pre_nombre= 'Listar Reporte',pre_grupo= 'Reporte',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031005 11:36:07',modificado= '20031005 11:36:07',activo= 1 where pre_id = 7008
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (7008,'Listar Reporte','Reporte','','','','','','20031005 11:36:07','20031005 11:36:07',1)
end
if exists(select * from Prestacion where pre_id = 7009) begin
update Prestacion set pre_id= 7009,pre_nombre= 'Agregar Parametro',pre_grupo= 'Parametro',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031005 11:36:07',modificado= '20031005 11:36:07',activo= 1 where pre_id = 7009
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (7009,'Agregar Parametro','Parametro','','','','','','20031005 11:36:07','20031005 11:36:07',1)
end
if exists(select * from Prestacion where pre_id = 7010) begin
update Prestacion set pre_id= 7010,pre_nombre= 'Editar Parametro',pre_grupo= 'Parametro',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031005 11:36:07',modificado= '20031005 11:36:07',activo= 1 where pre_id = 7010
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (7010,'Editar Parametro','Parametro','','','','','','20031005 11:36:07','20031005 11:36:07',1)
end
if exists(select * from Prestacion where pre_id = 7011) begin
update Prestacion set pre_id= 7011,pre_nombre= 'Borrar Parametro',pre_grupo= 'Parametro',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031005 11:36:07',modificado= '20031005 11:36:07',activo= 1 where pre_id = 7011
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (7011,'Borrar Parametro','Parametro','','','','','','20031005 11:36:07','20031005 11:36:07',1)
end
if exists(select * from Prestacion where pre_id = 7012) begin
update Prestacion set pre_id= 7012,pre_nombre= 'Listar Parametro',pre_grupo= 'Parametro',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031005 11:36:07',modificado= '20031005 11:36:07',activo= 1 where pre_id = 7012
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (7012,'Listar Parametro','Parametro','','','','','','20031005 11:36:07','20031005 11:36:07',1)
end
if exists(select * from Prestacion where pre_id = 7013) begin
update Prestacion set pre_id= 7013,pre_nombre= 'Modificar Configuracion de Informes',pre_grupo= 'Configuracion de Informes',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031016 14:41:01',modificado= '20031016 14:41:01',activo= 1 where pre_id = 7013
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (7013,'Modificar Configuracion de Informes','Configuracion de Informes','','','','','','20031016 14:41:01','20031016 14:41:01',1)
end
if exists(select * from Prestacion where pre_id = 8001) begin
update Prestacion set pre_id= 8001,pre_nombre= 'Importar Proveedores',pre_grupo= 'AFIP Resolucion 1361',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030819 11:54:28',modificado= '20030819 11:54:28',activo= 1 where pre_id = 8001
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (8001,'Importar Proveedores','AFIP Resolucion 1361','','','','','','20030819 11:54:28','20030819 11:54:28',1)
end
if exists(select * from Prestacion where pre_id = 8002) begin
update Prestacion set pre_id= 8002,pre_nombre= 'Listar CAIS vencidos',pre_grupo= 'AFIP Resolución 1361',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20030827 14:03:54',modificado= '20030827 14:03:54',activo= 1 where pre_id = 8002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (8002,'Listar CAIS vencidos','AFIP Resolución 1361','','','','','','20030827 14:03:54','20030827 14:03:54',1)
end
if exists(select * from Prestacion where pre_id = 11000) begin
update Prestacion set pre_id= 11000,pre_nombre= 'Agregar Alsa',pre_grupo= 'Alsa',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031130 13:34:55',modificado= '20031130 13:34:55',activo= 1 where pre_id = 11000
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11000,'Agregar Alsa','Alsa','','','','','','20031130 13:34:55','20031130 13:34:55',1)
end
GO
if exists(select * from Prestacion where pre_id = 11001) begin
update Prestacion set pre_id= 11001,pre_nombre= 'Editar Alsa',pre_grupo= 'Alsa',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031130 13:34:55',modificado= '20031130 13:34:55',activo= 1 where pre_id = 11001
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11001,'Editar Alsa','Alsa','','','','','','20031130 13:34:55','20031130 13:34:55',1)
end
if exists(select * from Prestacion where pre_id = 11002) begin
update Prestacion set pre_id= 11002,pre_nombre= 'Borrar Alsa',pre_grupo= 'Alsa',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031130 13:34:55',modificado= '20031130 13:34:55',activo= 1 where pre_id = 11002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11002,'Borrar Alsa','Alsa','','','','','','20031130 13:34:55','20031130 13:34:55',1)
end
if exists(select * from Prestacion where pre_id = 11003) begin
update Prestacion set pre_id= 11003,pre_nombre= 'Listar Alsa',pre_grupo= 'Alsa',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031130 13:34:55',modificado= '20031130 13:34:55',activo= 1 where pre_id = 11003
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11003,'Listar Alsa','Alsa','','','','','','20031130 13:34:55','20031130 13:34:55',1)
end
if exists(select * from Prestacion where pre_id = 11004) begin
update Prestacion set pre_id= 11004,pre_nombre= 'Agregar Medicamento',pre_grupo= 'Medicamento',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031130 13:34:55',modificado= '20031130 13:34:55',activo= 1 where pre_id = 11004
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11004,'Agregar Medicamento','Medicamento','','','','','','20031130 13:34:55','20031130 13:34:55',1)
end
if exists(select * from Prestacion where pre_id = 11005) begin
update Prestacion set pre_id= 11005,pre_nombre= 'Editar Medicamento',pre_grupo= 'Medicamento',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031130 13:34:55',modificado= '20031130 13:34:55',activo= 1 where pre_id = 11005
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11005,'Editar Medicamento','Medicamento','','','','','','20031130 13:34:55','20031130 13:34:55',1)
end
if exists(select * from Prestacion where pre_id = 11006) begin
update Prestacion set pre_id= 11006,pre_nombre= 'Borrar Medicamento',pre_grupo= 'Medicamento',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031130 13:34:55',modificado= '20031130 13:34:55',activo= 1 where pre_id = 11006
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11006,'Borrar Medicamento','Medicamento','','','','','','20031130 13:34:55','20031130 13:34:55',1)
end
if exists(select * from Prestacion where pre_id = 11007) begin
update Prestacion set pre_id= 11007,pre_nombre= 'Listar Medicamento',pre_grupo= 'Medicamento',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031130 13:34:55',modificado= '20031130 13:34:55',activo= 1 where pre_id = 11007
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11007,'Listar Medicamento','Medicamento','','','','','','20031130 13:34:55','20031130 13:34:55',1)
end
if exists(select * from Prestacion where pre_id = 11008) begin
update Prestacion set pre_id= 11008,pre_nombre= 'Agregar Reina',pre_grupo= 'Reina',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031130 13:34:55',modificado= '20031130 13:34:55',activo= 1 where pre_id = 11008
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11008,'Agregar Reina','Reina','','','','','','20031130 13:34:55','20031130 13:34:55',1)
end
if exists(select * from Prestacion where pre_id = 11009) begin
update Prestacion set pre_id= 11009,pre_nombre= 'Editar Reina',pre_grupo= 'Reina',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031130 13:34:55',modificado= '20031130 13:34:55',activo= 1 where pre_id = 11009
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11009,'Editar Reina','Reina','','','','','','20031130 13:34:55','20031130 13:34:55',1)
end
if exists(select * from Prestacion where pre_id = 11010) begin
update Prestacion set pre_id= 11010,pre_nombre= 'Borrar Reina',pre_grupo= 'Reina',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031130 13:34:55',modificado= '20031130 13:34:55',activo= 1 where pre_id = 11010
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11010,'Borrar Reina','Reina','','','','','','20031130 13:34:55','20031130 13:34:55',1)
end
GO
if exists(select * from Prestacion where pre_id = 11011) begin
update Prestacion set pre_id= 11011,pre_nombre= 'Listar Reina',pre_grupo= 'Reina',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031130 13:34:55',modificado= '20031130 13:34:55',activo= 1 where pre_id = 11011
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11011,'Listar Reina','Reina','','','','','','20031130 13:34:55','20031130 13:34:55',1)
end
if exists(select * from Prestacion where pre_id = 11012) begin
update Prestacion set pre_id= 11012,pre_nombre= 'Agregar Colmena',pre_grupo= 'Colmena',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031130 13:55:23',modificado= '20031130 13:55:23',activo= 1 where pre_id = 11012
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11012,'Agregar Colmena','Colmena','','','','','','20031130 13:55:23','20031130 13:55:23',1)
end
if exists(select * from Prestacion where pre_id = 11013) begin
update Prestacion set pre_id= 11013,pre_nombre= 'Editar Colmena',pre_grupo= 'Colmena',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031130 13:55:23',modificado= '20031130 13:55:23',activo= 1 where pre_id = 11013
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11013,'Editar Colmena','Colmena','','','','','','20031130 13:55:23','20031130 13:55:23',1)
end
if exists(select * from Prestacion where pre_id = 11014) begin
update Prestacion set pre_id= 11014,pre_nombre= 'Borrar Colmena',pre_grupo= 'Colmena',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031130 13:55:23',modificado= '20031130 13:55:23',activo= 1 where pre_id = 11014
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11014,'Borrar Colmena','Colmena','','','','','','20031130 13:55:23','20031130 13:55:23',1)
end
if exists(select * from Prestacion where pre_id = 11015) begin
update Prestacion set pre_id= 11015,pre_nombre= 'Listar Colmena',pre_grupo= 'Colmena',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031130 13:55:23',modificado= '20031130 13:55:23',activo= 1 where pre_id = 11015
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (11015,'Listar Colmena','Colmena','','','','','','20031130 13:55:23','20031130 13:55:23',1)
end
if exists(select * from Prestacion where pre_id = 13002) begin
update Prestacion set pre_id= 13002,pre_nombre= 'Agregar Maquina',pre_grupo= 'Maquina',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:51:34',modificado= '20031127 13:51:34',activo= 1 where pre_id = 13002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (13002,'Agregar Maquina','Maquina','','','','','','20031127 13:51:34','20031127 13:51:34',1)
end
if exists(select * from Prestacion where pre_id = 13003) begin
update Prestacion set pre_id= 13003,pre_nombre= 'Editar Maquina',pre_grupo= 'Maquina',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:51:34',modificado= '20031127 13:51:34',activo= 1 where pre_id = 13003
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (13003,'Editar Maquina','Maquina','','','','','','20031127 13:51:34','20031127 13:51:34',1)
end
if exists(select * from Prestacion where pre_id = 13004) begin
update Prestacion set pre_id= 13004,pre_nombre= 'Borrar Maquina',pre_grupo= 'Maquina',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:51:34',modificado= '20031127 13:51:34',activo= 1 where pre_id = 13004
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (13004,'Borrar Maquina','Maquina','','','','','','20031127 13:51:34','20031127 13:51:34',1)
end
if exists(select * from Prestacion where pre_id = 13005) begin
update Prestacion set pre_id= 13005,pre_nombre= 'Listar Maquina',pre_grupo= 'Maquina',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:51:34',modificado= '20031127 13:51:34',activo= 1 where pre_id = 13005
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (13005,'Listar Maquina','Maquina','','','','','','20031127 13:51:34','20031127 13:51:34',1)
end
if exists(select * from Prestacion where pre_id = 15001) begin
update Prestacion set pre_id= 15001,pre_nombre= 'Agregar Legajo',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:16',modificado= '20040514 15:41:16',activo= 1 where pre_id = 15001
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15001,'Agregar Legajo','Envios','','','','','','20040514 15:41:16','20040514 15:41:16',1)
end
GO
if exists(select * from Prestacion where pre_id = 15002) begin
update Prestacion set pre_id= 15002,pre_nombre= 'Editar Legajo',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:16',modificado= '20040514 15:41:16',activo= 1 where pre_id = 15002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15002,'Editar Legajo','Envios','','','','','','20040514 15:41:16','20040514 15:41:16',1)
end
if exists(select * from Prestacion where pre_id = 15003) begin
update Prestacion set pre_id= 15003,pre_nombre= 'Borrar Legajo',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:16',modificado= '20040514 15:41:16',activo= 1 where pre_id = 15003
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15003,'Borrar Legajo','Envios','','','','','','20040514 15:41:16','20040514 15:41:16',1)
end
if exists(select * from Prestacion where pre_id = 15004) begin
update Prestacion set pre_id= 15004,pre_nombre= 'Listar Legajo',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:16',modificado= '20040514 15:41:16',activo= 1 where pre_id = 15004
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15004,'Listar Legajo','Envios','','','','','','20040514 15:41:16','20040514 15:41:16',1)
end
if exists(select * from Prestacion where pre_id = 15005) begin
update Prestacion set pre_id= 15005,pre_nombre= 'Agregar Parte Diario',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:16',modificado= '20040514 15:41:16',activo= 1 where pre_id = 15005
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15005,'Agregar Parte Diario','Envios','','','','','','20040514 15:41:16','20040514 15:41:16',1)
end
if exists(select * from Prestacion where pre_id = 15006) begin
update Prestacion set pre_id= 15006,pre_nombre= 'Editar Parte Diario',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:16',modificado= '20040514 15:41:16',activo= 1 where pre_id = 15006
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15006,'Editar Parte Diario','Envios','','','','','','20040514 15:41:16','20040514 15:41:16',1)
end
if exists(select * from Prestacion where pre_id = 15007) begin
update Prestacion set pre_id= 15007,pre_nombre= 'Borrar Parte Diario',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:16',modificado= '20040514 15:41:16',activo= 1 where pre_id = 15007
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15007,'Borrar Parte Diario','Envios','','','','','','20040514 15:41:16','20040514 15:41:16',1)
end
if exists(select * from Prestacion where pre_id = 15008) begin
update Prestacion set pre_id= 15008,pre_nombre= 'Listar Parte Diario',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:16',modificado= '20040514 15:41:16',activo= 1 where pre_id = 15008
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15008,'Listar Parte Diario','Envios','','','','','','20040514 15:41:16','20040514 15:41:16',1)
end
if exists(select * from Prestacion where pre_id = 15009) begin
update Prestacion set pre_id= 15009,pre_nombre= 'Modificar configuración general',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:16',modificado= '20040514 15:41:16',activo= 1 where pre_id = 15009
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15009,'Modificar configuración general','Envios','','','','','','20040514 15:41:16','20040514 15:41:16',1)
end
if exists(select * from Prestacion where pre_id = 15010) begin
update Prestacion set pre_id= 15010,pre_nombre= 'Agregar TipoTransporte',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15010
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15010,'Agregar TipoTransporte','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15011) begin
update Prestacion set pre_id= 15011,pre_nombre= 'Editar TipoTransporte',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15011
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15011,'Editar TipoTransporte','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
GO
if exists(select * from Prestacion where pre_id = 15012) begin
update Prestacion set pre_id= 15012,pre_nombre= 'Borrar TipoTransporte',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15012
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15012,'Borrar TipoTransporte','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15013) begin
update Prestacion set pre_id= 15013,pre_nombre= 'Listar TipoTransporte',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15013
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15013,'Listar TipoTransporte','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15014) begin
update Prestacion set pre_id= 15014,pre_nombre= 'Agregar Tarifa',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15014
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15014,'Agregar Tarifa','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15015) begin
update Prestacion set pre_id= 15015,pre_nombre= 'Editar Tarifa',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15015
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15015,'Editar Tarifa','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15016) begin
update Prestacion set pre_id= 15016,pre_nombre= 'Borrar Tarifa',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15016
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15016,'Borrar Tarifa','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15017) begin
update Prestacion set pre_id= 15017,pre_nombre= 'Listar Tarifa',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15017
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15017,'Listar Tarifa','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15018) begin
update Prestacion set pre_id= 15018,pre_nombre= 'Agregar Tipo de Legajo',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15018
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15018,'Agregar Tipo de Legajo','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15019) begin
update Prestacion set pre_id= 15019,pre_nombre= 'Editar Tipo de Legajo',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15019
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15019,'Editar Tipo de Legajo','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15020) begin
update Prestacion set pre_id= 15020,pre_nombre= 'Borrar Tipo de Legajo',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15020
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15020,'Borrar Tipo de Legajo','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15021) begin
update Prestacion set pre_id= 15021,pre_nombre= 'Listar Tipo de Legajo',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15021
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15021,'Listar Tipo de Legajo','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
GO
if exists(select * from Prestacion where pre_id = 15022) begin
update Prestacion set pre_id= 15022,pre_nombre= 'Agregar Vuelo',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15022
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15022,'Agregar Vuelo','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15023) begin
update Prestacion set pre_id= 15023,pre_nombre= 'Editar Vuelo',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15023
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15023,'Editar Vuelo','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15024) begin
update Prestacion set pre_id= 15024,pre_nombre= 'Borrar Vuelo',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15024
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15024,'Borrar Vuelo','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15025) begin
update Prestacion set pre_id= 15025,pre_nombre= 'Listar Vuelos',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15025
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15025,'Listar Vuelos','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15026) begin
update Prestacion set pre_id= 15026,pre_nombre= 'Agregar Presupuesto',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15026
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15026,'Agregar Presupuesto','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15027) begin
update Prestacion set pre_id= 15027,pre_nombre= 'Editar Presupuesto',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15027
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15027,'Editar Presupuesto','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15028) begin
update Prestacion set pre_id= 15028,pre_nombre= 'Borrar Presupuesto',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15028
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15028,'Borrar Presupuesto','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15029) begin
update Prestacion set pre_id= 15029,pre_nombre= 'Listar Presupuestos',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15029
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15029,'Listar Presupuestos','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15030) begin
update Prestacion set pre_id= 15030,pre_nombre= 'Desanular Presupuestos',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15030
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15030,'Desanular Presupuestos','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
if exists(select * from Prestacion where pre_id = 15031) begin
update Prestacion set pre_id= 15031,pre_nombre= 'Anular Presupuesto',pre_grupo= 'Envios',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040514 15:41:17',modificado= '20040514 15:41:17',activo= 1 where pre_id = 15031
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (15031,'Anular Presupuesto','Envios','','','','','','20040514 15:41:17','20040514 15:41:17',1)
end
GO
if exists(select * from Prestacion where pre_id = 16002) begin
update Prestacion set pre_id= 16002,pre_nombre= 'Agregar Factura de ventas',pre_grupo= 'Ventas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040125 13:13:50',modificado= '20040125 13:13:50',activo= 1 where pre_id = 16002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (16002,'Agregar Factura de ventas','Ventas','','','','','','20040125 13:13:50','20040125 13:13:50',1)
end
if exists(select * from Prestacion where pre_id = 16003) begin
update Prestacion set pre_id= 16003,pre_nombre= 'Editar Factura de ventas',pre_grupo= 'Ventas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040125 13:13:50',modificado= '20040125 13:13:50',activo= 1 where pre_id = 16003
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (16003,'Editar Factura de ventas','Ventas','','','','','','20040125 13:13:50','20040125 13:13:50',1)
end
if exists(select * from Prestacion where pre_id = 16004) begin
update Prestacion set pre_id= 16004,pre_nombre= 'Borrar Factura de ventas',pre_grupo= 'Ventas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040125 13:13:50',modificado= '20040125 13:13:50',activo= 1 where pre_id = 16004
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (16004,'Borrar Factura de ventas','Ventas','','','','','','20040125 13:13:50','20040125 13:13:50',1)
end
if exists(select * from Prestacion where pre_id = 16005) begin
update Prestacion set pre_id= 16005,pre_nombre= 'Listar Factura de ventas',pre_grupo= 'Ventas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040125 13:13:50',modificado= '20040125 13:13:50',activo= 1 where pre_id = 16005
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (16005,'Listar Factura de ventas','Ventas','','','','','','20040125 13:13:50','20040125 13:13:50',1)
end
if exists(select * from Prestacion where pre_id = 16006) begin
update Prestacion set pre_id= 16006,pre_nombre= 'Agregar Remito de ventas',pre_grupo= 'Ventas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040125 13:13:50',modificado= '20040125 13:13:50',activo= 1 where pre_id = 16006
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (16006,'Agregar Remito de ventas','Ventas','','','','','','20040125 13:13:50','20040125 13:13:50',1)
end
if exists(select * from Prestacion where pre_id = 16007) begin
update Prestacion set pre_id= 16007,pre_nombre= 'Editar Remito de ventas',pre_grupo= 'Ventas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040125 13:13:50',modificado= '20040125 13:13:50',activo= 1 where pre_id = 16007
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (16007,'Editar Remito de ventas','Ventas','','','','','','20040125 13:13:50','20040125 13:13:50',1)
end
if exists(select * from Prestacion where pre_id = 16008) begin
update Prestacion set pre_id= 16008,pre_nombre= 'Borrar Remito de ventas',pre_grupo= 'Ventas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040125 13:13:50',modificado= '20040125 13:13:50',activo= 1 where pre_id = 16008
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (16008,'Borrar Remito de ventas','Ventas','','','','','','20040125 13:13:50','20040125 13:13:50',1)
end
if exists(select * from Prestacion where pre_id = 16009) begin
update Prestacion set pre_id= 16009,pre_nombre= 'Listar Remito de ventas',pre_grupo= 'Ventas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040125 13:13:50',modificado= '20040125 13:13:50',activo= 1 where pre_id = 16009
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (16009,'Listar Remito de ventas','Ventas','','','','','','20040125 13:13:50','20040125 13:13:50',1)
end
if exists(select * from Prestacion where pre_id = 16010) begin
update Prestacion set pre_id= 16010,pre_nombre= 'Des-anular Factura de ventas',pre_grupo= 'Ventas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040125 13:13:50',modificado= '20040125 13:13:50',activo= 1 where pre_id = 16010
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (16010,'Des-anular Factura de ventas','Ventas','','','','','','20040125 13:13:50','20040125 13:13:50',1)
end
if exists(select * from Prestacion where pre_id = 16011) begin
update Prestacion set pre_id= 16011,pre_nombre= 'Anular Factura de ventas',pre_grupo= 'Ventas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040125 13:13:50',modificado= '20040125 13:13:50',activo= 1 where pre_id = 16011
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (16011,'Anular Factura de ventas','Ventas','','','','','','20040125 13:13:50','20040125 13:13:50',1)
end
GO
if exists(select * from Prestacion where pre_id = 16012) begin
update Prestacion set pre_id= 16012,pre_nombre= 'Des-anular Remito de ventas',pre_grupo= 'Ventas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040125 13:13:50',modificado= '20040125 13:13:50',activo= 1 where pre_id = 16012
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (16012,'Des-anular Remito de ventas','Ventas','','','','','','20040125 13:13:50','20040125 13:13:50',1)
end
if exists(select * from Prestacion where pre_id = 16013) begin
update Prestacion set pre_id= 16013,pre_nombre= 'Anular Remito de ventas',pre_grupo= 'Ventas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040125 13:13:50',modificado= '20040125 13:13:50',activo= 1 where pre_id = 16013
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (16013,'Anular Remito de ventas','Ventas','','','','','','20040125 13:13:50','20040125 13:13:50',1)
end
if exists(select * from Prestacion where pre_id = 16014) begin
update Prestacion set pre_id= 16014,pre_nombre= 'Modificar aplicacion de ventas',pre_grupo= 'Ventas',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040502 23:44:19',modificado= '20040502 23:44:19',activo= 1 where pre_id = 16014
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (16014,'Modificar aplicacion de ventas','Ventas','','','','','','20040502 23:44:19','20040502 23:44:19',1)
end
if exists(select * from Prestacion where pre_id = 17002) begin
update Prestacion set pre_id= 17002,pre_nombre= 'Agregar Factura de Compras',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040126 15:37:27',modificado= '20040126 15:37:27',activo= 1 where pre_id = 17002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17002,'Agregar Factura de Compras','Compras','','','','','','20040126 15:37:27','20040126 15:37:27',1)
end
if exists(select * from Prestacion where pre_id = 17003) begin
update Prestacion set pre_id= 17003,pre_nombre= 'Editar Factura de Compras',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040126 15:37:27',modificado= '20040126 15:37:27',activo= 1 where pre_id = 17003
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17003,'Editar Factura de Compras','Compras','','','','','','20040126 15:37:27','20040126 15:37:27',1)
end
if exists(select * from Prestacion where pre_id = 17004) begin
update Prestacion set pre_id= 17004,pre_nombre= 'Borrar Factura de Compras',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040126 15:37:27',modificado= '20040126 15:37:27',activo= 1 where pre_id = 17004
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17004,'Borrar Factura de Compras','Compras','','','','','','20040126 15:37:27','20040126 15:37:27',1)
end
if exists(select * from Prestacion where pre_id = 17005) begin
update Prestacion set pre_id= 17005,pre_nombre= 'Listar Factura de Compras',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040126 15:37:27',modificado= '20040126 15:37:27',activo= 1 where pre_id = 17005
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17005,'Listar Factura de Compras','Compras','','','','','','20040126 15:37:27','20040126 15:37:27',1)
end
if exists(select * from Prestacion where pre_id = 17006) begin
update Prestacion set pre_id= 17006,pre_nombre= 'Agregar Remito de Compra',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040126 15:37:27',modificado= '20040126 15:37:27',activo= 1 where pre_id = 17006
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17006,'Agregar Remito de Compra','Compras','','','','','','20040126 15:37:27','20040126 15:37:27',1)
end
if exists(select * from Prestacion where pre_id = 17007) begin
update Prestacion set pre_id= 17007,pre_nombre= 'Editar Remito de Compra',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040126 15:37:27',modificado= '20040126 15:37:27',activo= 1 where pre_id = 17007
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17007,'Editar Remito de Compra','Compras','','','','','','20040126 15:37:27','20040126 15:37:27',1)
end
if exists(select * from Prestacion where pre_id = 17008) begin
update Prestacion set pre_id= 17008,pre_nombre= 'Borrar Remito de Compra',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040126 15:37:27',modificado= '20040126 15:37:27',activo= 1 where pre_id = 17008
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17008,'Borrar Remito de Compra','Compras','','','','','','20040126 15:37:27','20040126 15:37:27',1)
end
GO
if exists(select * from Prestacion where pre_id = 17009) begin
update Prestacion set pre_id= 17009,pre_nombre= 'Listar Remito de Compra',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040126 15:37:27',modificado= '20040126 15:37:27',activo= 1 where pre_id = 17009
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17009,'Listar Remito de Compra','Compras','','','','','','20040126 15:37:27','20040126 15:37:27',1)
end
if exists(select * from Prestacion where pre_id = 17010) begin
update Prestacion set pre_id= 17010,pre_nombre= 'Des-anular Factura de Compras',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040126 15:37:27',modificado= '20040126 15:37:27',activo= 1 where pre_id = 17010
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17010,'Des-anular Factura de Compras','Compras','','','','','','20040126 15:37:27','20040126 15:37:27',1)
end
if exists(select * from Prestacion where pre_id = 17011) begin
update Prestacion set pre_id= 17011,pre_nombre= 'Anular Factura de Compras',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040126 15:37:27',modificado= '20040126 15:37:27',activo= 1 where pre_id = 17011
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17011,'Anular Factura de Compras','Compras','','','','','','20040126 15:37:27','20040126 15:37:27',1)
end
if exists(select * from Prestacion where pre_id = 17012) begin
update Prestacion set pre_id= 17012,pre_nombre= 'Des-anular Remito de Compra',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040126 15:37:27',modificado= '20040126 15:37:27',activo= 1 where pre_id = 17012
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17012,'Des-anular Remito de Compra','Compras','','','','','','20040126 15:37:27','20040126 15:37:27',1)
end
if exists(select * from Prestacion where pre_id = 17013) begin
update Prestacion set pre_id= 17013,pre_nombre= 'Anular Remito de Compra',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040126 15:37:27',modificado= '20040126 15:37:27',activo= 1 where pre_id = 17013
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17013,'Anular Remito de Compra','Compras','','','','','','20040126 15:37:27','20040126 15:37:27',1)
end
if exists(select * from Prestacion where pre_id = 17014) begin
update Prestacion set pre_id= 17014,pre_nombre= 'Agregar Pedido de Compra',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040127 18:50:57',modificado= '20040127 18:50:57',activo= 1 where pre_id = 17014
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17014,'Agregar Pedido de Compra','Compras','','','','','','20040127 18:50:57','20040127 18:50:57',1)
end
if exists(select * from Prestacion where pre_id = 17015) begin
update Prestacion set pre_id= 17015,pre_nombre= 'Editar Pedido de Compra',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040127 18:50:57',modificado= '20040127 18:50:57',activo= 1 where pre_id = 17015
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17015,'Editar Pedido de Compra','Compras','','','','','','20040127 18:50:57','20040127 18:50:57',1)
end
if exists(select * from Prestacion where pre_id = 17016) begin
update Prestacion set pre_id= 17016,pre_nombre= 'Borrar Pedido de Compra',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040127 18:50:57',modificado= '20040127 18:50:57',activo= 1 where pre_id = 17016
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17016,'Borrar Pedido de Compra','Compras','','','','','','20040127 18:50:57','20040127 18:50:57',1)
end
if exists(select * from Prestacion where pre_id = 17017) begin
update Prestacion set pre_id= 17017,pre_nombre= 'Listar Pedido de Compra',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040127 18:50:58',modificado= '20040127 18:50:58',activo= 1 where pre_id = 17017
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17017,'Listar Pedido de Compra','Compras','','','','','','20040127 18:50:58','20040127 18:50:58',1)
end
if exists(select * from Prestacion where pre_id = 17018) begin
update Prestacion set pre_id= 17018,pre_nombre= 'Des-anular Pedido de Compra',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040127 18:50:58',modificado= '20040127 18:50:58',activo= 1 where pre_id = 17018
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17018,'Des-anular Pedido de Compra','Compras','','','','','','20040127 18:50:58','20040127 18:50:58',1)
end
GO
if exists(select * from Prestacion where pre_id = 17019) begin
update Prestacion set pre_id= 17019,pre_nombre= 'Anular Pedido de Compra',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040127 18:50:58',modificado= '20040127 18:50:58',activo= 1 where pre_id = 17019
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17019,'Anular Pedido de Compra','Compras','','','','','','20040127 18:50:58','20040127 18:50:58',1)
end
if exists(select * from Prestacion where pre_id = 17020) begin
update Prestacion set pre_id= 17020,pre_nombre= 'Modificar aplicacion de compras',pre_grupo= 'Compras',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040612 17:18:27',modificado= '20040612 17:18:27',activo= 1 where pre_id = 17020
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (17020,'Modificar aplicacion de compras','Compras','','','','','','20040612 17:18:27','20040612 17:18:27',1)
end
if exists(select * from Prestacion where pre_id = 18001) begin
update Prestacion set pre_id= 18001,pre_nombre= 'Agregar Deposito',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040309 14:18:31',modificado= '20040309 14:18:31',activo= 1 where pre_id = 18001
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18001,'Agregar Deposito','Tesoreria','','','','','','20040309 14:18:31','20040309 14:18:31',1)
end
if exists(select * from Prestacion where pre_id = 18002) begin
update Prestacion set pre_id= 18002,pre_nombre= 'Editar Deposito',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040309 14:18:31',modificado= '20040309 14:18:31',activo= 1 where pre_id = 18002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18002,'Editar Deposito','Tesoreria','','','','','','20040309 14:18:31','20040309 14:18:31',1)
end
if exists(select * from Prestacion where pre_id = 18003) begin
update Prestacion set pre_id= 18003,pre_nombre= 'Borrar Deposito',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040309 14:18:31',modificado= '20040309 14:18:31',activo= 1 where pre_id = 18003
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18003,'Borrar Deposito','Tesoreria','','','','','','20040309 14:18:31','20040309 14:18:31',1)
end
if exists(select * from Prestacion where pre_id = 18004) begin
update Prestacion set pre_id= 18004,pre_nombre= 'Listar Deposito',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040309 14:18:31',modificado= '20040309 14:18:31',activo= 1 where pre_id = 18004
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18004,'Listar Deposito','Tesoreria','','','','','','20040309 14:18:31','20040309 14:18:31',1)
end
if exists(select * from Prestacion where pre_id = 18005) begin
update Prestacion set pre_id= 18005,pre_nombre= 'Des anular Deposito',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040309 14:18:31',modificado= '20040309 14:18:31',activo= 1 where pre_id = 18005
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18005,'Des anular Deposito','Tesoreria','','','','','','20040309 14:18:31','20040309 14:18:31',1)
end
if exists(select * from Prestacion where pre_id = 18006) begin
update Prestacion set pre_id= 18006,pre_nombre= 'Anular Deposito',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040309 14:18:31',modificado= '20040309 14:18:31',activo= 1 where pre_id = 18006
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18006,'Anular Deposito','Tesoreria','','','','','','20040309 14:18:31','20040309 14:18:31',1)
end
if exists(select * from Prestacion where pre_id = 18007) begin
update Prestacion set pre_id= 18007,pre_nombre= 'Agregar Cobranza',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040309 14:18:31',modificado= '20040309 14:18:31',activo= 1 where pre_id = 18007
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18007,'Agregar Cobranza','Tesoreria','','','','','','20040309 14:18:31','20040309 14:18:31',1)
end
if exists(select * from Prestacion where pre_id = 18008) begin
update Prestacion set pre_id= 18008,pre_nombre= 'Editar Cobranza',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040309 14:18:31',modificado= '20040309 14:18:31',activo= 1 where pre_id = 18008
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18008,'Editar Cobranza','Tesoreria','','','','','','20040309 14:18:31','20040309 14:18:31',1)
end
GO
if exists(select * from Prestacion where pre_id = 18009) begin
update Prestacion set pre_id= 18009,pre_nombre= 'Borrar Cobranza',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040309 14:18:31',modificado= '20040309 14:18:31',activo= 1 where pre_id = 18009
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18009,'Borrar Cobranza','Tesoreria','','','','','','20040309 14:18:31','20040309 14:18:31',1)
end
if exists(select * from Prestacion where pre_id = 18010) begin
update Prestacion set pre_id= 18010,pre_nombre= 'Listar Cobranza',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040309 14:18:31',modificado= '20040309 14:18:31',activo= 1 where pre_id = 18010
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18010,'Listar Cobranza','Tesoreria','','','','','','20040309 14:18:31','20040309 14:18:31',1)
end
if exists(select * from Prestacion where pre_id = 18011) begin
update Prestacion set pre_id= 18011,pre_nombre= 'Des anular Cobranza',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040309 14:18:31',modificado= '20040309 14:18:31',activo= 1 where pre_id = 18011
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18011,'Des anular Cobranza','Tesoreria','','','','','','20040309 14:18:31','20040309 14:18:31',1)
end
if exists(select * from Prestacion where pre_id = 18012) begin
update Prestacion set pre_id= 18012,pre_nombre= 'Anular Cobranza',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040309 14:18:31',modificado= '20040309 14:18:31',activo= 1 where pre_id = 18012
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18012,'Anular Cobranza','Tesoreria','','','','','','20040309 14:18:31','20040309 14:18:31',1)
end
if exists(select * from Prestacion where pre_id = 18013) begin
update Prestacion set pre_id= 18013,pre_nombre= 'Modificar Aplicaciones',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040325 18:36:50',modificado= '20040325 18:36:50',activo= 1 where pre_id = 18013
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18013,'Modificar Aplicaciones','Tesoreria','','','','','','20040325 18:36:50','20040325 18:36:50',1)
end
if exists(select * from Prestacion where pre_id = 18014) begin
update Prestacion set pre_id= 18014,pre_nombre= 'Agregar Orden de Pago',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040407 14:40:01',modificado= '20040407 14:40:01',activo= 1 where pre_id = 18014
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18014,'Agregar Orden de Pago','Tesoreria','','','','','','20040407 14:40:01','20040407 14:40:01',1)
end
if exists(select * from Prestacion where pre_id = 18015) begin
update Prestacion set pre_id= 18015,pre_nombre= 'Editar Orden de Pago',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040407 14:40:01',modificado= '20040407 14:40:01',activo= 1 where pre_id = 18015
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18015,'Editar Orden de Pago','Tesoreria','','','','','','20040407 14:40:01','20040407 14:40:01',1)
end
if exists(select * from Prestacion where pre_id = 18016) begin
update Prestacion set pre_id= 18016,pre_nombre= 'Borrar Orden de Pago',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040407 14:40:01',modificado= '20040407 14:40:01',activo= 1 where pre_id = 18016
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18016,'Borrar Orden de Pago','Tesoreria','','','','','','20040407 14:40:01','20040407 14:40:01',1)
end
if exists(select * from Prestacion where pre_id = 18017) begin
update Prestacion set pre_id= 18017,pre_nombre= 'Listar Orden de Pago',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040407 14:40:01',modificado= '20040407 14:40:01',activo= 1 where pre_id = 18017
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18017,'Listar Orden de Pago','Tesoreria','','','','','','20040407 14:40:01','20040407 14:40:01',1)
end
if exists(select * from Prestacion where pre_id = 18018) begin
update Prestacion set pre_id= 18018,pre_nombre= 'Des anular Orden de Pago',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040407 14:40:01',modificado= '20040407 14:40:01',activo= 1 where pre_id = 18018
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18018,'Des anular Orden de Pago','Tesoreria','','','','','','20040407 14:40:01','20040407 14:40:01',1)
end
GO
if exists(select * from Prestacion where pre_id = 18019) begin
update Prestacion set pre_id= 18019,pre_nombre= 'Anular Orden de Pago',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040407 14:40:01',modificado= '20040407 14:40:01',activo= 1 where pre_id = 18019
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18019,'Anular Orden de Pago','Tesoreria','','','','','','20040407 14:40:01','20040407 14:40:01',1)
end
if exists(select * from Prestacion where pre_id = 18020) begin
update Prestacion set pre_id= 18020,pre_nombre= 'Agregar Movimiento de Fondo',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040512 10:16:03',modificado= '20040512 10:16:03',activo= 1 where pre_id = 18020
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18020,'Agregar Movimiento de Fondo','Tesoreria','','','','','','20040512 10:16:03','20040512 10:16:03',1)
end
if exists(select * from Prestacion where pre_id = 18021) begin
update Prestacion set pre_id= 18021,pre_nombre= 'Editar Movimiento de Fondo',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040512 10:16:03',modificado= '20040512 10:16:03',activo= 1 where pre_id = 18021
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18021,'Editar Movimiento de Fondo','Tesoreria','','','','','','20040512 10:16:03','20040512 10:16:03',1)
end
if exists(select * from Prestacion where pre_id = 18022) begin
update Prestacion set pre_id= 18022,pre_nombre= 'Borrar Movimiento de Fondo',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040512 10:16:03',modificado= '20040512 10:16:03',activo= 1 where pre_id = 18022
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18022,'Borrar Movimiento de Fondo','Tesoreria','','','','','','20040512 10:16:03','20040512 10:16:03',1)
end
if exists(select * from Prestacion where pre_id = 18023) begin
update Prestacion set pre_id= 18023,pre_nombre= 'Listar Movimiento de Fondo',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040512 10:16:03',modificado= '20040512 10:16:03',activo= 1 where pre_id = 18023
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18023,'Listar Movimiento de Fondo','Tesoreria','','','','','','20040512 10:16:03','20040512 10:16:03',1)
end
if exists(select * from Prestacion where pre_id = 18024) begin
update Prestacion set pre_id= 18024,pre_nombre= 'Des anular Movimiento de Fondo',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040512 10:16:03',modificado= '20040512 10:16:03',activo= 1 where pre_id = 18024
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18024,'Des anular Movimiento de Fondo','Tesoreria','','','','','','20040512 10:16:03','20040512 10:16:03',1)
end
if exists(select * from Prestacion where pre_id = 18025) begin
update Prestacion set pre_id= 18025,pre_nombre= 'Anular Movimiento de Fondo',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040512 10:16:03',modificado= '20040512 10:16:03',activo= 1 where pre_id = 18025
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18025,'Anular Movimiento de Fondo','Tesoreria','','','','','','20040512 10:16:03','20040512 10:16:03',1)
end
if exists(select * from Prestacion where pre_id = 18026) begin
update Prestacion set pre_id= 18026,pre_nombre= 'Agregar Rendición',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040512 10:16:03',modificado= '20040512 10:16:03',activo= 1 where pre_id = 18026
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18026,'Agregar Rendición','Tesoreria','','','','','','20040512 10:16:03','20040512 10:16:03',1)
end
if exists(select * from Prestacion where pre_id = 18027) begin
update Prestacion set pre_id= 18027,pre_nombre= 'Editar Rendición',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040512 10:16:03',modificado= '20040512 10:16:03',activo= 1 where pre_id = 18027
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18027,'Editar Rendición','Tesoreria','','','','','','20040512 10:16:03','20040512 10:16:03',1)
end
if exists(select * from Prestacion where pre_id = 18028) begin
update Prestacion set pre_id= 18028,pre_nombre= 'Borrar Rendición',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040512 10:16:03',modificado= '20040512 10:16:03',activo= 1 where pre_id = 18028
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18028,'Borrar Rendición','Tesoreria','','','','','','20040512 10:16:03','20040512 10:16:03',1)
end
GO
if exists(select * from Prestacion where pre_id = 18029) begin
update Prestacion set pre_id= 18029,pre_nombre= 'Listar Rendición',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040512 10:16:03',modificado= '20040512 10:16:03',activo= 1 where pre_id = 18029
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18029,'Listar Rendición','Tesoreria','','','','','','20040512 10:16:03','20040512 10:16:03',1)
end
if exists(select * from Prestacion where pre_id = 18030) begin
update Prestacion set pre_id= 18030,pre_nombre= 'Des anular Rendición',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040512 10:16:03',modificado= '20040512 10:16:03',activo= 1 where pre_id = 18030
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18030,'Des anular Rendición','Tesoreria','','','','','','20040512 10:16:03','20040512 10:16:03',1)
end
if exists(select * from Prestacion where pre_id = 18031) begin
update Prestacion set pre_id= 18031,pre_nombre= 'Anular Rendición',pre_grupo= 'Tesoreria',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040512 10:16:03',modificado= '20040512 10:16:03',activo= 1 where pre_id = 18031
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (18031,'Anular Rendición','Tesoreria','','','','','','20040512 10:16:03','20040512 10:16:03',1)
end
if exists(select * from Prestacion where pre_id = 19001) begin
update Prestacion set pre_id= 19001,pre_nombre= 'Agregar Asiento',pre_grupo= 'Asiento',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040223 10:45:14',modificado= '20040223 10:45:14',activo= 1 where pre_id = 19001
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (19001,'Agregar Asiento','Asiento','','','','','','20040223 10:45:14','20040223 10:45:14',1)
end
if exists(select * from Prestacion where pre_id = 19002) begin
update Prestacion set pre_id= 19002,pre_nombre= 'Editar Asiento',pre_grupo= 'Asiento',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040223 10:45:14',modificado= '20040223 10:45:14',activo= 1 where pre_id = 19002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (19002,'Editar Asiento','Asiento','','','','','','20040223 10:45:14','20040223 10:45:14',1)
end
if exists(select * from Prestacion where pre_id = 19003) begin
update Prestacion set pre_id= 19003,pre_nombre= 'Borrar Asiento',pre_grupo= 'Asiento',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040223 10:45:14',modificado= '20040223 10:45:14',activo= 1 where pre_id = 19003
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (19003,'Borrar Asiento','Asiento','','','','','','20040223 10:45:14','20040223 10:45:14',1)
end
if exists(select * from Prestacion where pre_id = 19004) begin
update Prestacion set pre_id= 19004,pre_nombre= 'Listar Asiento',pre_grupo= 'Asiento',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040223 10:45:14',modificado= '20040223 10:45:14',activo= 1 where pre_id = 19004
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (19004,'Listar Asiento','Asiento','','','','','','20040223 10:45:14','20040223 10:45:14',1)
end
if exists(select * from Prestacion where pre_id = 19005) begin
update Prestacion set pre_id= 19005,pre_nombre= 'Des anular Asiento',pre_grupo= 'Asiento',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040223 10:45:14',modificado= '20040223 10:45:14',activo= 1 where pre_id = 19005
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (19005,'Des anular Asiento','Asiento','','','','','','20040223 10:45:14','20040223 10:45:14',1)
end
if exists(select * from Prestacion where pre_id = 19006) begin
update Prestacion set pre_id= 19006,pre_nombre= 'Anular Asiento',pre_grupo= 'Asiento',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040223 10:45:14',modificado= '20040223 10:45:14',activo= 1 where pre_id = 19006
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (19006,'Anular Asiento','Asiento','','','','','','20040223 10:45:14','20040223 10:45:14',1)
end
if exists(select * from Prestacion where pre_id = 20001) begin
update Prestacion set pre_id= 20001,pre_nombre= 'Agregar Movimiento de Stock',pre_grupo= 'Stock',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040528 13:54:24',modificado= '20040528 13:54:24',activo= 1 where pre_id = 20001
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (20001,'Agregar Movimiento de Stock','Stock','','','','','','20040528 13:54:24','20040528 13:54:24',1)
end
GO
if exists(select * from Prestacion where pre_id = 20002) begin
update Prestacion set pre_id= 20002,pre_nombre= 'Editar Movimiento de Stock',pre_grupo= 'Stock',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040528 13:54:24',modificado= '20040528 13:54:24',activo= 1 where pre_id = 20002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (20002,'Editar Movimiento de Stock','Stock','','','','','','20040528 13:54:24','20040528 13:54:24',1)
end
if exists(select * from Prestacion where pre_id = 20003) begin
update Prestacion set pre_id= 20003,pre_nombre= 'Borrar Movimiento de Stock',pre_grupo= 'Stock',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040528 13:54:24',modificado= '20040528 13:54:24',activo= 1 where pre_id = 20003
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (20003,'Borrar Movimiento de Stock','Stock','','','','','','20040528 13:54:24','20040528 13:54:24',1)
end
if exists(select * from Prestacion where pre_id = 20004) begin
update Prestacion set pre_id= 20004,pre_nombre= 'Listar Movimiento de Stock',pre_grupo= 'Stock',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040528 13:54:24',modificado= '20040528 13:54:24',activo= 1 where pre_id = 20004
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (20004,'Listar Movimiento de Stock','Stock','','','','','','20040528 13:54:24','20040528 13:54:24',1)
end
if exists(select * from Prestacion where pre_id = 20005) begin
update Prestacion set pre_id= 20005,pre_nombre= 'Des-anular Movimiento de Stock',pre_grupo= 'Stock',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040528 13:54:24',modificado= '20040528 13:54:24',activo= 1 where pre_id = 20005
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (20005,'Des-anular Movimiento de Stock','Stock','','','','','','20040528 13:54:24','20040528 13:54:24',1)
end
if exists(select * from Prestacion where pre_id = 20006) begin
update Prestacion set pre_id= 20006,pre_nombre= 'Anular Movimiento de Stock',pre_grupo= 'Stock',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040528 13:54:24',modificado= '20040528 13:54:24',activo= 1 where pre_id = 20006
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (20006,'Anular Movimiento de Stock','Stock','','','','','','20040528 13:54:24','20040528 13:54:24',1)
end
if exists(select * from Prestacion where pre_id = 20007) begin
update Prestacion set pre_id= 20007,pre_nombre= 'Agregar Recuento de Stock',pre_grupo= 'RecuentoStock',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040616 21:41:57',modificado= '20040616 21:41:57',activo= 1 where pre_id = 20007
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (20007,'Agregar Recuento de Stock','RecuentoStock','','','','','','20040616 21:41:57','20040616 21:41:57',1)
end
if exists(select * from Prestacion where pre_id = 20008) begin
update Prestacion set pre_id= 20008,pre_nombre= 'Editar Recuento de Stock',pre_grupo= 'RecuentoStock',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040616 21:41:57',modificado= '20040616 21:41:57',activo= 1 where pre_id = 20008
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (20008,'Editar Recuento de Stock','RecuentoStock','','','','','','20040616 21:41:57','20040616 21:41:57',1)
end
if exists(select * from Prestacion where pre_id = 20009) begin
update Prestacion set pre_id= 20009,pre_nombre= 'Borrar Recuento de Stock',pre_grupo= 'RecuentoStock',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040616 21:41:57',modificado= '20040616 21:41:57',activo= 1 where pre_id = 20009
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (20009,'Borrar Recuento de Stock','RecuentoStock','','','','','','20040616 21:41:57','20040616 21:41:57',1)
end
if exists(select * from Prestacion where pre_id = 20010) begin
update Prestacion set pre_id= 20010,pre_nombre= 'Listar Recuento de Stock',pre_grupo= 'RecuentoStock',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040616 21:41:57',modificado= '20040616 21:41:57',activo= 1 where pre_id = 20010
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (20010,'Listar Recuento de Stock','RecuentoStock','','','','','','20040616 21:41:57','20040616 21:41:57',1)
end
if exists(select * from Prestacion where pre_id = 21001) begin
update Prestacion set pre_id= 21001,pre_nombre= 'Agregar Importacion',pre_grupo= 'Implementacion',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040214 20:33:01',modificado= '20040214 20:33:01',activo= 1 where pre_id = 21001
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (21001,'Agregar Importacion','Implementacion','','','','','','20040214 20:33:01','20040214 20:33:01',1)
end
GO
if exists(select * from Prestacion where pre_id = 21002) begin
update Prestacion set pre_id= 21002,pre_nombre= 'Borrar Importacion',pre_grupo= 'Implementacion',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040214 20:33:01',modificado= '20040214 20:33:01',activo= 1 where pre_id = 21002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (21002,'Borrar Importacion','Implementacion','','','','','','20040214 20:33:01','20040214 20:33:01',1)
end
if exists(select * from Prestacion where pre_id = 21003) begin
update Prestacion set pre_id= 21003,pre_nombre= 'Editar Importacion',pre_grupo= 'Implementacion',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040214 20:33:01',modificado= '20040214 20:33:01',activo= 1 where pre_id = 21003
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (21003,'Editar Importacion','Implementacion','','','','','','20040214 20:33:01','20040214 20:33:01',1)
end
if exists(select * from Prestacion where pre_id = 21004) begin
update Prestacion set pre_id= 21004,pre_nombre= 'Listar Importacion',pre_grupo= 'Implementacion',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040214 20:33:01',modificado= '20040214 20:33:01',activo= 1 where pre_id = 21004
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (21004,'Listar Importacion','Implementacion','','','','','','20040214 20:33:01','20040214 20:33:01',1)
end
if exists(select * from Prestacion where pre_id = 22001) begin
update Prestacion set pre_id= 22001,pre_nombre= 'Agregar Aduana',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040428 17:35:29',modificado= '20040428 17:35:29',activo= 1 where pre_id = 22001
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22001,'Agregar Aduana','Exportación','','','','','','20040428 17:35:29','20040428 17:35:29',1)
end
if exists(select * from Prestacion where pre_id = 22002) begin
update Prestacion set pre_id= 22002,pre_nombre= 'Editar Aduana',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040428 17:35:29',modificado= '20040428 17:35:29',activo= 1 where pre_id = 22002
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22002,'Editar Aduana','Exportación','','','','','','20040428 17:35:29','20040428 17:35:29',1)
end
if exists(select * from Prestacion where pre_id = 22003) begin
update Prestacion set pre_id= 22003,pre_nombre= 'Borrar Aduana',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040428 17:35:29',modificado= '20040428 17:35:29',activo= 1 where pre_id = 22003
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22003,'Borrar Aduana','Exportación','','','','','','20040428 17:35:29','20040428 17:35:29',1)
end
if exists(select * from Prestacion where pre_id = 22004) begin
update Prestacion set pre_id= 22004,pre_nombre= 'Listar Aduana',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040428 17:35:29',modificado= '20040428 17:35:29',activo= 1 where pre_id = 22004
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22004,'Listar Aduana','Exportación','','','','','','20040428 17:35:29','20040428 17:35:29',1)
end
if exists(select * from Prestacion where pre_id = 22005) begin
update Prestacion set pre_id= 22005,pre_nombre= 'Agregar Embarque',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040428 19:08:48',modificado= '20040428 19:08:48',activo= 1 where pre_id = 22005
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22005,'Agregar Embarque','Exportación','','','','','','20040428 19:08:48','20040428 19:08:48',1)
end
if exists(select * from Prestacion where pre_id = 22006) begin
update Prestacion set pre_id= 22006,pre_nombre= 'Editar Embarque',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040428 19:08:48',modificado= '20040428 19:08:48',activo= 1 where pre_id = 22006
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22006,'Editar Embarque','Exportación','','','','','','20040428 19:08:48','20040428 19:08:48',1)
end
if exists(select * from Prestacion where pre_id = 22007) begin
update Prestacion set pre_id= 22007,pre_nombre= 'Borrar Embarque',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040428 19:08:48',modificado= '20040428 19:08:48',activo= 1 where pre_id = 22007
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22007,'Borrar Embarque','Exportación','','','','','','20040428 19:08:48','20040428 19:08:48',1)
end
GO
if exists(select * from Prestacion where pre_id = 22008) begin
update Prestacion set pre_id= 22008,pre_nombre= 'Listar Embarque',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040428 19:08:48',modificado= '20040428 19:08:48',activo= 1 where pre_id = 22008
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22008,'Listar Embarque','Exportación','','','','','','20040428 19:08:48','20040428 19:08:48',1)
end
if exists(select * from Prestacion where pre_id = 22009) begin
update Prestacion set pre_id= 22009,pre_nombre= 'Agregar Permiso de Embarque',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040430 00:28:25',modificado= '20040430 00:28:25',activo= 1 where pre_id = 22009
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22009,'Agregar Permiso de Embarque','Exportación','','','','','','20040430 00:28:25','20040430 00:28:25',1)
end
if exists(select * from Prestacion where pre_id = 22010) begin
update Prestacion set pre_id= 22010,pre_nombre= 'Editar Permiso de Embarque',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040430 00:28:25',modificado= '20040430 00:28:25',activo= 1 where pre_id = 22010
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22010,'Editar Permiso de Embarque','Exportación','','','','','','20040430 00:28:25','20040430 00:28:25',1)
end
if exists(select * from Prestacion where pre_id = 22011) begin
update Prestacion set pre_id= 22011,pre_nombre= 'Borrar Permiso de Embarque',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040430 00:28:25',modificado= '20040430 00:28:25',activo= 1 where pre_id = 22011
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22011,'Borrar Permiso de Embarque','Exportación','','','','','','20040430 00:28:25','20040430 00:28:25',1)
end
if exists(select * from Prestacion where pre_id = 22012) begin
update Prestacion set pre_id= 22012,pre_nombre= 'Listar Permiso de Embarque',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040430 00:28:25',modificado= '20040430 00:28:25',activo= 1 where pre_id = 22012
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22012,'Listar Permiso de Embarque','Exportación','','','','','','20040430 00:28:25','20040430 00:28:25',1)
end
if exists(select * from Prestacion where pre_id = 22013) begin
update Prestacion set pre_id= 22013,pre_nombre= 'Des-anular Permiso de Embarque',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040430 00:28:25',modificado= '20040430 00:28:25',activo= 1 where pre_id = 22013
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22013,'Des-anular Permiso de Embarque','Exportación','','','','','','20040430 00:28:25','20040430 00:28:25',1)
end
if exists(select * from Prestacion where pre_id = 22014) begin
update Prestacion set pre_id= 22014,pre_nombre= 'Anular Permiso de Embarque',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040430 00:28:25',modificado= '20040430 00:28:25',activo= 1 where pre_id = 22014
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22014,'Anular Permiso de Embarque','Exportación','','','','','','20040430 00:28:25','20040430 00:28:25',1)
end
if exists(select * from Prestacion where pre_id = 22015) begin
update Prestacion set pre_id= 22015,pre_nombre= 'Agregar Manifiesto de Carga',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040430 15:07:25',modificado= '20040430 15:07:25',activo= 1 where pre_id = 22015
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22015,'Agregar Manifiesto de Carga','Exportación','','','','','','20040430 15:07:25','20040430 15:07:25',1)
end
if exists(select * from Prestacion where pre_id = 22016) begin
update Prestacion set pre_id= 22016,pre_nombre= 'Editar Manifiesto de Carga',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040430 15:07:25',modificado= '20040430 15:07:25',activo= 1 where pre_id = 22016
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22016,'Editar Manifiesto de Carga','Exportación','','','','','','20040430 15:07:25','20040430 15:07:25',1)
end
if exists(select * from Prestacion where pre_id = 22017) begin
update Prestacion set pre_id= 22017,pre_nombre= 'Borrar Manifiesto de Carga',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040430 15:07:25',modificado= '20040430 15:07:25',activo= 1 where pre_id = 22017
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22017,'Borrar Manifiesto de Carga','Exportación','','','','','','20040430 15:07:25','20040430 15:07:25',1)
end
GO
if exists(select * from Prestacion where pre_id = 22018) begin
update Prestacion set pre_id= 22018,pre_nombre= 'Listar Manifiesto de Carga',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040430 15:07:25',modificado= '20040430 15:07:25',activo= 1 where pre_id = 22018
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22018,'Listar Manifiesto de Carga','Exportación','','','','','','20040430 15:07:25','20040430 15:07:25',1)
end
if exists(select * from Prestacion where pre_id = 22019) begin
update Prestacion set pre_id= 22019,pre_nombre= 'Des-anular Manifiesto de Carga',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040430 15:07:25',modificado= '20040430 15:07:25',activo= 1 where pre_id = 22019
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22019,'Des-anular Manifiesto de Carga','Exportación','','','','','','20040430 15:07:25','20040430 15:07:25',1)
end
if exists(select * from Prestacion where pre_id = 22020) begin
update Prestacion set pre_id= 22020,pre_nombre= 'Anular Manifiesto de Carga',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040430 15:07:25',modificado= '20040430 15:07:25',activo= 1 where pre_id = 22020
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22020,'Anular Manifiesto de Carga','Exportación','','','','','','20040430 15:07:25','20040430 15:07:25',1)
end
if exists(select * from Prestacion where pre_id = 22021) begin
update Prestacion set pre_id= 22021,pre_nombre= 'Editar Packing List',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040506 14:21:30',modificado= '20040506 14:21:30',activo= 1 where pre_id = 22021
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22021,'Editar Packing List','Exportación','','','','','','20040506 14:21:30','20040506 14:21:30',1)
end
if exists(select * from Prestacion where pre_id = 22022) begin
update Prestacion set pre_id= 22022,pre_nombre= 'Borrar Packing List',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040506 14:21:30',modificado= '20040506 14:21:30',activo= 1 where pre_id = 22022
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22022,'Borrar Packing List','Exportación','','','','','','20040506 14:21:30','20040506 14:21:30',1)
end
if exists(select * from Prestacion where pre_id = 22023) begin
update Prestacion set pre_id= 22023,pre_nombre= 'Listar Packing List',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040506 14:21:30',modificado= '20040506 14:21:30',activo= 1 where pre_id = 22023
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22023,'Listar Packing List','Exportación','','','','','','20040506 14:21:30','20040506 14:21:30',1)
end
if exists(select * from Prestacion where pre_id = 22024) begin
update Prestacion set pre_id= 22024,pre_nombre= 'Des-anular Packing List',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040506 14:21:30',modificado= '20040506 14:21:30',activo= 1 where pre_id = 22024
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22024,'Des-anular Packing List','Exportación','','','','','','20040506 14:21:30','20040506 14:21:30',1)
end
if exists(select * from Prestacion where pre_id = 22025) begin
update Prestacion set pre_id= 22025,pre_nombre= 'Anular Packing List',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040506 14:21:30',modificado= '20040506 14:21:30',activo= 1 where pre_id = 22025
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22025,'Anular Packing List','Exportación','','','','','','20040506 14:21:30','20040506 14:21:30',1)
end
if exists(select * from Prestacion where pre_id = 22026) begin
update Prestacion set pre_id= 22026,pre_nombre= 'Modificar aplicacion de exportación',pre_grupo= 'Exportación',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040506 14:21:30',modificado= '20040506 14:21:30',activo= 1 where pre_id = 22026
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (22026,'Modificar aplicacion de exportación','Exportación','','','','','','20040506 14:21:30','20040506 14:21:30',1)
end
if exists(select * from Prestacion where pre_id = 1000033) begin
update Prestacion set pre_id= 1000033,pre_nombre= 'Agregar Configuracion Calibradora',pre_grupo= 'Configuracion Calibradora',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000033
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000033,'Agregar Configuracion Calibradora','Configuracion Calibradora','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
GO
if exists(select * from Prestacion where pre_id = 1000034) begin
update Prestacion set pre_id= 1000034,pre_nombre= 'Editar Configuracion Calibradora',pre_grupo= 'Configuracion Calibradora',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000034
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000034,'Editar Configuracion Calibradora','Configuracion Calibradora','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000035) begin
update Prestacion set pre_id= 1000035,pre_nombre= 'Borrar Configuracion Calibradora',pre_grupo= 'Configuracion Calibradora',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000035
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000035,'Borrar Configuracion Calibradora','Configuracion Calibradora','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000036) begin
update Prestacion set pre_id= 1000036,pre_nombre= 'Listar Configuracion Calibradora',pre_grupo= 'Configuracion Calibradora',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000036
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000036,'Listar Configuracion Calibradora','Configuracion Calibradora','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000037) begin
update Prestacion set pre_id= 1000037,pre_nombre= 'Agregar Calibradora',pre_grupo= 'Calibradora',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000037
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000037,'Agregar Calibradora','Calibradora','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000038) begin
update Prestacion set pre_id= 1000038,pre_nombre= 'Editar Calibradora',pre_grupo= 'Calibradora',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000038
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000038,'Editar Calibradora','Calibradora','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000039) begin
update Prestacion set pre_id= 1000039,pre_nombre= 'Borrar Calibradora',pre_grupo= 'Calibradora',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000039
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000039,'Borrar Calibradora','Calibradora','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000040) begin
update Prestacion set pre_id= 1000040,pre_nombre= 'Listar Calibradora',pre_grupo= 'Calibradora',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000040
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000040,'Listar Calibradora','Calibradora','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000045) begin
update Prestacion set pre_id= 1000045,pre_nombre= 'Agregar Especie',pre_grupo= 'Especie',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000045
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000045,'Agregar Especie','Especie','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000046) begin
update Prestacion set pre_id= 1000046,pre_nombre= 'Editar Especie',pre_grupo= 'Especie',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000046
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000046,'Editar Especie','Especie','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000047) begin
update Prestacion set pre_id= 1000047,pre_nombre= 'Borrar Especie',pre_grupo= 'Especie',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000047
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000047,'Borrar Especie','Especie','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
GO
if exists(select * from Prestacion where pre_id = 1000048) begin
update Prestacion set pre_id= 1000048,pre_nombre= 'Listar Especie',pre_grupo= 'Especie',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000048
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000048,'Listar Especie','Especie','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000049) begin
update Prestacion set pre_id= 1000049,pre_nombre= 'Agregar Barco',pre_grupo= 'Barco',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000049
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000049,'Agregar Barco','Barco','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000050) begin
update Prestacion set pre_id= 1000050,pre_nombre= 'Editar Barco',pre_grupo= 'Barco',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000050
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000050,'Editar Barco','Barco','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000051) begin
update Prestacion set pre_id= 1000051,pre_nombre= 'Borrar Barco',pre_grupo= 'Barco',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000051
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000051,'Borrar Barco','Barco','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000052) begin
update Prestacion set pre_id= 1000052,pre_nombre= 'Listar Barco',pre_grupo= 'Barco',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000052
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000052,'Listar Barco','Barco','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000053) begin
update Prestacion set pre_id= 1000053,pre_nombre= 'Agregar Puerto',pre_grupo= 'Puerto',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000053
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000053,'Agregar Puerto','Puerto','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000054) begin
update Prestacion set pre_id= 1000054,pre_nombre= 'Editar Puerto',pre_grupo= 'Puerto',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000054
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000054,'Editar Puerto','Puerto','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000055) begin
update Prestacion set pre_id= 1000055,pre_nombre= 'Borrar Puerto',pre_grupo= 'Puerto',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000055
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000055,'Borrar Puerto','Puerto','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000056) begin
update Prestacion set pre_id= 1000056,pre_nombre= 'Listar Puerto',pre_grupo= 'Puerto',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20031127 13:49:58',modificado= '20031127 13:49:58',activo= 1 where pre_id = 1000056
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000056,'Listar Puerto','Puerto','','','','','','20031127 13:49:58','20031127 13:49:58',1)
end
if exists(select * from Prestacion where pre_id = 1000057) begin
update Prestacion set pre_id= 1000057,pre_nombre= 'Agregar Contra Marcas',pre_grupo= 'Empaque',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040430 16:13:28',modificado= '20040430 16:13:28',activo= 1 where pre_id = 1000057
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000057,'Agregar Contra Marcas','Empaque','','','','','','20040430 16:13:28','20040430 16:13:28',1)
end
GO
if exists(select * from Prestacion where pre_id = 1000058) begin
update Prestacion set pre_id= 1000058,pre_nombre= 'Editar Contra Marcas',pre_grupo= 'Empaque',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040430 16:13:28',modificado= '20040430 16:13:28',activo= 1 where pre_id = 1000058
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000058,'Editar Contra Marcas','Empaque','','','','','','20040430 16:13:28','20040430 16:13:28',1)
end
if exists(select * from Prestacion where pre_id = 1000059) begin
update Prestacion set pre_id= 1000059,pre_nombre= 'Borrar Contra Marcas',pre_grupo= 'Empaque',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040430 16:13:28',modificado= '20040430 16:13:28',activo= 1 where pre_id = 1000059
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000059,'Borrar Contra Marcas','Empaque','','','','','','20040430 16:13:28','20040430 16:13:28',1)
end
if exists(select * from Prestacion where pre_id = 1000060) begin
update Prestacion set pre_id= 1000060,pre_nombre= 'Listar Contra Marcas',pre_grupo= 'Empaque',pre_grupo1= '',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040430 16:13:28',modificado= '20040430 16:13:28',activo= 1 where pre_id = 1000060
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (1000060,'Listar Contra Marcas','Empaque','','','','','','20040430 16:13:28','20040430 16:13:28',1)
end
if exists(select * from Prestacion where pre_id = 10000041) begin
update Prestacion set pre_id= 10000041,pre_nombre= 'Cuenta Corriente de Clientes',pre_grupo= 'Informes',pre_grupo1= '',pre_grupo2= 'web_clientes',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040525 20:41:10',modificado= '20040525 20:41:10',activo= 1 where pre_id = 10000041
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (10000041,'Cuenta Corriente de Clientes','Informes','','web_clientes','','','','20040525 20:41:10','20040525 20:41:10',1)
end
if exists(select * from Prestacion where pre_id = 10000042) begin
update Prestacion set pre_id= 10000042,pre_nombre= 'Listado de Ordenes de Pago',pre_grupo= 'Informes',pre_grupo1= '',pre_grupo2= 'web_clientes',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040525 20:44:01',modificado= '20040525 20:44:01',activo= 1 where pre_id = 10000042
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (10000042,'Listado de Ordenes de Pago','Informes','','web_clientes','','','','20040525 20:44:01','20040525 20:44:01',1)
end
if exists(select * from Prestacion where pre_id = 10000043) begin
update Prestacion set pre_id= 10000043,pre_nombre= 'Listado de Cobranzas',pre_grupo= 'Informes',pre_grupo1= 'web_clientes',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040530 01:23:29',modificado= '20040530 01:23:29',activo= 1 where pre_id = 10000043
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (10000043,'Listado de Cobranzas','Informes','web_clientes','','','','','20040530 01:23:29','20040530 01:23:29',1)
end
if exists(select * from Prestacion where pre_id = 10000044) begin
update Prestacion set pre_id= 10000044,pre_nombre= 'Partes diarios agrupados por responsable y fecha',pre_grupo= 'Informes',pre_grupo1= 'web_contactos',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040530 01:23:58',modificado= '20040530 01:23:58',activo= 1 where pre_id = 10000044
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (10000044,'Partes diarios agrupados por responsable y fecha','Informes','web_contactos','','','','','20040530 01:23:58','20040530 01:23:58',1)
end
if exists(select * from Prestacion where pre_id = 10000045) begin
update Prestacion set pre_id= 10000045,pre_nombre= 'Pedidos de ventas agrupado por Cliente y Doc.',pre_grupo= 'Informes',pre_grupo1= 'web_clientes',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040530 01:24:13',modificado= '20040530 01:24:13',activo= 1 where pre_id = 10000045
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (10000045,'Pedidos de ventas agrupado por Cliente y Doc.','Informes','web_clientes','','','','','20040530 01:24:13','20040530 01:24:13',1)
end
if exists(select * from Prestacion where pre_id = 10000046) begin
update Prestacion set pre_id= 10000046,pre_nombre= 'Pedidos de venta',pre_grupo= 'Informes',pre_grupo1= 'web_clientes',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040530 01:24:31',modificado= '20040530 01:24:31',activo= 1 where pre_id = 10000046
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (10000046,'Pedidos de venta','Informes','web_clientes','','','','','20040530 01:24:31','20040530 01:24:31',1)
end
if exists(select * from Prestacion where pre_id = 10000047) begin
update Prestacion set pre_id= 10000047,pre_nombre= 'Pedidos de ventas agrupado por estado y cliente',pre_grupo= 'Informes',pre_grupo1= 'web_clientes',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040530 01:24:52',modificado= '20040530 01:24:52',activo= 1 where pre_id = 10000047
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (10000047,'Pedidos de ventas agrupado por estado y cliente','Informes','web_clientes','','','','','20040530 01:24:52','20040530 01:24:52',1)
end
GO
if exists(select * from Prestacion where pre_id = 10000048) begin
update Prestacion set pre_id= 10000048,pre_nombre= 'Pedidos de ventas agrupado por cliente, sucursal y ctro de costo',pre_grupo= 'Informes',pre_grupo1= 'web_clientes',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040530 01:25:16',modificado= '20040530 01:25:16',activo= 1 where pre_id = 10000048
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (10000048,'Pedidos de ventas agrupado por cliente, sucursal y ctro de costo','Informes','web_clientes','','','','','20040530 01:25:16','20040530 01:25:16',1)
end
if exists(select * from Prestacion where pre_id = 10000049) begin
update Prestacion set pre_id= 10000049,pre_nombre= 'Detalle de Horas',pre_grupo= 'Informes',pre_grupo1= 'web_contactos',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040530 01:26:05',modificado= '20040530 01:26:05',activo= 1 where pre_id = 10000049
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (10000049,'Detalle de Horas','Informes','web_contactos','','','','','20040530 01:26:05','20040530 01:26:05',1)
end
if exists(select * from Prestacion where pre_id = 10000050) begin
update Prestacion set pre_id= 10000050,pre_nombre= 'Aplicación de Documentos de Venta',pre_grupo= 'Informes',pre_grupo1= 'Ventas',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040609 17:29:23',modificado= '20040609 17:29:23',activo= 1 where pre_id = 10000050
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (10000050,'Aplicación de Documentos de Venta','Informes','Ventas','','','','','20040609 17:29:23','20040609 17:29:23',1)
end
if exists(select * from Prestacion where pre_id = 10000051) begin
update Prestacion set pre_id= 10000051,pre_nombre= 'Libro I.V.A. Ventas',pre_grupo= 'Informes',pre_grupo1= 'Contabilidad',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040609 20:13:19',modificado= '20040609 20:13:19',activo= 1 where pre_id = 10000051
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (10000051,'Libro I.V.A. Ventas','Informes','Contabilidad','','','','','20040609 20:13:19','20040609 20:13:19',1)
end
if exists(select * from Prestacion where pre_id = 10000052) begin
update Prestacion set pre_id= 10000052,pre_nombre= 'Libro I.V.A. Compras',pre_grupo= 'Informes',pre_grupo1= 'Contabilidad',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040609 20:14:29',modificado= '20040609 20:14:29',activo= 1 where pre_id = 10000052
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (10000052,'Libro I.V.A. Compras','Informes','Contabilidad','','','','','20040609 20:14:29','20040609 20:14:29',1)
end
if exists(select * from Prestacion where pre_id = 10000053) begin
update Prestacion set pre_id= 10000053,pre_nombre= 'Aplicación de Documentos de Compra',pre_grupo= 'Informes',pre_grupo1= 'Compras',pre_grupo2= '',pre_grupo3= '',pre_grupo4= '',pre_grupo5= '',creado= '20040610 13:36:08',modificado= '20040610 13:36:08',activo= 1 where pre_id = 10000053
end else begin 
INSERT INTO Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,pre_grupo2,pre_grupo3,pre_grupo4,pre_grupo5,creado,modificado,activo)VALUES (10000053,'Aplicación de Documentos de Compra','Informes','Compras','','','','','20040610 13:36:08','20040610 13:36:08',1)
end

