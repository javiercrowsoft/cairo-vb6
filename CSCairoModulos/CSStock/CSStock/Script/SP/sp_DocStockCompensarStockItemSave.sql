if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockCompensarStockItemSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockCompensarStockItemSave]

/*
 select * from Compensar
 sp_DocStockCompensarStockItemSave 26

*/

go
create procedure sp_DocStockCompensarStockItemSave (
  @@sti_grupo        int,
  @@st_id           int,
  @@sti_orden        int out,
  @@compi_cantidad  decimal(18,6),
  @@compi_descrip   varchar(255),
  @@pr_id           int,
  @@depl_id_origen  int,
  @@depl_id_destino int,
  @@prns_id         int,
  @@stik_id         int,

  @@bSuccess         tinyint out,
  @@MsgError        varchar(5000)= '' out
)
as
begin

set nocount on

  declare  @sti_id          int

  exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0

  declare @pr_id_kit int
  if @@stik_id is not null begin
    select @pr_id_kit = pr_id from StockItemKit where stik_id = @@stik_id
  end

  insert into StockItem (
                          st_id,  
                          sti_id,  
                          sti_orden,  
                          sti_ingreso, 
                          sti_salida,  
                          sti_descrip,  
                          sti_grupo,
                          pr_id,  
                          depl_id,
                          prns_id,
                          stik_id,
                          pr_id_kit
                        )
                  values(
                          @@st_id, 
                          @sti_id, 
                          @@sti_orden,           
                          0, 
                          @@compi_cantidad, 
                          @@compi_descrip, 
                          @@sti_grupo,
                          @@pr_id, 
                          @@depl_id_origen,
                          @@prns_id,
                          @@stik_id,
                          @pr_id_kit
                        )
  if @@error <> 0 goto ControlError

  set @@sti_orden = @@sti_orden + 1

  exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0

  insert into StockItem (
                          st_id,  
                          sti_id,  
                          sti_orden,  
                          sti_ingreso, 
                          sti_salida, 
                          sti_descrip,  
                          sti_grupo,
                          pr_id,  
                          depl_id,
                          prns_id,
                          stik_id,
                          pr_id_kit
                        )
                  values(
                          @@st_id, 
                          @sti_id, 
                          @@sti_orden, 
                          @@compi_cantidad,          
                          0, 
                          @@compi_descrip, 
                          @@sti_grupo,
                          @@pr_id, 
                          @@depl_id_destino,
                          @@prns_id,
                          @@stik_id,
                          @pr_id_kit
                        )
  if @@error <> 0 goto ControlError

  set @@sti_orden = @@sti_orden + 1

  set @@bSuccess = 1
  return

ControlError:

  set @@bSuccess = 0
  set @@MsgError = 'Ha ocurrido un error al grabar el item de la transferencia de stock. sp_DocStockCompensarStockItemSave.'
end
go