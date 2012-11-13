/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsUsuario         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
us_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_usuario      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Usuario Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
3      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

												select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Usuario%'

Para testear:

lsUsuario 'N622'

select * from rama where ram_nombre like '%usuario%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsUsuario]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsUsuario]

go
create procedure lsUsuario (

@@us_id			varchar(255)

)as 

declare @us_id int
declare @ram_id_usuario int

declare @clienteID 	int
declare @IsRaiz 		tinyint

exec sp_ArbConvertId @@us_id, @us_id out, @ram_id_usuario out

if @ram_id_usuario <> 0 begin

	exec sp_ArbIsRaiz @ram_id_usuario, @IsRaiz out

  if @IsRaiz = 0 begin

		exec sp_GetRptId @clienteID out
		exec sp_ArbGetAllHojas @ram_id_usuario, @clienteID

	end else begin

		set @ram_id_usuario = 0
  	set @clienteID = 0
	end

end else begin

	set @clienteID = 0

end

select *,
  case activo
  when 0 then 'No'
  else 'Si'
  end
  as [En uso]

-- Listado de columnas que corresponda	

from 

-- Listado de tablas que corresponda	
  Usuario

where 
      (Usuario.us_id = @us_id or @us_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 3 -- tbl_id de Usuario
                  and  rptarb_hojaid = Usuario.us_id
							   ) 
           )
        or 
					 (@ram_id_usuario = 0)
			 )