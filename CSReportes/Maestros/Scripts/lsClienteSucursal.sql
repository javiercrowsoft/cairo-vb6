/*
select * from clientesucursal
Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsClienteSucursal         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
clis_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_clientesucursal      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
ClienteSucursal Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
14      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

												select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%ClienteSucursal%'

Para testear:

lsClienteSucursal 'N596'

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsClienteSucursal]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsClienteSucursal]

go
create procedure lsClienteSucursal (

@@clis_id			varchar(255)

)as 

declare @clis_id int
declare @ram_id_clientesucursal int

declare @clienteID 	int
declare @IsRaiz 		tinyint

exec sp_ArbConvertId @@clis_id, @clis_id out, @ram_id_clientesucursal out

if @ram_id_clientesucursal <> 0 begin

	exec sp_ArbIsRaiz @ram_id_clientesucursal, @IsRaiz out

  if @IsRaiz = 0 begin

		exec sp_GetRptId @clienteID out
		exec sp_ArbGetAllHojas @ram_id_clientesucursal, @clienteID

	end else begin

		set @ram_id_clientesucursal = 0
  	set @clienteID = 0
	end

end else begin

	set @clienteID = 0

end
select * from clientesucursal
alter table clientesucursal drop column activo 
select *

-- Listado de columnas que corresponda	

from 

-- Listado de tablas que corresponda	
ClienteSucursal

where 
      (ClienteSucursal.clis_id = @clis_id or @clis_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 14 -- tbl_id de ClienteSucursal
                  and  rptarb_hojaid = ClienteSucursal.clis_id
							   ) 
           )
        or 
					 (@ram_id_clientesucursal = 0)
			 )