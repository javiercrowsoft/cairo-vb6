/*

Lo primero es guardar como NO SEAN GILI....
select * from barco
Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsBarco         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
barc_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_barco      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Barco Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
12004      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

                        select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Barco%'

Para testear:

lsBarco 'N596'

select * from rama where ram_nombre like '%transpor%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsBarco]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsBarco]

go
create procedure lsBarco (

@@barc_id      varchar(255)

)as 

declare @barc_id int
declare @ram_id_barco int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@barc_id, @barc_id out, @ram_id_barco out

if @ram_id_barco <> 0 begin

  exec sp_ArbIsRaiz @ram_id_barco, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_barco, @clienteID

  end else begin

    set @ram_id_barco = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select *

-- Listado de columnas que corresponda  

from 

-- Listado de tablas que corresponda  
  Barco

where 
      (Barco.barc_id = @barc_id or @barc_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 12004 -- tbl_id de Barco
                  and  rptarb_hojaid = Barco.barc_id
                 ) 
           )
        or 
           (@ram_id_barco = 0)
       )