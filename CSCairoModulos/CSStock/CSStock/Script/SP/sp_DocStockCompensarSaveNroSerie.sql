if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockCompensarSaveNroSerie]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockCompensarSaveNroSerie]

/*
 select * from Compensar
 sp_DocStockCompensarSaveNroSerie 26

*/

go
create procedure sp_DocStockCompensarSaveNroSerie (
	@@compi_id        int,
	@@st_id 					int,
	@@sti_orden				int out,
	@@compi_cantidad  decimal(18,6),
  @@compi_descrip   varchar(255),
  @@pr_id           int,
  @@depl_id_origen  int,
  @@depl_id_destino int,
	@@stik_id         int,

	@@bSuccess 				tinyint out,
  @@MsgError        varchar(5000)= '' out
)
as
begin

set nocount on

	declare @prns_id int

	select 
				@prns_id = prns_id
	from 
				#sp_DocStockCompensar 
	where 
						id = @@compi_id 

	exec sp_DocStockCompensarStockItemSave 	
																					@@compi_id,
																					@@st_id,
																					@@sti_orden out,
																					1,
																				  @@compi_descrip,
																				  @@pr_id,
																				  @@depl_id_origen,
																				  @@depl_id_destino,
																					@prns_id,
																				  @@stik_id,
			
																					@@bSuccess out,
																					@@MsgError out 

	if IsNull(@@bSuccess,0) = 0 goto Validate

	set @@bSuccess = 1
	return

ControlError:
	set @@MsgError = 'Ha ocurrido un error al grabar el item de la transferencia de stock. sp_DocStockCompensarSaveNroSerie.'

Validate:

	set @@bSuccess = 0

end
go