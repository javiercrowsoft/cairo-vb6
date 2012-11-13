/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsChequera         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
chq_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_chequera      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Chequera Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
22      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

												select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Chequera%'

Para testear:

lsChequera 'N671'

select * from rama where ram_nombre like '%chequera%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsChequera]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsChequera]

go
create procedure lsChequera (

@@chq_id			varchar(255)

)as 

declare @chq_id int
declare @ram_id_chequera int

declare @clienteID 	int
declare @IsRaiz 		tinyint

exec sp_ArbConvertId @@chq_id, @chq_id out, @ram_id_chequera out

if @ram_id_chequera <> 0 begin

	exec sp_ArbIsRaiz @ram_id_chequera, @IsRaiz out

  if @IsRaiz = 0 begin

		exec sp_GetRptId @clienteID out
		exec sp_ArbGetAllHojas @ram_id_chequera, @clienteID

	end else begin

		set @ram_id_chequera = 0
  	set @clienteID = 0
	end

end else begin

	set @clienteID = 0

end

select chequera.*,
       cue_nombre

-- Listado de columnas que corresponda	

from 

-- Listado de tablas que corresponda	
  Chequera left join cuenta on chequera.cue_id = cuenta.cue_id

where 
      (Chequera.chq_id = @chq_id or @chq_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 22 -- tbl_id de Chequera
                  and  rptarb_hojaid = Chequera.chq_id
							   ) 
           )
        or 
					 (@ram_id_chequera = 0)
			 )