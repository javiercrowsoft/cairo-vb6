
/*---------------------------------------------------------------------
Nombre: Balance
---------------------------------------------------------------------*/

/*
exec DC_CSC_CON_9995 1,2802

1,
'20000101',
'20100101',

'0',
'0',
'0',
'1'


*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_9995]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_9995]

go
create procedure DC_CSC_CON_9995 (

  @@us_id    				int,
	@@as_numero				int

)as 

begin

set nocount on

	declare @as_id int

	select @as_id = as_id from Asiento where as_numero = @@as_numero

	if @as_id is null begin

		select 1 as aux_id, 'No se encontro un asiento con el numero [' + convert(varchar,@@as_numero) + ']' as Info, '' as dummy_col

		return
	end

	begin tran

	update Liquidacion set as_id = null where as_id = @as_id
	if @@error <> 0 goto ControlError

	update MovimientoCajaMovimiento set as_id = null where as_id = @as_id
	if @@error <> 0 goto ControlError

	update FacturaCompra set as_id = null where as_id = @as_id
	if @@error <> 0 goto ControlError

	update MovimientoFondo set as_id = null where as_id = @as_id
	if @@error <> 0 goto ControlError

	update MovimientoCaja set as_id = null where as_id = @as_id
	if @@error <> 0 goto ControlError

	update FacturaVenta set as_id = null where as_id = @as_id
	if @@error <> 0 goto ControlError

	update DepositoCupon set as_id = null where as_id = @as_id
	if @@error <> 0 goto ControlError

	update OrdenPago set as_id = null where as_id = @as_id
	if @@error <> 0 goto ControlError

	update Cobranza set as_id = null where as_id = @as_id
	if @@error <> 0 goto ControlError

	update DepositoBanco set as_id = null where as_id = @as_id
	if @@error <> 0 goto ControlError

	update ResolucionCupon set as_id = null where as_id = @as_id
	if @@error <> 0 goto ControlError

	delete AsientoItem where as_id = @as_id
	if @@error <> 0 goto ControlError

	delete Asiento where as_id = @as_id
	if @@error <> 0 goto ControlError

	commit transaction

	select 1 as aux_id, 'El asiento se borro con éxito.' as Info,  '' as dummy_col

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el asiento. DC_CSC_CON_9995.', 16, 1)
	rollback transaction	

end
go


