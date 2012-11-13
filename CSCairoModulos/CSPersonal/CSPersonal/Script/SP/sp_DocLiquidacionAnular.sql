if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocLiquidacionAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocLiquidacionAnular]

go

create procedure sp_DocLiquidacionAnular (
	@@us_id       int,
	@@liq_id 			int,
  @@anular      tinyint,
  @@Select      tinyint = 0
)
as

begin

	set nocount on

	if @@liq_id = 0 return

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

	declare @est_id           int
	declare @estado_pendiente int set @estado_pendiente = 1
	declare @estado_anulado   int set @estado_anulado   = 7
	declare @as_id 						int

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
		begin transaction
  end

	if @@anular <> 0 begin

		-- Borro el asiento	
		--
		select @as_id = as_id from Liquidacion where liq_id = @@liq_id
	  update Liquidacion set as_id = null where liq_id = @@liq_id
		exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
		if @@error <> 0 goto ControlError

		-- Liquidacion
		--
		update Liquidacion set est_id = @estado_anulado
		where liq_id = @@liq_id
		set @est_id = @estado_anulado

	end else begin

		update Liquidacion set est_id = @estado_pendiente
		where liq_id = @@liq_id

    exec sp_DocLiquidacionSetEstado @@liq_id,0,@est_id out

		-- Genero nuevamente el asiento
		declare @bError 	 smallint
		declare @MsgError  varchar(5000) set @MsgError = ''

		exec sp_DocLiquidacionAsientoSave @@liq_id,0,@bError out, @MsgError out
	  if @bError <> 0 goto ControlError

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @bSuccess tinyint

	exec sp_AuditoriaAnularCheckDocLIQ	@@liq_id,
																			@bSuccess	out,
																			@MsgError out

	-- Si el documento no es valido
	if IsNull(@bSuccess,0) = 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	update Liquidacion set modificado = getdate(), modifico = @@us_id where liq_id = @@liq_id

	if @@anular <> 0 exec sp_HistoriaUpdate 35012, @@liq_id, @@us_id, 7
	else             exec sp_HistoriaUpdate 35012, @@liq_id, @@us_id, 8

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	if @bInternalTransaction <> 0 
		commit transaction
  
	if @@Select <> 0 begin
		select est_id, est_nombre from Estado where est_id = @est_id
	end

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el estado dla liquidación de haberes. sp_DocLiquidacionAnular. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @bInternalTransaction <> 0 
		rollback transaction	

	return

end