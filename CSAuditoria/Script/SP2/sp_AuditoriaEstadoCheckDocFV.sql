-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoCheckDocFV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoCheckDocFV]

go

create procedure sp_AuditoriaEstadoCheckDocFV (

	@@fv_id       int,
  @@bSuccess    tinyint out,
	@@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

	declare @bError tinyint

	set @bError     = 0
	set @@bSuccess 	= 0
	set @@bErrorMsg = '@@ERROR_SP:'

	declare @doct_id      int
	declare @fv_nrodoc 		varchar(50) 
	declare @fv_numero 		varchar(50) 
	declare @est_id       int

	select 
						@doct_id 		= doct_id,
						@fv_nrodoc  = fv_nrodoc,
						@fv_numero  = convert(varchar,fv_numero),
						@est_id     = est_id

	from FacturaVenta where fv_id = @@fv_id

	if @est_id <> 7 begin

		if exists(select * from FacturaVentaItem fvi
							where round(
										(fvi_pendiente + (		IsNull(
																						(select sum(rvfv_cantidad) from RemitoFacturaVenta 
																						 where fvi_id = fvi.fvi_id),0)
																			) 
																	 + (		IsNull(
																						(select sum(pvfv_cantidad) from PedidoFacturaVenta 
																						 where fvi_id = fvi.fvi_id),0)
																			) 
										),2) <> round(fvi_cantidadaremitir,2)
	
								and fv_id = @@fv_id
							)
		begin

				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'El pendiente de los items de esta factura no coincide con la suma de sus aplicaciones' + char(10)

		end
	
		if exists(select * from FacturaVentaItem fvi
							where round(
										(fvi_pendientepklst + (		IsNull(
																						(select sum(pklstfv_cantidad) from PackingListFacturaVenta 
																						 where fvi_id = fvi.fvi_id),0)
																			) 
										),2) <> round(fvi_cantidadaremitir,2)
	
								and fv_id = @@fv_id
							)
		begin
										
				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'El pendiente de los items de esta factura no coincide con la suma de sus aplicaciones' + char(10)

		end

	end else begin

		if exists(select * from FacturaVentaItem fvi
							where fvi_pendiente <> 0	
								and fv_id = @@fv_id
							)
		begin
										
				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'Esta factura esta anulada y tiene pendiente en sus items' + char(10)

		end
	
		if exists(select * from FacturaVentaItem fvi
							where fvi_pendientepklst <> 0	
								and fv_id = @@fv_id
							)
		begin
										
				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'Esta factura esta anulada y tiene pendiente packinglist en sus items' + char(10)

		end

	end

	if 		@est_id <> 7 
		and @est_id <> 5 
		and @est_id <> 4 begin

		declare @fv_pendiente	decimal(18,6)

	  select 
						@fv_pendiente		= round(fv_pendiente,2)

		from FacturaVenta where fv_id = @@fv_id

		if @fv_pendiente = 0 begin
										
				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'La factura no tiene vencimientos pendientes y su estado no es finalizado, o anulado, o pendiente de firma' + char(10)

		end

	end

	-- No hubo errores asi que todo bien
	--
	if @bError = 0 set @@bSuccess = 1

end
GO