/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsCuenta         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
cue_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_cuenta      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Cuenta Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
17      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

                        select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Cuenta%'

Para testear:

lsCuenta 'N520'

select * from rama where ram_nombre like '%cuenta%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsCuenta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsCuenta]

go
create procedure lsCuenta (

@@cue_id      varchar(255)

)as 

declare @cue_id int
declare @ram_id_cuenta int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@cue_id, @cue_id out, @ram_id_cuenta out

if @ram_id_cuenta <> 0 begin

  exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID

  end else begin

    set @ram_id_cuenta = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select *,
  case cue_llevacentrocosto
  when 0 then 'No' 
  else 'Si'
  end
  as tienectrocost
-- Listado de columnas que corresponda  

from 

-- Listado de tablas que corresponda  
  Cuenta

where 
      (Cuenta.cue_id = @cue_id or @cue_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 -- tbl_id de Cuenta
                  and  rptarb_hojaid = Cuenta.cue_id
                 ) 
           )
        or 
           (@ram_id_cuenta = 0)
       )