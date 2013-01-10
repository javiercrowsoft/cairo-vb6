/*


Para testear:

lsTabla 'N646'

select * from rama where ram_nombre like 'Empaques'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsTabla]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsTabla]

go
create procedure lsTabla (

@@tbl_id      varchar(255)

)as 

declare @tbl_id int
declare @ram_id_Tabla int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@tbl_id, @tbl_id out, @ram_id_Tabla out

if @ram_id_Tabla <> 0 begin

  exec sp_ArbIsRaiz @ram_id_Tabla, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_Tabla, @clienteID

  end else begin

    set @ram_id_Tabla = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select 

Tabla.*  

from 

  
Tabla

where 
      (Tabla.tbl_id = @tbl_id or @tbl_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 42 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Tabla.tbl_id
                 ) 
           )
        or 
           (@ram_id_Tabla = 0)
       )