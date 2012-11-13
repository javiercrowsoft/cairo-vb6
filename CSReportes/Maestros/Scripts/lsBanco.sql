/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsBanco         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
bco_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_banco      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Banco Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
13      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

												select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Banco%'

Para testear:

lsBanco 'N508'

select * from rama where ram_nombre like '%banco%'
select * from banco
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsBanco]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsBanco]

go
create procedure lsBanco (

@@bco_id			varchar(255)

)as 

declare @bco_id int
declare @ram_id_banco int

declare @clienteID 	int
declare @IsRaiz 		tinyint

exec sp_ArbConvertId @@bco_id, @bco_id out, @ram_id_banco out

if @ram_id_banco <> 0 begin

	exec sp_ArbIsRaiz @ram_id_banco, @IsRaiz out

  if @IsRaiz = 0 begin

		exec sp_GetRptId @clienteID out
		exec sp_ArbGetAllHojas @ram_id_banco, @clienteID

	end else begin

		set @ram_id_banco = 0
  	set @clienteID = 0
	end

end else begin

	set @clienteID = 0

end

select 

  *

from 

  
Banco

where 
      (Banco.bco_id = @bco_id or @bco_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 13 -- tbl_id de Banco
                  and  rptarb_hojaid = Banco.bco_id
							   ) 
           )
        or 
					 (@ram_id_banco = 0)
			 )