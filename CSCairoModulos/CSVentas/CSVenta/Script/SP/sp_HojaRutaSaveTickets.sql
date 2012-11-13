if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_HojaRutaSaveTickets]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_HojaRutaSaveTickets]

go

create procedure sp_HojaRutaSaveTickets (
	@@emp_id		int,
	@@us_id 		int,
	@@hr_id 		int,
	@@comision 	decimal(18,6)
)
as

begin

	set nocount on

	if @@comision >= 0 update HojaRuta set hr_porctickets = @@comision where hr_id = @@hr_id

	if not exists(select * from HojaRuta where hr_id = @@hr_id)
	begin

		select 0 as result, 'Debe guardar la hoja de ruta antes de poder generar los movimientos por comision sobre tickets.' as info
		return
	end

	declare @mf_id_tickets  int
	declare @mf_nrodoc      varchar(50)

	declare @prs_id int
	declare @cli_id int

	select 	@prs_id 					= prs_id,
					@mf_id_tickets    = mf_id_tickets

	from HojaRuta 

	where hr_id = @@hr_id

	if @@comision <> 0 begin

		select @cli_id = cli_id from Persona where prs_id = @prs_id

	end

	select @mf_nrodoc = mf_nrodoc from movimientofondo where mf_id = @mf_id_tickets

	if @@comision = 0 and @mf_id_tickets <> 0 begin

		begin tran

		update HojaRuta set mf_id_tickets = null where hr_id = @@hr_id

		exec sp_DocMovimientoFondoDelete @mf_id_tickets, @@emp_id, @@us_id
		if @@error <> 0 goto ControlError

		commit tran

	end

	if @@comision < 0 
	begin

		select 0 as result, 'El porcentaje por comision sobre tickets de la rendicion no puede ser negativo.' as info
		return

	end

	declare @bsuccess tinyint
	declare @tickets  decimal(18,6)

	select @tickets = sum(hri_tickets) from HojaRutaItem where hr_id = @@hr_id

	set @@comision = @@comision * isnull(@tickets,0) /100

	if @@comision <> 0 begin

		exec sp_HojaRutaSaveTicketsAux  @@hr_id, 
																		@mf_id_tickets out, 
																		@mf_nrodoc out,
																		@@comision, 
																		@@emp_id, 
																		@@us_id, 
																		@cli_id,
																		@bsuccess out
		if @@error <> 0 goto ControlError

	end else set @bsuccess = 1

	if @bsuccess <> 0 

		select 1 as result, '' as info, @mf_id_tickets as mf_id, @mf_nrodoc as mf_nrodoc

	return
ControlError:

	if @@trancount > 0 rollback transaction	

	raiserror ('Ha ocurrido un error al generar el movimiento de comision sobre tickets de la hoja de ruta. sp_HojaRutaSaveTickets.', 16, 1)
	
end

go