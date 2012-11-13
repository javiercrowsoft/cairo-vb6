/*
select * from centrocosto
Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsCentroCosto         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
ccos_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_centrocosto      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
CentroCosto Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
21      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

												select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%CentroCosto%'

Para testear:

lsCentroCosto 'N532'
select * from rama where ram_nombre like '%centro%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsCentroCosto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsCentroCosto]

go
create procedure lsCentroCosto (

@@ccos_id			varchar(255)

)as 

declare @ccos_id int
declare @ram_id_centrocosto int

declare @clienteID 	int
declare @IsRaiz 		tinyint

exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_centrocosto out

if @ram_id_centrocosto <> 0 begin

	exec sp_ArbIsRaiz @ram_id_centrocosto, @IsRaiz out

  if @IsRaiz = 0 begin

		exec sp_GetRptId @clienteID out
		exec sp_ArbGetAllHojas @ram_id_centrocosto, @clienteID

	end else begin

		set @ram_id_centrocosto = 0
  	set @clienteID = 0
	end

end else begin

	set @clienteID = 0

end

select *,
  case ccos_compra
  when 0 then 'no'
    else 'si'
  end 
  as Compra,
  case ccos_venta
  when 0 then 'no'
    else 'si'
  end 
  as venta

-- Listado de columnas que corresponda	

from 

-- Listado de tablas que corresponda	
  CentroCosto

where 
      (CentroCosto.ccos_id = @ccos_id or @ccos_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 21 -- tbl_id de CentroCosto
                  and  rptarb_hojaid = CentroCosto.ccos_id
							   ) 
           )
        or 
					 (@ram_id_centrocosto = 0)
			 )