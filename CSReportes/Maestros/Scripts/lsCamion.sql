/*
select * from camion
Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsCamion         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
cam_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_camion      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Camion Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
1004      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

                        select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Camion%'

Para testear:

lsCamion 'N683'

select * from rama where ram_nombre like '%camion%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsCamion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsCamion]

go
create procedure lsCamion (

@@cam_id      varchar(255)

)as 

declare @cam_id int
declare @ram_id_camion int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@cam_id, @cam_id out, @ram_id_camion out

if @ram_id_camion <> 0 begin

  exec sp_ArbIsRaiz @ram_id_camion, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_camion, @clienteID

  end else begin

    set @ram_id_camion = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select *

-- Listado de columnas que corresponda  

from 

-- Listado de tablas que corresponda  
Camion

where 
      (Camion.cam_id = @cam_id or @cam_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1004 -- tbl_id de Camion
                  and  rptarb_hojaid = Camion.cam_id
                 ) 
           )
        or 
           (@ram_id_camion = 0)
       )