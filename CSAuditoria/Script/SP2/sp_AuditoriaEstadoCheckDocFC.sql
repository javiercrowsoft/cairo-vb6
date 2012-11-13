-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoCheckDocFC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoCheckDocFC]

go

create procedure sp_AuditoriaEstadoCheckDocFC (

	@@fc_id       int,
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
	declare @fc_nrodoc 		varchar(50) 
	declare @fc_numero 		varchar(50) 
	declare @est_id       int

	select 
						@doct_id 		= doct_id,
						@fc_nrodoc  = fc_nrodoc,
						@fc_numero  = convert(varchar,fc_numero),
						@est_id     = est_id

	from FacturaCompra where fc_id = @@fc_id

	if exists(select * from FacturaCompraItem fci
						where (fci_pendiente + (		IsNull(
																					(select sum(rcfc_cantidad) from RemitoFacturaCompra 
																					 where fci_id = fci.fci_id),0)
																		) 
																 + (		IsNull(
																					(select sum(ocfc_cantidad) from OrdenFacturaCompra 
																					 where fci_id = fci.fci_id),0)
																		) 
									) <> fci_cantidadaremitir

							and fc_id = @@fc_id
						)
	begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El pendiente de los items de esta factura no coincide con la suma de sus aplicaciones' + char(10)

	end

	if 		@est_id <> 7 
		and @est_id <> 5 
		and @est_id <> 4 begin

		declare @fc_pendiente	decimal(18,6)

	  select 
						@fc_pendiente		= fc_pendiente

		from FacturaCompra where fc_id = @@fc_id

		if @fc_pendiente = 0 begin

				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'La factura no tiene vencimientos pendientes y su estado no es finalizado, o anulado, o pendiente de firma' + char(10)

		end

	end

	-- No hubo errores asi que todo bien
	--
	if @bError = 0 set @@bSuccess = 1

end
GO