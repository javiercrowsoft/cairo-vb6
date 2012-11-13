if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRecuentoStockStockItemSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRecuentoStockStockItemSave]

/*
 select * from RecuentoStock
 sp_DocRecuentoStockStockItemSave 26

*/

go
create procedure sp_DocRecuentoStockStockItemSave (
	@@sti_grupo				int,
	@@st_id 					int,
	@@sti_orden				int out,
	@@rsi_ajuste      decimal(18,6),
  @@rsi_descrip     varchar(255),
  @@pr_id           int,
  @@depl_id_origen  int,
  @@depl_id_destino int,
	@@prns_id         int,
  @@stik_id         int,
	@@stl_id          int,

	@@bSuccess 				tinyint out,
  @@MsgError        varchar(5000)= '' out
)
as
begin

	declare	@sti_id					int

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
                          pr_id_kit,
													stl_id
												)
									values(
													@@st_id, 
													@sti_id, 
													@@sti_orden,           
													0, 
													@@rsi_ajuste, 
													@@rsi_descrip, 
													@@sti_grupo,
													@@pr_id, 
													@@depl_id_origen,
													@@prns_id,
													@@stik_id,
                          @pr_id_kit,
													@@stl_id
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
													pr_id_kit,
													stl_id
												)
									values(
													@@st_id, 
													@sti_id, 
													@@sti_orden, 
													@@rsi_ajuste,          
													0, 
													@@rsi_descrip, 
													@@sti_grupo,
													@@pr_id, 
													@@depl_id_destino,
													@@prns_id,
													@@stik_id,
													@pr_id_kit,
													@@stl_id
												)
  if @@error <> 0 goto ControlError

	set @@sti_orden = @@sti_orden + 1

	set @@bSuccess = 1
	return

ControlError:

	set @@bSuccess = 0
	set @@MsgError = 'Ha ocurrido un error al grabar el item de stock del recuento de stock. sp_DocRecuentoStockStockItemSave.'
end
go