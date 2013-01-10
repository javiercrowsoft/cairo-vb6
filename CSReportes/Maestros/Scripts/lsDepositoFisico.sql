/*
Para testear:

lsDepositoFisico 'N503'

select * from rama where ram_nombre like 'deposit%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsDepositoFisico]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsDepositoFisico]

go
create procedure lsDepositoFisico (

@@depf_id      varchar(255)

)as 

declare @depf_id int
declare @ram_id_depositoFisico int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@depf_id, @depf_id out, @ram_id_depositoFisico out

if @ram_id_depositoFisico <> 0 begin

  exec sp_ArbIsRaiz @ram_id_depositoFisico, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_depositoFisico, @clienteID

  end else begin

    set @ram_id_depositoFisico = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select 

  DepositoFisico.*

from 

  DepositoFisico

where 
      (DepositoFisico.depf_id = @depf_id or @depf_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 10 -- tbl_id de Proyecto
                  and  rptarb_hojaid = DepositoFisico.depf_id
                 ) 
           )
        or 
           (@ram_id_depositoFisico = 0)
       )