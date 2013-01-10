/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
NOMBRE_SP         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
TABLA_ID          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
RAM_ID_TABLA      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
TABLA_DEL_LISTADO Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
TBL_ID_TABLA      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

                        select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%TABLA_DEL_LISTADO%'

Para testear:

NOMBRE_SP 'N596'

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[NOMBRE_SP]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[NOMBRE_SP]

go
create procedure NOMBRE_SP (

@@TABLA_ID      varchar(255)

)as 

declare @TABLA_ID int
declare @RAM_ID_TABLA int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@TABLA_ID, @TABLA_ID out, @RAM_ID_TABLA out

if @RAM_ID_TABLA <> 0 begin

  exec sp_ArbIsRaiz @RAM_ID_TABLA, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @RAM_ID_TABLA, @clienteID

  end else begin

    set @RAM_ID_TABLA = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select 

-- Listado de columnas que corresponda  

from 

-- Listado de tablas que corresponda  
TABLA_DEL_LISTADO

where 
      (TABLA_DEL_LISTADO.TABLA_ID = @TABLA_ID or @TABLA_ID=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA -- tbl_id de TABLA_DEL_LISTADO
                  and  rptarb_hojaid = TABLA_DEL_LISTADO.TABLA_ID
                 ) 
           )
        or 
           (@RAM_ID_TABLA = 0)
       )