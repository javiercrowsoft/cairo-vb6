/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_MovimientoCajaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_MovimientoCajaDelete]


/*

 exec sp_MovimientoCajaDelete 15

*/

go
create procedure sp_MovimientoCajaDelete (
  @@mcj_id    int,
	@@emp_id		int,
	@@us_id     int

)as 

begin

	set nocount on

	declare @cj_id int
	declare @mcj_nrodoc varchar(255)
	declare @last_mcj_nrodoc varchar(255)
	declare @emp_id int
	declare @editMsg varchar(255)


	select @cj_id = mcj.cj_id, @mcj_nrodoc = mcj_nrodoc, @emp_id = cj.emp_id 
	from MovimientoCaja mcj inner join Caja cj on mcj.cj_id = cj.cj_id
	where mcj_id = @@mcj_id

	if @emp_id <> @@emp_id begin

		set @editMsg = '@@ERROR_SP:No se puede eliminar este movimiento por que pertenece a otra empresa.'
		raiserror (@editMsg, 16, 1)
		return

	end

	select @last_mcj_nrodoc = max(convert(int,mcj_nrodoc)) 
	from MovimientoCaja 
	where cj_id = @cj_id
		and isnumeric(mcj_nrodoc)<>0

	if @last_mcj_nrodoc <> convert(int,@mcj_nrodoc) begin

		set @editMsg = '@@ERROR_SP:No se puede eliminar este movimiento por que existen movimientos posteriores. Solo se puede eliminar el ultimo movimiento de una caja.'
		raiserror (@editMsg, 16, 1)
		return

	end else

		begin transaction

		declare @as_id int
	
		select @as_id = as_id from MovimientoCaja where mcj_id = @@mcj_id
	  update MovimientoCaja set as_id = null where mcj_id = @@mcj_id
		exec sp_DocAsientoDelete @as_id, @@emp_id, @@us_id, 1 -- No check access
		if @@error <> 0 goto ControlError

		delete MovimientoCajaItem where mcj_id = @@mcj_id
		if @@error <> 0 goto ControlError

		delete MovimientoCajaMovimiento where mcj_id = @@mcj_id
		if @@error <> 0 goto ControlError

		delete MovimientoCaja where mcj_id = @@mcj_id
		if @@error <> 0 goto ControlError

		commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el movimiento de apertura o cierre de caja. sp_MovimientoCajaDelete.', 16, 1)
	rollback transaction	
	
end
go