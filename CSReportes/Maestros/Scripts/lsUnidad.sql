/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsUnidad         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
un_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_unidad      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Unidad Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
7      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

												select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Unidad%'

Para testear:

lsUnidad 'N494'

select * from rama where ram_nombre like '%unidad%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsUnidad]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsUnidad]

go
create procedure lsUnidad (

@@un_id			varchar(255)

)as 

declare @un_id int
declare @ram_id_unidad int

declare @clienteID 	int
declare @IsRaiz 		tinyint

exec sp_ArbConvertId @@un_id, @un_id out, @ram_id_unidad out

if @ram_id_unidad <> 0 begin

	exec sp_ArbIsRaiz @ram_id_unidad, @IsRaiz out

  if @IsRaiz = 0 begin

		exec sp_GetRptId @clienteID out
		exec sp_ArbGetAllHojas @ram_id_unidad, @clienteID

	end else begin

		set @ram_id_unidad = 0
  	set @clienteID = 0
	end

end else begin

	set @clienteID = 0

end

select * ,
  case activo
  when 0 then 'No'
  else 'Si'
  end
  as Activos

-- Listado de columnas que corresponda	

from 

-- Listado de tablas que corresponda	
  Unidad

where 
      (Unidad.un_id = @un_id or @un_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 7 -- tbl_id de Unidad
                  and  rptarb_hojaid = Unidad.un_id
							   ) 
           )
        or 
					 (@ram_id_unidad = 0)
			 )