if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_LiquidacionItemCodigoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LiquidacionItemCodigoSave]

go

create procedure sp_LiquidacionItemCodigoSave (
	@@liqcTMP_id 			int,
	@@liq_id          int
)
as

begin

	set nocount on

	declare @MsgError  varchar(5000) set @MsgError = ''

-- Talonario
  declare @ta_id      		int

	select @ta_id = ta_id_haberes
	from Liquidacion liq inner join Documento doc on liq.doc_id = doc.doc_id
	where liq_id = @@liq_id

	if IsNull(@ta_id,0) = 0 begin
		select col1 = 'ERROR', col2 = 'El documento no tiene definido su talonario de recibos de haberes.'
		return
	end
--

	begin transaction

	delete LiquidacionItemCodigo 
	where liq_id = @@liq_id 
		and liqi_id in (select liqi_id 
									from LiquidacionItemCodigoTMP 
									where liqcTMP_id = @@liqcTMP_id)
	if @@error <> 0 goto ControlError

	insert into LiquidacionItemCodigo (
																			liq_id,
																			liqi_id,
																			liqfi_id,
																			liqic_importe,
																			liqic_unidades,
																			liqic_descrip
																		)

	select 															@@liq_id,
																			t.liqi_id,
																			t.liqfi_id,
																			t.liqic_importe,
																			t.liqic_unidades,
																			case when liqfi_nombrerecibo = '' then liqfi_nombrerecibo else liqfi_nombre end

	from LiquidacionItemCodigoTMP t inner join LiquidacionFormulaItem liqfi on t.liqfi_id = liqfi.liqfi_id
	where liqcTMP_id = @@liqcTMP_id
	if @@error <> 0 goto ControlError

	update LiquidacionItem 
			set liqi_importe = isnull(( select sum(liqic_importe) 
													from LiquidacionItemCodigo 
													where liqi_id = LiquidacionItem.liqi_id
												),0)
	where liq_id = @@liq_id
	if @@error <> 0 goto ControlError

	declare @neto decimal(18,6)

	select @neto = sum(liqi_importe) from LiquidacionItem where liq_id = @@liq_id

	update Liquidacion
			set liq_neto = @neto, liq_total = @neto
	where liq_id = @@liq_id
	if @@error <> 0 goto ControlError

	--////////////////////////////////////////////////////////////////////////////////
	-- Recibos

	declare @liqi_id 			int
	declare @liqi_nrodoc 	varchar(50)
	declare @ta_nrodoc 		varchar(100)

	declare c_items insensitive cursor for select liqi_id from LiquidacionItem where liqi_nrodoc = '' and liq_id = @@liq_id

	open c_items

	fetch next from c_items into @liqi_id
	while @@fetch_status = 0
	begin

			set @liqi_nrodoc = ''
	
			exec sp_talonarioGetNextNumber @ta_id, @ta_nrodoc out
			if @@error <> 0 goto ControlError

			-- Con esto evitamos que dos tomen el mismo número
			--
			exec sp_TalonarioSet @ta_id, @ta_nrodoc
			if @@error <> 0 goto ControlError

			set @liqi_nrodoc = @ta_nrodoc
	
			update LiquidacionItem set liqi_nrodoc = @liqi_nrodoc where liqi_id = @liqi_id
			if @@error <> 0 goto ControlError

		fetch next from c_items into @liqi_id
	end

	close c_items
	deallocate c_items
	--////////////////////////////////////////////////////////////////////////////////

	commit transaction

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar la liquidación de haberes. sp_LiquidacionItemCodigoSave. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

	return

end

go