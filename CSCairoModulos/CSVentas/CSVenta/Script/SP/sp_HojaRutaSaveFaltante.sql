if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_HojaRutaSaveFaltante]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_HojaRutaSaveFaltante]

go

create procedure sp_HojaRutaSaveFaltante (
	@@emp_id		int,
	@@us_id 		int,
	@@hr_id 		int,
	@@sobrante 	decimal(18,6),
	@@faltante 	decimal(18,6)
)
as

begin

	set nocount on

	if @@faltante >= 0 update HojaRuta set hr_faltante = @@faltante where hr_id = @@hr_id
	if @@sobrante >= 0 update HojaRuta set hr_sobrante = @@sobrante where hr_id = @@hr_id

	if not exists(select * from HojaRuta where hr_id = @@hr_id)
	begin

		select 0 as result, 'Debe guardar la hoja de ruta antes de poder generar los movimientos por sobrantes o faltantes de cobranzas.' as info
		return
	end

	declare @fv_id_faltante int
	declare @mf_id_sobrante int
	declare @mf_nrodoc      varchar(50)
	declare @fv_nrodoc      varchar(50)

	declare @prs_id int
	declare @cli_id int

	select 	@prs_id 					= prs_id,
					@fv_id_faltante   = fv_id_faltante,
					@mf_id_sobrante 	= mf_id_sobrante

	from HojaRuta 

	where hr_id = @@hr_id

	if @@faltante <> 0 begin

		if @prs_id is null 
		begin
			select 0 as result, 'Debe indicar una persona en la hoja de ruta para poder generar los movimientos por sobrantes o faltantes de cobranzas.' as info
			return
		end

		select @cli_id = cli_id from Persona where prs_id = @prs_id

		if @cli_id is null 
		begin
			select 0 as result, 'Debe asociar un cliente a la persona indicada en la hoja de ruta para poder generar la factura por faltantes de cobranzas.' as info
			return
		end

	end

	select @fv_nrodoc = fv_nrodoc from facturaventa where fv_id = @fv_id_faltante

	-- Si no hay faltante pero la hoja de ruta tiene
	-- asociada una factura tenemos que borrarla
	--
	if @@faltante = 0 and @fv_id_faltante <> 0 begin
	
		begin tran

		update HojaRuta set fv_id_faltante = null where hr_id = @@hr_id

		exec sp_DocFacturaVentaDelete @fv_id_faltante, @@emp_id, @@us_id
		if @@error <> 0 goto ControlError

		set @fv_id_faltante = null

		commit tran
		
	end

	select @mf_nrodoc = mf_nrodoc from movimientofondo where mf_id = @mf_id_sobrante

	if @@sobrante = 0 and @mf_id_sobrante <> 0 begin

		begin tran

		update HojaRuta set mf_id_sobrante = null where hr_id = @@hr_id

		exec sp_DocMovimientoFondoDelete @mf_id_sobrante, @@emp_id, @@us_id
		if @@error <> 0 goto ControlError

		set @mf_id_sobrante = null

		commit tran

	end

	if @@faltante < 0 
	begin

		select 0 as result, 'El monto faltante de la rendicion no puede ser negativo.' as info
		return

	end

	if @@sobrante < 0 
	begin

		select 0 as result, 'El monto sobrante de la rendicion no puede ser negativo.' as info
		return

	end

	if @@sobrante <> 0 and @@faltante <> 0
	begin

		select 0 as result, 'No puede indicar un monto sobrante y un monto faltante. Uno de los dos debe ser cero.' as info
		return

	end

	declare @bsuccess tinyint

	if @@faltante <> 0 begin

		exec sp_HojaRutaSaveFaltanteAux @@hr_id, 
																		@fv_id_faltante out, 
																		@fv_nrodoc out,
																		@@faltante, 
																		@@emp_id, 
																		@@us_id, 
																		@cli_id,
																		@bsuccess out
		if @@error <> 0 goto ControlError

	end

	if @@sobrante <> 0 begin

		exec sp_HojaRutaSaveSobranteAux @@hr_id, 
																		@mf_id_sobrante out, 
																		@mf_nrodoc out,
																		@@sobrante, 
																		@@emp_id, 
																		@@us_id, 
																		@cli_id,
																		@bsuccess out
		if @@error <> 0 goto ControlError

	end else set @bsuccess = 1

	if @bsuccess <> 0 

		select 	1 								as result,
						'' 								as info,
						@fv_id_faltante 	as fv_id,
						@fv_nrodoc 				as fv_nrodoc,
						@mf_id_sobrante 	as mf_id,
						@mf_nrodoc 				as mf_nrodoc

	return
ControlError:

	if @@trancount > 0 rollback transaction	

	raiserror ('Ha ocurrido un error al generar los movimientos de faltante y sobrante de la hoja de ruta. sp_HojaRutaSaveFaltante.', 16, 1)
	
end

go