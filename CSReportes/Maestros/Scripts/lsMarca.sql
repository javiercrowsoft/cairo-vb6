/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsMarca         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
marc_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_marca      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Marca Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
1002      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

                        select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Marca%'

Para testear:

lsMarca 'N596'

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsMarca]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsMarca]

go
create procedure lsMarca (

@@marc_id      varchar(255)

)as 

declare @marc_id int
declare @ram_id_marca int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@marc_id, @marc_id out, @ram_id_marca out

if @ram_id_marca <> 0 begin

  exec sp_ArbIsRaiz @ram_id_marca, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_marca, @clienteID

  end else begin

    set @ram_id_marca = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select *

-- Listado de columnas que corresponda  

from 

-- Listado de tablas que corresponda  
  Marca

where 
      (Marca.marc_id = @marc_id or @marc_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1002 -- tbl_id de Marca
                  and  rptarb_hojaid = Marca.marc_id
                 ) 
           )
        or 
           (@ram_id_marca = 0)
       )