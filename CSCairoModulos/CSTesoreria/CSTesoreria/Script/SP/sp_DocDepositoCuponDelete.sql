if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoCuponDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoCuponDelete]

go
/*

 sp_DocDepositoCuponDelete 93

*/

create procedure sp_DocDepositoCuponDelete (
	@@dcup_id 			int,
	@@emp_id    		int,
	@@us_id					int
)
as

begin

	set nocount on

	if isnull(@@dcup_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocDepositoCuponEditableGet	@@emp_id    	,
																			@@dcup_id 		,
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

  -- Solo puedo borrar esta presentacion si ninguno de los cupons
  -- ha sido conciliado por una resolucion de cupones
  if exists(select * from TarjetaCreditoCupon t inner join DepositoCuponItem d   on t.tjcc_id = d.tjcc_id
                                                inner join ResolucionCuponItem r on t.tjcc_id = r.tjcc_id
            where dcup_id = @@dcup_id) begin

  	raiserror ('@@ERROR_SP:Existen cupones en esta presentación que ya han sido conciliados. La presentación no puede borrarce.', 16, 1)
  	return	
  end

	begin transaction

	declare @as_id int

	select @as_id = as_id from DepositoCupon where dcup_id = @@dcup_id
  update DepositoCupon set as_id = null where dcup_id = @@dcup_id
	exec sp_DocAsientoDelete @as_id, @@emp_id, @@us_id, 1 -- No check access
	if @@error <> 0 goto ControlError

  -- Devuelvo los cupones a su estado original
  --
  update TarjetaCreditoCupon set cue_id = CobranzaItem.cue_id 
  from CobranzaItem 
  where TarjetaCreditoCupon.tjcc_id = CobranzaItem.tjcc_id
    and exists(select * from DepositoCuponItem where tjcc_id = TarjetaCreditoCupon.tjcc_id and dcup_id = @@dcup_id)
	if @@error <> 0 goto ControlError
  -----------------------------------------------------------------------------------------

	delete DepositoCuponItem where dcup_id = @@dcup_id
	if @@error <> 0 goto ControlError

	delete DepositoCupon where dcup_id = @@dcup_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar la presentacion de cupones. sp_DocDepositoCuponDelete.', 16, 1)
	rollback transaction	

end