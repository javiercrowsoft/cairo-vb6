/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsMaquina         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
maq_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
maq_id_maquina      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Maquina Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
13001      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

												select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Maquina%'

Para testear:

select * from rama where ram_nombre like '%maquina%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsMaquina]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsMaquina]

go
create procedure lsMaquina (

@@maq_id			varchar(255)

)as 

declare @maq_id int
declare @maq_id_maquina int

declare @clienteID 	int
declare @IsRaiz 		tinyint

exec sp_ArbConvertId @@maq_id, @maq_id out, @maq_id_maquina out

if @maq_id_maquina <> 0 begin

	exec sp_ArbIsRaiz @maq_id_maquina, @IsRaiz out

  if @IsRaiz = 0 begin

		exec sp_GetRptId @clienteID out
		exec sp_ArbGetAllHojas @maq_id_maquina, @clienteID

	end else begin

		set @maq_id_maquina = 0
  	set @clienteID = 0
	end

end else begin

	set @clienteID = 0

end

select *

-- Listado de columnas que corresponda	

from 

-- Listado de tablas que corresponda	
  Maquina

where 
      (Maquina.maq_id = @maq_id or @maq_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 13001 -- tbl_id de Maquina
                  and  rptarb_hojaid = Maquina.maq_id
							   ) 
           )
        or 
					 (@maq_id_maquina = 0)
			 )