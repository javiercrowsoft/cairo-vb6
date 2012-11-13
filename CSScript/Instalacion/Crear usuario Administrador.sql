select 'update ' + s.name + ' set ' + c.name + ' = 1 where modifico = 7'  
from sysobjects s inner join syscolumns c on s.id = c.id and s.type = 'U' and c.name = 'modifico'

/*
	select * from usuario

if exists(select * from Usuario where us_id = 1) begin
update Usuario set us_id= 1,us_nombre= 'Administrador',us_clave= '',us_descrip= '',us_externo= 0,us_email= '',modificado= '20040618 16:41:58',creado= '20040618 13:47:18',activo= 1,modifico= 1 where us_id = 1
end else begin 
INSERT INTO Usuario (us_id,us_nombre,us_clave,us_descrip,us_externo,us_email,modificado,creado,activo,modifico)VALUES (1,'Administrador','','',0,'','20040618 16:41:58','20040618 13:47:18',1,1)
end

if exists(select * from Rol where rol_id = 1) begin
update Rol set rol_id= 1,rol_nombre= 'Administrador',modificado= '20040618 13:39:23',creado= '20040618 13:39:23',modifico= 1,activo= 1 where rol_id = 1
end else begin 
INSERT INTO Rol (rol_id,rol_nombre,modificado,creado,modifico,activo)VALUES (1,'Administrador','20040618 13:39:23','20040618 13:39:23',1,1)
end



 	update partediario set us_id_responsable = 1 where us_id_responsable = 7
	update partediario set us_id_asignador = 1 where us_id_asignador = 7
	update movimientofondo set us_id = 1 where us_id = 7
  update webArticulo set us_id = 1 where us_id = 7
	update reporte set us_id = 1 where us_id = 7
	update documentofirma set us_id = 1 where us_id = 7

	delete usuario where us_id = 7

	update usuario set us_nombre = 'Administrador' where us_id = 1

	update rol set rol_nombre = 'Administrador' where rol_id = 1
*/

