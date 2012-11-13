-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoCheckDocOC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoCheckDocOC]

go

create procedure sp_AuditoriaEstadoCheckDocOC (

	@@oc_id       int,
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
	declare @oc_nrodoc 		varchar(50) 
	declare @oc_numero 		varchar(50) 
	declare @est_id       int

	select 
						@doct_id 		= doct_id,
						@oc_nrodoc  = oc_nrodoc,
						@oc_numero  = convert(varchar,oc_numero),
						@est_id     = est_id

	from OrdenCompra where oc_id = @@oc_id

	if exists(select * from OrdenCompraItem oci
						where (oci_pendientefac 
																+ 	(	  IsNull(
																					(select sum(ocfc_cantidad) from OrdenFacturaCompra 
																					 where oci_id = oci.oci_id),0)
																			+	IsNull(
																				  (select sum(ocdc_cantidad)   from OrdenDevolucionCompra 
                                           where 
                                                 (oci_id_Orden       = oci.oci_id and @doct_id = 35)
                                              or (oci_id_devolucion  = oci.oci_id and @doct_id = 36)
                                          ),0)
																			+ IsNull(
																					(select sum(ocrc_cantidad) from OrdenRemitoCompra 
																					 where oci_id = oci.oci_id),0)
																		) 
									) <> oci_cantidadaremitir

							and oc_id = @@oc_id
						)
	begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El pendiente de los items de esta orden de compra no coincide con la suma de sus aplicaciones' + char(10)

	end

	if exists(select * from OrdenCompraItem oci
						where (oci_pendiente 
																+ 	(	  IsNull(
																					(select sum(pcoc_cantidad) from PedidoOrdenCompra 
																					 where oci_id = oci.oci_id),0)
																		) 
									) <> oci_cantidadaremitir

							and oc_id = @@oc_id
						)
	begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El pendiente de los items de esta orden de compra no coincide con la suma de sus aplicaciones' + char(10)

	end

	if 		@est_id <> 7 
		and @est_id <> 5 
		and @est_id <> 4 begin

		declare @oc_pendiente	decimal(18,6)

	  select 
						@oc_pendiente		= sum(oci_pendientefac)

		from OrdenCompraItem where oc_id = @@oc_id

		if @oc_pendiente = 0 begin

				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'La orden de compra no tiene items pendientes y su estado no es finalizado, o anulado, o pendiente de firma' + char(10)
	
		end

	end

	-- No hubo errores asi que todo bien
	--
	if @bError = 0 set @@bSuccess = 1

end
GO