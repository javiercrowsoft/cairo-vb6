/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsChofer         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
chof_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_Chofer      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Chofer Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
1001      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

                        select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Chofer%'

Para testear:

lsChofer 'N684'

select * from rama where ram_nombre like '%chofer%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsChofer]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsChofer]

go
create procedure lsChofer (

@@chof_id      varchar(255)

)as 

declare @chof_id int
declare @ram_id_Chofer int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@chof_id, @chof_id out, @ram_id_Chofer out

if @ram_id_Chofer <> 0 begin

  exec sp_ArbIsRaiz @ram_id_Chofer, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_Chofer, @clienteID

  end else begin

    set @ram_id_Chofer = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select 

  *,
  case chof_tipodni
    when 1 then 'DNI'
    when 2 then 'CI'
    when 3 then 'Pasaporte'  
    when 4 then 'LE'
    when 5 then 'LC'
    when 6 then 'Otros'
  else 'Sin definir'
  end
  as TipoDoc    

-- Listado de columnas que corresponda  

from 

-- Listado de tablas que corresponda  
Chofer

where 
      (Chofer.chof_id = @chof_id or @chof_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1001 -- tbl_id de Chofer
                  and  rptarb_hojaid = Chofer.chof_id
                 ) 
           )
        or 
           (@ram_id_Chofer = 0)
       )