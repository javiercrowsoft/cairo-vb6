/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsEspecie         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
esp_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_especie      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Especie Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
12003      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

												select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Especie%'

Para testear:

lsEspecie 'N596'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsEspecie]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsEspecie]

go
create procedure lsEspecie (

@@esp_id			varchar(255)

)as 

declare @esp_id int
declare @ram_id_especie int

declare @clienteID 	int
declare @IsRaiz 		tinyint

exec sp_ArbConvertId @@esp_id, @esp_id out, @ram_id_especie out

if @ram_id_especie <> 0 begin

	exec sp_ArbIsRaiz @ram_id_especie, @IsRaiz out

  if @IsRaiz = 0 begin

		exec sp_GetRptId @clienteID out
		exec sp_ArbGetAllHojas @ram_id_especie, @clienteID

	end else begin

		set @ram_id_especie = 0
  	set @clienteID = 0
	end

end else begin

	set @clienteID = 0

end

select *

-- Listado de columnas que corresponda	

from 

-- Listado de tablas que corresponda	
  Especie

where 
      (Especie.esp_id = @esp_id or @esp_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 12003 -- tbl_id de Especie
                  and  rptarb_hojaid = Especie.esp_id
							   ) 
           )
        or 
					 (@ram_id_especie = 0)
			 )