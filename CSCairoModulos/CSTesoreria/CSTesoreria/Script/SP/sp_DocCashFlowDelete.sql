if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCashFlowDelete ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCashFlowDelete ]

go

/*
select * from cuenta where cue_nombre like '%doc%'
sp_DocCashFlowDelete 496,'19000101','21000101'

sp_DocCashFlowDelete null,'20060101 00:00:00','20061029 00:00:00'

*/
create procedure sp_DocCashFlowDelete  (
	@@cf_id 		int,
	@@emp_id		int,
	@@us_id			int
)
as

begin

	set nocount on

	begin transaction

	delete CashFlowItem where cf_id = @@cf_id
	if @@error <> 0 goto ControlError

	delete CashFlowParam where cf_id = @@cf_id
	if @@error <> 0 goto ControlError

	delete CashFlow where cf_id = @@cf_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el flujo de fondos. sp_DocCashFlowDelete.', 16, 1)
	rollback transaction	

end				