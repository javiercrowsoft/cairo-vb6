/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsContacto         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
cont_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_contacto      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Contacto Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
2001      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

                        select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Contacto%'

Para testear:

lsContacto 'N596'



*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsContacto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsContacto]

go
create procedure lsContacto (

@@cont_id      varchar(255)

)as 

declare @cont_id int
declare @ram_id_contacto int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@cont_id, @cont_id out, @ram_id_contacto out

if @ram_id_contacto <> 0 begin

  exec sp_ArbIsRaiz @ram_id_contacto, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_contacto, @clienteID

  end else begin

    set @ram_id_contacto = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select contacto.* ,
       cli_nombre,
       prov_nombre
from 
      Contacto left join cliente   on contacto.cli_id = cliente.cli_id
               left join proveedor on contacto.prov_id = proveedor.prov_id

where 
      (Contacto.cont_id = @cont_id or @cont_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 2001 -- tbl_id de Contacto
                  and  rptarb_hojaid = Contacto.cont_id
                 ) 
           )
        or 
           (@ram_id_contacto = 0)
       )