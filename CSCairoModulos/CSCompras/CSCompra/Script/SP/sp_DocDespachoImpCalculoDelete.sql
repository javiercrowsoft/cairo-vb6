
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDespachoImpCalculoDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDespachoImpCalculoDelete]

go


/*

sp_DocDespachoImpCalculoDelete 0

*/

create procedure sp_DocDespachoImpCalculoDelete (
@@dic_id int
)as 
begin

	set nocount on

	begin transaction

	delete DespachoImpCalculoItem where dic_id = @@dic_id
	if @@error <> 0 goto ControlError

	delete DespachoImpCalculoPosicionArancel where dic_id = @@dic_id
	if @@error <> 0 goto ControlError

	delete DespachoImpCalculo where dic_id = @@dic_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el calculo de coeficiente de costos del despacho de importación. sp_DocDespachoImpCalculoDelete.', 16, 1)
	rollback transaction	

end
