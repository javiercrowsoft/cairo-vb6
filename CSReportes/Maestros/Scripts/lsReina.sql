/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsReina         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
reina_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_reina      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Reina Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
11002      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

                        select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Reina%'

Para testear:

lsReina 'N596'

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsReina]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsReina]

go
create procedure lsReina (

@@reina_id      varchar(255)

)as 

declare @reina_id int
declare @ram_id_reina int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@reina_id, @reina_id out, @ram_id_reina out

if @ram_id_reina <> 0 begin

  exec sp_ArbIsRaiz @ram_id_reina, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_reina, @clienteID

  end else begin

    set @ram_id_reina = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select reina.*,
       proveedor.prov_nombre,
       colmena.colm_codigo,

      case reina_calidad
      when 1 then 'Buena' 
      when 2 then 'Regular'
      when 3 then 'Mala' 
      else 'Sin definir'
      end
      as calidaReina

-- Listado de columnas que corresponda  

from 
      reina left join proveedor on reina.prov_id = proveedor.prov_id
            left join colmena   on reina.colm_id = colmena.colm_id
-- Listado de tablas que corresponda  


where 
      (Reina.reina_id = @reina_id or @reina_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11002 -- tbl_id de Reina
                  and  rptarb_hojaid = Reina.reina_id
                 ) 
           )
        or 
           (@ram_id_reina = 0)
       )