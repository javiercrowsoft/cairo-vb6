/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsPais         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
pa_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_pais      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Pais Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
39      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

                        select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Pais%'

Para testear:


select * from rama where ram_nombre like '%pais%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsPais]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsPais]

go
create procedure lsPais (

@@pa_id      varchar(255)

)as 

declare @pa_id int
declare @ram_id_pais int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@pa_id, @pa_id out, @ram_id_pais out

if @ram_id_pais <> 0 begin

  exec sp_ArbIsRaiz @ram_id_pais, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_pais, @clienteID

  end else begin

    set @ram_id_pais = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select *

-- Listado de columnas que corresponda  

from 

-- Listado de tablas que corresponda  
  Pais

where 
      (Pais.pa_id = @pa_id or @pa_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 39 -- tbl_id de Pais
                  and  rptarb_hojaid = Pais.pa_id
                 ) 
           )
        or 
           (@ram_id_pais = 0)
       )