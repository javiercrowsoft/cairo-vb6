/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsCobrador         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
cob_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_cobrador      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Cobrador Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
25      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

                        select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Cobrador%'

Para testear:

lsCobrador 'N534'
select * from cobrador
select * from rama where ram_nombre like '%cobrador%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsCobrador]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsCobrador]

go
create procedure lsCobrador (

@@cob_id      varchar(255)

)as 

declare @cob_id int
declare @ram_id_cobrador int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@cob_id, @cob_id out, @ram_id_cobrador out

if @ram_id_cobrador <> 0 begin

  exec sp_ArbIsRaiz @ram_id_cobrador, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_cobrador, @clienteID

  end else begin

    set @ram_id_cobrador = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select 
  
  cobrador.*,
  reglaliquidacion.rel_nombre  
  
from 

  Cobrador inner join ReglaLiquidacion on cobrador.rel_id = reglaliquidacion.rel_id

where 
      (Cobrador.cob_id = @cob_id or @cob_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 25 -- tbl_id de Cobrador
                  and  rptarb_hojaid = Cobrador.cob_id
                 ) 
           )
        or 
           (@ram_id_cobrador = 0)
       )