if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaSetPendiente]

/*

	exec	sp_DocCobranzaSetPendiente 28

*/

go
create procedure sp_DocCobranzaSetPendiente (
	@@cobz_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @aplicado decimal(18,6)

	begin transaction

	select @aplicado = sum(fvcobz_importe) from FacturaVentaCobranza where cobz_id = @@cobz_id
	set @aplicado = round(IsNull(@aplicado,0),2)

	update Cobranza set cobz_pendiente = round(cobz_total - @aplicado,2) where cobz_id = @@cobz_id
	if @@error <> 0 goto ControlError

	commit transaction

	set @@bSuccess = 1

	return
ControlError:

	raiserror ('Ha ocurrido un error al actualizar el pendiente de la cobranza. sp_DocCobranzaSetPendiente.', 16, 1)
	rollback transaction	

end 

go