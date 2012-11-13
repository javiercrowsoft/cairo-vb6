/*

Lo primero es guardar como NO SEAN GILI....
select * from permiso
Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsPermiso         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
per_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_permiso      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Permiso Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
4      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

												select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Permiso%'

Para testear:

lsPermiso 'N476'

select * from rama where ram_nombre like '%permiso%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsPermiso]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsPermiso]

go
create procedure lsPermiso (

@@per_id			varchar(255)

)as 

declare @per_id int
declare @ram_id_permiso int

declare @clienteID 	int
declare @IsRaiz 		tinyint

exec sp_ArbConvertId @@per_id, @per_id out, @ram_id_permiso out

if @ram_id_permiso <> 0 begin

	exec sp_ArbIsRaiz @ram_id_permiso, @IsRaiz out

  if @IsRaiz = 0 begin

		exec sp_GetRptId @clienteID out
		exec sp_ArbGetAllHojas @ram_id_permiso, @clienteID

	end else begin

		set @ram_id_permiso = 0
  	set @clienteID = 0
	end

end else begin

	set @clienteID = 0

end

select permiso.*,
       prestacion.pre_nombre,
       usuario.us_nombre,
       rol.rol_nombre

-- Listado de columnas que corresponda	

from 

  Permiso left join prestacion on permiso.pre_id = prestacion.pre_id
          left join usuario    on permiso.us_id  = usuario.us_id
          left join rol        on permiso.rol_id = rol.rol_id

where 
      (Permiso.per_id = @per_id or @per_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4 -- tbl_id de Permiso
                  and  rptarb_hojaid = Permiso.per_id
							   ) 
           )
        or 
					 (@ram_id_permiso = 0)
			 )