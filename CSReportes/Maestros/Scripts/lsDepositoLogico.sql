/*

Lo primero es guardar como NO SEAN GILI....
select * from depositologico
Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsDepositoLogico         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
depl_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_depositologico      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
DepositoLogico Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
11      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

                        select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%DepositoLogico%'

Para testear:

lsDepositoLogico 'N596'



*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsDepositoLogico]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsDepositoLogico]

go
create procedure lsDepositoLogico (

@@depl_id      varchar(255)

)as 

declare @depl_id int
declare @ram_id_depositologico int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@depl_id, @depl_id out, @ram_id_depositologico out

if @ram_id_depositologico <> 0 begin

  exec sp_ArbIsRaiz @ram_id_depositologico, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_depositologico, @clienteID

  end else begin

    set @ram_id_depositologico = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select 
    DepositoLogico.*,
    DepositoFisico.depf_nombre

-- Listado de columnas que corresponda  

from 

     DepositoLogico left join DepositoFisico on DepositoLogico.depf_id = DepositoFisico.depf_id
-- Listado de tablas que corresponda  


where 
      (DepositoLogico.depl_id = @depl_id or @depl_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11 -- tbl_id de DepositoLogico
                  and  rptarb_hojaid = DepositoLogico.depl_id
                 ) 
           )
        or 
           (@ram_id_depositologico = 0)
       )