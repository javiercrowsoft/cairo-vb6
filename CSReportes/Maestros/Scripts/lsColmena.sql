/*

Lo primero es guardar como NO SEAN GILI....

select * from colmena
Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsColmena         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
colm_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_colmena      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Colmena Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
11003      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

                        select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Colmena%'

Para testear:

lsColmena 'N693'

select * from rama where ram_nombre like '%colmena%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsColmena]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsColmena]

go
create procedure lsColmena (

@@colm_id      varchar(255)

)as 

declare @colm_id int
declare @ram_id_colmena int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@colm_id, @colm_id out, @ram_id_colmena out

if @ram_id_colmena <> 0 begin

  exec sp_ArbIsRaiz @ram_id_colmena, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_colmena, @clienteID

  end else begin

    set @ram_id_colmena = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select *

-- Listado de columnas que corresponda  

from 

-- Listado de tablas que corresponda  
  Colmena

where 
      (Colmena.colm_id = @colm_id or @colm_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11003 -- tbl_id de Colmena
                  and  rptarb_hojaid = Colmena.colm_id
                 ) 
           )
        or 
           (@ram_id_colmena = 0)
       )