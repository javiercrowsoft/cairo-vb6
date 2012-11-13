if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_chequeRechazoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_chequeRechazoSave]

go

/*

sp_chequeRechazoSave 101

*/
create procedure sp_chequeRechazoSave (
		@@cheq_id						int,
		@@cheq_rechazado		tinyint,
		@@cheq_fechaRechazo	datetime,
		@@fc_id_nd1					int,
		@@fc_id_nd2					int,
		@@fv_id_nd					int,
		@@cheq_fc_imp_1			decimal(18,6),
		@@cheq_fc_imp_2			decimal(18,6),
		@@cheq_fv_imp				decimal(18,6),
		@@cheq_descrip			varchar(255)
)
as

begin

	set nocount on

	declare @MsgError  varchar(5000) set @MsgError = ''
	declare @bError 	 smallint

	begin transaction

	if @@cheq_rechazado = 0 begin
		set @@cheq_fechaRechazo 	= '19000101'
		set @@fc_id_nd1 					= null
		set @@fc_id_nd2 					= null
		set @@fv_id_nd 						= null
		set @@cheq_fc_imp_1 			= 0
		set @@cheq_fc_imp_2 			= 0
		set @@cheq_fv_imp   			= 0

	end else begin

		if @@fc_id_nd1 = 0 set @@fc_id_nd1	= null
		if @@fc_id_nd2 = 0 set @@fc_id_nd2 	= null
		if @@fv_id_nd  = 0 set @@fv_id_nd 	= null

	end

	update cheque

		set
			cheq_rechazado			= @@cheq_rechazado,
			cheq_fechaRechazo 	= @@cheq_fechaRechazo,
			fc_id_nd1 					= @@fc_id_nd1,
			fc_id_nd2 					= @@fc_id_nd2,
			fv_id_nd 						= @@fv_id_nd,
			cheq_fc_importe1	  = @@cheq_fc_imp_1,
			cheq_fc_importe2	  = @@cheq_fc_imp_2,
			cheq_fv_importe			= @@cheq_fv_imp,
			cheq_descrip 				= @@cheq_descrip

	where cheq_id = @@cheq_id

	-- Si fue depositado modifico el 
	-- asiento del deposito bancario

	declare @dbco_id int
	select @dbco_id = dbcoi.dbco_id 
	from DepositoBancoItem dbcoi 
						inner join DepositoBanco dbco 
							on dbcoi.dbco_id = dbco.dbco_id
	where cheq_id = @@cheq_id 
		and dbco.est_id <> 7 /* Anulado */

	if @dbco_id is not null
	begin

		exec sp_DocDepositoBancoAsientoSave @dbco_id,0,@bError out, @MsgError out
	  if @bError <> 0 goto ControlError

	end

	commit transaction

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar el deposito bancario. sp_DocDepositoBancoSave. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end