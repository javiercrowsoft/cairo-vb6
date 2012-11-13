/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

select * from moneda
1)
lsMoneda         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
mon_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_moneda      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Moneda Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
12      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

												select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Moneda%'

Para testear:

lsMoneda 'N511'

select * from rama where ram_nombre like '%moneda%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsMoneda]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsMoneda]

go
create procedure lsMoneda (

@@mon_id			varchar(255)

)as 

declare @mon_id int
declare @ram_id_moneda int

declare @clienteID 	int
declare @IsRaiz 		tinyint

exec sp_ArbConvertId @@mon_id, @mon_id out, @ram_id_moneda out

if @ram_id_moneda <> 0 begin

	exec sp_ArbIsRaiz @ram_id_moneda, @IsRaiz out

  if @IsRaiz = 0 begin

		exec sp_GetRptId @clienteID out
		exec sp_ArbGetAllHojas @ram_id_moneda, @clienteID

	end else begin

		set @ram_id_moneda = 0
  	set @clienteID = 0
	end

end else begin

	set @clienteID = 0

end

select 

	*

from 

-- Listado de tablas que corresponda	
	Moneda

where 
      (Moneda.mon_id = @mon_id or @mon_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 12 -- tbl_id de Moneda
                  and  rptarb_hojaid = Moneda.mon_id
							   ) 
           )
        or 
					 (@ram_id_moneda = 0)
			 )