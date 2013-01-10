/*

Lo primero es guardar como NO SEAN GILI....
select * from ciudad
Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsCiudad         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
ciu_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_ciudad      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Ciudad Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
40      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

                        select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Ciudad%'

Para testear:

lsCiudad 'N631'

select * from rama where ram_nombre like '%ciudad%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsCiudad]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsCiudad]

go
create procedure lsCiudad (

@@ciu_id      varchar(255)

)as 

declare @ciu_id int
declare @ram_id_ciudad int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@ciu_id, @ciu_id out, @ram_id_ciudad out

if @ram_id_ciudad <> 0 begin

  exec sp_ArbIsRaiz @ram_id_ciudad, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_ciudad, @clienteID

  end else begin

    set @ram_id_ciudad = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select *

-- Listado de columnas que corresponda  

from 

-- Listado de tablas que corresponda  
  Ciudad

where 
      (Ciudad.ciu_id = @ciu_id or @ciu_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 40 -- tbl_id de Ciudad
                  and  rptarb_hojaid = Ciudad.ciu_id
                 ) 
           )
        or 
           (@ram_id_ciudad = 0)
       )