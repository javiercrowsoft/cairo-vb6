/*
select * from vendedor
Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsVendedor         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
ven_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_vendedor      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Vendedor Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
15      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

												select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Vendedor%'

Para testear:

lsVendedor 'N510'

select * from rama where ram_nombre like '%vendedor%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsVendedor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsVendedor]

go
create procedure lsVendedor (

@@ven_id			varchar(255)

)as 

declare @ven_id int
declare @ram_id_vendedor int

declare @clienteID 	int
declare @IsRaiz 		tinyint

exec sp_ArbConvertId @@ven_id, @ven_id out, @ram_id_vendedor out

if @ram_id_vendedor <> 0 begin

	exec sp_ArbIsRaiz @ram_id_vendedor, @IsRaiz out

  if @IsRaiz = 0 begin

		exec sp_GetRptId @clienteID out
		exec sp_ArbGetAllHojas @ram_id_vendedor, @clienteID

	end else begin

		set @ram_id_vendedor = 0
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
  as EnActividad

-- Listado de columnas que corresponda	

from 

-- Listado de tablas que corresponda	
  Vendedor

where 
      (Vendedor.ven_id = @ven_id or @ven_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 15 -- tbl_id de Vendedor
                  and  rptarb_hojaid = Vendedor.ven_id
							   ) 
           )
        or 
					 (@ram_id_vendedor = 0)
			 )