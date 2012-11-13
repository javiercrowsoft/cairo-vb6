-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoCheckDocRC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoCheckDocRC]

go

create procedure sp_AuditoriaEstadoCheckDocRC (

	@@rc_id       int,
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
	declare @rc_nrodoc 		varchar(50) 
	declare @rc_numero 		varchar(50) 
	declare @est_id       int

	select 
						@doct_id 		= doct_id,
						@rc_nrodoc  = rc_nrodoc,
						@rc_numero  = convert(varchar,rc_numero),
						@est_id     = est_id

	from RemitoCompra where rc_id = @@rc_id

	if exists(select * from RemitoCompraItem rci
						where (rci_pendientefac + (	IsNull(
																					(select sum(rcfc_cantidad) from RemitoFacturaCompra 
																					 where rci_id = rci.rci_id),0)
																			+	IsNull(
																				  (select sum(rcdc_cantidad)   from RemitoDevolucionCompra 
                                           where 
                                                 (rci_id_remito      = rci.rci_id and @doct_id = 4)
                                              or (rci_id_devolucion  = rci.rci_id and @doct_id = 25)
                                          ),0)
																		) 
									) <> rci_cantidadaremitir

							and rc_id = @@rc_id
						)
	begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El pendiente de los items de este remito no coincide con la suma de sus aplicaciones' + char(10)

	end

	if exists(select * from RemitoCompraItem rci
						where (rci_pendiente + (		IsNull(
																					(select sum(ocrc_cantidad) from OrdenRemitoCompra 
																					 where rci_id = rci.rci_id),0)
																		) 
									) <> rci_cantidad

							and rc_id = @@rc_id
						)
	begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El pendiente de los items de este remito no coincide con la suma de sus aplicaciones' + char(10)

	end

	if 		@est_id <> 7 
		and @est_id <> 5 
		and @est_id <> 4 begin

		declare @rc_pendiente	decimal(18,6)

	  select 
						@rc_pendiente		= sum(rci_pendientefac)

		from RemitoCompraItem where rc_id = @@rc_id

		if @rc_pendiente = 0 begin

				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'El remito no tiene items pendientes y su estado no es finalizado, o anulado, o pendiente de firma' + char(10)

		end

	end

	-- No hubo errores asi que todo bien
	--
	if @bError = 0 set @@bSuccess = 1

end
GO