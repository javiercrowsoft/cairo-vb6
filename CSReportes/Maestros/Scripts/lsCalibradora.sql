/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsCalibradora         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
calib_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_calibradora      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Calibradora Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
12002      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

												select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Calibradora%'

Para testear:

lsCalibradora 'N596'

select * from rama where ram_nombre like '%calibradora%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsCalibradora]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsCalibradora]

go
create procedure lsCalibradora (

@@calib_id			varchar(255)

)as 

declare @calib_id int
declare @ram_id_calibradora int

declare @clienteID 	int
declare @IsRaiz 		tinyint

exec sp_ArbConvertId @@calib_id, @calib_id out, @ram_id_calibradora out

if @ram_id_calibradora <> 0 begin

	exec sp_ArbIsRaiz @ram_id_calibradora, @IsRaiz out

  if @IsRaiz = 0 begin

		exec sp_GetRptId @clienteID out
		exec sp_ArbGetAllHojas @ram_id_calibradora, @clienteID

	end else begin

		set @ram_id_calibradora = 0
  	set @clienteID = 0
	end

end else begin

	set @clienteID = 0

end

select *

-- Listado de columnas que corresponda	

from 

-- Listado de tablas que corresponda	
  Calibradora

where 
      (Calibradora.calib_id = @calib_id or @calib_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 12002 -- tbl_id de Calibradora
                  and  rptarb_hojaid = Calibradora.calib_id
							   ) 
           )
        or 
					 (@ram_id_calibradora = 0)
			 )