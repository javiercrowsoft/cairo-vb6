/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsZona         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
zon_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_zona      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Zona Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
8      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

												select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Zona%'

Para testear:

lsZona 'N495'

select * from rama where ram_nombre like '%zona%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsZona]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsZona]

go
create procedure lsZona (

@@zon_id			varchar(255)

)as 

declare @zon_id int
declare @ram_id_zona int

declare @clienteID 	int
declare @IsRaiz 		tinyint

exec sp_ArbConvertId @@zon_id, @zon_id out, @ram_id_zona out

if @ram_id_zona <> 0 begin

	exec sp_ArbIsRaiz @ram_id_zona, @IsRaiz out

  if @IsRaiz = 0 begin

		exec sp_GetRptId @clienteID out
		exec sp_ArbGetAllHojas @ram_id_zona, @clienteID

	end else begin

		set @ram_id_zona = 0
  	set @clienteID = 0
	end

end else begin

	set @clienteID = 0

end

select 

*
-- Listado de columnas que corresponda	

from 

-- Listado de tablas que corresponda	
Zona

where 
      (Zona.zon_id = @zon_id or @zon_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 8 -- tbl_id de Zona
                  and  rptarb_hojaid = Zona.zon_id
							   ) 
           )
        or 
					 (@ram_id_zona = 0)
			 )