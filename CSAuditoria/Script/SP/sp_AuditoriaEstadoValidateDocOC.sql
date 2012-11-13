-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidateDocOC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidateDocOC]

go

create procedure sp_AuditoriaEstadoValidateDocOC (

	@@oc_id       int,
	@@aud_id 			int

)
as

begin

  set nocount on

	declare @audi_id 			int
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

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de esta orden de compra no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @oc_nrodoc + ' nro.: '+ @oc_numero + ')',
																 3,
																 3,
																 @doct_id,
																 @@oc_id
																)
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

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de esta orden de compra no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @oc_nrodoc + ' nro.: '+ @oc_numero + ')',
																 3,
																 3,
																 @doct_id,
																 @@oc_id
																)
	end

	if 		@est_id <> 7 
		and @est_id <> 5 
		and @est_id <> 4 begin

		declare @oc_pendiente	decimal(18,6)

	  select 
						@oc_pendiente		= sum(oci_pendientefac)

		from OrdenCompraItem where oc_id = @@oc_id

		if @oc_pendiente = 0 begin

				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'La orden de compra no tiene items pendientes y su estado no es finalizado, o anulado, o pendiente de firma '
	                                 + '(comp.:' + @oc_nrodoc + ' nro.: '+ @oc_numero + ')',
																	 3,
																	 3,
																	 @doct_id,
																	 @@oc_id
																	)
		end

	end

ControlError:

end
GO