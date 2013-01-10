/*
select * from provincia
Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsProvincia         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
pro_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_provincia      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Provincia Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
6      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

                        select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Provincia%'

Para testear:

lsProvincia 'N484'

select * from rama where ram_nombre like '%provincia%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsProvincia]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsProvincia]

go
create procedure lsProvincia (

@@pro_id      varchar(255)

)as 

declare @pro_id int
declare @ram_id_provincia int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@pro_id, @pro_id out, @ram_id_provincia out

if @ram_id_provincia <> 0 begin

  exec sp_ArbIsRaiz @ram_id_provincia, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_provincia, @clienteID

  end else begin

    set @ram_id_provincia = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select *

-- Listado de columnas que corresponda  

from 

-- Listado de tablas que corresponda  
Provincia

where 
      (Provincia.pro_id = @pro_id or @pro_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 6 -- tbl_id de Provincia
                  and  rptarb_hojaid = Provincia.pro_id
                 ) 
           )
        or 
           (@ram_id_provincia = 0)
       )