if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoBancoDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoBancoDelete]

go
/*

 sp_DocDepositoBancoDelete 93

*/

create procedure sp_DocDepositoBancoDelete (
	@@dbco_id 			int,
	@@emp_id    		int,
	@@us_id					int
)
as

begin

	set nocount on

	if isnull(@@dbco_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocDepositoBancoEditableGet	@@emp_id    	,
																			@@dbco_id			,
																		  @@us_id     	,
																			@bEditable 		out,
																			@editMsg   		out,
																		  0							, --@@ShowMsg
																			0  						,	--@@bNoAnulado
																			1							  --@@bDelete

	if @bEditable = 0 begin

		set @editMsg = '@@ERROR_SP:' + @editMsg
		raiserror (@editMsg, 16, 1)

		return
	end

	begin transaction

	declare @as_id int

	select @as_id = as_id from DepositoBanco where dbco_id = @@dbco_id
  update DepositoBanco set as_id = null where dbco_id = @@dbco_id
	exec sp_DocAsientoDelete @as_id, @@emp_id, @@us_id, 1 -- No check access
	if @@error <> 0 goto ControlError

	-----------------------------------------------------------------------------------------------------------------

	-- Hay dos situaciones a resolver con los cheques
	--
	-- 1- Devolver a la cuenta mencionada en el ultimo 
	--    movimiento de fondos que menciono al cheque
	--
	-- 2- Devolver a documentos en cartera los cheques
	--    ingresados por una cobranza

	-- Devuelvo a documentos en cartera los cheques de tercero
	update Cheque set cue_id = mfi.cue_id_debe
	from MovimientoFondoItem mfi
	where Cheque.cheq_id = mfi.cheq_id
		and Cheque.mf_id   = mfi.mf_id
		and exists(select cheq_id 
							 from DepositoBancoItem dbcoi
							 where cheq_id = Cheque.cheq_id 
								 and dbcoi.dbco_id = @@dbco_id
							)
	if @@error <> 0 goto ControlError

	-- Devuelvo a documentos en cartera los cheques de tercero
	update Cheque set cue_id = cobzi.cue_id
	from CobranzaItem cobzi
	where cobzi.cheq_id = Cheque.cheq_id 
		and Cheque.mf_id  is null
		and exists(select cheq_id 
							 from DepositoBancoItem dbcoi
							 where cheq_id = Cheque.cheq_id 
								 and dbcoi.dbco_id = @@dbco_id
							)
	if @@error <> 0 goto ControlError
	-----------------------------------------------------------------------------------------------------------------

	-- Por ultimo borro los cheques que se crearon en este deposito
	--
	update DepositoBancoItem set cheq_id = null where cheq_id in (select cheq_id from cheque where dbco_id = @@dbco_id)
	if @@error <> 0 goto ControlError

	delete Cheque where dbco_id = @@dbco_id
	if @@error <> 0 goto ControlError
	-----------------------------------------------------------------------------------------------------------------


	delete DepositoBancoItem where dbco_id = @@dbco_id
	if @@error <> 0 goto ControlError

	delete DepositoBanco where dbco_id = @@dbco_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el deposito bancario. sp_DocDepositoBancoDelete.', 16, 1)
	rollback transaction	

end